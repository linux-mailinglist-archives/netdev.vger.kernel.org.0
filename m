Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 494B729453C
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 00:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410355AbgJTWqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 18:46:47 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:63632 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731978AbgJTWqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 18:46:47 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09KMWp7B056469;
        Tue, 20 Oct 2020 18:46:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to; s=pp1;
 bh=4j7RmXFDeHc6tv5A7/5Tj3BXLVGBySASY90mifTTtU0=;
 b=Rjsh6MYIVOdXOOpVvmMY2Bm0ehGHv9zjduoPDSG9wN5WRvAanYYLcMoNM3vb3KV80ayq
 U1Utwdl0TZSkmfdNck4JGr70HhywaD6r+VAR97Dc6utefW1U9PFSUigFZ1apEVTecpGL
 itIgC0PjEx3umoqcKn2OIQOWR5ChObRUur9eXdzl+xGbTven0+lRubh2Lr/1GimHVDHb
 jiIIlnh+2c+Xe6qD2vlUvdpufuVbOKHjPlsmanN71G7KAehRVIvMD3jZQm41YrnHwf7Z
 jFZ8sN2XZyGm45PZb9th7dT/EydOSwcso50/9daMBB8RVlH3yxooDdSnKasarzcyb1Bj VA== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34a8d60rev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Oct 2020 18:46:45 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09KMcDQY010981;
        Tue, 20 Oct 2020 22:46:44 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma02dal.us.ibm.com with ESMTP id 347r89ab9d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Oct 2020 22:46:44 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09KMkhNV43909474
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Oct 2020 22:46:43 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9069F112066;
        Tue, 20 Oct 2020 22:46:43 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 50DCC112061;
        Tue, 20 Oct 2020 22:46:43 +0000 (GMT)
Received: from [9.85.179.149] (unknown [9.85.179.149])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTPS;
        Tue, 20 Oct 2020 22:46:43 +0000 (GMT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH net] ibmvnic: save changed mac address to
 adapter->mac_addr
From:   Lijun Pan <ljp@linux.vnet.ibm.com>
In-Reply-To: <20201020151913.3bfc8edb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Tue, 20 Oct 2020 17:46:42 -0500
Cc:     Lijun Pan <ljp@linux.ibm.com>, netdev@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <A630B1DF-A3DE-4E15-A7CA-63AF390E4CB9@linux.vnet.ibm.com>
References: <20201016045715.26768-1-ljp@linux.ibm.com>
 <20201019171152.6592e0c7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <456A40F4-7C46-4147-A22E-8B09209FD13A@linux.vnet.ibm.com>
 <20201020143352.04cee401@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <8AEE4003-FA15-4D69-9355-F15E1B737C0F@linux.vnet.ibm.com>
 <20201020151913.3bfc8edb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
To:     Jakub Kicinski <kuba@kernel.org>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-20_13:2020-10-20,2020-10-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 priorityscore=1501 malwarescore=0 adultscore=0 mlxlogscore=960
 lowpriorityscore=0 impostorscore=0 suspectscore=0 phishscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010200149
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Oct 20, 2020, at 5:19 PM, Jakub Kicinski <kuba@kernel.org> wrote:
>=20
> On Tue, 20 Oct 2020 17:07:38 -0500 Lijun Pan wrote:
>>> Please read my reply carefully.
>>>=20
>>> What's the call path that leads to the address being wrong? If you =
set
>>> the address via ifconfig it will call ibmvnic_set_mac() of the =
driver.
>>> ibmvnic_set_mac() does the copy.
>>>=20
>>> But it doesn't validate the address, which it should. =20
>>=20
>> Sorry about that. The mac addr validation is performed on vios side =
when it receives the
>> change request. That=E2=80=99s why there is no mac validation code in =
vnic driver.=20
>=20
> The problem is that there is validation in the driver:
>=20
> static int __ibmvnic_set_mac(struct net_device *netdev, u8 *dev_addr)
> {
> 	struct ibmvnic_adapter *adapter =3D netdev_priv(netdev);
> 	union ibmvnic_crq crq;
> 	int rc;
>=20
> 	if (!is_valid_ether_addr(dev_addr)) {
> 		rc =3D -EADDRNOTAVAIL;
> 		goto err;
> 	}
>=20

I think this one validates whether the address is of a legal format.
The validation in VIOS checks it according to the Address Control List
entries set up by the administrator.

> And ibmvnic_set_mac() does this:
>=20
> 	ether_addr_copy(adapter->mac_addr, addr->sa_data);
> 	if (adapter->state !=3D VNIC_PROBED)
> 		rc =3D __ibmvnic_set_mac(netdev, addr->sa_data);
>=20
> So if state =3D=3D VNIC_PROBED, the user can assign an invalid address =
to
> adapter->mac_addr, and ibmvnic_set_mac() will still return 0.

Let me address this problem, and send a separate patch.

>=20
> That's a separate issue, for a separate patch, though, so you can send=20=

> a v2 of this patch regardless.
>=20
>> In handle_change_mac_rsp(), &crq->change_mac_addr_rsp.mac_addr[0]
>> contains the current valid mac address, which may be different than =
the requested one,=20
>> that is &crq->change_mac_addr.mac_addr[0].
>> crq->change_mac_addr.mac_addr is the requested one.
>> crq->change_mac_addr_rsp.mac_addr is the returned valid one.
>>=20
>> Hope the above answers your doubt.
>=20
> Oh! The address in reply can be different than the requested one?
> Please add a comment stating that in the code.

I have sent v2 with comment in the code.

