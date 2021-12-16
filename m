Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3901476B92
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 09:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234805AbhLPINK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 03:13:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234784AbhLPINJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 03:13:09 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FBD6C06173E
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 00:13:09 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id r138so22369711pgr.13
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 00:13:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jOPkYIC9MBDg3QKppD+I6WeSKkJEENVHD/2UOgJbqlQ=;
        b=E9Ad9va9ifQLKwbuGcxmxEl5p+2kSq3JCOfT2pkXz2GWKit/8G4IpQB1/B7LoUuyog
         gRGYWo1pJFWDDKCdGouMaizZjHp+/8PEr2Td2DCRY7qEixL26T83/sXxqB+u2V8Vq+Iq
         Ya9GqYPmvMWZQ6zRu8X4EPTf0FimLSGjoI7N2xFGaINSZeBSA7hDKsALOTdBd83587SZ
         xlSzbjkkd05wjeVuncTXCzihfnEEstddfSv5PXAT4OXdAVNbeFHFO2yaP4NvferPemgi
         yGDfpj3C3fu6X8eYdT5Z1Yvx/wtieFpfsIuGrt9n4QVqxYwq0XdqLJ6PqI52xf9CRQAA
         1BCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jOPkYIC9MBDg3QKppD+I6WeSKkJEENVHD/2UOgJbqlQ=;
        b=l8ykBbhSC1T6gp/0lWucZb1RKgKyhuxEXlJUGAaHZhUZP2B0wVSeSwInvWxJeWeYhX
         P/2ULQpwoHFLiE+Yix6a6p8TUhroxrGRego0j3jKXTrdcYWWSIFixHwklTNTZ/NydhIW
         qTHrM2GibBLd7nH+xnAYqEb1cpz2dEfF+7IuArOq+29LEJ0ZwTeU04OPMCJEkTPrSDoO
         RmIZuTCYOZlx2EUS9yoc255UG9HNCd7AlJRr3BgNmcgPYZ6U5qk058ijBJy4BabWJO/Z
         oryJXTkBscAcN3FncdCKsnvotE+09s6sw9bwhP9XDjtRaSP6/wbONnNxUQZH/EI+8o2i
         LX7w==
X-Gm-Message-State: AOAM533OklJzZN2dFwAkgcHiFdEnmVztb92L0jOLzzqyjBVmsnBDPIbg
        DKLLcz5Bhl5y4f4iCUoLWP6M
X-Google-Smtp-Source: ABdhPJz5i9WCnPCYAej1F+/71u+jQegY5Bm3GgFKjkemTATAUWlgMQgDvDa+7CcaKnOTNnbRKst7XQ==
X-Received: by 2002:a62:7a92:0:b0:49f:9a0f:6bcd with SMTP id v140-20020a627a92000000b0049f9a0f6bcdmr12887295pfc.43.1639642388527;
        Thu, 16 Dec 2021 00:13:08 -0800 (PST)
Received: from localhost.localdomain ([117.193.208.121])
        by smtp.gmail.com with ESMTPSA id u38sm326835pfg.4.2021.12.16.00.13.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 00:13:08 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     mhi@lists.linux.dev, hemantk@codeaurora.org, bbhatt@codeaurora.org,
        loic.poulain@linaro.org, thomas.perrot@bootlin.com,
        aleksander@aleksander.es, slark_xiao@163.com,
        christophe.jaillet@wanadoo.fr, keescook@chromium.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 04/10] bus: mhi: core: Minor style and comment fixes
Date:   Thu, 16 Dec 2021 13:42:21 +0530
Message-Id: <20211216081227.237749-5-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211216081227.237749-1-manivannan.sadhasivam@linaro.org>
References: <20211216081227.237749-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes the below checkpatch warnings in MHI bus:

WARNING: Possible repeated word: 'events'
+	/* Process ctrl events events */

WARNING: Missing a blank line after declarations
+			struct mhi_buf_info info = { };
+			buf = kmalloc(len, GFP_KERNEL);

WARNING: Move const after static - use 'static const struct mhi_pm_transitions'
+static struct mhi_pm_transitions const dev_state_transitions[] = {

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/bus/mhi/core/main.c | 3 ++-
 drivers/bus/mhi/core/pm.c   | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/bus/mhi/core/main.c b/drivers/bus/mhi/core/main.c
index b15c5bc37dd4..930aba666b67 100644
--- a/drivers/bus/mhi/core/main.c
+++ b/drivers/bus/mhi/core/main.c
@@ -1065,7 +1065,7 @@ void mhi_ctrl_ev_task(unsigned long data)
 		return;
 	}
 
-	/* Process ctrl events events */
+	/* Process ctrl events */
 	ret = mhi_event->process_event(mhi_cntrl, mhi_event, U32_MAX);
 
 	/*
@@ -1464,6 +1464,7 @@ int mhi_prepare_channel(struct mhi_controller *mhi_cntrl,
 		while (nr_el--) {
 			void *buf;
 			struct mhi_buf_info info = { };
+
 			buf = kmalloc(len, GFP_KERNEL);
 			if (!buf) {
 				ret = -ENOMEM;
diff --git a/drivers/bus/mhi/core/pm.c b/drivers/bus/mhi/core/pm.c
index 0bb8d77515e3..7464f5d09973 100644
--- a/drivers/bus/mhi/core/pm.c
+++ b/drivers/bus/mhi/core/pm.c
@@ -42,7 +42,7 @@
  * L3: LD_ERR_FATAL_DETECT <--> LD_ERR_FATAL_DETECT
  *     LD_ERR_FATAL_DETECT -> DISABLE
  */
-static struct mhi_pm_transitions const dev_state_transitions[] = {
+static const struct mhi_pm_transitions dev_state_transitions[] = {
 	/* L0 States */
 	{
 		MHI_PM_DISABLE,
-- 
2.25.1

