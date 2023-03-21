Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 899056C2C33
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 09:22:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbjCUIWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 04:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbjCUIWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 04:22:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F9EC311D1;
        Tue, 21 Mar 2023 01:22:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0478361A24;
        Tue, 21 Mar 2023 08:22:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9680C433EF;
        Tue, 21 Mar 2023 08:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679386931;
        bh=qmL5btKZB/IZvUgdpQ2K3dkSP/h1TPOeFV45YDB0j48=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iDH45JkBdnLdoWiKQ0q1CDsjmo2Siaxp3tbsD99aFYKfI0fR/+LZfvb+DYcZFHNqG
         QRGW6YTroRRsfjw5lD6xNtWKcmtXDa/xNiaH4ZVOwEEub17SIIlG9P02WZxbEkIHRY
         TfoeBeJZHyUHZedvNcORUvWs4lErCj7W9LkkxGPpXCBEh0PtdOMLaR6t8TYAKYleOY
         6KRFp0Q3vk2S9fjrBTRNIxibz6v7bsq4TZF/HYRULcMyhvAk6v6dEnp/4CtzUVgd4Z
         9STXDiBFQBYK+W4RACElN+sVwFwEZnesUvKto3u9xFFhvRwaXkOCn89MXxeqFSB4td
         cCNwYFNMvF27g==
Date:   Tue, 21 Mar 2023 10:22:06 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] sh_eth: remove open coded netif_running()
Message-ID: <20230321082206.GS36557@unreal>
References: <20230321065826.2044-1-wsa+renesas@sang-engineering.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321065826.2044-1-wsa+renesas@sang-engineering.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 07:58:26AM +0100, Wolfram Sang wrote:
> It had a purpose back in the days, but today we have a handy helper.
> 
> Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
> ---
> 
> Based on 6.3-rc3 and tested on a Renesas Lager board (R-Car H2).
> 
>  drivers/net/ethernet/renesas/sh_eth.c | 6 +-----
>  drivers/net/ethernet/renesas/sh_eth.h | 1 -
>  2 files changed, 1 insertion(+), 6 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
