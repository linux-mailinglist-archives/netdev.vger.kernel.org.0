Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCD483A1C81
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 20:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbhFISJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 14:09:34 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:54675 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229507AbhFISJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 14:09:34 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 0DED95C0172;
        Wed,  9 Jun 2021 14:07:39 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Wed, 09 Jun 2021 14:07:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=+57D/J
        g6bs5+SePgby7diY3f/m6igTC7E5KydLDWcpY=; b=pNhGePw7HHHJ6tkEFRNkb8
        EPXbu4ikycdCr4Zn4KzARv/158Eyd1Qpn63cKxqDB48X3TxkPRcdO8xtX3Rq65Ec
        KcoM8FA0Z59492Raqo3J3g8l4BFWHkLnKxJMe7mYHCDXnbsfw3+ZNESoDJCj++Yv
        sU1S+T+qTMSUF1ZKWZyJCjphi5fcOgIqcdz20Xjualk1CnZXmA/8okqlb+e9bL7T
        tTRmDZe+w1xD9K1UQsxo1iP5ymTBh5c10wAtlXv2L6OMlRq109sd6at8tRCcDyGv
        Vsz/vESWcUTDmxMNIUKyNEVwogSqRBZ2l9mlZv6+tplelXd1Kq5X7TOGZil2YyJA
        ==
X-ME-Sender: <xms:agPBYHgE-6daaucP9ddIsIFjrldY06Jo2Y2TiIjHEKxyfU9otDy6fA>
    <xme:agPBYEDTeoLfn4qF1iuSecNb8vlzs1HSh2UCg5ZvckxBRnjwMzwLNRSjAJT255ODq
    H9PAxtiOW1ptpE>
X-ME-Received: <xmr:agPBYHHKdx5l27i63uI96-P86z0xKm-BX7PQlscOBDNmnb6BCDZ9RaKrwHj0zbKULQ9UdkK5rm63X1JbTwAmwy4HDBUEvQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeduuddguddvtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:agPBYEQk8nuMHWKJaProS05nVesYi_PBPpWsSegA3mxPBv9olWxQUg>
    <xmx:agPBYExNovX8LbrH7cPSKcEhWKpt2FSYv9PmDGcs7b99q1NILGjKyQ>
    <xmx:agPBYK7NgxLrEw-rzTFgoj0M1OoPJTpM5-p9f2DjE-DtKxq_sKYxfQ>
    <xmx:awPBYHytP8KkEsIhKlM3oIIXBm2X9q5qkbUrIpZxOi0F21Xz4Q9VpQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 9 Jun 2021 14:07:38 -0400 (EDT)
Date:   Wed, 9 Jun 2021 21:07:35 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Colin King <colin.king@canonical.com>
Cc:     Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mykola Kostenok <c_mykolak@nvidia.com>,
        Vadim Pasternak <vadimp@nvidia.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] mlxsw: thermal: Fix null dereference of NULL
 temperature parameter
Message-ID: <YMEDZ4/7atRSTcOL@shredder>
References: <20210609175657.299112-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210609175657.299112-1-colin.king@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 09, 2021 at 06:56:57PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The call to mlxsw_thermal_module_temp_and_thresholds_get passes a NULL
> pointer for the temperature and this can be dereferenced in this function
> if the mlxsw_reg_query call fails.  The simplist fix is to pass the
> address of dummy temperature variable instead of a NULL pointer.
> 
> Addresses-Coverity: ("Explicit null dereferenced")
> Fixes: 72a64c2fe9d8 ("mlxsw: thermal: Read module temperature thresholds using MTMP register")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>

Thanks
