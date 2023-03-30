Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A06686D0DE6
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 20:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbjC3SjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 14:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbjC3SjT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 14:39:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC96D33C
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 11:39:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE44162152
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 18:39:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B32BDC4339E;
        Thu, 30 Mar 2023 18:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680201542;
        bh=XJXFgN5WRqNRoZVRC4PBO6BFzVDypFdxGoAE9laZ+4s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gd4F9KkpU4D1slo+jN1jWmPmP07vOooSaZOb4T6oSbQklCcwzxHMwxfL2R2AXGEkX
         JzNP9U9jVGhLnlLGsxxhx4YqH2H4oC2P9sy6qhaRiOAmfV+Ov36qfzbRVwRVyLkL/3
         gi+J8WudxQ7iDS6lI0d1Vf52xehoJxM9sw6uyshlMvlk8nkAVvTmo6/X0lCvCzlUDC
         biVDFC7Bs1x417V3B7NtJLxd8HTslQb3iTE6Hw3y897JgX2fiSjXekOvr2xcIMogwz
         IvOHfmu2JUXojtidNtZ07b4V1YM7NL8Z9a3n5s5HgQydE4tBNv9LOa7mW0K+c70qjE
         HqGc4U7WOgxtA==
Date:   Thu, 30 Mar 2023 21:38:58 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net v2 3/3] net: ethernet: mtk_eth_soc: add missing ppe
 cache flush when deleting a flow
Message-ID: <20230330183858.GY831478@unreal>
References: <20230330120840.52079-1-nbd@nbd.name>
 <20230330120840.52079-3-nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230330120840.52079-3-nbd@nbd.name>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 30, 2023 at 02:08:40PM +0200, Felix Fietkau wrote:
> The cache needs to be flushed to ensure that the hardware stops offloading
> the flow immediately.
> 
> Fixes: 33fc42de3327 ("net: ethernet: mtk_eth_soc: support creating mac address based offload entries")
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---
>  drivers/net/ethernet/mediatek/mtk_ppe.c | 1 +
>  1 file changed, 1 insertion(+)

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
