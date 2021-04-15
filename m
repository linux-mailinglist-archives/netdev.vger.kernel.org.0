Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 711F2361693
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 01:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234941AbhDOXvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 19:51:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:50098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234894AbhDOXvs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 19:51:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 664E2610FB;
        Thu, 15 Apr 2021 23:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618530684;
        bh=wDo8O5dUiuBhn+SFiaTY8QivE8MvzXSrqAZf4iwGaNo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lKkUW01UtB4OF7xm3XKYUDn4TqsQQwzLs/4qGGldZhYXtAPMPNwrteMC9RsUAxhZ7
         QhYEzCJljnmb3BLFTPR8rhHRWxoZOpWRJhaW/WI+/vv2c+3czm69fNdXuH+ApQss3D
         pePknK6Sr1rjgrLlvmzW/H1Im4tjkw9lrCQZYL1s7bAZYtLlwXW0W7mQYoyDIKA3F8
         9CctvENqAID5I3+AjhJzHepifkx3LVjbQRWZEzcbLvN4jlYhPf3585xtaHxA8ba6kr
         cFCXOYPyX+/zt8RWPaYC1V1CNTl6A0OGYBTG+Gf5bw8kjv1WP3xONkR7vgEtGqVSXi
         baid24lcINanQ==
Message-ID: <991d74e8bac9a778ea0e0a4c522613ef39f8819e.camel@kernel.org>
Subject: Re: [PATCH net-next v2 0/6] ethtool: add standard FEC statistics
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, michael.chan@broadcom.com, leon@kernel.org,
        ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        f.fainelli@gmail.com, andrew@lunn.ch, mkubecek@suse.cz,
        ariela@nvidia.com
Date:   Thu, 15 Apr 2021 16:51:23 -0700
In-Reply-To: <20210415225318.2726095-1-kuba@kernel.org>
References: <20210415225318.2726095-1-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-04-15 at 15:53 -0700, Jakub Kicinski wrote:
> This set adds uAPI for reporting standard FEC statistics, and
> implements it in a handful of drivers.
> 
> The statistics are taken from the IEEE standard, with one
> extra seemingly popular but not standard statistics added.
> 
> The implementation is similar to that of the pause frame
> statistics, user requests the stats by setting a bit
> (ETHTOOL_FLAG_STATS) in the common ethtool header of
> ETHTOOL_MSG_FEC_GET.
> 
> Since standard defines the statistics per lane what's
> reported is both total and per-lane counters:
> 
>  # ethtool -I --show-fec eth0
>  FEC parameters for eth0:
>  Configured FEC encodings: None
>  Active FEC encoding: None
>  Statistics:
>   corrected_blocks: 256
>     Lane 0: 255
>     Lane 1: 1
>   uncorrectable_blocks: 145
>     Lane 0: 128
>     Lane 1: 17
> 
> v2: check for errors in mlx5 register access
> 
> Jakub Kicinski (6):
>   ethtool: move ethtool_stats_init
>   ethtool: fec_prepare_data() - jump to error handling
>   ethtool: add FEC statistics
>   bnxt: implement ethtool::get_fec_stats
>   sfc: ef10: implement ethtool::get_fec_stats
>   mlx5: implement ethtool::get_fec_stats

For the series:

Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>

