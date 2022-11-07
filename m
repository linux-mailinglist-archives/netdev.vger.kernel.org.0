Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E244161EC7D
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 08:54:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbiKGHyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 02:54:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231378AbiKGHyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 02:54:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8831C13E9B
        for <netdev@vger.kernel.org>; Sun,  6 Nov 2022 23:54:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28706B80E19
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 07:54:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D97BC433C1;
        Mon,  7 Nov 2022 07:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667807645;
        bh=4i2O5JJ1QiNuhw1wMEWnXWWxuTHBkjmjjAezmrxcXuk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VWDiaeFoqbIyPAek4tFSTBE03ISRKgGLSL2gxQZyiwaVZD3dGab3nKTXV0bA1qWDP
         QruMp76+K5yLI3/5sYCr8VivlFM6m1gt+mksEP86N6PugPVYOX2h9L6X89oIxaZanq
         hGY4y0YQm7cLRLSBKqGtMiqHjEb7gq8jwAK/v72UbxAC2OHIwn3Aw0yZRg8Dnkp0PU
         wmhVrEIhDt91aFwewiSpymoaiBDza18BvIPjs9HXvM2nNSA+QUWcEf0QTj2VlY34+A
         O0Akzu8cuvjDtHRdaEJON/MEQ+2kaCNP+BrKKnaiuZscuEKBOs77lM2/k0RU5DKkU0
         WRDmqmvcW75OQ==
Date:   Mon, 7 Nov 2022 09:54:01 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        bgolaszewski@baylibre.com, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
Subject: Re: [PATCH net] net: ethernet: mtk-star-emac: disable napi when
 connect and start PHY failed in mtk_star_enable()
Message-ID: <Y2i5mc04/XDfNqAs@unreal>
References: <20221107012159.211387-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221107012159.211387-1-shaozhengchao@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 07, 2022 at 09:21:59AM +0800, Zhengchao Shao wrote:
> When failed to connect to and start PHY in mtk_star_enable() for opening
> device, napi isn't disabled. When open mtk star device next time, it will
> reports a invalid opcode issue. Fix it. Only be compiled, not be tested.
> 
> Fixes: 8c7bd5a454ff ("net: ethernet: mtk-star-emac: new driver")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  drivers/net/ethernet/mediatek/mtk_star_emac.c | 2 ++
>  1 file changed, 2 insertions(+)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
