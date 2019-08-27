Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61AC59F1BA
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 19:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730417AbfH0Rg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 13:36:27 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4390 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727057AbfH0Rg0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 13:36:26 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7RHZW1p010983;
        Tue, 27 Aug 2019 13:35:49 -0400
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2un6kdxwhn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Aug 2019 13:35:48 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x7RHTj3G024387;
        Tue, 27 Aug 2019 17:34:18 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma04wdc.us.ibm.com with ESMTP id 2ujvv6gynf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Aug 2019 17:34:18 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7RHYHin57999844
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Aug 2019 17:34:17 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7794D7805C;
        Tue, 27 Aug 2019 17:34:17 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F5807805E;
        Tue, 27 Aug 2019 17:34:15 +0000 (GMT)
Received: from leobras.br.ibm.com (unknown [9.18.235.216])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 27 Aug 2019 17:34:15 +0000 (GMT)
Message-ID: <77c43754ff72e9a2e8048ccd032351cf0186080a.camel@linux.ibm.com>
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
Date:   Tue, 27 Aug 2019 14:34:14 -0300
In-Reply-To: <20190827103541.vzwqwg4jlbuzajxu@salvia>
References: <20190821141505.2394-1-leonardo@linux.ibm.com>
         <20190827103541.vzwqwg4jlbuzajxu@salvia>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-cNCIg1ywiNXBjGc4Cw+F"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-27_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908270168
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-cNCIg1ywiNXBjGc4Cw+F
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2019-08-27 at 12:35 +0200, Pablo Neira Ayuso wrote:
> On Wed, Aug 21, 2019 at 11:15:06AM -0300, Leonardo Bras wrote:
> > If IPv6 is disabled on boot (ipv6.disable=3D1), but nft_fib_inet ends u=
p
> > dealing with a IPv6 package, it causes a kernel panic in
> > fib6_node_lookup_1(), crashing in bad_page_fault.
>=20
> Q: How do you get to see IPv6 packets if IPv6 module is disable?
I could reproduce this bug on a host ('ipv6.disable=3D1') starting a
guest with a virtio-net interface with 'filterref' over a virtual
bridge. It crashes the host during guest boot (just before login).

By that I could understand that a guest IPv6 network traffic (viavirtio-net=
) may cause this kernel panic.=20

>=20
> > The panic is caused by trying to deference a very low address (0x38
> > in ppc64le), due to ipv6.fib6_main_tbl =3D NULL.
> > BUG: Kernel NULL pointer dereference at 0x00000038
> >=20
> > Fix this behavior by dropping IPv6 packages if !ipv6_mod_enabled().
>=20
> I'd suggest: s/package/packet/
Sure, I will make sure to put it on v3.
(Sorry, I am not very used to net subsystem.)
>=20
> [...]
> > diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft=
_fib_ipv6.c
> > index 7ece86afd079..75acc417e2ff 100644
> > --- a/net/ipv6/netfilter/nft_fib_ipv6.c
> > +++ b/net/ipv6/netfilter/nft_fib_ipv6.c
> > @@ -125,6 +125,11 @@ void nft_fib6_eval_type(const struct nft_expr *exp=
r, struct nft_regs *regs,
> >  	u32 *dest =3D &regs->data[priv->dreg];
> >  	struct ipv6hdr *iph, _iph;
> > =20
> > +	if (!ipv6_mod_enabled()) {
> > +		regs->verdict.code =3D NF_DROP;
>=20
> NFT_BREAK instead to stop evaluating this rule, this results in a
> mismatch, so you let the user decide what to do with packets that do
> not match your policy.
Ok, I will replace for v3.

>=20
> The drop case at the bottom of the fib eval function never actually
> never happens.
Which one do you mean?


--=-cNCIg1ywiNXBjGc4Cw+F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEMdeUgIzgjf6YmUyOlQYWtz9SttQFAl1laZYACgkQlQYWtz9S
ttQGCRAAhnjh/QWbYyASq5WgwLCyx11sioZdz7iKVUMRTLuMWnyyZbPBOdc7kAw+
TMDxCvi/O+caKgzOoW2ya3bqtHyI8lSEdbjrxfNBn6+AoxhXKBHBdHKrR6zUYE8J
+rM5AHcg2WZU58uyln0XdiXEmEeZEEq80AhKyYtZRpg8mGoMMo3fMo6zNGVfloBH
FmGGaohtVXS7BBuTTWZwXIR8fuYtAZKlSyxHrazZksz4PkZAsZWckpfTluy55vzS
kJBqfG91rkAkaUpuyrVv0hRYQNqWrFP441yutxOX6eWLYusxwHLzZWq1hlVYluiB
1UCUhIw1WWGP583Iz8YHJ993QRtbwJVDibmXUM39Cg3+kfh9h+vY8sGi96bGRn0h
NQDxUIXkGXBrAJQPON75Z0igM16rivks3AhHkL8M1HKMWDYJpEHaornjSLYpt0l5
Yngy+xTXDUdWH0dgoTweWkHIGL+mJ1g5FrJoSFP0pA/kZ17b/X7cRrnUV6E6jUnj
t6bKHLzY6JvCsiQLo/i9QNp6Eg4Y/cLk5AwRCotJcTupTL65Tp34r6fK0vBDVVoR
OTqV3jNinxK7BmHW8jGkXxdYJg0T3HcWg6FCqaTnmD9eruGTReSPxUF02QAe+3gk
iY67EsxcWu6ThPhqePMtyssRz8YOQeXBe0kUjRNKw0pCCFdomlQ=
=26Ah
-----END PGP SIGNATURE-----

--=-cNCIg1ywiNXBjGc4Cw+F--

