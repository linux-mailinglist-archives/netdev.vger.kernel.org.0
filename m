Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0833B232F6D
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 11:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729350AbgG3JV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 05:21:59 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:52473 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726819AbgG3JV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 05:21:59 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 037515C005A;
        Thu, 30 Jul 2020 05:21:58 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 30 Jul 2020 05:21:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Azs/jj
        8Elw8jISiMzkP2/GILjWe9/10d6C2mwH/LP4E=; b=G6an2bnKsRvaRoBvDhP9QK
        Xsp63ezloczInWVcPW2wt7zzoEGlYEbfOw8S8nq0ikV6TCRdteK1glrJxQ6wDHIH
        zgm1+wlhLL3GEucVvMR5iz7wnFvK6BO55il6RT8l3q/9uxwfdLnJXQk32YT8yEmy
        DUkCoQGjP7VWObB0ZA4K3WGHV/oF/wNtru+p5nji7bAM+HdglzKqi/+K+AVmx14s
        4VnRDzwjuym6OLys9BCHZnfw3k00FNUmVDKxztlrzJDs97Vz0w5+ljWZCkBqnyWU
        zNrth9vB37g2/jq90wuXNCnv7q8w1QyE+yrGr6fxqsZHzwapo5ML18OqPQ4TmjJA
        ==
X-ME-Sender: <xms:NZEiX5N-UHK26dzIDZw0vQTiyqqruKN8e3y2X9mh7SS09DIYWE2fNg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrieeigdduhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necukfhppeejledrudekuddrvddrudejleenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:NZEiX78SeG8EoMple3_xuR6pHiKhvC-IbikX1xvE9u6gkQSRo_Gm9A>
    <xmx:NZEiX4TtazjF4LOFlQ_XCeXZfp6XYh3oJ5nxNP86iMSz5xGck-nyoQ>
    <xmx:NZEiX1sl7K_09GMDl02JbuNo7siw_-bhv4YDKe7bwRqav9-U2v5Udw>
    <xmx:NpEiXyqHL2AJQwOFXgDNrtydJ1zcCKpsyMAmhzBryTuyqd6HFxIecA>
Received: from localhost (bzq-79-181-2-179.red.bezeqint.net [79.181.2.179])
        by mail.messagingengine.com (Postfix) with ESMTPA id 314E7328005E;
        Thu, 30 Jul 2020 05:21:57 -0400 (EDT)
Date:   Thu, 30 Jul 2020 12:21:53 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Jiri Pirko <jiri@mellanox.com>, Ido Schimmel <idosch@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] mlxsw: spectrum_cnt: Use flex_array_size() helper
 in memcpy()
Message-ID: <20200730092153.GA2182419@shredder>
References: <20200729225803.GA15866@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200729225803.GA15866@embeddedor>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 29, 2020 at 05:58:03PM -0500, Gustavo A. R. Silva wrote:
> Make use of the flex_array_size() helper to calculate the size of a
> flexible array member within an enclosing structure.
> 
> This helper offers defense-in-depth against potential integer
> overflows, while at the same time makes it explicitly clear that
> we are dealing witha flexible array member.
> 
> Also, remove unnecessary pointer identifier sub_pool.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Ido Schimmel <idosch@mellanox.com>
Tested-by: Ido Schimmel <idosch@mellanox.com>

Thanks
