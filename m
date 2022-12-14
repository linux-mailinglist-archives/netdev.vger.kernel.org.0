Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2D5564C484
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 08:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237524AbiLNHyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 02:54:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237348AbiLNHyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 02:54:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 253D811173
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 23:54:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A6E7461842
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 07:54:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A5ACC433EF;
        Wed, 14 Dec 2022 07:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671004483;
        bh=93g2T3KhAXhgG13/7pvnSucwyl+V/l6zp5Waj7KK7fM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gfC+mMup11HUefG+BLYZD7E5ZU34eyZfbs7p82jwChzLgdsK1u/SNN+yXJ4YH/oG8
         u9UjygaxxLPV9j62vwdHENFRfUXH/cJgvDp1KJW4Oc69D9iPF37AVGE0hFXgDVs+5M
         p9ckSE6LbT6sVnuHMXTXZ8ZRKchKQebV2I0w5svRcuwWeqeb3PbHTFeknRt79+fxpx
         Mwisdjb3BYIhZSYdyJHqk2jfvo5+f2jXDpcMUgzo3CpZlWxGOgCW4yV6U9mTpG5sBI
         Us3e2cNwZny8hcOHs1gtRLoDHKLfFAY8/5xrhhLclkpffwRfAbB8mYkibWHqzSRufp
         IdA91KOOF8vFA==
Date:   Wed, 14 Dec 2022 09:54:38 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Gaosheng Cui <cuigaosheng1@huawei.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, boon.leong.ong@intel.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] net: stmmac: fix errno when
 create_singlethread_workqueue() fails
Message-ID: <Y5mBPs/eYf4yVFfi@unreal>
References: <20221214034205.3449908-1-cuigaosheng1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221214034205.3449908-1-cuigaosheng1@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 14, 2022 at 11:42:05AM +0800, Gaosheng Cui wrote:
> We should set the return value to -ENOMEM explicitly when
> create_singlethread_workqueue() fails in stmmac_dvr_probe(),
> otherwise we'll lose the error value.
> 
> Fixes: a137f3f27f92 ("net: stmmac: fix possible memory leak in stmmac_dvr_probe()")
> Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 1 +
>  1 file changed, 1 insertion(+)
> 

Please change title of your patch to be "PATCH net"

Thanks
