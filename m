Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49F6340C796
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 16:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237955AbhIOOi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 10:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233771AbhIOOi4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 10:38:56 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 302F0C061574
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 07:37:37 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id qq21so6567173ejb.10
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 07:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=wxxnUpxBal8hhhiaC1b7VYDy3n1hbvzPDCzipHNkDPY=;
        b=GeYfE6RKk0lYwZtXDg2m9Ok7vY8U3EJQ6Ngetd2W+3KPGimImRivex0a5qXEEsx4Qr
         iRfNtW35lSKcHO/ZJ123Z/NYoMvqKRVp/i+UfBOjWeljF//JcgjBhEtOQwfHnPyo1K4n
         yD6pMwe7VGA/3Q+2jbDWmAhCbrIQ+bDnAv+NGwVO3gKdkNsCnrwlzhUWYo4C3zCxRj1S
         vATjduM1pLSmMxMW1rhoc+CqMao/IpJ6Pz2uhYimyrfFi7uTnTkS13MU00Y7ErMgSLUl
         fCNpsT1BYDrMU6mz0ibV6zQlGGye/hVYWOselOe2xnuS+qQbYLJjXFNjHOfL4dHHlbkG
         h+rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=wxxnUpxBal8hhhiaC1b7VYDy3n1hbvzPDCzipHNkDPY=;
        b=XG/oxpGuoR5T7roiUG1pUZm5oFchekiO/JvOvbD6cVoJC2qt8+zYru4BzeN0zr5MlM
         p78190rK9TgCO6bQv8vMNUv50ICzQn/MuiTxn+6+FDmeKKdjOitBy4RcKNeOeTDeRBxV
         bQSDWmOlyzFEN4V/hqqt0d8RDTiKtSTQEvnR8qB5uiTxGD3XnW7GsDDIa8hvLjm5Gd9F
         0ePH1i6P9qJ13x6Ys4j+LSMEKSIPdgbRZcVCYYHVC1Cw7fMeDS2ZTVmFwVm0GQlhss/u
         BRutwPkoRgsJWfDr3IbbQjlXSeB4f2MFEeZpBUTq7U02vZD+GZcruucP+vREe1aLDi5T
         GbNg==
X-Gm-Message-State: AOAM530zDYy9zPJhLjb86v9FLC02doi2GY1nNVA0P3Cq9kVigUYodo7R
        usvnTRdx7vARV6dwjUslcso=
X-Google-Smtp-Source: ABdhPJykaXgCPBPfW0Mgq2VihcP4/EPQWl9l+MfCEx2aiKysMXhxsFyxaEz9HYAaoSl1txkyQX8gHg==
X-Received: by 2002:a17:906:6c94:: with SMTP id s20mr368426ejr.152.1631716655488;
        Wed, 15 Sep 2021 07:37:35 -0700 (PDT)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id bm26sm87929ejb.16.2021.09.15.07.37.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 Sep 2021 07:37:35 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: Urgent  Bug report: PPPoE ioctl(PPPIOCCONNECT): Transport
 endpoint is not connected
From:   Martin Zaharinov <micron10@gmail.com>
In-Reply-To: <C2588B79-4053-48E7-A053-408762AB01CA@gmail.com>
Date:   Wed, 15 Sep 2021 17:37:33 +0300
Cc:     Guillaume Nault <gnault@redhat.com>,
        netdev <netdev@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <BB7A0E66-1005-4515-AA9A-213DFF629E64@gmail.com>
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
 <C2588B79-4053-48E7-A053-408762AB01CA@gmail.com>
To:     Florian Westphal <fw@strlen.de>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

and this :=20

  PerfTop:   26378 irqs/sec  kernel:61.4%  exact: 100.0% lost: 0/0 drop: =
