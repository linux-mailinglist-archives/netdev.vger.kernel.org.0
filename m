Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 553152D4749
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 18:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730954AbgLIQ63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 11:58:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728099AbgLIQ63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 11:58:29 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AEC9C0613CF;
        Wed,  9 Dec 2020 08:57:48 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id q75so2408453wme.2;
        Wed, 09 Dec 2020 08:57:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=cMp69MaN+J070jrWLh6Y1Ygh1y/wU0eQaSpJFMomigo=;
        b=hNzat3xAW29PMtiCwzYJDNDT07XvlXFxql1kb0SFiEk6tqL1UVMBWmAl8oD3w4wRp2
         Ghwptw17SbpFHUDdrc2QX2oQ71Ulw9KWc2mPSymWRHssUvy64HV1E9h4sEGUltdU1QKp
         AMulR9e81Ocpe23iKRUu9W8ZgNtlDM3JspakeyKIVATN0+5y9WQlFZjM+dCmpA05eWze
         uGFfiOkT1At9TDa+bqyAyW8UI/cfAS1+X2CkTaQDPtDIEqILeefnhpOKcYX8GxhADbM2
         PtsxVB0Y051nvT0lzYPheaCRavYDPqBPUXdkC2WlwP3UBtTa4m8qzNsJqtj0lyWIaJ14
         1OwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=cMp69MaN+J070jrWLh6Y1Ygh1y/wU0eQaSpJFMomigo=;
        b=C+JgFvbxRbEg6YYTsyp/Fbu0LD1WxVO3a5D2a8xbmG5SAPAI6aLUgC6WglA77uzmA1
         aYEkN1dXuu3AsAUtTFXvOLKrGf8QdRCFp7kKRt9O67Ys9JlJEgha82PzkjZqGJ3fFnUZ
         4Yclzl/fb/c+C+e6xFPFC5lUdU/nZHRPlOdKNoc4zbB2NuCfhvC3y6WJbxNHw38qmWLA
         VaqjhkjoGy9Sxez1HMubSUT0krfWtPPxVsO0Oo4m41tYmwL9Vyq1LM+lubwY4APRtyji
         Dnez+vr4HIy7XsQh256Q5QD6OIR8KewNEs2QSwCJ2et2qMypGvySwNYXWM+hlCi8CDRF
         lR+g==
X-Gm-Message-State: AOAM531QisSGzKb7Uub/+jjc3vwNBdU7MQmDrwVFv0uG+N081LCIJg74
        kyy9U/mYhLV4rNM19Z4YYe0=
X-Google-Smtp-Source: ABdhPJzdhp4qP4pYdbojBd219F7mBn4QFrMpnbwD1XIHqfVnu3w5io70ztKKD9isSWOwb+J6PKsLxw==
X-Received: by 2002:a1c:6283:: with SMTP id w125mr3706617wmb.155.1607533067247;
        Wed, 09 Dec 2020 08:57:47 -0800 (PST)
Received: from [10.11.11.4] ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id d9sm4656707wrs.26.2020.12.09.08.57.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Dec 2020 08:57:45 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.40.0.2.31\))
Subject: Re: Urgent: BUG: PPP ioctl Transport endpoint is not connected
From:   Martin Zaharinov <micron10@gmail.com>
In-Reply-To: <20201209164013.GA21199@linux.home>
Date:   Wed, 9 Dec 2020 18:57:44 +0200
Cc:     "linux-kernel@vger kernel. org" <linux-kernel@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <1E49F9F8-0325-439E-B200-17C8CB6A3CBE@gmail.com>
References: <83C781EB-5D66-426E-A216-E1B846A3EC8A@gmail.com>
 <20201209164013.GA21199@linux.home>
To:     Guillaume Nault <gnault@redhat.com>
X-Mailer: Apple Mail (2.3654.40.0.2.31)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nault=20



> On 9 Dec 2020, at 18:40, Guillaume Nault <gnault@redhat.com> wrote:
>=20
> On Wed, Dec 09, 2020 at 04:47:52PM +0200, Martin Zaharinov wrote:
>> Hi All
>>=20
>> I have problem with latest kernel release=20
>> And the problem is base on this late problem :
>>=20
>>=20
>> =
https://www.mail-archive.com/search?l=3Dnetdev@vger.kernel.org&q=3Dsubject=
:%22Re%5C%3A+ppp%5C%2Fpppoe%2C+still+panic+4.15.3+in+ppp_push%22&o=3Dnewes=
t&f=3D1
>>=20
>> I have same problem in kernel 5.6 > now I use kernel 5.9.13 and have =
same problem.
>>=20
>>=20
>> In kernel 5.9.13 now don=E2=80=99t have any crashes in dimes but in =
one moment accel service stop with defunct and in log have many of this =
line :
>>=20
>>=20
>> error: vlan608: ioctl(PPPIOCCONNECT): Transport endpoint is not =
connected
>> error: vlan617: ioctl(PPPIOCCONNECT): Transport endpoint is not =
connected
>> error: vlan679: ioctl(PPPIOCCONNECT): Transport endpoint is not =
connected
>>=20
>> In one moment connected user bump double or triple and after that =
service defunct and need wait to drop all session to start .
>>=20
>> I talk with accel-ppp team and they said this is kernel related =
problem and to back to kernel 4.14 there is not this problem.
>>=20
>> Problem is come after kernel 4.15 > and not have solution to this =
moment.
>=20
> I'm sorry, I don't understand.
> Do you mean that v4.14 worked fine (no crash, no ioctl() error)?
> Did the problem start appearing in v4.15? Or did v4.15 work and the
> problem appeared in v4.16?

In Telegram group I talk with Sergey and Dimka and told my the problem =
is come after changes from 4.14 to 4.15=20
Sergey write this : "as I know, there was a similar issue in kernel 4.15 =
so maybe it is still not fixed=E2=80=9D

I don=E2=80=99t have options to test with this old kernel 4.14.xxx i =
don=E2=80=99t have support for them.


>=20
>> Please help to find the problem.
>>=20
>> Last time in link I see is make changes in ppp_generic.c=20
>>=20
>> ppp_lock(ppp);
>>        spin_lock_bh(&pch->downl);
>>        if (!pch->chan) {
>>                /* Don't connect unregistered channels */
>>                spin_unlock_bh(&pch->downl);
>>                ppp_unlock(ppp);
>>                ret =3D -ENOTCONN;
>>                goto outl;
>>        }
>>        spin_unlock_bh(&pch->downl);
>>=20
>>=20
>> But this fix only to don=E2=80=99t display error and freeze system=20
>> The problem is stay and is to big.
>=20
> Do you use accel-ppp's unit-cache option? Does the problem go away if
> you stop using it?
>=20

No I don=E2=80=99t use unit-cache , if I set unit-cache accel-ppp =
defunct same but user Is connect and disconnet more fast.

The problem is same with unit and without .=20
Only after this patch I don=E2=80=99t see error in dimes but this is not =
solution.
In network have customer what have power cut problem, when drop 600 user =
and back Is normal but in this moment kernel is locking and start to =
make this :=20
sessions:
  starting: 4235
  active: 3882
  finishing: 378

 The problem is starting session is not real user normal user in this =
server is ~4k customers .

I use pppd_compat .

Any idea ?

>>=20
>> Please help to fix.
Martin

