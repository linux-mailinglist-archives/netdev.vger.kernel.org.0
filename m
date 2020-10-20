Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE59729446E
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 23:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409804AbgJTVSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 17:18:10 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:3236 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2409799AbgJTVSJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 17:18:09 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09KL2AIR033890;
        Tue, 20 Oct 2020 17:18:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to; s=pp1;
 bh=H5g8PgFpfSuSqhVaa/qYOA87sGXtBj3AvmAG1jZzyh4=;
 b=Igebvb64lQToz2eHzCQYb8BFas8FDp6yqUqbnXDJxux0eQMtB96t0u5eNdRxqizeKjIp
 94hNqjdNV77mxyT9tsZpKHwSgG6Eam/5Q1V98/mZ6VDH1LtesGCDgMB4ztjkWFEUezMZ
 bsTuwCN2Ol0R/n8uPNd8frFobKCeiNlk2gvDjcfx3vXG1zc6Aq8l42uXxSNQhR2x+ME7
 CF2bI95m4ckx/jwXjy6iQnSyswSB7SEpKtFiwdmgRz3Pa8teROswj8gngrRuNUKCRemA
 7i3LIf4UMT4KW51ChtpE+J3aTB2PqqowzDsQgzaqbcTVgC3HGGu2SkmPUQQpiqqKcVxH Ow== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34a6qq9kg4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Oct 2020 17:18:07 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09KLC9vd022258;
        Tue, 20 Oct 2020 21:18:06 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma02dal.us.ibm.com with ESMTP id 347r899sda-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Oct 2020 21:18:06 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09KLI5EK13435788
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Oct 2020 21:18:05 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A212C2805C;
        Tue, 20 Oct 2020 21:18:05 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5F4662805E;
        Tue, 20 Oct 2020 21:18:05 +0000 (GMT)
Received: from [9.85.179.149] (unknown [9.85.179.149])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTPS;
        Tue, 20 Oct 2020 21:18:05 +0000 (GMT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH net] ibmvnic: save changed mac address to
 adapter->mac_addr
From:   Lijun Pan <ljp@linux.vnet.ibm.com>
In-Reply-To: <20201019171152.6592e0c7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Tue, 20 Oct 2020 16:18:04 -0500
Cc:     Lijun Pan <ljp@linux.ibm.com>, netdev@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <456A40F4-7C46-4147-A22E-8B09209FD13A@linux.vnet.ibm.com>
References: <20201016045715.26768-1-ljp@linux.ibm.com>
 <20201019171152.6592e0c7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
To:     Jakub Kicinski <kuba@kernel.org>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-20_12:2020-10-20,2020-10-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 mlxlogscore=727 lowpriorityscore=0 malwarescore=0 priorityscore=1501
 clxscore=1011 spamscore=0 mlxscore=0 suspectscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010200139
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Oct 19, 2020, at 7:11 PM, Jakub Kicinski <kuba@kernel.org> wrote:
>=20
> On Thu, 15 Oct 2020 23:57:15 -0500 Lijun Pan wrote:
>> After mac address change request completes successfully, the new mac
>> address need to be saved to adapter->mac_addr as well as
>> netdev->dev_addr. Otherwise, adapter->mac_addr still holds old
>> data.
>=20
> Do you observe this in practice? Can you show us which path in
> particular you see this happen on?
>=20
> AFAICS ibmvnic_set_mac() copies the new MAC addr into =
adapter->mac_addr
> before making a request.
>=20
> If anything is wrong here is that it does so regardless if MAC addr=20
> is valid.
>=20

Yes, I ran some internal test to check the mac address in =
adapter->mac_addr, and
it is the old data. If you run ifconfig command to change mac addr, the =
netdev->dev_addr
is changed afterwards, and if you run ifocnfig again, it will show the =
new mac addr. However,
since we did not check adapter->mac_addr in this use case, this bug was =
not exposed.

This vnic driver is little bit different than other physical NIC driver. =
All the control paths
are negotaited with VIOS server, and data paths are through DMA mapping.

__ibmvnic_set_mac copies the new mac addr to crq by
	ether_addr_copy(&crq.change_mac_addr.mac_addr[0], dev_addr);
and then send the change request by
	rc =3D ibmvnic_send_crq(adapter, &crq);
Now adapter->mac_addr still has the old data.

When the request is handled by VIOS server, an interrupt is triggered, =
and=20
handle_change_mac_rsp is called.=20
Now it is time to copy the new mac to netdev->dev_addr, and =
adatper->mac_addr.
	ether_addr_copy(netdev->dev_addr,
			&crq->change_mac_addr_rsp.mac_addr[0]);
It missed the copy for adapter->mac_addr, which is what I add in this =
patch.
+	ether_addr_copy(adapter->mac_addr,
+			&crq->change_mac_addr_rsp.mac_addr[0]);

>> Fixes: 62740e97881c("net/ibmvnic: Update MAC address settings after =
adapter reset")
>                     ^
>                      missing space here=20
>=20

Will fix this in v2.

Lijun

