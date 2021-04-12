Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77C1B35BAFA
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 09:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236899AbhDLHl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 03:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236917AbhDLHl1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 03:41:27 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D665DC061574
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 00:40:58 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id c16so12587947oib.3
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 00:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SosURgTWm7bhYnfflbqTj3vqGS/o94RI6cqCpClYbUk=;
        b=VNXxChMY8xucg1lo0MUofovnkBCh09zNlBMrZYo32hGVxH5IM1Yi1Sp3AAOA19TNZO
         HwAAA2aRNgxoHqjPCCqxtNGWTG4jG9Ks/7zCoDdcRBA/lXvm6tYa0muBhhOwyByF6PyQ
         WxgoWLnrTlZbFF1T6N+iGCdNdBAAHz8zkSx72jM2U4RawiHgdc8NHyctTv7KFIfXu1e+
         vRH6iVVe4jZaxLzk1zS009GTD6C4AA0hmPH7SqtJOwrRYasLSWq4RtgSoRalOffjRIoR
         Orz04MShYAQmuu6hZmVTITI8glGn4Ik3RRs7W5880rnLgTZmZ2x/O0ZzA5O8UN1UxEDt
         yJdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SosURgTWm7bhYnfflbqTj3vqGS/o94RI6cqCpClYbUk=;
        b=gAPhC0RskChLwHIKiBfPSZETYofEUJTTvH/2uQ2+5/rlJ4mNxjBhZqD7VZC7fhCGRF
         VU3Ytw+DDgkTQdDx4bAvCbCbldv1US7kGDTJVZwClYIhGCdXVuITLoQsCpDX9Abwa4FM
         RdYbTvyX9eH+IirBZBiMx9dp0Wgukqb9yGag8kUYv+ukEr+FPYolBXrcaApWnXfhL5De
         rrkLxpc+OJlJrgskuvfm0DEThob3mA16TCHsfDl3SywhHSu+Z2xp9tpMgsaYFwuwUHWR
         HR99qhsRiwh95xdCnPTjFlJhW/OwB8XuwJ90b3JZTSxz9ouxAeHOxDsHus+D3fccuXIX
         pj2A==
X-Gm-Message-State: AOAM533Qdo6TW4Puixlc3WahafhseHEjwXMSh1gTGwkLF7vJp91izqSq
        yUmasM5Ehv77Cztd3NWwz1pmsg6ofrI=
X-Google-Smtp-Source: ABdhPJxi2LXcwhLD4y0yVZG2z5XqCjanuK7qkQGm6Avcv3FTetmI2uWQt+gG3N+aE6fIFz2gj412ZQ==
X-Received: by 2002:a54:408a:: with SMTP id i10mr18448513oii.141.1618213258119;
        Mon, 12 Apr 2021 00:40:58 -0700 (PDT)
Received: from pear.attlocal.net ([2600:1700:271:1a80:70fe:cfb5:1414:607d])
        by smtp.gmail.com with ESMTPSA id u185sm1580911oie.12.2021.04.12.00.40.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Apr 2021 00:40:57 -0700 (PDT)
From:   Lijun Pan <lijunp213@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <lijunp213@gmail.com>
Subject: [PATCH net-next] ibmvnic: clean up the remaining debugfs data structures
Date:   Mon, 12 Apr 2021 02:40:59 -0500
Message-Id: <20210412074059.9251-1-lijunp213@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit e704f0434ea6 ("ibmvnic: Remove debugfs support") did not
clean up everything. Remove the remaining code.

Signed-off-by: Lijun Pan <lijunp213@gmail.com>
---
 drivers/net/ethernet/ibm/ibmvnic.h | 94 ------------------------------
 1 file changed, 94 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index 806aa75a4e86..c1d39a748546 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -412,77 +412,6 @@ struct ibmvnic_control_ip_offload {
 	struct ibmvnic_rc rc;
 } __packed __aligned(8);
 
