Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 606E81E3CF1
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 11:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388412AbgE0JAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 05:00:17 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:60345 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388251AbgE0JAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 05:00:16 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 7B9615C01A7;
        Wed, 27 May 2020 05:00:15 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 27 May 2020 05:00:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=3ZRtiX
        lcFQeWgLraPyBZ52n+2xUg/Eap8AOdNZJnsiM=; b=kpVwA1ooWMY1GERAeJ1I4i
        NKmF3C7XjF1Qfzufdga2X0bvgpskSXp+zOx6hQK6BYL71jzG5WO7EOFXWoetrv9I
        pNuCuVz/l4Swic9Vj8ZWKJQn1Uu02uaSjISgVkLPb+iyFZ/MWXGc5da5eS2L7rJ8
        1E8gKfgUsRkkCkEyFlOlXZIjFg086i2DuqcEYZUWcmsOpF4JIqly3ThvgrjbSRaM
        PC/2uFSsqKNoBllLv5L/hH2/GGrEMh6vX/84Bs93wEsmnQStUEftJvRjegy0LLGp
        TTX9PFKWupf8atAyLobnHEWkNhSfy7Pc3tmXfg3hL2/Ko1Hdn76mxe7kuGxQ37DQ
        ==
X-ME-Sender: <xms:HyzOXhxHULXxQXP6jVh68lamNyyVSAOXBOJC-l_JAj3KY0zU6zLrsg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvgedgtdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepuddtledrieehrddufeelrddukedtnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:HyzOXhSL13DQuGBmZ3vRvkBnO3sH_4HilU2Dx85_iRmrt1OWZSBe2w>
    <xmx:HyzOXrWHijhxf3VgC_WQMoG8QES7eW0NpFTl7JQJRKceG7qXSRYYTw>
    <xmx:HyzOXjjSp97FHIN8OtlOnU5ew1Q2cow-3wCvQhzN7TDiov5QK2-UsA>
    <xmx:HyzOXqNqBn1FTq_h8yiTPYIPPe-eB58tIGdKuqnqTy-8f1gBj4E2WQ>
Received: from localhost (bzq-109-65-139-180.red.bezeqint.net [109.65.139.180])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8F65C3060F09;
        Wed, 27 May 2020 05:00:14 -0400 (EDT)
Date:   Wed, 27 May 2020 12:00:11 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Colin King <colin.king@canonical.com>
Cc:     Jiri Pirko <jiri@mellanox.com>, Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][V2][net-next] mlxsw: spectrum_router: remove redundant
 initialization of pointer br_dev
Message-ID: <20200527090011.GA1519147@splinter>
References: <20200527081555.124615-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200527081555.124615-1-colin.king@canonical.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 09:15:55AM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The pointer br_dev is being initialized with a value that is never read
> and is being updated with a new value later on. The initialization
> is redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Reviewed-by: Ido Schimmel <idosch@mellanox.com>

Thanks
