Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2F896CFB6A
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 08:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbjC3GT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 02:19:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbjC3GT2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 02:19:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B56874C27;
        Wed, 29 Mar 2023 23:19:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F7A4B825DB;
        Thu, 30 Mar 2023 06:19:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A815C433EF;
        Thu, 30 Mar 2023 06:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680157158;
        bh=XYQUmLig9r6nb6+zmJG6pa9K9pcE5W+gs9bpXBz3vak=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VOpREeOYRN35CeBGSebaFctUekja8gF6h+TxpNvykuZq6OxpNMnhcj5np3CqRQVA6
         59+HpCai+9V+JsdC2r8evGIFsW+N/UjsSl/zhK60pqSwKsV9ohWMlNU6FySRk8XKaY
         6P2Mas+NfAMgZXdvMaGyiLoDi/hPsPpYLyJj+6Om0GcONWhrinINuouKFdwgOkMu/I
         C3GBm+rE/GCXtDZuKnAXApmqSB6uzn4DwAUMrJ6585I22/4rqr1TQlb/Vlw9YXbLyO
         +5oX3+UU8a617IplgUqHaW64ACMw/753Pg0pdZNwOnsUdmgvTSlP3zIAGqvkko4FAE
         QxnIxHJDX+14g==
Date:   Thu, 30 Mar 2023 09:19:14 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Sai Krishna <saikrishnag@marvell.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sgoutham@marvell.com,
        richardcochran@gmail.com, Suman Ghosh <sumang@marvell.com>
Subject: Re: [net PATCH 4/7] octeontx2-af: Update correct mask to filter IPv4
 fragments
Message-ID: <20230330061914.GN831478@unreal>
References: <20230329170619.183064-1-saikrishnag@marvell.com>
 <20230329170619.183064-5-saikrishnag@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230329170619.183064-5-saikrishnag@marvell.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 10:36:16PM +0530, Sai Krishna wrote:
> From: Suman Ghosh <sumang@marvell.com>
> 
> During the initial design, the IPv4 ip_flag mask was set to 0xff.
> Which results to filter only fragmets with (fragment_offset == 0).
> As part of the fix, updated the mask to 0x20 to filter all the
> fragmented packets irrespective of the fragment_offset value.
> 
> Fixes: c672e3727989 ("octeontx2-pf: Add support to filter packet based on IP fragment")
> Signed-off-by: Suman Ghosh <sumang@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
> ---
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
