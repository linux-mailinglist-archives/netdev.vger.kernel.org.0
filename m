Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E309D478B60
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 13:32:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236141AbhLQMcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 07:32:33 -0500
Received: from vps.slashdirt.org ([144.91.108.218]:52966 "EHLO
        vps.slashdirt.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236039AbhLQMcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 07:32:32 -0500
X-Greylist: delayed 420 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Dec 2021 07:32:31 EST
Received: from smtpclient.apple (unknown [IPv6:2a03:4980:117:e500:f57f:f2de:1685:6cbb])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by vps.slashdirt.org (Postfix) with ESMTPSA id 83887600F5;
        Fri, 17 Dec 2021 13:25:28 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 vps.slashdirt.org 83887600F5
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=slashdirt.org; s=mail;
        t=1639743930; bh=w3lTyQFPgz1iRDYYTzvF8n7RYG8pjeS2PbjnS4HmxLA=;
        h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
        b=oWTQVimqdLJLbCY1SD2plmL3q3mxxDNIKfGakk8slmHH1OFDHWTywWe0O2BGks/gc
         T9pbcuMZTJLIm21XsyrtS/mY30ozETb3vE1OWE9VFgmhdxpFj2HWo7kbfrfTBcSjsO
         ACaBXevbaxU/QgAEUn82WTAsaiQgSkCu0UieuneU=
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.20.0.1.32\))
Subject: Re: [PATCH] ath10k: support bus and device specific API 1 BDF
 selection
From:   Thibaut <hacks@slashdirt.org>
In-Reply-To: <CAOX2RU6qaZ7NkeRe1bukgH6OxXOPvJS=z9PRp=UYAxMfzwD2oQ@mail.gmail.com>
Date:   Fri, 17 Dec 2021 13:25:28 +0100
Cc:     Christian Lamparter <chunkeey@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <EC2778B3-B957-4F3F-B299-CC18805F8381@slashdirt.org>
References: <20211009221711.2315352-1-robimarko@gmail.com>
 <163890036783.24891.8718291787865192280.kvalo@kernel.org>
 <CAOX2RU5mqUfPRDsQNSpVPdiz6sE_68KN5Ae+2bC_t1cQzdzgTA@mail.gmail.com>
 <09a27912-9ea4-fe75-df72-41ba0fa5fd4e@gmail.com>
 <CAOX2RU6qaZ7NkeRe1bukgH6OxXOPvJS=z9PRp=UYAxMfzwD2oQ@mail.gmail.com>
To:     Robert Marko <robimarko@gmail.com>
X-Mailer: Apple Mail (2.3693.20.0.1.32)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> Le 17 d=C3=A9c. 2021 =C3=A0 13:06, Robert Marko <robimarko@gmail.com> =
a =C3=A9crit :
>=20
> On Wed, 8 Dec 2021 at 15:07, Christian Lamparter <chunkeey@gmail.com> =
wrote:
>>=20
>> Isn't the only user of this the non-upstreamable rb_hardconfig
>> mikrotik platform driver?

The driver could be upstreamed if desirable.
Yet I think it=E2=80=99s quite orthogonal to having the possibility to =
dynamically load a different BDF via API 1 for each available radio, =
which before this patch couldn=E2=80=99t be done and is necessary for =
this particular hardware.

>> So, in your case the devices in question
>> needs to setup a detour through the userspace firmware =
(helper+scripts)
>> to pull on the sysfs of that mikrotik platform driver? Wouldn't it
>> be possible to do this more directly?
>=20
> Yes, its the sole current user as its the only vendor shipping the BDF
> as part of the
> factory data and not like a userspace blob.
>=20
> I don't see how can it be more direct, its the same setup as when
> getting pre-cal
> data for most devices currently.

Indeed, not sure how it could be more direct than it already is. I=E2=80=99=
m open to suggestions though.

> I am adding Thibaut who is the author of the platform driver.

Best,
Thibaut=
