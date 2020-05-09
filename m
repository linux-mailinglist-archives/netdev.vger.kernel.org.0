Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B80851CC423
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 21:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728340AbgEITc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 15:32:29 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:45567 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727938AbgEITc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 15:32:29 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 24FCF5C0004;
        Sat,  9 May 2020 15:32:28 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sat, 09 May 2020 15:32:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=MaSnVBPSxxLeNG0GhsY+3wa6qXbJVePJ8Dk9XGTRc
        0U=; b=ujZg6vzYO2PFtiqHkxnZ5o5SIOVKrqDyXZ/NNdgtdMc6OSMjOWIiL5Mn0
        p58qvCARapq1DkuwhCkxHeZcaj+D4VuIk+nrh96ME9lDltHyf2pobzWGFHJgFNs+
        lRoCvlnw5hRUyELnmLIIK3uzfZuN7/aO8Cu63U0943RHaFdm2CGitI9jmU5Bw6pi
        5vG56Rmpp6dOfHAjygk8x67CqnQ1TJhHG65B9d686Cw8Gx0G6zsXHzcU9m15nemK
        cm6YFxxg9KSzMEHop9RdbSXNIr4CQcOfliJMEG9kD0x8E5qi+1IBYlgEAmBcymWE
        AFh6wt5ZeTUlZGiSGZ8DDQmJAdLsw==
X-ME-Sender: <xms:SwW3XmZbqtIFKIpDNHzbWnekK3iJcz5mw61Odq48KxYB4Clohb9_yA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrkeehgddufeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtjeenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepteekvdfgkeevueetudelkeefveeltdevjeegvefhiedvuedvieduffejvdel
    fefgnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghdpnhgvthguvghvtghonhhfrdhinh
    hfohenucfkphepjeelrddujeeirddvgedruddtjeenucevlhhushhtvghrufhiiigvpedt
    necurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:SwW3XkKf2s6MafhmPT2UazOx2ad1U-uzTcQXtjAhczF-5kXO7xDWEw>
    <xmx:SwW3Xv3qpZdIYv_1lR4vC3LNsYOIjtZuWp-RqXAHnFdGOcHcB5Ju7w>
    <xmx:SwW3Xva0SEYcZT0V9MO_n0BuBuRX-mbx_xkMDlGVbsyw9gYe_A1eQw>
    <xmx:TAW3XhZUq2Hd88vFprD_MuvPPDxKE-PTSy-KMkbrnF2YeGwR9Ib7qQ>
Received: from localhost (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 96F3F328005D;
        Sat,  9 May 2020 15:32:27 -0400 (EDT)
Date:   Sat, 9 May 2020 22:32:25 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>
Subject: Re: [PATCH] net-icmp: make icmp{,v6} (ping) sockets available to all
 by default
Message-ID: <20200509193225.GA372881@splinter>
References: <20200508234223.118254-1-zenczykowski@gmail.com>
 <20200509191536.GA370521@splinter>
 <CANP3RGftbDDATFi+4HBSbOFEU-uAddqg2p8+asMMRJtgOJy6mg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANP3RGftbDDATFi+4HBSbOFEU-uAddqg2p8+asMMRJtgOJy6mg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 09, 2020 at 12:17:47PM -0700, Maciej Żenczykowski wrote:
> Argh.  I've never understood the faintest thing about VRF's.

:)

There are many resources that David created over the years. For example:

https://www.kernel.org/doc/Documentation/networking/vrf.txt
https://netdevconf.info/1.1/proceedings/slides/ahern-vrf-tutorial.pdf
https://netdevconf.info/1.2/session.html?david-ahern-talk

BTW, in the example it should be:

ip link set dev veth-blue up master vrf-blue

Instead of:

ip link set dev veth-blue up master vrf-red

(Obviously)
