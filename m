Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC9B3E8F48
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 13:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237233AbhHKLLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 07:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237180AbhHKLK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 07:10:58 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B80DC061765
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 04:10:35 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id d6so3124532edt.7
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 04:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=eXy8CLdrg8L6sdvmUtzyW2x/KcGW/JqgBVQPePJ+2lY=;
        b=NN6mkth7ZziZjjBNwPkI2YhtUWC72b/IWaGX1e/lkICo8MMPMTInoC9FLJCn1TNO2A
         hYbM5kWWn3aGyypu53KMtaPlds0cJkJxJmlq6Yw5KtVxm32jQW/Szns/daTXqM/Un/bk
         5aFP2AhylrXSdpjMGSz1Aawoi52RAejqMqwI0LGeuqdVKKd636iN+BiRiMq3nC2kahys
         kac48IlmFCc7Phgj6UajOVUiuppa1YIPq/8BmqvGt/Ts0oeMEsb+LZojTcTNutB6G3wL
         bKnui/uMemWo2k5G8vfwc42uGYSqmD8OBxATEFgpumBBdNubvQBVrb+qccak0aEkmtV3
         GUtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=eXy8CLdrg8L6sdvmUtzyW2x/KcGW/JqgBVQPePJ+2lY=;
        b=DbGvl5bCi3tC6BF3c6SW6NNqZ8FGNPL+SuDPAJfbBC0l2sjrHvUOVp8L9OCuMLH2Xk
         y/tK8OlbdGiLFyf3rw2MRFifZ9X81NbR50bjz/1tPodK6Z9RMKVlSGXzHQ9MkgSvjccE
         6hJpDvTodZEHHPzKGK9HdauuR4Sg2DuS7WKpZZqTe5E+ZBdihZkfv/d2aRLUQkUeTvWA
         2unuUsNCKIg/SyW8fsM2ufIHEagE7oZx7N8jgE+2SKk7fhsKQ81WFvx8TTaCw8YPutv2
         XSD/aMY5b8Bmfdy/rV4X7J3iRsnpRDjBuXhPxabnXR+ojh+j9LxvAIAF1ae1Z+vKEw82
         CcYw==
X-Gm-Message-State: AOAM532veTCSi87fcWaDLNC2maU9HDVG2lzUaQIjDa9CY5M47LbvEh+q
        aFWRNMWCaQ0i92D+fPl0yrY=
X-Google-Smtp-Source: ABdhPJxdnEDoH6KVAPE28gqAxTclFhAQELCHJvoxHwNKTE1kx46yKYEiei6SflC4bf2xOp1N+bLgsA==
X-Received: by 2002:a05:6402:4d1:: with SMTP id n17mr10593067edw.337.1628680233844;
        Wed, 11 Aug 2021 04:10:33 -0700 (PDT)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id t9sm10659667edd.33.2021.08.11.04.10.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Aug 2021 04:10:33 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: Urgent  Bug report: PPPoE ioctl(PPPIOCCONNECT): Transport
 endpoint is not connected
From:   Martin Zaharinov <micron10@gmail.com>
In-Reply-To: <20210809151529.ymbq53f633253loz@pali>
Date:   Wed, 11 Aug 2021 14:10:32 +0300
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <FFD368DF-4C89-494B-8E7B-35C2A139E277@gmail.com>
References: <7EE80F78-6107-4C6E-B61D-01752D44155F@gmail.com>
 <YQy9JKgo+BE3G7+a@kroah.com> <08EC1CDD-21C4-41AB-B6A8-1CC2D40F5C05@gmail.com>
 <20210808152318.6nbbaj3bp6tpznel@pali>
 <8BDDA0B3-0BEE-4E80-9686-7F66CF58B069@gmail.com>
 <20210809151529.ymbq53f633253loz@pali>
To:     =?utf-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
        Guillaume Nault <gnault@redhat.com>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

And one more that see.

Problem is come when accel start finishing sessions,
Now in server have 2k users and restart on one of vlans 3 Olt with 400 =
users and affect other vlans ,
And problem is start when start destroying dead sessions from vlan with =
3 Olt and this affect all other vlans.
May be kernel destroy old session slow and entrained other users by =
locking other sessions.
is there a way to speed up the closing of stopped/dead sessions.

Martin

