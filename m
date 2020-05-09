Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E08AF1CBDCB
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 07:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728806AbgEIFeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 01:34:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:57258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725820AbgEIFeI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 01:34:08 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C625E21775;
        Sat,  9 May 2020 05:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589002448;
        bh=OF7xDddeQIYus8MCBYwmjSFSmjahaMVyxZGwA9Fiq+I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fSG1f29zc7KMW0j1BYCggfPqAKIT3g30Phu6DmnKqzyqeL/lX2a+x/0P2yTqczsIw
         6t8TF4DuhUTLtSp09z1QR6rMAU3/VXfQKLq3OwZW/5YViNKd8GAogyl53RyYYQ6rZB
         Rum8nv4epAKCRP9lqAbW5xaiJrA6zqrXCVH539QI=
Date:   Fri, 8 May 2020 22:34:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Ahern <dsahern@kernel.org>, Wei Wang <weiwan@google.com>,
        "Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?=" <maze@google.com>
Subject: Re: [PATCH net-next] ipv6: use DST_NOCOUNT in ip6_rt_pcpu_alloc()
Message-ID: <20200508223406.4fb88676@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200508143414.42022-1-edumazet@google.com>
References: <20200508143414.42022-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  8 May 2020 07:34:14 -0700 Eric Dumazet wrote:
> We currently have to adjust ipv6 route gc_thresh/max_size depending
> on number of cpus on a server, this makes very little sense.
> 
> If the kernels sets /proc/sys/net/ipv6/route/gc_thresh to 1024
> and /proc/sys/net/ipv6/route/max_size to 4096, then we better
> not track the percpu dst that our implementation uses.
> 
> Only routes not added (directly or indirectly) by the admin
> should be tracked and limited.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied, thank you!
