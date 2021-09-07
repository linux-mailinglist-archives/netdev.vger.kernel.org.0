Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A383940234F
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 08:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbhIGGR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 02:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbhIGGR0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 02:17:26 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8B9DC061575
        for <netdev@vger.kernel.org>; Mon,  6 Sep 2021 23:16:18 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id x11so17593160ejv.0
        for <netdev@vger.kernel.org>; Mon, 06 Sep 2021 23:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=tnvgByfuIkfmlWfRU1IC/YwHdPQRnsqUJq7GLyYhJeY=;
        b=q6NsvnX61JkBPKBqu79eBmqxKFY46WszuNUUfhrn7txnHcSTUl/OYeK4JFWwg7P3lh
         KgSoR8G0S684QzClGYwepxF1EUWGM6dT1+vqSPjmeInSN+rnYM1mvieoHX9Z0cXVNJmr
         pxsFbc1dCZZOYYfVQ/mL84PA6ifdq6q9hRJ8FkCpwz7t5TMbZoY29jTgBmJh3ofFcZG5
         gKFbQv9uKWPUQpH/doSe7nuRhUl4DQUDWS2PgGOlJz1CrzkCBxf5BktfKaNCx948km/l
         KVfILKjyWyS1yIhXbUec8VL6zWy3CgQGVpBVM1NP0YdQVQQD48Gl8SVe96c0am1lGc4q
         xiSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=tnvgByfuIkfmlWfRU1IC/YwHdPQRnsqUJq7GLyYhJeY=;
        b=CGLHcFt2FTFQcQGrCLz5u67T/EkGnPIW6/n8inr7K+CLTb2BonYjVW1ENcEd+8gWYs
         KdavkZp5M0J93ijd0mXWeWh1zPyL+Mj5buNO/o2gZyzQmdOWvJA5iBCUIoMTq3E4n/uG
         a4KTXi1k275L6Tb06mh9v55REvxEdvffL4aHjFMqHS3mw1SaF2hAaqOWL+xwmNLmNqIy
         075bbIbzu5FYV57Suc1oMAqetyNMXWWFGgjxvLMklhp3kBeIL7E/jYSUCylmthGsGfsu
         KRV3Ebp4IFiTpyAJOtf0cPL23ayZp+DLjPF6oQfGLS2fsG0tr5QFbn3ntowTzKYdxngE
         oQig==
X-Gm-Message-State: AOAM530PW2E9zvZVue+uFd5NFbTF+QOjQh3/PMis7ZrooCy9vpPUqKQq
        2NPZaJnxB4VfLZsONjO9PfA=
X-Google-Smtp-Source: ABdhPJx7TNXdq8HbDO0APcty/3NzT3WDd/cpayxAY3AgSQmc00xEEE5SOqyiZXXb8vRm0AVSv2+Icw==
X-Received: by 2002:a17:907:9602:: with SMTP id gb2mr17410707ejc.119.1630995377543;
        Mon, 06 Sep 2021 23:16:17 -0700 (PDT)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id h22sm4843259eji.112.2021.09.06.23.16.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Sep 2021 23:16:17 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: Urgent  Bug report: PPPoE ioctl(PPPIOCCONNECT): Transport
 endpoint is not connected
From:   Martin Zaharinov <micron10@gmail.com>
In-Reply-To: <20210811164835.GB15488@pc-32.home>
Date:   Tue, 7 Sep 2021 09:16:16 +0300
Cc:     =?utf-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <81FD1346-8CE6-4080-84C9-705E2E5E69C0@gmail.com>
References: <7EE80F78-6107-4C6E-B61D-01752D44155F@gmail.com>
 <YQy9JKgo+BE3G7+a@kroah.com> <08EC1CDD-21C4-41AB-B6A8-1CC2D40F5C05@gmail.com>
 <20210808152318.6nbbaj3bp6tpznel@pali>
 <8BDDA0B3-0BEE-4E80-9686-7F66CF58B069@gmail.com>
 <20210809151529.ymbq53f633253loz@pali>
 <FFD368DF-4C89-494B-8E7B-35C2A139E277@gmail.com>
 <20210811164835.GB15488@pc-32.home>
To:     Guillaume Nault <gnault@redhat.com>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi=20
Sorry for delay but not easy to catch moment .


See this is mpstatl 1 :

