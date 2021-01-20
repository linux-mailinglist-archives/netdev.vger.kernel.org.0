Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FACE2FCB32
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 07:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727153AbhATGxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 01:53:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbhATGwR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 01:52:17 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AD2FC061757;
        Tue, 19 Jan 2021 22:51:37 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id j12so6753621pfj.12;
        Tue, 19 Jan 2021 22:51:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=hSTCljo+6s3Mzjwr6y147WsbBzkNmoKUysS7Dm9EnPo=;
        b=XNNytEFUyXePR6IQR+Jxq5BP1WOIxasXa3YTi2Khe0bUs8UyT7fdXbQXhNGt4aLHuR
         9rtopzEiyth+6uK6wJmd1DuYLgR6pfAePg31H3IoWJzNN0qWbAy4zfKNIHObeZ2HSUbu
         WrgIuOTikpTwU7MxMquqAcoB0AoLPbroLWaCVCWv1nhhUyAMXYj8mzOxllijS6Eq9iDB
         uhkIsOyuBym9P6lqzQRl3W83/YHmyV4FVqwq+tZeiQOLPGmxF0FgdVLErscaYJhBRY+e
         8qLvznM2JCc+s8oBL4953rnsOH1NOV3RInOz5CUXlx7rkFipiY425MtcX/lwTEhQ5VmV
         FNJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=hSTCljo+6s3Mzjwr6y147WsbBzkNmoKUysS7Dm9EnPo=;
        b=pVKy89bCgYfj7CXgNL4L6/qBmTXpojjSmfd7cC9QBKOe68ARC0Lk5lJJIt0ius3lyL
         a7mW3Mpl5qTGnRa221No+omQUXbuLEEU7mCopnMS4bXuTwMLrzN1+F2G7cYDEo0tcuPI
         dKZneCznOjXB/rJnHHoR2pzqrLKD2pLn4MkDXZ3kqcFbNv7G8bSFJa7mWMtcBfS5K0ME
         LZ6zPOQwa75Uj5/OC0cgGFyz9Hl/w+UKV0c32mjDmJVszDK+sebFr9fi2qrGWeRaQSJL
         0wi5IkRD1+GxvOm9Q2w1vSpLZlKr8STDbSwTwDz5XchmhPSDJxBpY9JC5VhcAKXn+tXS
         SPAA==
X-Gm-Message-State: AOAM533eUd7s+QzR6YOuSmcWfRd2kZjdqM0x9faMvg3SScZbG4sx9wHA
        plyZYuYh22U+fp57ynCziBYfFgc+epblYQY=
X-Google-Smtp-Source: ABdhPJzKOsQbJVr1v9ePySXk3FER8Vs0Fw+MDRTfejpxFhT40eigUQIAOqD5IlwjvF5fDiLbTAHICQ==
X-Received: by 2002:a62:790a:0:b029:1b4:80d4:c246 with SMTP id u10-20020a62790a0000b02901b480d4c246mr7783312pfc.71.1611125496871;
        Tue, 19 Jan 2021 22:51:36 -0800 (PST)
Received: from ?IPv6:2600:1700:cda0:4340:8831:6d69:57a3:bbfb? ([2600:1700:cda0:4340:8831:6d69:57a3:bbfb])
        by smtp.gmail.com with ESMTPSA id m3sm1043704pfa.134.2021.01.19.22.51.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Jan 2021 22:51:36 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH v2 net-next 1/1] Allow user to set metric on default route
 learned via Router Advertisement.
From:   praveen chaudhary <praveen5582@gmail.com>
In-Reply-To: <7839be40-6555-3e5a-3459-c3f0e4726795@gmail.com>
Date:   Tue, 19 Jan 2021 22:51:27 -0800
Cc:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zhenggen Xu <zxu@linkedin.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <A54CD4CD-9280-4969-ACD3-592A6933E745@gmail.com>
References: <20210115080203.8889-1-pchaudhary@linkedin.com>
 <0f64942e-debd-81bd-b29c-7d2728a5bd4b@gmail.com>
 <A2DE27CF-A988-4003-8A95-60CC101086DA@gmail.com>
 <7839be40-6555-3e5a-3459-c3f0e4726795@gmail.com>
To:     David Ahern <dsahern@gmail.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jan 19, 2021, at 8:22 PM, David Ahern <dsahern@gmail.com> wrote:
>=20
> On 1/19/21 3:17 PM, praveen chaudhary wrote:
>>>> ----------------------------------------------------------------
>>>> For IPv4:
>>>> ----------------------------------------------------------------
>>>>=20
>>>> Config in etc/network/interfaces
>>>> ----------------------------------------------------------------
>>>> ```
>>>> auto eth0
>>>> iface eth0 inet dhcp
>>>>   metric 4261413864
>>>=20
>>> how does that work for IPv4? Is the metric passed to the dhclient =
and it
>>> inserts the route with the given metric or is a dhclient script used =
to
>>> replace the route after insert?
>>>=20
>>>=20
>>=20
>> Yes, DHCP client picks config under =E2=80=9Ciface eth0 inet dhcp=E2=80=
=9D line and if metric is configured, then it adds the metric for all =
added routes.
>=20
> As I recall ifupdown{2} forks dhclient as a process to handle dhcp
> config, and I believe there is a script that handles adding the =
default
> route with metric. Meaning ... it is not comparable to an RA.
>=20

I hope, we both will agree that a fixed metric value on default route =
learned via RA=20
restricts Network Administrators today. And such issues hinder the =
deployment
of IPv6 only networks. So if we agree that in future we may need to =
allow  a
configurable value for metric then this fix makes good sense.
BTW, kindly let me know if there is a better way to configure this =
metric. I think,
sysctl is the only way.


>>=20
>> Thanks a lot again for spending time for this Review,
>> This feature will help SONiC OS [and others Linux flavors] for better =
IPv6 support, so thanks again.
>=20
> I think SONiC is an abomination, so that is definitely not the
> motivation for my reviews. :-)
>=20

Trying to make things better day by day. That is the only solace for =
Software Engineers :-).=20

I really appreciate for your time to review this patch. Cheers.


