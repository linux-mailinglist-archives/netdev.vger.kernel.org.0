Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 344AD2D8A99
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 00:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408172AbgLLXMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 18:12:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:46752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725822AbgLLXMH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 18:12:07 -0500
Date:   Sat, 12 Dec 2020 15:11:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607814686;
        bh=bCJ0vEa+NXKDqpdHivUO/Cf39yNtoHaB+vwlCR4wO60=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=Gf8yIPjKuFCMf4x4E9D+2oL2eGsxgC1L4B0TBLV64mbEeZ7gLoZmbl6S8cvjtAAEr
         lu9iq7sEJFbz5p+mc6N597jxqrtyf5kd6mDQpsV56w3o51/Xi+CA1eD0KDe46FtAHh
         zeb3BYEo8V+pghgMpIhrmz92oPylJZghKxvnHNipPykLYInfLlJTBR3F3AWEuMNzIK
         DD+2FsZqIruH4mAppeV9HA5C7NLmV20ynPeHmyV1a9CpMoKJBflx9X2weOFSMrB7iw
         /5XPA9PeFEb+NwySfwRL0TgHIlQpSoopYG8okkFQoz/8yqyaoOjLtcwh/vhECXJ/Q/
         grB0h4z/eoImw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     SeongJae Park <sjpark@amazon.com>,
        David Miller <davem@davemloft.net>,
        SeongJae Park <sjpark@amazon.de>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Florian Westphal <fw@strlen.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        netdev <netdev@vger.kernel.org>, rcu@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] net/ipv4/inet_fragment: Batch fqdir destroy works
Message-ID: <20201212151125.1d8074a4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CANn89iKGU6_OusKfXeoT0hQN2kto2RF_RpL3GNBeB54iqvqvXw@mail.gmail.com>
References: <20201211112405.31158-1-sjpark@amazon.com>
        <CANn89iKGU6_OusKfXeoT0hQN2kto2RF_RpL3GNBeB54iqvqvXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Dec 2020 15:36:53 +0100 Eric Dumazet wrote:
> On Fri, Dec 11, 2020 at 12:24 PM SeongJae Park <sjpark@amazon.com> wrote:
> > From: SeongJae Park <sjpark@amazon.de>
> >
> > On a few of our systems, I found frequent 'unshare(CLONE_NEWNET)' calls
> > make the number of active slab objects including 'sock_inode_cache' type
> > rapidly and continuously increase.  As a result, memory pressure occurs.
> 
> Reviewed-by: Eric Dumazet <edumazet@google.com>
> 
> Jakub or David might change the patch title, no need to resend.

"inet: frags: batch fqdir destroy works" it is.

Applied, thanks!
