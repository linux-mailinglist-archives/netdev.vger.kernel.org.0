Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2988D64C4BF
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 09:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237720AbiLNINB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 03:13:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237543AbiLNIMH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 03:12:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A55DD165BC
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 00:10:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 208D3B815DB
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 08:10:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15BD8C433EF;
        Wed, 14 Dec 2022 08:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671005437;
        bh=+zeXN5WosSUBbyyksAsVntvHbGVEsx9KgPHCEaV47NU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V+3cDGjLFdTIIVZSXUTZNjn58MwVidDTAFPnff9rXCEMo1dyIq9fMJn8N9UoVQ5I8
         P8/rjIAjfLEIhwDy9KngMMUQLU6oxytvWUlhlx28vuF76gTkX8JYTlUDDJocpp7jQ1
         pTPXxJppunVcUSVxAXFGQa1YB50DS01v3LFOkMR0ozekMRwqyyg8nBcx5Wf11rl1ms
         0kEnK1VKywrDCDJvuRF6DLh9JztADRZ74NQjnO6cnKPDw7zzBQ1FTNaPByNMQqxulS
         9blt93uIzwXBJyZcqa1JTUEUusBDCkUCkE4g8kjg4wkhEjk8D8Yu/Udm3NlNVD+eMh
         AYleLAIjcEeXQ==
Date:   Wed, 14 Dec 2022 10:10:33 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Gaosheng Cui <cuigaosheng1@huawei.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, boon.leong.ong@intel.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net,v2] net: stmmac: fix errno when
 create_singlethread_workqueue() fails
Message-ID: <Y5mE+UB9tVppXJr+@unreal>
References: <20221214080117.3514615-1-cuigaosheng1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221214080117.3514615-1-cuigaosheng1@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 14, 2022 at 04:01:17PM +0800, Gaosheng Cui wrote:
> We should set the return value to -ENOMEM explicitly when
> create_singlethread_workqueue() fails in stmmac_dvr_probe(),
> otherwise we'll lose the error value.
> 
> Fixes: a137f3f27f92 ("net: stmmac: fix possible memory leak in stmmac_dvr_probe()")
> Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
> ---
> v2:
> - Change title of this patch to be "PATCH net", thanks!
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 1 +
>  1 file changed, 1 insertion(+)
> 

It is so shameful that on Fixed commit, my tag too :(.
Sorry about that.

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
