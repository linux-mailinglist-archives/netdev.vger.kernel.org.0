Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 751E6469143
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 09:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238980AbhLFIR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 03:17:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238981AbhLFIR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 03:17:27 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DBD1C0613F8;
        Mon,  6 Dec 2021 00:13:59 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id j6-20020a17090a588600b001a78a5ce46aso10232318pji.0;
        Mon, 06 Dec 2021 00:13:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n11Fgm6HIUp815Ejz6fy/o0RkksnlLFrEoqWKlN2XYk=;
        b=VU+cLiPDtOCoS/xVmYT97UFygNNSc4U6aqdqobLAkb4lCYK//E3Hl+VxIltV4C2y9o
         6GGIrTtY5nns06bOP1w/yefcuGm8oT9p4iOywsbHXy2UfLk6QqcVZpGMeCCazZSS7fqq
         rv8t8NNFfCbyCh8seI0xIpDTYUYzSGHc+eQ/cqh5Wx8DB17QXQTV5yaCTbA3D1vUMq8H
         ThhiFfb7RVf7D6+HhMJ4LG4XRtbaP8YKIC3OANpK+w5s8lZ0OpZoYUmWUQ82toK9uWMZ
         hEt9erY2X3djJVzwxhxFJDZ8NVMA3A4tNx6OC8dL13FsEksOHdyDmfoveur7kW3pzAC8
         DJbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n11Fgm6HIUp815Ejz6fy/o0RkksnlLFrEoqWKlN2XYk=;
        b=qpUB1xEajmE8X336VOwH5gRkJnpGwPCoHj8tti3QYzBmyINFmZcghu2CAnWFTA5P3x
         896O7A3mJlauTqcUsgmaNrMT56ndrBMzTm+AefMK+Ikm665CoHNdMOScHqWpKvKLdvQX
         Jc//g674s9Ox6fcBbeNoJHiGRwQko558luyVpAb3QVqA0Rq1Expn5eE9jfBihB3d8Nus
         CkeAJskSdLijMb10orXbxOV8V6v4P0grED/dcv83A4yce0MOhrEzgc+DD6kriQYuCglc
         2sOXKwJRTiWULzocTndJH6bNEVO08AEpi5GEj5P1nwr+qx2ndfOGveEuCpnL63Uc0D9t
         kpjg==
X-Gm-Message-State: AOAM532zbx2N+TYkkUxx4MCFEoyKawaR6I9vefwidWzrhcIZ8X49LZT8
        Smtd4V4OjOxJKXUTvFo0Bm0=
X-Google-Smtp-Source: ABdhPJzTrNZVBrRh9dvsw5yjQNmgqDCjeZAPACDoo1pJUVbAVf35Du8+utsdIuVjPL0qI5R2BFVGuw==
X-Received: by 2002:a17:90b:1d81:: with SMTP id pf1mr36092946pjb.134.1638778439085;
        Mon, 06 Dec 2021 00:13:59 -0800 (PST)
Received: from localhost.localdomain ([8.26.182.175])
        by smtp.gmail.com with ESMTPSA id 95sm8999332pjo.2.2021.12.06.00.13.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 00:13:58 -0800 (PST)
From:   Yanteng Si <siyanteng01@gmail.com>
X-Google-Original-From: Yanteng Si <siyanteng@loongson.cn>
To:     akiyks@gmail.com, linux@armlinux.org.uk
Cc:     Yanteng Si <siyanteng01@gmail.com>, andrew@lunn.ch, corbet@lwn.net,
        chenhuacai@kernel.org, hkallweit1@gmail.com,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        Yanteng Si <siyanteng@loongson.cn>
Subject: [PATCH v2 1/2] net: phy: Remove unnecessary indentation in the comments of phy_device
Date:   Mon,  6 Dec 2021 16:12:27 +0800
Message-Id: <df98d3b985891670acec5dd2a398837336aeffeb.1638776933.git.siyanteng@loongson.cn>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1638776933.git.siyanteng@loongson.cn>
References: <cover.1638776933.git.siyanteng@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yanteng Si <siyanteng01@gmail.com>

Fix warning as:

linux-next/Documentation/networking/kapi:122: ./include/linux/phy.h:543: WARNING: Unexpected indentation.
linux-next/Documentation/networking/kapi:122: ./include/linux/phy.h:544: WARNING: Block quote ends without a blank line; unexpected unindent.
linux-next/Documentation/networking/kapi:122: ./include/linux/phy.h:546: WARNING: Unexpected indentation.

Signed-off-by: Yanteng Si <siyanteng@loongson.cn>
---
 include/linux/phy.h | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index 1e57cdd95da3..6de8d7a90d78 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -538,11 +538,12 @@ struct macsec_ops;
  * @mac_managed_pm: Set true if MAC driver takes of suspending/resuming PHY
  * @state: State of the PHY for management purposes
  * @dev_flags: Device-specific flags used by the PHY driver.
- *		Bits [15:0] are free to use by the PHY driver to communicate
- *			    driver specific behavior.
- *		Bits [23:16] are currently reserved for future use.
- *		Bits [31:24] are reserved for defining generic
- *			     PHY driver behavior.
+ *
+ *      - Bits [15:0] are free to use by the PHY driver to communicate
+ *        driver specific behavior.
+ *      - Bits [23:16] are currently reserved for future use.
+ *      - Bits [31:24] are reserved for defining generic
+ *        PHY driver behavior.
  * @irq: IRQ number of the PHY's interrupt (-1 if none)
  * @phy_timer: The timer for handling the state machine
  * @phylink: Pointer to phylink instance for this PHY
-- 
2.27.0

