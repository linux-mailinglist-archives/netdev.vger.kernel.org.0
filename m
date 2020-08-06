Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F92423D7C2
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 09:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728334AbgHFH4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 03:56:24 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:56462 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727006AbgHFH4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 03:56:19 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1596700577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oxcPCOsVLRgnK8paFoLXrTRYnlgDIKkJ0vlNmxVeJus=;
        b=TnE7SWjtF48lxgl5bhgi+lGeBZ+O3H4tB0WRy84SXJ/UXeVQpLoSKF0DWZVKejvbPukEY5
        uzu5OwZIdy2pJTe+7jGLzy5smhfI+5ybZZO9+jJp/LMbsLQAfDTez98Xc5Q5UGpN9jPJlm
        viHHaSwq1FNzgpswmN6DurjLIH4+gONcthDh6tdDURSNgox05npDbmdPpm43lmauo2B1lu
        eIHDBKNwLkafd2+OnU3JwZJp1nmjyRKqycpRntsnjU9EejHMwWHL83pYns8ABbgWd6YLRG
        VdC12cfsZIeY0ZMQbpRI7Qm1yy3LoOrV5rgN9+h6Mm7dxy7oIgkuaSafM9ekBw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1596700577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oxcPCOsVLRgnK8paFoLXrTRYnlgDIKkJ0vlNmxVeJus=;
        b=TNYS64vbQjTZ8Lp4PYXJ5vnIEq9MFQH24giySrtCtPzrx+ROdyfIqdPot0U0X0sg7q60mF
        UeYxgMJmjcNjeZDA==
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
In-Reply-To: <292391c2-e59c-7c53-6bdd-164d9f3fd867@ti.com>
References: <20200730080048.32553-1-kurt@linutronix.de> <20200730080048.32553-2-kurt@linutronix.de> <87lfj1gvgq.fsf@mellanox.com> <87pn8c0zid.fsf@kurt> <09f58c4f-dec5-ebd1-3352-f2e240ddcbe5@ti.com> <20200804210759.GU1551@shell.armlinux.org.uk> <45130ed9-7429-f1cd-653b-64417d5a93aa@ti.com> <20200804214448.GV1551@shell.armlinux.org.uk> <8f1945a4-33a2-5576-2948-aee5141f83f6@ti.com> <20200804231429.GW1551@shell.armlinux.org.uk> <875z9x1lvn.fsf@kurt> <4d9aeb50-e8df-369a-7e3d-87ff9ba86079@ti.com> <87bljpnqji.fsf@kurt> <292391c2-e59c-7c53-6bdd-164d9f3fd867@ti.com>
Date:   Thu, 06 Aug 2020 09:56:05 +0200
Message-ID: <874kpg8ay2.fsf@kurt>
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
> On 05/08/2020 16:57, Kurt Kanzenbach wrote:
>> So, only patch 6 is to drop or 5 as well? Anyhow, I'll wait for your
>> test results. Thanks!
>
> Patch 5 not affected as all RX packet have timestamp and it's coming different way.
> TX not affected as skb come to .xmit() properly initialized.

OK.

>
> As I've just replied for patch 6 - skb_reset_mac_header() helps.

OK. I'll add it. Thanks for testing and fixing it.

>
> Rhetorical question - is below check really required?
> Bad packets (short, crc) expected to be discarded by HW
>
> 	/* Ensure that the entire header is present in this packet. */
> 	if (ptr + sizeof(struct ptp_header) > skb->data + skb->len)
> 		return NULL;

Even if it's a rhetorical question - Can we rely on the fact that too
short packets (or bad) are discarded? All driver instances I've changed
in this series do the length check somehow.

>
>
> And I'd like to ask you to update ptp_parse_header() documentation
> with description of expected SKB state for this function to work.

Yes, I've wanted to do that anyway.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl8rt5UACgkQeSpbgcuY
8Kb5ERAAvBwonm2Faij5go3anEM1aVYo2HBlWIMbWnT4AKOaXYuJieTbRrfs7Skw
8FGl99t+KOjMevZq7GZwaIRDy6CoqBJm8VFpn6aN28Erh6AKykwz7Qpqy5tIWQQx
BLNepz9hqiLVmad01WGn1AxL0h1pKEvmRQMGmMPOvUhZMXHQXuY7AGSFle/oYdJ4
yM0YGLq1ihR+xEQdDuxq2Np8mt/GS+Am9kBZ3bk8xy02Vp0pjuiey8kRDsLZiYeE
CXtTs9V9crGCSqhWbdiGyGhQOEfKJ7W04+Y/Mn9O1c2lM8teB0SdXniKFE3318Wr
6ruzh6d/KcGIgB2PYgUMgAA0E+uuL0sY6N1x6P3vYSvMbDnab31pc+b60hG77QC+
RMbpIK8f+eYaD2f4FqNYATNpoDPazCUf0aDlThTcEuuxiun8bH/qKXwe2+qiIx4g
2+VSgA7fyY5oDKJep8sLaHQdGD3J+JWxtZD080XnpaVDcYD/lNsx4vmh3l/WcE4m
ASYDO8a8pmZhyiv0WUoBPP4hk5+idfZLEQC8+A4fOsx2uArgKOEMnlWWgnbq5IM9
wJVJDv7keitX3gAOpgWTmiMre3FyZWqKZ7Sh8aT/1RJU8P43VePSemly39P017Iz
pnZYNqTlTrOtHIagajdpIefMy/Zi+1dpoP7+CDZ3247fOBwzA2k=
=2MWq
-----END PGP SIGNATURE-----
--=-=-=--
