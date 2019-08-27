Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49F289F2C1
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 20:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730652AbfH0S4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 14:56:25 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36416 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728312AbfH0S4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 14:56:24 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7RIb9oS084097;
        Tue, 27 Aug 2019 14:55:46 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2un8kkcjgr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Aug 2019 14:55:46 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x7RItYvC022964;
        Tue, 27 Aug 2019 18:55:45 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma05wdc.us.ibm.com with ESMTP id 2ujvv71b32-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Aug 2019 18:55:45 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7RItiq747972670
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Aug 2019 18:55:44 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 87A72112063;
        Tue, 27 Aug 2019 18:55:44 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 082D7112062;
        Tue, 27 Aug 2019 18:55:43 +0000 (GMT)
Received: from leobras.br.ibm.com (unknown [9.18.235.216])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 27 Aug 2019 18:55:42 +0000 (GMT)
Message-ID: <0c563d05f6615d5cb32716f62416a5496ad197d4.camel@linux.ibm.com>
Subject: Re: [PATCH v2 1/1] netfilter: nf_tables: fib: Drop IPV6 packages if
 IPv6 is disabled on boot
From:   Leonardo Bras <leonardo@linux.ibm.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Date:   Tue, 27 Aug 2019 15:55:39 -0300
In-Reply-To: <20190827185111.cgutfqkqwsufe2nl@salvia>
References: <20190821141505.2394-1-leonardo@linux.ibm.com>
         <20190827103541.vzwqwg4jlbuzajxu@salvia>
         <77c43754ff72e9a2e8048ccd032351cf0186080a.camel@linux.ibm.com>
         <20190827185111.cgutfqkqwsufe2nl@salvia>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-bC3QiacUuz+PrqDXq2+v"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-27_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908270179
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-bC3QiacUuz+PrqDXq2+v
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2019-08-27 at 20:51 +0200, Pablo Neira Ayuso wrote:
> > > The drop case at the bottom of the fib eval function never actually
> > > never happens.
> >=20
> > Which one do you mean?
>=20
> Line 31 of net/netfilter/nft_fib_inet.c.
Oh, yeah, I was thinking about that when I wrote the patch.
Thanks for explaining :)

I will send the v3 in a few minutes.

Best regards,

--=-bC3QiacUuz+PrqDXq2+v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEMdeUgIzgjf6YmUyOlQYWtz9SttQFAl1lfKsACgkQlQYWtz9S
ttRjNxAArsbMmS4pe2EfMQGGOr2krvP+GCUcOCHZA32WFNQUme+NlnKmkERtMUgt
OmI+FZv3Q2W8l+dZR1sOxk8uaoyhh8ny9g4rK/qypga5NaXIId0U1RYnGKJadFqp
lWJLHtfHGXG0ljzPtpdKzvCtMnAMm6PIEs6yGGblfIciRBhI5ldxUEcD5AzHhXdj
yT7wNPyk+uq1LJ2QFs1doP2stuIMjXnBngKOb8us180KlEsAtvLCrIl3Hu4zrvF8
2Ogu8PqmCf8BfogE0maGCUz8rwRMs+o+YyQP82Ra8XLjiKm3uvvAn0rKh08BGDsA
PEcr0VZvrgT8PnbxLI6fwplERJgtSw2WO6SFMGr4v5ETCz2+nppsc1mAv18wvdK8
GNYpSuEeG/qGAtOWmWyDqxxEsfqA83oHHilnB3stAJEYKFClB0eBDmO9cQKaHu83
3eC5df7hl9GfIQLjo2MjeusSQt3tJfQ9fcdv8qLX7DZAw1/t/yjrg0a7DGt6VBx2
Uauhkh3Rlzz8mNji9WLEZfsh6Lm0aO0/g1gYMfM4hJ0V43KKZ2SVqzif1WBo1RcL
Z31Fi2ROWihgs4RZYUKFofwG/dte+n26Pol5bIOOy84sHw1I+3E8HV0H1bmZqXqW
zzHpx5gsHVyJ/Gn712FM8bgrFxxmEL/yJ3hXzhDclPUr2iHDpr8=
=G0DM
-----END PGP SIGNATURE-----

--=-bC3QiacUuz+PrqDXq2+v--

