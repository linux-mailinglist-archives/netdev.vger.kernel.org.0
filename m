Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E58C9407553
	for <lists+netdev@lfdr.de>; Sat, 11 Sep 2021 08:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235213AbhIKG2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Sep 2021 02:28:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbhIKG2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Sep 2021 02:28:01 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA7BEC061574
        for <netdev@vger.kernel.org>; Fri, 10 Sep 2021 23:26:48 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id e21so8743198ejz.12
        for <netdev@vger.kernel.org>; Fri, 10 Sep 2021 23:26:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Ha2H/PXD+Bdo/PGL8NlHS0bVy5vbg6Y/9CjkPLvj13E=;
        b=lkSs87S5IvM1uPqZzWGoerR1d/gDMRZT8e5bidKh5SzFBjUglokyZ8Cpv6VTYZ+Eea
         8kDpOL8og6pD8j12H+vAlDzB1e+UkA9ZP7m+J6sg6N83kuB07kv38c3XTrAUJRuw05n8
         ly8DFArXrlDh4/++xrrjxEB0cvDBGshJwila8hUhJ8kQmPU3dh6D+KIgyoec+R2pYuFc
         kU04iUeVwhtJW1bjD6fUl/l8LT/uXkqLpnsnjxv3avXlQdBIfsmNoGcxyKuiOyE+BpuP
         rkOcH1pI+SPZSGvM07gWYJlmEbzSfAqcyTSylCY7fTYwvWAhhp4pLn6YcbdHvteIcW0R
         s+Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Ha2H/PXD+Bdo/PGL8NlHS0bVy5vbg6Y/9CjkPLvj13E=;
        b=u2+rt+zCtCHeYX1QLA+AjoBm+k7MK1RgN8bgfbswXQzLo7PKdTbGGbmjzmeJaf2s4f
         6BEB4GPQa6yTt7Xki1METGVw59weyNMK11lER3x/9jR6JCN1D8MF+T/VuXpyp3GeOsCs
         D1+7IEgeZCrSQ5etDtsq7oZKPWgyvrlP1bfh/VgRco89eo3sYW4OnRMudBgW3d3J8Q5Y
         T81US+6/OO3fy1ICByP8PYfst+l0hvpmYQQXWduFiZ4s4AON7JG8GahbPiOjk8f+vmCr
         JZwClEHdYwgBe6bCgVjOhLT9ro8laEdFaZid4IERwtEKxYQbEUo39KJ7ERiLaIp4Y0pt
         O6QQ==
X-Gm-Message-State: AOAM532PVd1z+K6d2OndxhdKXUEsDtU+SbpKW8+VRBwGp3KO/p9I+Mcw
        k27smUUWvXbrYjeAvJc2Xl6tI8US+RU=
X-Google-Smtp-Source: ABdhPJyATHCn1Vm1hUO6qBuVKLtngLgd5XkdJLy+fRtZv98n4ytPZwZOTaLZqU31qznxgEub8Io16A==
X-Received: by 2002:a17:906:3383:: with SMTP id v3mr1471570eja.213.1631341607277;
        Fri, 10 Sep 2021 23:26:47 -0700 (PDT)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id r22sm332963ejj.91.2021.09.10.23.26.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 Sep 2021 23:26:46 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: Urgent  Bug report: PPPoE ioctl(PPPIOCCONNECT): Transport
 endpoint is not connected
From:   Martin Zaharinov <micron10@gmail.com>
In-Reply-To: <6A3B4C11-EF48-4CE9-9EC7-5882E330D7EA@gmail.com>
Date:   Sat, 11 Sep 2021 09:26:45 +0300
Cc:     =?utf-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <A16DCD3E-43AA-4D50-97FC-EBB776481840@gmail.com>
References: <7EE80F78-6107-4C6E-B61D-01752D44155F@gmail.com>
 <YQy9JKgo+BE3G7+a@kroah.com> <08EC1CDD-21C4-41AB-B6A8-1CC2D40F5C05@gmail.com>
 <20210808152318.6nbbaj3bp6tpznel@pali>
 <8BDDA0B3-0BEE-4E80-9686-7F66CF58B069@gmail.com>
 <20210809151529.ymbq53f633253loz@pali>
 <FFD368DF-4C89-494B-8E7B-35C2A139E277@gmail.com>
 <20210811164835.GB15488@pc-32.home>
 <81FD1346-8CE6-4080-84C9-705E2E5E69C0@gmail.com>
 <6A3B4C11-EF48-4CE9-9EC7-5882E330D7EA@gmail.com>
