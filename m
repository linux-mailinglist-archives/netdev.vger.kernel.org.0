Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA0130938B
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 10:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231848AbhA3Jjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 04:39:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:43682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231986AbhA3Jiy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Jan 2021 04:38:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62F7B64E19;
        Sat, 30 Jan 2021 06:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611989959;
        bh=YunYa7fNzr8/qZLICf6mNKbmtJwg3nHJ9EJ4vUZ7YAk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=f6j0X/VN0DN4qnU5IWgau8a1slEwoESWkW/xoY2IKlcJijBKqzz0zd8f+XbJP9ewn
         iS6DMeixyMZcS3FiZMEuA82DD9u/Nw26cy1vxtxL6i3qvPgnWJ36AXs8lx+wEYxQuO
         o25mYiDYWmew4tslTQiT/WuXXJ7tW3PEt2mevYQ4oi55uQMIqrC0d4LcKpu7MpdV8G
         MZdYyGl1N4aV9o2HNdMm9ev1dPwOCFG6bbkmUySnSdyZMcNufHnSQPavEu1l3Y9R2e
         w3neW8HNoILZ4yn27nWsqZBSoig9pphohN/9OltGPnk2ZYTv0tMB4vHQNXdisz99Mt
         vDx1sgHStTFQw==
Date:   Fri, 29 Jan 2021 22:59:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chris Mi <cmi@nvidia.com>
Cc:     netdev@vger.kernel.org, jiri@nvidia.com, saeedm@nvidia.com,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH net-next v5] net: psample: Introduce stubs to remove NIC
 driver dependency
Message-ID: <20210129225918.0b621ed7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210130023319.32560-1-cmi@nvidia.com>
References: <20210130023319.32560-1-cmi@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 30 Jan 2021 10:33:19 +0800 Chris Mi wrote:
> +// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
> +/* Copyright (c) 2021 Mellanox Technologies. */
> +
> +const struct psample_ops __rcu *psample_ops __read_mostly;
> +EXPORT_SYMBOL_GPL(psample_ops);

Please explain to me how you could possibly have compile tested this
and not caught that it doesn't build.
