Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4113E22FA
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 07:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240700AbhHFFlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 01:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239635AbhHFFlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 01:41:14 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69562C061798
        for <netdev@vger.kernel.org>; Thu,  5 Aug 2021 22:40:58 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id cf5so11550382edb.2
        for <netdev@vger.kernel.org>; Thu, 05 Aug 2021 22:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=IO7M1a4L/NCpJOuSf3NlUgjoq5w3dwZIm0bi9ORSWic=;
        b=tU5JEsI3JaxMSk+kV2G7tUxicT6Hpv89KGPsVz8AR85on1N2/a3b/MNxZcHueeXZCd
         NQcl14IlSMPUCVZF/hERohkepLTcghHhwvb3ZGSfj3Zsl50J+cQ1LpdXo5bpYpFrGiVy
         K5WbzEDBF/JsvTtCNptJJJip+ZWSizZw0MG/EF1peyZ8gYfxSRcr720DpeC+Dawbf9p7
         NRGsmgN6SWNaAvJrWLmeY9fn9yqlZ9HujmJQ1dr6hDi1QfSHkWbGfJoWetmc6pdyxpRq
         COnDGKq4SgcFIALJ7T0ynFGsgHhzgDkWcYSIj1VYHsaJWcIBdXVh8mZbevWUCL32eXyM
         erTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=IO7M1a4L/NCpJOuSf3NlUgjoq5w3dwZIm0bi9ORSWic=;
        b=VXyqaVejxbKH0XnSdU7qc2oT65IrIE1kB7K6BX0bragVhQgszmnJVBTgtursYUwrrq
         CwWP44fmXZVfjz0Gbe1QT6ykyYIuELLhavWF11mLHyyHsr+UHAfNY2kZNnIWSxgFFT7j
         /MVI6T6mqZQUJNNwRH0zvXsEFvYPS3wU8uZD6r6modk/MN/G8WKKMswKUu8dYIqaujXY
         L5mWMnPsO21M0yb2yewF+ozSJyvJSfuqjyK1FaqQepiJDDST9M6Ah4iElIVgLaqrm1NK
         6O6OaY9OQh+T7ipq/8pZJ3KcmG+bs3Nu9OBiSCdjD1tfK3tpqz6Ny6qP4uV2Df+iewxn
         EZ8A==
X-Gm-Message-State: AOAM532c+tlddmk2RNg5TWHWzqzw2UsF1pJFkDOwuzCm1ajUPk03z9BQ
        Jm/HkMd7J7O/ik13CElvLX8=
X-Google-Smtp-Source: ABdhPJx2vU/r79F6MUBymWJ4xy0zyXN7kyFlJGLuCZ2ul/U1GyjVh8jF5QqN3oR6yEYyKSa4xL06yw==
X-Received: by 2002:a05:6402:781:: with SMTP id d1mr11111962edy.32.1628228457061;
        Thu, 05 Aug 2021 22:40:57 -0700 (PDT)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id i14sm3253709edx.30.2021.08.05.22.40.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Aug 2021 22:40:56 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: Urgent  Bug report: PPPoE ioctl(PPPIOCCONNECT): Transport
 endpoint is not connected
From:   Martin Zaharinov <micron10@gmail.com>
In-Reply-To: <YQy9JKgo+BE3G7+a@kroah.com>
Date:   Fri, 6 Aug 2021 08:40:55 +0300
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <FE7AFA47-4EB0-44FB-B0E2-F6877B0B1ABF@gmail.com>
References: <7EE80F78-6107-4C6E-B61D-01752D44155F@gmail.com>
 <YQy9JKgo+BE3G7+a@kroah.com>
To:     Greg KH <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg

Latest kernel 5.13.8.

I try old version from 5.10 to 5.13 and its same error.

Martin

> On 6 Aug 2021, at 7:40, Greg KH <gregkh@linuxfoundation.org> wrote:
>=20
> On Thu, Aug 05, 2021 at 11:53:50PM +0300, Martin Zaharinov wrote:
>> Hi Net dev team
>>=20
>>=20
>> Please check this error :
>> Last time I write for this problem : =
https://www.spinics.net/lists/netdev/msg707513.html
>>=20
>> But not find any solution.
>>=20
>> Config of server is : Bonding port channel (LACP)  > Accel PPP server =
> Huawei switch.
>>=20
>> Server is work fine users is down/up 500+ users .
>> But in one moment server make spike and affect other vlans in same =
server .
>> And in accel I see many row with this error.
>>=20
>> Is there options to find and fix this bug.
>>=20
>> With accel team I discus this problem  and they claim it is kernel =
bug and need to find solution with Kernel dev team.
>>=20
>>=20
>> [2021-08-05 13:52:05.294] vlan912: 24b205903d09718e: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>> [2021-08-05 13:52:05.298] vlan912: 24b205903d097162: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>> [2021-08-05 13:52:05.626] vlan641: 24b205903d09711b: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>> [2021-08-05 13:52:11.000] vlan912: 24b205903d097105: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>> [2021-08-05 13:52:17.852] vlan912: 24b205903d0971ae: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>> [2021-08-05 13:52:21.113] vlan641: 24b205903d09715b: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>> [2021-08-05 13:52:27.963] vlan912: 24b205903d09718d: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>> [2021-08-05 13:52:30.249] vlan496: 24b205903d097184: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>> [2021-08-05 13:52:30.992] vlan420: 24b205903d09718a: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>> [2021-08-05 13:52:33.937] vlan640: 24b205903d0971cd: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>> [2021-08-05 13:52:40.032] vlan912: 24b205903d097182: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>> [2021-08-05 13:52:40.420] vlan912: 24b205903d0971d5: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>> [2021-08-05 13:52:42.799] vlan912: 24b205903d09713a: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>> [2021-08-05 13:52:42.799] vlan614: 24b205903d0971e5: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>> [2021-08-05 13:52:43.102] vlan912: 24b205903d097190: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>> [2021-08-05 13:52:43.850] vlan479: 24b205903d097153: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>> [2021-08-05 13:52:43.850] vlan479: 24b205903d097141: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>> [2021-08-05 13:52:43.852] vlan912: 24b205903d097198: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>> [2021-08-05 13:52:43.977] vlan637: 24b205903d097148: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>> [2021-08-05 13:52:44.528] vlan637: 24b205903d0971c3: =
ioctl(PPPIOCCONNECT): Transport endpoint is not connected
>=20
> These are userspace error messages, not kernel messages.
>=20
> What kernel version are you using?
>=20
> thanks,
>=20
> greg k-h

