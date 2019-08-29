Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D86E5A27A6
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 22:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbfH2UEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 16:04:51 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21970 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726512AbfH2UEv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 16:04:51 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7TK233X040496;
        Thu, 29 Aug 2019 16:04:10 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2upna189g9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Aug 2019 16:04:10 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x7TK3CUI024417;
        Thu, 29 Aug 2019 20:04:09 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma02wdc.us.ibm.com with ESMTP id 2ujvv6xcru-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Aug 2019 20:04:09 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7TK49RY51642816
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 20:04:09 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 564A2112062;
        Thu, 29 Aug 2019 20:04:09 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE290112061;
        Thu, 29 Aug 2019 20:04:07 +0000 (GMT)
Received: from leobras.br.ibm.com (unknown [9.18.235.111])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 29 Aug 2019 20:04:07 +0000 (GMT)
Message-ID: <db0f02c5b1a995fde174f036540a3d11008cf116.camel@linux.ibm.com>
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
Date:   Thu, 29 Aug 2019 17:04:03 -0300
In-Reply-To: <20190821141505.2394-1-leonardo@linux.ibm.com>
References: <20190821141505.2394-1-leonardo@linux.ibm.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-FHDAs17k+gbMZaWPCpYr"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-29_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=845 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908290200
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-FHDAs17k+gbMZaWPCpYr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> Thats a good point -- Leonardo, is the
> "net.bridge.bridge-nf-call-ip6tables" sysctl on?

Running
# sudo sysctl -a
I can see:
net.bridge.bridge-nf-call-ip6tables =3D 1
=20
So this packets are sent to host iptables for processing?


(Sorry for the delay, I did not received the previous e-mails.
Please include me in to/cc.)

--=-FHDAs17k+gbMZaWPCpYr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEMdeUgIzgjf6YmUyOlQYWtz9SttQFAl1oL7MACgkQlQYWtz9S
ttSUbA/5AUisorNqlRZnWcdh7AysMoIkbIMEP9J2EMxnJap4lGlqu2SG/C1SSRFK
zOkU8AeQWHoGIwktUdJGxaux1os6s9mY3NQNmwKeQvr6Hc2IjmUfwjxNiDJMHvyE
oSH5BuAmP8o/DDDRDmH1MHDJVdmBabmnegjxip+II14jj+gOZ9XzyMeNmBIozaYv
y9puT0TSpYkR0QiwJ4BKOi2/zPlT1wuvDMdK66ywakTwzqNPVgA89X4e8c3EwBcM
TjBArAtxAD1P7sm8bN00s/Tm7i1E+DTO2McHwUJdpoFbH0K4UTUxjvkhgE5LhFXH
2aHGIErLQrTiCX7xmqMPNO3/fVC67Y1TW+AOhKWLZaYtwS82WncSzeRMsnOr0TaH
UqVsqqZS2H56G5kBRypF5iKvf5dMLDPmWiHru7YVupMEb5oKJaofvy0HPUQ5FLam
6tMT+xC0DUUFyZkc1t+KCxyZr/zD8yxGck7qOQJqsJn0uM3sQZ54W31iYgpr/q0H
TUoxRZJS9J/rpoJyryVmE7V2tWJmpyP7sMvcNbu6o8odvrRvzjCZXKXN7r6r5ghG
iTNe70wJMeHrgamx95Xbj3LAXRD7HNAVrIxh0S3nWo5Cc76ByOk3IN0SBTMpxt5G
D0nlzyVzNorW76LvMIEfxMECpG5KtTC7OInYlnZue0zLblJR9ZU=
=Idus
-----END PGP SIGNATURE-----

--=-FHDAs17k+gbMZaWPCpYr--

