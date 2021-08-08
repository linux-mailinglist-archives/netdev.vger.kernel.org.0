Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA2FB3E3B16
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 17:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231869AbhHHP3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 11:29:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbhHHP3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Aug 2021 11:29:52 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61FE7C061760
        for <netdev@vger.kernel.org>; Sun,  8 Aug 2021 08:29:33 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id k9so3463451edr.10
        for <netdev@vger.kernel.org>; Sun, 08 Aug 2021 08:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=K7q/4FejWt9HYg4/mZQLsfL0TSkeAHWwBWPqNXP6mtw=;
        b=flLQGCUEoEkXP6Dmx68lDLMDHVX9/ezUceugdDMNPg8WU49X2UY3T0tLdp7wtGfAjm
         XEWgbh7cp0ENOifvOhgZTnn7FyKmm8Tjmh+OtwZtNeE1vVlLGBC0bhtmUxmr5csVkoPR
         N1VfsrwwsXNigcODmRlWMovB9tQHQO/pwG+3FQyMsyl9t15pFWMMR8eMMFD5Ptq3uAuR
         hv7cP7jRxaViX/Egb7irzQrTSEEBttzf8ffJYSoCfs+3+ADNR0lYrQehTVP1okx9G0mI
         O/VnL8K6Htluiy2682X3b2ZpNDUE6k5E6OW3kHyJr2Jr/+RlXcxQwjHA4N0ZyEFY9JX5
         LSUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=K7q/4FejWt9HYg4/mZQLsfL0TSkeAHWwBWPqNXP6mtw=;
        b=P0DDxR1xd1CNuPYVbe16tebAwHP1VdhpvpB0JgIzuYg7eb3hIAl6Ax6JTylmCM5wPk
         77TcxRXIbpLYGCBDwpsvwWg8LiWTKH6tubBA9loIZ0YM9xK65B4rLOpUCChzr6DvL3ed
         EDvOP37lGnnsREBa6sArgmjX+GHTnMwD0VhkGnNZrfXxwF/UsVeuXKDFiodEkJe5WTu9
         3DAmFECpVyeTBFwPHiEsw5GmKd7OgRU8+485RJS0KUjEnvGULJN/izdhlhQuQ3Wn67ef
         zmkRIEg9i6yEmFPQoVBkl6P3KOnOwX21Mc4wwAqOxJlmybsJQGyzcL4WCHhDpRUh/ozT
         f/aA==
X-Gm-Message-State: AOAM531EzGWMRzJ95KVs9/6XX38VhcegYoqautB42I9WqrWoGdopUAk4
        b6IbMZaK0gji6LGJRVKdDvM=
X-Google-Smtp-Source: ABdhPJwMWpV6KGekG5W4l1UXw2xQ/T5qYQ9y3Kv91/xtC4rGV6KCRnqUvHqR/kQaeIABt1NUs/nr7Q==
X-Received: by 2002:a05:6402:19a:: with SMTP id r26mr24259013edv.230.1628436571939;
        Sun, 08 Aug 2021 08:29:31 -0700 (PDT)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id a12sm5083048ejv.14.2021.08.08.08.29.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 Aug 2021 08:29:31 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: Urgent  Bug report: PPPoE ioctl(PPPIOCCONNECT): Transport
 endpoint is not connected
From:   Martin Zaharinov <micron10@gmail.com>
In-Reply-To: <20210808152318.6nbbaj3bp6tpznel@pali>
Date:   Sun, 8 Aug 2021 18:29:30 +0300
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <8BDDA0B3-0BEE-4E80-9686-7F66CF58B069@gmail.com>
References: <7EE80F78-6107-4C6E-B61D-01752D44155F@gmail.com>
 <YQy9JKgo+BE3G7+a@kroah.com> <08EC1CDD-21C4-41AB-B6A8-1CC2D40F5C05@gmail.com>
 <20210808152318.6nbbaj3bp6tpznel@pali>
To:     =?utf-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pali

Kernel 5.13.8


The problem is from kernel 5.8 > I try all major update 5.9, 5.10, 5.11 =
,5.12

I use accel-pppd daemon (not pppd) .

And yes after users started to connecting .

