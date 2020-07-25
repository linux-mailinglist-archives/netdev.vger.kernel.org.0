Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0C222D5A0
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 09:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbgGYHEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 03:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgGYHEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 03:04:39 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A0BCC0619D3
        for <netdev@vger.kernel.org>; Sat, 25 Jul 2020 00:04:39 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1595660677;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TnChhB4iMyKM7B2WXTjtIxWd1gDqy4U0wELOTljV0Ak=;
        b=WQYPJIieFwGN7UmBc39MMU2pv6YiWXorqMPiOl1kDpGuE0Eib3p8E0jPduiSzPvsm/qQ4r
        ui/o0aZkqvC3VsgtUyr2HLDijJ0TrJ5F1WBiAtEj+1CcCnZz9DPxfdxUzhbhNqPzcZocZL
        2w6KOQuiQRqJvixcxnuw4F1adff82qKoKqxIYfoL3F+a8AauGyqa4OpiIHMp8RBNMaWOoK
        5u7dhGas8zndX/lLSa6WJNjyLLrhPK37y1iaB1HhC7rAvG0rcu7qoGbHHs7IlHTIDkIEjj
        lh8o2IESPSbXKW3htKQ0alf4FGcL6HPiMKK7VE6dRlP4LbiIs7m/yhON5R6MxA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1595660677;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TnChhB4iMyKM7B2WXTjtIxWd1gDqy4U0wELOTljV0Ak=;
        b=A/1HZWy9QZd2neZcPMbPF7+2xOX6bROr9f29xvPiumgIzXQH1vzmDGicuQIU8KdvrzJWVi
        jfiB+GkSkfsdT5DQ==
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH v1 0/2] ptp: Add generic header parsing function
In-Reply-To: <20200724160335.GA30531@hoboy>
References: <20200723074946.14253-1-kurt@linutronix.de> <20200723170842.GB2975@hoboy> <87r1t12zuw.fsf@kurt> <20200724160335.GA30531@hoboy>
Date:   Sat, 25 Jul 2020 09:04:36 +0200
Message-ID: <871rl0nkhn.fsf@kurt>
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

On Fri Jul 24 2020, Richard Cochran wrote:
> On Fri, Jul 24, 2020 at 08:25:59AM +0200, Kurt Kanzenbach wrote:
>> |static inline u8 ptp_get_msgtype(const struct ptp_header *hdr, unsigned=
 int type)
>> |{
>> |	u8 msg;
>> |
>> |	if (unlikely(type & PTP_CLASS_V1))
>> |		/* msg type is located @ offset 20 for ptp v1 */=20
>> |		msg =3D hdr->source_port_identity.clock_identity.id[0];
>> |	else
>> |		msg =3D hdr->tsmt & 0x0f;
>> |
>> |	return msg;
>> |}
>>=20
>> What do you think about it?
>
> Looks good.

OK, I'll add it.

>
> I can also test the dp83640.  Maybe you could test the cpts on a bbb?

Most likely, yes.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl8b2YQACgkQeSpbgcuY
8KY0TQ/+NO77q666WFl/taM4WwxntpainTC4Rw7v+nm9vunjoX6fRHvbwiIXZthT
QYWEusUQU3yYE2UQYLVLzgnikysbNHm9lDqt20FHUZG+0bDpA3f91KPeBR3GFYzo
qvIe4O+G7y2eC9oP26n4jdKvGtl3RGUa82MqFyMyjHCX0cCDv+ccOTGOlsde5j7x
4NJWYEMrFk0wqYZTLHwvZH36F57/vVsR6MzqKvDeArR+WJmUL0V+gOP4nZURgifA
N9EGg2F9ZYaqBX3exNoexb/mhp2ZrcTc65pzLgp0aUk3+WhfnrxuiUwGDjSM1w1x
WgFmzaqTlxhfKcoEpUanfTSYTKHEwVBT7jUNKnUr5G3vp/Y1bhn+zPW3CbbqlSff
8c46a5CjDQYM32Jp8DNxbeEwXoPZYwK2YbNIyGzsz3pkdz99XXEH5Znyf1f0Kh/D
q/mFFGhGwxh+QCcwllF3me4ZU3FRhUlJcN7rse5biNTrRrYslzKntNhvOePUbuu7
QWGQ7K69TPGt1geG0+czKOCT25Q9L0ty/gHmTY8Ca8+IiSJKo3Y9RIALldbX6WoU
Hf+kpDyMyWptF6FrVskT8hqk8YgzenUQzIA/sLUHfW68cZ/tXJl7lbpcqfRuZ7Iy
qInt8CGR39+g+AVpNp89Ss/ZS7ywBjEbCK55ZbwybzhrzlFeOjc=
=F8BW
-----END PGP SIGNATURE-----
--=-=-=--
