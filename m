Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64FFA6D44F0
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 14:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232427AbjDCMxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 08:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232180AbjDCMxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 08:53:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8443435B0
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 05:53:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F38D61AA2
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 12:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21749C433EF;
        Mon,  3 Apr 2023 12:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680526424;
        bh=M+zmrFne0b8B3h7JZYKQI0K0ZrTVY1zpV6xxve5i50g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PItdDMvrXAJlmZeLh9YJ6y+5waLNoqvgiqYj7Fko84h9oRBGSut9VdUMIqIQPdF4y
         ewsbpb13FvgbKuFkrxHmg2pIzIn2r6TcikiQK6b+jbwu7u7x9wpMqCulp7kMQMLAew
         IdWSKJwu/UUtvBtr3aDAfcDM80W8nVGSQ9bEhQU0vqdAN57PzQJ4JFNgKb+EEX7joG
         pi2Kag3kBaVQ6MvGBmWmmaKlQzKmA/fHK5fNIUFqfG3Lu5ISdW+/k5G1ehOMVQob9z
         lMylEgbPLR2IJlR81VchRKAxTg/1/16xPuEp9tcKxWRyujhEmZmRNzbA5zLCFM0RJm
         YTMcUBOu93iPA==
Date:   Mon, 3 Apr 2023 15:53:41 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, Daniel Golle <daniel@makrotopia.org>
Subject: Re: [PATCH net-next 1/3] net: ethernet: mtk_eth_soc: improve keeping
 track of offloaded flows
Message-ID: <20230403125341.GA176342@unreal>
References: <20230331082945.75075-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230331082945.75075-1-nbd@nbd.name>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 10:29:43AM +0200, Felix Fietkau wrote:
> Unify tracking of L2 and L3 flows. Use the generic list field in struct
> mtk_foe_entry for tracking L2 subflows. Preparation for improving
> flow accounting support.
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---
>  drivers/net/ethernet/mediatek/mtk_ppe.c | 162 ++++++++++++------------
>  drivers/net/ethernet/mediatek/mtk_ppe.h |  15 +--
>  2 files changed, 86 insertions(+), 91 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
