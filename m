Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB7DA438F91
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 08:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbhJYGjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 02:39:10 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:54713 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229823AbhJYGjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 02:39:09 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 344705806A7;
        Mon, 25 Oct 2021 02:36:47 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 25 Oct 2021 02:36:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=3jaAj+
        gBSUpvJ7BuI4E8o6kxGEsZFrotiqAwq1+dtoQ=; b=GY03+DJHQ0KK/9zk6QGX4w
        NzGmVIJxoXYjoWhI3ryE+cuRIKjaFHvFMtNLzqQSmGFIenqXwJ1DA1p4E62VLN9O
        iTRhCaQBc3bRASnzP5b9m34CNcJMxl3ysF5VAY3e0YYhpDo1niRuPQaNTrJzF35q
        iB0Db2+PKD7UhT8yK8+0NFeC5Of+3juPppBQV+8On73S3bNJIQpfy1rMmZLpn4io
        uz3hx2feifYrcWQVUVCWPauikYWXdXflwpxWpsAFIfK0aC4IbPc04o//0nCeP+zp
        UoOIiEUjZC7aRFbW0pNA+sgIuYE6iWZ2mUulU70cTMT5BwHgmlxyB94dxYc+KMRA
        ==
X-ME-Sender: <xms:fFB2YQbVNIq2Wo6eUMY0IvAfWoJ0ZYzHcLZXbHDn_uVsOj5HkAks4A>
    <xme:fFB2YbYzYC1V0fZ27o3p_kyXdKf7oHUp6Ul9eykk6MU-l9wcyfWVPEdMjFD_3ylW8
    fhKSDHaGCCYLUA>
X-ME-Received: <xmr:fFB2Ya_gkzeQ_cxPcnTKi08ZUx7E1nvJjQHmd4vLNbrO5dFEnZx94FWrUCyVGmcbzaLa9jYD8pXTSqRjGBMgBpzjPf4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdefgedguddtjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:fVB2YapQC673689NWqhkV9HBUaySV-5bLYkUUN14Q-JtWFKSBckAnw>
    <xmx:fVB2YbrYRUozKI8NqY74RCGByPzy0akaVDqGdeA1ADDCzvzBQoNu6w>
    <xmx:fVB2YYT_0vj908vLcl2cDVyra8afh30h62_oYkS-K5w32Bx4UfwE6g>
    <xmx:f1B2YW8hwtun6c8jUIMiei66wXgzqhWZThhIMKzrkv9bmoYSwnfrbA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 25 Oct 2021 02:36:44 -0400 (EDT)
Date:   Mon, 25 Oct 2021 09:36:41 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        UNGLinuxDriver@microchip.com, DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        John Crispin <john@phrozen.org>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        Egil Hjelmeland <privat@egil-hjelmeland.no>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Guillaume Nault <gnault@redhat.com>,
        Po-Hsu Lin <po-hsu.lin@canonical.com>
Subject: Re: [PATCH v5 net-next 09/10] selftests: lib: forwarding: allow
 tests to not require mz and jq
Message-ID: <YXZQedit6YT4ivVo@shredder>
References: <20211024171757.3753288-1-vladimir.oltean@nxp.com>
 <20211024171757.3753288-10-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211024171757.3753288-10-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 24, 2021 at 08:17:56PM +0300, Vladimir Oltean wrote:
> These programs are useful, but not all selftests require them.
> 
> Additionally, on embedded boards without package management (things like
> buildroot), installing mausezahn or jq is not always as trivial as
> downloading a package from the web.
> 
> So it is actually a bit annoying to require programs that are not used.
> Introduce options that can be set by scripts to not enforce these
> dependencies. For compatibility, default to "yes".
> 
> Cc: Nikolay Aleksandrov <nikolay@nvidia.com>
> Cc: Ido Schimmel <idosch@nvidia.com>
> Cc: Guillaume Nault <gnault@redhat.com>
> Cc: Po-Hsu Lin <po-hsu.lin@canonical.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