Linux 5.14.1 (demobng) 	09/07/21 	_x86_64_	(12 CPU)

11:12:16     CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal =
 %guest  %gnice   %idle
11:12:17     all    0.17    0.00    6.66    0.00    0.00    4.13    0.00 =
   0.00    0.00   89.05
11:12:18     all    0.25    0.00    8.36    0.00    0.00    4.88    0.00 =
   0.00    0.00   86.51
11:12:19     all    0.26    0.00    9.62    0.00    0.00    3.91    0.00 =
   0.00    0.00   86.21
11:12:20     all    0.85    0.00    6.00    0.00    0.00    4.31    0.00 =
   0.00    0.00   88.84
11:12:21     all    0.08    0.00    4.45    0.00    0.00    4.79    0.00 =
   0.00    0.00   90.67
11:12:22     all    0.17    0.00    9.50    0.00    0.00    4.58    0.00 =
   0.00    0.00   85.75
11:12:23     all    0.00    0.00    6.92    0.00    0.00    2.48    0.00 =
   0.00    0.00   90.61
11:12:24     all    0.17    0.00    5.45    0.00    0.00    4.27    0.00 =
   0.00    0.00   90.11
11:12:25     all    0.25    0.00    5.38    0.00    0.00    4.79    0.00 =
   0.00    0.00   89.58
11:12:26     all    0.60    0.00    1.45    0.00    0.00    2.65    0.00 =
   0.00    0.00   95.30
11:12:27     all    0.42    0.00    6.91    0.00    0.00    4.47    0.00 =
   0.00    0.00   88.20
11:12:28     all    0.00    0.00    6.75    0.00    0.00    4.18    0.00 =
   0.00    0.00   89.07
11:12:29     all    0.17    0.00    3.52    0.00    0.00    5.11    0.00 =
   0.00    0.00   91.20
11:12:30     all    1.45    0.00   10.14    0.00    0.00    3.49    0.00 =
   0.00    0.00   84.92
11:12:31     all    0.09    0.00    5.11    0.00    0.00    4.77    0.00 =
   0.00    0.00   90.03
11:12:32     all    0.25    0.00    3.11    0.00    0.00    4.46    0.00 =
   0.00    0.00   92.17
Average:     all    0.32    0.00    6.21    0.00    0.00    4.21    0.00 =
   0.00    0.00   89.26


I attache and one screenshot from perf top (Screenshot is send on =
preview mail)

And I see in lsmod=20

pppoe                  20480  8198
pppox                  16384  1 pppoe
ppp_generic            45056  16364 pppox,pppoe
slhc                   16384  1 ppp_generic

To slow remove pppoe session .

And from log :=20

[2021-09-07 11:01:11.129] vlan3020: ebdd1c5d8b5900f6: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
[2021-09-07 11:01:53.621] vlan643: ebdd1c5d8b59014e: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
[2021-09-07 11:02:00.359] vlan1616: ebdd1c5d8b590195: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
[2021-09-07 11:02:05.859] vlan3020: ebdd1c5d8b5900d8: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
[2021-09-07 11:02:08.258] vlan3005: ebdd1c5d8b590190: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
[2021-09-07 11:02:13.820] vlan643: ebdd1c5d8b590152: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
[2021-09-07 11:02:15.839] vlan727: ebdd1c5d8b590144: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
[2021-09-07 11:02:20.139] vlan1693: ebdd1c5d8b59019f: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected

> On 11 Aug 2021, at 19:48, Guillaume Nault <gnault@redhat.com> wrote:
>=20
> On Wed, Aug 11, 2021 at 02:10:32PM +0300, Martin Zaharinov wrote:
>> And one more that see.
>>=20
>> Problem is come when accel start finishing sessions,
>> Now in server have 2k users and restart on one of vlans 3 Olt with =
400 users and affect other vlans ,
>> And problem is start when start destroying dead sessions from vlan =
with 3 Olt and this affect all other vlans.
>> May be kernel destroy old session slow and entrained other users by =
locking other sessions.
>> is there a way to speed up the closing of stopped/dead sessions.
>=20
> What are the CPU stats when that happen? Is it users space or kernel
> space that keeps it busy?
>=20
> One easy way to check is to run "mpstat 1" for a few seconds when the
> problem occurs.
>=20

