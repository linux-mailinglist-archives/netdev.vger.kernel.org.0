Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A60CA3AF6
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 17:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728178AbfH3Pt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 11:49:58 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58220 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727135AbfH3Pt5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 11:49:57 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7UFmKhi135060;
        Fri, 30 Aug 2019 11:48:20 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2uq6cd8w4h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Aug 2019 11:48:20 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x7UFg72J028795;
        Fri, 30 Aug 2019 15:48:19 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma02dal.us.ibm.com with ESMTP id 2un65kg9dm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Aug 2019 15:48:19 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7UFmInU42729834
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 15:48:18 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6FEF6AE05C;
        Fri, 30 Aug 2019 15:48:18 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D75B3AE05F;
        Fri, 30 Aug 2019 15:48:15 +0000 (GMT)
Received: from LeoBras (unknown [9.85.151.141])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 30 Aug 2019 15:48:15 +0000 (GMT)
Message-ID: <4b3b52d0f73aeb1437b4b2a46325b36e9c41f92b.camel@linux.ibm.com>
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
Date:   Fri, 30 Aug 2019 12:48:11 -0300
In-Reply-To: <20190829205832.GM20113@breakpoint.cc>
References: <20190821141505.2394-1-leonardo@linux.ibm.com>
         <db0f02c5b1a995fde174f036540a3d11008cf116.camel@linux.ibm.com>
         <b6585989069fd832a65b73d1c4f4319a10714165.camel@linux.ibm.com>
         <20190829205832.GM20113@breakpoint.cc>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-oQxTJclox6vwlEkEdc9g"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-30_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908300157
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-oQxTJclox6vwlEkEdc9g
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2019-08-29 at 22:58 +0200, Florian Westphal wrote:
[...]
> 1. add a patch to BREAK in nft_fib_netdev.c for !ipv6_mod_enabled()
[...]

But this is still needed? I mean, in nft_fib_netdev_eval there are only
2 functions being called for IPv6 protocol : nft_fib6_eval and
nft_fib6_eval_type. Both are already protected by this current patch.

Is your 1st suggestion about this patch, or you think it's better to
move this change to nft_fib_netdev_eval ?

Best regards,
Leonardo Bras

--=-oQxTJclox6vwlEkEdc9g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEMdeUgIzgjf6YmUyOlQYWtz9SttQFAl1pRTsACgkQlQYWtz9S
ttR8vg//bORcfn9a17NfB/LSQtdMIyP0xefyHbkTJ3ZpRcj7XLzdkqrnAoksLzEG
z0EP0HoNn1M2I8WDglih/B+pLqyc9vaCn73+7cem61/+Uhcqzb/7z8zvmn6HLdI2
G8cpXJeOL+vOG2YXb1kX+FfJ7BtLyalCJ/KyJvLtpy+J0UVTILvXD/ag0huemWs1
xHpzVEDys4Gwh+EPF9hOpFDCnQDbp6QdmOxXKXkq/C4ArLHrSok5mZQOsHo6BFrh
SpPGZsStPVWPIx/Xt+2H4AxkP3VpSr332sWViTh94YX6rTGDMMaWCm0bH4/aIAF/
J0Nj9ig2i1eKrKNXcg21dzcw0AgqXOdts4I1DJfi9aNflB8sOu9+/VgMLiz36mjl
463rg6Lc/Rx16HQ3w3g2usaaVWM7qSSYw7AvWbccIJjYHQHO6Sw4o60ErJkE0mie
W2KCD+pYRjmbF0pRmcsuFPlVMFa+u1aM2iwNbE47XYiXBBwHC5cvGBupj5KLanSy
fsFQQX2qLpC5Wc67M1xGv6SE+1PuKza3sH3w/z0WzeKewAJ38BsEZtOF7mfdwrHw
ZNKRpjUFimwQz1QjlSd7wki2nzrNj4REDQ1xMjdEZQpBnHN7jctb0AlpuI24VbMR
pkhAqZE+qzGgoeT5j7fVg7ow487ckU9/mScTImeIRmHArgNGJVw=
=cgry
-----END PGP SIGNATURE-----

--=-oQxTJclox6vwlEkEdc9g--

