Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 136AC4D6363
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 15:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345126AbiCKO02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 09:26:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiCKO01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 09:26:27 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A9B91C7EBD;
        Fri, 11 Mar 2022 06:25:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1647008724; x=1678544724;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FJzf77sp+R4AKDyJrAnw7tSJq2oomw6VdBOt0zeISec=;
  b=iUahQ6qQlg2AOiUwLhZkP7AR9HbNXqVuL64NzBNR4DyTCltMY7Eminte
   MQAsOIzKWDRXKDitEMBMHxM/8F4IptPo4QdhWMrIJMdZSZeIEUlPmpumL
   H2ny3gbtn3s+sDeO4oH2HjuEr+9xUmKxMJtaUtoa9Q3DHXPCjQyMRBNgT
   Xi1O/3DBCIGFZUogXvFVK80fItQ7SKAmngzQS6DIkpUVT3yZEzGr0CdoA
   0NwinSU+85WecqEmcjvx3Vvt6k4n/o59x48n8nQ/hSwc5a5FacjYkdi98
   EpbA1W0KW2DVj7DGin+IrYzkcq+Up9CLO7Y3ZdUzZurGFUVVn0+E59YjT
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,174,1643698800"; 
   d="scan'208";a="156123161"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Mar 2022 07:25:23 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 11 Mar 2022 07:25:22 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Fri, 11 Mar 2022 07:25:22 -0700
Date:   Fri, 11 Mar 2022 15:28:14 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, <Divya.Koppera@microchip.com>,
        <netdev@vger.kernel.org>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <Madhuri.Sripada@microchip.com>,
        <Manohar.Puri@microchip.com>
Subject: Re: [PATCH net-next 2/3] dt-bindings: net: micrel: Configure latency
 values and timestamping check for LAN8814 phy
Message-ID: <20220311142814.z3h5nystnrkvbzek@soft-dev3-1.localhost>
References: <YiYD2kAFq5EZhU+q@lunn.ch>
 <CO1PR11MB4771F7C1819E033EC613E262E2099@CO1PR11MB4771.namprd11.prod.outlook.com>
 <YidgHT8CLWrmhbTW@lunn.ch>
 <20220308154345.l4mk2oab4u5ydn5r@soft-dev3-1.localhost>
 <YiecBKGhVui1Gtb/@lunn.ch>
 <20220308221404.bwhujvsdp253t4g3@soft-dev3-1.localhost>
 <YifoltDp4/Fs+9op@lunn.ch>
 <20220309132443.axyzcsc5kyb26su4@soft-dev3-1.localhost>
 <Yii/9RH67BEjNtLM@shell.armlinux.org.uk>
 <20220309195252.GB9663@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20220309195252.GB9663@hoboy.vegasvil.org>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 03/09/2022 11:52, Richard Cochran wrote:
> 
> On Wed, Mar 09, 2022 at 02:55:49PM +0000, Russell King (Oracle) wrote:
> 
> > I think we understand this, and compensating for the delay in the PHY
> > is quite reasonable, which surely will be a fixed amount irrespective
> > of the board.
> 
> The PHY delays are not fixed.  They can be variable, even packet to packet.
> 
> https://www.researchgate.net/publication/260434179_Measurement_of_egress_and_ingress_delays_of_PTP_clocks
> 
> https://www.researchgate.net/publication/265731050_Experimental_verification_of_the_egress_and_ingress_latency_correction_in_PTP_clocks
> 
> Some PHYs are well behaved.  Some are not.

What about adding only some sane values in the driver like here [1].
And the allow the user to use linuxptp to fine tune all this.

> 
> In any case, the linuxptp user space stack supports the standardized
> method of correcting a system's delay asymmetry.  IMO it makes no
> sense to even try to let kernel device drivers correct these delays.
> Driver authors will get it wrong, and indeed they have already tried
> and failed.  And when the magic numbers change from one kernel release
> to another, it only makes the end user's job harder, because they will
> have to update their scripts to correct the bogus numbers.
> 
> Thanks,
> Richard
> 

[1] https://elixir.bootlin.com/linux/v5.17-rc7/source/drivers/net/phy/mscc/mscc_ptp.c#L245

-- 
/Horatiu
