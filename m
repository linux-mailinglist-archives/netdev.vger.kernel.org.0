Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E53A6D0DE4
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 20:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbjC3SjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 14:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231523AbjC3SjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 14:39:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D8EF777
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 11:38:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C476B829D3
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 18:38:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9676EC433EF;
        Thu, 30 Mar 2023 18:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680201534;
        bh=FcDUxXp2mXyrGhTpmNIZlYeFBj9WpoutRWZW/eGG+RE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O+HDIvTGSM+BGhiufE/EKmtUvsVvduQXFWP1G2e7E0eOKoSjzdZH959Os/dut483H
         +9UZoWb+Vo9tpLvOHqGJKTP1lJZz6dpIJPGkZkYdjNzu/++K8JssY/7OWGAelX3W/x
         7mFe2UfWuYwc/cQzan0drX5h6YX1oYBug5Yq7kcGjJSv0ShKtzGbjztA3/C09yHDRU
         bylp/QJiHLb6oy99UlobONTYVG7E7vqKOTk+MqpMc4sVsELCDF//x5TuDnSkLSLPzF
         Zk27GaIJ010ixTfqTOPVJEQCjqAumaP/hMe7i9NnsYyQSeuRfp9dJ2MwTj/I1LZlW8
         vSWRyju1CjWfw==
Date:   Thu, 30 Mar 2023 21:38:50 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net v2 2/3] net: ethernet: mtk_eth_soc: fix L2 offloading
 with DSA untag offload
Message-ID: <20230330183850.GX831478@unreal>
References: <20230330120840.52079-1-nbd@nbd.name>
 <20230330120840.52079-2-nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230330120840.52079-2-nbd@nbd.name>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 30, 2023 at 02:08:39PM +0200, Felix Fietkau wrote:
> Check for skb metadata in order to detect the case where the DSA header
> is not present.
> 
> Fixes: 2d7605a72906 ("net: ethernet: mtk_eth_soc: enable hardware DSA untagging")
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c | 6 +++---
>  drivers/net/ethernet/mediatek/mtk_ppe.c     | 5 ++++-
>  2 files changed, 7 insertions(+), 4 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
