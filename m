Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 416DB27A28D
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 21:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgI0TZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 15:25:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbgI0TZZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 15:25:25 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEFAFC0613CE;
        Sun, 27 Sep 2020 12:25:24 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id m6so9578445wrn.0;
        Sun, 27 Sep 2020 12:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ib+m1upj1my5VACm4oUnf3b2Tj68EgFVrf7eXMZTHfA=;
        b=UREkh7q3a8XqC4vMjYLUHU5B32+ZhtSg5kKiGrLc07GE7sLvYFIdVIlJeBSqeeuTls
         0T780VdBWvd35udo+spI2djY5UoRW1Xd5Y/9ARKtP5WnutErh9Vt6ThsxUPJFftqVjJ4
         /VMcOxAzbZz0Nr4r+5XESrhhujkB5RUdyPZcj1GfWkCnmQzJC+o1AR3AbdpiWBqT2uXg
         Wx5Ct3l9T2bzfQGB4pQoVCQaTwaGePQiW4bT85Ba05n1HpeljR7EwZzXV+Xelztm4h5v
         JLeB2gc1K0zy94ik6bFrc0qBmZPoVDvkZX4dt70xmAneufhgVy9SCytuGIFeMfET8HeZ
         mPsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ib+m1upj1my5VACm4oUnf3b2Tj68EgFVrf7eXMZTHfA=;
        b=IE7Dbiyv2p4vgaI41EtrFPWXw1bUSti2VHYlg47ZwuGcZqZ3j8ssOjrdi0EElbTwOT
         dfVgjEGlzQ0JmogZaEjjVi92vkJzEqg/ZcvRl3MmajZufrEpvg1TX6n2k327qy2h5m4k
         1q8U6Y0IvXWhT88J9jb3le+ukzw2hB1adq9QrQ86Oejke3EGAZXWZCQYw+5TAF48w9e/
         G6+rM81vQgVXq28RxblqhXRvO06dNwvI0lnt7urzf8vuVOqKxg+HeCXDOvxEzQ2MQwgn
         Wi/etJI69sqg6Yu9IMngdsA/fpMgzkudPAk5Qoq8HRvpoyaWFMrOiGFY9ArAm37KSbP+
         HDFA==
X-Gm-Message-State: AOAM532QMdH1HJrpiWfSsy8aswsaDonTUyMKmjcbyAIC7+A/wRahc8tZ
        6QnTVMA13HojXCszuBub/48=
X-Google-Smtp-Source: ABdhPJwUUM/a/0bM09qKLhuI3meVRyIGzKoPK8GfrgyIMYu0sDQyWDYEeuVS+sSDhGeI1KsJ1SCC6w==
X-Received: by 2002:adf:9043:: with SMTP id h61mr3933615wrh.237.1601234723236;
        Sun, 27 Sep 2020 12:25:23 -0700 (PDT)
Received: from Ansuel-XPS.localdomain (93-39-149-95.ip76.fastwebnet.it. [93.39.149.95])
        by smtp.googlemail.com with ESMTPSA id w21sm6398106wmk.34.2020.09.27.12.25.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2020 12:25:22 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     "0001-ath10k-Try-to-get-mac-address-from-dts . patchKalle Valo" 
        <kvalo@codeaurora.org>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ath10k: Try to get mac-address from dts
Date:   Sun, 27 Sep 2020 21:25:13 +0200
Message-Id: <20200927192515.86-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most of embedded device that have the ath10k wifi integrated store the
mac-address in nvmem partitions. Try to fetch the mac-address using the
standard 'of_get_mac_address' than in all the check also try to fetch the
address using the nvmem api searching for a defined 'mac-address' cell.
Mac-address defined in the dts have priority than any other address found.

Tested-on: QCA9984 hw1.0 PCI 10.4

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 5f4e12196..9ed7b9883 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -8,6 +8,8 @@
 #include <linux/module.h>
 #include <linux/firmware.h>
 #include <linux/of.h>
+#include <linux/of_net.h>
+#include <linux/property.h>
 #include <linux/property.h>
 #include <linux/dmi.h>
 #include <linux/ctype.h>
@@ -2961,8 +2963,12 @@ EXPORT_SYMBOL(ath10k_core_stop);
 static int ath10k_core_probe_fw(struct ath10k *ar)
 {
 	struct bmi_target_info target_info;
+	const char *mac;
 	int ret = 0;
 
+	/* register the platform to be found by the of api */
+	of_platform_device_create(ar->dev->of_node, NULL, NULL);
+
 	ret = ath10k_hif_power_up(ar, ATH10K_FIRMWARE_MODE_NORMAL);
 	if (ret) {
 		ath10k_err(ar, "could not power on hif bus (%d)\n", ret);
@@ -3062,6 +3068,10 @@ static int ath10k_core_probe_fw(struct ath10k *ar)
 
 	device_get_mac_address(ar->dev, ar->mac_addr, sizeof(ar->mac_addr));
 
+	mac = of_get_mac_address(ar->dev->of_node);
+	if (!IS_ERR(mac))
+		ether_addr_copy(ar->mac_addr, mac);
+
 	ret = ath10k_core_init_firmware_features(ar);
 	if (ret) {
 		ath10k_err(ar, "fatal problem with firmware features: %d\n",
-- 
2.27.0

