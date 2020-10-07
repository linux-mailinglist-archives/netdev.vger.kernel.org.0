Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF983285E02
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 13:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbgJGLS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 07:18:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:52512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726730AbgJGLS5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 07:18:57 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DFEBD2075A;
        Wed,  7 Oct 2020 11:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602069536;
        bh=zw0n7Q6vqIwxN2eQAkiygtAkgWUFMpxyiyTNt9ZDXhU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L5Io4qDFVAH3R/f+acwtHjrIS9+xZImma5sPW4IaEeIMDZBA4F0ejWx9Hy7Lxf4Jx
         fts1rpjEYYeHjEluo1jtkgIYI2GuFvAIn8NwVcVfAnvSkt78tBsXHgwygwMi1mUZ9S
         mXVXEnCvUDojayFUMdyxcPnrcAYP6FhDnL5MK3E8=
Date:   Wed, 7 Oct 2020 14:18:52 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 2/2] ethtool: correct policy for ETHTOOL_MSG_CHANNELS_SET
Message-ID: <20201007111852.GE3678159@unreal>
References: <20201007125348.a0b250308599.Ie9b429e276d064f28ce12db01fffa430e5c770e0@changeid>
 <20201007125348.a74389e18168.Ieab7a871e27b9698826e75dc9e825e4ddbc852b1@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201007125348.a74389e18168.Ieab7a871e27b9698826e75dc9e825e4ddbc852b1@changeid>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 07, 2020 at 12:53:51PM +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> This accidentally got wired up to the *get* policy instead
> of the *set* policy, causing operations to be rejected. Fix
> it by wiring up the correct policy instead.
>
> Fixes: 5028588b62cb ("ethtool: wire up set policies to ops")
> Reported-by: Leon Romanovsky <leon@kernel.org>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/ethtool/netlink.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>

Thanks,
Tested-by: Leon Romanovsky <leonro@nvidia.com>
