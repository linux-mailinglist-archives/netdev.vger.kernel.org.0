Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9095F87A4C
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 14:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406723AbfHIMiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 08:38:08 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:56223 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406338AbfHIMiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 08:38:07 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 64A6916F8;
        Fri,  9 Aug 2019 08:38:06 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 09 Aug 2019 08:38:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=UGpzjb
        qu0GcoMj8VDJJI+K6QugUp4Yy+CNlcDr+wolg=; b=dQRu2eiU0gxoJk4DwmQs4T
        zERL8LEHN3bycXdublQQEwhp4OzKVmQRz7IpJvmxCHSxE4Yf2MfgZnAU/3eDb8WO
        43iQsDd0JZIK4TAkIIM/XWCzShWcTR3BkY3rlo27XY3i8dPCvbANFwYqNPWVp+9X
        q0bJPcZNFXgWi5FZAvIPi5QIMONTwBarcjr8aMxzl6096l/eszx3fLwJuavU2fnC
        HVbAe/od2qNf1Biq53v2qBGGE8ZPyogKUU3kcuS+2rT3kOF/USqRSYglIfzC0bLs
        sir8YCSfsmGNZ8O/WjhaC3zMRj7E0jEzpWvmlcJ/IISs7okxPmtcalgVR5NnxqAw
        ==
X-ME-Sender: <xms:LGlNXWvZ9pJTzCuMNCWn8iUct1hPITDJ9y-YVZ6nCB2reAcz2fjeWA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddujedgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecukfhppeejle
    drudejledrkeehrddvtdelnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhes
    ihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:LGlNXVHBdBM4pSUlEITj38pWZLGYGl4VbASLxkVxwN5uSdfWDlsbyQ>
    <xmx:LGlNXeZCkgZhGVE4ZjWR3FPgqlwdrmBSjxQNOQR_ZOxQwtT5rHIk8A>
    <xmx:LGlNXR2Ye3NAhPMjTsCr4DO8GbLsWC-1q563z1cGwFyTQC9QXUr4SQ>
    <xmx:LmlNXf-PGGCFqa4PiekkwtJ3--Gk53GU-5AQrje_XCcp1PgxSF4F7w>
Received: from localhost (bzq-79-179-85-209.red.bezeqint.net [79.179.85.209])
        by mail.messagingengine.com (Postfix) with ESMTPA id 80A93380084;
        Fri,  9 Aug 2019 08:38:03 -0400 (EDT)
Date:   Fri, 9 Aug 2019 15:38:00 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nhorman@tuxdriver.com,
        jiri@mellanox.com, toke@redhat.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 00/10] drop_monitor: Capture dropped packets and
 metadata
Message-ID: <20190809123800.GA2931@splinter>
References: <20190807103059.15270-1-idosch@idosch.org>
 <745e5ab5-e254-ecd0-565a-371c5b6d0df0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <745e5ab5-e254-ecd0-565a-371c5b6d0df0@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 08, 2019 at 03:08:25PM -0600, David Ahern wrote:
> On top of your dropwatch changes I added the ability to print the
> payload as hex. e.g.,
> 
> Issue Ctrl-C to stop monitoring
> drop at: nf_hook_slow+0x59/0x98 (0xffffffff814ec532)
> input port ifindex: 1
> timestamp: Thu Aug  8 15:04:02 2019 360015026 nsec
> length: 64
> 00 00 00 00 00 00 00 00  00 00 00 00 08 00 45 00      ........ ......E.
> 00 3c e7 50 40 00 40 06  55 69 7f 00 00 01 7f 00      .<.P@.@. Ui......
> 00 01 80 2c 30 39 74 b9  c7 4d 00 00 00 00 a0 02      ...,09t. .M......
> ff d7 fe 30 00 00 02 04  ff d7 04 02 08 0a 53 79       ...0.... ......Sy
> original length: 74

Nice! I'll Cc you on my pull request so that you could submit your
changes afterwards.

> Seems like the skb protocol is also needed to properly parse the payload
> - ie., to know it is an ethernet header, followed by ip and tcp.

Yes, you're right. Will add this in v2.

Thanks, David.
