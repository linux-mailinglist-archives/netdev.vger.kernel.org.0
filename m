Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B63103ECEAF
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 08:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233444AbhHPGkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 02:40:32 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:35153 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230442AbhHPGkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 02:40:31 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 4245A58042A;
        Mon, 16 Aug 2021 02:40:00 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 16 Aug 2021 02:40:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=6XXJ5r
        tCyGduq0Yu39Vt8fIWGZkz1E0tbLgO3BCRQic=; b=LsqtfPuXLwiz5Gz0UX2YNG
        9mNrjrnqlDnxVZmT68LIf/ynJxAtS591peoszFYqrpUDmtBKEg8gyYxIH2p3e6H7
        ngGw9vN/fttjOJCBU6n1peu2DD/aFmxbcc3vJ+BCRHl8yOjgGpwYwvboopQ2vjEj
        AHMPjvM8S5dIvm8tZYtkHiFOZDrafPSeqmSbrii909GYEM8TLDRN78UYRXM0NJum
        OuZ43X59+Kz4ZGEhBpsAsIQnRCyiS0vI6WN8Fng2YTFIxwbHWqT1levyu4sFAASp
        krnzxZi7cs/7R4WQnK3spa7N5BWsBtJUWs+8OnU+XeNl8RP2us91mEempPW2fyPA
        ==
X-ME-Sender: <xms:PggaYZHiy6fy0uExBARmwpKQSFVdurnP7QP6gWXy-olPcs0FKvOZqQ>
    <xme:PggaYeXZ_4LA4kbVUTVg8nW5jduZEAENqVEJnif6UO-WzroESI84VEa2TMR03O2k4
    Oiwch96DyBF_YM>
X-ME-Received: <xmr:PggaYbLcLxF2H1tUm4_JNutdZ21UsVIStWqefZBPuuaCFBw_yxjD97yNyWJVPcJtEDyX4KPf47pGLdyehKyvos6C2TVOKg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrledtgdduudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:PggaYfFPpGac4rvFR_zcG-SneBiTsQN8HwOL3Z2JCsm5Kr9M-yQ02Q>
    <xmx:PggaYfVTOEA9mnk5QQCDdj8ZrTbphJnKR0OyKFbZNdhL00KMtz-rXA>
    <xmx:PggaYaN5LFDDkPOlV-eDfUJSRAirld7eeF2S9zOeVm-daUZ9HDe9Xw>
    <xmx:QAgaYYXepFTG9nfysiNaxQ43Tn1JDz6m4WeqElpsavv-gaq6FsvcNg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 16 Aug 2021 02:39:57 -0400 (EDT)
Date:   Mon, 16 Aug 2021 09:39:53 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [RFC PATCH net-next] net: bridge: switchdev: expose the port
 hwdom as a netlink attribute
Message-ID: <YRoIOTMsXClsJ06G@shredder>
References: <20210812121703.3461228-1-vladimir.oltean@nxp.com>
 <YRU/s7Zfl67FhI7+@shredder>
 <20210812161648.ncxtaftsoq5txnui@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210812161648.ncxtaftsoq5txnui@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 12, 2021 at 04:16:48PM +0000, Vladimir Oltean wrote:
> On Thu, Aug 12, 2021 at 06:35:15PM +0300, Ido Schimmel wrote:
> > Makes sense to me. Gives us further insight into the offload process. I
> > vaguely remember discussing this with Nik in the past. The
> > hwdom/fwd_mark is in the tree for long enough to be considered a stable
> > and useful concept.
> > 
> > You are saying that it is useful to expose despite already having
> > "switchid" exposed because you can have interfaces with the same
> > "switchid" that are not member in the same hardware domain? E.g., the
> > LAG example. If so, might be worth explicitly spelling it out in the
> > commit message.
> 
> Indeed, the "switchid" is static, whereas the "hwdom" depends upon the
> current configuration. So it is useful as a debug feature for the
> reasons you mention, but I am also a bit worried whether we should
> expose this now, since I am not sure if it will impact future redesigns
> of the bridge driver or switchdev (the hwdom is a pretty detailed bit of
> information). Basically the only guarantee we're giving user space is
> that a hwdom of zero means unoffloaded, and two non-zero and equal
> integer values can forward between each other without involving the CPU.
> The numbers themselves are arbitrary, mean nothing and can vary even
> depending on the port join order into the bridge. That shouldn't impose
> any restrictions going further, should it?

Not that I'm aware. On the other hand, I didn't see a pressing need to
expose this attribute either so we can wait a bit longer to gain more
confidence if you want.
