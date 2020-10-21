Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 270772946E3
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 05:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411619AbgJUDRw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 23:17:52 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46458 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2406353AbgJUDRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 23:17:52 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09L31vce164289
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 23:17:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : subject : from : in-reply-to : date :
 content-transfer-encoding : message-id : references : to; s=pp1;
 bh=BAzG9bcTSG9BbkEDTyUGNIlZ6aUmD+76q7CYuPlKS9g=;
 b=GWcLjj7MTpr/9udNLZ8jSEL0aM6QLBJjkUfGS9ba5ZUzPDIJHGAjThiHmPAbc+axuGfJ
 c+NVEJaLwLTQW9KyTqoj0SHkfuA1jbV7S4HQ2MURZwdDIwZ7n8NwthsBzeMbO9/uA9Vp
 vMeUE9oFB91ij6qcv4Ekwyc1GACpYYnd8iFVWtm12dwNl8sy/IuteF9GxNCtT6zNfFYW
 WAgYQ4WENTuFizeIgUH9OMvXzOftV39rN3vxLBV9NeJwf3Q9SxvhxOMQKNxbjMmAX1m6
 3CMxa316r7VlBO2AgKVfyQ+m5U5gmq+HV1SvOEAThqZ+GjeVuEXShVrreYA6BGbhbhL2 fQ== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34abtvsrgp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 23:17:50 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09L3DDwN020226
        for <netdev@vger.kernel.org>; Wed, 21 Oct 2020 03:17:50 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma05wdc.us.ibm.com with ESMTP id 347r88vw3h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 21 Oct 2020 03:17:50 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09L3Hiuo62718298
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Oct 2020 03:17:44 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1B954136055;
        Wed, 21 Oct 2020 03:17:49 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A4ABA13604F;
        Wed, 21 Oct 2020 03:17:48 +0000 (GMT)
