Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AFEC596928
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 08:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238832AbiHQGKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 02:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232678AbiHQGKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 02:10:12 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7725F754A6
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 23:10:11 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1660716608;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qQN4bdKJtEm0SAhnURVpkP8zPxX8iHX5edk4kl8nVU8=;
        b=oB8DS/MC1aCpOvlfxtVbuO4CZ9XQLZxDTqyMtl9TGUNdiC5zflajWNkT/GShI6aUKsdj0Q
        qgZVX6GhkdexWpG038QB8m6FEGucrvG5uIKVnCFbQt0L2PCylD0//PTs/XMgK6+H/ST3TP
        vDryLs8m+oAfTYk+bXxQP0y60ZrpUiqr7kTH3z1q2FTxXmuI3zrTjSE8FdaH3cmManos0b
        /dhH/aFE8w8xdKW0SK6M9XWlBMVqAVMPMVdEVG2yFpCwXTb2izf7isno8/GdmEVLvoPXLq
        BYRcmpTq2FURMdMNUxFhbzMmfEGrzFHyGELizavsF2l7tmZBD2TUpuOH0P/YBg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1660716608;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qQN4bdKJtEm0SAhnURVpkP8zPxX8iHX5edk4kl8nVU8=;
        b=WstS5gwQg7z2VLx2B8cGHr70KDEiL0ysCAMKnWtu9RdtY0EYqkBsH2i3L0VkWaCwQ2OH9B
        +WLkAWM4wdEDX2Dw==
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Ferenc Fejes <ferenc.fejes@ericsson.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "marton12050@gmail.com" <marton12050@gmail.com>,
        "peti.antal99@gmail.com" <peti.antal99@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: igc: missing HW timestamps at TX
In-Reply-To: <87v8qrhq7w.fsf@intel.com>
References: <VI1PR07MB4080AED64AC8BFD3F9C1BE58E18D9@VI1PR07MB4080.eurprd07.prod.outlook.com>
 <VI1PR07MB4080DC45051E112EEC6D7734E18D9@VI1PR07MB4080.eurprd07.prod.outlook.com>
 <87tu7emqb9.fsf@intel.com>
 <695ec13e018d1111cf3e16a309069a72d55ea70e.camel@ericsson.com>
 <d5571f0ea205e26bced51220044781131296aaac.camel@ericsson.com>
 <87tu6i6h1k.fsf@intel.com>
 <252755c5f3b83c86fac5cb60c70931204b0ed6df.camel@ericsson.com>
 <252755c5f3b83c86fac5cb60c70931204b0ed6df.camel@ericsson.com>
 <20220812201654.qx7e37otu32pxnbk@skbuf> <87v8qti3u2.fsf@intel.com>
 <20220815222639.346wachaaq5zjwue@skbuf> <87k079hzry.fsf@intel.com>
 <87edxgr2q0.fsf@kurt> <87v8qrhq7w.fsf@intel.com>
