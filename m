Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF1521D7E0
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 16:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730062AbgGMOIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 10:08:01 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:49227 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729689AbgGMOIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 10:08:00 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 305B55C0175;
        Mon, 13 Jul 2020 10:07:59 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 13 Jul 2020 10:07:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=1u5IbW
        PmRk5LYUKDNZfqznKEBjVAi1uXDRab1eUrqGU=; b=QBgjyBlprn0prrOX2p6Tb3
        xvTaWm7UwfhM3j64CMVYPvBACUPo7UFrqacyK/UJO3Ms9J7+ZR7r+n26urvNhkL6
        zL5c93IYR0EfWpsvqzHnmtWrkq3iBbjixkrVv8kfdbhDToogZekZ9Y4WPvqByEqN
        RhC+p94inQVWdHGVjeMZOgpy8NeK+b+9QfTqUCN3mTEwBS+2vHA2m1ksQMG7HoFE
        ly4iy2qQDz+LWUrqztDybeCvc362N3DYQXix6TH7kxFXsF7JwZmBuKxS6MnSMG7L
        N3RYVVkHxxxI4XxzD2P7g9/WqZiqnlmmXQhG2Z+SUDXv0n3q81OQ/KuNKLN7UYxA
        ==
X-ME-Sender: <xms:vmoMX8_R0QnWBS63QvXBOI9PDEw279I4NnmMYwNu8i_xfJq-b_Tj7g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrvdekgdejgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necukfhppedutdelrdeiiedrudelrddufeefnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:vmoMX0troOUNJkNOYpxSo2ielxk53-dwb9rDBKngeLDSaGnQ8pA_6A>
    <xmx:vmoMXyBpN9Aoi5aWpUV9uJit4hGFQcqJwskOlidopgC7y1wBJTNTLg>
    <xmx:vmoMX8fubV4SCxxEbueXvZu_-dhyOuJlSmYBpXh2x0gknKCOFz7fSw>
    <xmx:v2oMXyoFriE8XRBqCbyEYS7yog1GYfewb9pfM2IUtmKKb6UU4sxgmw>
Received: from localhost (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id 850E13280060;
        Mon, 13 Jul 2020 10:07:58 -0400 (EDT)
Date:   Mon, 13 Jul 2020 17:07:54 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Qian Cai <cai@lca.pw>
Cc:     Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vladyslav Tarasiuk <vladyslavt@mellanox.com>
Subject: Re: [PATCH net-next v3 5/7] devlink: Add devlink health port
 reporters API
Message-ID: <20200713140754.GA238765@shredder>
References: <1594383913-3295-1-git-send-email-moshe@mellanox.com>
 <1594383913-3295-6-git-send-email-moshe@mellanox.com>
 <20200713131824.GA4489@lca.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200713131824.GA4489@lca.pw>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 09:18:25AM -0400, Qian Cai wrote:
> On Fri, Jul 10, 2020 at 03:25:11PM +0300, Moshe Shemesh wrote:
> > From: Vladyslav Tarasiuk <vladyslavt@mellanox.com>
> > 
> > In order to use new devlink port health reporters infrastructure, add
> > corresponding constructor and destructor functions.
> > 
> > Signed-off-by: Vladyslav Tarasiuk <vladyslavt@mellanox.com>
> > Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
> > Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> 
> This will trigger an use-after-free below while doing SR-IOV,

Yes. I sent a patch for internal review and I'm waiting for Vladyslav
and Moshe to review it. Will copy you once I post it.
