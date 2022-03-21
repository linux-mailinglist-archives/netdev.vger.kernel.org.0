Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBF74E3180
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 21:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352999AbiCUUOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 16:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353420AbiCUUNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 16:13:09 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99A2C2CCA3;
        Mon, 21 Mar 2022 13:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1647893429; x=1679429429;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JflRYBzJ/v3lV9RjWArieyXQLSJLXWoiJMZIx4KYloU=;
  b=hx+FFJQOFoN9PfEe6l/sU+1J8adfL6b2VrbsbQiGFHQjjdA7kykMpmPM
   xMkEC2m5WnTBDbm7iN1Gk7WrayoY4fq2fdUTyoP9LlKZAxpLJf51tdpik
   TJPJoDFzdWyzHHOvQCVTfjNqJMIlYvxD8BxhgyP+Jjo1JhTnZ8MdwySEv
   JFNT9SNNqaESEsDOYESbkckSM7Uff2iXe6Cdeg8aq9c2ahZ1dwZ4wnYzX
   tTau/McJs1zZW+2dSgu8DB4MRCdcRzker3N310r2EMDPDpoHxawhGgg57
   FHv3I/IrPBUPZShOJtzhBt+nx/4N5SAVrLdBVT24faAOKSEnZRADyCyIH
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,199,1643698800"; 
   d="scan'208";a="157194855"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Mar 2022 13:09:39 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 21 Mar 2022 13:09:38 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 21 Mar 2022 13:09:30 -0700
Message-ID: <3441a9f60834f8a32a537145303f4a93e2e76c60.camel@microchip.com>
Subject: Re: [PATCH v9 net-next 06/11] net: dsa: microchip: add DSA support
 for microchip lan937x
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>, <UNGLinuxDriver@microchip.com>,
        <woojung.huh@microchip.com>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Date:   Tue, 22 Mar 2022 01:39:28 +0530
In-Reply-To: <YjaAqXfiBrMggIdA@lunn.ch>
References: <20220318085540.281721-1-prasanna.vengateshan@microchip.com>
         <20220318085540.281721-7-prasanna.vengateshan@microchip.com>
         <YjaAqXfiBrMggIdA@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2022-03-20 at 02:17 +0100, Andrew Lunn wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the
> content is safe
> 
> > +int lan937x_reset_switch(struct ksz_device *dev)
> > +{
> > +     u32 data32;
> > +     u8 data8;
> > +     int ret;
> > +
> > +     /* reset switch */
> > +     ret = lan937x_cfg(dev, REG_SW_OPERATION, SW_RESET, true);
> > +     if (ret < 0)
> > +             return ret;
> > +
> > +     ret = ksz_read8(dev, REG_SW_LUE_CTRL_1, &data8);
> > +     if (ret < 0)
> > +             return ret;
> > +
> > +     /* Enable Auto Aging */
> > +     ret = ksz_write8(dev, REG_SW_LUE_CTRL_1, data8 | SW_LINK_AUTO_AGING);
> > +     if (ret < 0)
> > +             return ret;
> > +
> > +     /* disable interrupts */
> > +     ret = ksz_write32(dev, REG_SW_INT_MASK__4, SWITCH_INT_MASK);
> > +     if (ret < 0)
> > +             return ret;
> > +
> > +     ret = ksz_write32(dev, REG_SW_PORT_INT_MASK__4, 0xFF);
> > +     if (ret < 0)
> > +             return ret;
> > +
> > +     return ksz_read32(dev, REG_SW_PORT_INT_STATUS__4, &data32);
> 
> I would probably enable auto aging in the setup routing, not the
> reset.  Disabling interrupts is less clear, maybe it also belongs in
> setup?

Actually lan937x_reset_switch() gets called from setup() as well.

> 
> > +static void lan937x_switch_exit(struct ksz_device *dev)
> > +{
> > +     lan937x_reset_switch(dev);
> > +}
> 
> Humm. Does a reset leave the switch in a dumb mode, or is it totally
> disabled?

Its a kind of unconfiguring and you are right, Auto aging & disabling interrupts
can be directly moved to setup().


> 
> > +int lan937x_internal_phy_write(struct ksz_device *dev, int addr, int reg,
> > +                            u16 val)
> > +{
> > +     u16 temp, addr_base;
> > +     unsigned int value;
> > +     int ret;
> > +
> > +     /* Check for internal phy port */
> > +     if (!lan937x_is_internal_phy_port(dev, addr))
> > +             return -EOPNOTSUPP;
> > +
> > +     if (lan937x_is_internal_base_tx_phy_port(dev, addr))
> > +             addr_base = REG_PORT_TX_PHY_CTRL_BASE;
> > +     else
> > +             addr_base = REG_PORT_T1_PHY_CTRL_BASE;
> > +
> > +     temp = PORT_CTRL_ADDR(addr, (addr_base + (reg << 2)));
> > +
> > +     ret = ksz_write16(dev, REG_VPHY_IND_ADDR__2, temp);
> > +     if (ret < 0)
> > +             return ret;
> 
> ...
> 
> > +}
> > +
> > +int lan937x_internal_phy_read(struct ksz_device *dev, int addr, int reg,
> > +                           u16 *val)
> > +{
> > +     u16 temp, addr_base;
> > +     unsigned int value;
> > +     int ret;
> > +
> > +     /* Check for internal phy port, return 0xffff for non-existent phy */
> > +     if (!lan937x_is_internal_phy_port(dev, addr))
> > +             return 0xffff;
> > +
> > +     if (lan937x_is_internal_base_tx_phy_port(dev, addr))
> > +             addr_base = REG_PORT_TX_PHY_CTRL_BASE;
> > +     else
> > +             addr_base = REG_PORT_T1_PHY_CTRL_BASE;
> > +
> > +     /* get register address based on the logical port */
> > +     temp = PORT_CTRL_ADDR(addr, (addr_base + (reg << 2)));
> > +
> > +     ret = ksz_write16(dev, REG_VPHY_IND_ADDR__2, temp);
> > +     if (ret < 0)
> > +             return ret;
> 
> Looks pretty similar to me. You should pull this out into a helper.

Sure, i think it can be made except if check lan937x_is_internal_phy_port() 

> 
> 
> > +struct lan_alu_struct {
> > +     /* entry 1 */
> > +     u8      is_static:1;
> > +     u8      is_src_filter:1;
> > +     u8      is_dst_filter:1;
> > +     u8      prio_age:3;
> > +     u32     _reserv_0_1:23;
> > +     u8      mstp:3;
> 
> I assume this works O.K, but bitfields are nornaly defined using one
> type. I would of used u32 for them all. Is there some advantage of
> missing u8 and u32?

It works because direct assignments are used. But using one type is the right
way. I will change it in the next patch.

> 
> > +     /* entry 2 */
> > +     u8      is_override:1;
> > +     u8      is_use_fid:1;
> > +     u32     _reserv_1_1:22;
> > +     u8      port_forward:8;
> > +     /* entry 3 & 4*/
> > +     u32     _reserv_2_1:9;
> > +     u8      fid:7;
> > +     u8      mac[ETH_ALEN];
> > +};
> 
>   Andrew


