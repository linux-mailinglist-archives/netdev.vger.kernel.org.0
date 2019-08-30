Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85347A3D9A
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 20:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbfH3SSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 14:18:52 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46180 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727246AbfH3SSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 14:18:52 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7UI2gaZ111190;
        Fri, 30 Aug 2019 14:17:08 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2uq77fb9wc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Aug 2019 14:17:08 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x7UI4pdi023363;
        Fri, 30 Aug 2019 18:17:06 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma01wdc.us.ibm.com with ESMTP id 2ujvv6v7ad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Aug 2019 18:17:06 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7UIH6Pj53084484
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 18:17:06 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 76867AE05F;
        Fri, 30 Aug 2019 18:17:06 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 13AC7AE064;
        Fri, 30 Aug 2019 18:17:04 +0000 (GMT)
Received: from LeoBras (unknown [9.85.151.141])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 30 Aug 2019 18:17:03 +0000 (GMT)
Message-ID: <77102bfec450d92c58d572a0af3981f7171e67e9.camel@linux.ibm.com>
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
Date:   Fri, 30 Aug 2019 15:16:59 -0300
In-Reply-To: <20190829205832.GM20113@breakpoint.cc>
References: <20190821141505.2394-1-leonardo@linux.ibm.com>
         <db0f02c5b1a995fde174f036540a3d11008cf116.camel@linux.ibm.com>
         <b6585989069fd832a65b73d1c4f4319a10714165.camel@linux.ibm.com>
         <20190829205832.GM20113@breakpoint.cc>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-LXuXxsj4EfX4WwucxL0p"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-30_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908300176
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-LXuXxsj4EfX4WwucxL0p
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2019-08-29 at 22:58 +0200, Florian Westphal wrote:

> Ah, it was the latter.
> Making bridge netfilter not pass packets up with ipv6 off closes
> the problem for fib_ipv6 and inet, so only _netdev.c needs fixing.

Ok then, preparing a v4.
https://lkml.org/lkml/2019/8/30/843


--=-LXuXxsj4EfX4WwucxL0p
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEMdeUgIzgjf6YmUyOlQYWtz9SttQFAl1paBsACgkQlQYWtz9S
ttSreg//XGxhxzY/pjkpjXL6mAu4Ba2JIuox5I+MBXaU1arO1ruCqx3Ses4CVSlr
RDydtxtS2iCPo6d30Ynsfk5MoyKCIeppFNYQzjT7AHHzym3xoZOuOBIQrf5n/Or/
mvandv5TuEuMrsmna4ADSKxBinkJCaBgQYNufkeKzONqJhMyLaWj2DXQITpy+SEx
yx+IXOniAkU6x3w+P44ESLBaDTX62njJGXfeQS3Taf7CQVDlOIywiT0ScfKZ0OHW
VppqGirwDgUsBbXkjIgthgXp+exEa+gRtc8laWf+48pReY/aNiWKesSBC4zW0j9j
bjbPx19TssSa2KhkKhre0p4Y/EjsbAfNyEJRXR2DgNvqG+aKd+ye/qI9HfczGGE6
MTbXQ4Vg2PDxPGWczjVL4EpRS9iVAl5tQpETDXz48a4YVH2aeY1H7+3mWCcESgtY
AhegAKFzXP9ZlSVZjgb0yoQ79lHiGkOkxdeOZMz8PC+4XnJIMvKn/ren+tZsQz4k
EbOdS1Nnv6QMnQADnLiStgMO0uWn+rVu6ZLWK9hKxKWv2NCmNBV/e2SHxsmFElyM
w8Kusc2KkUXG8Q1DlwpQGt8IjRPUL0oirY9xKPhoBRWdfmllH3XVFUoPaHEBEiag
flNTnU7BS9xplMVvRxAxOuHVa2d/WxeYY23pGnO8omabU0sBNNo=
=YKYm
-----END PGP SIGNATURE-----

--=-LXuXxsj4EfX4WwucxL0p--

