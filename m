Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F673482164
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 03:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241006AbhLaCJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 21:09:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbhLaCJx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 21:09:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA089C061574;
        Thu, 30 Dec 2021 18:09:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5658AB81CAC;
        Fri, 31 Dec 2021 02:09:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2997C36AEA;
        Fri, 31 Dec 2021 02:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640916590;
        bh=gSzqPQ6IFufxMDlKjpZbLlQez/c+rK8RGCTrCFGHhxU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LoaCpH9pkvjfXP4SFT0NyFKJnUkHF0dKM5Yat4hA3+OeZ0nd42MtApzhEGjEGwaoq
         n+2YgnhSLOEWSvWexCfZTLtfNZxDiKMc7UxuBb9aPeJRZiGo0GNuIJWa013nksqtBv
         NswdCVooUdtdJfg1PzMbM/eBRNw9Y9gUW5O0Wq7jDjJebvU+aRG5YfQsnA2I4rf+Uk
         qKMBq10l2ywLz3Fx/Lyoplrziule/+kFhbOMlxCw5hNfRaflcdJdwEKRfhtqG9+feP
         5VZXnq4AkUdSWdh4uIUtsfdK9tYRl317cjX3biCHZakfwrrIgjuXcRMTfu6wTlHRqh
         LJQGad7A0tt0g==
Date:   Thu, 30 Dec 2021 18:09:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Muhammad Sammar <muhammads@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>, linux-doc@vger.kernel.org
Subject: Re: [net-next  07/16] net/mlx5: DR, Add support for dumping
 steering info
Message-ID: <20211230180948.7be1ddb5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <MW2PR12MB2489C8551828CFE500F4492EC0469@MW2PR12MB2489.namprd12.prod.outlook.com>
References: <20211229062502.24111-1-saeed@kernel.org>
        <20211229062502.24111-8-saeed@kernel.org>
        <20211229181650.33978893@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <MW2PR12MB2489C8551828CFE500F4492EC0469@MW2PR12MB2489.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Dec 2021 01:49:54 +0000 Yevgeny Kliteynik wrote:
> Actually, this was written based on debugfs functions documentation, where
> it states that "if an error occurs, NULL will be returned"
> 
> https://www.kernel.org/doc/htmldocs/filesystems/API-debugfs-create-dir.html
> 
> Looking at the code, I see that it's no longer the case.

Oh, I see. That looks like some old, out of date version of the docs.
The text was already correct in 5.15, it seems:

https://elixir.bootlin.com/linux/v5.15/source/fs/debugfs/inode.c#L549

Also this render of the docs is correct:

https://www.kernel.org/doc/html/latest/filesystems/api-summary.html#c.debugfs_create_dir

I don't really know who's responsible for the kernel.org docs... 
Let's CC Jon.

Jon, is the www.kernel.org/doc/htmldocs/ copy intentionally what it is?
Anyone we should talk to?
