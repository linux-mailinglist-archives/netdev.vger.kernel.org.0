Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF4E62B8338
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 18:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbgKRRjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 12:39:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:56414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725943AbgKRRjr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 12:39:47 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4919C248D3;
        Wed, 18 Nov 2020 17:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605721186;
        bh=LPpvwJI/gBHb8rGQb9ullpKjv8aBduEkbMnbhCeWQq0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gWypMLsO8joDfpNGTexSwJr9kWUXpp8mHQvbUGacdiXygvlNmGkbImbmtZ44De2BQ
         eqp9N+Tg6J8hOJ7cZsQrCmFt8evvFSwFH0HxNwM7fvAC/8glhmlrL2eDnEKfRgvu8G
         hVS3LiDBAiyGgjxEyPBLUxW3+16xTHqpjr9LhU0Q=
Date:   Wed, 18 Nov 2020 09:39:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Antonio Cardace <acardace@redhat.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH net-next v5 3/6] netdevsim: support ethtool ring and
 coalesce settings
Message-ID: <20201118093945.2565691d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201118171827.48143-4-acardace@redhat.com>
References: <20201118171827.48143-1-acardace@redhat.com>
        <20201118171827.48143-4-acardace@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 18:18:24 +0100 Antonio Cardace wrote:
>  	debugfs_create_bool("report_stats_tx", 0600, dir,
> -			    &ns->ethtool.report_stats_tx);
> +			    &ns->ethtool.pauseparam.report_stats_tx);

Sorry missed that in v4, this belongs in the previous patch, otherwise
patch 2 breaks bisection.
