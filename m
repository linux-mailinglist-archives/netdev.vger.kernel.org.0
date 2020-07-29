Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B20E4232048
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 16:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgG2O0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 10:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbgG2O0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 10:26:06 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D110BC061794
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 07:26:05 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1596032762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Dri3wC0snnZvlvvKPHpzZlS/oHUsRJgR8OkqPmf/NhM=;
        b=3H6ytHyywCiCghCM0s1Zy8YYLxPiAmhPzyLQfMM6/QXiJGphpyXaV4F1yywKMDoqqRGBR2
        TfkJqrdvuRAwWUi83LSCvHVezIPey8xh+/emXm5xFm27kmr5ecwXLqspiwkea2O1hHi2rR
        KpfuC5Ay4lDP/rZUoT9dA8T/5aAVvyUkFIQW3qykoPTYYDF47EphzpLx2WAuHWPl4Kjp9a
        CjbJYsjTg4vMTVu6v3GM16O4K0Jzex9c7iryiJARW62PkgPqNdiPt3XhWwaHqN6xbdn0FH
        CIAPp3zxgCQCOfC6cqPr769yUl5kZDiJhTy/hwi3ZN3YvkntnjtNoCDhq52CuA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1596032762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Dri3wC0snnZvlvvKPHpzZlS/oHUsRJgR8OkqPmf/NhM=;
        b=0zsi3bN+un/mZ3POiY90HFgkDUgmVK5MIa0Mg7e8JxrQmpqz/lW94uaGonMWVz+nUUTuLl
        JpEEqCE26d656cBA==
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Petr Machata <petrm@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Samuel Zou <zou_wei@huawei.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v2 4/9] mlxsw: spectrum_ptp: Use generic helper function
In-Reply-To: <20200729134958.GC23222@hoboy>
References: <20200727090601.6500-1-kurt@linutronix.de> <20200727090601.6500-5-kurt@linutronix.de> <87a6zli04l.fsf@mellanox.com> <875za7sr7b.fsf@kurt> <87pn8fgxj3.fsf@mellanox.com> <20200729100257.GX1551@shell.armlinux.org.uk> <87sgdaaa2z.fsf@kurt> <20200729134958.GC23222@hoboy>
Date:   Wed, 29 Jul 2020 16:26:00 +0200
Message-ID: <87eeou9z47.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed Jul 29 2020, Richard Cochran wrote:
> On Wed, Jul 29, 2020 at 12:29:08PM +0200, Kurt Kanzenbach wrote:
>> I'll test it and send v3. But before, I've got another question that
>> somebody might have an answer to:
>>=20
>> The ptp v1 code always does locate the message type at
>>=20
>>  msgtype =3D data + offset + OFF_PTP_CONTROL
>>=20
>> OFF_PTP_CONTROL is 32. However, looking at the ptp v1 header, the
>> message type is located at offset 20. What am I missing here?
>
>
> My source back in the day was the John Eidson book.  In Appendix A it cla=
ims
>
>
>                    Table A.1. Common PTP message fields
>
>    Field name                    Purpose
>    --------------------------------------------------------------------
>    messageType                   Identifies message as event or general
>    control                       Indicates the message type, e.g., Sync

OK. That was the missing piece. I'll adjust patch 2 accordingly. Thanks
a lot.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl8hhvgACgkQeSpbgcuY
8KaYqA//Ywn4byl4tWcoqDc5183PojVqBLiUrKMiU/as3YXPONJk2124F1Ks8ltt
YVeS1p7wlogZvz58BGxKC68dPTN7I8TK7rwIAfJIkhH6VTQcHpssWPRC7BBRRV/L
0Dkbui/rcUMnzPynKojNCsMp2LDRN52KJCLMKGvwladQkvu+4Vekn9/BH0pNLBfS
OxnPPiNUwEMkO9Sc9PEuoHTUTdubQct3tzLAWtihsWvxsEPbk8c7ENGsxDfPVHJ1
WtyXIGOmNMHXU/COMC8vaBqPrXhGaRWpi50prMYI22YaW0YoIznDAMW6uUMVW61T
FZF1OFlCqlQDps5bk2I9N0jx5vK0x0zD6MRgh8O7RWsZM16JZYSA/vIE9HRFs7jL
yZbcJ5XKAYcBtIA12bcD9DYyYKPJ/dPSu4LmUky52sfdg6hE+t/PVQf63U0U3GXW
M8ChZ3BrTjXts+wFF5AvszNw3x87XvPchoqj5oqaPL5fIjl1k8wZdWLAtic9ERFZ
1Nl/YCcYsUZmwTNetJKh8YRwjZJ1//KbDxNMpMSBGJjGiwJq7vecol8llBkr+NaG
hdS/yXEoet4GrrBShJXv7cqyNAKIo1C5HZ9qe2PI82eMnF7QWKZtTTXX2R3OUg1P
cnhaVVV+tkKfF9eXRWlQ360ixEZhaOR9r9vKype8pYIIE7sI24Q=
=4me5
-----END PGP SIGNATURE-----
--=-=-=--
