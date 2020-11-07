Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECAEF2AA871
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 00:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgKGXmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 18:42:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:34454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbgKGXmO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 18:42:14 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97FE3208E4;
        Sat,  7 Nov 2020 23:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604792534;
        bh=lsjSlgecxEp8lKItZ0KtaX6Fj/9C3uGapq/9CXeEaGw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Zoae1tk4tBKBG4ji0rz3y6i+DeGUYVEoTw7hZoIjZwIUaDdDjl1QEZlfNv2i8O50r
         ZIL1irJngLuRkY51svvRBTsB7P9KyxJoeilAu9ilvO3bdzsZUd2sfswkW+Sgo5zJfi
         VDOCQb0hhnMTu7eE4LRW4p4PTisq6ew6kltW1JP0=
Date:   Sat, 7 Nov 2020 15:42:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     xiakaixu1987@gmail.com
Cc:     irusskikh@marvell.com, andrew@lunn.ch, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] net: atlantic: Remove unnecessary conversion to bool
Message-ID: <20201107154212.71db8d96@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1604631479-32279-1-git-send-email-kaixuxia@tencent.com>
References: <1604631479-32279-1-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  6 Nov 2020 10:57:59 +0800 xiakaixu1987@gmail.com wrote:
> -	cfg->is_qos = (tcs != 0 ? true : false);
> +	cfg->is_qos = (tcs != 0);

!!tcs
