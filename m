Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34F9A363580
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 15:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbhDRNZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 09:25:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:37660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229671AbhDRNZl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Apr 2021 09:25:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D796610EA;
        Sun, 18 Apr 2021 13:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618752313;
        bh=OuJ1kSaJZH5doYSuThOcTU7jidENxl8t3U8OJI9T/pI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JYygGQmIaws8/2RmS8FYAZiXRM5eMbUTCEEgELMhwoqvhtFl3gm6Orpr5Oi5bMBQ+
         URlFurjG6Xs/o3dn+T9uoVmbYaw7TjUFmBzOmA3bfr3LYuGvS1DhvH5rPrFK58B3QQ
         ra8hFLERefwN3z4caH4tMSxT+VX2cO4/f2KJUvueCzBOR7yWf8PUlMd3HzZ1TZwrzU
         fwIJKVxmulsV+jbzhZNAhY0dfwW/v4bdBg/bBjFFFE4WCJ8uzQjDySWrkySyec3ECK
         vsFQM0kRcaghz+n3i/FvJ9tJhG50+B1w/j+FKWCR8XO8V9HJ3EotzTtDzKde1iaRlL
         LoBsvW5r0SLQw==
Date:   Sun, 18 Apr 2021 16:25:09 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        dsahern@gmail.com
Subject: Re: [PATCH iproute2] rdma: stat: fix return code
Message-ID: <YHwzNYSZbrTiri/M@unreal>
References: <9cc2c9bdb7bf7c235bf2e7a63b9e13b0cdae58c5.1618750205.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9cc2c9bdb7bf7c235bf2e7a63b9e13b0cdae58c5.1618750205.git.aclaudi@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 18, 2021 at 02:56:30PM +0200, Andrea Claudi wrote:
> libmnl defines MNL_CB_OK as 1 and MNL_CB_ERROR as -1. rdma uses these
> return codes, and stat_qp_show_parse_cb() should do the same.
> 
> Fixes: 16ce4d23661a ("rdma: stat: initialize ret in stat_qp_show_parse_cb()")
> Reported-by: Leon Romanovsky <leon@kernel.org>
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> ---
>  rdma/stat.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Thanks,
Acked-by: Leon Romanovsky <leonro@nvidia.com>
