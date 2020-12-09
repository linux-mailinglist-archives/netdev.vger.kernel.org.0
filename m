Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15F862D49E1
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 20:15:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387527AbgLITNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 14:13:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732900AbgLITNC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 14:13:02 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35CACC0613D6;
        Wed,  9 Dec 2020 11:12:22 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id k10so2506869wmi.3;
        Wed, 09 Dec 2020 11:12:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=7c8pG7KIt2VsKEH1T3YthsMxGUwmBMeRcrpXnjhocb0=;
        b=cDSB4Ym4/KwKb/KuYyYhakJDqYHrFewbr/KFiZTsCcEAezOz6pWQxmPw3bDYyq1Lmt
         eN+9xb3k40e6/8d+9iVnd7kJi3EuWTbyReboKiGybq+5iJkO32GRMtl6pabypsXAjZK3
         9Ugg/8VAYr9jxLpkkrZyInmt/vXbxZKKyybNUzvMdAjNIUNG/HKKLbFNdB3kb0fdvWhT
         18R8+Z7/dm1tFavaBbjrK6lIR0OSRacuauoUx5YGLTsaJP+N9B7jwt00RPwspFLmyKvY
         acPRbR5Ybkvg7gX6w0LStdIv9exss7YHf3242xYjkevuzqJaAA2Xw5svtlXYNCvAeuOk
         q/Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=7c8pG7KIt2VsKEH1T3YthsMxGUwmBMeRcrpXnjhocb0=;
        b=H8RK0JhhxWUTbUr8nitMnfygRAyJjbFAyUEFJGcu8ZD0zXqe9msUkOKnA4atERw8n8
         DirnekKJ+nqJsLx8izxAnGeOK/bTEhhdbQV8bnetiDjbj+qiR9VIQ69G2jXX5ps8Oc8e
         6OxoGvxZm6jxzbPtd1vp5uX/C0LJM61ZNhkBD0QCYiQZqpI4wzDBx1vKHB9FTjuAosdi
         5uy+n7sCe5uX5Bwfl58Tg7pWApf4bzQ9Nmdq0s2WwdpYyMBwj9LKqyMzN0TNYzq+0GP5
         +0vwICuRqU82v9cEZ/cdcgYgRsR3f4R91eSa2k98LRsrp7WO0FzbvoAsRPHj/zNNsgZd
         uyRw==
X-Gm-Message-State: AOAM531c1cs+IbZgDZyU1vxFGS3T9m0Y65wnvdglp9Q4HO4q7m9k3EYJ
        KTX+l4J8u4EPjgUUu6etFa0iW2+2crITS0iN
X-Google-Smtp-Source: ABdhPJz+SM9TejehgRWBVz9mWMwpagfZS/DA1AmfzO3oE4a+DVQpUES01fAW9ZjHWnL4EyyHyHGdtg==
X-Received: by 2002:a05:600c:2652:: with SMTP id 18mr4233703wmy.54.1607541140894;
        Wed, 09 Dec 2020 11:12:20 -0800 (PST)
Received: from [10.11.11.4] ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id z8sm5151116wmg.17.2020.12.09.11.12.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Dec 2020 11:12:20 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.40.0.2.31\))
Subject: Re: Urgent: BUG: PPP ioctl Transport endpoint is not connected
From:   Martin Zaharinov <micron10@gmail.com>
In-Reply-To: <20201209181033.GB21199@linux.home>
Date:   Wed, 9 Dec 2020 21:12:18 +0200
Cc:     "linux-kernel@vger kernel. org" <linux-kernel@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <B70AAB31-B656-43B4-97B6-6E0FA0E1E680@gmail.com>
References: <83C781EB-5D66-426E-A216-E1B846A3EC8A@gmail.com>
 <20201209164013.GA21199@linux.home>
 <1E49F9F8-0325-439E-B200-17C8CB6A3CBE@gmail.com>
 <20201209181033.GB21199@linux.home>
