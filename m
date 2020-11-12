Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 580FB2B0638
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 14:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728291AbgKLNUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 08:20:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728211AbgKLNUJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 08:20:09 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9125EC0613D6
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 05:20:08 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id l1so5955839wrb.9
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 05:20:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eX+GAAptHKXOgkhhbpbMgVCvd1r24QVRM1QUTVGcPnU=;
        b=r7ks3WZ03Rk/rlNiqW0vrdZ5f0tUwn8RyVrmHJ1/rAjKIhGNF03nERo+UOAnUayb5N
         ODPD8xNuJAxnt6bbKRCGGVtWQHsmibelQ7xDkgzEr34xgcVHJREwDVxTz1X4UQgu/okD
         WmQ6h3XZ06G/XaRepGbUq600vle6QN1hBmIQiyfLSlFPaAPgwBXGadAJYjfKp5KkZU/a
         bUQ4Fi/VnN0JiOc3piOLAA0BnfsWgFXtyQQ6NkG9ifBx0z1cDLmSfnm2vTuNzL8BVQiL
         sP1960KNh3E4xelGNqsJRYut3RaNaYttcmp8EKIwRg4RJvwNxlnHiEbgO8eCS94/xMnA
         86jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eX+GAAptHKXOgkhhbpbMgVCvd1r24QVRM1QUTVGcPnU=;
        b=dPDFcAsDfzZEuZ7rpcNVzjarHmi4RiqnjsizTeRA4nTlgdAScT2uZME8R2e//gGYPc
         UQ0GG50lUEtptjku85CF8SZBU2VQ1fkAsIH3h2Q6QRKnFH6L3wCsMxFTl2GILzJHom1q
         GI9GNdB/gSgroVcjnl0JbfzQxrARIkkUa4+ok+dJOiSdSNnuyJLhv09dtRa6SI19N6Mj
         qk9TBJp06d/rNqitn5WrSEoebljYPyxRTzcuVZQPyWu6Iyq1Deb3tcWJHuvEfVat5sS2
         Je0w4qHlIiECvx/DhhuqtOrK8wMSW8paW+xvYQS/tj0a+vXcu+pnhoqbUkbxOIUGG067
         Z73w==
X-Gm-Message-State: AOAM530ytrHwK9U2KkDhL5rKYMCdnZn9+1oHTAuP6KXQtq14LvWpwUxl
        WKp5wXAKCUSqjHJ9o8oN9Be4Ww==
X-Google-Smtp-Source: ABdhPJzsoVfypyyuwRu8eGiLpd7PHZ28rxmqqrOUalYwoTiEGfgOFZhqMed3k/sxRA3Yf98av2k42A==
X-Received: by 2002:a5d:548b:: with SMTP id h11mr16509802wrv.306.1605187207325;
        Thu, 12 Nov 2020 05:20:07 -0800 (PST)
Received: from dell.default ([91.110.221.159])
        by smtp.gmail.com with ESMTPSA id t136sm2806326wmt.18.2020.11.12.05.20.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 05:20:06 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
        linux-wimax@intel.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Yanir Lubetkin <yanirx.lubetkin@intel.com>,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH 3/6] staging: net: wimax: i2400m: fw: Fix some function header misdemeanours
Date:   Thu, 12 Nov 2020 13:19:56 +0000
Message-Id: <20201112131959.2213841-4-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201112131959.2213841-1-lee.jones@linaro.org>
References: <20201112131959.2213841-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wimax/i2400m/fw.c:584: warning: Function parameter or member 'i2400m' not described in 'i2400m_bm_cmd'
 drivers/net/wimax/i2400m/fw.c:584: warning: Excess function parameter 'returns' description in 'i2400m_bm_cmd'
 drivers/net/wimax/i2400m/fw.c:646: warning: Function parameter or member 'chunk' not described in 'i2400m_download_chunk'
 drivers/net/wimax/i2400m/fw.c:646: warning: Function parameter or member '__chunk_len' not described in 'i2400m_download_chunk'
 drivers/net/wimax/i2400m/fw.c:646: warning: Excess function parameter 'buf' description in 'i2400m_download_chunk'
 drivers/net/wimax/i2400m/fw.c:646: warning: Excess function parameter 'buf_len' description in 'i2400m_download_chunk'
 drivers/net/wimax/i2400m/fw.c:1548: warning: Function parameter or member 'flags' not described in 'i2400m_dev_bootstrap'

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
Cc: linux-wimax@intel.com
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Yanir Lubetkin <yanirx.lubetkin@intel.com>
Cc: netdev@vger.kernel.org
Cc: devel@driverdev.osuosl.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/staging/wimax/i2400m/fw.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wimax/i2400m/fw.c b/drivers/staging/wimax/i2400m/fw.c
index 6c9a41bff2e0a..9970857063374 100644
--- a/drivers/staging/wimax/i2400m/fw.c
+++ b/drivers/staging/wimax/i2400m/fw.c
@@ -534,6 +534,7 @@ ssize_t __i2400m_bm_ack_verify(struct i2400m *i2400m, int opcode,
 /**
  * i2400m_bm_cmd - Execute a boot mode command
  *
+ * @i2400m: device descriptor
  * @cmd: buffer containing the command data (pointing at the header).
  *     This data can be ANYWHERE (for USB, we will copy it to an
  *     specific buffer). Make sure everything is in proper little
@@ -566,7 +567,7 @@ ssize_t __i2400m_bm_ack_verify(struct i2400m *i2400m, int opcode,
  *
  * @flags: see I2400M_BM_CMD_* above.
  *
- * @returns: bytes received by the notification; if < 0, an errno code
+ * Returns: bytes received by the notification; if < 0, an errno code
  *     denoting an error or:
  *
  *     -ERESTARTSYS  The device has rebooted
@@ -634,8 +635,8 @@ ssize_t i2400m_bm_cmd(struct i2400m *i2400m,
  * i2400m_download_chunk - write a single chunk of data to the device's memory
  *
  * @i2400m: device descriptor
- * @buf: the buffer to write
- * @buf_len: length of the buffer to write
+ * @chunk: the buffer to write
+ * @chunk_len: length of the buffer to write
  * @addr: address in the device memory space
  * @direct: bootrom write mode
  * @do_csum: should a checksum validation be performed
@@ -1533,6 +1534,13 @@ void i2400m_fw_put(struct i2400m_fw *i2400m_fw)
  * i2400m_dev_bootstrap - Bring the device to a known state and upload firmware
  *
  * @i2400m: device descriptor
+ * @flags:
+ *      I2400M_BRI_SOFT: a reboot barker has been seen
+ *          already, so don't wait for it.
+ *
+ *      I2400M_BRI_NO_REBOOT: Don't send a reboot command, but wait
+ *          for a reboot barker notification. This is a one shot; if
+ *          the state machine needs to send a reboot command it will.
  *
  * Returns: >= 0 if ok, < 0 errno code on error.
  *
-- 
2.25.1

