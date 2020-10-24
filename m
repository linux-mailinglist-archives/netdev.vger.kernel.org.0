Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7622979D6
	for <lists+netdev@lfdr.de>; Sat, 24 Oct 2020 02:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1755860AbgJXAHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 20:07:40 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57446 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755837AbgJXAHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 20:07:40 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09O03bg0153279
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 20:07:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=pp1;
 bh=1LuGNAIxVTMkOXriFLpUCWBHgOyx8bfquukB1/8IAz4=;
 b=mdozspgp6em+1FCo987GVNEc5VUV1N1RgXFatKvx2M3XGYM/4pxexD0XUCjfS6Mfe+Xo
 bY/CZNY9bjtl2PM4WA0kNQQUZWU6F+Q5j+/2phWsSn1lKy4QlNfCLThmtLG65aKtzqlE
 hJ9piFhUpef/K3g7dGukvGGCCam+w8djMKmmVrqy0SABR08XuRllWLjARvsaXogZ0ZNR
 WC3bwfjRQ0KiFG1pGk30bqKloKx803rjpLotqAsnMr7Aik9FmzSBahsVA1yc5BPv/iJN
 1tm0T1IugPQuSWSVVbszFw7HYAZQznIXefxWpdKcei89Y1PCWKpdn9CTA/RSEkV3N6Vj yg== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34c04mqfh6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 20:07:38 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09O026KW025551
        for <netdev@vger.kernel.org>; Sat, 24 Oct 2020 00:02:38 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma04dal.us.ibm.com with ESMTP id 347r8a9cpw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 24 Oct 2020 00:02:37 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09O02bmN20971932
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Oct 2020 00:02:37 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1E091112062;
        Sat, 24 Oct 2020 00:02:37 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E296D112061;
        Sat, 24 Oct 2020 00:02:36 +0000 (GMT)
Received: from suka-w540.localdomain (unknown [9.85.171.35])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Sat, 24 Oct 2020 00:02:36 +0000 (GMT)
Received: by suka-w540.localdomain (Postfix, from userid 1000)
        id E88E72E0BEA; Fri, 23 Oct 2020 17:02:33 -0700 (PDT)
Date:   Fri, 23 Oct 2020 17:02:33 -0700
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     Lijun Pan <ljp@linux.vnet.ibm.com>
Cc:     netdev@vger.kernel.org, Dany Madden <drt@linux.vnet.ibm.com>,
        Lijun Pan <ljp@linux.ibm.com>
