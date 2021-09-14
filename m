Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C85940AB4E
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 12:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbhINKCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 06:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbhINKCq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 06:02:46 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E43C061574
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 03:01:28 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id i21so27620800ejd.2
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 03:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Tk4/0DznfHHusfrQM+PryYkGknItx7s/3txw+QrVwsk=;
        b=EKv69U4RxmCJZWyia55ReUa0GP57tS5qP+FjXF+LMjaKMTnsCqYqWS2BzYSTzoSg8q
         +q4xtJ7xQxnK+Uv8WYTNja+uDBo6SurkU0730HetNrM2zfULXLA2rXlqTFv1REoDQCY3
         7s9DPuff9KVVYx2muiFLhuL43IIp3tZSHyE1DUP2Qw3iGsOCKNOBsGQAvLnt0yO+gqJ4
         4LLVwMdRqnkqRGXhr3CrooWKuhcZKdM7EYeqdYKA6czQZkeZhzhnVGlDRnpEsk6/dqdr
         P9wluWhKCqO46lSJcxZu0w5cPr3xKKOG87iUhRwp6xR7Yh68IOw82J0+MAgorU2ZjXlV
         0ydA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Tk4/0DznfHHusfrQM+PryYkGknItx7s/3txw+QrVwsk=;
        b=qllXJPHNGgSK8V2IwIexO8rSe8/kW6RZTq3c0I/nWMxcackmL9PRjbQW5TnATmntpE
         nb01i2Rjnb+p6lc+gldX3tmir/UivRc3IUqcb1nxab3EgYy+nXyu+Zva1/tT8+n1/dSg
         iz1eJu6AvfOzEfOi4hW21mxrjDOZGnP6CFcAOK+hiGZw9K/5Eh7Rmu2+ehpNV5i9Kjax
         XXMk4TyabkLyOW7sSf0p6WedLzPNNLSYJ37ib7k0s2s+B4N5PqrxaE7MW7WcPW6W5l0w
         j5tRUQfIymjvJ7lCuywJH97iUEF4bmLgxtPwdgDYBwr8fC6uaXVHKiBf5iNHMN+hHnwF
         IV+w==
X-Gm-Message-State: AOAM530tmpBKF5HNODUB16OZQiYYm6QlOTc4hn0ifWbybtH2XhAnuhVO
        H5fr5thO+7kxuK5VHUBC4ZE=
X-Google-Smtp-Source: ABdhPJznXDPtaYDTAjVJlWpwP5lETitJ97A7BmS2QiO/YmPJlgC5h5z/Nl/Z+dnEvptwilAGCuDkJg==
X-Received: by 2002:a17:906:1d41:: with SMTP id o1mr18181628ejh.232.1631613687465;
        Tue, 14 Sep 2021 03:01:27 -0700 (PDT)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id by26sm3222836edb.69.2021.09.14.03.01.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Sep 2021 03:01:26 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: Urgent  Bug report: PPPoE ioctl(PPPIOCCONNECT): Transport
 endpoint is not connected
From:   Martin Zaharinov <micron10@gmail.com>
In-Reply-To: <20210914095015.GA9076@breakpoint.cc>
Date:   Tue, 14 Sep 2021 13:01:25 +0300
Cc:     Guillaume Nault <gnault@redhat.com>,
        =?utf-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <1724F1B4-5048-4625-88A5-1193D4445D5A@gmail.com>
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

Hi Nault and Florian

Nault :=20

No not test need conntrack to log user traffic.

Florian:=20

If you make patch send to test please.


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