To:     Guillaume Nault <gnault@redhat.com>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Guillaume

Main problem is overload of service because have many finishing ppp =
(customer) last two day down from 40-50 to 100-200 users and make =
problem when is happen if try to type : ip a wait 10-20 sec to start =
list interface .
But how to find where is a problem any locking or other.
And is there options to make fast remove ppp interface from kernel to =
reduce this load.


Martin

> On 7 Sep 2021, at 9:42, Martin Zaharinov <micron10@gmail.com> wrote:
>=20
> Perf top from text
>=20
>=20
> PerfTop:   28391 irqs/sec  kernel:98.0%  exact: 100.0% lost: 0/0 drop: =
0/0 [4000Hz cycles],  (all, 12 CPUs)
> =
--------------------------------------------------------------------------=
--------------------------------------------------------------------------=
-----------------------------------------------------------
>=20
>    17.01%  [nf_conntrack]           [k] nf_ct_iterate_cleanup
>     9.73%  [kernel]                 [k] mutex_spin_on_owner
>     9.07%  [pppoe]                  [k] pppoe_rcv
>     2.77%  [nf_nat]                 [k] device_cmp
>     1.66%  [kernel]                 [k] osq_lock
>     1.65%  [kernel]                 [k] _raw_spin_lock
>     1.61%  [kernel]                 [k] __local_bh_enable_ip
>     1.35%  [nf_nat]                 [k] inet_cmp
>     1.30%  [kernel]                 [k] =
__netif_receive_skb_core.constprop.0
>     1.16%  [kernel]                 [k] menu_select
>     0.99%  [kernel]                 [k] cpuidle_enter_state
>     0.96%  [ixgbe]                  [k] ixgbe_clean_rx_irq
>     0.86%  [kernel]                 [k] __dev_queue_xmit
>     0.70%  [kernel]                 [k] __cond_resched
>     0.69%  [sch_cake]               [k] cake_dequeue
>     0.67%  [nf_tables]              [k] nft_do_chain
>     0.63%  [kernel]                 [k] rcu_all_qs
>     0.61%  [kernel]                 [k] fib_table_lookup
>     0.57%  [kernel]                 [k] __schedule
>     0.57%  [kernel]                 [k] skb_release_data
>     0.54%  [kernel]                 [k] sched_clock
>     0.54%  [kernel]                 [k] __copy_skb_header
>     0.53%  [kernel]                 [k] dev_queue_xmit_nit
>     0.53%  [kernel]                 [k] _raw_spin_lock_irqsave
>     0.50%  [kernel]                 [k] kmem_cache_free
>     0.48%  libfrr.so.0.0.0          [.] 0x00000000000ce970
>     0.47%  [ixgbe]                  [k] ixgbe_clean_tx_irq
>     0.45%  [kernel]                 [k] timerqueue_add
>     0.45%  [kernel]                 [k] lapic_next_deadline
>     0.45%  [kernel]                 [k] csum_partial_copy_generic
>     0.44%  [nf_flow_table]          [k] nf_flow_offload_ip_hook
>     0.44%  [kernel]                 [k] kmem_cache_alloc
>     0.44%  [nf_conntrack]           [k] nf_conntrack_lock
>=20
>> On 7 Sep 2021, at 9:16, Martin Zaharinov <micron10@gmail.com> wrote:
>>=20
>> Hi=20
>> Sorry for delay but not easy to catch moment .
>>=20
>>=20
>> See this is mpstatl 1 :
>>=20
>> Linux 5.14.1 (demobng) 	09/07/21 	_x86_64_	(12 CPU)
>>=20
>> 11:12:16     CPU    %usr   %nice    %sys %iowait    %irq   %soft  =
%steal  %guest  %gnice   %idle
>> 11:12:17     all    0.17    0.00    6.66    0.00    0.00    4.13    =
0.00    0.00    0.00   89.05
>> 11:12:18     all    0.25    0.00    8.36    0.00    0.00    4.88    =
0.00    0.00    0.00   86.51
>> 11:12:19     all    0.26    0.00    9.62    0.00    0.00    3.91    =
0.00    0.00    0.00   86.21
>> 11:12:20     all    0.85    0.00    6.00    0.00    0.00    4.31    =
0.00    0.00    0.00   88.84
>> 11:12:21     all    0.08    0.00    4.45    0.00    0.00    4.79    =
0.00    0.00    0.00   90.67
>> 11:12:22     all    0.17    0.00    9.50    0.00    0.00    4.58    =
0.00    0.00    0.00   85.75
>> 11:12:23     all    0.00    0.00    6.92    0.00    0.00    2.48    =
0.00    0.00    0.00   90.61
>> 11:12:24     all    0.17    0.00    5.45    0.00    0.00    4.27    =
0.00    0.00    0.00   90.11
>> 11:12:25     all    0.25    0.00    5.38    0.00    0.00    4.79    =
0.00    0.00    0.00   89.58
>> 11:12:26     all    0.60    0.00    1.45    0.00    0.00    2.65    =
0.00    0.00    0.00   95.30
>> 11:12:27     all    0.42    0.00    6.91    0.00    0.00    4.47    =
0.00    0.00    0.00   88.20
>> 11:12:28     all    0.00    0.00    6.75    0.00    0.00    4.18    =
0.00    0.00    0.00   89.07
>> 11:12:29     all    0.17    0.00    3.52    0.00    0.00    5.11    =
0.00    0.00    0.00   91.20
>> 11:12:30     all    1.45    0.00   10.14    0.00    0.00    3.49    =
0.00    0.00    0.00   84.92
>> 11:12:31     all    0.09    0.00    5.11    0.00    0.00    4.77    =
0.00    0.00    0.00   90.03
>> 11:12:32     all    0.25    0.00    3.11    0.00    0.00    4.46    =
0.00    0.00    0.00   92.17
>> Average:     all    0.32    0.00    6.21    0.00    0.00    4.21    =
0.00    0.00    0.00   89.26
>>=20
>>=20
>> I attache and one screenshot from perf top (Screenshot is send on =
preview mail)
>>=20
>> And I see in lsmod=20
>>=20
>> pppoe                  20480  8198
>> pppox                  16384  1 pppoe
>> ppp_generic            45056  16364 pppox,pppoe
>> slhc                   16384  1 ppp_generic
>>=20
>> To slow remove pppoe session .
>>=20
>> And from log :=20
>>=20
>> [2021-09-07 11:01:11.129] vlan3020: ebdd1c5d8b5900f6: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>> [2021-09-07 11:01:53.621] vlan643: ebdd1c5d8b59014e: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>> [2021-09-07 11:02:00.359] vlan1616: ebdd1c5d8b590195: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>> [2021-09-07 11:02:05.859] vlan3020: ebdd1c5d8b5900d8: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>> [2021-09-07 11:02:08.258] vlan3005: ebdd1c5d8b590190: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>> [2021-09-07 11:02:13.820] vlan643: ebdd1c5d8b590152: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>> [2021-09-07 11:02:15.839] vlan727: ebdd1c5d8b590144: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>> [2021-09-07 11:02:20.139] vlan1693: ebdd1c5d8b59019f: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>>=20
>>> On 11 Aug 2021, at 19:48, Guillaume Nault <gnault@redhat.com> wrote:
>>>=20
>>> On Wed, Aug 11, 2021 at 02:10:32PM +0300, Martin Zaharinov wrote:
>>>> And one more that see.
>>>>=20
>>>> Problem is come when accel start finishing sessions,
>>>> Now in server have 2k users and restart on one of vlans 3 Olt with =
400 users and affect other vlans ,
>>>> And problem is start when start destroying dead sessions from vlan =
with 3 Olt and this affect all other vlans.
>>>> May be kernel destroy old session slow and entrained other users by =
locking other sessions.
>>>> is there a way to speed up the closing of stopped/dead sessions.
>>>=20
>>> What are the CPU stats when that happen? Is it users space or kernel
>>> space that keeps it busy?
>>>=20
>>> One easy way to check is to run "mpstat 1" for a few seconds when =
the
>>> problem occurs.
>>>=20
>>=20
>=20

