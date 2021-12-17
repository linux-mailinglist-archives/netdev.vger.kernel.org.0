Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B200247894E
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 11:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235143AbhLQK57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 05:57:59 -0500
Received: from sender3-op-o12.zoho.com ([136.143.184.12]:17897 "EHLO
        sender3-op-o12.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235032AbhLQK56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 05:57:58 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1639738667; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=AemxX4kYs+7ymy+k1SW7S2mb8m+shbSzKAQD99o3W7HVEfBg6E6TVOeTzTko26VbqoM9MZapx1AwRs8NZLSdRfE35aW4l+1WhScZ+XffqljHUAp6XakvM5ks5NC/N39bQC24Q7wOKZ01phw6vRgYPMXAFpklBHIsOXkeU8SBJBk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1639738667; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=e+NvNmDILrHFPV8oik2ojBh7PB5Hu4T1++Ta0KfnK1A=; 
        b=O/8s1xYtkDuSOzfDWolZGZPNdQQFrW9Msimw/71UqMi/CW0uXGYOuPPzzQI8wNLMKzwEdtVm+8aqI1N/ATs6OJ2MMjd0uG2g0/Q83CW4bxqYayzZIT9FgA9jq5PAlNozacwZgNNAbKehYkW+FZWoUaRbp/E8i05bMohtkP/RJAU=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1639738667;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Content-Type:Content-Transfer-Encoding:From:Mime-Version:Subject:Date:Message-Id:References:Cc:In-Reply-To:To;
        bh=e+NvNmDILrHFPV8oik2ojBh7PB5Hu4T1++Ta0KfnK1A=;
        b=HFY5awbV0d6qzShdTTshBzzavBk+GvkpXMuPAiL8uAc0qrAPdFEBv32E6lHaGp9i
        mXzlpQhGPljFAlxeSoolxfERiTNREaK+J8KUiEEnNaGEwbULSg9AZFu6xRsWGwe6MNL
        Q9D6cttZwQLq+JlBHxFcttvHQ31M6AObqm6DOhXs=
Received: from [10.10.9.3] (85.117.236.245 [85.117.236.245]) by mx.zohomail.com
        with SMTPS id 1639738665275919.3434676396447; Fri, 17 Dec 2021 02:57:45 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   =?utf-8?Q?Ar=C4=B1n=C3=A7_=C3=9CNAL?= <arinc.unal@arinc9.com>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH net-next 07/13] net: dsa: rtl8365mb: rename rtl8365mb to rtl8367c
Date:   Fri, 17 Dec 2021 13:57:38 +0300
Message-Id: <49975111-781B-4DF8-B63B-4E78ACD9BF8B@arinc9.com>
References: <1fbf5793-8635-557b-79f2-39b70b141ba3@bang-olufsen.dk>
Cc:     "luizluca@gmail.com" <luizluca@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>
In-Reply-To: <1fbf5793-8635-557b-79f2-39b70b141ba3@bang-olufsen.dk>
To:     =?utf-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
X-Mailer: iPhone Mail (17H35)
X-ZohoMailClient: External
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Alvin.

> On 17 Dec 2021, at 02:42, Alvin =C5=A0ipraga <ALSI@bang-olufsen.dk> wrote:=

>=20
> =EF=BB=BFHi Luiz,
>=20
>> On 12/16/21 21:13, luizluca@gmail.com wrote:
>> From: Luiz Angelo Daros de Luca <luizluca@gmail.com>
>>=20
>> rtl8365mb refers to a single device supported by the driver.
>> The rtl8367c does not refer to any real device, but it is the
>> driver version name used by Realtek.
>>=20
>> Tested-by: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com>
>> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
>> ---
>>  drivers/net/dsa/realtek/Kconfig       |    9 +-
>>  drivers/net/dsa/realtek/Makefile      |    2 +-
>>  drivers/net/dsa/realtek/realtek-smi.c |    4 +-
>>  drivers/net/dsa/realtek/realtek.h     |    2 +-
>>  drivers/net/dsa/realtek/rtl8367c.c    | 1321 ++++++++++++-------------
>>  drivers/net/phy/realtek.c             |    2 +-
>>  6 files changed, 666 insertions(+), 674 deletions(-)
>>=20
>=20
> Is the rename really necessary? My logic in naming it rtl8365mb was=20
> simply that it was the first hardware to be supported by the driver,=20
> which was more meaningful than Realtek's fictitious rtl8367c. This seems=20=

> to be common practice in the kernel, and bulk renames don't normally=20
> bring much value.
>=20
> I think the vendor's naming scheme is confusing at best, so it's better=20=

> to stick to real things in the kernel.

Here's my 2 cents on this. We do know that rtl8367c is the family name of a b=
unch of different switch models. Yes, it=E2=80=99s a huge chunk of change wi=
th no real benefits but since we=E2=80=99re already necessarily changing fun=
ction names of other parts of the code (e.g. smi -> priv), I believe changin=
g the subdriver to the most accurate name that represents these switch model=
s along with that would be acceptable and for the better.

Cheers.
Ar=C4=B1n=C3=A7

>=20
>    Alvin