Subject: Re: [PATCH v2 1/1] powerpc/vnic: Extend "failover pending" window
Message-ID: <20201024000233.GC1411079@us.ibm.com>
References: <20201019195233.GA1282438@us.ibm.com>
 <FC9128E6-0E4A-476C-8A98-B04785385841@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <FC9128E6-0E4A-476C-8A98-B04785385841@linux.vnet.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-23_18:2020-10-23,2020-10-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 spamscore=0 mlxscore=0 suspectscore=1 mlxlogscore=999
 bulkscore=0 lowpriorityscore=0 clxscore=1015 malwarescore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010230149
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lijun Pan [ljp@linux.vnet.ibm.com] wrote:
>    On Oct 19, 2020, at 2:52 PM, Sukadev Bhattiprolu
>    <[1]sukadev@linux.ibm.com> wrote:
>=20
>    From 67f8977f636e462a1cd1eadb28edd98ef4f2b756 Mon Sep 17 00:00:00 2001
>    From: Sukadev Bhattiprolu <[2]sukadev@linux.vnet.ibm.com>
>    Date: Thu, 10 Sep 2020 11:18:41 -0700
>    Subject: [PATCH 1/1] powerpc/vnic: Extend "failover pending" window
>    Commit 5a18e1e0c193b introduced the 'failover_pending' state to track
>    the "failover pending window" - where we wait for the partner to become
>    ready (after a transport event) before actually attempting to failover.
>    i.e window is between following two events:
>           a. we get a transport event due to a FAILOVER
>           b. later, we get CRQ_INITIALIZED indicating the partner is
>              ready  at which point we schedule a FAILOVER reset.
>    and ->failover_pending is true during this window.
>    If during this window, we attempt to open (or close) a device, we
>    pretend
>    that the operation succeded and let the FAILOVER reset path complete
>    the
>    operation.
>    This is fine, except if the transport event ("a" above) occurs during
>    the
>    open and after open has already checked whether a failover is pending.
>    If
>    that happens, we fail the open, which can cause the boot scripts to
>    leave
>    the interface down requiring administrator to manually bring up the
>    device.
>    This fix "extends" the failover pending window till we are _actually_
>    ready to perform the failover reset (i.e until after we get the RTNL
>    lock). Since open() holds the RTNL lock, we can be sure that we either
>    finish the open or if the open() fails due to the failover pending
>    window,
>    we can again pretend that open is done and let the failover complete
>    it.
>    Signed-off-by: Sukadev Bhattiprolu <[3]sukadev@linux.ibm.com>
>    ---
>    Changelog [v2]:
>    [Brian King] Ensure we clear failover_pending during hard reset
>    ---
>    drivers/net/ethernet/ibm/ibmvnic.c | 36 ++++++++++++++++++++++++++----
>    1 file changed, 32 insertions(+), 4 deletions(-)
>    diff --git a/drivers/net/ethernet/ibm/ibmvnic.c
>    b/drivers/net/ethernet/ibm/ibmvnic.c
>    index 1b702a43a5d0..2a0f6f6820db 100644
>    --- a/drivers/net/ethernet/ibm/ibmvnic.c
>    +++ b/drivers/net/ethernet/ibm/ibmvnic.c
>    @@ -1197,18 +1197,27 @@ static int ibmvnic_open(struct net_device
>    *netdev)
>    if (adapter->state !=3D VNIC_CLOSED) {
>    rc =3D ibmvnic_login(netdev);
>    if (rc)
>    - return rc;
>    + goto out;
>    rc =3D init_resources(adapter);
>    if (rc) {
>    netdev_err(netdev, "failed to initialize resources\n");
>    release_resources(adapter);
>    - return rc;
>    + goto out;
>    }
>    }
>    rc =3D __ibmvnic_open(netdev);
>    +out:
>    + /*
>    + * If open fails due to a pending failover, set device state and
>    + * return. Device operation will be handled by reset routine.
>    + */
>    + if (rc && adapter->failover_pending) {
>    + adapter->state =3D VNIC_OPEN;
>    + rc =3D 0;
>    + }
>    return rc;
>    }
>    @@ -1931,6 +1940,13 @@ static int do_reset(struct ibmvnic_adapter
>    *adapter,
>      rwi->reset_reason);
>    rtnl_lock();
>    + /*
>    + * Now that we have the rtnl lock, clear any pending failover.
>    + * This will ensure ibmvnic_open() has either completed or will
>    + * block until failover is complete.
>    + */
>    + if (rwi->reset_reason =3D=3D VNIC_RESET_FAILOVER)
>    + adapter->failover_pending =3D false;
>    netif_carrier_off(netdev);
>    adapter->reset_reason =3D rwi->reset_reason;
>    @@ -2211,6 +2227,13 @@ static void __ibmvnic_reset(struct work_struct
>    *work)
>    /* CHANGE_PARAM requestor holds rtnl_lock */
>    rc =3D do_change_param_reset(adapter, rwi, reset_state);
>    } else if (adapter->force_reset_recovery) {
>    + /*
>    + * Since we are doing a hard reset now, clear the
>    + * failover_pending flag so we don't ignore any
>    + * future MOBILITY or other resets.
>    + */
>    + adapter->failover_pending =3D false;
>    +
>=20
>    I think it would be better to put above chunk of code to
>    do_hard_reset()
>    like you do for do_reset(),  if you really want to extend the window

I put it here because we clear the other flags like force_reset_recovery
also. I have been considering moving the check ->wait_for_reset and the
rtnl lock also into do_hard_reset(). I will queue that reorg separate
=66rom this bug fix.

>    this way.
>    Extending the window that long may cause some resets being
>    skipped in some scenarios though I don=E2=80=99t know yet.

Yes hard to prove, but we have run several tests on this and seems to
be working.

>    We have already seen the migration reset being skipped in some cases.

Is that happening due to this patch or in general? If a migration occurs
while failover is pending, we should review the best way to handle that.
Will failover complete in such a case or should we punt the failover and
process migration instead? I think that should be addressed separately
because that window is smaller but is there even without this patch?

>    So my point is extending the window is kind of risky, and do we have an
>    alternative to address the "open=E2=80=9D problem you want to solve or=
iginally?
>    For example, would it be a viable approach to only change the code in
>    ibmvnic_open() or __ibmvnic_open(), but not extend this window?

Not sure. We could try and block the open until failover is completed
but a) that could still timeout the application and b) Existing code
"pretends" that failover occurred "just after" open succeeded, so marks
the open successful and lets the failover complete the open.

Besides, we should also not assume that the failover window will be
short right?

>=20
>    /* Transport event occurred during previous reset */
>    if (adapter->wait_for_reset) {
>    /* Previous was CHANGE_PARAM; caller locked */
>    @@ -2275,9 +2298,15 @@ static int ibmvnic_reset(struct ibmvnic_adapter
>    *adapter,
>    unsigned long flags;
>    int ret;
>    + /*
>    + * If failover is pending don't schedule any other reset.
>    + * Instead let the failover complete. If there is already a
>    + * a failover reset scheduled, we will detect and drop the
>    + * duplicate reset when walking the ->rwi_list below.
>    + */
>    if (adapter->state =3D=3D VNIC_REMOVING ||
>       adapter->state =3D=3D VNIC_REMOVED ||
>    -    adapter->failover_pending) {
>    +    (adapter->failover_pending && reason !=3D VNIC_RESET_FAILOVER)) {
>    ret =3D EBUSY;
>    netdev_dbg(netdev, "Adapter removing or pending failover, skipping
>    reset\n");
>    goto err;
>    @@ -4653,7 +4682,6 @@ static void ibmvnic_handle_crq(union ibmvnic_crq
>    *crq,
>    case IBMVNIC_CRQ_INIT:
>    dev_info(dev, "Partner initialized\n");
>    adapter->from_passive_init =3D true;
>    - adapter->failover_pending =3D false;
>    if (!completion_done(&adapter->init_done)) {
>    complete(&adapter->init_done);
>    adapter->init_done_rc =3D -EIO;
>    --
>    2.25.4
>=20
> References
>=20
>    1. mailto:sukadev@linux.ibm.com
>    2. mailto:sukadev@linux.vnet.ibm.com
>    3. mailto:sukadev@linux.ibm.com
