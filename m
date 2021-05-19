Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF1C6388755
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 08:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243365AbhESGIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 02:08:16 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64784 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S238224AbhESGH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 02:07:56 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14J6500J122998;
        Wed, 19 May 2021 02:06:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to; s=pp1;
 bh=js7ywePFwqXDwb4F8ZByIydGgPy+pA3TkzRf4z26Io4=;
 b=B5ESKKe7aie35I1RgpHQ0/AYE6JTw4pB/iVxX6n3CxWmWJRYDNBA1jilRwn9hS7oeMPf
 BZagVanvHj2vH0Dxgh/YADIrtJnM3+yBJjCSSGMhUcQRz2jcHwXx8jkoHB+5yQisLZj2
 s7UoDpuCXbtyNklLH2Bv4NPD45GNNvMqtYHfyPZhCs4WN4qfYtNZp+3/N8uGvZXkYzpW
 uhsIVY1k+Hk4pyLyZCmyeCtSiCkJe3r/S41eeirXtQK/VbpnJ4WV/ezgzFky3ebw7evu
 KmdpGdyGQTCWbyQxzMsxhYVPVFOqn13TVj6XCCyJyWXrilObLyI7eqiuWDlKRl68gtmr vA== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38mvfa8w4x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 May 2021 02:06:31 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14J66U2A001832;
        Wed, 19 May 2021 06:06:30 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma03wdc.us.ibm.com with ESMTP id 38j5x9cqay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 May 2021 06:06:30 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14J66UGx28836226
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 May 2021 06:06:30 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 11B1B11206B;
        Wed, 19 May 2021 06:06:30 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9B63D112070;
        Wed, 19 May 2021 06:06:29 +0000 (GMT)
Received: from [9.65.90.43] (unknown [9.65.90.43])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTPS;
        Wed, 19 May 2021 06:06:29 +0000 (GMT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH 00/20] net: ethernet: remove leading spaces before tabs
