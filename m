Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1590235DBEF
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 11:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbhDMJ4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 05:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbhDMJ4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 05:56:09 -0400
X-Greylist: delayed 96659 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 13 Apr 2021 02:55:50 PDT
Received: from mx.i2x.nl (mx.i2x.nl [IPv6:2a04:52c0:101:921::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E7294C061574;
        Tue, 13 Apr 2021 02:55:49 -0700 (PDT)
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd00::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mx.i2x.nl (Postfix) with ESMTPS id 3CB085FBA8;
        Tue, 13 Apr 2021 11:55:47 +0200 (CEST)
Authentication-Results: mx.i2x.nl;
        dkim=pass (2048-bit key; secure) header.d=vdorst.com header.i=@vdorst.com header.b="Gghi4hES";
        dkim-atps=neutral
Received: from www (unknown [192.168.2.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id EDBE5BCBD82;
        Tue, 13 Apr 2021 11:55:46 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com EDBE5BCBD82
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1618307747;
        bh=sWQeaeOZs1zGfDyfM+Yma0gmKoH8b4gYtID9LwyyZ5w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gghi4hEShLFgZnDXwuQW8jfIxh7MkxHmq+NZ0k2s+nND11zJt7k4G1H3UMRBbSPaD
         8J4TJrlKR08JzOITEUFD5YjM4pojAxuGYtzuGKdq6w5ZWzOqiGhsgKvJlPayJXmgc7
         0R343Hr8LuZBbSwqz95x5qGKYwtiSIlvw8pQ3lAl36oIOkYldIISeeHMwVz4w4kAI5
         9nAiWev+Ipuk1zFHDSqVmaatXUONC8fEE+Tc14M4+Wy6WyaklIpKTZCXLLRFxukSYe
         JwT3D1mxVmyaqSSScCNP6/pZMdOl4pKfTtOOhPskToPL6snJfFPMff7XOmFmRi0nWn
         9cEMPEdyhK96Q==
Received: from 48.79.2.5.in-addr.arpa (48.79.2.5.in-addr.arpa [5.2.79.48])
 by www.vdorst.com (Horde Framework) with HTTPS; Tue, 13 Apr 2021 09:55:46
 +0000
Date:   Tue, 13 Apr 2021 09:55:46 +0000
Message-ID: <20210413095546.Horde.AlZ6EGgmo3WL6JXtMEAWgRh@www.vdorst.com>
From:   =?utf-8?b?UmVuw6k=?= van Dorst <opensource@vdorst.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-staging@lists.linux.dev, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, Weijie Gao <weijie.gao@mediatek.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>
Subject: Re: [RFC v4 net-next 1/4] net: phy: add MediaTek PHY driver
References: <20210412034237.2473017-1-dqfext@gmail.com>
 <20210412034237.2473017-2-dqfext@gmail.com>
 <20210412070449.Horde.wg9CWXW8V9o0P-heKYtQpVh@www.vdorst.com>
 <20210412150836.929610-1-dqfext@gmail.com>
 <20210413035920.1422364-1-dqfext@gmail.com>
In-Reply-To: <20210413035920.1422364-1-dqfext@gmail.com>
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting DENG Qingfang <dqfext@gmail.com>:

> On Mon, Apr 12, 2021 at 11:08:36PM +0800, DENG Qingfang wrote:
>> On Mon, Apr 12, 2021 at 07:04:49AM +0000, René van Dorst wrote:
>> > Hi Qingfang,
>> > > +static void mtk_phy_config_init(struct phy_device *phydev)
>> > > +{
>> > > +	/* Disable EEE */
>> > > +	phy_write_mmd(phydev, MDIO_MMD_AN, MDIO_AN_EEE_ADV, 0);
>> >
>> > For my EEE patch I changed this line to:
>> >
>> > genphy_config_eee_advert(phydev);
>> >
>> > So PHY EEE part is setup properly at boot, instead enable it manual via
>> > ethtool.
>> > This function also takes the DTS parameters "eee-broken-xxxx" in  
>> to account
>> > while
>> > setting-up the PHY.
>>
>> Thanks, I'm now testing with it.
>
> Hi Rene,
>
> Within 12 hours, I got some spontaneous link down/ups when EEE is enabled:
>
> [16334.236233] mt7530 mdio-bus:1f wan: Link is Down
> [16334.241340] br-lan: port 3(wan) entered disabled state
> [16337.355988] mt7530 mdio-bus:1f wan: Link is Up - 1Gbps/Full -  
> flow control rx/tx
> [16337.363468] br-lan: port 3(wan) entered blocking state
> [16337.368638] br-lan: port 3(wan) entered forwarding state
>
> The cable is a 30m Cat.6 and never has such issue when EEE is disabled.
> Perhaps WAKEUP_TIME_1000/100 or some PHY registers need to be fine-tuned,
> but for now I think it should be disabled by default.

Hi Qingfang,

Problem is that, may be the other device on the other side, may is issue.
So it is hard to tell which device is the issue.


I have a low traffic access point with 1meter cable running the  
openwrt 5.10 kernel with the openwrt EEE patch.
EEE is active and uptime with 16days without an issue.
This was with the old patch which clears the WAKEUP_TIME_1000/100 values.


I changed my ethernet setup so that access point switch has more  
traffic and longer cable ~18meters.
I also upgraded the kernel to 5.10.28 and added the EEE v2 patch.
Let's see what happens for a longer time and with more real world traffic.

Greats,

René
>
>>
>> >
>> > > +
>> > > +	/* Enable HW auto downshift */
>> > > +	phy_modify_paged(phydev, MTK_PHY_PAGE_EXTENDED, 0x14, 0, BIT(4));



