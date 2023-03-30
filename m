Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA4AE6CFB4C
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 08:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbjC3GMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 02:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjC3GMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 02:12:45 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28B0140D6;
        Wed, 29 Mar 2023 23:12:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 875B1CE2703;
        Thu, 30 Mar 2023 06:12:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 056B3C433D2;
        Thu, 30 Mar 2023 06:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680156761;
        bh=fRhYHGPA8bRYVMGe+73+epZF5AM6t03R3K5uaSxkDUc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ptZCHxcHQ+9ErefKTDfu5te3RtzpJjQbzKgG/gc532RCuWQzWwgOABITlEWVwDRwE
         LXdvJ89n6Aw/IrqGOLejcfL4RHwI9y5XwFEReh8f44Dmgd+y4jiSe8QUi84yuByNni
         SA1iMOFkNiQsLBVcVk+QbgNErqX0qGWQXNmyI9ZJEiiY3se2ppT1d5etDoaQy1f1Ct
         8Q2vZztPO7KkEM2D+ogTkKAnAsEfdl9qlvi933UywJjYUZsnCCSeF9/uduYDopvcNS
         LebxZRbITdMgQQ4NaacN9FJzbgzyLdVEzanqSxEv2dV+i9na6ceFNMM+YPntO81LHf
         gNrbctII//XRg==
Date:   Thu, 30 Mar 2023 09:12:37 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Sai Krishna <saikrishnag@marvell.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sgoutham@marvell.com,
        richardcochran@gmail.com, Ratheesh Kannoth <rkannoth@marvell.com>
Subject: Re: [net PATCH 2/7] octeontx2-af: Fix start and end bit for scan
 config
Message-ID: <20230330061237.GL831478@unreal>
References: <20230329170619.183064-1-saikrishnag@marvell.com>
 <20230329170619.183064-3-saikrishnag@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230329170619.183064-3-saikrishnag@marvell.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 10:36:14PM +0530, Sai Krishna wrote:
> From: Ratheesh Kannoth <rkannoth@marvell.com>
> 
> Fix the NPC nibble start and end positions in the bit
> map. Fix the depth of cam and mem table configuration.
> Increased the field size of dmac filter flows as cn10kb
> support large in number.
> 
> Fixes: b747923afff8 ("octeontx2-af: Exact match support")
> Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
> ---
>  drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c   | 5 ++---
>  drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c | 4 ++--
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h | 4 ++--
>  3 files changed, 6 insertions(+), 7 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
