Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA58B19271F
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 12:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbgCYL2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 07:28:04 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:36136 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbgCYL2D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 07:28:03 -0400
Received: by mail-qt1-f195.google.com with SMTP id m33so1797142qtb.3
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 04:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tlapnet.cz; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cFpiKQKfEyBf7kVwQiPJyLs0REO1rSVoozH+YImjnPg=;
        b=bSSJG6FrwVE4agmDIlnhFQe7j6p/HjEGSnGoqBjswzogGM2N6+Ktoam0Q+43e6wNxp
         8EqCn0kATjw+xTodeDm4otHqhtFNYpGm2T0MH9a28CUCHSLZT386WGZ5LPor+RPgbZ3J
         fML9vt5Z1i6N4sxfrsh/+8x3gYcxv5nUg5v7ETpw3GhogxQ93NtNavCcx3N41KMAgC6l
         1+3lei868dtZe1mQTEJmdayRm/5LoQlhi4Sxgi3/dh3Vj7BlFz1zvz5SttHnmJmuFZn+
         unKpLYjiG7FMNW4JkQZkBCvc6URx75fVNEnBbDdCf4Iyt8HLuUn9OJR1IzVdrKkl+is7
         LGCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cFpiKQKfEyBf7kVwQiPJyLs0REO1rSVoozH+YImjnPg=;
        b=WdPzw6T4SRuJ/lvDOODjJc8NwAWK1oZz7xwcRJxz7/BeQXcO16VvhZMAmgendZKZqv
         DffZPayzivd7UT7PjpDc651qGRGNH5GzjqloP4E3UP4O5WYfCK4vMVuIBf32NOuscS1+
         WxWmQ/8I5bTKckLuwh5fTTAoybzSTFXZhiJk/kD4voKkFaMrewHNO4g6ybwSFbV3ESOl
         7wLpqN963ZUSO1ZsSfe2fDa8sWaOWSm8A3N5KSdfK3yD90Ab9kRJxpnngax4tgrSx31u
         penUw3I99+0Kx2eTph+gFKD/v5Rgr9KJ0UXmqdPyuhpO8YXapXfiHCnFyDW9rIb2eHGo
         RKMQ==
X-Gm-Message-State: ANhLgQ0N/ntxdGp4YtNU29op3IYVtNyLpVHQOh8OOI8VwoaCeMmn74qo
        TmLo/baTKGnFwurm7vMmprrl3zcYiFlRqRMwWYZmkg==
X-Google-Smtp-Source: ADFU+vtNG8EJqiR8tF+TBD882mnvqT6OB6M09HH/d8NEIQKBubD9I1WbiWuLz7GtL98Zk1GVJhEbbcxAwXbOKzIgNXQ=
X-Received: by 2002:ac8:708b:: with SMTP id y11mr2320278qto.195.1585135680673;
 Wed, 25 Mar 2020 04:28:00 -0700 (PDT)
MIME-Version: 1.0
References: <CANxWus8WiqQZBZF9aWF_wc-57OJcEb-MoPS5zup+JFY_oLwHGA@mail.gmail.com>
 <CAM_iQpUPvcyxoW9=z4pY6rMfeAJNAbh21km4fUTSredm1rP+0Q@mail.gmail.com>
 <CANxWus9HZhN=K5oFH-qSO43vJ39Yn9YhyviNm5DLkWVnkoSeQQ@mail.gmail.com> <CAM_iQpWaK9t7patdFaS_BCdckM-nuocv7m1eiGwbO-jdLVNBMw@mail.gmail.com>
In-Reply-To: <CAM_iQpWaK9t7patdFaS_BCdckM-nuocv7m1eiGwbO-jdLVNBMw@mail.gmail.com>
From:   =?UTF-8?Q?V=C3=A1clav_Zindulka?= <vaclav.zindulka@tlapnet.cz>
Date:   Wed, 25 Mar 2020 12:27:49 +0100
Message-ID: <CANxWus9yWwUq9YKE=d5T-6UutewFO01XFnvn=KHcevUmz27W0A@mail.gmail.com>
Subject: Re: iproute2: tc deletion freezes whole server
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 11:57 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> Hm, my bad, please also run `perf report -g` after you record them,
> we need the text output with stack traces.

