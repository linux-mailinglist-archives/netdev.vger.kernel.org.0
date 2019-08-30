Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7D07A38F1
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 16:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728192AbfH3OQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 10:16:15 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1244 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727751AbfH3OQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 10:16:15 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7UE3hwn132775;
        Fri, 30 Aug 2019 10:15:31 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2uq0kt2772-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Aug 2019 10:15:31 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x7UEB94f005012;
        Fri, 30 Aug 2019 14:15:30 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma02dal.us.ibm.com with ESMTP id 2un65kfrta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Aug 2019 14:15:30 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7UEFT5i55312664
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 14:15:29 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5DA40112064;
        Fri, 30 Aug 2019 14:15:29 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 027CB11206E;
        Fri, 30 Aug 2019 14:15:26 +0000 (GMT)
Received: from LeoBras (unknown [9.85.151.141])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 30 Aug 2019 14:15:26 +0000 (GMT)
Message-ID: <daa9f83eaeba2ce41a72ac2fa23e24817ef3d4a1.camel@linux.ibm.com>
Subject: Re: [PATCH v2 1/1] netfilter: nf_tables: fib: Drop IPV6 packages if
 IPv6 is disabled on boot
From:   Leonardo Bras <leonardo@linux.ibm.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Date:   Fri, 30 Aug 2019 11:15:22 -0300
In-Reply-To: <20190829205832.GM20113@breakpoint.cc>
References: <20190821141505.2394-1-leonardo@linux.ibm.com>
         <db0f02c5b1a995fde174f036540a3d11008cf116.camel@linux.ibm.com>
         <b6585989069fd832a65b73d1c4f4319a10714165.camel@linux.ibm.com>
         <20190829205832.GM20113@breakpoint.cc>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-+IABKuOZYCco6cLZ6aAe"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-30_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908300146
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-+IABKuOZYCco6cLZ6aAe
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2019-08-29 at 22:58 +0200, Florian Westphal wrote:
> In any case your patch looks ok to me.

Great! Please give your feedback on v3:=20
http://patchwork.ozlabs.org/patch/1154040/

[...]
>=20
> Even if we disable call-ip6tables in br_netfilter we will at least
> in addition need a patch for nft_fib_netdev.c.
>=20
> From a "avoid calls to ipv6 stack when its disabled" standpoint,
> the safest fix is to disable call-ip6tables functionality if ipv6
> module is off *and* fix nft_fib_netdev.c to BREAK in ipv6 is off case.
>=20
> I started to place a list of suspicous modules here, but that got out
> of hand quickly.
>=20
> So, given I don't want to plaster ipv6_mod_enabled() everywhere, I
> would suggest this course of action:
>=20
> 1. add a patch to BREAK in nft_fib_netdev.c for !ipv6_mod_enabled()
> 2. change net/bridge/br_netfilter_hooks.c, br_nf_pre_routing() to
>    make sure ipv6_mod_enabled() is true before doing the ipv6 stack
>    "emulation".
>=20
> Makes sense?
IMHO sure.

Shortly, I will send a couple patches proposing the above changes.
(Or my best understanding about them :) )=20

>=20
> Thanks,
> Florian

Thank you,
Leonardo Bras

--=-+IABKuOZYCco6cLZ6aAe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEMdeUgIzgjf6YmUyOlQYWtz9SttQFAl1pL3oACgkQlQYWtz9S
ttRoEg//YEDzqVS2pknZEenxYLlPas/7KfnsR9DlKgvsPOgmMGilF7cNsmX6TGRj
LeosgkxEJF2vr0Slja1c9jRNNl1gTBq9ICTdRw9CFMni/XOAmwPKgHVqqA6XMd9I
K5D7hdsJz2Yev00SylE5/bI+WPGhgA2deBQToKgPQiILKxQH/aU4TJer6fdiuOra
kip4EG58o164qwZH3nqPArQR32RjGOPiK4J6LxMB0OQttrBjk6i0oTQjXgYfdX/P
MqV5KZEBKRvM6NiFat1ZR7C5ns1lDONTfOAzmX1zGBHXY28xDCEpaaCSdQTUj+5G
SoCwkBtnN8h+xHtP4XuyBdlBQVJOIqoW2ICGqaYonO+k0Pa4QoXuW9VKSrRfK/x8
qLd+JHjLSPnZo9c35Gz7TaFbDPelaQnFRjBVmXhzgWiJeAIRosFzWVtzH7aQ6wAU
UOEFYMSrkYLe06gyarZR1Lltb6qSJK5SSwV7lG8kl2YmMRbc25a+UmaaRaZ2ePjt
FwyXTuYjrKL2zAwo2heF+EnJwWL4QlQifdBMS2uczXTdhX5OayElOZFYU68Mcg/n
QEe5u0G+FolDPWaA7X0eqRzjQoCmaAWNF6i78mP6NjhPdgsif5XbSzmzrYB9Tzdv
oGmHflawcvhTciuqVOZRFwN9Uow0B88OpQtSWh7H/lx7qIgf77w=
=WcP3
-----END PGP SIGNATURE-----

--=-+IABKuOZYCco6cLZ6aAe--

