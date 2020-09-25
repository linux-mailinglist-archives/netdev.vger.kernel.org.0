Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1814A279426
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 00:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728869AbgIYWZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 18:25:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729088AbgIYWZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 18:25:08 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEEB4C0613D3
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 15:25:07 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id t14so3749203pgl.10
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 15:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gBRmBAGcKu4lRBYEDyDAo9a/cZeUFzzfNrVmpyXvD88=;
        b=Dt6dM676KYkZi3XlM474+k5/+qt50lBLrSUv/f6p1K3WAhE7vwmQ2R+r3AsmnSpi6Z
         MFaEnhZ8BrqsQF5k06bvaParVgsHdn1d6YCP4+0X43ABC1P0dE0TkE5sBYbUlj7RmQNQ
         38oyo5/TBL+Q0iGgpGSyZBrStoKWbbkPVerWZ2KNe9Q14vvC4/RqlOxacaCXpwnmGpaJ
         dTfWlwYOB05RAnKXYQwEw98dUMCELbBhPE+oY+qDCsTkSBKri7/msGA3LbqSil6M8d23
         8wPMK49pTG6UWqiCUSnMBUOsrx3ZblvO747JPrXfWu39B3pZQMoEdrKrsvRKUVLbvxwN
         FKkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gBRmBAGcKu4lRBYEDyDAo9a/cZeUFzzfNrVmpyXvD88=;
        b=jy7BDLePmUVURArnuAYfidLl0/TxL3C2HZ16fYwjcg+s0QqcM54dyeSfmy2oJXRozo
         MF3B/UIHQ0u3ZYh5RqKUhawh4BYifIVcGkDuk693qwto6BiD7lzmDgaWEJJwQAbzHAvg
         u/Zohr4DsnuhMPLATF8XRwTfdhCYzL3+q1uGlCvz9uUFB5o12+V1DSIhs5YvskoF8cxk
         Z2POH+fiVJfFWDppoQ2YBVjS7Ni8xVj6w/XRe1Te+0LN7ohQcX726Jz1uO/rD1tWCR6O
         6UEVg0doGaV/D3jwzA7BwtAe/b9aEvtsgauzxe/6ZBQ81e9KTin+RqdLVSJUb42Krv+M
         5Q/g==
X-Gm-Message-State: AOAM5310Ro/jSuYOnpjuPHtauPthQzxGHzWEV8o3lDER8tQ58JOuBYYY
        oZxC82PHzBnYFTuzgPI1cEakgVLkysa9GvcL
X-Google-Smtp-Source: ABdhPJxIR04MB+SRSlDEh2QuBAilY6mUu/k33gVIw50wl43OjPvBbBra8S6EnaVPrflTT7VaU+R7WQ==
X-Received: by 2002:aa7:9ab0:0:b029:13c:1611:66bb with SMTP id x16-20020aa79ab00000b029013c161166bbmr1289978pfi.6.1601072707097;
        Fri, 25 Sep 2020 15:25:07 -0700 (PDT)
Received: from jesse-ThinkPad-T570.lan (50-39-107-76.bvtn.or.frontiernet.net. [50.39.107.76])
        by smtp.gmail.com with ESMTPSA id q15sm169343pje.29.2020.09.25.15.25.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 15:25:06 -0700 (PDT)
From:   Jesse Brandeburg <jesse.brandeburg@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@gmail.com>,
        intel-wired-lan@lists.osuosl.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next v3 8/9] sfc: fix kdoc warning
Date:   Fri, 25 Sep 2020 15:24:44 -0700
Message-Id: <20200925222445.74531-9-jesse.brandeburg@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200925222445.74531-1-jesse.brandeburg@gmail.com>
References: <20200925222445.74531-1-jesse.brandeburg@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

kernel-doc script as used by W=1, is confused by the macro
usage inside the header describing the efx_ptp_data struct.

drivers/net/ethernet/sfc/ptp.c:345: warning: Function parameter or member 'MC_CMD_PTP_IN_TRANSMIT_LENMAX' not described in 'efx_ptp_data'

After some discussion on the list, break this patch out to
a separate one, and fix the issue through a creative
macro declaration.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Acked-by: Edward Cree <ecree@solarflare.com>
---
v3: unchanged, but it should be noted that the kernel-doc script
    should be fixed by someone smarter than me, to not complain
    about the original code.
v2: split this patch out and used custom fix to work around
    kernel-doc script.
---
 drivers/net/ethernet/sfc/mcdi.h | 1 +
 drivers/net/ethernet/sfc/ptp.c  | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/mcdi.h b/drivers/net/ethernet/sfc/mcdi.h
index ef6d21e4bd0b..69c2924a147c 100644
--- a/drivers/net/ethernet/sfc/mcdi.h
+++ b/drivers/net/ethernet/sfc/mcdi.h
@@ -190,6 +190,7 @@ void efx_mcdi_sensor_event(struct efx_nic *efx, efx_qword_t *ev);
  * 32-bit-aligned.  Also, on Siena we must copy to the MC shared
  * memory strictly 32 bits at a time, so add any necessary padding.
  */
+#define MCDI_TX_BUF_LEN(_len) DIV_ROUND_UP((_len), 4)
 #define _MCDI_DECLARE_BUF(_name, _len)					\
 	efx_dword_t _name[DIV_ROUND_UP(_len, 4)]
 #define MCDI_DECLARE_BUF(_name, _len)					\
diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index 2e8c4569f03b..aae208fe6b6e 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -326,7 +326,7 @@ struct efx_ptp_data {
 	struct work_struct pps_work;
 	struct workqueue_struct *pps_workwq;
 	bool nic_ts_enabled;
-	_MCDI_DECLARE_BUF(txbuf, MC_CMD_PTP_IN_TRANSMIT_LENMAX);
+	efx_dword_t txbuf[MCDI_TX_BUF_LEN(MC_CMD_PTP_IN_TRANSMIT_LENMAX)];
 
 	unsigned int good_syncs;
 	unsigned int fast_syncs;
-- 
2.25.4

