Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09D8A31D53F
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 07:06:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbhBQGFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 01:05:46 -0500
Received: from pbmsgap01.intersil.com ([192.157.179.201]:33018 "EHLO
        pbmsgap01.intersil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231569AbhBQGFX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 01:05:23 -0500
Received: from pps.filterd (pbmsgap01.intersil.com [127.0.0.1])
        by pbmsgap01.intersil.com (8.16.0.42/8.16.0.42) with SMTP id 11H5gc3h009549;
        Wed, 17 Feb 2021 00:42:38 -0500
Received: from pbmxdp01.intersil.corp (pbmxdp01.pb.intersil.com [132.158.200.222])
        by pbmsgap01.intersil.com with ESMTP id 36pb661gdx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 17 Feb 2021 00:42:38 -0500
Received: from pbmxdp02.intersil.corp (132.158.200.223) by
 pbmxdp01.intersil.corp (132.158.200.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.1979.3; Wed, 17 Feb 2021 00:42:37 -0500
Received: from localhost (132.158.202.108) by pbmxdp02.intersil.corp
 (132.158.200.223) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Wed, 17 Feb 2021 00:42:36 -0500
From:   <vincent.cheng.xh@renesas.com>
To:     <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Vincent Cheng <vincent.cheng.xh@renesas.com>
Subject: [PATCH v3 net-next 5/7] ptp: ptp_clockmatrix: Coding style - tighten vertical spacing.
Date:   Wed, 17 Feb 2021 00:42:16 -0500
Message-ID: <1613540538-23792-6-git-send-email-vincent.cheng.xh@renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1613540538-23792-1-git-send-email-vincent.cheng.xh@renesas.com>
References: <1613540538-23792-1-git-send-email-vincent.cheng.xh@renesas.com>
X-TM-AS-MML: disable
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-17_02:2021-02-16,2021-02-17 signatures=0
X-Proofpoint-Spam-Details: rule=junk_notspam policy=junk score=0 bulkscore=0 spamscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 phishscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170042
X-Proofpoint-Spam-Reason: mlx
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Cheng <vincent.cheng.xh@renesas.com>

Code clean-up.

* Remove blank line between variable declarations.
* Remove blank line between:
	err = blah(...)

	if (err)
		...
* Remove unnecessary blank line before/after loop constructs.

Signed-off-by: Vincent Cheng <vincent.cheng.xh@renesas.com>
---
 drivers/ptp/ptp_clockmatrix.c | 90 ++++++-------------------------------------
 1 file changed, 11 insertions(+), 79 deletions(-)

diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
index eec0a74..241bff0 100644
--- a/drivers/ptp/ptp_clockmatrix.c
+++ b/drivers/ptp/ptp_clockmatrix.c
@@ -229,7 +229,6 @@ static int idtcm_page_offset(struct idtcm *idtcm, u8 val)
 	buf[3] = 0x20;
 
 	err = idtcm_xfer_write(idtcm, PAGE_ADDR, buf, sizeof(buf));
-
 	if (err) {
 		idtcm->page_offset = 0xff;
 		dev_err(&idtcm->client->dev, "failed to set page offset");
@@ -254,7 +253,6 @@ static int _idtcm_rdwr(struct idtcm *idtcm,
 	lo = regaddr & 0xff;
 
 	err = idtcm_page_offset(idtcm, hi);
-
 	if (err)
 		return err;
 
@@ -312,7 +310,6 @@ static int wait_for_boot_status_ready(struct idtcm *idtcm)
 
 	do {
 		err = read_boot_status(idtcm, &status);
-
 		if (err)
 			return err;
 
@@ -415,14 +412,12 @@ static int _idtcm_gettime(struct idtcm_channel *channel,
 
 	/* wait trigger to be 0 */
 	while (trigger & TOD_READ_TRIGGER_MASK) {
-
 		if (idtcm->calculate_overhead_flag)
 			idtcm->start_time = ktime_get_raw();
 
 		err = idtcm_read(idtcm, channel->tod_read_primary,
 				 TOD_READ_PRIMARY_CMD, &trigger,
 				 sizeof(trigger));
-
 		if (err)
 			return err;
 
@@ -432,7 +427,6 @@ static int _idtcm_gettime(struct idtcm_channel *channel,
 
 	err = idtcm_read(idtcm, channel->tod_read_primary,
 			 TOD_READ_PRIMARY, buf, sizeof(buf));
-
 	if (err)
 		return err;
 
@@ -595,7 +589,6 @@ static int sync_source_dpll_tod_pps(u16 tod_addr, u8 *sync_src)
 static int idtcm_sync_pps_output(struct idtcm_channel *channel)
 {
 	struct idtcm *idtcm = channel->idtcm;
-
 	u8 pll;
 	u8 sync_src;
 	u8 qn;
@@ -604,7 +597,6 @@ static int idtcm_sync_pps_output(struct idtcm_channel *channel)
 	u8 out8_mux = 0;
 	u8 out11_mux = 0;
 	u8 temp;
-
 	u16 output_mask = channel->output_mask;
 
 	err = sync_source_dpll_tod_pps(channel->tod_n, &sync_src);
@@ -681,7 +673,6 @@ static int _idtcm_set_dpll_hw_tod(struct idtcm_channel *channel,
 			       enum hw_tod_write_trig_sel wr_trig)
 {
 	struct idtcm *idtcm = channel->idtcm;
-
 	u8 buf[TOD_BYTE_COUNT];
 	u8 cmd;
 	int err;
@@ -691,7 +682,6 @@ static int _idtcm_set_dpll_hw_tod(struct idtcm_channel *channel,
 	/* Configure HW TOD write trigger. */
 	err = idtcm_read(idtcm, channel->hw_dpll_n, HW_DPLL_TOD_CTRL_1,
 			 &cmd, sizeof(cmd));
-
 	if (err)
 		return err;
 
@@ -700,20 +690,16 @@ static int _idtcm_set_dpll_hw_tod(struct idtcm_channel *channel,
 
 	err = idtcm_write(idtcm, channel->hw_dpll_n, HW_DPLL_TOD_CTRL_1,
 			  &cmd, sizeof(cmd));
-
 	if (err)
 		return err;
 
 	if (wr_trig  != HW_TOD_WR_TRIG_SEL_MSB) {
-
 		err = timespec_to_char_array(&local_ts, buf, sizeof(buf));
-
 		if (err)
 			return err;
 
 		err = idtcm_write(idtcm, channel->hw_dpll_n,
 				  HW_DPLL_TOD_OVR__0, buf, sizeof(buf));
-
 		if (err)
 			return err;
 	}
@@ -725,7 +711,6 @@ static int _idtcm_set_dpll_hw_tod(struct idtcm_channel *channel,
 			  &cmd, sizeof(cmd));
 
 	if (wr_trig == HW_TOD_WR_TRIG_SEL_MSB) {
-
 		if (idtcm->calculate_overhead_flag) {
 			/* Assumption: I2C @ 400KHz */
 			ktime_t diff = ktime_sub(ktime_get_raw(),
@@ -740,7 +725,6 @@ static int _idtcm_set_dpll_hw_tod(struct idtcm_channel *channel,
 		}
 
 		err = timespec_to_char_array(&local_ts, buf, sizeof(buf));
-
 		if (err)
 			return err;
 
@@ -764,7 +748,6 @@ static int _idtcm_set_dpll_scsr_tod(struct idtcm_channel *channel,
 	timespec64_add_ns(&local_ts, SETTIME_CORRECTION);
 
 	err = timespec_to_char_array(&local_ts, buf, sizeof(buf));
-
 	if (err)
 		return err;
 
@@ -868,7 +851,6 @@ static int _idtcm_settime_deprecated(struct idtcm_channel *channel,
 	int err;
 
 	err = _idtcm_set_dpll_hw_tod(channel, ts, HW_TOD_WR_TRIG_SEL_MSB);
-
 	if (err) {
 		dev_err(&idtcm->client->dev,
 			"%s: Set HW ToD failed", __func__);
@@ -893,7 +875,6 @@ static int idtcm_set_phase_pull_in_offset(struct idtcm_channel *channel,
 	int err;
 	int i;
 	struct idtcm *idtcm = channel->idtcm;
-
 	u8 buf[4];
 
 	for (i = 0; i < 4; i++) {
@@ -913,7 +894,6 @@ static int idtcm_set_phase_pull_in_slope_limit(struct idtcm_channel *channel,
 	int err;
 	u8 i;
 	struct idtcm *idtcm = channel->idtcm;
-
 	u8 buf[3];
 
 	if (max_ffo_ppb & 0xff000000)
@@ -934,12 +914,10 @@ static int idtcm_start_phase_pull_in(struct idtcm_channel *channel)
 {
 	int err;
 	struct idtcm *idtcm = channel->idtcm;
-
 	u8 buf;
 
 	err = idtcm_read(idtcm, channel->dpll_phase_pull_in, PULL_IN_CTRL,
 			 &buf, sizeof(buf));
-
 	if (err)
 		return err;
 
@@ -961,12 +939,10 @@ static int idtcm_do_phase_pull_in(struct idtcm_channel *channel,
 	int err;
 
 	err = idtcm_set_phase_pull_in_offset(channel, -offset_ns);
-
 	if (err)
 		return err;
 
 	err = idtcm_set_phase_pull_in_slope_limit(channel, max_ffo_ppb);
-
 	if (err)
 		return err;
 
@@ -982,7 +958,6 @@ static int set_tod_write_overhead(struct idtcm_channel *channel)
 	s64 lowest_ns = 0;
 	int err;
 	u8 i;
-
 	ktime_t start;
 	ktime_t stop;
 	ktime_t diff;
@@ -994,12 +969,10 @@ static int set_tod_write_overhead(struct idtcm_channel *channel)
 		    buf, sizeof(buf));
 
 	for (i = 0; i < TOD_WRITE_OVERHEAD_COUNT_MAX; i++) {
-
 		start = ktime_get_raw();
 
 		err = idtcm_write(idtcm, channel->hw_dpll_n,
 				  HW_DPLL_TOD_OVR__0, buf, sizeof(buf));
-
 		if (err)
 			return err;
 
@@ -1035,12 +1008,10 @@ static int _idtcm_adjtime_deprecated(struct idtcm_channel *channel, s64 delta)
 		idtcm->calculate_overhead_flag = 1;
 
 		err = set_tod_write_overhead(channel);
-
 		if (err)
 			return err;
 
 		err = _idtcm_gettime(channel, &ts);
-
 		if (err)
 			return err;
 
@@ -1275,7 +1246,6 @@ static int idtcm_load_firmware(struct idtcm *idtcm,
 		idtcm_state_machine_reset(idtcm);
 
 	for (len = fw->size; len > 0; len -= sizeof(*rec)) {
-
 		if (rec->reserved) {
 			dev_err(&idtcm->client->dev,
 				"bad firmware, reserved field non-zero");
@@ -1336,7 +1306,6 @@ static int idtcm_output_enable(struct idtcm_channel *channel,
 	}
 
 	err = idtcm_read(idtcm, (u16)base, OUT_CTRL_1, &val, sizeof(val));
-
 	if (err)
 		return err;
 
@@ -1359,11 +1328,8 @@ static int idtcm_output_mask_enable(struct idtcm_channel *channel,
 	outn = 0;
 
 	while (mask) {
-
 		if (mask & 0x1) {
-
 			err = idtcm_output_enable(channel, enable, outn);
-
 			if (err)
 				return err;
 		}
@@ -1453,7 +1419,6 @@ static int idtcm_set_pll_mode(struct idtcm_channel *channel,
 static int _idtcm_adjphase(struct idtcm_channel *channel, s32 delta_ns)
 {
 	struct idtcm *idtcm = channel->idtcm;
-
 	int err;
 	u8 i;
 	u8 buf[4] = {0};
@@ -1461,9 +1426,7 @@ static int _idtcm_adjphase(struct idtcm_channel *channel, s32 delta_ns)
 	s64 offset_ps;
 
 	if (channel->pll_mode != PLL_MODE_WRITE_PHASE) {
-
 		err = idtcm_set_pll_mode(channel, PLL_MODE_WRITE_PHASE);
-
 		if (err)
 			return err;
 	}
@@ -1539,15 +1502,13 @@ static int _idtcm_adjfine(struct idtcm_channel *channel, long scaled_ppm)
 
 static int idtcm_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts)
 {
-	struct idtcm_channel *channel =
-		container_of(ptp, struct idtcm_channel, caps);
+	struct idtcm_channel *channel = container_of(ptp, struct idtcm_channel, caps);
 	struct idtcm *idtcm = channel->idtcm;
 	int err;
 
 	mutex_lock(&idtcm->reg_lock);
 
 	err = _idtcm_gettime(channel, ts);
-
 	if (err)
 		dev_err(&idtcm->client->dev, "Failed at line %d in %s!",
 			__LINE__, __func__);
@@ -1560,15 +1521,13 @@ static int idtcm_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts)
 static int idtcm_settime_deprecated(struct ptp_clock_info *ptp,
 				    const struct timespec64 *ts)
 {
-	struct idtcm_channel *channel =
-		container_of(ptp, struct idtcm_channel, caps);
+	struct idtcm_channel *channel = container_of(ptp, struct idtcm_channel, caps);
 	struct idtcm *idtcm = channel->idtcm;
 	int err;
 
 	mutex_lock(&idtcm->reg_lock);
 
 	err = _idtcm_settime_deprecated(channel, ts);
-
 	if (err)
 		dev_err(&idtcm->client->dev,
 			"Failed at line %d in %s!", __LINE__, __func__);
@@ -1581,15 +1540,13 @@ static int idtcm_settime_deprecated(struct ptp_clock_info *ptp,
 static int idtcm_settime(struct ptp_clock_info *ptp,
 			 const struct timespec64 *ts)
 {
-	struct idtcm_channel *channel =
-		container_of(ptp, struct idtcm_channel, caps);
+	struct idtcm_channel *channel = container_of(ptp, struct idtcm_channel, caps);
 	struct idtcm *idtcm = channel->idtcm;
 	int err;
 
 	mutex_lock(&idtcm->reg_lock);
 
 	err = _idtcm_settime(channel, ts, SCSR_TOD_WR_TYPE_SEL_ABSOLUTE);
-
 	if (err)
 		dev_err(&idtcm->client->dev,
 			"Failed at line %d in %s!", __LINE__, __func__);
@@ -1601,15 +1558,13 @@ static int idtcm_settime(struct ptp_clock_info *ptp,
 
 static int idtcm_adjtime_deprecated(struct ptp_clock_info *ptp, s64 delta)
 {
-	struct idtcm_channel *channel =
-		container_of(ptp, struct idtcm_channel, caps);
+	struct idtcm_channel *channel = container_of(ptp, struct idtcm_channel, caps);
 	struct idtcm *idtcm = channel->idtcm;
 	int err;
 
 	mutex_lock(&idtcm->reg_lock);
 
 	err = _idtcm_adjtime_deprecated(channel, delta);
-
 	if (err)
 		dev_err(&idtcm->client->dev,
 			"Failed at line %d in %s!", __LINE__, __func__);
@@ -1621,8 +1576,7 @@ static int idtcm_adjtime_deprecated(struct ptp_clock_info *ptp, s64 delta)
 
 static int idtcm_adjtime(struct ptp_clock_info *ptp, s64 delta)
 {
-	struct idtcm_channel *channel =
-		container_of(ptp, struct idtcm_channel, caps);
+	struct idtcm_channel *channel = container_of(ptp, struct idtcm_channel, caps);
 	struct idtcm *idtcm = channel->idtcm;
 	struct timespec64 ts;
 	enum scsr_tod_write_type_sel type;
@@ -1647,7 +1601,6 @@ static int idtcm_adjtime(struct ptp_clock_info *ptp, s64 delta)
 	mutex_lock(&idtcm->reg_lock);
 
 	err = _idtcm_settime(channel, &ts, type);
-
 	if (err)
 		dev_err(&idtcm->client->dev,
 			"Failed at line %d in %s!", __LINE__, __func__);
@@ -1659,17 +1612,13 @@ static int idtcm_adjtime(struct ptp_clock_info *ptp, s64 delta)
 
 static int idtcm_adjphase(struct ptp_clock_info *ptp, s32 delta)
 {
-	struct idtcm_channel *channel =
-		container_of(ptp, struct idtcm_channel, caps);
-
+	struct idtcm_channel *channel = container_of(ptp, struct idtcm_channel, caps);
 	struct idtcm *idtcm = channel->idtcm;
-
 	int err;
 
 	mutex_lock(&idtcm->reg_lock);
 
 	err = _idtcm_adjphase(channel, delta);
-
 	if (err)
 		dev_err(&idtcm->client->dev,
 			"Failed at line %d in %s!", __LINE__, __func__);
@@ -1681,17 +1630,13 @@ static int idtcm_adjphase(struct ptp_clock_info *ptp, s32 delta)
 
 static int idtcm_adjfine(struct ptp_clock_info *ptp,  long scaled_ppm)
 {
-	struct idtcm_channel *channel =
-		container_of(ptp, struct idtcm_channel, caps);
-
+	struct idtcm_channel *channel = container_of(ptp, struct idtcm_channel, caps);
 	struct idtcm *idtcm = channel->idtcm;
-
 	int err;
 
 	mutex_lock(&idtcm->reg_lock);
 
 	err = _idtcm_adjfine(channel, scaled_ppm);
-
 	if (err)
 		dev_err(&idtcm->client->dev,
 			"Failed at line %d in %s!", __LINE__, __func__);
@@ -1705,9 +1650,7 @@ static int idtcm_enable(struct ptp_clock_info *ptp,
 			struct ptp_clock_request *rq, int on)
 {
 	int err;
-
-	struct idtcm_channel *channel =
-		container_of(ptp, struct idtcm_channel, caps);
+	struct idtcm_channel *channel = container_of(ptp, struct idtcm_channel, caps);
 
 	switch (rq->type) {
 	case PTP_CLK_REQ_PEROUT:
@@ -1813,28 +1756,24 @@ static int _enable_pll_tod_sync(struct idtcm *idtcm,
 	 */
 	if (out0) {
 		err = idtcm_read(idtcm, out0, OUT_CTRL_1, &val, sizeof(val));
-
 		if (err)
 			return err;
 
 		val &= ~OUT_SYNC_DISABLE;
 
 		err = idtcm_write(idtcm, out0, OUT_CTRL_1, &val, sizeof(val));
-
 		if (err)
 			return err;
 	}
 
 	if (out1) {
 		err = idtcm_read(idtcm, out1, OUT_CTRL_1, &val, sizeof(val));
-
 		if (err)
 			return err;
 
 		val &= ~OUT_SYNC_DISABLE;
 
 		err = idtcm_write(idtcm, out1, OUT_CTRL_1, &val, sizeof(val));
-
 		if (err)
 			return err;
 	}
@@ -1854,7 +1793,6 @@ static int _enable_pll_tod_sync(struct idtcm *idtcm,
 static int idtcm_enable_tod_sync(struct idtcm_channel *channel)
 {
 	struct idtcm *idtcm = channel->idtcm;
-
 	u8 pll;
 	u8 sync_src;
 	u8 qn;
@@ -1896,8 +1834,7 @@ static int idtcm_enable_tod_sync(struct idtcm_channel *channel)
 		return -EINVAL;
 	}
 
-	err = idtcm_read(idtcm, 0, HW_Q8_CTRL_SPARE,
-			 &temp, sizeof(temp));
+	err = idtcm_read(idtcm, 0, HW_Q8_CTRL_SPARE, &temp, sizeof(temp));
 	if (err)
 		return err;
 
@@ -1905,8 +1842,7 @@ static int idtcm_enable_tod_sync(struct idtcm_channel *channel)
 	    Q9_TO_Q8_FANOUT_AND_CLOCK_SYNC_ENABLE_MASK)
 		out8_mux = 1;
 
-	err = idtcm_read(idtcm, 0, HW_Q11_CTRL_SPARE,
-			 &temp, sizeof(temp));
+	err = idtcm_read(idtcm, 0, HW_Q11_CTRL_SPARE, &temp, sizeof(temp));
 	if (err)
 		return err;
 
@@ -1953,7 +1889,6 @@ static int idtcm_enable_tod_sync(struct idtcm_channel *channel)
 		if ((qn != 0) || (qn_plus_1 != 0))
 			err = _enable_pll_tod_sync(idtcm, pll, sync_src, qn,
 					       qn_plus_1);
-
 		if (err)
 			return err;
 	}
@@ -2218,7 +2153,6 @@ static void ptp_clock_unregister_all(struct idtcm *idtcm)
 	struct idtcm_channel *channel;
 
 	for (i = 0; i < MAX_TOD; i++) {
-
 		channel = &idtcm->channel[i];
 
 		if (channel->ptp_clock)
@@ -2268,10 +2202,8 @@ static int idtcm_probe(struct i2c_client *client,
 	idtcm_set_version_info(idtcm);
 
 	err = idtcm_load_firmware(idtcm, &client->dev);
-
 	if (err)
-		dev_warn(&idtcm->client->dev,
-			 "loading firmware failed with %d", err);
+		dev_warn(&idtcm->client->dev, "loading firmware failed with %d", err);
 
 	wait_for_chip_ready(idtcm);
 
-- 
2.7.4