Date:   Wed, 17 Aug 2022 08:10:05 +0200
Message-ID: <87y1vno0xu.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue Aug 16 2022, Vinicius Costa Gomes wrote:
> Kurt Kanzenbach <kurt@linutronix.de> writes:
>
>> Hi Vinicius,
>>
>> On Mon Aug 15 2022, Vinicius Costa Gomes wrote:
>>> I think your question is more "why there's that workqueue on igc?"/"why
>>> don't you retrieve the TX timestamp 'inline' with the interrupt?", if I
>>> got that right, then, I don't have a good reason, apart from the feeling
>>> that reading all those (5-6?) registers may take too long for a
>>> interrupt handler. And it's something that's being done the same for
>>> most (all?) Intel drivers.
>>
>> We do have one optimization for igb which attempts to read the Tx
>> timestamp directly from the ISR. If that's not ready *only* then we
>> schedule the worker. I do assume igb and igc have the same logic for
>> retrieving the timestamps here.
>>
>
> That seems a sensible approach. And yes, the timestamping logic is the
> same.
>
>> The problem with workqueues is that under heavy system load, it might be
>> deferred and timestamps will be lost. I guess that workqueue was added
>> because of something like this: 1f6e8178d685 ("igb: Prevent dropped Tx
>> timestamps via work items and interrupts.").
>>
>>>
>>> I have a TODO to experiment with removing the workqueue, and retrieving
>>> the TX timestamp in the same context as the interrupt handler, but other
>>> things always come up.
>>
>> Let me know if you have interest in that igb patch.
>
> That would be great! Thanks.

Sure. See igb patch below.

I'm also wondering whether that delayed work should be replaced
completely by the PTP AUX worker, because that one can be prioritized in
accordance to the use case. And I see Vladimir already suggested this.

From=20c546621323ba325eccfcf6a9891681929d4b9b4f Mon Sep 17 00:00:00 2001
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Date: Tue, 8 Jun 2021 15:38:43 +0200
Subject: [PATCH] igb: Try to tread the timestamp from the ISR.

Commit
   1f6e8178d6851 ("igb: Prevent dropped Tx timestamps via work items and in=
terrupts.")

moved the read of the timestamp into a workqueue in order to retry the
read process in case the timestamp is not immediatly available after the
interrupt. The workqueue is scheduled immediatelly after sending a skb
on 82576 and for all other card types once the timestamp interrupt
occurs. Once scheduled, the workqueue will busy poll for the timestamp
until the operation times out.

By defferring the read of timestamp into a workqueue, the driver can
drop the timestamp of a following packet if the read does not occur
before the following packet is sent. This can happen if the system is
busy and the workqueue is delayed so that it is scheduled after another
skb.

Attempt the of the timestamp directly in the ISR and schedule a
workqueue in case the timestamp is not yet ready. Guard the read process
with __IGB_PTP_TX_READ_IN_PROGRESS to ensure that only one process
attempts to read the timestamp.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
=2D--
 drivers/net/ethernet/intel/igb/igb.h      | 2 ++
 drivers/net/ethernet/intel/igb/igb_main.c | 2 +-
 drivers/net/ethernet/intel/igb/igb_ptp.c  | 7 +++++--
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb.h b/drivers/net/ethernet/in=
tel/igb/igb.h
index 2d3daf022651..4c49550768ee 100644
=2D-- a/drivers/net/ethernet/intel/igb/igb.h
+++ b/drivers/net/ethernet/intel/igb/igb.h
@@ -705,6 +705,7 @@ enum e1000_state_t {
 	__IGB_RESETTING,
 	__IGB_DOWN,
 	__IGB_PTP_TX_IN_PROGRESS,
+	__IGB_PTP_TX_READ_IN_PROGRESS,
 };
=20
 enum igb_boards {
@@ -750,6 +751,7 @@ void igb_ptp_tx_hang(struct igb_adapter *adapter);
 void igb_ptp_rx_rgtstamp(struct igb_q_vector *q_vector, struct sk_buff *sk=
b);
 int igb_ptp_rx_pktstamp(struct igb_q_vector *q_vector, void *va,
 			ktime_t *timestamp);
+void igb_ptp_tx_work(struct work_struct *work);
 int igb_ptp_set_ts_config(struct net_device *netdev, struct ifreq *ifr);
 int igb_ptp_get_ts_config(struct net_device *netdev, struct ifreq *ifr);
 void igb_set_flag_queue_pairs(struct igb_adapter *, const u32);
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethern=
et/intel/igb/igb_main.c
index b88303351484..b74b305b5730 100644
=2D-- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -6756,7 +6756,7 @@ static void igb_tsync_interrupt(struct igb_adapter *a=
dapter)
=20
 	if (tsicr & E1000_TSICR_TXTS) {
 		/* retrieve hardware timestamp */
=2D		schedule_work(&adapter->ptp_tx_work);
+		igb_ptp_tx_work(&adapter->ptp_tx_work);
 		ack |=3D E1000_TSICR_TXTS;
 	}
=20
diff --git a/drivers/net/ethernet/intel/igb/igb_ptp.c b/drivers/net/etherne=
t/intel/igb/igb_ptp.c
index 0011b15e678c..97b444f84b83 100644
=2D-- a/drivers/net/ethernet/intel/igb/igb_ptp.c
+++ b/drivers/net/ethernet/intel/igb/igb_ptp.c
@@ -680,7 +680,7 @@ static int igb_ptp_verify_pin(struct ptp_clock_info *pt=
p, unsigned int pin,
  * This work function polls the TSYNCTXCTL valid bit to determine when a
  * timestamp has been taken for the current stored skb.
  **/
=2Dstatic void igb_ptp_tx_work(struct work_struct *work)
+void igb_ptp_tx_work(struct work_struct *work)
 {
 	struct igb_adapter *adapter =3D container_of(work, struct igb_adapter,
 						   ptp_tx_work);
@@ -705,7 +705,9 @@ static void igb_ptp_tx_work(struct work_struct *work)
 	}
=20
 	tsynctxctl =3D rd32(E1000_TSYNCTXCTL);
=2D	if (tsynctxctl & E1000_TSYNCTXCTL_VALID)
+	if (tsynctxctl & E1000_TSYNCTXCTL_VALID &&
+	    !test_and_set_bit_lock(__IGB_PTP_TX_READ_IN_PROGRESS,
+				   &adapter->state))
 		igb_ptp_tx_hwtstamp(adapter);
 	else
 		/* reschedule to check later */
@@ -850,6 +852,7 @@ static void igb_ptp_tx_hwtstamp(struct igb_adapter *ada=
pter)
 	 */
 	adapter->ptp_tx_skb =3D NULL;
 	clear_bit_unlock(__IGB_PTP_TX_IN_PROGRESS, &adapter->state);
+	clear_bit_unlock(__IGB_PTP_TX_READ_IN_PROGRESS, &adapter->state);
=20
 	/* Notify the stack and free the skb after we've unlocked */
 	skb_tstamp_tx(skb, &shhwtstamps);
=2D-=20
2.30.2


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmL8hj0THGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgiZvD/9+SXFekDpTf0QJ/vmry0PlYkjlfo4B
BwzNwlxx/L+CtRxeYJ+YGde6PdVQZPpe0eeKxNuOWpm1ZRIVHU5BHjnpiwG7nq1S
1LZsOxVxAAOJ+Gfy9U+MiLayk5Hu0BNZjHzl0HG4btBN2rEO4r15RU8/xMCrxoWt
8tT8qHlO001tQ88lK20XMotNPo66vQFGyBUMqnq+wX7VpjYlM1irtmXmk6a041EY
PVcWYKbW32AC7Cpru8uUqXqiZonIyPtmUCUaQVphEhtevEscpmvmDyaE98+oqDra
lZDnXHKEiAPQpet1/9oTxGF341llAT5TFFC0F/U7VyX64FUSZjaAItd9/Km7/xxx
IgeUPblwq5SjPbFmEm6ka+yWgnPDGwwLL7J7KOnFQigJHvif+1Xc8tuQKt54Myhr
2ezYxxvO/MnmZ0P2YeHoMKx+qBBppb8EDKma0dnGoriQK7sxseXUIFX0956kiLN0
GWmhFUTblvJ+meml5VwmfZTHI2OFMtgcXXZvAi9inlAXGRw1JAmHY2fYeAAbPDx+
ClvflOkDJsaBejeDaewwwORABlqjgKnG/JoIGLJkGMp5UzwKeSohPyr7MXKWIRGO
9Y4PokxYk5+QlxKH+HrOK9Ei8rTmUw0Va52lVql71QpmypFEvRJnOE2YAHHzSxsK
6KdQhRFEHqsDBg==
=7KQK
-----END PGP SIGNATURE-----
--=-=-=--