From:   Lijun Pan <ljp@linux.vnet.ibm.com>
In-Reply-To: <1621402253-27200-1-git-send-email-tanghui20@huawei.com>
Date:   Wed, 19 May 2021 01:06:28 -0500
Cc:     David Miller <davem@davemloft.net>, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <7D679E0A-DEBE-4F84-945F-86E63F031754@linux.vnet.ibm.com>
References: <1621402253-27200-1-git-send-email-tanghui20@huawei.com>
To:     Hui Tang <tanghui20@huawei.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: FnFAETX3OWLBvJob2UGf4wFZF3Z7L3Ye
X-Proofpoint-ORIG-GUID: FnFAETX3OWLBvJob2UGf4wFZF3Z7L3Ye
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-19_02:2021-05-18,2021-05-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 mlxlogscore=820 mlxscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 clxscore=1015 spamscore=0 priorityscore=1501 lowpriorityscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105190047
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On May 19, 2021, at 12:30 AM, Hui Tang <tanghui20@huawei.com> wrote:
>=20
> There are a few leading spaces before tabs and remove it by running =
the
> following commard:
>=20
>        $ find . -name '*.c' | xargs sed -r -i 's/^[ ]+\t/\t/'
>        $ find . -name '*.h' | xargs sed -r -i 's/^[ ]+\t/\t/'
>=20
> Hui Tang (20):
>  net: 3com: remove leading spaces before tabs
>  net: alteon: remove leading spaces before tabs
>  net: amd: remove leading spaces before tabs
>  net: apple: remove leading spaces before tabs
>  net: broadcom: remove leading spaces before tabs
>  net: chelsio: remove leading spaces before tabs
>  net: dec: remove leading spaces before tabs
>  net: dlink: remove leading spaces before tabs
>  net: ibm: remove leading spaces before tabs
>  net: marvell: remove leading spaces before tabs
>  net: natsemi: remove leading spaces before tabs
>  net: realtek: remove leading spaces before tabs
>  net: seeq: remove leading spaces before tabs
>  net: sis: remove leading spaces before tabs
>  net: smsc: remove leading spaces before tabs
>  net: sun: remove leading spaces before tabs
>  net: fealnx: remove leading spaces before tabs
>  net: xircom: remove leading spaces before tabs
>  net: 8390: remove leading spaces before tabs
>  net: fujitsu: remove leading spaces before tabs
>=20
> drivers/net/ethernet/3com/3c59x.c            |  2 +-
> drivers/net/ethernet/8390/axnet_cs.c         | 14 +++++-----
> drivers/net/ethernet/8390/pcnet_cs.c         |  2 +-
> drivers/net/ethernet/8390/smc-ultra.c        |  6 ++--
> drivers/net/ethernet/8390/stnic.c            |  2 +-
> drivers/net/ethernet/alteon/acenic.c         | 26 ++++++++---------
> drivers/net/ethernet/amd/amd8111e.c          |  4 +--
> drivers/net/ethernet/amd/amd8111e.h          |  6 ++--
> drivers/net/ethernet/amd/atarilance.c        |  2 +-
> drivers/net/ethernet/amd/declance.c          |  2 +-
> drivers/net/ethernet/amd/lance.c             |  4 +--
> drivers/net/ethernet/amd/ni65.c              | 12 ++++----
> drivers/net/ethernet/amd/nmclan_cs.c         | 12 ++++----
> drivers/net/ethernet/amd/sun3lance.c         | 12 ++++----
> drivers/net/ethernet/apple/bmac.c            | 30 ++++++++++----------
> drivers/net/ethernet/apple/mace.c            |  8 +++---
> drivers/net/ethernet/broadcom/b44.c          | 20 ++++++-------
> drivers/net/ethernet/broadcom/bnx2.c         |  6 ++--
> drivers/net/ethernet/chelsio/cxgb3/sge.c     |  2 +-
> drivers/net/ethernet/dec/tulip/de2104x.c     |  4 +--
> drivers/net/ethernet/dec/tulip/de4x5.c       |  6 ++--
> drivers/net/ethernet/dec/tulip/dmfe.c        | 18 ++++++------
> drivers/net/ethernet/dec/tulip/pnic2.c       |  4 +--
> drivers/net/ethernet/dec/tulip/uli526x.c     | 10 +++----
> drivers/net/ethernet/dec/tulip/winbond-840.c |  4 +--
> drivers/net/ethernet/dlink/sundance.c        | 12 ++++----
> drivers/net/ethernet/fealnx.c                |  2 +-
> drivers/net/ethernet/fujitsu/fmvj18x_cs.c    |  6 ++--
> drivers/net/ethernet/ibm/emac/emac.h         |  2 +-
> drivers/net/ethernet/marvell/skge.h          |  2 +-
> drivers/net/ethernet/marvell/sky2.c          | 30 ++++++++++----------
> drivers/net/ethernet/marvell/sky2.h          |  8 +++---
> drivers/net/ethernet/natsemi/natsemi.c       |  6 ++--
> drivers/net/ethernet/realtek/8139cp.c        |  6 ++--
> drivers/net/ethernet/realtek/8139too.c       |  6 ++--
> drivers/net/ethernet/realtek/atp.c           |  4 +--
> drivers/net/ethernet/seeq/ether3.c           | 10 +++----
> drivers/net/ethernet/sis/sis900.c            | 22 +++++++--------
> drivers/net/ethernet/smsc/smc9194.c          | 42 =
++++++++++++++--------------
> drivers/net/ethernet/smsc/smc91x.c           | 14 +++++-----
> drivers/net/ethernet/sun/cassini.c           |  2 +-
> drivers/net/ethernet/sun/sungem.c            | 20 ++++++-------
> drivers/net/ethernet/sun/sunhme.c            |  6 ++--
> drivers/net/ethernet/xircom/xirc2ps_cs.c     |  2 +-
> 44 files changed, 210 insertions(+), 210 deletions(-)
>=20
> =E2=80=94

It should be targeting net-next, I believe.


