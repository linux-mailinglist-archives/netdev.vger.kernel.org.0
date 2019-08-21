Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E771797C41
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 16:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729271AbfHUOOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 10:14:50 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:27084 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726484AbfHUOOu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 10:14:50 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7LECoba131355;
        Wed, 21 Aug 2019 10:14:40 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2uh7fr08cg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Aug 2019 10:14:40 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x7LEAVX1007263;
        Wed, 21 Aug 2019 14:14:39 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma02dal.us.ibm.com with ESMTP id 2ue976fabx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Aug 2019 14:14:39 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7LEEcG050725356
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Aug 2019 14:14:38 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B2627112066;
        Wed, 21 Aug 2019 14:14:38 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 37353112061;
        Wed, 21 Aug 2019 14:14:36 +0000 (GMT)
Received: from LeoBras (unknown [9.85.171.79])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 21 Aug 2019 14:14:35 +0000 (GMT)
Message-ID: <31b9320ccad0df9119cd9a14dbc8a4ad53e5a255.camel@linux.ibm.com>
Subject: Re: [PATCH 1/1] netfilter: nf_tables: fib: Drop IPV6 packages if
 IPv6 is disabled on boot
From:   Leonardo Bras <leonardo@linux.ibm.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>
Date:   Wed, 21 Aug 2019 11:14:31 -0300
In-Reply-To: <20190821095844.me6kscvnfruinseu@salvia>
References: <20190820005821.2644-1-leonardo@linux.ibm.com>
         <20190820053607.GL2588@breakpoint.cc>
         <793ce2e9b6200a033d44716749acc837aaf5e4e7.camel@linux.ibm.com>
         <20190821095844.me6kscvnfruinseu@salvia>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-bdwFVMrF2Fdp/po9EBbe"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-21_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908210156
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-bdwFVMrF2Fdp/po9EBbe
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2019-08-21 at 11:58 +0200, Pablo Neira Ayuso wrote:
> On Tue, Aug 20, 2019 at 01:15:58PM -0300, Leonardo Bras wrote:
> > On Tue, 2019-08-20 at 07:36 +0200, Florian Westphal wrote:
> > > Wouldn't fib_netdev.c have the same problem?
> > Probably, but I haven't hit this issue yet.
> >=20
> > > If so, might be better to place this test in both
> > > nft_fib6_eval_type and nft_fib6_eval.
> >=20
> > I think that is possible, and not very hard to do.
> >=20
> > But in my humble viewpoint, it looks like it's nft_fib_inet_eval() and
> > nft_fib_netdev_eval() have the responsibility to choose a valid
> > protocol or drop the package.=20
> > I am not sure if it would be a good move to transfer this
> > responsibility to nft_fib6_eval_type() and nft_fib6_eval(), so I would
> > rather add the same test to nft_fib_netdev_eval().
> >=20
> > Does it make sense?
>=20
> Please, update common code to netdev and ip6 extensions as Florian
> suggests.
>=20
> Thanks.

Ok then, I will send a v2 with that change.

Thanks,

--=-bdwFVMrF2Fdp/po9EBbe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEMdeUgIzgjf6YmUyOlQYWtz9SttQFAl1dUccACgkQlQYWtz9S
ttTvbxAAuqtgCz71kpVB4SpD7Z6y7shLthssFi4Ilnhr3fsG3CsvZ6PwjTWih8r6
fHcBXT+vu5Xydu+U/Ped9nJi6Ans7qslneoEf/yGINNwcfaK+SoOIE8AvXWXkNmp
TY41CZ+n2on93yo0lFt2daPaEssuXtvjY2H2hTdHdEaU+Cwaiji2ecxf5P1uTxRM
kW6rXl4vYWumQ9xjwn8Dg1ilHU86ipRwGnkU8V2fgOMOhdt3p/BfxxeEoYwhHY6Q
nmteFoZ6lhHtTGblz9bGrM4hbx9Q/9Lmup2hsBZA/YVeWtPVDd04ZhOpcbh4VFXg
a8H4a+VPh5y9+GUD5EyhnwkTfQMmmL+E+vU40m3Mw9w7cnPbfUlsgN7lHcckpy/r
5Wjcc/s4ESJxKDFu0gV8tJ7vlOfxo+z5tJj2+WtPn8g8X+Tktew/MSfSsM7X6gi3
3L7iH+XAchrvoVns8E4Q8V0dg+oIhPW118HuNgHFyfVoBaKhgIvEnQDf2H9s2j/k
Ng86g8LSWbUEQBXmq8THSEZagY2Q8Ec2q/B3TF4B8tGk6yNsOMM1rjSAeqDGkqIZ
bZGj4FhVePOvtMNpU8ACzWVWSaUSoJFiWrVQGprm0aAJukWH7m0QqKZEideDYf8h
nfmAmwVOTn1QUN1CsNSAGcq3X8UZbQPcRy1W/0h1y7z2HbZxkss=
=Jo9A
-----END PGP SIGNATURE-----

--=-bdwFVMrF2Fdp/po9EBbe--

