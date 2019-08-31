Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A725EA4246
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 06:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbfHaEmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 00:42:49 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61808 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725836AbfHaEms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Aug 2019 00:42:48 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7V4frRO042221;
        Sat, 31 Aug 2019 00:42:37 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2uq0ktq20w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 31 Aug 2019 00:42:36 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x7V4eRoF008866;
        Sat, 31 Aug 2019 04:42:35 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma04dal.us.ibm.com with ESMTP id 2uqgh60g3b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 31 Aug 2019 04:42:35 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7V4gY3X58261846
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 31 Aug 2019 04:42:34 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 790DD7805C;
        Sat, 31 Aug 2019 04:42:34 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC0357805E;
        Sat, 31 Aug 2019 04:42:31 +0000 (GMT)
Received: from LeoBras (unknown [9.80.210.156])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sat, 31 Aug 2019 04:42:31 +0000 (GMT)
Message-ID: <2ba876f9ad6597e640df68f09659dce3c4b5ce03.camel@linux.ibm.com>
Subject: Re: [PATCH v4 2/2] net: br_netfiler_hooks: Drops IPv6 packets if
 IPv6 module is not loaded
From:   Leonardo Bras <leonardo@linux.ibm.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>
Date:   Sat, 31 Aug 2019 01:42:29 -0300
In-Reply-To: <20190830205541.GR20113@breakpoint.cc>
References: <20190830181354.26279-1-leonardo@linux.ibm.com>
         <20190830181354.26279-3-leonardo@linux.ibm.com>
         <20190830205541.GR20113@breakpoint.cc>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-NmceabA7waNjtZ157fkz"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-31_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908310052
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-NmceabA7waNjtZ157fkz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2019-08-30 at 22:55 +0200, Florian Westphal wrote:
> Leonardo Bras <leonardo@linux.ibm.com> wrote:
> > A kernel panic can happen if a host has disabled IPv6 on boot and have =
to
> > process guest packets (coming from a bridge) using it's ip6tables.
> >=20
> > IPv6 packets need to be dropped if the IPv6 module is not loaded.
> >=20
> > Signed-off-by: Leonardo Bras <leonardo@linux.ibm.com>
> > ---
> >  net/bridge/br_netfilter_hooks.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >=20
> > diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_=
hooks.c
> > index d3f9592f4ff8..5e8693730df1 100644
> > --- a/net/bridge/br_netfilter_hooks.c
> > +++ b/net/bridge/br_netfilter_hooks.c
> > @@ -493,6 +493,8 @@ static unsigned int br_nf_pre_routing(void *priv,
> >  	brnet =3D net_generic(state->net, brnf_net_id);
> >  	if (IS_IPV6(skb) || is_vlan_ipv6(skb, state->net) ||
> >  	    is_pppoe_ipv6(skb, state->net)) {
> > +		if (!ipv6_mod_enabled())
> > +			return NF_DROP;
> >  		if (!brnet->call_ip6tables &&
> >  		    !br_opt_get(br, BROPT_NF_CALL_IP6TABLES))
> >  			return NF_ACCEPT;
>=20
> No, thats too aggressive and turns the bridge into an ipv6 blackhole.
>=20
> There are two solutions:
> 1. The above patch, but use NF_ACCEPT instead
> 2. keep the DROP, but move it below the call_ip6tables test,
>    so that users can tweak call-ip6tables to accept packets.

Q: Does 2 mean that it will only be dropped if bridge intents to use
host's ip6tables? Else, it will be accepted by previous if?

> Perhaps it would be good to also add a pr_warn_once() that
> tells that ipv6 was disabled on command line and
> call-ip6tables isn't supported in this configuration.
>=20
Good idea, added.

> I would go with option two.
I think it's better than 1 too.

I sent a v5 with these changes:
https://lkml.org/lkml/2019/8/31/4

Thanks!

Leonardo Bras

--=-NmceabA7waNjtZ157fkz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEMdeUgIzgjf6YmUyOlQYWtz9SttQFAl1p+rUACgkQlQYWtz9S
ttSbUxAAr5vWLsGmro0HQCOExyLhf5zWEHkHJXUbjLocdlp1f3FOsgmu5Wz8noQs
gbPstMKc4dGJDZ5kFiTlYT4rxDP4zms84JzRohrjWvM/W/quuAS063wMCqjbFq6r
F8HUhED6VGd3ViAeEASkwHMjgCdla9y5M9/V84GxBlQ+ZVt0hFqon8Q3Us0OLMoA
91TfahVL8FyhW2w6h5F/oCYG2oD+2KqGScCjoZ0tVyppJP9GUI63E7pEwodXsDHH
MW153XedTgyNnHl5CK9LBLX2lHXZi4O8cauVqXWnbDyvJl/VaRzCUAnNLSdjTM3X
SmXy+5iLTuxnpIAr9esXdXdFXaIV7FnMwXHvBIkXdT1KOVZcmJg5NnZaswjP4LAD
fJbNAKky0A56keHQ8bi7CqQ2+GmVK4wMyANAXaow2OynLvZbw/vhQzoqi5wjuP4p
Z+nHh2n2BTTjY1ZcJJLjMRi12DIZFLDYnqpu4vXEvmhp3PtlO5BCg0C+A1HWtSdq
0oVzl+MXOKhtZF5H7wwIV5wjC5Ij88TaDEatC1iYZE8AhADlDZ2foHCVoFZm2OGr
+ggS9vYmGiqw5zSHFQSqY6PVKdSPxg25Zoe+um2J0KCbVhldmEjBIJ1lXgeICPEx
AK8YyIJB14V5H3Ef4EveO77t3tYQon28WfOix1tSQ9+//XVUlVU=
=lpBD
-----END PGP SIGNATURE-----

--=-NmceabA7waNjtZ157fkz--