When system boot and connect first time all user connect without any =
problem .
In time of work user disconnect and connect (power cut , fiber cut or =
other problem in network) , but in time of spike (may be make lock or =
other problem ) disconnect ~ 400-500 users  and affect other users. =
Process go to load over 100% and In statistic I see many finishing =
connection and many start connection.=20
And in this time in log get many lines with   ioctl(PPPIOCCONNECT): =
Transport endpoint is not connected. After finish (unlock or other) stop =
to see this error and system is back to normal. And connect all =
disconnected users.

Martin

> On 8 Aug 2021, at 18:23, Pali Roh=C3=A1r <pali@kernel.org> wrote:
>=20
> Hello!
>=20
> On Sunday 08 August 2021 18:14:09 Martin Zaharinov wrote:
>> Add Pali Roh=C3=A1r,
>>=20
>> If have any idea .
>>=20
>> Martin
>>=20
>>> On 6 Aug 2021, at 7:40, Greg KH <gregkh@linuxfoundation.org> wrote:
>>>=20
>>> On Thu, Aug 05, 2021 at 11:53:50PM +0300, Martin Zaharinov wrote:
>>>> Hi Net dev team
>>>>=20
>>>>=20
>>>> Please check this error :
>>>> Last time I write for this problem : =
https://www.spinics.net/lists/netdev/msg707513.html
>>>>=20
>>>> But not find any solution.
>>>>=20
>>>> Config of server is : Bonding port channel (LACP)  > Accel PPP =
server > Huawei switch.
>>>>=20
>>>> Server is work fine users is down/up 500+ users .
>>>> But in one moment server make spike and affect other vlans in same =
server .
>=20
> When this error started to happen? After kernel upgrade? After pppd
> upgrade? Or after system upgrade? Or when more users started to
> connecting?
>=20
>>>> And in accel I see many row with this error.
>>>>=20
>>>> Is there options to find and fix this bug.
>>>>=20
>>>> With accel team I discus this problem  and they claim it is kernel =
bug and need to find solution with Kernel dev team.
>>>>=20
>>>>=20
>>>> [2021-08-05 13:52:05.294] vlan912: 24b205903d09718e: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>>>> [2021-08-05 13:52:05.298] vlan912: 24b205903d097162: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>>>> [2021-08-05 13:52:05.626] vlan641: 24b205903d09711b: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>>>> [2021-08-05 13:52:11.000] vlan912: 24b205903d097105: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>>>> [2021-08-05 13:52:17.852] vlan912: 24b205903d0971ae: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>>>> [2021-08-05 13:52:21.113] vlan641: 24b205903d09715b: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>>>> [2021-08-05 13:52:27.963] vlan912: 24b205903d09718d: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>>>> [2021-08-05 13:52:30.249] vlan496: 24b205903d097184: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>>>> [2021-08-05 13:52:30.992] vlan420: 24b205903d09718a: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>>>> [2021-08-05 13:52:33.937] vlan640: 24b205903d0971cd: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>>>> [2021-08-05 13:52:40.032] vlan912: 24b205903d097182: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>>>> [2021-08-05 13:52:40.420] vlan912: 24b205903d0971d5: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>>>> [2021-08-05 13:52:42.799] vlan912: 24b205903d09713a: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>>>> [2021-08-05 13:52:42.799] vlan614: 24b205903d0971e5: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>>>> [2021-08-05 13:52:43.102] vlan912: 24b205903d097190: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>>>> [2021-08-05 13:52:43.850] vlan479: 24b205903d097153: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>>>> [2021-08-05 13:52:43.850] vlan479: 24b205903d097141: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>>>> [2021-08-05 13:52:43.852] vlan912: 24b205903d097198: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>>>> [2021-08-05 13:52:43.977] vlan637: 24b205903d097148: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>>>> [2021-08-05 13:52:44.528] vlan637: 24b205903d0971c3: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>>>=20
>>> These are userspace error messages, not kernel messages.
>>>=20
>>> What kernel version are you using?
>=20
> Yes, we need to know, what kernel version are you using.
>=20
>>> thanks,
>>>=20
>>> greg k-h
>>=20
>=20
> And also another question, what version of pppd daemon are you using?
>=20
> Also, are you able to dump state of ppp channels and ppp units? It is
> needed to know to which tty device, file descriptor (or socket
> extension) is (or should be) particular ppp channel bounded.

