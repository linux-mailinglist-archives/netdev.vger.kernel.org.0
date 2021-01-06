Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBE8E2EC226
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 18:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbhAFR1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 12:27:36 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:36829 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727814AbhAFR1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 12:27:35 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id C3B3E580265;
        Wed,  6 Jan 2021 12:26:28 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 06 Jan 2021 12:26:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=ek9BJj
        vqCBBp70ijZgnhcepKrwiNHYoA1lTv6N8lc44=; b=EZpwU5kvXhp44Ke3a5I1DC
        wG8Y0Q/7w+VfPIUi9bowH7iLoqQx0ABYBwx1ZPEQfvGPk0R2oiMEKIxyTPj0V+mU
        ihTjSYB7yBTH8z+eWXRBBOQl4+0ZejdNux/Tw+qG+Zt/vP01wt5GtvUpq/NytAJt
        kSFQ3Ba460P64krr3RfZa5GrAlRmph3ZyKYwWmXQvGs6myIsiPlKwJOSczP4BUiN
        sBlgOInPs9lHl8/A4gywvjcxvXmIpZYtFkrTEaYlvIzosPd2G9+DJPCmilCOQL5R
        bVMlH2kc0N8OuZNKMmXUAMRvDQ5Wlskj5ZdA+SG0wiD+egFTFfi9cNSxJAauMSqQ
        ==
X-ME-Sender: <xms:wfL1X65-g_hnVq2fgmTa5XiOHd1QGX-ETFiI9eXozFlLYEGVCAK2TA>
    <xme:wfL1Xz5gK-hWUcHHEj7Crz-hcfUaFQ0THc08HALlw2ArGlK9I9YqMo7eMB-Ua3ZFj
    a5ywAt5V1_89DQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdegtddgtdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdduheefrdeggeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:wfL1X5cGeEcMImRG7L3bRR7PwB37QmRuYe-pyRLnqR2pf8qXH65TMA>
    <xmx:wfL1X3LkHY6gWXkYoAOIXm-oQmMkRCpRPCjtTJBDvDzywR4PHuCRPw>
    <xmx:wfL1X-J0VA_NVCjRM1WYS-Lpg4LrNt--JR1cLXN_1X67gVUtiT94Fw>
    <xmx:xPL1Xy8JM6HBcYSt-PHX0cUnnMgPuCAZiFo92FJ1vNiNOCY8RP4CLQ>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0A40024005A;
        Wed,  6 Jan 2021 12:26:25 -0500 (EST)
Date:   Wed, 6 Jan 2021 19:26:21 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>
Subject: Re: [PATCH v2 net-next 01/10] net: switchdev: remove vid_begin ->
 vid_end range from VLAN objects
Message-ID: <20210106172621.GA1082418@shredder.lan>
References: <20210106131006.577312-1-olteanv@gmail.com>
 <20210106131006.577312-2-olteanv@gmail.com>
 <20210106170818.GA1080217@shredder.lan>
 <20210106171559.abu2jffskjsry77b@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210106171559.abu2jffskjsry77b@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 06, 2021 at 07:15:59PM +0200, Vladimir Oltean wrote:
> On Wed, Jan 06, 2021 at 07:08:18PM +0200, Ido Schimmel wrote:
> > On Wed, Jan 06, 2021 at 03:09:57PM +0200, Vladimir Oltean wrote:
> > > Of the existing switchdev pieces of hardware, it appears that only
> > > Mellanox Spectrum supports offloading more than one VLAN at a time.
> > > I have kept that code internal to the driver, because there is some more
> > > bookkeeping that makes use of it, but I deleted it from the switchdev
> > > API. But since the switchdev support for ranges has already been de
> > > facto deleted by a Mellanox employee and nobody noticed for 4 years, I'm
> > > going to assume it's not a biggie.
> > 
> > Which code are you referring to?
> 
> mlxsw_sp_port_vlan_set

OK, we actually need this one. We are using it during driver
initialization to clear VLAN membership for all 4k VLANs in each port in
batch. For some reason, the hardware/firmware default is that ports are
member in all 4k VLANs, which is not in accordance with the kernel.

> 
> > For the switchdev and mlxsw parts:
> > 
> > Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> > 
> > I applied the series to our queue, so I should have regression results
> > tomorrow
> 
> Thanks. Could you wait for me to send a v3 though, with that small fixup
> in mv88e6xxx? I'm sure it will raise some red flags for your testing too.

I don't have mv88e6xxx enabled in my config, so I was able to compile
the kernel successfully. Anyway, I can always test more versions.
