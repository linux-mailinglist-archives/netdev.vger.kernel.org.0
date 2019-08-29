Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82A71A27FE
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 22:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728141AbfH2Uah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 16:30:37 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:62912 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726661AbfH2Uah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 16:30:37 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7TKShen146787;
        Thu, 29 Aug 2019 16:29:58 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2upjrupa29-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Aug 2019 16:29:58 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x7TKPKjn025392;
        Thu, 29 Aug 2019 20:29:56 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma01wdc.us.ibm.com with ESMTP id 2ujvv6pjca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Aug 2019 20:29:56 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7TKTvWX52166930
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 20:29:57 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0194BAE062;
        Thu, 29 Aug 2019 20:29:57 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 77A37AE05C;
        Thu, 29 Aug 2019 20:29:55 +0000 (GMT)
Received: from leobras.br.ibm.com (unknown [9.18.235.111])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 29 Aug 2019 20:29:55 +0000 (GMT)
Message-ID: <b6585989069fd832a65b73d1c4f4319a10714165.camel@linux.ibm.com>
Subject: Re: [PATCH v2 1/1] netfilter: nf_tables: fib: Drop IPV6 packages if
 IPv6 is disabled on boot
From:   Leonardo Bras <leonardo@linux.ibm.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Date:   Thu, 29 Aug 2019 17:29:51 -0300
In-Reply-To: <db0f02c5b1a995fde174f036540a3d11008cf116.camel@linux.ibm.com>
References: <20190821141505.2394-1-leonardo@linux.ibm.com>
         <db0f02c5b1a995fde174f036540a3d11008cf116.camel@linux.ibm.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-MdIb0HamTTXKEH8vz6zh"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-29_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=947 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908290205
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-MdIb0HamTTXKEH8vz6zh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2019-08-29 at 17:04 -0300, Leonardo Bras wrote:
> > Thats a good point -- Leonardo, is the
> > "net.bridge.bridge-nf-call-ip6tables" sysctl on?
>=20
> Running
> # sudo sysctl -a
> I can see:
> net.bridge.bridge-nf-call-ip6tables =3D 1

Also, doing
# echo 0 >  /proc/sys/net/bridge/bridge-nf-call-ip6tables=20
And then trying to boot the guest will not crash the host.

Which would make sense, since host iptables is not dealing with guest
IPv6 packets.

So, the real cause of this bug is the bridge making host ip6tables deal
with guest IPv6 packets ?=20
If so, would it be ok if write a patch testing ipv6_mod_enabled()
before passing guest ipv6 packets to host ip6tables?=20


Best regards,

> =20
> So this packets are sent to host iptables for processing?
>=20
>=20
> (Sorry for the delay, I did not received the previous e-mails.
> Please include me in to/cc.)

--=-MdIb0HamTTXKEH8vz6zh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEMdeUgIzgjf6YmUyOlQYWtz9SttQFAl1oNb8ACgkQlQYWtz9S
ttTJExAApXmGPloLN1N0hwKRPP49xzh1v8ik/VVU7a6G/PprKe45kT3bdkjoMLpJ
7T7yXMOH5yyUFOeXPnUpAYcKqjmS0y4gF/dtBMAM+2SRVwlTK5vDrKo+HtBOff0X
DZ6TF7Q8lRzPMWrQBuAbAIoDqwpt1eaGf+UjFXGU2CXDNbRv1sxTZzsbc1EkScwO
WFs/XbcZ2gLkz20i0btstEP7d8luGgEcvNG48i3BlgoczRWVacnkiWunAHsS39AQ
+Fq2Trw7N3gg1NVlZ8kOrGW+193ZdRswSbDnq7C3JUX/gcgzIo/flUV0AFwEXOqx
/7fM8I5gqVWbJBqpRMHKtsO/4HMpaqiLWZMtUwt/MZQQWsCZX8eDO5VjcaXR8EMy
MouFJMVi2R4rrJTOaq0d4klCk6YKYdlheBDq6ZzSF26BSd07gAywLODl9QyxnHiq
SCLzQ23KI4N98xZiL2SpajR4ZEn8yGpv6Mgxexk/BC3Dc4jZ0YVDznd83sKZHhFh
hP083MF6os74GEcRSpyYyOfqbZnvt7SwUEWxfCo1hyWp+Z/Ar+Z7GW0pmHJLXU6Z
PsWneKVq85kb8Zl1Uzg55/rKhopWU6RUV1YJn+RaZOn9Z41FJkcX2kUmY1We+x/N
y9xIJ4IRMrNfb06qZxkEbub5w8wvpid9CFyHjbdAzDIHapP2o1M=
=ueqQ
-----END PGP SIGNATURE-----

--=-MdIb0HamTTXKEH8vz6zh--

