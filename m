Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65515263E69
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 09:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730361AbgIJHTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 03:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729986AbgIJGzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 02:55:53 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84B92C0617AA
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 23:55:01 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id a17so5415139wrn.6
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 23:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gHJHQOsrS1Lf8CGsUJv+l1dxeez2PhjcwxgjgiaDN24=;
        b=OzXJQefC1e+7qdSuahZz0Emy7KZKAcxdICX2H//vEvlg/EuHw31k+1hvtaAC7dYQTr
         lmYxXKN5q7uMzNLx5HydBotZmqVI+40XHCq6D8NPEe3e/RRYH4jNuL59hKdngUY3IGbl
         7w/A+FKqUhYyisPOd/rfuhV1d7tD56Jx+HwNrUXyecr5D3VqiGccHraOgx3aNf5qa6Bq
         Q9+82mLEGGt+UWQj5tx/Rdo7Wlkpjw5CvvuBgkHrh87upFJ7UHxkZaeZ+tDfakTXlJXw
         MH90l/t1JLFLWZ06cuVcaaY+Ig9PsGkdt9pZM4mcII5TSTZpJRIST6ir8pQ6qoTtzDuB
         ysMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gHJHQOsrS1Lf8CGsUJv+l1dxeez2PhjcwxgjgiaDN24=;
        b=QULnyH5I7izjrABcAFNj3SPsIiKXFNqlCu6oDAtoJc2uIkCBz7eCPCYYWGlPt9t014
         SBcVlDuf0vv1bMB142vfXh9XkUGMFQPU4clUs0Ce7j4Wm6EQh6gX4GeR9KUk5fAe5ZZ/
         wjth5menO9MVcOByfWX9zAl155cM5qkCd/wFGNRvbdQrrgQ6OHA3LH0S1U7ypCPYSdgl
         B4VJh9G00wyYqg6dWdgkaf1orKGn5hqsYAGCne6AdHnBGVOvliqiA1h3taMCtpQhWe8A
         erJZoq8bB/S3XSWzz+mB5A4ynIPIqIRJ/dOUK7K4wceqd357lN2YTjowmQYnE0uT9V4p
         A0nA==
X-Gm-Message-State: AOAM531vFhZxo0D64NGsQheeowmwFwrJEDI/kMLUlPm08Sjea10nU249
        O1uM25O3G4jOJnuisM6BYgl1dQ==
X-Google-Smtp-Source: ABdhPJy+3jU6kG/TKWH4gN99I71MijD8I6j6lfejKven5durxKSwD6WJXARvOWeiaSFnUiLJXTlg5A==
X-Received: by 2002:adf:eece:: with SMTP id a14mr7071043wrp.330.1599720900244;
        Wed, 09 Sep 2020 23:55:00 -0700 (PDT)
Received: from dell.default ([91.110.221.246])
        by smtp.gmail.com with ESMTPSA id m3sm2444028wme.31.2020.09.09.23.54.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 23:54:59 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        wil6210@qti.qualcomm.com, Maya Erez <merez@codeaurora.org>
Subject: [PATCH 06/29] wil6210: Fix a couple of formatting issues in 'wil6210_debugfs_init'
Date:   Thu, 10 Sep 2020 07:54:08 +0100
Message-Id: <20200910065431.657636-7-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200910065431.657636-1-lee.jones@linaro.org>
References: <20200910065431.657636-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kerneldoc expects attributes/parameters to be in '@*.: ' format and
gets confused if the variable does not follow the type/attribute
definitions.

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/ath/wil6210/debugfs.c:456: warning: Function parameter or member 'wil' not described in 'wil6210_debugfs_init_offset'
 drivers/net/wireless/ath/wil6210/debugfs.c:456: warning: Function parameter or member 'dbg' not described in 'wil6210_debugfs_init_offset'
 drivers/net/wireless/ath/wil6210/debugfs.c:456: warning: Function parameter or member 'base' not described in 'wil6210_debugfs_init_offset'
 drivers/net/wireless/ath/wil6210/debugfs.c:456: warning: Function parameter or member 'tbl' not described in 'wil6210_debugfs_init_offset'

Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: wil6210@qti.qualcomm.com
Cc: netdev@vger.kernel.org
Reviewed-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 11d0c79e90562..2d618f90afa7b 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -443,10 +443,10 @@ DEFINE_DEBUGFS_ATTRIBUTE(wil_fops_ulong, wil_debugfs_ulong_get,
 
 /**
  * wil6210_debugfs_init_offset - create set of debugfs files
- * @wil - driver's context, used for printing
- * @dbg - directory on the debugfs, where files will be created
- * @base - base address used in address calculation
- * @tbl - table with file descriptions. Should be terminated with empty element.
+ * @wil: driver's context, used for printing
+ * @dbg: directory on the debugfs, where files will be created
+ * @base: base address used in address calculation
+ * @tbl: table with file descriptions. Should be terminated with empty element.
  *
  * Creates files accordingly to the @tbl.
  */
-- 
2.25.1