0/0 [4000Hz cycles],  (all, 12 CPUs)
=
--------------------------------------------------------------------------=
--------------------------------------------------------------------------=
-----------------------------------------------------------

     5.65%  libfrr.so.0.0.0   [.] 0x00000000000ce970
     5.56%  [kernel]          [k] osq_lock
     5.22%  [kernel]          [k] mutex_spin_on_owner
     3.66%  [pppoe]           [k] pppoe_flush_dev
     3.01%  libfrr.so.0.0.0   [.] 0x00000000000ce94e
     1.98%  libc.so.6         [.] 0x00000000000965a2
     1.84%  libc.so.6         [.] 0x0000000000186afa
     1.55%  libc.so.6         [.] 0x0000000000186e57
     1.54%  zebra             [.] 0x00000000000b9271
     1.46%  zebra             [.] 0x00000000000b91f1
     1.46%  libteam.so.5.6.1  [.] 0x0000000000006470
     1.44%  libc.so.6         [.] 0x00000000000965a0
     1.30%  libteam.so.5.6.1  [.] 0x0000000000009e7d
     1.08%  [kernel]          [k] fib_table_flush
     1.02%  libc.so.6         [.] 0x0000000000186eac
     0.93%  [kernel]          [k] do_poll.constprop.0
     0.85%  libc.so.6         [.] 0x0000000000186afe
     0.80%  dtvbras           [.] 0x0000000000014be8
     0.78%  [kernel]          [k] queued_read_lock_slowpath
     0.72%  [kernel]          [k] next_uptodate_page
     0.64%  [kernel]          [k] zap_pte_range
     0.64%  bgpd              [.] 0x0000000000070a46
     0.61%  [kernel]          [k] fib_table_insert

> On 15 Sep 2021, at 17:25, Martin Zaharinov <micron10@gmail.com> wrote:
>=20
> Hey Florian
>=20
> make test in lab and look much better that before.
>=20
> see this perf=20
>=20
> PerfTop:    6551 irqs/sec  kernel:77.8%  exact: 100.0% lost: 0/0 drop: =
0/0 [4000Hz cycles],  (all, 12 CPUs)
> =
--------------------------------------------------------------------------=
--------------------------------------------------------------------------=
-----------------------------------------------------------
>=20
>    15.70%  [ixgbe]           [k] ixgbe_read_reg
>    13.33%  [kernel]          [k] mutex_spin_on_owner
>     7.65%  [kernel]          [k] osq_lock
>     2.85%  libfrr.so.0.0.0   [.] 0x00000000000ce970
>     1.94%  libfrr.so.0.0.0   [.] 0x00000000000ce94e
>     1.19%  libc.so.6         [.] 0x0000000000186afa
>     1.15%  [kernel]          [k] do_poll.constprop.0
>     0.99%  [kernel]          [k] inet_dump_ifaddr
>     0.94%  libteam.so.5.6.1  [.] 0x0000000000006470
>     0.79%  libc.so.6         [.] 0x0000000000186e57
>     0.71%  [ixgbe]           [k] ixgbe_update_mc_addr_list_generic
>     0.65%  [kernel]          [k] __fget_files
>     0.61%  [kernel]          [k] sock_poll
>     0.57%  libteam.so.5.6.1  [.] 0x0000000000009e7d
>     0.51%  perf              [.] 0x00000000000bc7b3
>     0.51%  libteam.so.5.6.1  [.] 0x0000000000006501
>     0.48%  [kernel]          [k] next_uptodate_page
>     0.46%  [kernel]          [k] _raw_read_lock_bh
>     0.43%  libc.so.6         [.] 0x0000000000186eac
>     0.42%  bgpd              [.] 0x0000000000070a46
>     0.41%  [pppoe]           [k] pppoe_flush_dev
>     0.39%  [kernel]          [k] zap_pte_range
>=20
>=20
> This happened when remove and add new interface on time of drop and =
reconnect users.
>=20
>=20
> now : ip a command work fine !
>=20
>=20
> Martin
>=20
>=20
>> On 14 Sep 2021, at 14:00, Florian Westphal <fw@strlen.de> wrote:
>>=20
>> Martin Zaharinov <micron10@gmail.com> wrote:
>>=20
>> [ Trimming CC list ]
>>=20
>>> Florian:=20
>>>=20
>>> If you make patch send to test please.
>>=20
>> Attached.  No idea if it helps, but 'ip' should stay responsive
>> even when masquerade processes netdevice events.
>> <defer_masq_work.diff>
>=20

