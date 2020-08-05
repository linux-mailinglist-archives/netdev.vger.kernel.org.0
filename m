Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77A0523D0DE
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 21:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728242AbgHETxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 15:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727057AbgHEQtp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 12:49:45 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E16C0A889D
        for <netdev@vger.kernel.org>; Wed,  5 Aug 2020 07:03:12 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1596635887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pZAMFZECISVC+f1/HqoixYfgzBWRZz9pXR9Mug3P4/k=;
        b=OyXZKv8OIjocIvNCUhPtRDTFqONnmekMQPdug5xCC5gtxfSXxVynwnT3rjywb1En1lNrye
        ne8uIUQa551DH9eDQdBKyQ6hnh6I71o+NSJS4mAtSqWyOW/TmZOm+gcBSOYiIlsWBesm6q
        rZs5as/I7tl0Ac1SqiDqjQNhxyrAbvjSRcdQZ7VzUsKCiml3LLoCY1hnEaS5urhzEO3eDp
        PWH3yd002gSPc1GswW6eN1vcrPCjhE5mQsi5snnQ5nURY5luhrHpALm1l3Ufx7NUl2if8U
        uooZandw14xpXvMk5pvWo2yEyT6e0Bn+vTTLRqshUC7Ka279cYKImy7jjLg48w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1596635887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pZAMFZECISVC+f1/HqoixYfgzBWRZz9pXR9Mug3P4/k=;
        b=tSC0X5lHpPdkrD03x/xzs2TnA+aAfbeRwOb7gebLhuo1ivk5IgoQm7Y8hWkQoJR1/8gPTz
        LLDdDDYJbzRRG+DQ==
To:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Petr Machata <petrm@mellanox.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Samuel Zou <zou_wei@huawei.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v3 1/9] ptp: Add generic ptp v2 header parsing function
In-Reply-To: <4d9aeb50-e8df-369a-7e3d-87ff9ba86079@ti.com>
References: <20200730080048.32553-1-kurt@linutronix.de> <20200730080048.32553-2-kurt@linutronix.de> <87lfj1gvgq.fsf@mellanox.com> <87pn8c0zid.fsf@kurt> <09f58c4f-dec5-ebd1-3352-f2e240ddcbe5@ti.com> <20200804210759.GU1551@shell.armlinux.org.uk> <45130ed9-7429-f1cd-653b-64417d5a93aa@ti.com> <20200804214448.GV1551@shell.armlinux.org.uk> <8f1945a4-33a2-5576-2948-aee5141f83f6@ti.com> <20200804231429.GW1551@shell.armlinux.org.uk> <875z9x1lvn.fsf@kurt> <4d9aeb50-e8df-369a-7e3d-87ff9ba86079@ti.com>
Date:   Wed, 05 Aug 2020 15:57:53 +0200
Message-ID: <87bljpnqji.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Wed Aug 05 2020, Grygorii Strashko wrote:
> I really do not want touch netcp, sry.
> There are other internal code based on this even if there is only one hooks in LKML now.
> + my comment above.

OK, I see. The use of lists makes more sense now.

>
> I'll try use skb_reset_mac_header(skb);
> As spectrum does:
>   	skb_reset_mac_header(skb);
> 	mlxsw_sp1_ptp_got_packet(mlxsw_sp, skb, local_port, true);
>
> if doesn't help PATCH 6 is to drop.

So, only patch 6 is to drop or 5 as well? Anyhow, I'll wait for your
test results. Thanks!

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl8quuEACgkQeSpbgcuY
8KYdAQ//ehbHAz67yBuU/W69T8zgbPrwOw1L1dBaYdSXz+D2cBQtqQy9FFa5Nhro
Oexn7FxptUJQH20KjvtokHztH0XG6XOQu/VRTa0qRBgSF39f/HCGT9tNRfz77AWG
S/UYDVmV9FCyMcsXyLIhA5RORkYiDr9C99pdLijGOCFdjBkJIF9AH6Vtr7scuCOl
aHFeJcgsqzglOsziqvqEybg8iH2dKEMGnyztgPJP2fSl2A1TmqgBtnJbcCbM1grw
LzhlxTCW4dNQyD1Iqi38yUOw2UNCFZamJfmfXbiC95PqxhPzsVAgvWsBjs7B4V6B
pPuS/4829qeqYK6SnXGORgnixWhx8UfybeEW/QI0wvd5W+h47tvCYS4IjhGUuvCf
JZffSl4zFMpt79uGA7KgTXSL3RPZPtBd8bWRBhhw0tTLezsg4u66AWqR671Tvx8t
s4GRIe4LIzZU+yQj6BdJoth9sM5Q3YEU8LwKP2742nX4yuKnZYAlaeAqEwUKTjqP
87yeGG1Qdf/DZoS6zguoU0G5O9oD6tHPYbr3y1f94c+3VFMeti8WVkxXx2qGZJ3D
fC7pKVcQZ6/lzmQMNQsY6KRJ/Bwih1pcUkHQipoFjFIWnIAhSooYhIpOvypN/5WY
NVYmEQNU/D1ZecXhXU1DdwyjAqoEl2ggGBROG+2YS9wzTS2aIfw=
=Z2rm
-----END PGP SIGNATURE-----
--=-=-=--
