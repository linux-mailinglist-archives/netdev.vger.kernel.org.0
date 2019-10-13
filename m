Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD1ED5840
	for <lists+netdev@lfdr.de>; Sun, 13 Oct 2019 23:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729296AbfJMVKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Oct 2019 17:10:52 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:35708 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727632AbfJMVKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Oct 2019 17:10:52 -0400
Received: by mail-ed1-f68.google.com with SMTP id v8so13105574eds.2
        for <netdev@vger.kernel.org>; Sun, 13 Oct 2019 14:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uMgoaDS3bS3W93Sjn53qc8fO6lRrYIzsYvQkBgchiLs=;
        b=LUogR6kiFKn6s7aEgLbPHg8axUhpgp5hB2Nt8uR0GtgNO4NoaWJofazAYK6les3on5
         hLeRm8mOfaUE1aZ6ejAEkhWnGDtW5BBMPfSiXAfX2UIEzpjfkK0zw50S7j7dWGwpYALs
         Sqf44zKVYZZ0HuJ5Zi0xNdOHoIHEbOg7nGEALPo5Z12Jq/irn0Eqz2o8IspvzXU7s6EX
         tfLhM9QM5tL6oDoKjw2hpjs4JLTilRLYrxiJPx0xPOT5oOYMHC3PJheVYL/AZRH1vg78
         Wry5mcOeXjTfw/TsZsm3iZ0Y1dA2RBOoCvRRix8lUUCEMOLgL4F0g6qpH1wPHzUQIVJY
         bzbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uMgoaDS3bS3W93Sjn53qc8fO6lRrYIzsYvQkBgchiLs=;
        b=EiUaXuUq6UoPqQO03OBnxqKbMFKMkpIhyPd072BrC1kPEKO0TSEzHabGvP8wV8955z
         oQY4NjAvLrl1wmBbufjaAfohb1C+3fvD72nTX3FuriFV+0WDX8m7OuDz/C4g5aw3n8JL
         xtYAYA1sFjla/AUvxbkybxX3/Z8TcTp3BmY4AH1Ywa7fDDK/uIJhExIuDHtyMp89lUNQ
         0YjQXu5KWC5Fzh7csdPIGTJ3+VzeKaab9+XT5xOMRIIPlykH6JyPrSc4J00zCzpsnVfs
         /uTxeX+jx5J7SLMWmHKXzh7uS+bpws9Vrg9UFfAQxUmNOVZMMyrWY5Xq6vNvBwoR6xY4
         HjFw==
X-Gm-Message-State: APjAAAUImNhUpftRz0yIZ3yzbxzgjp3EcTdvqi9sYv6yOj2W+RzLvbR3
        jw4bJxPXWn3QQjBN6+XIwtTHI+fFaoBZmv/1RjI=
X-Google-Smtp-Source: APXvYqz0KM23gagMfz7iSPk9cHkqMTGIRKjiVqRwgAOjht564G/l6FDIprBKBfz4KP0zAcE4UQwIhlYNGw631DIsFc4=
X-Received: by 2002:a17:906:2490:: with SMTP id e16mr25978984ejb.182.1571001050293;
 Sun, 13 Oct 2019 14:10:50 -0700 (PDT)
MIME-Version: 1.0
References: <a69550fc-b545-b5de-edd9-25d1e3be5f6b@ti.com> <87v9sv3uuf.fsf@linux.intel.com>
 <7fc6c4fd-56ed-246f-86b7-8435a1e58163@ti.com> <87r23j3rds.fsf@linux.intel.com>
In-Reply-To: <87r23j3rds.fsf@linux.intel.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 14 Oct 2019 00:10:39 +0300
Message-ID: <CA+h21hon+QzS7tRytM2duVUvveSRY5BOGXkHtHOdTEwOSBcVAg@mail.gmail.com>
Subject: Re: taprio testing - Any help?
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     Murali Karicheri <m-karicheri2@ti.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vinicius,

On Sat, 12 Oct 2019 at 00:28, Vinicius Costa Gomes
<vinicius.gomes@intel.com> wrote:
>
> Hi,
>
> Murali Karicheri <m-karicheri2@ti.com> writes:
>
> > Hi Vinicius,
> >
> > On 10/11/2019 04:12 PM, Vinicius Costa Gomes wrote:
> >> Hi Murali,
> >>
> >> Murali Karicheri <m-karicheri2@ti.com> writes:
> >>
> >>> Hi,
> >>>
> >>> I am testing the taprio (802.1Q Time Aware Shaper) as part of my
> >>> pre-work to implement taprio hw offload and test.
> >>>
> >>> I was able to configure tap prio on my board and looking to do
> >>> some traffic test and wondering how to play with the tc command
> >>> to direct traffic to a specfic queue. For example I have setup
> >>> taprio to create 5 traffic classes as shows below;-
> >>>
> >>> Now I plan to create iperf streams to pass through different
> >>> gates. Now how do I use tc filters to mark the packets to
> >>> go through these gates/queues? I heard about skbedit action
> >>> in tc filter to change the priority field of SKB to allow
> >>> the above mapping to happen. Any example that some one can
> >>> point me to?
> >>
> >> What I have been using for testing these kinds of use cases (like iperf)
> >> is to use an iptables rule to set the priority for some kinds of traffic.
> >>
> >> Something like this:
> >>
> >> sudo iptables -t mangle -A POSTROUTING -p udp --dport 7788 -j CLASSIFY --set-class 0:3
> > Let me try this. Yes. This is what I was looking for. I was trying
> > something like this and I was getting an error
> >
> > tc filter add  dev eth0 parent 100: protocol ip prio 10 u32 match ip
> > dport 10000 0xffff flowid 100:3
> > RTNETLINK answers: Operation not supported
> > We have an error talking to the kernel, -1
>
> Hmm, taprio (or mqprio for that matter) doesn't support tc filter
> blocks, so this won't work for those qdiscs.
>
> I never thought about adding support for it, it looks very interesting.
> Thanks for pointing this out. I will add this to my todo list, but
> anyone should feel free to beat me to it :-)
>
>
> Cheers,
> --
> Vinicius

What do you mean taprio doesn't support tc filter blocks? What do you
think there is to do in taprio to support that?
I don't think Murali is asking for filter offloading, but merely for a
way to direct frames to a certain traffic class on xmit from Linux.
Something like this works perfectly fine:

sudo tc qdisc add dev swp2 root handle 1: taprio num_tc 2 map 0 1
queues 1@0 1@1 base-time 1000 sched-entry S 03 300000 flags 2
# Add the qdisc holding the classifiers
sudo tc qdisc add dev swp2 clsact
# Steer L2 PTP to TC 1 (see with "tc filter show dev swp2 egress")
sudo tc filter add dev swp2 egress prio 1 u32 match u16 0x88f7 0xffff
at -2 action skbedit priority 1

However, the clsact qdisc and tc u32 egress filter can be replaced
with proper use of the SO_PRIORITY API, which is preferable for new
applications IMO.

I'm trying to send a demo application to tools/testing/selftests/
which sends cyclic traffic through a raw L2 socket at a configurable
base-time and cycle-time, along with the accompanying scripts to set
up the receiver and bandwidth reservation on an in-between switch. But
I have some trouble getting the sender application to work reliably at
100 us cycle-time, so it may take a while until I figure out with
kernelshark what's going on.

Regards,
-Vladimir
