Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A94A36EC12A
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 18:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbjDWQss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 12:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbjDWQsp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 12:48:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02ACC10F0;
        Sun, 23 Apr 2023 09:48:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 885BC61B5C;
        Sun, 23 Apr 2023 16:48:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25641C4339B;
        Sun, 23 Apr 2023 16:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682268521;
        bh=ddToxb9gkHG/FkTnr9/E04yp93nvcB9vGAz/CWipWRo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=meiIehMSXFmw8QLgP3JYfJI44hllJ52uMpKkWBXS5bnXXjfEx5VibSwadR2Bb/JFw
         HeVzWjbDnF5D5TR21KiJWwlq7M3hX+D+i+dF85LEceh+b44+EFg2ve0FREDHXQlPOb
         8dWxyPwhCa6BiLQh0MY6HaA4hLA0vHEzgxDGPBY4CqRcNdjtTwM0VVNAGdZYtUJtlB
         X+AmsrxIeCnaVAYMfBt7Xmo7U5M/QI/dxegtjbBI2vMSq2V6Nn94P5x8fzbRK70g6O
         fgBGGwVNlRi2+b+8Sec1ZtxHEjFKBKtRfXlouoKXPdUiT+Dd/mYP87KVh1I/H4AGyg
         sofC8ln57dDYg==
Date:   Sun, 23 Apr 2023 19:48:37 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Geetha sowjanya <gakula@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, richardcochran@gmail.com, sgoutham@marvell.com,
        sbhatta@marvell.com, hkelam@marvell.com
Subject: Re: [net PATCH 1/9] octeonxt2-af: mcs: Fix per port bypass config
Message-ID: <20230423164837.GF4782@unreal>
References: <20230423095454.21049-1-gakula@marvell.com>
 <20230423095454.21049-2-gakula@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230423095454.21049-2-gakula@marvell.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 23, 2023 at 03:24:46PM +0530, Geetha sowjanya wrote:
> For each lmac port, MCS has two MCS_TOP_SLAVE_CHANNEL_CONFIGX
> registers. For CN10KB both register need to be configured for the
> port level mcs bypass to work. This patch also sets bitmap
> of flowid/secy entry reserved for default bypass so that these
> entries can be shown in debugfs.
> 
> Fixes: bd69476e86fc ("octeontx2-af: cn10k: mcs: Install a default TCAM for normal traffic")
> Signed-off-by: Geetha sowjanya <gakula@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> ---
>  drivers/net/ethernet/marvell/octeontx2/af/mcs.c       | 11 ++++++++++-
>  .../net/ethernet/marvell/octeontx2/af/rvu_debugfs.c   |  5 +++--
>  2 files changed, 13 insertions(+), 3 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
