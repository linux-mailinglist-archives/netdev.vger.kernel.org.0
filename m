Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE11523D6DA
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 08:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728064AbgHFGdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 02:33:45 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:53065 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726051AbgHFGdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 02:33:43 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id D8CBCC68;
        Thu,  6 Aug 2020 02:33:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 06 Aug 2020 02:33:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=xS4gG2
        hlh9g2ergD1Egjtb5Ux9RloSRe0TeE1f3tEew=; b=XtlW0JoAZwXgt3OieiB6SI
        FqGadcpMfXc+CHCgI3IWLeyyB/ZDOPUS46HJracGJtJuKb1MHx2uiGGEnTBFCX1D
        1oP94gUsVUZhoYAux3qZqbEmcLT7lRYPpeLaXpsGz7I0RAT9pJNVFT2lK+bJfW3z
        GRp24kxocWhFuZmX2z4lPrqF9jAc+obCL5iTZWMfcB3yi6Gffsnstz22fQ/62X5t
        SlKovudt7djcHH+1VSA2aouJ/wZsvSjP6XpTKXJE3N37f51jelyxZGa43xXjudTY
        TLTW1pLJ6tHakqKE/vWms1ZE5Ms9PiSC5RWnqQE8daB6toLP+pg3orDsE+CtFrHg
        ==
X-ME-Sender: <xms:RKQrXwu5Eq-3x4XFYA1IMCG_3JLMl5qTA84yswp2zBoeXpTe7OizEg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrjeelgdduuddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepjeelrddukedurdeirddvudelnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:RKQrX9fHUsUbZQPoEk9OODr-KCO4a6KiXt62_dYZUawtxQowzGonvQ>
    <xmx:RKQrX7yYXgd5iKTpyzWyEtmwmBu0CmEY70IkTus6elFLFjFmFUUCTw>
    <xmx:RKQrXzNcszpdpYUhSJO-VijeDuZYq0fC71CAgPg5b7Woeb5OqdWnLQ>
    <xmx:RaQrXzIaP1KnPXpz15zsSeCV7U2w1RV7vA8v9LlyZ8RijR5Qh785Rw>
Received: from localhost (bzq-79-181-6-219.red.bezeqint.net [79.181.6.219])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1D81F30600A3;
        Thu,  6 Aug 2020 02:33:39 -0400 (EDT)
Date:   Thu, 6 Aug 2020 09:33:36 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Swarm NameRedacted <thesw4rm@pm.me>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: Re: Packet not rerouting via different bridge interface after
 modifying destination IP in TC ingress hook
Message-ID: <20200806063336.GA2621096@shredder>
References: <20200805081951.4iznjdgudulitamc@chillin-at-nou.localdomain>
 <20200805133922.GB1960434@lunn.ch>
 <20200805201204.vsnav57fmgqkkpxf@chillin-at-nou.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200805201204.vsnav57fmgqkkpxf@chillin-at-nou.localdomain>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 05, 2020 at 08:12:08PM +0000, Swarm NameRedacted wrote:
> All fair points, I'll address them one by one. 
> 1) The subnet size on everything is /16; everything is on the same
> subnet (hence the bridge) except for the client which sends the initial
> SYN packet. Modifying the destination MAC address was definitely
> something I overlooked and that did get the packet running through the
> correct interface. I got a bit thrown off that the bridge has it's own
> MAC address that is identical to the LAN interface and couldn't
> visualize it as an L2 switch. However, the packet is still being
> dropped; I suspect it might be a checksum error but the only incorrect
> checksum is TCP. Might have accidentally disabled checksum offloading. I'm not
> sure

You might need to enable hairpin on eth0:

# ip link set dev eth0 type bridge_slave hairpin on
