Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 943D25EEC08
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 04:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233665AbiI2CmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 22:42:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232557AbiI2CmX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 22:42:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B07C995AA
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 19:42:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 403EC61BA6
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 02:42:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 501CAC433D7;
        Thu, 29 Sep 2022 02:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664419341;
        bh=GFyH+qnoSEt0ng0YdsB5NQMSeRrYvW4dCvrjU5uuFrs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oaYL/RkwOpOqODLbFDRzW/GazrI4iiciP7JAFyPMMoZJ10+GEJjFIWi4jkhPIsKd4
         rE+fu8uYtUam8711DJOy6YAtrV3X6qra0VJVTNwRCSMvtOdb6Nfm+XHcRTfHv30dGn
         TucK1pcQmM0tzsxjUmmvMhIH+eqWzR1b8K2Rx3oaqFWZA3jRHAfpBanl+lji1rlOfR
         +8MaDrWVRqSWfglKbpsZlw0gXKeTGS8BXfNrn+doED2ecw0XpluOKKul+Dd1Kttddv
         OHhw3LoGwsc29zHwUHLUD6MrF5RzY7pJKnzSSe8JnMplbncnWzrXpjlxI/Knevx6jm
         0t3jaf4BrvL6A==
Date:   Wed, 28 Sep 2022 19:42:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Leon Romanovsky <leon@kernel.org>,
        Huanhuan Wang <huanhuan.wang@corigine.com>
Subject: Re: [PATCH net-next v2 0/3] nfp: IPsec offload support
Message-ID: <20220928194220.2e0b72d1@kernel.org>
In-Reply-To: <20220927102707.479199-1-simon.horman@corigine.com>
References: <20220927102707.479199-1-simon.horman@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Sep 2022 12:27:04 +0200 Simon Horman wrote:
> this short series is support IPsec offload for the NFP driver.
> 
> It covers three enhancements:
> 
> 1. Patches 1/3:
>    - Extend the capability word and control word to to support
>      new features.
> 
> 2. Patch 2/3:
>    - Add framework to support IPsec offloading for NFP driver,
>      but IPsec offload control plane interface xfrm callbacks which
>      interact with upper layer are not implemented in this patch.
> 
> 3. Patch 3/3:
>    - IPsec control plane interface xfrm callbacks are implemented
>      in this patch.

Should this not CC Steffen?
