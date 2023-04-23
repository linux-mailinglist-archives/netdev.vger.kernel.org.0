Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31E986EC12C
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 18:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjDWQtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 12:49:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjDWQtp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 12:49:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B8C210E6;
        Sun, 23 Apr 2023 09:49:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96CA460F71;
        Sun, 23 Apr 2023 16:49:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36A48C433EF;
        Sun, 23 Apr 2023 16:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682268584;
        bh=kASU+/mrkQ9A/jChgnrK2HkPgNiJvc5j5hmvbvjQBSI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rLrN6P3EcBcwFjY6CU+aq/3XCW/jhm4O4KkYOCwuBhwMIl46NJXqojyzqm3aCik7O
         j0HOST/tvjLKi4/PZqLZCsd6PzSkfqFcXYjsf8kThEE65IQCTvpk0u4B93eh1rJIGz
         v7XuuHqihMQOx+e/dBSJIcJpAsmIkiZppR0tABJdDReD2rRlEKROcU9YYHI/k4vpxf
         Hgfd3itOeppQrJVSe7nIfA2grRtjYu5qFTfkidl3Dwu8rPK4hZjunqXjeLjVV4gy+4
         NuD2rIGfIRY7dd8g/dqncOvnc7Ts5RA6Icg+LXoR81hZxlourSbx1rDRKzFVqfSn6z
         a+RnLmuCZoV/w==
Date:   Sun, 23 Apr 2023 19:49:39 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Geetha sowjanya <gakula@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, richardcochran@gmail.com, sgoutham@marvell.com,
        sbhatta@marvell.com, hkelam@marvell.com
Subject: Re: [net PATCH 4/9] octeontx2-af: mcs: Fix MCS block interrupt
Message-ID: <20230423164939.GG4782@unreal>
References: <20230423095454.21049-1-gakula@marvell.com>
 <20230423095454.21049-5-gakula@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230423095454.21049-5-gakula@marvell.com>
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 23, 2023 at 03:24:49PM +0530, Geetha sowjanya wrote:
> On CN10KB, MCS IP vector number, BBE and PAB interrupt mask
> got changed to support more block level interrupts.
> To address this changes, this patch fixes the bbe and pab
> interrupt handlers.
> 
> Fixes: 6c635f78c474 ("octeontx2-af: cn10k: mcs: Handle MCS block interrupts")
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> Signed-off-by: Geetha sowjanya <gakula@marvell.com>
> ---
>  .../net/ethernet/marvell/octeontx2/af/mcs.c   | 95 ++++++++-----------
>  .../net/ethernet/marvell/octeontx2/af/mcs.h   | 26 +++--
>  .../marvell/octeontx2/af/mcs_cnf10kb.c        | 63 ++++++++++++
>  .../ethernet/marvell/octeontx2/af/mcs_reg.h   |  5 +-
>  4 files changed, 119 insertions(+), 70 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
