Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88C4824CEFC
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 09:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728482AbgHUHUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 03:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728236AbgHUHSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 03:18:12 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 402E2C06137A
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 00:17:18 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id d16so989258wrq.9
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 00:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DhbLFeeUnXIVGU1eOiDrbU+gQsxY/cBKEYP7/4MCrLk=;
        b=kt+Oz5/Guc0OMiYL/RbMLd1EoMi3UUjUjxjDZQtiTu6rCXqTKBVUUAyXYnSOZLXBr2
         iwe5d7opEM+HeFviPE2v2KjOXExGVdCb4ijqAPjZ8qRhZD+zvhtZd1aDnJktap99nYpU
         ciMApTG7JXjQKc8gFVQJMnxPt4pkCVAGiSQCkYr0PKiF+tLuFSuqxrCb/M5OYUqLFK4Y
         omOaqgI/rsUwW5XlsTXslblhc+ig3ucvYUgvSy/CcFO9g8Kk8fMw/lg9RR0Y6neLfdzI
         sP5rCTx+yQkKsnD5Q0dehsHKxpOyKxT0hz3Y8G+4zlNahztdFGsEy2vwuLbrFb/f8Ozv
         YPPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DhbLFeeUnXIVGU1eOiDrbU+gQsxY/cBKEYP7/4MCrLk=;
        b=Yw6ARd+oDItCTDXwfksiB18nOHOll6B128fowJ8mqAHeHMoBOHi5qCh54LNT6pAbki
         m6J383DXAuBgYZCLrSnQAhf0MUhYTggy+m5xCiXxUte4WYF+qKScytybi+iL8BzUQJku
         mBTTWhrekpk8yqzZFBMz0UtDogXNKnROdIknkoOXizqE9AZDGKrSBAvCxzgW/W4jrWCa
         hLfZUHryq6ZuR5N/xF3F/ZA3TaeqyK2x7+Sr07YnrncBhOg0klcS5tQwOWuxeoQ5+1hQ
         OcRhQIoktU7CPtcTpyRj3VpRDHIJcTYSo0aF+IBmARjsqkzFIS2tML2NWeznRTtHZFx6
         9Esg==
X-Gm-Message-State: AOAM533V1OKvmVqWppegMVhs5Wvbnl9WoAo1OpYqVPhYHIp/6IxK9bG8
        /AMmasimyc3qPVjKTe58I89MssEbJSHn4A==
X-Google-Smtp-Source: ABdhPJyHOVv55ct2DNh1mX90E5Ko+y+vDMR+i42zeCzP9KM++B/cTXhA8BYuAkK7d9HIbCVX+YRVRQ==
X-Received: by 2002:a5d:490c:: with SMTP id x12mr1346304wrq.238.1597994236949;
        Fri, 21 Aug 2020 00:17:16 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id y24sm2667957wmi.17.2020.08.21.00.17.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 00:17:16 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Linux Wireless <ilw@linux.intel.com>
Subject: [PATCH 23/32] wireless: intel: iwlegacy: 4965-calib: Demote seemingly accidental kernel-doc header
Date:   Fri, 21 Aug 2020 08:16:35 +0100
Message-Id: <20200821071644.109970-24-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821071644.109970-1-lee.jones@linaro.org>
References: <20200821071644.109970-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No parameters were documented and it's the only one in the file.

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/intel/iwlegacy/4965-calib.c:608: warning: Function parameter or member 'il' not described in 'il4965_find_disconn_antenna'
 drivers/net/wireless/intel/iwlegacy/4965-calib.c:608: warning: Function parameter or member 'average_sig' not described in 'il4965_find_disconn_antenna'
 drivers/net/wireless/intel/iwlegacy/4965-calib.c:608: warning: Function parameter or member 'data' not described in 'il4965_find_disconn_antenna'

Cc: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Linux Wireless <ilw@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/intel/iwlegacy/4965-calib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/4965-calib.c b/drivers/net/wireless/intel/iwlegacy/4965-calib.c
index e78bdefb8952c..2f97cbd423202 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965-calib.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-calib.c
@@ -598,7 +598,7 @@ il4965_find_first_chain(u8 mask)
 	return CHAIN_C;
 }
 
-/**
+/*
  * Run disconnected antenna algorithm to find out which antennas are
  * disconnected.
  */
-- 
2.25.1

