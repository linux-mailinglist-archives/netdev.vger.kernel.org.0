Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 350D6338B4A
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 12:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234135AbhCLLJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 06:09:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234055AbhCLLJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 06:09:18 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56C93C061574
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 03:09:18 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id y16so4586066wrw.3
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 03:09:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZLANRHliRO73E/sxll05XoJuWbOQ7cfgrUcNCab2WrE=;
        b=F6WN3Mo8QzSuMitYPhDY5pFMEMdgvHcA8euhraBsMg5y4Ghj/V1/4oSsOa6NeQRGZ9
         qDY67j4czyel4Pqt5xdxCXHIzA4ngSdX6SUS5ZU2+OXZm2YbEIQ/T4a3h+hb4Veu1Sj9
         e4O+Wdngyz55/G7XS4VAIGqXefmP4pE/q5LRUifn8G5+bJOO9HJLlqoeAvXq0l2eB7U3
         YhyP2bTsW/xBJKNXFiLwugkEx8IT6G33WyBVe1KWK2E+0LFOB2IlZgKB7VV13V+iVL+q
         zTJ+A5a4xFIq0zw+0WfB6ml7l+RcrCCZ2Qlu0J/EjL94g5GNSu1gub+V0BB+zXzEqTQT
         ut+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZLANRHliRO73E/sxll05XoJuWbOQ7cfgrUcNCab2WrE=;
        b=fC5XLR6yfWV6Icdjnm9mquhE/uxx+zqtfO3/ZOb9FZwAtOTVt3VPSWQhS1jhqcD09k
         V1jxVZXfGMDAmWWfXKIgSQV/ZaLQxNEcSGScgr83zY9ahKJe/RbvTWS/X0VLxAcScGuY
         EDhGLecSxpQKTl5SnHJtF+CcNJ+EWnkp0EkCTF1rruzwASN8pz+efRfwj5NIDm5owpJy
         i2MNekeTP6UKSkSHycd//iAeo6ru29M8VHykpzm/29SoW9H4R6wQ7jfYjeUzr7TBdGJZ
         8oIhmf7kCe3P/nYBcB9OUoJDHuNj07r1QLxDOXEPe5sVCR45kmGNtE08/cds6VLRHhN1
         bk4A==
X-Gm-Message-State: AOAM533TXVfNIYETyNTRkgMgnn/XicXetbj2mXK0xIOY+hKTDEpGRMqa
        DEg2qkLeYu7KVLvIhN+1EoLWzw==
X-Google-Smtp-Source: ABdhPJzBZxEfRiXDIa54RX+VDX64gnUgXaLm+YOS8fR0v6kksaceGaXE+M9CpZAg5QJjonQ+nBkgDg==
X-Received: by 2002:a5d:4fd0:: with SMTP id h16mr12939845wrw.178.1615547357082;
        Fri, 12 Mar 2021 03:09:17 -0800 (PST)
Received: from dell.default ([91.110.221.204])
        by smtp.gmail.com with ESMTPSA id b65sm1833255wmh.4.2021.03.12.03.09.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 03:09:16 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>,
        LAPIS SEMICONDUCTOR <tshimizu818@gmail.com>,
        netdev@vger.kernel.org
