Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 015582EB4A7
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 22:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729694AbhAEVF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 16:05:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:56190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726687AbhAEVF3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 16:05:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 740FB22D6F;
        Tue,  5 Jan 2021 21:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609880688;
        bh=4cTBG9sUVLD5FV3a1wpreDach9q1xER3C3Qvnndkbm4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MYezKsWwdo1ve7k5tIlZ1urYav04PiX0+ZTJ1vfBUXHCJTzGSusmBaposrrCSXfIw
         S1LbZNuI61SVZpxrtTDuhTopuxO1JZMo0DYXrMN02aa6sC01W/EiAJAAJcdMjb6rky
         199IApX60grjTrarFzOJ96F3hGizDHg8KEzF2zPIDPLMmdL5lYoMgFfXnnL6G8qFx3
         VwvejOyFh6uNUWOuaT8aKKgSQ+NYD19+lB8ZE9T22khx360cKUtmq15b5nz2DHZ43O
         O8jtI9oXT1+bjPy86RVNzrS5cBFIAHbttdSIZJZKL6L0yTygRxhx9WL/uJXeUgxYLp
         pVzsPjXDAciBw==
Message-ID: <00b4d4f0c1b98915c45cb598acac670f0684811d.camel@kernel.org>
Subject: Re: [PATCH] net/mlx5e: remove h from printk format specifier
From:   Saeed Mahameed <saeed@kernel.org>
To:     trix@redhat.com, leon@kernel.org, davem@davemloft.net,
        kuba@kernel.org, vladyslavt@nvidia.com, maximmi@mellanox.com,
        tariqt@nvidia.com, bjorn.topel@intel.com
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 05 Jan 2021 13:04:45 -0800
In-Reply-To: <20201223194512.126231-1-trix@redhat.com>
References: <20201223194512.126231-1-trix@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-12-23 at 11:45 -0800, trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> This change fixes the checkpatch warning described in this commit
> commit cbacb5ab0aa0 ("docs: printk-formats: Stop encouraging use of
> unnecessary %h[xudi] and %hh[xudi]")
> 
> Standard integer promotion is already done and %hx and %hhx is
> useless
> so do not encourage the use of %hh[xudi] or %h[xudi].
> 
> Signed-off-by: Tom Rix <trix@redhat.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en/params.c | 2 +-
>  drivers/net/ethernet/mellanox/mlx5/core/en_main.c   | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 

applied to net-next-mlx5,
Thanks

