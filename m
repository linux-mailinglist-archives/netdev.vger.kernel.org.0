Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B466275E1A
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 19:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgIWRBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 13:01:25 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53124 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726342AbgIWRBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 13:01:24 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08NGksl1087670
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 13:01:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=pp1;
 bh=+TYehS/U5KnfK/75L5CLi6uO12LO2sMIG7boTkh0bSw=;
 b=s6mApdVEfIAYlGAVC9oBXY0682MQjsAmyhWHbFEeuRiJPw4MceTkVQQrnMpsYzc3KVEA
 +3qxvk5dpgRzRwXRb+1niAhG6s4g6Wr2KQbgZR4eF8cuZNPkZgEdPXF1VSQyCELdBZ8D
 p3WN+MLtlXske4nugZFQxufR0WXtsF5XJ2rJXtOl2xisbbfJXCgOn78CsxVgdJ5FEbe0
 2vECghDTmmGjhdGiGusSX0HqiPWeD9OivMZ0g7zmkZzuZK4i1pbAI3rZ3LT96UbIgwLL
 iANC/9lxleWaxDQSCBGksXXf6WlJYH5SCr3y8AJK6VWmRUBpfEH21QJB3LNnZBMNd451 pg== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33ra6crcmy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 13:01:22 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08NGqi6W002931
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 17:01:21 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma02wdc.us.ibm.com with ESMTP id 33n9m99hq8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 17:01:21 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08NH1L2815204846
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Sep 2020 17:01:21 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 35B4328059;
        Wed, 23 Sep 2020 17:01:21 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0FF9F2805A;
        Wed, 23 Sep 2020 17:01:21 +0000 (GMT)
Received: from suka-w540.localdomain (unknown [9.85.181.197])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 23 Sep 2020 17:01:20 +0000 (GMT)
Received: by suka-w540.localdomain (Postfix, from userid 1000)
        id 3EA352E1194; Wed, 23 Sep 2020 10:01:18 -0700 (PDT)
