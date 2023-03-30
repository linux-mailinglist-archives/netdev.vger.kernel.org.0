Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE3276D046E
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 14:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbjC3MN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 08:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbjC3MN4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 08:13:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12328123
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 05:13:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7825F62047
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 12:13:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BB5DC433EF;
        Thu, 30 Mar 2023 12:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680178433;
        bh=Q4//J8BMx5UHzRKqYXgOEpz654x7i7qnhCnbPHQ79yI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gyeIcYg0DytX+tOCsvWYih74uKx+rc3U6k6qb6AIrjNGgV2oSfkp3Ck7dbI47TALN
         p4YlttkkIWj9POWuc4lYb3VuHv+WH4MRv7jbi14+vchk49OtVhN8ONhiw72N38BeDm
         oTYeV32JmNFYlO++2FJfd5HI7yG+ZdQgKoi+UNJJdUQH/BsokL/qht13L4h6l6BMB5
         xNrBxaM5UtKMZQeymqQjaiZBjZQx/Db8ScMsFK+3fW6K8gCZ7meHxu986LFu6/4Lip
         DSr4yrSfYGmVYrE7o+Umn8oO4SDJ4yfqi7fZQMDEaufupjB09lF1Uz0cf9IrTLj8C8
         eJzn7PwSJ18Kw==
Date:   Thu, 30 Mar 2023 15:13:49 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net v2 1/3] net: ethernet: mtk_eth_soc: fix flow block
 refcounting logic
Message-ID: <20230330121349.GV831478@unreal>
References: <20230330120840.52079-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230330120840.52079-1-nbd@nbd.name>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 30, 2023 at 02:08:38PM +0200, Felix Fietkau wrote:
> Since we call flow_block_cb_decref on FLOW_BLOCK_UNBIND, we also need to
> call flow_block_cb_incref for a newly allocated cb.
> Also fix the accidentally inverted refcount check on unbind.
> 
> Fixes: 502e84e2382d ("net: ethernet: mtk_eth_soc: add flow offloading support")
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---
>  drivers/net/ethernet/mediatek/mtk_ppe_offload.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

So what was changed between version 1 and 2?
It is expected to send cover letter too for series with more than 2 patches.

Thanks
