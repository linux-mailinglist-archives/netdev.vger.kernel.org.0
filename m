Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6C6A661582
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 14:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232782AbjAHNiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 08:38:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbjAHNip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 08:38:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D9CB9FFF
        for <netdev@vger.kernel.org>; Sun,  8 Jan 2023 05:38:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C598760C83
        for <netdev@vger.kernel.org>; Sun,  8 Jan 2023 13:38:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59A3BC433EF;
        Sun,  8 Jan 2023 13:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673185120;
        bh=zTtH3GQuyWtOad4m9akgSZI9d8SS4wzT6oG3JQocEDk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oJrJ6hNWlzN/gUfXYhKfqEa9BCTA5pKd/l74VRlwfyxXTAdvNTbnaJaUZY4qRfPKc
         W87lr7v1EO7jwAq0T0IK0mTSO1vzp+Tj1AwAQeuqchlU9YmtIucEi2d4PtdAKyqrP+
         06R4MrOowdW6rQwITvBP92HrbeWw0UxJKkEPzdpCWatdpSgb4c2a6a/fZC3GjIdH70
         T8mhkpOfWhW9HDdlra9+0JcFpeW+cwUhqUVLPru2P2CIalnFJ8174TsoN4F5BfVR8N
         Qdr77ec0ezF9O5k2iX1p6v2E2LrF2ltUHArl6l3FA/JcSmRtw6afJTVjnBYoW0U03Q
         IiKjp6W4fJ1pA==
Date:   Sun, 8 Jan 2023 15:38:35 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lorenzo.bianconi@redhat.com,
        nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, sujuan.chen@mediatek.com,
        daniel@makrotopia.org
Subject: Re: [PATCH v3 net-next 1/5] net: ethernet: mtk_eth_soc: introduce
 mtk_hw_reset utility routine
Message-ID: <Y7rHW58kK0wjmMCJ@unreal>
References: <cover.1673102767.git.lorenzo@kernel.org>
 <4e191be0c12b6e45e9bef4b1b54b51755e92eefe.1673102767.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e191be0c12b6e45e9bef4b1b54b51755e92eefe.1673102767.git.lorenzo@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 07, 2023 at 03:50:50PM +0100, Lorenzo Bianconi wrote:
> This is a preliminary patch to add Wireless Ethernet Dispatcher reset
> support.
> 
> Tested-by: Daniel Golle <daniel@makrotopia.org>
> Co-developed-by: Sujuan Chen <sujuan.chen@mediatek.com>
> Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c | 36 +++++++++++++--------
>  1 file changed, 22 insertions(+), 14 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
