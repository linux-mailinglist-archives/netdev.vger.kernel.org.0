Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 202B09D472
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 18:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733285AbfHZQtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 12:49:02 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51806 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731578AbfHZQtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 12:49:02 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7QGmeAO135983;
        Mon, 26 Aug 2019 12:48:50 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2umk1urg8g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Aug 2019 12:48:42 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x7QGerhX005922;
        Mon, 26 Aug 2019 16:48:04 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma02wdc.us.ibm.com with ESMTP id 2ujvv6dxfn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Aug 2019 16:48:04 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7QGm3Sn25952690
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 16:48:03 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 850F0AC062;
        Mon, 26 Aug 2019 16:48:03 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 63E62AC060;
        Mon, 26 Aug 2019 16:48:01 +0000 (GMT)
Received: from LeoBras (unknown [9.85.146.55])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 26 Aug 2019 16:48:01 +0000 (GMT)
Message-ID: <e2cf315d21394ca2c994a2499d9816cd4922197d.camel@linux.ibm.com>
Subject: Re: [PATCH 1/1] netfilter: nf_tables: fib: Drop IPV6 packages if
 IPv6 is disabled on boot
From:   Leonardo Bras <leonardo@linux.ibm.com>
To:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>
Date:   Mon, 26 Aug 2019 13:47:55 -0300
In-Reply-To: <20190821095844.me6kscvnfruinseu@salvia>
References: <20190820005821.2644-1-leonardo@linux.ibm.com>
         <20190820053607.GL2588@breakpoint.cc>
         <793ce2e9b6200a033d44716749acc837aaf5e4e7.camel@linux.ibm.com>
         <20190821095844.me6kscvnfruinseu@salvia>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-zBDRiKK8xztrGjRvBz3a"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-26_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908260164
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-zBDRiKK8xztrGjRvBz3a
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello Pablo, Florian,

I implemented a V2 of this patch with the changes you proposed.
Could you please give your feedback on that patch?
https://lkml.org/lkml/2019/8/21/527

Thanks!

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

--=-zBDRiKK8xztrGjRvBz3a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEMdeUgIzgjf6YmUyOlQYWtz9SttQFAl1kDTsACgkQlQYWtz9S
ttTuhA//cuSNReLpNT7MtnSrTh/NMHak2UJhClO5A5q6dWLRuhjag+AG0ik7S0MD
+PN4NFCymRxsrWjBuRPfxBiNskm7Xg+EA55ZSelxwHZhzMIUR/aEANqYBYj/YE+Q
fhOTXq88MRjYHSYycGoIUviGaLgEQx3wTfaK4aR7F5MfnaUuqqwz7Rnc6E9F740C
HcnbeoqakAY9SXsNke0NYjM+AnvV5FuGcU3Qcz26cZkRCBMS0QkvE2CR17EOq779
mmj+nvpdD5h3teEGAznG9yADdwkpgXRDEkg6JHVYSlMC69H9qcvMeXYPbTw4cOkV
bX4abUrC3pS3LupHMRB8BGKLn2PyZjZHE8xUmKSkC7BH3ZL5A47teNdH9725Geld
tVA+OIxmujQIU4vWgnQq96auj/ukO/QCzZgE4/7i5m5Sp5lN5IDasVgwTgXkSJQ9
5KPKGAul8xGiHaYkhjCJd7iZYuhtWq7oer9fF/AC8eTz4v45Kryg0lmmtb0hA4Oc
9LD9WaI+yg5vCh188b3hLS28jC/yktx/T+6+7lHJqI0jyCHp9vAMl6O5VxUfX/eZ
PmwQADsZKBzMAgwiuWdPVdogUzhua7pxfpuZ3VS519nPHSybGdiYw6iHYq04+x6E
i+9y/Zx57p3D03com/Bwurivkd2HnBB+KBbcbqPMDIB/k5cNTIM=
=hUXu
-----END PGP SIGNATURE-----

--=-zBDRiKK8xztrGjRvBz3a--

