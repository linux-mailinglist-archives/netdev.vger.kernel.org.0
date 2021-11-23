Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8AD459ED0
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 10:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232901AbhKWJHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 04:07:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232331AbhKWJHm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 04:07:42 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD423C061574;
        Tue, 23 Nov 2021 01:04:34 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id i12so18018782wmq.4;
        Tue, 23 Nov 2021 01:04:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ppn9KYLUktOj/QHnYjHMY0C4/1wB69v7mQXRVYA/g4Y=;
        b=o3yiz6KS56n1KvcbD4V90lY6AM4keEqI3UDlSmzQaVjXaoLrNS+emTSeQrwYZjIRqU
         Zv9QRPk6/0GrzsdELd6pup67/1OV/OacG95FwvFcVVRwr4SMAGHr1yHoDyIgGwy4B/9d
         YP0HVqeAmGfH7z9/iZ85Q/9fqBBcRzbw7Lo2m1DMV8hOQsz55KKV1rHivN4DbadDBgsu
         iaKI3K0M4iW9HK4vHigm2KFRgkhdSZrkI9/jbYBVWGWMw63dSDQHMr7o+8RhgSyjDZDG
         WP9/qiZBMcpVutKsp079TQMn664M4KjrQdagy0F2+cCLpHW/wdH7v9Rc5P3tNNSruzhM
         WN4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ppn9KYLUktOj/QHnYjHMY0C4/1wB69v7mQXRVYA/g4Y=;
        b=Im5QY2qnZPfPDSF9HY+6Z26PoKTaWdAV46xXUakDk7Bc6Tak8X2lrpdkso1xwLL70t
         WjPndDRJm/0W3mFqYa+7wOF1T6KYgQCoerfaCxmbcDTZ8q3sOcAQmvq4uLEsgs3nHRTZ
         gqEE7x8NN8I6ifU4Ab71O4IxJLLWkN35/tDrf+SpIsfjIv3rdXlzmEERLYrSjAGQOdCG
         W9Bpr7gektJnm8lSRPKlqUM3AQdz+AnYQZpdkVspqA0d4LfxEO0hljhRUEmYvAcmGeNg
         W7PKqvpdLAaQNn8HY7co5TNpGYueVmziydayFW6a9VyP5XwmVsj1Tkm/fqJ3scbAEKqJ
         E1FA==
X-Gm-Message-State: AOAM530YJ0g0XNoLdxr4ErjZeTOp8bPc9TMWGAHA7EDVFmV5eSIi0m8H
        UXNHV6NBhWBVTA==
X-Google-Smtp-Source: ABdhPJzScrp7Z8emr48dP+PHr9nk5Cky63LWRFXInhaHtMM5KV1lgpMtaaQwqIpZ58OCN6mnNdyPKA==
X-Received: by 2002:a05:600c:2242:: with SMTP id a2mr1025016wmm.141.1637658273393;
        Tue, 23 Nov 2021 01:04:33 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id t8sm532590wmq.32.2021.11.23.01.04.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 01:04:32 -0800 (PST)
From:   Colin Ian King <colin.i.king@googlemail.com>
X-Google-Original-From: Colin Ian King <colin.i.king@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ath11k: Fix spelling mistake "detetction" -> "detection"
Date:   Tue, 23 Nov 2021 09:04:31 +0000
Message-Id: <20211123090431.165103-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a spelling mistake in an ath11k_warn message. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/wireless/ath/ath11k/wmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index 614b2f6bcc8e..24b74a373df8 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -3506,7 +3506,7 @@ ath11k_wmi_obss_color_collision_event(struct ath11k_base *ab, struct sk_buff *sk
 	case WMI_BSS_COLOR_FREE_SLOT_AVAILABLE:
 		break;
 	default:
-		ath11k_warn(ab, "received unknown obss color collision detetction event\n");
+		ath11k_warn(ab, "received unknown obss color collision detection event\n");
 	}
 
 exit:
-- 
2.32.0