Date:   Wed, 23 Sep 2020 10:01:18 -0700
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     Lijun Pan <ljp@linux.vnet.ibm.com>
Cc:     netdev@vger.kernel.org, drt@linux.ibm.com
Subject: Re: [PATCH 1/1] powerpc/vnic: Extend "failover pending" window
Message-ID: <20200923170118.GA273493@us.ibm.com>
References: <20200923045332.GA269687@us.ibm.com>
 <066E780A-93EB-498E-A6EC-9DDDFF1B461A@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <066E780A-93EB-498E-A6EC-9DDDFF1B461A@linux.vnet.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-23_12:2020-09-23,2020-09-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 phishscore=0
 adultscore=0 impostorscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230126
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lijun Pan [ljp@linux.vnet.ibm.com] wrote:
>=20
>=20
> > On Sep 22, 2020, at 11:53 PM, Sukadev Bhattiprolu <sukadev@linux.ibm.co=
m> wrote:
> >=20
> >=20
> > From 547fa5627b63102f3ef80edffff3a032d62c88c5 Mon Sep 17 00:00:00 2001
> > From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> > Date: Thu, 10 Sep 2020 11:18:41 -0700
> > Subject: [PATCH 1/1] powerpc/vnic: Extend "failover pending" window
> >=20
> > Commit 5a18e1e0c193b introduced the 'failover_pending' state to track
> > the "failover pending window" - where we wait for the partner to become
> > ready (after a transport event) before actually attempting to failover.
> > i.e window is between following two events:
> >=20
> >        a. we get a transport event due to a FAILOVER
> >=20
> >        b. later, we get CRQ_INITIALIZED indicating the partner is
> >           ready  at which point we schedule a FAILOVER reset.
> >=20
> > and ->failover_pending is true during this window.
> >=20
> > If during this window, we attempt to open (or close) a device, we prete=
nd
> > that the operation succeded and let the FAILOVER reset path complete the
> > operation.
> >=20
> > This is fine, except if the transport event ("a" above) occurs during t=
he
> > open and after open has already checked whether a failover is pending. =
If
> > that happens, we fail the open, which can cause the boot scripts to lea=
ve
> > the interface down requiring administrator to manually bring up the dev=
ice.
> >=20
> > This fix "extends" the failover pending window till we are _actually_
> > ready to perform the failover reset (i.e until after we get the RTNL
> > lock). Since open() holds the RTNL lock, we can be sure that we either
> > finish the open or if the open() fails due to the failover pending wind=
ow,
> > we can again pretend that open is done and let the failover complete it.
> >=20
> > Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
> > ---
> > drivers/net/ethernet/ibm/ibmvnic.c | 33 +++++++++++++++++++++++++-----
> > 1 file changed, 28 insertions(+), 5 deletions(-)
> >=20
> > diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/=
ibm/ibmvnic.c
> > index 1b702a43a5d0..cf75a649ed8b 100644
> > --- a/drivers/net/ethernet/ibm/ibmvnic.c
> > +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> > @@ -1197,18 +1197,29 @@ static int ibmvnic_open(struct net_device *netd=
ev)
> > 	if (adapter->state !=3D VNIC_CLOSED) {
> > 		rc =3D ibmvnic_login(netdev);
> > 		if (rc)
> > -			return rc;
> > +			goto out;
> >=20
> > 		rc =3D init_resources(adapter);
> > 		if (rc) {
> > -			netdev_err(netdev, "failed to initialize resources\n");
> > +			netdev_err(netdev,
> > +				"failed to initialize resources, failover %d\n",
> > +				adapter->failover_pending);
>=20
> Would =E2=80=9C..., failover_pending=3D%d\n=E2=80=9D be more explicit tha=
n "failover %d=E2=80=9D?

Sure.

>=20
> > 			release_resources(adapter);
> > -			return rc;
> > +			goto out;
> > 		}
> > 	}
> >=20
> > 	rc =3D __ibmvnic_open(netdev);
> >=20
> > +out:
> > +	/*
> > +	 * If open fails due to a pending failover, set device state and
> > +	 * return. Device operation will be handled by reset routine.
> > +	 */
> > +	if (rc && adapter->failover_pending) {
> > +		adapter->state =3D VNIC_OPEN;
> > +		rc =3D 0;
> > +	}
> > 	return rc;
> > }
> >=20
> > @@ -1931,6 +1942,13 @@ static int do_reset(struct ibmvnic_adapter *adap=
ter,
> > 		   rwi->reset_reason);
> >=20
> > 	rtnl_lock();
> > +	/*
> > +	 * Now that we have the rtnl lock, clear any pending failover.
> > +	 * This will ensure ibmvnic_open() has either completed or will
> > +	 * block until failover is complete.
> > +	 */
> > +	if (rwi->reset_reason =3D=3D VNIC_RESET_FAILOVER)
> > +		adapter->failover_pending =3D false;
>=20
> The window extends till here.
> And sometimes VNIC_RESET_FAILOVER case will call do_hard_reset
> instead of do_reset, depending on adapter->force_reset_recovery is true o=
r false.

If we encounter an error during failover we drop the lock, return error
and initiate a hard reset. At that point, failover is no longer pending so
its ok for failover_pending to be false?=20

Once the hard reset completes, the adapter should go back to the PROBED or
OPEN state. We still need to think about what happens to a concurrent open
if there is a hard reset in progress - probably ok to fail it, unlike in
this failover case?
>=20
> >=20
> > 	netif_carrier_off(netdev);
> > 	adapter->reset_reason =3D rwi->reset_reason;
> > @@ -2275,9 +2293,15 @@ static int ibmvnic_reset(struct ibmvnic_adapter =
*adapter,
> > 	unsigned long flags;
> > 	int ret;
> >=20
> > +	/*
> > +	 * If failover is pending don't schedule any other reset.
> > +	 * Instead let the failover complete. If there is already a
> > +	 * a failover reset scheduled, we will detect and drop the
> > +	 * duplicate reset when walking the ->rwi_list below.
> > +	 */
> > 	if (adapter->state =3D=3D VNIC_REMOVING ||
> > 	    adapter->state =3D=3D VNIC_REMOVED ||
> > -	    adapter->failover_pending) {
> > +	    (adapter->failover_pending && reason !=3D VNIC_RESET_FAILOVER)) {
>=20
> I don=E2=80=99t quite get =E2=80=9Creason !=3DVNIC_RESET_FAILOVER=E2=80=
=9D.
> Isn=E2=80=99t failover_pending to describe VNIC_RESET_FAILOVER only?=20
> Please list an example that failover_pending is true and reason is not VN=
IC_RESET_FAILOVER.

This function (ibmvnic_reset()) is queuing various reset requests for a
worker thread to handle later right? So, we could queue a failover reset
and before that is processed by the worker thread, we encounter another
reason to reset and come here. If we do, both existing and new code return
EBUSY.

Thanks for the questions and comments.

Sukadev
