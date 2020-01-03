Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9910B12FEF9
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 23:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbgACW5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 17:57:42 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56574 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727210AbgACW5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 17:57:42 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E5329158582BE;
        Fri,  3 Jan 2020 14:57:41 -0800 (PST)
Date:   Fri, 03 Jan 2020 14:57:39 -0800 (PST)
Message-Id: <20200103.145739.1949735492303739713.davem@davemloft.net>
To:     tom@herbertland.com
Cc:     ahabdels.dev@gmail.com, netdev@vger.kernel.org,
        simon.horman@netronome.com, willemdebruijn.kernel@gmail.com
Subject: Re: [PATCH v8 net-next 0/9] ipv6: Extension header infrastructure
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CALx6S34vyjNnVbYfjqB1mNDDr3-zQixzXk=kgDqjJ0yxHVCgKg@mail.gmail.com>
References: <CALx6S361vkhp8rLzP804oMz2reuDgQDjm9G_+eXfq5oQpVscyg@mail.gmail.com>
        <20200103.124517.1721098411789807467.davem@davemloft.net>
        <CALx6S34vyjNnVbYfjqB1mNDDr3-zQixzXk=kgDqjJ0yxHVCgKg@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 Jan 2020 14:57:42 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Herbert <tom@herbertland.com>
Date: Fri, 3 Jan 2020 14:31:58 -0800

> On Fri, Jan 3, 2020 at 12:45 PM David Miller <davem@davemloft.net> wrote:
>>
>> From: Tom Herbert <tom@herbertland.com>
>> Date: Fri, 3 Jan 2020 09:35:08 -0800
>>
>> > The real way to combat this provide open implementation that
>> > demonstrates the correct use of the protocols and show that's more
>> > extensible and secure than these "hacks".
>>
>> Keep dreaming, this won't stop Cisco from doing whatever it wants to do.
> 
> See QUIC. See TLS. See TCP fast open. See transport layer encryption.
> These are prime examples where we've steered the Internet from host
> protocols and implementation to successfully obsolete or at least work
> around protocol ossification that was perpetuated by router vendors.
> Cisco is not the Internet!

Seriously, I wish you luck stopping the SRv6 header insertion stuff.

It's simply not happening, no matter what transport layer technology
you throw at the situation.