Subject: [PATCH 4/4] ptp: ptp_p: Demote non-conformant kernel-doc headers and supply a param description
Date:   Fri, 12 Mar 2021 11:09:10 +0000
Message-Id: <20210312110910.2221265-5-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210312110910.2221265-1-lee.jones@linaro.org>
References: <20210312110910.2221265-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/ptp/ptp_pch.c:78: warning: Function parameter or member 'control' not described in 'pch_ts_regs'
 drivers/ptp/ptp_pch.c:78: warning: Function parameter or member 'event' not described in 'pch_ts_regs'
 drivers/ptp/ptp_pch.c:78: warning: Function parameter or member 'addend' not described in 'pch_ts_regs'
 drivers/ptp/ptp_pch.c:78: warning: Function parameter or member 'accum' not described in 'pch_ts_regs'
 drivers/ptp/ptp_pch.c:78: warning: Function parameter or member 'test' not described in 'pch_ts_regs'
 drivers/ptp/ptp_pch.c:78: warning: Function parameter or member 'ts_compare' not described in 'pch_ts_regs'
 drivers/ptp/ptp_pch.c:78: warning: Function parameter or member 'rsystime_lo' not described in 'pch_ts_regs'
 drivers/ptp/ptp_pch.c:78: warning: Function parameter or member 'rsystime_hi' not described in 'pch_ts_regs'
 drivers/ptp/ptp_pch.c:78: warning: Function parameter or member 'systime_lo' not described in 'pch_ts_regs'
 drivers/ptp/ptp_pch.c:78: warning: Function parameter or member 'systime_hi' not described in 'pch_ts_regs'
 drivers/ptp/ptp_pch.c:78: warning: Function parameter or member 'trgt_lo' not described in 'pch_ts_regs'
 drivers/ptp/ptp_pch.c:78: warning: Function parameter or member 'trgt_hi' not described in 'pch_ts_regs'
 drivers/ptp/ptp_pch.c:78: warning: Function parameter or member 'asms_lo' not described in 'pch_ts_regs'
 drivers/ptp/ptp_pch.c:78: warning: Function parameter or member 'asms_hi' not described in 'pch_ts_regs'
 drivers/ptp/ptp_pch.c:78: warning: Function parameter or member 'amms_lo' not described in 'pch_ts_regs'
 drivers/ptp/ptp_pch.c:78: warning: Function parameter or member 'amms_hi' not described in 'pch_ts_regs'
 drivers/ptp/ptp_pch.c:78: warning: Function parameter or member 'ch_control' not described in 'pch_ts_regs'
 drivers/ptp/ptp_pch.c:78: warning: Function parameter or member 'ch_event' not described in 'pch_ts_regs'
 drivers/ptp/ptp_pch.c:78: warning: Function parameter or member 'tx_snap_lo' not described in 'pch_ts_regs'
 drivers/ptp/ptp_pch.c:78: warning: Function parameter or member 'tx_snap_hi' not described in 'pch_ts_regs'
 drivers/ptp/ptp_pch.c:78: warning: Function parameter or member 'rx_snap_lo' not described in 'pch_ts_regs'
 drivers/ptp/ptp_pch.c:78: warning: Function parameter or member 'rx_snap_hi' not described in 'pch_ts_regs'
 drivers/ptp/ptp_pch.c:78: warning: Function parameter or member 'src_uuid_lo' not described in 'pch_ts_regs'
 drivers/ptp/ptp_pch.c:78: warning: Function parameter or member 'src_uuid_hi' not described in 'pch_ts_regs'
 drivers/ptp/ptp_pch.c:78: warning: Function parameter or member 'can_status' not described in 'pch_ts_regs'
 drivers/ptp/ptp_pch.c:78: warning: Function parameter or member 'can_snap_lo' not described in 'pch_ts_regs'
 drivers/ptp/ptp_pch.c:78: warning: Function parameter or member 'can_snap_hi' not described in 'pch_ts_regs'
 drivers/ptp/ptp_pch.c:78: warning: Function parameter or member 'ts_sel' not described in 'pch_ts_regs'
 drivers/ptp/ptp_pch.c:78: warning: Function parameter or member 'ts_st' not described in 'pch_ts_regs'
 drivers/ptp/ptp_pch.c:78: warning: Function parameter or member 'reserve1' not described in 'pch_ts_regs'
 drivers/ptp/ptp_pch.c:78: warning: Function parameter or member 'stl_max_set_en' not described in 'pch_ts_regs'
 drivers/ptp/ptp_pch.c:78: warning: Function parameter or member 'stl_max_set' not described in 'pch_ts_regs'
 drivers/ptp/ptp_pch.c:78: warning: Function parameter or member 'reserve2' not described in 'pch_ts_regs'
 drivers/ptp/ptp_pch.c:78: warning: Function parameter or member 'srst' not described in 'pch_ts_regs'
 drivers/ptp/ptp_pch.c:121: warning: Function parameter or member 'regs' not described in 'pch_dev'
 drivers/ptp/ptp_pch.c:121: warning: Function parameter or member 'ptp_clock' not described in 'pch_dev'
 drivers/ptp/ptp_pch.c:121: warning: Function parameter or member 'caps' not described in 'pch_dev'
 drivers/ptp/ptp_pch.c:121: warning: Function parameter or member 'exts0_enabled' not described in 'pch_dev'
 drivers/ptp/ptp_pch.c:121: warning: Function parameter or member 'exts1_enabled' not described in 'pch_dev'
 drivers/ptp/ptp_pch.c:121: warning: Function parameter or member 'mem_base' not described in 'pch_dev'
 drivers/ptp/ptp_pch.c:121: warning: Function parameter or member 'mem_size' not described in 'pch_dev'
 drivers/ptp/ptp_pch.c:121: warning: Function parameter or member 'irq' not described in 'pch_dev'
 drivers/ptp/ptp_pch.c:121: warning: Function parameter or member 'pdev' not described in 'pch_dev'
 drivers/ptp/ptp_pch.c:121: warning: Function parameter or member 'register_lock' not described in 'pch_dev'
 drivers/ptp/ptp_pch.c:128: warning: Function parameter or member 'station' not described in 'pch_params'
 drivers/ptp/ptp_pch.c:291: warning: Function parameter or member 'pdev' not described in 'pch_set_station_address'

Cc: Richard Cochran <richardcochran@gmail.com>
Cc: LAPIS SEMICONDUCTOR <tshimizu818@gmail.com>
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/ptp/ptp_pch.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/ptp/ptp_pch.c b/drivers/ptp/ptp_pch.c
index fa4417ad02e0c..a17e8cc642c5f 100644
--- a/drivers/ptp/ptp_pch.c
+++ b/drivers/ptp/ptp_pch.c
@@ -37,7 +37,8 @@ enum pch_status {
 	PCH_FAILED,
 	PCH_UNSUPPORTED,
 };
-/**
+
+/*
  * struct pch_ts_regs - IEEE 1588 registers
  */
 struct pch_ts_regs {
@@ -103,7 +104,8 @@ struct pch_ts_regs {
 
 #define PCH_IEEE1588_ETH	(1 << 0)
 #define PCH_IEEE1588_CAN	(1 << 1)
-/**
+
+/*
  * struct pch_dev - Driver private data
  */
 struct pch_dev {
@@ -120,7 +122,7 @@ struct pch_dev {
 	spinlock_t register_lock;
 };
 
-/**
+/*
  * struct pch_params - 1588 module parameter
  */
 struct pch_params {
@@ -286,6 +288,7 @@ static void pch_reset(struct pch_dev *chip)
  *				    IEEE 1588 hardware when looking at PTP
  *				    traffic on the  ethernet interface
  * @addr:	dress which contain the column separated address to be used.
+ * @pdev:	PCI device.
  */
 int pch_set_station_address(u8 *addr, struct pci_dev *pdev)
 {
-- 
2.27.0

