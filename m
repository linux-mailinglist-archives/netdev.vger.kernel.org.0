Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7452EE9CF
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 00:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729247AbhAGXf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 18:35:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729071AbhAGXf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 18:35:29 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9E25C0612FE
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 15:34:10 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id q1so8472648ilt.6
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 15:34:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xiaTitkw4KzTKWeohNq2UnqJT3ZfYyxC40xKZK6Dfz8=;
        b=CVTYFTud1QL63XEsmChmsUfOdQmb3nvZYMrbDXMQ/mlq25YO9zpkE/7e3HSxXsfBCN
         dwiPNAXZwyLkQq2HuV7KsoQathgYnBYPe6l+UBuOQ9zL/GqM5+/0JXIfs9ZRt8DCnLtH
         J8ZPSiujp/86QMWQksJQQhTa+92moAUXS55Ui/QVkNH5+Lp8dRGzhEmUKM8clgspln67
         1YLy9DJwwCBfUdkSwXCCBb4YGApVZ7KXauHAqTrwbHCRCjcovz3O8TshW2JD0VKxpLpG
         Nodc+RDcnItSz6qQ+oKHReSJHTeE0ZHF4UvxNCYh3phS2903Bqfbprq8CXBawwN9b0hl
         KAgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xiaTitkw4KzTKWeohNq2UnqJT3ZfYyxC40xKZK6Dfz8=;
        b=rWK/q4NUbgBvEu6agwkf4smYJujOgyphYC0plVwYqPiA5zfShS7HSS2IScWDMCAynW
         QL3l84fTf+Qi6L6pXzAPy4bR5I8pqEGy9ADQAsEFgZdSYwNsIrFs7uJp+nJvet/FU3qN
         C5dAO5W1PqHeHglRFUQL1lksRGtA9V0wJtSvr7jHVWvnEMiMI7j5ib65JldWqEO3zZQ4
         d/g3NkFj1Q4NIAxEYL3Rq+JPks9+v/aR2K973O3kvdjM1WJIC0o8Rd7Gmbp4IEKuV8Lz
         EJh1nAP/c/n5gSZ0bTCUHVX81M1cLv6t1ylgdj6195YcCY21CZi6qNLiZ0wC5X0cnAB8
         djaA==
X-Gm-Message-State: AOAM532vCKWx2YDRcHQnqCszznmovzrb+gwMOSyqpD3zihN0ZEmpDM/N
        yRcugVRfCuINorvmuMkUI3v0xA==
X-Google-Smtp-Source: ABdhPJxwf8C24X6AFWpLCk4TfPWDSqqQDj5m686UoGGcUyeMXiDxmCUmQLCrEnBx4fh63BSqTuO76g==
X-Received: by 2002:a05:6e02:1605:: with SMTP id t5mr1223825ilu.232.1610062450195;
        Thu, 07 Jan 2021 15:34:10 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id o195sm5648521ila.38.2021.01.07.15.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 15:34:09 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     bjorn.andersson@linaro.org, agross@kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ohad@wizery.com,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/4] soc: qcom: mdt_loader: define stubs for COMPILE_TEST
Date:   Thu,  7 Jan 2021 17:34:02 -0600
Message-Id: <20210107233404.17030-3-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210107233404.17030-1-elder@linaro.org>
References: <20210107233404.17030-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define stub functions for the exposed MDT functions in case
QCOM_MDT_LOADER is not configured.  This allows users of these
functions to link correctly for COMPILE_TEST builds without
QCOM_SCM enabled.

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Alex Elder <elder@linaro.org>
---
 include/linux/soc/qcom/mdt_loader.h | 35 +++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/include/linux/soc/qcom/mdt_loader.h b/include/linux/soc/qcom/mdt_loader.h
index e600baec68253..afd47217996b0 100644
--- a/include/linux/soc/qcom/mdt_loader.h
+++ b/include/linux/soc/qcom/mdt_loader.h
@@ -11,6 +11,8 @@
 struct device;
 struct firmware;
 
+#if IS_ENABLED(CONFIG_QCOM_MDT_LOADER)
+
 ssize_t qcom_mdt_get_size(const struct firmware *fw);
 int qcom_mdt_load(struct device *dev, const struct firmware *fw,
 		  const char *fw_name, int pas_id, void *mem_region,
@@ -23,4 +25,37 @@ int qcom_mdt_load_no_init(struct device *dev, const struct firmware *fw,
 			  phys_addr_t *reloc_base);
 void *qcom_mdt_read_metadata(const struct firmware *fw, size_t *data_len);
 
+#else /* !IS_ENABLED(CONFIG_QCOM_MDT_LOADER) */
+
+static inline ssize_t qcom_mdt_get_size(const struct firmware *fw)
+{
+	return -ENODEV;
+}
+
+static inline int qcom_mdt_load(struct device *dev, const struct firmware *fw,
+				const char *fw_name, int pas_id,
+				void *mem_region, phys_addr_t mem_phys,
+				size_t mem_size, phys_addr_t *reloc_base)
+{
+	return -ENODEV;
+}
+
+static inline int qcom_mdt_load_no_init(struct device *dev,
+					const struct firmware *fw,
+					const char *fw_name, int pas_id,
+					void *mem_region, phys_addr_t mem_phys,
+					size_t mem_size,
+					phys_addr_t *reloc_base)
+{
+	return -ENODEV;
+}
+
+static inline void *qcom_mdt_read_metadata(const struct firmware *fw,
+					   size_t *data_len)
+{
+	return ERR_PTR(-ENODEV);
+}
+
+#endif /* !IS_ENABLED(CONFIG_QCOM_MDT_LOADER) */
+
 #endif
-- 
2.20.1

