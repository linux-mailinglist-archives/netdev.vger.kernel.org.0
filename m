Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 879EC301A6B
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 09:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726503AbhAXIKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 03:10:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbhAXIKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 03:10:13 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEBACC061573;
        Sun, 24 Jan 2021 00:09:32 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id 36so9688198otp.2;
        Sun, 24 Jan 2021 00:09:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=OHJGHOC3Sd+miCKSV/eRBuVMrTeofMl4U/fP/gR69wQ=;
        b=DrmPbtyGAy6ClKFd8ICGnfOkvG7cFnnTpO1iGU9ZfhCbtIG6JKLTE3+20pf3X2oriX
         BiGk31Lbwu/uZRnuE0KNPugZW84JrfkBBtoBU/qpdQv89L/xQM+YUXLuaa+Vzrap4nnT
         lCIBIyv7gBcBbClhcTOsn8fX+loxt72vhdsOvhuq8A364aZ2vdt/J+SK3iA4H9J+J+JZ
         IiPWEOQYduFeMnrYRAYE4iXgxO/PA00F4hCnzFmGg4gSbrouaWbUDe9hsI4HAknkHWGW
         uCC14ym7xbMor0ITZM9GbYHZ7f5uri8Sm2ApD/yAbRNp0HdItUV0DqzYdX8GHgta5nTB
         IRTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=OHJGHOC3Sd+miCKSV/eRBuVMrTeofMl4U/fP/gR69wQ=;
        b=kAAY6LcD6kGM5CRWxxtmMdDkWF8XhrXSBa3m3AURlj20xOHC+y8McnnhGo2gmdPbQ+
         X3HbIvw3TmU7fhquWlO84m/WlLjF2+dJ7M6A92HeDe3/uWt3tGtbxhA8HFarlaD0rriI
         k1kjzQ9BRRqdSfIB/2lHdkabbEV1fHXKWZNA6b/ekVgFvIw6vTrVJ2UyWSnwAJXq2ZIm
         Vn6KftuIAaaJJFiDzTIWP6dPn/1/Fig6mGcfD6EbkHZNJvoH36upPA7W/i20nuOGNZQu
         0UDFvuRbjWW6l19xATzoaJ9vUkDaCXC1su/1FzWHR2jhTllNOSAPK+e7+XfMq6d7Zi+X
         7boQ==
X-Gm-Message-State: AOAM531Kx//B9TK4tImZ8qhXGDy6JFO2ds7qQlXO8uiyf5WwIr7lQx82
        QIGBP1Tsa566VrkV1BjNtw==
X-Google-Smtp-Source: ABdhPJx3SgnHSpPXLEUElhSnAkaPdGCB8G47/1f/dRCeJkKNXwl4yvGTLGkHrGkOFG5gWX1u+YOS9w==
X-Received: by 2002:a9d:3e85:: with SMTP id b5mr8897391otc.8.1611475772109;
        Sun, 24 Jan 2021 00:09:32 -0800 (PST)
Received: from pchaudha-mn1.attlocal.net ([2600:1700:cda0:4340:5c00:a7a1:3ed7:5678])
        by smtp.gmail.com with ESMTPSA id l8sm2879035ota.9.2021.01.24.00.09.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 Jan 2021 00:09:31 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH v3 net-next 1/1] Allow user to set metric on default route
 learned via Router Advertisement.
From:   praveen chaudhary <praveen5582@gmail.com>
In-Reply-To: <2de4989b-5b72-cb0a-470f-9bd0dcb96e53@gmail.com>
Date:   Sun, 24 Jan 2021 00:09:20 -0800
Cc:     =?utf-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>,
        David Miller <davem@davemloft.net>, corbet@lwn.net,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki Yoshifuji <yoshfuji@linux-ipv6.org>,
        Linux NetDev <netdev@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Zhenggen Xu <zxu@linkedin.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <3ACC52AF-8992-4CD9-B89F-2529DA402A25@gmail.com>
References: <20210119212959.25917-1-pchaudhary@linkedin.com>
 <1cc9e887-a984-c14a-451c-60a202c4cf20@gmail.com>
 <CAHo-Oozz-mGNz4sphOJekNeAgGJCLmiZaiNccXjiQ02fQbfthQ@mail.gmail.com>
 <bc855311-f348-430b-0d3c-9103d4fdbbb6@gmail.com>
 <20210123120001.50a3f676@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <2de4989b-5b72-cb0a-470f-9bd0dcb96e53@gmail.com>
To:     David Ahern <dsahern@gmail.com>, Jakub Kicinski <kuba@kernel.org>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jan 23, 2021, at 5:13 PM, David Ahern <dsahern@gmail.com> wrote:
>=20
> On 1/23/21 1:00 PM, Jakub Kicinski wrote:
>> On Fri, 22 Jan 2021 22:16:41 -0700 David Ahern wrote:
>>> On 1/22/21 9:02 PM, Maciej =C5=BBenczykowski wrote:
>>>> Why can't we get rid of the special case for 0 and simply make 1024 =
the
>>>> default value? =20
>>>=20
>>> That would work too.
>>=20
>> Should we drop it then? Easier to bring it back than to change the
>> interpretation later. It doesn't seem to serve any clear purpose =
right
>> now.
>>=20
>> (Praveen if you post v4 please take a look at the checkpatch --strict
>> warnings and address the ones which make sense, e.g. drop the =
brackets
>> around comparisons, those are just noise, basic grasp of C operator
>> precedence can be assumed in readers of kernel code).
>>=20
>=20
> let's do a v4.
>=20
> Praveen: set the initial value to IP6_RT_PRIO_USER, do not allow 0,
> remove the checks on value and don't forget to update documentation.
>=20

Sure, I will respin V4, with above mentioned changes. Also, I will =
address checkpatch --strict warnings.

I wanted to set initial value to IP6_RT_PRIO_USER in v1, but avoided =
till review for 2 simple coding reasons:
1.) IP6_RT_PRIO_USER must be exposed in net/ipv6/addrconf.c by including =
include/uapi/linux/ipv6_route.h.
2.) If rt6_add_dflt_router() will be called from other files in future, =
IP6_RT_PRIO_USER should be included in all those files as well, because =
caller will pass most probably default value.

> Oh and cc me on the next otherwise the review depends on me finding =
time
> to scan netdev.

Sure, I will cc you and will add =E2=80=9CReviewed by=E2=80=9D as well. =
I will also send you the lkml link to v4.
Thanks Jakub and you for reviewing this over the weekend.


