Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8524B49C4C9
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 08:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238080AbiAZHyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 02:54:38 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:52711 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229840AbiAZHyi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 02:54:38 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 51A415C011C;
        Wed, 26 Jan 2022 02:54:37 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 26 Jan 2022 02:54:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=SKGS1zEnaV0fvTDM6
        ntgjxIzlGVxcG6al568ySb0rQM=; b=PK0ydKVjyuytKIpayMC5aLszd6KWSoPnq
        ik3Lmmw+K8hvaq5rvAa3l4uBcNxr8SWg9AiqFKwKRicVCvmkY8zH67gZtyOPo5T0
        38ppC+lDHYV2FS0BXSoi8Ws/lVac1zucxpqvOVCdIQaZdMHr4ltskAJZWB0uNdd0
        qyBZ22Q0mzJMHNNIp9bi/y54cMwtJHQp5CN/lIiVTWHafXV7YHFXvGY6E63RPIpM
        l1M7UvPGiR6TKr+KRga7IkQ2RMzYfXpbvzk7oXhEkNxfDUBmko6Ete1UY1hYtiFq
        CXZZ0zinCuqgiBSLD5MmKYVs0fLlushw7WmFZlKa8Q6O036Cz85sg==
X-ME-Sender: <xms:Pf7wYUfku9RBU_jvEjoWD3mfQjo_5J8mBRMLPbCkynmxjR3vAZ0xKQ>
    <xme:Pf7wYWMYgq5Mj8r3v92-GcPxEGiGiZbPvAyN0MHZ_tw-V7PAMWWEh4bVfTX9lF6dw
    cS8nvm_N0qCT9Q>
X-ME-Received: <xmr:Pf7wYVis8XsFlx8Elktwm0_ooLTod0uMyacKYcXo1kgrFSr6uKhbJ26ncwbJOplu0iMTjOx6rb0q5nSBjN9kKJsyBtY5sg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrfedtgdduudehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpeehhfdthfduueehgfekkefhhedutddvveefteehteekleevgfegteevueelheek
    ueenucffohhmrghinhepghhithhhuhgsrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:Pf7wYZ_dwFxsSiZx2SvkEwpzenhfU5SaEKUePuhtQwT8GSf7CKcbRw>
    <xmx:Pf7wYQv7EjI_HRa2poIfDSlQD1b4Cj9kHYRkNHcz0yONAGjRmLF3kQ>
    <xmx:Pf7wYQFiq9hgd7-rDlzQMDZDyGz0krQ6Sns0ER7ZHB3mD4tp1TYUdg>
    <xmx:Pf7wYaUMW7E6H53zZuYUflAs3yF1h-xf0D5HaTOVshyaNwlKMwwh6A>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 26 Jan 2022 02:54:36 -0500 (EST)
Date:   Wed, 26 Jan 2022 09:54:32 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] mlxsw: spectrum_kvdl: Use struct_size() helper in
 kzalloc()
Message-ID: <YfD+OCLziDeuDr8R@shredder>
References: <20220125170128.GA60918@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125170128.GA60918@embeddedor>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 25, 2022 at 11:01:28AM -0600, Gustavo A. R. Silva wrote:
> Make use of the struct_size() helper instead of an open-coded version,
> in order to avoid any potential type mistakes or integer overflows that,
> in the worst scenario, could lead to heap overflows.
> 
> Also, address the following sparse warnings:
> drivers/net/ethernet/mellanox/mlxsw/spectrum1_kvdl.c:229:24: warning: using sizeof on a flexible structure
> 
> Link: https://github.com/KSPP/linux/issues/174
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>

Thanks
