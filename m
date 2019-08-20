Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBD796608
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 18:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730261AbfHTQQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 12:16:15 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35326 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730123AbfHTQQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 12:16:15 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7KGDIm3008590;
        Tue, 20 Aug 2019 12:16:06 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ugjn4dd58-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Aug 2019 12:16:06 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x7KGFMhg027748;
        Tue, 20 Aug 2019 16:16:04 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma02dal.us.ibm.com with ESMTP id 2ue9768xfv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Aug 2019 16:16:04 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7KGG3MA53412332
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 16:16:03 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D94AD112061;
        Tue, 20 Aug 2019 16:16:03 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D5CA112066;
        Tue, 20 Aug 2019 16:16:02 +0000 (GMT)
Received: from leobras.br.ibm.com (unknown [9.18.235.137])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 20 Aug 2019 16:16:02 +0000 (GMT)
Message-ID: <793ce2e9b6200a033d44716749acc837aaf5e4e7.camel@linux.ibm.com>
Subject: Re: [PATCH 1/1] netfilter: nf_tables: fib: Drop IPV6 packages if
 IPv6 is disabled on boot
From:   Leonardo Bras <leonardo@linux.ibm.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>
Date:   Tue, 20 Aug 2019 13:15:58 -0300
In-Reply-To: <20190820053607.GL2588@breakpoint.cc>
References: <20190820005821.2644-1-leonardo@linux.ibm.com>
         <20190820053607.GL2588@breakpoint.cc>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-m9cJ5dvj55slR763He6R"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-20_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908200150
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-m9cJ5dvj55slR763He6R
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2019-08-20 at 07:36 +0200, Florian Westphal wrote:
> Wouldn't fib_netdev.c have the same problem?
Probably, but I haven't hit this issue yet.

> If so, might be better to place this test in both
> nft_fib6_eval_type and nft_fib6_eval.
I think that is possible, and not very hard to do.

But in my humble viewpoint, it looks like it's nft_fib_inet_eval() and
nft_fib_netdev_eval() have the responsibility to choose a valid
protocol or drop the package.=20
I am not sure if it would be a good move to transfer this
responsibility to nft_fib6_eval_type() and nft_fib6_eval(), so I would
rather add the same test to nft_fib_netdev_eval().

Does it make sense?

Thanks for the feedback!

Leonardo Bras


--=-m9cJ5dvj55slR763He6R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEMdeUgIzgjf6YmUyOlQYWtz9SttQFAl1cHL4ACgkQlQYWtz9S
ttQbUQ//an3s2FA0YmWznPCpuVyaRbg4KSGnPHCjofiK80uNECoyITzkXkjLAtpe
KjHFZTLAyJ88bSIXzT4Xk3qiGn3GHLVPoJKZyMqMic/kTVg2Uz+ylOl4FRGzI5uL
KYIgXLWgha1MYUCv6nhjNwWB9a6lvGMiquiwFWRdv/VtqXcEPh8YB2hTlxjH9O1E
mSQyapLF+2JLCWhj3M2dzX5TVGPPSoVmiYI2+PQpcnriTD5f4ouok+aTY0xUjLEJ
YiFGaGsbQXePVz0MZgFqyM/k+sbP+7DyBSy3qhexluK/TaM/5SE5PXihm9uXou63
w1A7kvVYQgIjSu9z3IkcWKhR5o/ePQmEVL3lu+Gj465P6XJ6k0PQo6GcEFcOKoP/
ro9XXYfCkNRddrRA4e9mpWyYGhGwbjeZzjASEtJ9B8mfXjMda/f98dGCNzrSWYQ2
QoaQ9j4HbfDEraxaPYMbyQZaqR4frsMFH0lf0y9Cyjw0zHYcTROvVM2Zn/1W65m0
ekkK9X46pZsB61qPbOHhs+8IB0YBsf7B/T7AQZRxWRhHLqp6ziUMVqD0N77kZs6D
u8eTaJMxLaE9mvEBbBdPL1fiDuqKJ5yyplPWswv7+CCUnFYDpXRybYE/xBSX3+RQ
bopDEGzVU/+iwu5U1ggkRvqaMuOpUSb2WEfTpI7X4ii2d4RZH5o=
=4h++
-----END PGP SIGNATURE-----

--=-m9cJ5dvj55slR763He6R--

