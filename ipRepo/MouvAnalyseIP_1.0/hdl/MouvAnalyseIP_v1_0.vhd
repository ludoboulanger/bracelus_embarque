library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MouvAnalyseIP_v1_0 is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface MouvAnalyseIP
		C_MouvAnalyseIP_DATA_WIDTH	: integer	:= 32;
		C_MouvAnalyseIP_ADDR_WIDTH	: integer	:= 4
	);
	port (
		-- Users to add ports here
		i_bclk : in std_logic;
        i_data_echantillon : in std_logic_vector(11 downto 0);
        i_adc_strobe : in std_logic;
        o_data_out0 : out std_logic_vector(1 downto 0);
        o_data_out1 : out std_logic_vector(31 downto 0);
		-- User ports ends
		-- Do not modify the ports beyond this line


		-- Ports of Axi Slave Bus Interface MouvAnalyseIP
		mouvanalyseip_aclk	: in std_logic;
		mouvanalyseip_aresetn	: in std_logic;
		mouvanalyseip_awaddr	: in std_logic_vector(C_MouvAnalyseIP_ADDR_WIDTH-1 downto 0);
		mouvanalyseip_awprot	: in std_logic_vector(2 downto 0);
		mouvanalyseip_awvalid	: in std_logic;
		mouvanalyseip_awready	: out std_logic;
		mouvanalyseip_wdata	: in std_logic_vector(C_MouvAnalyseIP_DATA_WIDTH-1 downto 0);
		mouvanalyseip_wstrb	: in std_logic_vector((C_MouvAnalyseIP_DATA_WIDTH/8)-1 downto 0);
		mouvanalyseip_wvalid	: in std_logic;
		mouvanalyseip_wready	: out std_logic;
		mouvanalyseip_bresp	: out std_logic_vector(1 downto 0);
		mouvanalyseip_bvalid	: out std_logic;
		mouvanalyseip_bready	: in std_logic;
		mouvanalyseip_araddr	: in std_logic_vector(C_MouvAnalyseIP_ADDR_WIDTH-1 downto 0);
		mouvanalyseip_arprot	: in std_logic_vector(2 downto 0);
		mouvanalyseip_arvalid	: in std_logic;
		mouvanalyseip_arready	: out std_logic;
		mouvanalyseip_rdata	: out std_logic_vector(C_MouvAnalyseIP_DATA_WIDTH-1 downto 0);
		mouvanalyseip_rresp	: out std_logic_vector(1 downto 0);
		mouvanalyseip_rvalid	: out std_logic;
		mouvanalyseip_rready	: in std_logic
	);
end MouvAnalyseIP_v1_0;

architecture arch_imp of MouvAnalyseIP_v1_0 is

	-- component declaration
	component MouvAnalyseIP_v1_0_MouvAnalyseIP is
		generic (
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= 4
		);
		port (
		i_bclk : in std_logic;
		i_data_echantillon : in std_logic_vector(11 downto 0);
		i_adc_strobe : in std_logic;
        o_data_out0 : out std_logic_vector(1 downto 0);
        o_data_out1 : out std_logic_vector(31 downto 0);
        
		S_AXI_ACLK	: in std_logic;
		S_AXI_ARESETN	: in std_logic;
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
		S_AXI_AWVALID	: in std_logic;
		S_AXI_AWREADY	: out std_logic;
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		S_AXI_WVALID	: in std_logic;
		S_AXI_WREADY	: out std_logic;
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		S_AXI_BVALID	: out std_logic;
		S_AXI_BREADY	: in std_logic;
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
		S_AXI_ARVALID	: in std_logic;
		S_AXI_ARREADY	: out std_logic;
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		S_AXI_RVALID	: out std_logic;
		S_AXI_RREADY	: in std_logic
		);
	end component MouvAnalyseIP_v1_0_MouvAnalyseIP;

begin

-- Instantiation of Axi Bus Interface MouvAnalyseIP
MouvAnalyseIP_v1_0_MouvAnalyseIP_inst : MouvAnalyseIP_v1_0_MouvAnalyseIP
	generic map (
		C_S_AXI_DATA_WIDTH	=> C_MouvAnalyseIP_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_MouvAnalyseIP_ADDR_WIDTH
	)
	port map (
	    i_bclk => i_bclk,
	    i_data_echantillon => i_data_echantillon,
	    i_adc_strobe => i_adc_strobe,
	    o_data_out0 => o_data_out0,
        o_data_out1 => o_data_out1,
        
		S_AXI_ACLK	=> mouvanalyseip_aclk,
		S_AXI_ARESETN	=> mouvanalyseip_aresetn,
		S_AXI_AWADDR	=> mouvanalyseip_awaddr,
		S_AXI_AWPROT	=> mouvanalyseip_awprot,
		S_AXI_AWVALID	=> mouvanalyseip_awvalid,
		S_AXI_AWREADY	=> mouvanalyseip_awready,
		S_AXI_WDATA	=> mouvanalyseip_wdata,
		S_AXI_WSTRB	=> mouvanalyseip_wstrb,
		S_AXI_WVALID	=> mouvanalyseip_wvalid,
		S_AXI_WREADY	=> mouvanalyseip_wready,
		S_AXI_BRESP	=> mouvanalyseip_bresp,
		S_AXI_BVALID	=> mouvanalyseip_bvalid,
		S_AXI_BREADY	=> mouvanalyseip_bready,
		S_AXI_ARADDR	=> mouvanalyseip_araddr,
		S_AXI_ARPROT	=> mouvanalyseip_arprot,
		S_AXI_ARVALID	=> mouvanalyseip_arvalid,
		S_AXI_ARREADY	=> mouvanalyseip_arready,
		S_AXI_RDATA	=> mouvanalyseip_rdata,
		S_AXI_RRESP	=> mouvanalyseip_rresp,
		S_AXI_RVALID	=> mouvanalyseip_rvalid,
		S_AXI_RREADY	=> mouvanalyseip_rready
	);

	-- Add user logic here
	-- User logic ends

end arch_imp;
