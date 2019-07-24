Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBB8873738
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 21:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728821AbfGXTDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 15:03:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:45594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727777AbfGXTDJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 15:03:09 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 076BB22ADB;
        Wed, 24 Jul 2019 19:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563994988;
        bh=W7Y9oN9/ybRA+889iyJc8Sp46nGRbSZs546N0y4ccAw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P/sgd1WEfA1UzlKSlOlf5voa5IZ7DiREeZ6+nCqBiUNNj0aKJB2qaE1zen4VO+9MD
         g40O+XGAtxBTh28lguakyP8uQ4bme4YGIAtcT8dvQZa4WjSMcW8R5HWJxYZWHbQUcg
         HR6eOoDIC35HHu52qFp5VlYGni/vEq//lKPNVIzE=
Date:   Wed, 24 Jul 2019 12:03:06 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        netdev <netdev@vger.kernel.org>, Florian Westphal <fw@strlen.de>,
        i.maximets@samsung.com, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: Reminder: 99 open syzbot bugs in net subsystem
Message-ID: <20190724190305.GG213255@gmail.com>
Mail-Followup-To: Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>, netdev <netdev@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>, i.maximets@samsung.com,
        David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
References: <20190724013813.GB643@sol.localdomain>
 <63f12327-dd4b-5210-4de2-705af6bc4ba4@gmail.com>
 <20190724163014.GC673@sol.localdomain>
 <20190724.111225.2257475150626507655.davem@davemloft.net>
 <20190724183710.GF213255@gmail.com>
 <CANn89iKZcdk-YfqZ-F1toHDLW3Etf5oPR78bXOq0FbjwWyiSMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iKZcdk-YfqZ-F1toHDLW3Etf5oPR78bXOq0FbjwWyiSMQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 08:52:54PM +0200, 'Eric Dumazet' via syzkaller-bugs wrote:
> On Wed, Jul 24, 2019 at 8:37 PM Eric Biggers <ebiggers@kernel.org> wrote:
> 
> > A huge number of valid open bugs are not being fixed, which is a fact.  We can
> > argue about what words to use to describe this situation, but it doesn't change
> > the situation itself.
> >
> > What is your proposed solution?
> 
> syzbot sends emails, plenty  of them, with many wrong bisection
> results, increasing the noise.
> 
> If nobody is interested, I am not sure sending copies of them
> repeatedly will be of any help.
> 
> Maybe a simple monthly reminder with one URL to go to the list of bugs
> would be less intrusive.
> 

The bogus bisection results is a known issue (which I'm trying to convince
Dmitry is important enough to fix...), which is why I manually reviewed all of
them and discarded out all the obviously incorrect ones.  My reminders only
include manually reviewed bisection results.  Obviously there will still be some
looked plausible but are actualy wrong, but I suspect the accuracy is around
80-90% rather than the 40-50% of the raw syzbot bisection results.

- Eric
