Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92E0946D674
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 16:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235698AbhLHPMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 10:12:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234822AbhLHPMT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 10:12:19 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7158EC061746;
        Wed,  8 Dec 2021 07:08:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B2B48CE2208;
        Wed,  8 Dec 2021 15:08:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7425C00446;
        Wed,  8 Dec 2021 15:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638976123;
        bh=bwk6+DFEail/wAUewOYdMkSzwg/r8ym6KopVexCptvk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZN0Mgkx0NO82LGwEsTRg3nZEuw/lCV1imvo0y8A3epiwoMm2g5S+IIZTUvsxgj5Dc
         2Z6pFprEIewhtVhmUdSGloQwISb5/BQ3ZJNHrouLrOU14FtIO9aHt4r/3LYlhWuT6B
         MIJsQhoxvyt4yDKEUDkdmb7XPqEua5+QI7Fs17GO5aJB5Lg1xZYZUKiLX308npDu1K
         UWPGS/l8MvKK0orFPYFeE0XV1Nol2MjAg6I/YhSq/aTuEcHT12dcrRJy9P8LsiL0Nq
         jklyYX+Em2D9On6PhY42JNOj+0d5mPszDNm+n/CzuRcnDovvFJv3r85p8XG1hMa6wk
         ai46UNigUDjMw==
Date:   Wed, 8 Dec 2021 07:08:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Shaokun Zhang <zhangshaokun@hisilicon.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net/mlx5: Remove the repeated declaration
Message-ID: <20211208070842.0ace6747@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YbB0AUPzeEjkb8bQ@unreal>
References: <20211207123515.61295-1-zhangshaokun@hisilicon.com>
        <Ya9WMysibKB7e5CF@unreal>
        <83cb3b17-09a7-fefe-6310-8ec5b992a6a7@hisilicon.com>
        <YbB0AUPzeEjkb8bQ@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Dec 2021 10:59:45 +0200 Leon Romanovsky wrote:
> > > Fixes: 4f4edcc2b84f ("net/mlx5: E-Switch, Add ovs internal port mapping to metadata support")
> > 
> > Shall we need this tag since it is trivial cleanup patch?  
> 
> I don't know about netdev policy about Fixes line.
> 
> IMHO, it should be always when the bug is fixed.

This is not a bug, tho. Bugs bother users.
