Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6720E642F00
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 18:42:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbiLERmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 12:42:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbiLERmF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 12:42:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A5A513CCB
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 09:42:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A12B61280
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 17:42:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F193C43146;
        Mon,  5 Dec 2022 17:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670262123;
        bh=HUvXXPySnmgJs4So8nvqneqZ8dOcoHGWjpwV2GIFH70=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UTJ/oR+8yLOTm4JGOs0E1JDWZitESkEkbYBZwW4Qyu2tMN4AcKCHNOJeFlalZjMnj
         murD1unxoNbPM+D9ENQ/scUTVBEUp51fLLq5kvfPXAvZEdsQlwxrmKP4qK2WOlUd1E
         jGBY4O8/QwT4Qy1+Q6VnVON3Q/LjbQUK8uSZFi86y+5UWdxw/xusOyC6+L8TSoLAue
         wWW9TKl+0mRlpjyVLemVV1jM46Yt2i5MFAZDGmUH8ga09SDQs38Ql2aw+7N3qWXbo7
         HAGMPzZd2l4UMgdbfx9XkHAt7RlCi2FmX3F7ERXzHrRtHbLYffoQPGYTr3ujZ4iolz
         9tXyJ21MwnSIw==
Date:   Mon, 5 Dec 2022 19:41:58 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        sujuan.chen@mediatek.com
Subject: Re: [PATCH v2 net-next] net: ethernet: mtk_wed: add reset to
 rx_ring_setup callback
Message-ID: <Y44tZlaHPdJhXCGd@unreal>
References: <29c6e7a5469e784406cf3e2920351d1207713d05.1670239984.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29c6e7a5469e784406cf3e2920351d1207713d05.1670239984.git.lorenzo@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 12:34:42PM +0100, Lorenzo Bianconi wrote:
> This patch adds reset parameter to mtk_wed_rx_ring_setup signature
> in order to align rx_ring_setup callback to tx_ring_setup one introduced
> in 'commit 23dca7a90017 ("net: ethernet: mtk_wed: add reset to
> tx_ring_setup callback")'
> 
> Co-developed-by: Sujuan Chen <sujuan.chen@mediatek.com>
> Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
> Changes since v1:
> - update commit message
> ---
>  drivers/net/ethernet/mediatek/mtk_wed.c  | 20 +++++++++++++-------
>  drivers/net/wireless/mediatek/mt76/dma.c |  2 +-
>  include/linux/soc/mediatek/mtk_wed.h     |  8 ++++----
>  3 files changed, 18 insertions(+), 12 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
