Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B71BA2A29E8
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:48:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728859AbgKBLst (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:48:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728616AbgKBLpb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:45:31 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B2EC061A49
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 03:45:29 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id y12so14217308wrp.6
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 03:45:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ovie+dxspvrU5u8+4wDypRlKJmG6Xumo/oagtBBwY2g=;
        b=bKwIQdAnp/kv2/fCVRgBZpe17vYm8/pAkopdSiLaVAAEeqtSNnYKfQojLimBEUYe6F
         TnwQ0/R0n3TuTnVFSZD2O+pnB3SzYIhkJUjB+HnKrT7+4aHfZKwQj+Quc6WhHFSHI0Oe
         t2ah0F5oBlLM3HHGdA0fiH0FELST3HRKp7wKkeFVgJNm227dSWcSFiKzKQqeX+6zO7R/
         SxxhjOsHT2PFKxWNst0iONDkLkkVfR7SMGzSQRbU9VMbSNdXl9SBRsxDEMXMGy/QAixH
         +qsZ1wB7hICLkWTkKCzun+BLDx20BTZ3oJ8hBz2nFRRFOGuFQHJ8OVQ/vpH4SWEUL+fg
         dQCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ovie+dxspvrU5u8+4wDypRlKJmG6Xumo/oagtBBwY2g=;
        b=XzKMhUH8lH4yC8lgLtSQ2YqtXyaK1sXQxNOd2tx0MQSYWKVRUR8w8t5GdytG1i5X0w
         9vRaqNwmvlbr6OcOrpq7b7dSQs1K77ysHvIkOP5G/sztIdi4HXJFOKjlGuT3P/tNKxS5
         qUgKwh5tNDI1mYNnafEW9LEk6kPj7/mrrt1PfymYqOvKtfBEhyCkcRUvgNjTFyYwtSPR
         88ZxIgmyv3srmbDd84Jmth79G4qEWhWl8HBJcJJ6i8eEqFwlxfzVBzucMSGrQvgMxZ0Y
         8DEx98y2mzWadJOZPoVqPL21BZNXdSuqCSDLbv+tQNN3SUXR25X5XpSDs/c+1eZOIgmO
         hrYQ==
X-Gm-Message-State: AOAM530tWEvzSfrx4DGn6t6i6St9vF+c8TNv9wdAGdOxdajKvHT4v0WO
        nSwN6r1AoxySe4tzIcIbXQsNPA==
X-Google-Smtp-Source: ABdhPJz77Ti9iG1aZnh7BZeK40/QFiM41qDrrepDbBJsPnTPjLG6Kl4EnPZomOQL1Gxcl1oTyav9Aw==
X-Received: by 2002:adf:f20f:: with SMTP id p15mr20042117wro.339.1604317528202;
        Mon, 02 Nov 2020 03:45:28 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id g66sm15545352wmg.37.2020.11.02.03.45.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:45:27 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net
Cc:     Lee Jones <lee.jones@linaro.org>,
        Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
        linux-wimax@intel.com, Jakub Kicinski <kuba@kernel.org>,
        Yanir Lubetkin <yanirx.lubetkin@intel.com>,
        netdev@vger.kernel.org
Subject: [PATCH 06/30] net: wimax: i2400m: fw: Fix some function header misdemeanours
Date:   Mon,  2 Nov 2020 11:44:48 +0000
Message-Id: <20201102114512.1062724-7-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102114512.1062724-1-lee.jones@linaro.org>
References: <20201102114512.1062724-1-lee.jones@linaro.org>
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

Cc: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
Cc: linux-wimax@intel.com
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Yanir Lubetkin <yanirx.lubetkin@intel.com>
Cc: netdev@vger.kernel.org
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