Received: from [9.85.179.149] (unknown [9.85.179.149])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Wed, 21 Oct 2020 03:17:48 +0000 (GMT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH 1/1] powerpc/vnic: Extend "failover pending" window
From:   Lijun Pan <ljp@linux.vnet.ibm.com>
In-Reply-To: <20201021031430.1327927-1-sukadev@linux.ibm.com>
Date:   Tue, 20 Oct 2020 22:17:47 -0500
Content-Transfer-Encoding: quoted-printable
Message-Id: <277C3597-9527-4701-A0DA-55C8B159F251@linux.vnet.ibm.com>
References: <20201021031430.1327927-1-sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-21_02:2020-10-20,2020-10-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 mlxlogscore=999 clxscore=1015
 suspectscore=1 impostorscore=0 spamscore=0 mlxscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010210021
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Oct 20, 2020, at 10:14 PM, Sukadev Bhattiprolu =
<sukadev@linux.ibm.com> wrote:
>=20
> Commit 5a18e1e0c193b introduced the 'failover_pending' state to track
> the "failover pending window" - where we wait for the partner to =
become
> ready (after a transport event) before actually attempting to =
failover.
> i.e window is between following two events:
>=20
>        a. we get a transport event due to a FAILOVER
>=20
>        b. later, we get CRQ_INITIALIZED indicating the partner is
>           ready  at which point we schedule a FAILOVER reset.
>=20
> and ->failover_pending is true during this window.
>=20
> If during this window, we attempt to open (or close) a device, we =
pretend
> that the operation succeded and let the FAILOVER reset path complete =
the
> operation.
>=20
> This is fine, except if the transport event ("a" above) occurs during =
the
> open and after open has already checked whether a failover is pending. =
If
> that happens, we fail the open, which can cause the boot scripts to =
leave
> the interface down requiring administrator to manually bring up the =
device.
>=20
> This fix "extends" the failover pending window till we are _actually_
> ready to perform the failover reset (i.e until after we get the RTNL
> lock). Since open() holds the RTNL lock, we can be sure that we either
> finish the open or if the open() fails due to the failover pending =
window,
> we can again pretend that open is done and let the failover complete =
it.
>=20
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
> ---
> Changelog [v2]:
> 	[Brian King] Ensure we clear failover_pending during hard reset
> ---
> drivers/net/ethernet/ibm/ibmvnic.c | 36 ++++++++++++++++++++++++++----
> 1 file changed, 32 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c =
b/drivers/net/ethernet/ibm/ibmvnic.c
> index 1b702a43a5d0..2a0f6f6820db 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -1197,18 +1197,27 @@ static int ibmvnic_open(struct net_device =
*netdev)
> 	if (adapter->state !=3D VNIC_CLOSED) {
> 		rc =3D ibmvnic_login(netdev);
> 		if (rc)
> -			return rc;
> +			goto out;
>=20
> 		rc =3D init_resources(adapter);
> 		if (rc) {
> 			netdev_err(netdev, "failed to initialize =
resources\n");
> 			release_resources(adapter);
> -			return rc;
> +			goto out;
> 		}
> 	}
>=20
> 	rc =3D __ibmvnic_open(netdev);
>=20
> +out:
> +	/*
> +	 * If open fails due to a pending failover, set device state and
> +	 * return. Device operation will be handled by reset routine.
> +	 */
> +	if (rc && adapter->failover_pending) {
> +		adapter->state =3D VNIC_OPEN;
> +		rc =3D 0;
> +	}
> 	return rc;
> }
>=20
> @@ -1931,6 +1940,13 @@ static int do_reset(struct ibmvnic_adapter =
*adapter,
> 		   rwi->reset_reason);
>=20
> 	rtnl_lock();
> +	/*
> +	 * Now that we have the rtnl lock, clear any pending failover.
> +	 * This will ensure ibmvnic_open() has either completed or will
> +	 * block until failover is complete.
> +	 */
> +	if (rwi->reset_reason =3D=3D VNIC_RESET_FAILOVER)
> +		adapter->failover_pending =3D false;
>=20
> 	netif_carrier_off(netdev);
> 	adapter->reset_reason =3D rwi->reset_reason;
> @@ -2211,6 +2227,13 @@ static void __ibmvnic_reset(struct work_struct =
*work)
> 			/* CHANGE_PARAM requestor holds rtnl_lock */
> 			rc =3D do_change_param_reset(adapter, rwi, =
reset_state);
> 		} else if (adapter->force_reset_recovery) {
> +			/*
> +			 * Since we are doing a hard reset now, clear =
the
> +			 * failover_pending flag so we don't ignore any
> +			 * future MOBILITY or other resets.
> +			 */
> +			adapter->failover_pending =3D false;
> +

I think it would be better to put above chunk of code to do_hard_reset()
like you do for do_reset(),  if you really want to extend the window =
this way.

Extending the window that long may cause some resets being
skipped in some scenarios though I don=E2=80=99t know yet.
We have already seen the migration reset being skipped in some cases.

So my point is extending the window is kind of risky, and do we have an
alternative to address the "open=E2=80=9D problem you want to solve =
originally?
For example, would it be a viable approach to only change the code in
ibmvnic_open() or __ibmvnic_open(), but not extend this window?

> 			/* Transport event occurred during previous =
reset */
> 			if (adapter->wait_for_reset) {
> 				/* Previous was CHANGE_PARAM; caller =
locked */
> @@ -2275,9 +2298,15 @@ static int ibmvnic_reset(struct ibmvnic_adapter =
*adapter,
> 	unsigned long flags;
> 	int ret;
>=20
> +	/*
> +	 * If failover is pending don't schedule any other reset.
> +	 * Instead let the failover complete. If there is already a
> +	 * a failover reset scheduled, we will detect and drop the
> +	 * duplicate reset when walking the ->rwi_list below.
> +	 */
> 	if (adapter->state =3D=3D VNIC_REMOVING ||
> 	    adapter->state =3D=3D VNIC_REMOVED ||
> -	    adapter->failover_pending) {
> +	    (adapter->failover_pending && reason !=3D =
VNIC_RESET_FAILOVER)) {
> 		ret =3D EBUSY;
> 		netdev_dbg(netdev, "Adapter removing or pending =
failover, skipping reset\n");
> 		goto err;
> @@ -4653,7 +4682,6 @@ static void ibmvnic_handle_crq(union ibmvnic_crq =
*crq,
> 		case IBMVNIC_CRQ_INIT:
> 			dev_info(dev, "Partner initialized\n");
> 			adapter->from_passive_init =3D true;
> -			adapter->failover_pending =3D false;
> 			if (!completion_done(&adapter->init_done)) {
> 				complete(&adapter->init_done);
> 				adapter->init_done_rc =3D -EIO;
> --=20
> 2.25.4
>=20

