Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 244C531E8F6
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 12:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232389AbhBRLF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 06:05:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:57182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231272AbhBRKiE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Feb 2021 05:38:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 768DF64DE9;
        Thu, 18 Feb 2021 10:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613644633;
        bh=GC/+qGL4jWqb0AlBV+rnFjuMEIRv27x+lfUlOQ/3QCM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LHZywTMg4ggnBnh7h4rxOOyA9sZaj0kObrbRX3ik6J89xnZQYGoj0GVy/YFtS/BIf
         eFOP4g90bnhdKzcv4HQTF0x5WOJgJSkKGor9AT7lQyMyzD+RX9sRitFY9BsV4eFP2Z
         hL6MC4Ps52qUO/P5Mz7p7IYe139BtyTv8LTLsx5rtQaMmlW9oMOk1Q8lW/Xi07xgnb
         HHRz2QU/vC1lEvtkpf4aPCNAxJq56ysa0w+wgpB6Qi815ploMBwk86E6pUZxGP5bFf
         Gwdovi+95e3ZsKIbzW0aex+m2WLwo6GCg6vLLXiCQubvVc5YGXQ9KQUP0EfqL5CN8i
         2ZlX6yAM/EL6A==
Date:   Thu, 18 Feb 2021 12:37:09 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Martin Schiller <ms@dev.tdt.de>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next RFC v4] net: hdlc_x25: Queue outgoing LAPB frames
Message-ID: <YC5DVTHHd6OOs459@unreal>
References: <20210216201813.60394-1-xie.he.0141@gmail.com>
 <YC4sB9OCl5mm3JAw@unreal>
 <CAJht_EN2ZO8r-dpou5M4kkg3o3J5mHvM7NdjS8nigRCGyih7mg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJht_EN2ZO8r-dpou5M4kkg3o3J5mHvM7NdjS8nigRCGyih7mg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 18, 2021 at 01:07:13AM -0800, Xie He wrote:
> On Thu, Feb 18, 2021 at 12:57 AM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > It is nice that you are resending your patch without the resolution.
> > However it will be awesome if you don't ignore review comments and fix this "3 - 1"
> > by writing solid comment above.
>
> I thought you already agreed with me? It looks like you didn't?
>
> I still don't think there is any problem with my current way.
>
> I still don't understand your point. What problem do you think is
> there? Why is your way better than my way? I've already given multiple
> reasons about why my way is better than yours. But you didn't explain
> clearly why yours is better than mine.

It is not me who didn't explain, it is you who didn't want to write clear
comment that describes the headroom size without need of "3 - 1".

So in current situation, you added two things: comment and assignment.
Both of them aren't serve their goals. Your comment doesn't explain
enough and needs extra help and your assignment is useless without
comment.

Thanks
