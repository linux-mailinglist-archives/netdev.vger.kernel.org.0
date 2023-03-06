Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D98216ACC4E
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 19:19:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbjCFSTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 13:19:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjCFSTb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 13:19:31 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C95F0457CB
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 10:19:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678126744; x=1709662744;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=v3Djklsyht7uJKBw6Zfk65UNwZ0LJrKevoeIRjYoG+A=;
  b=J4ceM678wjHWxs6wHghkRW5CbnPIEbO5N16HCwSaZX8TJE/jaEQGVZpF
   /JFZWC8XR6rjr/OXPLje146LJyY9wWcAtsvnUrBOerCuwjOPCIqqS4k2+
   V6qX9fAaC1toGuyGYhKQjSf1rJ/l3aMY3yo/sdP+jIWlHbZdFJZPK/im1
   ELskxVTt5Bj8XYQix1gELBkhLw2sFgjGNwZCsWi2NX2HkEOhTFdUkyatt
   89roEVoplMiC99gKi1a3i9yI5UWolXLkZUiAZaEeJijGDRTCu5BOgPMkD
   PTnE5EAd+0KYoH9Z0ER2opAoVjqUBRwAGDxtexEd5fhaxR8yW+p8b3O5n
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="337958270"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="337958270"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 10:18:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="626244963"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="626244963"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 06 Mar 2023 10:18:30 -0800
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pZFPp-0000Wd-0W;
        Mon, 06 Mar 2023 18:18:29 +0000
