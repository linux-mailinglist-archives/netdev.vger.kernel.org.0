Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D684308FC5
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 23:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232862AbhA2WGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 17:06:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:56434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232808AbhA2WFr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 17:05:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE87264DDD;
        Fri, 29 Jan 2021 22:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611957907;
        bh=l/7/jsusAp++NKFfZot3lyD6NorUsWHEeB8B1cfOt2Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tWf82aNTxilH5MMrxIcSGQOjl8TEil4S0NRn6gdbzRSbgwItYEXqzRFvPLIv6d6/4
         U+/dqgGlapI2xFgjuS+w2yu/72r+LViIwIHY0j6Mjt19Bh1qExJgO8pNeDjzIJhhKM
         5FXcCZ5IznjqsFHhbMLzqD496TDa1U0g6vfyin4QQ6yxwIvkuvoxzPwkqt4lSK2w+S
         hs3LB4IFqCNbz9ws5DFyO4v3L6/RUlFXJr81Jh++ZP8zMk1UWpDd4oRqjddAKs6LiB
         S/3V3R21pPJk6nTqi3eAUFuWgJT4ZkM15+Gu1o/X8FcA5zd55P1aoYQ+5yk75pwz1Z
         ziaXVN4rQ0pmQ==
Date:   Fri, 29 Jan 2021 14:05:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     "Willem de Bruijn <willemdebruijn.kernel@gmail.com>--to=Slava Bacherikov" 
        <mail@slava.cc>, Network Development <netdev@vger.kernel.org>
Subject: Re: [net v3] net: ip_tunnel: fix mtu calculation
Message-ID: <20210129140505.37a95f4a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAF=yD-LDhNK_EPS3ff3rEziM+e-XHHhK06WJRR0Z9K395xPnDg@mail.gmail.com>
References: <1611931494-20812-1-git-send-email-vfedorenko@novek.ru>
        <CAF=yD-LDhNK_EPS3ff3rEziM+e-XHHhK06WJRR0Z9K395xPnDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Jan 2021 10:29:29 -0500 Willem de Bruijn wrote:
> On Fri, Jan 29, 2021 at 9:45 AM Vadim Fedorenko <vfedorenko@novek.ru> wrote:
> >
> > dev->hard_header_len for tunnel interface is set only when header_ops
> > are set too and already contains full overhead of any tunnel encapsulation.
> > That's why there is not need to use this overhead twice in mtu calc.
> >
> > Fixes: fdafed459998 ("ip_gre: set dev->hard_header_len and dev->needed_headroom properly")
> > Reported-by: Slava Bacherikov <mail@slava.cc>
> > Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>  
> 
> Acked-by: Willem de Bruijn <willemb@google.com>

Thanks!

I think vger ate this one, Vadim, could you repost?
