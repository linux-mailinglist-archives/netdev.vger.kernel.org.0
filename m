Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3C3E285E03
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 13:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727424AbgJGLTP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 07:19:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:52658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgJGLTP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 07:19:15 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52F582075A;
        Wed,  7 Oct 2020 11:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602069555;
        bh=98X2b0Wp5jUwvRcUDA98skFMwIjIc7pLzOf83JY9u+4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a314fD3fHRRovHF2lg8Du6q3QFxieQtXy+NIENjxkhbsT7dgRPoKO63D6qzVbRSg6
         IU7rFEosgn7Uv3oqlEk5L5JskpSN2+V2h1JLzSQZuIc3L//fb5OJ4A2O6gGZSpvBqV
         u58yqiD2R6Bh5ExekpVhhiD8YLu4SrQhIj0dZNpQ=
Date:   Wed, 7 Oct 2020 14:19:11 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 1/2] ethtool: strset: allow ETHTOOL_A_STRSET_COUNTS_ONLY
 attr
Message-ID: <20201007111911.GF3678159@unreal>
References: <20201007125348.a0b250308599.Ie9b429e276d064f28ce12db01fffa430e5c770e0@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201007125348.a0b250308599.Ie9b429e276d064f28ce12db01fffa430e5c770e0@changeid>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 07, 2020 at 12:53:50PM +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> The ETHTOOL_A_STRSET_COUNTS_ONLY flag attribute was previously
> not allowed to be used, but now due to the policy size reduction
> we would access the tb[] array out of bounds since we tried to
> check for the attribute despite it not being accepted.
>
> Fix both issues by adding it correctly to the appropriate policy.
>
> Fixes: ff419afa4310 ("ethtool: trim policy tables")
> Fixes: 71921690f974 ("ethtool: provide string sets with STRSET_GET request")
> Reported-by: Leon Romanovsky <leon@kernel.org>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/ethtool/netlink.h | 2 +-
>  net/ethtool/strset.c  | 1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)
>

Thanks,
Tested-by: Leon Romanovsky <leonro@nvidia.com>
