Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 790BE315673
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 20:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233521AbhBITC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 14:02:59 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:41071 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233406AbhBISv4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 13:51:56 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 367E9580310;
        Tue,  9 Feb 2021 13:51:05 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 09 Feb 2021 13:51:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=yab2wm
        v6Wl9fFfxmQTboj1nEHw/37YL9zHWD6ZhbdHM=; b=P0a7X4kL8bJqhrpJAdamOb
        0i6LxuNNnMztcel+ytRDNDsFLepneY8Mc49QE2m5Oq3DDNuWFKlK91QevpYZisuk
        bxFkIPG7d6P/1VjyJTk5d0wc+C2rnks+fgDdpwdvAxursDr6q737F46MxruiQaQe
        22LMoTBRphwNt1OMxmYqrxsTN7MpjwchyykWnBdp6n9elWxZEmPdIG/3do6WhNm+
        w8wSQf7B30l3gSjfGii4RMAYxskNMXYmHcmrRQ7GV5gk6XkJM8fxcD1//oazn1cD
        on5Ie7fcdjFQEdJf21BlVmCBBoPPR0aKWzQ6I6xkKjso9CQtyLn2qJ/JNJryh+Xw
        ==
X-ME-Sender: <xms:l9kiYIfHN2hy2xkT2FeE25HMEi992P6W0bHF2p1pUbxXExR0SRhCSg>
    <xme:l9kiYPlRYgfP_cbAqh7FhsFXTHAzjAZ_Tt7MPV6_i5F7ULpO5A88inmz_I6040R2j
    q7obSz-6TAHbTA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrheehgdduudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdduheefrdeggeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:l9kiYJuDOxXHFzFe1ftwzAAhS7eJzjpsaDOLJoZNP0krzvJeWwEH1Q>
    <xmx:l9kiYN_diuJkA3BqFCbzEbPzdWcOCdLUMfi9fqNjwBjOFR1nXS_MDA>
    <xmx:l9kiYDP8q6mB6vcKZaEZaxUjrjJbHs_VRdzF8HfrB0Avovsfcj14Wg>
    <xmx:mdkiYM2ojVv5HkVRTpkgQfRG9NBN2hpnutWKXlDO9KErLSs5EVp-hw>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id BD09C24005C;
        Tue,  9 Feb 2021 13:51:02 -0500 (EST)
Date:   Tue, 9 Feb 2021 20:51:00 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org
Subject: Re: [PATCH v2 net-next 04/11] net: bridge: offload initial and final
 port flags through switchdev
Message-ID: <20210209185100.GA266253@shredder.lan>
References: <20210209151936.97382-1-olteanv@gmail.com>
 <20210209151936.97382-5-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210209151936.97382-5-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 09, 2021 at 05:19:29PM +0200, Vladimir Oltean wrote:
> So switchdev drivers operating in standalone mode should disable address
> learning. As a matter of practicality, we can reduce code duplication in
> drivers by having the bridge notify through switchdev of the initial and
> final brport flags. Then, drivers can simply start up hardcoded for no
> address learning (similar to how they already start up hardcoded for no
> forwarding), then they only need to listen for
> SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS and their job is basically done, no
> need for special cases when the port joins or leaves the bridge etc.

How are you handling the case where a port leaves a LAG that is linked
to a bridge? In this case the port becomes a standalone port, but will
not get this notification.
