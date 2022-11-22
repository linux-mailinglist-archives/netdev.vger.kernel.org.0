Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12352633CC8
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 13:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbiKVMqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 07:46:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232729AbiKVMqQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 07:46:16 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D3965BD47
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 04:46:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 751DACE1C68
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 12:46:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA02FC433C1;
        Tue, 22 Nov 2022 12:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669121171;
        bh=Sg4Pt+6D9ion79ljDdMWSp6O0aQkXHQt9N/Wdn8Q6PE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OQLx8uG4BPS0s2jYvC8t6A7WH/21CEXUrR/cpyanwHcqEKWwGchO43XySqFE88asY
         m2KLhWalZGGf1FL7yd8JfjQ9UwVoWNq8RtQr3EQLZd9YXOzqk58EAakQdaLdPZuOlL
         +nS2n3LIx1bdNEfv/UZ0hAkJjqiDRy/VVAV5Azsf7Vx+8NCpizTXw0Hjcc0108vxZp
         hTVAUzuEIVY3wUWSJuLEWZEZe1Spp8IkYBjYA47R7W/J0zHb8lgQ/hmtVqIbZzFHPj
         jcaVq9KFOPniCHnaopjNElqLQLk9W0pxbddKKYvIM3UC1VjlwPwJUCF6Nh+USLiVz1
         IUTdqebmyVYrw==
Date:   Tue, 22 Nov 2022 14:46:06 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Yan Cangang <nalanzeyu@gmail.com>
Cc:     kuba@kernel.org, Mark-MC.Lee@mediatek.com, john@phrozen.org,
        nbd@nbd.name, sean.wang@mediatek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net v3 0/2] net: ethernet: mtk_eth_soc: fix memory leak
 in error path
Message-ID: <Y3zEjjetA1lCXvKP@unreal>
References: <20221120055259.224555-1-nalanzeyu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221120055259.224555-1-nalanzeyu@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 20, 2022 at 01:52:57PM +0800, Yan Cangang wrote:
> v1: https://lore.kernel.org/netdev/20221112233239.824389-1-nalanzeyu@gmail.com/T/
> v2:
>   - clean up commit message
>   - new mtk_ppe_deinit() function, call it before calling mtk_mdio_cleanup()
> v3:
>   - split into two patches
> 
> Yan Cangang (2):
>   net: ethernet: mtk_eth_soc: fix resource leak in error path
>   net: ethernet: mtk_eth_soc: fix memory leak in error path
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
