Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA236D44F1
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 14:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232448AbjDCMx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 08:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232440AbjDCMxz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 08:53:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B505E35AF
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 05:53:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4655C61A82
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 12:53:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49473C433D2;
        Mon,  3 Apr 2023 12:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680526432;
        bh=QvVYrhqzPjMX6PCLhOBZguhVst8h2GheuIluDBud9h4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Hqpc43mJ+L+kbcMPywgCZOScaiS9onEIPXcXZFUGBc0EcWUetii/0LI2GMNl7M4N2
         VA+07tTpcsuimZthsNUcb5oG/Ouu4Sn4ySWjXcOsB1bYn4ysPrFh+BFLVpzc1uVby6
         B/nAE9gZeKr5zK33lo9fN1CWpHgoeSfCF6dx4Ex29AgpskOLP2BonopEbe1dQkm9Wd
         F4JadmcbkRHF3bWQf5O4qrF00XwTN9ava1y+uHycXihpdiCB9F4qWIKQsHcV1IMpME
         zkJXZGEXj60zE4TWg8BWAeXjX7ZrqeInrV2tAfyp61sEYDspLGRiNaRmQbv68V0/fI
         S/AZDSGKurLyA==
Date:   Mon, 3 Apr 2023 15:53:49 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, Daniel Golle <daniel@makrotopia.org>
Subject: Re: [PATCH net-next 3/3] net: ethernet: mtk_eth_soc: fix ppe flow
 accounting for v1 hardware
Message-ID: <20230403125349.GB176342@unreal>
References: <20230331082945.75075-1-nbd@nbd.name>
 <20230331082945.75075-3-nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230331082945.75075-3-nbd@nbd.name>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 10:29:45AM +0200, Felix Fietkau wrote:
> Older chips (like MT7622) use a different bit in ib2 to enable hardware
> counter support.
> 
> Fixes: 3fbe4d8c0e53 ("net: ethernet: mtk_eth_soc: ppe: add support for flow accounting")
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---
>  drivers/net/ethernet/mediatek/mtk_ppe.c | 10 ++++++++--
>  drivers/net/ethernet/mediatek/mtk_ppe.h |  3 ++-
>  2 files changed, 10 insertions(+), 3 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