-struct ibmvnic_request_dump_size {
-	u8 first;
-	u8 cmd;
-	u8 reserved[6];
-	__be32 len;
-	struct ibmvnic_rc rc;
-} __packed __aligned(8);
-
-struct ibmvnic_request_dump {
-	u8 first;
-	u8 cmd;
-	u8 reserved1[2];
-	__be32 ioba;
-	__be32 len;
-	u8 reserved2[4];
-} __packed __aligned(8);
-
-struct ibmvnic_request_dump_rsp {
-	u8 first;
-	u8 cmd;
-	u8 reserved[6];
-	__be32 dumped_len;
-	struct ibmvnic_rc rc;
-} __packed __aligned(8);
-
-struct ibmvnic_request_ras_comp_num {
-	u8 first;
-	u8 cmd;
-	u8 reserved1[2];
-	__be32 num_components;
-	u8 reserved2[4];
-	struct ibmvnic_rc rc;
-} __packed __aligned(8);
-
-struct ibmvnic_request_ras_comps {
-	u8 first;
-	u8 cmd;
-	u8 reserved[2];
-	__be32 ioba;
-	__be32 len;
-	struct ibmvnic_rc rc;
-} __packed __aligned(8);
-
-struct ibmvnic_control_ras {
-	u8 first;
-	u8 cmd;
-	u8 correlator;
-	u8 level;
-	u8 op;
-#define IBMVNIC_TRACE_LEVEL	1
-#define IBMVNIC_ERROR_LEVEL	2
-#define IBMVNIC_TRACE_PAUSE	3
-#define IBMVNIC_TRACE_RESUME	4
-#define IBMVNIC_TRACE_ON		5
-#define IBMVNIC_TRACE_OFF		6
-#define IBMVNIC_CHG_TRACE_BUFF_SZ	7
-	u8 trace_buff_sz[3];
-	u8 reserved[4];
-	struct ibmvnic_rc rc;
-} __packed __aligned(8);
-
-struct ibmvnic_collect_fw_trace {
-	u8 first;
-	u8 cmd;
-	u8 correlator;
-	u8 reserved;
-	__be32 ioba;
-	__be32 len;
-	struct ibmvnic_rc rc;
-} __packed __aligned(8);
-
 struct ibmvnic_request_statistics {
 	u8 first;
 	u8 cmd;
@@ -494,15 +423,6 @@ struct ibmvnic_request_statistics {
 	u8 reserved[4];
 } __packed __aligned(8);
 
-struct ibmvnic_request_debug_stats {
-	u8 first;
-	u8 cmd;
-	u8 reserved[2];
-	__be32 ioba;
-	__be32 len;
-	struct ibmvnic_rc rc;
-} __packed __aligned(8);
-
 struct ibmvnic_error_indication {
 	u8 first;
 	u8 cmd;
@@ -677,22 +597,8 @@ union ibmvnic_crq {
 	struct ibmvnic_query_ip_offload query_ip_offload_rsp;
 	struct ibmvnic_control_ip_offload control_ip_offload;
 	struct ibmvnic_control_ip_offload control_ip_offload_rsp;
-	struct ibmvnic_request_dump_size request_dump_size;
-	struct ibmvnic_request_dump_size request_dump_size_rsp;
-	struct ibmvnic_request_dump request_dump;
-	struct ibmvnic_request_dump_rsp request_dump_rsp;
-	struct ibmvnic_request_ras_comp_num request_ras_comp_num;
-	struct ibmvnic_request_ras_comp_num request_ras_comp_num_rsp;
-	struct ibmvnic_request_ras_comps request_ras_comps;
-	struct ibmvnic_request_ras_comps request_ras_comps_rsp;
-	struct ibmvnic_control_ras control_ras;
-	struct ibmvnic_control_ras control_ras_rsp;
-	struct ibmvnic_collect_fw_trace collect_fw_trace;
-	struct ibmvnic_collect_fw_trace collect_fw_trace_rsp;
 	struct ibmvnic_request_statistics request_statistics;
 	struct ibmvnic_generic_crq request_statistics_rsp;
-	struct ibmvnic_request_debug_stats request_debug_stats;
-	struct ibmvnic_request_debug_stats request_debug_stats_rsp;
 	struct ibmvnic_error_indication error_indication;
 	struct ibmvnic_link_state_indication link_state_indication;
 	struct ibmvnic_change_mac_addr change_mac_addr;
-- 
2.23.0

