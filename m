Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4483F35E63D
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 20:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347666AbhDMSYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 14:24:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:51076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232756AbhDMSYA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 14:24:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B1986052B;
        Tue, 13 Apr 2021 18:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618338220;
        bh=ide1FZBdOgAXXM6BbM3wXy1pVH2cCNpiiK+DxFPazL8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=izUSfN8w+f9kp99myDVrE8TytYSXbs0jQYwUjrIHPxOCyyvPeR+JB11WyxNldtE0h
         6DzwP6jl6QtUp3PHY4gNLxN0VW7poL0eZvyJ3mjKm/zTsZn6jEIpVlBkLhIpRZMQKR
         6A3htQfDWi5AbxNgt55+MbTiV8eqeBU4beTZzlQ0ZteNqEMyuL+RYZxpZ1hNKlbsZ+
         9247pd6Mn1YDPQVu2qPtIL99qQk/Ss4kunEsmz/cvZXnEiZI5XER4mlurb+oMrzPMy
         9KKlIdSSEMRatgTBLiaaNVBpdf8Q72QtmAHnc6x/FFuq4SkkQJg6bzvieZihrGAGCX
         2fGOtEBKD3oTA==
Date:   Tue, 13 Apr 2021 11:23:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonathon Reinhart <jonathon.reinhart@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH] net: Make tcp_allowed_congestion_control readonly in
 non-init netns
Message-ID: <20210413112339.263089fb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210413070848.7261-1-jonathon.reinhart@gmail.com>
References: <20210413070848.7261-1-jonathon.reinhart@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Apr 2021 03:08:48 -0400 Jonathon Reinhart wrote:
> Fixes: 9cb8e048e5d9: ("net/ipv4/sysctl: show tcp_{allowed, available}_congestion_control in non-initial netns")

nit: no semicolon after the hash
