Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC89040AC06
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 12:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbhINKyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 06:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231851AbhINKyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 06:54:40 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45369C061574
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 03:53:23 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id c21so11337530edj.0
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 03:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=0lhRthA/bSo5KcDjr/ssuFwMc8XUsRCWKq5Lwd9TeZk=;
        b=gdsGVEGwGYDqdPvsA1tvoeEqHf1fKhT0TkenZEfAF6yTLh1pN5g9QNdDdWX1cchx2t
         AHh//4loFtqDnUy0/70TVgQWL+uvt5do4euVXLaMjF5ggoX2OxmJaKLBpz8xuhcqaSqA
         r8hPbZm6GJKzI/HFeWomkmeLCfiJLb2npRc///cNSUCITdmmqpbyWJea3+LBTsn9q7tp
         K5/449ED1FISQkYNEacQ2Xc9GccDLa+AQNsNvPwX+UEBMoQ62naPPNceFHwZ2vYLWXgq
         5Z4DhECLqCAme9tTy36KNu5iaRdeYSx2uB0QAx063z2oOtUM5GAVpaalEci9TSaVkltc
         Zf9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=0lhRthA/bSo5KcDjr/ssuFwMc8XUsRCWKq5Lwd9TeZk=;
        b=I1vXK9dpIKSSF2b0yMBwBIj0GwHmy6y7KMKfoh49ARKqCpxNI9ZL+UiY6G03ut5K7P
         svHsTA14L44vb6phvkOoYQ+EoA9kUdTAkTC22QdrfIXmo8JEbY+owTRnbIBL312gMZX3
         2rqLqi98tdvu00GOD3iPxfrYFilBMx7rAi5Re8AEt8ypqam0uNQoUQe72M/wzqpP/2pZ
         eODRXSyc6t/tOMt9LLevc5om9dGW/w3bRm0WYe7bi3SozhGGHfx1WKPvfWPH09HwoHJl
         +OSqSs2QIwXs7ZBsmkVe4CXST027LmXiqmHQYsMoh52VL1vNED5zdGJtN6Dd19CauNmU
         Yfag==
X-Gm-Message-State: AOAM53144KzKVS/0lmPAv25Z/t/9JnbI2vQEdR2bFfHG/q61XmFnV8C7
        rphYlK1XlDhqp48wQjCd42M=
X-Google-Smtp-Source: ABdhPJy9SneASGLsX1BH/2LyBow8qQgjLQ7LjybTQ1Lmfqzb80gOpprmJThdFqX+zZpahW7nmg4sWQ==
X-Received: by 2002:aa7:c38b:: with SMTP id k11mr12886865edq.175.1631616801927;
        Tue, 14 Sep 2021 03:53:21 -0700 (PDT)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id 90sm5170966edc.36.2021.09.14.03.53.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Sep 2021 03:53:21 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: Urgent  Bug report: PPPoE ioctl(PPPIOCCONNECT): Transport
 endpoint is not connected
From:   Martin Zaharinov <micron10@gmail.com>
In-Reply-To: <20210914095015.GA9076@breakpoint.cc>
Date:   Tue, 14 Sep 2021 13:53:20 +0300
Cc:     Guillaume Nault <gnault@redhat.com>,
        =?utf-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <504E1119-3631-4A2A-BD0C-F74AEE2BDBF5@gmail.com>
References: <20210808152318.6nbbaj3bp6tpznel@pali>
 <8BDDA0B3-0BEE-4E80-9686-7F66CF58B069@gmail.com>
 <20210809151529.ymbq53f633253loz@pali>
 <FFD368DF-4C89-494B-8E7B-35C2A139E277@gmail.com>
 <20210811164835.GB15488@pc-32.home>
 <81FD1346-8CE6-4080-84C9-705E2E5E69C0@gmail.com>
 <6A3B4C11-EF48-4CE9-9EC7-5882E330D7EA@gmail.com>
 <A16DCD3E-43AA-4D50-97FC-EBB776481840@gmail.com>
 <E95FDB1D-488B-4780-96A1-A2D5C9616A7A@gmail.com>
 <20210914080206.GA20454@pc-4.home> <20210914095015.GA9076@breakpoint.cc>
To:     Florian Westphal <fw@strlen.de>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Florian Hi=20
One more=20

please see i try to remove nf_nat and xt_MASQUERADE=20

and on time of problem need 50-80 sec to remove and overload system .

see perf from this moment:=20




 PerfTop:    1738 irqs/sec  kernel:85.0%  exact: 100.0% lost: 0/0 drop: =
0/0 [4000Hz cycles],  (all, 12 CPUs)
=
--------------------------------------------------------------------------=
--------------------------------------------------------------------------=
-----------------------------------------------------------

    40.63%  [nf_conntrack]    [k] nf_ct_iterate_cleanup
    21.23%  [kernel]          [k] __local_bh_enable_ip
    10.93%  [kernel]          [k] __cond_resched
     9.20%  [kernel]          [k] _raw_spin_lock
     8.91%  [kernel]          [k] rcu_all_qs
     5.83%  [nf_conntrack]    [k] nf_conntrack_lock
     0.10%  [kernel]          [k] mutex_spin_on_owner
     0.08%  telegraf          [.] 0x0000000000021bf0
     0.06%  [kernel]          [k] osq_lock
     0.06%  [kernel]          [k] kallsyms_expand_symbol.constprop.0
     0.05%  [kernel]          [k] format_decode
     0.04%  [kernel]          [k] rtnl_fill_ifinfo.constprop.0.isra.0
     0.04%  perf              [.] 0x00000000000bc7b3
     0.04%  [kernel]          [k] memcpy_erms
     0.03%  [kernel]          [k] string
     0.03%  [kernel]          [k] menu_select
     0.03%  [kernel]          [k] nla_put
     0.03%  [kernel]          [k] vsnprintf



Martin

> On 14 Sep 2021, at 12:50, Florian Westphal <fw@strlen.de> wrote:
>=20
> Guillaume Nault <gnault@redhat.com> wrote:
>>> And on time of problem when try to write : ip a=20
>>> to list interface wait 15-20 sec i finaly have options to simulate =
but users is angry when down internet.
>>=20
>> Probably some contention on the rtnl lock.
>=20
> Yes, I'll create a patch.

