Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4599166B80B
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 08:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbjAPHTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 02:19:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbjAPHTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 02:19:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BE74CC0C
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 23:19:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9C1560EC9
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 07:19:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96665C433EF;
        Mon, 16 Jan 2023 07:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673853558;
        bh=bcT946jCoWtjSy877m5sF1HQyGT2lKAxG8TetGlj5Lo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HXu4RNFgLUoUzDXDnzvtbIVtBjMg5RuYKzFha8lPcMNaXzhoHUO59w33ToEkqMvot
         VHXXYEkkOFrIRg5LuiD1T2pWVj+WnTTjb8jymHV4XZBSCsfwXGEwFFCRV1xnv4XdeI
         KBVjHJ6fbEVHc5MedWwMwU0hVp5NQuUiBy2Fhhf0BwRFUu+R9kTKT/f2unkru18cgN
         BesvALKbGTBcnlqwjRUl5dIIyDrN9cTM4N9vONz7LHAstP6wjitm3VA5LUtxyZouID
         zk1SPCrGyvXGUi5wbG5Jp5lhbQvvDJR/ESJEYx0TSrOsmvI2PZOhdhedTz16Q11Ah8
         FmcKIhUE1XpDQ==
Date:   Mon, 16 Jan 2023 09:19:13 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Raju.Rangoju@amd.com, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH] MAINTAINERS: Update AMD XGBE driver maintainers
Message-ID: <Y8T6cQBB9BZA5cNA@unreal>
References: <20230116042548.413237-1-Shyam-sundar.S-k@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230116042548.413237-1-Shyam-sundar.S-k@amd.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 09:55:48AM +0530, Shyam Sundar S K wrote:
> Due to other additional responsibilities Tom would no longer
> be able to support AMD XGBE driver.
> 
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
> ---
>  MAINTAINERS | 1 -
>  1 file changed, 1 deletion(-)

Patch title should include target, in your case "PATCH net" ....

Thanks

> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 046ff06ff97f..e9b1b0cf27aa 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1079,7 +1079,6 @@ S:	Supported
>  F:	arch/arm64/boot/dts/amd/
>  
>  AMD XGBE DRIVER
> -M:	Tom Lendacky <thomas.lendacky@amd.com>
>  M:	"Shyam Sundar S K" <Shyam-sundar.S-k@amd.com>
>  L:	netdev@vger.kernel.org
>  S:	Supported
> -- 
> 2.25.1
> 
