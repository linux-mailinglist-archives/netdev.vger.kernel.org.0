Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5F9D1C0DC3
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 07:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728277AbgEAFgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 01:36:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbgEAFgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 01:36:07 -0400
Received: from mo6-p02-ob.smtp.rzone.de (mo6-p02-ob.smtp.rzone.de [IPv6:2a01:238:20a:202:5302::9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B28C035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 22:36:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1588311362;
        s=strato-dkim-0002; d=xenosoft.de;
        h=To:In-Reply-To:Cc:References:Message-Id:Date:Subject:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=hJfQ2R9oyPXbRKp+zZNmmNIpIc89RJkcFkSmzvlkCgw=;
        b=eESpH0TwBzm64mpr0fGQTst6afDc+ZLe96ovACp3Jm0TbDMvKFL6lKImZKRZ3wiFir
        ex+QeEPFmT5V3mF8SYU3yKXbvwy7yV7q7+p4LP3tePiLsvtSsUUvkCe4KxAMs07VI5Mp
        MofTn4IoqPn+hnYDcSGc0i5fzc47rf0ae2B7I2hFroXZ/W8NoTSALyHKzb15QrFiEgKK
        KJdTEiYUEbkjmKRmsnVqYjRGvTs5wvNffT3V+HwEftPeoBlDuySV0uraceRfouNwVeaD
        I+sxmTPYMtCm4FyxQ14a7p/ych4DkKNlXd49LJ7peJ1Sa5BKfRh0L2ONW+b6o/BhcHg0
        0CvA==
X-RZG-AUTH: ":L2QefEenb+UdBJSdRCXu93KJ1bmSGnhMdmOod1DhGN0rBVhd9dFr6KxrfO5Oh7R7b2dxi7ozwXQ+Xo6i0Yv8EnsEhh3gF2nHSBbUFCw1"
X-RZG-CLASS-ID: mo00
Received: from [IPv6:2a01:598:b000:f529:7401:562d:9520:15ed]
        by smtp.strato.de (RZmta 46.6.2 AUTH)
        with ESMTPSA id I01247w415Zxi5E
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Fri, 1 May 2020 07:35:59 +0200 (CEST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Christian Zigotzky <chzigotzky@xenosoft.de>
Mime-Version: 1.0 (1.0)
Subject: Re: Don't initialise ports with no PHY
Date:   Fri, 1 May 2020 07:35:58 +0200
Message-Id: <1963BFFC-34FD-4BDC-B277-838FB332D7BF@xenosoft.de>
References: <4f9f12e02c7.744a6d93@auth.smtp.1and1.co.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>, "R.T.Dickinson" <rtd2@xtra.co.nz>,
        netdev@vger.kernel.org, mad skateman <madskateman@gmail.com>,
        linuxppc-dev@lists.ozlabs.org
In-Reply-To: <4f9f12e02c7.744a6d93@auth.smtp.1and1.co.uk>
To:     Darren Stevens <darren@stevens-zone.net>
X-Mailer: iPhone Mail (17D50)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On 30. Apr 2020, at 23:36, Darren Stevens <darren@stevens-zone.net> wrote:=

>=20
> =EF=BB=BFHello Christian
>=20
>> On 29/04/2020, Christian Zigotzky wrote:
>>=20
>>=20
>>>> On 29. Apr 2020, at 17:22, Andrew Lunn <andrew@lunn.ch> wrote:
>>>=20
>>> ?On Wed, Apr 29, 2020 at 03:55:28PM +0200, Christian Zigotzky wrote:
>>>> Hi Andrew,
>>>>=20
>>>> You can find some dtb and source files in our kernel package.
>>>>=20
>>>> Download: http://www.xenosoft.de/linux-image-5.7-rc3-X1000_X5000.tar.gz=

>>>=20
>>> I have the tarball. Are we talking about
>>>=20
>>>=20
> linux-image-5.7-rc3-X1000_X5000/X5000_and_QEMU_e5500/dtbs/X5000_20/cyrus.e=
th.dtb
>>=20
>>> I don't see any status =3D "disabled"; in the blob. So i would expect
>>> the driver to probe.
>=20
> No, the vendor never added that to them.
>=20
>> Yes, that's correct but maybe Darren uses another dtb file.
>>=20
>> @Darren
>> Which dtb file do you use?
>=20
> My current one attached, including updated cyrus_p5020.dts & p5020si-pre.d=
tsi
> which I'm preparing patches for.
>=20
> Christian, build an unmodified kernel, select board level reset or power o=
ff,
> then both the GPIO drivers.
> Then under LED Support: GPIO connected LED's and triggers -> disk activity=

>=20
> I think you still have a 5020 don't you? I'll look at 5040 later (I'll nee=
d
> someone to test)
>=20
> Regards
> Darren
> <cyrus-dts.zip>

Darren

I use a 5040 currently.

Thanks
Christian


