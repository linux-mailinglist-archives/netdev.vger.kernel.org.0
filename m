Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 090E751EE9D
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 17:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234867AbiEHPlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 11:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234013AbiEHPlY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 11:41:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6BB921B6
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 08:37:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 905E8B80D3A
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 15:37:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CA5FC385AC;
        Sun,  8 May 2022 15:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652024251;
        bh=kKkseH/4GiZ+mbisyxrteTvhJEqz1haap/QSwtQuZHM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=frzQcBEovWaD/jPmTEulu4FFsEyKUAcJTKy5h2AmFnxMx2dMuMM1XJg/L7ht5WsNl
         8CYAUHjdeAA3ym+yhiflIknFg0PAnoKK8/l42ATsYYpSbok1pIGg4agWgZlqf35N1C
         xgDV9Z/eKqK/zOfJss1jgnUgFLLve4VjkzTacedQ/5lCmWOOZXCgGnY2nLOdzZBCtD
         cxTsUhqYNa8TwvG0ft0rST6Bw0JEfFd2usfneMUZ6n0jufCEn0+2uEJyWmMU1FZDS2
         1TF3MPWQUn1KSNh7U49VmQxHMcpbrbwNSQ1iYDVsowq5AoowG0yCn1cyijKJ+KO0L4
         TENE1mZAgBevQ==
Date:   Sun, 8 May 2022 18:37:26 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Simon Wunderlich <sw@simonwunderlich.de>, kuba@kernel.org,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [PATCH 1/2] batman-adv: Start new development cycle
Message-ID: <YnfjtpuAaH+Zkf9S@unreal>
References: <20220508132616.21232-1-sw@simonwunderlich.de>
 <20220508132616.21232-2-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220508132616.21232-2-sw@simonwunderlich.de>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 08, 2022 at 03:26:15PM +0200, Simon Wunderlich wrote:
> This version will contain all the (major or even only minor) changes for
> Linux 5.19.
> 
> The version number isn't a semantic version number with major and minor
> information. It is just encoding the year of the expected publishing as
> Linux -rc1 and the number of published versions this year (starting at 0).
> 
> Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
> ---
>  net/batman-adv/main.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/batman-adv/main.h b/net/batman-adv/main.h
> index f3be82999f1f..23f3d53f4b51 100644
> --- a/net/batman-adv/main.h
> +++ b/net/batman-adv/main.h
> @@ -13,7 +13,7 @@
>  #define BATADV_DRIVER_DEVICE "batman-adv"
>  
>  #ifndef BATADV_SOURCE_VERSION
> -#define BATADV_SOURCE_VERSION "2022.1"
> +#define BATADV_SOURCE_VERSION "2022.2"

It is so not kernel-style. I recommend to drop this patch.

Thanks

>  #endif
>  
>  /* B.A.T.M.A.N. parameters */
> -- 
> 2.30.2
> 
