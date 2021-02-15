Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24B0A31B54C
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 06:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbhBOFlS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 00:41:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:58750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229489AbhBOFlQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 00:41:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB49564DF2;
        Mon, 15 Feb 2021 05:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613367636;
        bh=32gZRSjfiMbtLYsrvgcIRRcwN+NIOr9YF5E1JXBKnmo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mcRrO6HSYqf8j2y8zNgeovpyq6IEUz47aQXkG+LhXi9OiaMLZVcTS0q03qx9b8/hM
         RAujO0FkZvJFP4/BPPoCS1oazqqNSJ0y2HTlVv7iArQOLIdEFNxHRPH6hRLwIjMWCH
         lWBWReUyrya0E/whs/9kLrTWi0ZWXDfvuX6Ewu48MZR5kueai4y3Ojv5dxj6G618sV
         H0ZZK/a4BkX36G8U2+iYjQY3da6akVlICSLQF/fo2IU9A47fxfd3QIO+YTo19JFuJX
         7Gk7Ou941mWHExtW+xjjmEYE3GA1c3c/KYED1ZGUz1V7jPOIWMh5BCKStGSr03aoHD
         5bcsn2hnepevA==
Date:   Mon, 15 Feb 2021 07:40:32 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Ido Kalir <idok@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH iproute2-rc] rdma: Fix statistics bind/unbing argument
 handling
Message-ID: <YCoJULID1x2kulQe@unreal>
References: <20210214083335.19558-1-leon@kernel.org>
 <5e9a8752-24a1-7461-e113-004b014dcde9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e9a8752-24a1-7461-e113-004b014dcde9@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 14, 2021 at 08:26:16PM -0700, David Ahern wrote:
> what does iproute2-rc mean?

Patch target is iproute2.git:
https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/
vs -next repo:
https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/

How do you want me to mark the patches?

https://git.kernel.org/pub/scm/network/iproute2/

Thanks
