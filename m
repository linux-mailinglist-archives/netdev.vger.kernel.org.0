Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7E66622C45
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 14:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbiKINUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 08:20:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbiKINUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 08:20:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8CC7E13
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 05:20:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5386361A0D
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 13:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03418C433C1;
        Wed,  9 Nov 2022 13:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668000009;
        bh=fFp8c/C5KwoHfojbaBlFLGxsFDoc+5v7nDjJF8XtA5E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JB4wdIBcpuQM1QD1oVuiN2ocxytPgaCSBTiYBYRlu2PGKG0FVWl5FbzHJCk/7hvxF
         IR7Ek52YTNxvWrLALHNL0K7Rz4yUdPQw/5kizz5gNgKNwsc4C8B3sIMsPEzfiKWK8f
         mMrhnzZzJXx2tNnV94/zFzWulW3fFrKjjgdExQlH+oQt7v/FCyB3xYZ6Bpoh7590F7
         d93FmBiQ8ydmW4rafDmB6MpeEauhYwnYynyHQb6YzQ+u8fmYZxI30UratA0VrSCw8J
         b+1RQFBdA/fP5cfL3H9bJvBaJcqiPnY5Z+xBWAVNTqcn6/kFnbzDC1ilmtiyx2cpAe
         RqwjpdiEriopg==
Date:   Wed, 9 Nov 2022 15:20:05 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, rajur@chelsio.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        jeffrey.t.kirsher@intel.com, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
Subject: Re: [PATCH net] net: cxgb3_main: disable napi when bind qsets failed
 in cxgb_up()
Message-ID: <Y2upBRYd3hbxNV5n@unreal>
References: <20221107093423.50810-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221107093423.50810-1-shaozhengchao@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 07, 2022 at 05:34:23PM +0800, Zhengchao Shao wrote:
> When failed to bind qsets in cxgb_up() for opening device, napi isn't
> disabled. When open cxgb3 device next time, it will reports a invalid
> opcode issue. Fix it. Only be compiled, not be tested.
> 
> Fixes: f7917c009c28 ("chelsio: Move the Chelsio drivers")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c | 1 +
>  1 file changed, 1 insertion(+)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
