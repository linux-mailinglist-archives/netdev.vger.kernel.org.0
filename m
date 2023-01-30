Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 812DD680A63
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 11:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235952AbjA3KGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 05:06:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235531AbjA3KGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 05:06:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C80E486A5;
        Mon, 30 Jan 2023 02:06:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 750FDB80EBB;
        Mon, 30 Jan 2023 10:06:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A50C433EF;
        Mon, 30 Jan 2023 10:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675073172;
        bh=1fvygeDlwnGzJzoprofN8kSwL8nlfgCguyi3IrR50Ow=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cNmVGi5dc2XscrLfjWu4aWXaFCXcer95BU7mEmJ4ARZqceCLNwys5YcEAAqFLIFYn
         l5ZgAYt0Zu5vhkDeNML9TqGTvT7y9nxzY4ASQAfpIAhj+bY3QP2EN3l217yZYinffu
         6RC5Fy21q75pgtNTUfzxXTbdGzrZnvWDcz47Oj0uDfJT21rTegu7BNn2TNBl/QKh3o
         qhfSFKy/tJDaLDpvfjPnOOTN/LlQ4YL9KNS3W8S4/bfQ3P5RSk2teLPU8tRPGJd1Gt
         jMhC+crPtD49p+v/f/pBjeKLNCLMgYJZEvXhF0jYuMMFkToh0e29Pq7NVBti6twDAx
         gFpgxPQQ3mh/g==
Date:   Mon, 30 Jan 2023 12:06:07 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Ratheesh Kannoth <rkannoth@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, sgoutham@marvell.com
Subject: Re: [net PATCH v1] octeontx2-af: Fix devlink unregister
Message-ID: <Y9eWjyUvK+f/lyg7@unreal>
References: <20230130060443.763564-1-rkannoth@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130060443.763564-1-rkannoth@marvell.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 11:34:43AM +0530, Ratheesh Kannoth wrote:
> Exact match devlink entry is only for CN10K-B.
> Unregistration devlink should subtract this
> entry before invoking devlink unregistration
> 
> Fixes: 87e4ea29b030 ("octeontx2-af: Debugsfs support for exact match.")
> Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
> ---
>  .../marvell/octeontx2/af/rvu_devlink.c        | 37 ++++++++++++++-----
>  1 file changed, 28 insertions(+), 9 deletions(-)

Your Fixes line, commit message and title don't correlate with the code.

Thanks
