Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 676C12029B8
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 10:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729586AbgFUI6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 04:58:01 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:42979 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727119AbgFUI6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 04:58:01 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id D01DC580558;
        Sun, 21 Jun 2020 04:57:59 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 21 Jun 2020 04:57:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=3K9ian
        o7tc8WbAJhJfY4t6jSmakbtH+Y8CHBQa0fNnw=; b=l4HUFNhb1v2HRiDTe23lB5
        0XOyRciYS4gcBXy7LcMABmWTuWyJEbcAEGYWul8+/dyW4K28jxPE1klJ8dIfjXEm
        5TaJ26ZtR73LbnveBHA2jNvQdNS1vo9qAfqnt0RNDQ3FWcTHAc+H5phcjtW55V21
        oJ/ViCwKvaIqQEbEHYV8r4frGkiL7+MD0SGXpzEsXpMWCmshEOfLAVwDFH0XM/3c
        wVjJTebZJ6QsTWsMVlDAjGqGTerwa1VhYxJBaYH4o1i7/m5GRD5aHyGPVbu2tT8f
        B4GOaY7HhsKeForq9SRzvSu3heR+42fEwbAqu/0qDe7BzjEoErXGgGcOesnluIag
        ==
X-ME-Sender: <xms:FiHvXpdClLbNOsA4PBqFU3IGPcq2nfyr12QnW5irm8qOlnIh8DHgiA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudektddgudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepuddtledrieejrdekrdduvdelnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:FiHvXnMgHo6MV0wyqDBEFGdQoMa8lg3UFwPitmnH5YMb9cqX0ZKGSQ>
    <xmx:FiHvXih7Xy8khsJHGldw_5_e7IKSkM47IkUPxazEFUZ5TmciPCnJVA>
    <xmx:FiHvXi_MEHJVMKVKvOJlRR5paFj3J9sTKlKZUeQIN-iyZXQePxjkvA>
    <xmx:FyHvXmnN64E_HoygGKo3FVQhdWw6undwN8IXkhfGXus18Pv9R6GRqA>
Received: from localhost (bzq-109-67-8-129.red.bezeqint.net [109.67.8.129])
        by mail.messagingengine.com (Postfix) with ESMTPA id EC1F73066CFF;
        Sun, 21 Jun 2020 04:57:57 -0400 (EDT)
Date:   Sun, 21 Jun 2020 11:57:55 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>
Subject: Re: [net-next 1/6] net: marvell: prestera: Add driver for Prestera
 family ASIC devices
Message-ID: <20200621085755.GA477536@splinter>
References: <20200528151245.7592-1-vadym.kochan@plvision.eu>
 <20200528151245.7592-2-vadym.kochan@plvision.eu>
 <20200530154801.GB1624759@splinter>
 <20200601105013.GB25323@plvision.eu>
 <20200603092358.GA1841966@splinter>
 <20200620125639.GA6911@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200620125639.GA6911@plvision.eu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 20, 2020 at 03:56:39PM +0300, Vadym Kochan wrote:
> But it will look same as prestera_destroy_ports(), do you think
> this is not a problem to have a same logic doubled ?

No, error paths of init() usually share logic with fini(). The benefits
of being consistent, always having init() followed by fini() and making
sure they are symmetric, out-weigh the benefit of saving a few lines of
code.
