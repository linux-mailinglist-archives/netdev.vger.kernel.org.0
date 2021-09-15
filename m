Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7489C40C767
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 16:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234460AbhIOO0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 10:26:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233745AbhIOO0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 10:26:41 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89D92C061574
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 07:25:22 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id h9so6559035ejs.4
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 07:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=9j7i7vbzJmEYdBTxqsYQPc2cl6b/nFVC1LMoAB9kjOY=;
        b=dgfLJw+QTccgDNmSqMioSCpwT+pqVKJ9GQ+UQhE0iR+YYS3PofwNWEVB77HgTTufr7
         k3tF1tPYl/lsdp3KmOCiEiGB1WvfohjPt+cCvqJnvtNJsFAqJnp0Xo8pLNa7mXOc2Lhl
         RtVCCgnqsi1zhuPOFkGdGxey3+TcAijZ5oqw9gjF9efcKCWz0PJ/O2xauEKbRKP53CLK
         DkhCY6cyhdRqhle1kpCtHWnmmowhzW06aH0bagxOwlLcntxmYCDE73OJ7RsAfY7eVutT
         UHHqgJxiXg5SP52IOIHOamrZrtQeCRZce95Hk6XJ21ESxEjH39XrUP9N47VXEH/rRFY0
         ORAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=9j7i7vbzJmEYdBTxqsYQPc2cl6b/nFVC1LMoAB9kjOY=;
        b=wN6MLrZwxI+eGqFpcVpkTXw0q+vw5hoiEfFLoq8XCf1hBBagqOh/2V8B/k61hld56X
         zmci5djpg0ulPFYGM6AAbEw7HEvDGQWJFaNqjNmAwfd8tgqS8kZuX6a7eLoMb0YE8QPI
         Gc4VWSwLTUQ3QtE6xJnTkYBEY96CcbAri4B1qdvmY/GJqdhbFyDaKvLW7IEN3kNObHaB
         Pws5G9Qn+4pZCjj291pJdwrqqHHUQ4RIPorVpjJyMgixHkoa510NGVsv1Q5pmxVmJ+EU
         R0MvTX936IquRIfvEsEik8OxIEOICsU+aTxIAr4y16JllHGK2yKIqakDZsedp70RmP/v
         EPzw==
X-Gm-Message-State: AOAM533bW3VME0k09Y0T4hIBeVBvKr98i+YdOBFhcN/FnmcE4BKc9X6W
        Od0CgaDYjLHEo8nYSZrr914/pmv5AV0=
X-Google-Smtp-Source: ABdhPJwwcmUl4tsyURAun06eRU5SbV1ppBOhs0fvfFNXqpM5Hg5fFev0gyrHXn4pV8FAQa1Z/R2Jnw==
X-Received: by 2002:a17:906:32d6:: with SMTP id k22mr285015ejk.228.1631715920894;
        Wed, 15 Sep 2021 07:25:20 -0700 (PDT)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id u16sm69102ejy.14.2021.09.15.07.25.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 Sep 2021 07:25:20 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: Urgent  Bug report: PPPoE ioctl(PPPIOCCONNECT): Transport
 endpoint is not connected
From:   Martin Zaharinov <micron10@gmail.com>
In-Reply-To: <20210914110038.GA25110@breakpoint.cc>
Date:   Wed, 15 Sep 2021 17:25:17 +0300
Cc:     Guillaume Nault <gnault@redhat.com>,
        netdev <netdev@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <C2588B79-4053-48E7-A053-408762AB01CA@gmail.com>
References: <20210809151529.ymbq53f633253loz@pali>
 <FFD368DF-4C89-494B-8E7B-35C2A139E277@gmail.com>
 <20210811164835.GB15488@pc-32.home>
 <81FD1346-8CE6-4080-84C9-705E2E5E69C0@gmail.com>
 <6A3B4C11-EF48-4CE9-9EC7-5882E330D7EA@gmail.com>
 <A16DCD3E-43AA-4D50-97FC-EBB776481840@gmail.com>
 <E95FDB1D-488B-4780-96A1-A2D5C9616A7A@gmail.com>
 <20210914080206.GA20454@pc-4.home> <20210914095015.GA9076@breakpoint.cc>
 <1724F1B4-5048-4625-88A5-1193D4445D5A@gmail.com>
 <20210914110038.GA25110@breakpoint.cc>
To:     Florian Westphal <fw@strlen.de>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Florian

make test in lab and look much better that before.

see this perf=20

 PerfTop:    6551 irqs/sec  kernel:77.8%  exact: 100.0% lost: 0/0 drop: =
0/0 [4000Hz cycles],  (all, 12 CPUs)
=
--------------------------------------------------------------------------=
--------------------------------------------------------------------------=
-----------------------------------------------------------

    15.70%  [ixgbe]           [k] ixgbe_read_reg
    13.33%  [kernel]          [k] mutex_spin_on_owner
     7.65%  [kernel]          [k] osq_lock
     2.85%  libfrr.so.0.0.0   [.] 0x00000000000ce970
     1.94%  libfrr.so.0.0.0   [.] 0x00000000000ce94e
     1.19%  libc.so.6         [.] 0x0000000000186afa
     1.15%  [kernel]          [k] do_poll.constprop.0
     0.99%  [kernel]          [k] inet_dump_ifaddr
     0.94%  libteam.so.5.6.1  [.] 0x0000000000006470
     0.79%  libc.so.6         [.] 0x0000000000186e57
     0.71%  [ixgbe]           [k] ixgbe_update_mc_addr_list_generic
     0.65%  [kernel]          [k] __fget_files
     0.61%  [kernel]          [k] sock_poll
     0.57%  libteam.so.5.6.1  [.] 0x0000000000009e7d
     0.51%  perf              [.] 0x00000000000bc7b3
     0.51%  libteam.so.5.6.1  [.] 0x0000000000006501
     0.48%  [kernel]          [k] next_uptodate_page
     0.46%  [kernel]          [k] _raw_read_lock_bh
     0.43%  libc.so.6         [.] 0x0000000000186eac
     0.42%  bgpd              [.] 0x0000000000070a46
     0.41%  [pppoe]           [k] pppoe_flush_dev
     0.39%  [kernel]          [k] zap_pte_range


This happened when remove and add new interface on time of drop and =
reconnect users.


now : ip a command work fine !


Martin


> On 14 Sep 2021, at 14:00, Florian Westphal <fw@strlen.de> wrote:
>=20
> Martin Zaharinov <micron10@gmail.com> wrote:
>=20
> [ Trimming CC list ]
>=20
>> Florian:=20
>>=20
>> If you make patch send to test please.
>=20
> Attached.  No idea if it helps, but 'ip' should stay responsive
> even when masquerade processes netdevice events.
> <defer_masq_work.diff>

