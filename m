Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B79D8A7126
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 18:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729873AbfICQ4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 12:56:30 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14246 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728864AbfICQ43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 12:56:29 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x83GsJJn110938;
        Tue, 3 Sep 2019 12:56:16 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ustn7bj4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Sep 2019 12:56:16 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x83GtdQO015415;
        Tue, 3 Sep 2019 16:56:15 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma05wdc.us.ibm.com with ESMTP id 2usa0m5gvw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Sep 2019 16:56:15 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x83GuFnf54657390
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 3 Sep 2019 16:56:15 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2CCCCAE05C;
        Tue,  3 Sep 2019 16:56:15 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B4E43AE060;
        Tue,  3 Sep 2019 16:56:12 +0000 (GMT)
Received: from LeoBras (unknown [9.80.220.79])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  3 Sep 2019 16:56:12 +0000 (GMT)
Message-ID: <a2f0d0b08a73d86e8a1f67c4eeea3be11614aada.camel@linux.ibm.com>
Subject: Re: [PATCH v4 1/2] netfilter: Terminate rule eval if protocol=IPv6
 and ipv6 module is disabled
From:   Leonardo Bras <leonardo@linux.ibm.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, FlorianWestphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>
Date:   Tue, 03 Sep 2019 13:56:11 -0300
In-Reply-To: <20190903164948.kuvtpy7viqhcmp77@salvia>
References: <20190830181354.26279-1-leonardo@linux.ibm.com>
         <20190830181354.26279-2-leonardo@linux.ibm.com>
         <20190830205802.GS20113@breakpoint.cc>
         <99e3ef9c5ead1c95df697d49ab9cc83a95b0ac7c.camel@linux.ibm.com>
         <20190903164948.kuvtpy7viqhcmp77@salvia>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-sCCUtoKpTC9VzNlcdhEG"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-03_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1909030172
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-sCCUtoKpTC9VzNlcdhEG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2019-09-03 at 18:49 +0200, Pablo Neira Ayuso wrote:
> On Tue, Sep 03, 2019 at 01:46:50PM -0300, Leonardo Bras wrote:
> > On Fri, 2019-08-30 at 22:58 +0200, Florian Westphal wrote:
> > Hello Pablo,
> >=20
> > Any trouble with this patch?=20
> > I could see the other* one got applied, but not this one.
> > *(The other did not get acked, so i released it alone as v5)
> >=20
> > Is there any fix I need to do in this one?
>=20
> Hm, I see, so this one:
>=20
> https://patchwork.ozlabs.org/patch/1156100/
>=20
> is not enough?

By what I could understand of Florian e-mail, we would need both:

>> So, given I don't want to plaster ipv6_mod_enabled() everywhere, I
>> would suggest this course of action:
>>
>> 1. add a patch to BREAK in nft_fib_netdev.c for !ipv6_mod_enabled()
>> 2. change net/bridge/br_netfilter_hooks.c, br_nf_pre_routing() to
>>    make sure ipv6_mod_enabled() is true before doing the ipv6 stack
>>    "emulation".

Is that ok?

>=20
> I was expecting we could find a way to handle this from br_netfilter
> alone itself.
>=20
> Thanks.
Thank you!

--=-sCCUtoKpTC9VzNlcdhEG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEMdeUgIzgjf6YmUyOlQYWtz9SttQFAl1umysACgkQlQYWtz9S
ttSPAA/9GCXjQ8Us2+uyMm9QRIsc5twobC8qN1ce3/b24ZxQ9u5+agoyU3d4mMJD
CXH4Ws1wl7wzkByiZiDaJxzKj9yM4RjqyXHhquOG1qqbYq6f7077irnslJTYySEs
yIXs/MQMEB2mF9ZRXRdwSvNJSyyR52EwZbMSY7xHKW3Z/l25gNbjgJLMy3Dbu7jr
k0/36+iPPXSVp+08LMtxuysM3Rwji4fRftdPuEq7ardu+7GQOaim6oSZ0s9pzw5O
jEsSjEjmP+kVc6HCFlyA0eDD9zInjmjLRsHizbSISx+My9obHy1OnburEd846z/y
UNaQd269+0eFmRXZuQun+Myrs5GgUBt9DvGLcEKm7AXN3bgaHv2+w/k3GDr/OWCp
7fsDHLkJdPuPc4mUFG3u5KhKWRHMkTURI14OuZGC9NO83lIi412imaZLSEkWVpL2
MX9DJhbE/daNz3DhAMq3mEf6cyMGARUWU+oeJY80pjbrrsQKPEsV5KjxJLRNRZxz
UBp+C5I3ASMS2gzjswwHUMJX4iV5zJDmEiaID1ftgcZlPeuoxBgVGTeF2Rp9gcts
XHVl6hort3xwRx7hf1N83wmakhyV/wYEFVGmorzJu2Y4+5OJkk/+CoNv9pQwljvJ
tL2K8VjDhxp6dkQK7dGmflb95qMfeQN1kXimC84IcKA3wFc1SCk=
=IFln
-----END PGP SIGNATURE-----

--=-sCCUtoKpTC9VzNlcdhEG--

