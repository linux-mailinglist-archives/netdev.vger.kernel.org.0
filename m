Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43ED07C5F4
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 17:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728651AbfGaPSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 11:18:47 -0400
Received: from mail-io1-f41.google.com ([209.85.166.41]:33702 "EHLO
        mail-io1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728226AbfGaPSp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 11:18:45 -0400
Received: by mail-io1-f41.google.com with SMTP id z3so18215577iog.0;
        Wed, 31 Jul 2019 08:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=xuzQG46X17DsEpMfhQGwH6+7cSvNDOWNUULAqRblVrE=;
        b=G8cVLquixj9RJ5F5DWhx6mOs8B+caqB1IGByYL8abw/1gBpACEU5BpYF8+NgotXC0c
         kKFV0rfirAAyP1gXl5HsIPjwuIAgD6W3pwYE37ceM86I+WBcmmGB6FALWXa2pbTFhsAI
         j9dMpX123uZAoJktmdulPiM/Im15dZjEJR/gEkbqmrdlYkk/cNQXSuvH79gDb63wb7jC
         DR10MLq6Q44IP34Qg1k00FENeVQ374/hDv78ASzDgvMq4m6w4lZL1yBwTpb4b0IS0pbT
         AGIOY0ljrVqg9Wpfg2MptFcrVEB9coViK9KJnyEEB7gI5WHMvEzhmUNPCPqQnOxL+dVB
         h/9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xuzQG46X17DsEpMfhQGwH6+7cSvNDOWNUULAqRblVrE=;
        b=YWerkMsG+rUekFLSvsTPMqcF7iX/uuG9UrH9Dgb3i2S2CYx8/5ujPxYyJUSZGWZ6PV
         AuBoePJ8aPJ9MKiUofPKpuRHdOt0bl8KRClmeZdVPtm5jk9XuADbdjIRYew5xCyFR7kH
         /Al+KffoqSVPrYxm3wXnQ00qVUoi5dLW753h1PB4Fmuy5TBkMU8XHO2GRMrPIVA/03/a
         Gwy8xZFGPJZUGaIG362Jo/2fmK2+UmPkjHiUqdmRxjVJWjBIAzKpNP6NSpAwq8txLx0O
         +wOoD1bFvn0e0Xol2O/hnXpQd+RebdZOlxgtBAMLxSDqoSmsnWBVN5lPuVNPR9exN771
         mqTw==
X-Gm-Message-State: APjAAAXPGnj5wXpfXiGBxXwLu4wQRS6I9nVE5KlRYwftqmsB4vf1Z48b
        PvWqJzwMKE1G3GdG7UY49N0QrcDK
X-Google-Smtp-Source: APXvYqxOFT93yS6bZ+rjOjuZjbsCKjPMDY24dDZN+q//o80Gi+2JowsiHkq+n8GrBvsuD0LMbsA7dg==
X-Received: by 2002:a5d:8d12:: with SMTP id p18mr1923906ioj.251.1564585996161;
        Wed, 31 Jul 2019 08:13:16 -0700 (PDT)
Received: from ?IPv6:2601:284:8200:5cfb:d4eb:7c00:40f8:97e? ([2601:284:8200:5cfb:d4eb:7c00:40f8:97e])
        by smtp.googlemail.com with ESMTPSA id t4sm51695019iop.0.2019.07.31.08.13.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 08:13:15 -0700 (PDT)
Subject: Re: Reminder: 99 open syzbot bugs in net subsystem
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>, dvyukov@google.com,
        netdev@vger.kernel.org, fw@strlen.de, i.maximets@samsung.com,
        edumazet@google.com, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <20190724163014.GC673@sol.localdomain>
 <20190724.111225.2257475150626507655.davem@davemloft.net>
 <20190724183710.GF213255@gmail.com>
 <20190724.130928.1854327585456756387.davem@davemloft.net>
 <20190724210950.GH213255@gmail.com>
 <1e07462d-61e2-9885-edd0-97a82dd7883e@gmail.com>
 <20190731025722.GE687@sol.localdomain>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5b38eb74-43d0-c7d7-88e1-103a4f82333f@gmail.com>
Date:   Wed, 31 Jul 2019 09:13:11 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190731025722.GE687@sol.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/30/19 8:57 PM, Eric Biggers wrote:
> syzbot finds a lot of security bugs, and security bugs are important.  And the
> bugs are still there regardless of whether they're reported by human or bot.
> 
> Also, there *are* bugs being fixed because of these reminders; some subsystem
> maintainers have even fixed all the bugs in their subsystem.  But I can
> understand that for subsystems with a lot of open bug reports it's overwhelming.
> 
> What I'll try doing next time (if there *is* a next time; it isn't actually my
> job to do any of this, I just care about the security and reliability of
> Linux...) is for subsystems with lots of open bug reports, only listing the ones
> actually seen in the last week or so, and perhaps also spending some more time
> manually checking those bugs.  That should cut down the noise a lot.

I don't think anyone questions the overall value of syzbot. It's the
maintenance of bug reports that needs refining.

As an example, this one:

https://syzkaller.appspot.com/bug?id=079bd8408abd95b492f127edf0df44ddc09d9405

was in reality a very short-lived bug in net-next but because bpf-next
managed to merge net-next in the small time window, the bug life seems
more extended that it apparently was (fuzzy words since we do not know
which commit fixed it).

Also, there is inconsistency with the report. It shows a bisected commit of:

commit f40b6ae2b612446dc970d7b51eeec47bd1619f82
Author: David Ahern <dsahern@gmail.com>
Date: Thu May 23 03:27:55 2019 +0000

  ipv6: Move pcpu cached routes to fib6_nh

yet the report shows an entry in net tree on April 27. Even the net
instance on June 14 is questionable given that the above commit is only
in net-next on June 14.

Taking all of those references out and there are 2 'real', unique
reports - the linux-next on May 31 and the net-next on June 5.

Given that nothing has appeared in the last 8 weeks it seems clear to me
that this bug has been fixed we just don't know by which commit.

If there is a way to reduce to some of that information or even to have
a button on that console that says 'apparently fixed' and close it would
be a help.