No problem. I've created reports on two servers with different cards.
See here https://github.com/zvalcav/tc-kernel/tree/master/20200325

> Also, do you have a complete kernel log too? If your network is completely
> down, you need some serial console to capture it, kdump could also help
> if you know how to setup it. The kernel log usually has some indication
> for hangs, for example if we have too much to do with RTNL lock held,
> kernel would complain some other tasks hung on waiting for RTNL.

I've exported dmesg for now. There are problems similar to this one on
both servers
perf: interrupt took too long (3173 > 3128), lowering
kernel.perf_event_max_sample_rate to 63000.

I don't think that kernel crashes because every time it happened
network adapter reset, but nothing else appeared in /var/log. There
are Hold timer expired errors from bird due to our custom BGP setup
with 20s hold. Sometimes there is:
bird6: I/O loop cycle took 5041 ms for 2 events

I'll try to setup kdump. On testing servers the problems are not that
significant and I'm able to access them if I delete from other
interface than I use to access it. Under heavy workload it causes
system freezes. Yet I can't reproduce it on production servers because
it limits our customers. I'll try to generate some traffic to put some
pressure on it if necessary.

> > > > When I call this command on ifb interface or RJ45 interface everything
> > > > is done within one second.
> > >
> > >
> > > Do they have the same tc configuration and same workload?
> >
> > Yes, both reproducers are exactly the same, interfaces are configured
> > in a similar way. I have the most of the offloading turned off for
> > physical interfaces. Yet metallic interfaces don't cause that big
> > delay and SFP+ dual port cards do, yet not all of them. Only
> > difference in reproducers is the interface name. See git repository
> > above, tc-interface_name-upload/download.txt files. I have altered my
> > whole setup in daemon I'm working on to change interfaces used. The
> > only difference is the existence of ingress tc filter rules to
> > redirect traffic to ifb interfaces in production setup. I don't use tc
> > filter classification in current setup. I use nftables' ability to
> > classify traffic. There is no traffic on interfaces except ssh
> > session. It behaves similar way with and without traffic.
>
> This rules out slow path vs. fast path scenario. So, the problem here
> is probably there are just too many TC classes and filters to destroy.

I think this is not the main cause. It happens with a lot of rules,
that is true, but it happens even with deletion of smaller number of
classes and qdiscs. I delete root qdisc just at the exit of my
program. All other changes are only deletions, creations and changes
of hfsc definitions. When I put this setup to production there were
random freezes and BGP timeouts according to changes in network that
caused deletion of tc rules. Not to mention that deletion from ifb or
metallic interfaces works without a flaw.

> Does this also mean it is 100% reproducible when you have the same
> number of classes and filters?

Yes. If it happens on particular server it happens every time. Server
is inaccessible on the interface where I invoke deletion. With heavier
traffic it is inaccessible at all. However there are servers with
identical HW configuration where there are absolutely no problems. We
have about 30 servers and a few of them work without problems. Yet the
most of them freeze during deletion.

> > > > My testing setup consists of approx. 18k tc class rules and approx.
> > > > 13k tc qdisc rules and was altered only with different interface name....
> > >
> > > Please share you tc configurations (tc -s -d qd show dev ..., tc
> > > -s -d filter show dev...).
> >
> > I've placed whole reproducers into repository. Do you need exports of rules too?
> >
> > > Also, it would be great if you can provide a minimal reproducer.
> >
> > I'm afraid that minor reproducer won't cause the problem. This was
> > happening mostly on servers with large tc rule setups. I was trying to
> > create small reproducer for nftables developer many times without
> > success. I can try to create reproducer as small as possible, but it
> > may still consist of thousands of rules.
>
> Yeah, this problem is probably TC specific, as we clean up from
> the top qdisc down to each class and each filter.

As I mentioned earlier, this happens even with specific deletion of
smaller number of rules. Yet I don't oppose it may be caused by tc.
Just inability to process any packets is strange and I'm not sure it
is pure tc problem.

> Can you try to reproduce the number of TC classes, for example,
> down to half, to see if the problem is gone? This could confirm
> whether it is related to the number of TC classes/filters.

Sure. I'll try to reduce the size of tc rule set and test the problem further.

Thank you.