> On 9 Aug 2021, at 18:15, Pali Roh=C3=A1r <pali@kernel.org> wrote:
>=20
> On Sunday 08 August 2021 18:29:30 Martin Zaharinov wrote:
>> Hi Pali
>>=20
>> Kernel 5.13.8
>>=20
>>=20
>> The problem is from kernel 5.8 > I try all major update 5.9, 5.10, =
5.11 ,5.12
>>=20
>> I use accel-pppd daemon (not pppd) .
>=20
> I'm not using accel-pppd, so cannot help here.
>=20
> I would suggest to try "git bisect" kernel version which started to be
> problematic for accel-pppd.
>=20
> Providing state of ppp channels and ppp units could help to debug this
> issue, but I'm not sure if accel-pppd has this debug feature. IIRC =
only
> process which has ppp file descriptors can retrieve and dump this
> information.
>=20
>> And yes after users started to connecting .
>>=20
>> When system boot and connect first time all user connect without any =
problem .
>> In time of work user disconnect and connect (power cut , fiber cut or =
other problem in network) , but in time of spike (may be make lock or =
other problem ) disconnect ~ 400-500 users  and affect other users. =
Process go to load over 100% and In statistic I see many finishing =
connection and many start connection.=20
>> And in this time in log get many lines with   ioctl(PPPIOCCONNECT): =
Transport endpoint is not connected. After finish (unlock or other) stop =
to see this error and system is back to normal. And connect all =
disconnected users.
>>=20
>> Martin
>>=20
>>> On 8 Aug 2021, at 18:23, Pali Roh=C3=A1r <pali@kernel.org> wrote:
>>>=20
>>> Hello!
>>>=20
>>> On Sunday 08 August 2021 18:14:09 Martin Zaharinov wrote:
>>>> Add Pali Roh=C3=A1r,
>>>>=20
>>>> If have any idea .
>>>>=20
>>>> Martin
>>>>=20
>>>>> On 6 Aug 2021, at 7:40, Greg KH <gregkh@linuxfoundation.org> =
wrote:
>>>>>=20
>>>>> On Thu, Aug 05, 2021 at 11:53:50PM +0300, Martin Zaharinov wrote:
>>>>>> Hi Net dev team
>>>>>>=20
>>>>>>=20
>>>>>> Please check this error :
>>>>>> Last time I write for this problem : =
https://www.spinics.net/lists/netdev/msg707513.html
>>>>>>=20
>>>>>> But not find any solution.
>>>>>>=20
>>>>>> Config of server is : Bonding port channel (LACP)  > Accel PPP =
server > Huawei switch.
>>>>>>=20
>>>>>> Server is work fine users is down/up 500+ users .
>>>>>> But in one moment server make spike and affect other vlans in =
same server .
>>>=20
>>> When this error started to happen? After kernel upgrade? After pppd
>>> upgrade? Or after system upgrade? Or when more users started to
>>> connecting?
>>>=20
>>>>>> And in accel I see many row with this error.
>>>>>>=20
>>>>>> Is there options to find and fix this bug.
>>>>>>=20
>>>>>> With accel team I discus this problem  and they claim it is =
kernel bug and need to find solution with Kernel dev team.
>>>>>>=20
>>>>>>=20
>>>>>> [2021-08-05 13:52:05.294] vlan912: 24b205903d09718e: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>>>>>> [2021-08-05 13:52:05.298] vlan912: 24b205903d097162: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>>>>>> [2021-08-05 13:52:05.626] vlan641: 24b205903d09711b: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>>>>>> [2021-08-05 13:52:11.000] vlan912: 24b205903d097105: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>>>>>> [2021-08-05 13:52:17.852] vlan912: 24b205903d0971ae: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>>>>>> [2021-08-05 13:52:21.113] vlan641: 24b205903d09715b: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>>>>>> [2021-08-05 13:52:27.963] vlan912: 24b205903d09718d: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>>>>>> [2021-08-05 13:52:30.249] vlan496: 24b205903d097184: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>>>>>> [2021-08-05 13:52:30.992] vlan420: 24b205903d09718a: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>>>>>> [2021-08-05 13:52:33.937] vlan640: 24b205903d0971cd: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>>>>>> [2021-08-05 13:52:40.032] vlan912: 24b205903d097182: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>>>>>> [2021-08-05 13:52:40.420] vlan912: 24b205903d0971d5: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>>>>>> [2021-08-05 13:52:42.799] vlan912: 24b205903d09713a: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>>>>>> [2021-08-05 13:52:42.799] vlan614: 24b205903d0971e5: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>>>>>> [2021-08-05 13:52:43.102] vlan912: 24b205903d097190: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>>>>>> [2021-08-05 13:52:43.850] vlan479: 24b205903d097153: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>>>>>> [2021-08-05 13:52:43.850] vlan479: 24b205903d097141: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>>>>>> [2021-08-05 13:52:43.852] vlan912: 24b205903d097198: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>>>>>> [2021-08-05 13:52:43.977] vlan637: 24b205903d097148: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>>>>>> [2021-08-05 13:52:44.528] vlan637: 24b205903d0971c3: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>>>>>=20
>>>>> These are userspace error messages, not kernel messages.
>>>>>=20
>>>>> What kernel version are you using?
>>>=20
>>> Yes, we need to know, what kernel version are you using.
>>>=20
>>>>> thanks,
>>>>>=20
>>>>> greg k-h
>>>>=20
>>>=20
>>> And also another question, what version of pppd daemon are you =
using?
>>>=20
>>> Also, are you able to dump state of ppp channels and ppp units? It =
is
>>> needed to know to which tty device, file descriptor (or socket
>>> extension) is (or should be) particular ppp channel bounded.
>>=20

