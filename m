Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC884C7920
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 20:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbiB1Tvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 14:51:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbiB1Tv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 14:51:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FA72C7C0E
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 11:49:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC3C3B8163F
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 19:49:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DC22C340F1;
        Mon, 28 Feb 2022 19:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646077755;
        bh=mywARaecSLg1NzPtHRVCTaw2SMOyBT1huRDr5OJsyfI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BomphpOB+xIxMPR6Q4k6KSCe35Uo6gyKjFpuflrDTzYiyfsbaPXrAc6AEw1IBTdCp
         RbSL0lnc5wgmln8ad5BhF1aYoqqXvta4QHpnuEEyKHgnFe4WNDrGOB5N/vhDbpIVCd
         A2mzBUak/1g0EalB9YZp2th4IroqUJtoSgtmRtHwthvzeOBqSyQXPpgLwbypmLyMGD
         Z2QKS8U1Sdlh3zAuyc/iexWmwghv1pO30x9RIVJi4qhmVlus2PHx84uUJJfp1lVRSF
         U0BIA73Mfu10oagYglXz+phycII6pGpt+izW6krdqT/SufcbgY4oN4IDhIjhVozfxM
         A0BVlGIVv7tCw==
Date:   Mon, 28 Feb 2022 11:49:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Yang Li <yang.lee@linux.alibaba.com>,
        Joseph CHAMG <josright123@gmail.com>, netdev@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] net: dm9051: Make remove() callback a void function
Message-ID: <20220228114913.209d141b@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220228173957.1262628-2-broonie@kernel.org>
References: <20220228173957.1262628-1-broonie@kernel.org>
        <20220228173957.1262628-2-broonie@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Feb 2022 17:39:57 +0000 Mark Brown wrote:
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> 
> Changes introduced since the merge window in the spi subsystem and
> available at:
> 
>    https://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git tags/spi-remove-void
> 
> make the remove() callback for spi return void rather than int, breaking
> the newly added dm9051 driver fail to build.  This patch fixes this
> issue, converting the remove() function provided by the driver to return
> void.
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> [Rewrote commit message -- broonie]
> Signed-off-by: Mark Brown <broonie@kernel.org>

Pulled & applied, thanks!
