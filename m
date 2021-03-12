Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAB1E338B31
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 12:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234124AbhCLLJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 06:09:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234137AbhCLLJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 06:09:17 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70A9CC061761
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 03:09:17 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id e9so1542681wrw.10
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 03:09:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZUveGSK6npk+QC7yNW+jetwhUE1LMyTcafYKcvUPbJg=;
        b=HtV+vx+dDBMdKSoFQBtUj3Qj5DXlD8N49u7k8YbucAZ/rl+eZ/su8Coa4vOMozqw4Z
         R62GV6sQuAwiTgmPOBDJy5OpBWuuTHeVqIEH+sF4alkZVi8wTLwl3RXnGhrK8KMycVBq
         gbQc7f/lDG9bqOldjobRuPE+P4O+B3nCxhFd1XAzHqaKQiThdlCJBOI00l4Z1jMu/6Ra
         Q1PWOl3bfXB4gFagpmz9w0OpEHUAySpTlD43zy+V3r+oYeDu6jVITifFOb5qAxDQuHZb
         1ZTnR030A9QG/5dFbw8gcsDKTdiBCzb1xwEefSAq3kaBgSaUk1MdAoW5d8wpQkQTv7XU
         wEgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZUveGSK6npk+QC7yNW+jetwhUE1LMyTcafYKcvUPbJg=;
        b=NLuFyeHbZ2WFeXD6MHbBYW41QSxvuZ0dxoGhp7iJMsEQtgshaqPu8xnQ8zy5D92hXD
         GKrUf0i99PdpehpwjLwThzqLSxg7xTGT1myb1XPkRzvvFAfJue4S+OlwWE2tLHTdLoRv
         ar5SJDyeMtPWJt8FJ5vEfKJlXG6TIFdD3PKN+mYadzb09nu+FEA5PufQok0nLaERmH7W
         +dgCMTd+pCg5MDJOwhRc8wsTWbGDZ02jotZglyhw5yjNOh5/dbPD+3v8/ktYlLdF0rgu
         osrXuHS+RgZ/78r4LF4Asqxp9laisyfUA3eLfMLVM5IgdSB9POY51EZs/73G9Ab44bWd
         fWAw==
X-Gm-Message-State: AOAM530qsl6G2Tdz9i8guFHoDxlEX72o11buacMEWe9L0gol91cgUs3K
        Ne1sVhmTMJFFxvbrLpwbW2JnRQ==
X-Google-Smtp-Source: ABdhPJyHjEoKvLyPV7yLmDisgrMONtxyetTll9HcG55CZuw+qxTIA+YsnK2unQ03AFR6B0m/NqjZQA==
X-Received: by 2002:a05:6000:250:: with SMTP id m16mr13662032wrz.325.1615547356191;
        Fri, 12 Mar 2021 03:09:16 -0800 (PST)
Received: from dell.default ([91.110.221.204])
        by smtp.gmail.com with ESMTPSA id b65sm1833255wmh.4.2021.03.12.03.09.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 03:09:15 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>,
        IDT-support-1588@lm.renesas.com, netdev@vger.kernel.org
Subject: [PATCH 3/4] ptp: ptp_clockmatrix: Demote non-kernel-doc header to standard comment
Date:   Fri, 12 Mar 2021 11:09:09 +0000
Message-Id: <20210312110910.2221265-4-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210312110910.2221265-1-lee.jones@linaro.org>
References: <20210312110910.2221265-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/ptp/ptp_clockmatrix.c:1408: warning: Cannot understand  * @brief Maximum absolute value for write phase offset in picoseconds
 drivers/ptp/ptp_clockmatrix.c:1408: warning: Cannot understand  * @brief Maximum absolute value for write phase offset in picoseconds
 drivers/ptp/ptp_clockmatrix.c:1408: warning: Cannot understand  * @brief Maximum absolute value for write phase offset in picoseconds
 drivers/ptp/ptp_clockmatrix.c:1408: warning: Cannot understand  * @brief Maximum absolute value for write phase offset in picoseconds
 drivers/ptp/ptp_clockmatrix.c:1408: warning: Cannot understand  * @brief Maximum absolute value for write phase offset in picoseconds

Cc: Richard Cochran <richardcochran@gmail.com>
Cc: IDT-support-1588@lm.renesas.com
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/ptp/ptp_clockmatrix.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
index 75463c2e2b867..fa636951169e5 100644
--- a/drivers/ptp/ptp_clockmatrix.c
+++ b/drivers/ptp/ptp_clockmatrix.c
@@ -1404,8 +1404,8 @@ static int idtcm_set_pll_mode(struct idtcm_channel *channel,
 
 /* PTP Hardware Clock interface */
 
-/**
- * @brief Maximum absolute value for write phase offset in picoseconds
+/*
+ * Maximum absolute value for write phase offset in picoseconds
  *
  * Destination signed register is 32-bit register in resolution of 50ps
  *
-- 
2.27.0