Date:   Tue, 7 Mar 2023 02:17:32 +0800
From:   kernel test robot <lkp@intel.com>
To:     Vadim Fedorenko <vadfed@meta.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     oe-kbuild-all@lists.linux.dev, Vadim Fedorenko <vadfed@meta.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org
Subject: Re: [net-next] ptp_ocp: add force_irq to xilinx_spi configuration
Message-ID: <202303070211.1hVqbsqg-lkp@intel.com>
References: <20230306155726.4035925-1-vadfed@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230306155726.4035925-1-vadfed@meta.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vadim,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Vadim-Fedorenko/ptp_ocp-add-force_irq-to-xilinx_spi-configuration/20230306-235901
patch link:    https://lore.kernel.org/r/20230306155726.4035925-1-vadfed%40meta.com
patch subject: [net-next] ptp_ocp: add force_irq to xilinx_spi configuration
config: ia64-allyesconfig (https://download.01.org/0day-ci/archive/20230307/202303070211.1hVqbsqg-lkp@intel.com/config)
compiler: ia64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/a30de1354a643bbb9f8e8174332d00d78e74c520
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Vadim-Fedorenko/ptp_ocp-add-force_irq-to-xilinx_spi-configuration/20230306-235901
        git checkout a30de1354a643bbb9f8e8174332d00d78e74c520
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=ia64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=ia64 SHELL=/bin/bash drivers/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303070211.1hVqbsqg-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/ptp/ptp_ocp.c:665:34: error: 'struct xspi_platform_data' has no member named 'force_irq'
     665 |                                 .force_irq = true,
         |                                  ^~~~~~~~~
>> drivers/ptp/ptp_ocp.c:665:46: warning: excess elements in struct initializer
     665 |                                 .force_irq = true,
         |                                              ^~~~
   drivers/ptp/ptp_ocp.c:665:46: note: (near initialization for '(anonymous)')


vim +665 drivers/ptp/ptp_ocp.c

   423	
   424	#define OCP_RES_LOCATION(member) \
   425		.name = #member, .bp_offset = offsetof(struct ptp_ocp, member)
   426	
   427	#define OCP_MEM_RESOURCE(member) \
   428		OCP_RES_LOCATION(member), .setup = ptp_ocp_register_mem
   429	
   430	#define OCP_SERIAL_RESOURCE(member) \
   431		OCP_RES_LOCATION(member), .setup = ptp_ocp_register_serial
   432	
   433	#define OCP_I2C_RESOURCE(member) \
   434		OCP_RES_LOCATION(member), .setup = ptp_ocp_register_i2c
   435	
   436	#define OCP_SPI_RESOURCE(member) \
   437		OCP_RES_LOCATION(member), .setup = ptp_ocp_register_spi
   438	
   439	#define OCP_EXT_RESOURCE(member) \
   440		OCP_RES_LOCATION(member), .setup = ptp_ocp_register_ext
   441	
   442	/* This is the MSI vector mapping used.
   443	 * 0: PPS (TS5)
   444	 * 1: TS0
   445	 * 2: TS1
   446	 * 3: GNSS1
   447	 * 4: GNSS2
   448	 * 5: MAC
   449	 * 6: TS2
   450	 * 7: I2C controller
   451	 * 8: HWICAP (notused)
   452	 * 9: SPI Flash
   453	 * 10: NMEA
   454	 * 11: Signal Generator 1
   455	 * 12: Signal Generator 2
   456	 * 13: Signal Generator 3
   457	 * 14: Signal Generator 4
   458	 * 15: TS3
   459	 * 16: TS4
   460	 --
   461	 * 8: Orolia TS1
   462	 * 10: Orolia TS2
   463	 * 11: Orolia TS0 (GNSS)
   464	 * 12: Orolia PPS
   465	 * 14: Orolia TS3
   466	 * 15: Orolia TS4
   467	 */
   468	
   469	static struct ocp_resource ocp_fb_resource[] = {
   470		{
   471			OCP_MEM_RESOURCE(reg),
   472			.offset = 0x01000000, .size = 0x10000,
   473		},
   474		{
   475			OCP_EXT_RESOURCE(ts0),
   476			.offset = 0x01010000, .size = 0x10000, .irq_vec = 1,
   477			.extra = &(struct ptp_ocp_ext_info) {
   478				.index = 0,
   479				.irq_fcn = ptp_ocp_ts_irq,
   480				.enable = ptp_ocp_ts_enable,
   481			},
   482		},
   483		{
   484			OCP_EXT_RESOURCE(ts1),
   485			.offset = 0x01020000, .size = 0x10000, .irq_vec = 2,
   486			.extra = &(struct ptp_ocp_ext_info) {
   487				.index = 1,
   488				.irq_fcn = ptp_ocp_ts_irq,
   489				.enable = ptp_ocp_ts_enable,
   490			},
   491		},
   492		{
   493			OCP_EXT_RESOURCE(ts2),
   494			.offset = 0x01060000, .size = 0x10000, .irq_vec = 6,
   495			.extra = &(struct ptp_ocp_ext_info) {
   496				.index = 2,
   497				.irq_fcn = ptp_ocp_ts_irq,
   498				.enable = ptp_ocp_ts_enable,
   499			},
   500		},
   501		{
   502			OCP_EXT_RESOURCE(ts3),
   503			.offset = 0x01110000, .size = 0x10000, .irq_vec = 15,
   504			.extra = &(struct ptp_ocp_ext_info) {
   505				.index = 3,
   506				.irq_fcn = ptp_ocp_ts_irq,
   507				.enable = ptp_ocp_ts_enable,
   508			},
   509		},
   510		{
   511			OCP_EXT_RESOURCE(ts4),
   512			.offset = 0x01120000, .size = 0x10000, .irq_vec = 16,
   513			.extra = &(struct ptp_ocp_ext_info) {
   514				.index = 4,
   515				.irq_fcn = ptp_ocp_ts_irq,
   516				.enable = ptp_ocp_ts_enable,
   517			},
   518		},
   519		/* Timestamp for PHC and/or PPS generator */
   520		{
   521			OCP_EXT_RESOURCE(pps),
   522			.offset = 0x010C0000, .size = 0x10000, .irq_vec = 0,
   523			.extra = &(struct ptp_ocp_ext_info) {
   524				.index = 5,
   525				.irq_fcn = ptp_ocp_ts_irq,
   526				.enable = ptp_ocp_ts_enable,
   527			},
   528		},
   529		{
   530			OCP_EXT_RESOURCE(signal_out[0]),
   531			.offset = 0x010D0000, .size = 0x10000, .irq_vec = 11,
   532			.extra = &(struct ptp_ocp_ext_info) {
   533				.index = 1,
   534				.irq_fcn = ptp_ocp_signal_irq,
   535				.enable = ptp_ocp_signal_enable,
   536			},
   537		},
   538		{
   539			OCP_EXT_RESOURCE(signal_out[1]),
   540			.offset = 0x010E0000, .size = 0x10000, .irq_vec = 12,
   541			.extra = &(struct ptp_ocp_ext_info) {
   542				.index = 2,
   543				.irq_fcn = ptp_ocp_signal_irq,
   544				.enable = ptp_ocp_signal_enable,
   545			},
   546		},
   547		{
   548			OCP_EXT_RESOURCE(signal_out[2]),
   549			.offset = 0x010F0000, .size = 0x10000, .irq_vec = 13,
   550			.extra = &(struct ptp_ocp_ext_info) {
   551				.index = 3,
   552				.irq_fcn = ptp_ocp_signal_irq,
   553				.enable = ptp_ocp_signal_enable,
   554			},
   555		},
   556		{
   557			OCP_EXT_RESOURCE(signal_out[3]),
   558			.offset = 0x01100000, .size = 0x10000, .irq_vec = 14,
   559			.extra = &(struct ptp_ocp_ext_info) {
   560				.index = 4,
   561				.irq_fcn = ptp_ocp_signal_irq,
   562				.enable = ptp_ocp_signal_enable,
   563			},
   564		},
   565		{
   566			OCP_MEM_RESOURCE(pps_to_ext),
   567			.offset = 0x01030000, .size = 0x10000,
   568		},
   569		{
   570			OCP_MEM_RESOURCE(pps_to_clk),
   571			.offset = 0x01040000, .size = 0x10000,
   572		},
   573		{
   574			OCP_MEM_RESOURCE(tod),
   575			.offset = 0x01050000, .size = 0x10000,
   576		},
   577		{
   578			OCP_MEM_RESOURCE(irig_in),
   579			.offset = 0x01070000, .size = 0x10000,
   580		},
   581		{
   582			OCP_MEM_RESOURCE(irig_out),
   583			.offset = 0x01080000, .size = 0x10000,
   584		},
   585		{
   586			OCP_MEM_RESOURCE(dcf_in),
   587			.offset = 0x01090000, .size = 0x10000,
   588		},
   589		{
   590			OCP_MEM_RESOURCE(dcf_out),
   591			.offset = 0x010A0000, .size = 0x10000,
   592		},
   593		{
   594			OCP_MEM_RESOURCE(nmea_out),
   595			.offset = 0x010B0000, .size = 0x10000,
   596		},
   597		{
   598			OCP_MEM_RESOURCE(image),
   599			.offset = 0x00020000, .size = 0x1000,
   600		},
   601		{
   602			OCP_MEM_RESOURCE(pps_select),
   603			.offset = 0x00130000, .size = 0x1000,
   604		},
   605		{
   606			OCP_MEM_RESOURCE(sma_map1),
   607			.offset = 0x00140000, .size = 0x1000,
   608		},
   609		{
   610			OCP_MEM_RESOURCE(sma_map2),
   611			.offset = 0x00220000, .size = 0x1000,
   612		},
   613		{
   614			OCP_I2C_RESOURCE(i2c_ctrl),
   615			.offset = 0x00150000, .size = 0x10000, .irq_vec = 7,
   616			.extra = &(struct ptp_ocp_i2c_info) {
   617				.name = "xiic-i2c",
   618				.fixed_rate = 50000000,
   619				.data_size = sizeof(struct xiic_i2c_platform_data),
   620				.data = &(struct xiic_i2c_platform_data) {
   621					.num_devices = 2,
   622					.devices = (struct i2c_board_info[]) {
   623						{ I2C_BOARD_INFO("24c02", 0x50) },
   624						{ I2C_BOARD_INFO("24mac402", 0x58),
   625						  .platform_data = "mac" },
   626					},
   627				},
   628			},
   629		},
   630		{
   631			OCP_SERIAL_RESOURCE(gnss_port),
   632			.offset = 0x00160000 + 0x1000, .irq_vec = 3,
   633			.extra = &(struct ptp_ocp_serial_port) {
   634				.baud = 115200,
   635			},
   636		},
   637		{
   638			OCP_SERIAL_RESOURCE(gnss2_port),
   639			.offset = 0x00170000 + 0x1000, .irq_vec = 4,
   640			.extra = &(struct ptp_ocp_serial_port) {
   641				.baud = 115200,
   642			},
   643		},
   644		{
   645			OCP_SERIAL_RESOURCE(mac_port),
   646			.offset = 0x00180000 + 0x1000, .irq_vec = 5,
   647			.extra = &(struct ptp_ocp_serial_port) {
   648				.baud = 57600,
   649			},
   650		},
   651		{
   652			OCP_SERIAL_RESOURCE(nmea_port),
   653			.offset = 0x00190000 + 0x1000, .irq_vec = 10,
   654		},
   655		{
   656			OCP_SPI_RESOURCE(spi_flash),
   657			.offset = 0x00310000, .size = 0x10000, .irq_vec = 9,
   658			.extra = &(struct ptp_ocp_flash_info) {
   659				.name = "xilinx_spi", .pci_offset = 0,
   660				.data_size = sizeof(struct xspi_platform_data),
   661				.data = &(struct xspi_platform_data) {
   662					.num_chipselect = 1,
   663					.bits_per_word = 8,
   664					.num_devices = 1,
 > 665					.force_irq = true,
   666					.devices = &(struct spi_board_info) {
   667						.modalias = "spi-nor",
   668					},
   669				},
   670			},
   671		},
   672		{
   673			OCP_MEM_RESOURCE(freq_in[0]),
   674			.offset = 0x01200000, .size = 0x10000,
   675		},
   676		{
   677			OCP_MEM_RESOURCE(freq_in[1]),
   678			.offset = 0x01210000, .size = 0x10000,
   679		},
   680		{
   681			OCP_MEM_RESOURCE(freq_in[2]),
   682			.offset = 0x01220000, .size = 0x10000,
   683		},
   684		{
   685			OCP_MEM_RESOURCE(freq_in[3]),
   686			.offset = 0x01230000, .size = 0x10000,
   687		},
   688		{
   689			.setup = ptp_ocp_fb_board_init,
   690		},
   691		{ }
   692	};
   693	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
