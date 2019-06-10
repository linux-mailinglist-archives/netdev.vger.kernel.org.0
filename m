Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05BE83B69A
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 15:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390627AbfFJN6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 09:58:53 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56857 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390587AbfFJN6x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 09:58:53 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 4FB6721E95;
        Mon, 10 Jun 2019 09:58:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 10 Jun 2019 09:58:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=BiZGHM
        plLnW8EXEEoCwq8ufJf39ejwvt7uPie6geQSM=; b=Z8n6CzX0lkMsldirbIU/PN
        VLBRpUDkrDSkK4cFEUMBVRo/vgbJhgFs2NP8/IkLVk6LR5NXRChGQy4ur0BzGJmR
        R44Sqp1iXf/UHLohWFicfNP1kR5Jhv7U1W5nSzEsTrn2gYadPJS+vVjsc6CdmlNl
        QbdTN9gL9hErRAfbJrTrB6n/PElQA/GkjHevStIZkhoHQd+bFF3zsXlao5eQufIT
        04xAlAikQSFwyVEN9PFKOBPTjt/G1h/ErGK5h4c8dcJUNM+/0qarc9JvNZf/mcxw
        pYMZ20Yk9rDampsPSLLel9aE32MacmxuWz6xhQphRgOyozpm8xw77UneqB/Cmxkw
        ==
X-ME-Sender: <xms:GmL-XCstSh2M-z1LWHWIDppUwLZELQDLhVxvLjKOtViHYPQ75k2uoA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudehvddgjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecukfhppedule
    efrdegjedrudeihedrvdehudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghh
    sehiughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:GmL-XFTr7ePOF0HP_2s1hOHdMTaF_zo71N2WPSz7A9kKmeCWXWOjxg>
    <xmx:GmL-XIPga0ST8ztZq2yXQ9VWREx17UdlZskDZMQG1n9sRRKgZaDeLQ>
    <xmx:GmL-XKaX_u4inD56GsPEvwEUDn5NJAISM-thTzyMyrIg1vw2SM1m7A>
    <xmx:HGL-XJHumOG26chiVnGMvYaZunsRmuBUE-s2n0pt9Jeeqo58EgAaoQ>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id C6F0180060;
        Mon, 10 Jun 2019 09:58:49 -0400 (EDT)
Date:   Mon, 10 Jun 2019 16:58:48 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, amitc@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 3/3] selftests: mlxsw: Add speed and
 auto-negotiation test
Message-ID: <20190610135848.GB19495@splinter>
References: <20190610084045.6029-1-idosch@idosch.org>
 <20190610084045.6029-4-idosch@idosch.org>
 <20190610134820.GG8247@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610134820.GG8247@lunn.ch>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 10, 2019 at 03:48:20PM +0200, Andrew Lunn wrote:
> > +		# Skip 56G because this speed isn't supported with autoneg off.
> > +		if [[ $speed == 56000 ]]; then
> > +			continue
> > +		fi
> 
> Interesting. How is 56000 represented in ethtool? Listed in both
> "Supported link modes" and "Advertised link modes"?

Hi Andrew,

Yes. We recently sent a patch to error out if autoneg is off: Commit
275e928f1911 ("mlxsw: spectrum: Prevent force of 56G").