To:     Guillaume Nault <gnault@redhat.com>
X-Mailer: Apple Mail (2.3654.40.0.2.31)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On 9 Dec 2020, at 20:10, Guillaume Nault <gnault@redhat.com> wrote:
>=20
> On Wed, Dec 09, 2020 at 06:57:44PM +0200, Martin Zaharinov wrote:
>>> On 9 Dec 2020, at 18:40, Guillaume Nault <gnault@redhat.com> wrote:
>>> On Wed, Dec 09, 2020 at 04:47:52PM +0200, Martin Zaharinov wrote:
>>>> Hi All
>>>>=20
>>>> I have problem with latest kernel release=20
>>>> And the problem is base on this late problem :
>>>>=20
>>>>=20
>>>> =
https://www.mail-archive.com/search?l=3Dnetdev@vger.kernel.org&q=3Dsubject=
:%22Re%5C%3A+ppp%5C%2Fpppoe%2C+still+panic+4.15.3+in+ppp_push%22&o=3Dnewes=
t&f=3D1
>>>>=20
>>>> I have same problem in kernel 5.6 > now I use kernel 5.9.13 and =
have same problem.
>>>>=20
>>>>=20
>>>> In kernel 5.9.13 now don=E2=80=99t have any crashes in dimes but in =
one moment accel service stop with defunct and in log have many of this =
line :
>>>>=20
>>>>=20
>>>> error: vlan608: ioctl(PPPIOCCONNECT): Transport endpoint is not =
connected
>>>> error: vlan617: ioctl(PPPIOCCONNECT): Transport endpoint is not =
connected
>>>> error: vlan679: ioctl(PPPIOCCONNECT): Transport endpoint is not =
connected
>>>>=20
>>>> In one moment connected user bump double or triple and after that =
service defunct and need wait to drop all session to start .
>>>>=20
>>>> I talk with accel-ppp team and they said this is kernel related =
problem and to back to kernel 4.14 there is not this problem.
>>>>=20
>>>> Problem is come after kernel 4.15 > and not have solution to this =
moment.
>>>=20
>>> I'm sorry, I don't understand.
>>> Do you mean that v4.14 worked fine (no crash, no ioctl() error)?
>>> Did the problem start appearing in v4.15? Or did v4.15 work and the
>>> problem appeared in v4.16?
>>=20
>> In Telegram group I talk with Sergey and Dimka and told my the =
problem is come after changes from 4.14 to 4.15=20
>> Sergey write this : "as I know, there was a similar issue in kernel =
4.15 so maybe it is still not fixed"
>=20
> Ok, but what is your experience? Do you have a kernel version where
> accel-ppp reports no ioctl() error and doesn't crash the kernel?
Reported by Sergey and Dimka  version 4.14 < don=E2=80=99t have this =
problem,
Only version after 4.15.0 > have problem and with patch only fix to =
don=E2=80=99t put crash log in dimes and freeze system.


>=20
> There wasn't a lot of changes between 4.14 and 4.15 for PPP.
> The only PPP patch I can see that might have been risky is commit
> 0171c4183559 ("ppp: unlock all_ppp_mutex before registering device").

For my changes is a atomic and skb kfree .
>=20
>> I don=E2=80=99t have options to test with this old kernel 4.14.xxx i =
don=E2=80=99t have support for them.
>>=20
>>=20
>>>=20
>>>> Please help to find the problem.
>>>>=20
>>>> Last time in link I see is make changes in ppp_generic.c=20
>>>>=20
>>>> ppp_lock(ppp);
>>>>       spin_lock_bh(&pch->downl);
>>>>       if (!pch->chan) {
>>>>               /* Don't connect unregistered channels */
>>>>               spin_unlock_bh(&pch->downl);
>>>>               ppp_unlock(ppp);
>>>>               ret =3D -ENOTCONN;
>>>>               goto outl;
>>>>       }
>>>>       spin_unlock_bh(&pch->downl);
>>>>=20
>>>>=20
>>>> But this fix only to don=E2=80=99t display error and freeze system=20=

>>>> The problem is stay and is to big.
>>>=20
>>> Do you use accel-ppp's unit-cache option? Does the problem go away =
if
>>> you stop using it?
>>>=20
>>=20
>> No I don=E2=80=99t use unit-cache , if I set unit-cache accel-ppp =
defunct same but user Is connect and disconnet more fast.
>>=20
>> The problem is same with unit and without .=20
>> Only after this patch I don=E2=80=99t see error in dimes but this is =
not solution.
>=20
> Soryy, what's "in dimes"?
> Do you mean that reverting commit 77f840e3e5f0 ("ppp: prevent
> unregistered channels from connecting to PPP units") fixes your =
problem?
Sorry text correct in dmesg*

I don=E2=80=99t make any changes of ppp part of kernel 5.9.13 I use =
clean build for ppp .


>=20
>> In network have customer what have power cut problem, when drop 600 =
user and back Is normal but in this moment kernel is locking and start =
to make this :=20
>> sessions:
>>  starting: 4235
>>  active: 3882
>>  finishing: 378
>> The problem is starting session is not real user normal user in this =
server is ~4k customers .
>=20
> What type of session is it? L2TP, PPPoE, PPTP?
>=20
Session is PPPoE only with radius auth

>> I use pppd_compat .
>>=20
>> Any idea ?
>>=20
>>>>=20
>>>> Please help to fix.
>> Martin

