Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA52238E0
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 15:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388821AbfETNyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 09:54:24 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:37865 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390351AbfETNyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 09:54:09 -0400
Received: by mail-io1-f65.google.com with SMTP id u2so11084718ioc.4
        for <netdev@vger.kernel.org>; Mon, 20 May 2019 06:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KapGiunwwx5p5z/8cIELmJy7chJVMEDGUUi3pAZirR8=;
        b=yzkpmxk6Ixt7Vl80qvoHTPb21ID7tx7gUl5mLADJHRIA+mwJh+3RgoLGGk3FLTk54T
         YiScf7OxLAxGZZO9LC3+c8gtM0a7Ny2oW1diBfNo/KFgJgeeoC6QMtMvwqVezCPM64Mp
         Vqa2IRutPqE8aDKy5pSCg0SoCU7x3XEmR9EhpHbWBcQfO0t7f0HIZTkPOFFny9fs2ft/
         SubZ6bAz3fd+WTZssKs0U/8XN4Bvy28hyjoIYHIsrx1TFdoJk2enr7kbvfSS3KDsuUkm
         SnglFiYSqw9p+9YZ7rokP3YXlNVR+BjVzrA4BlMeUzKXro+jzAtArTeK6j2I5+Cf7jRR
         miAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KapGiunwwx5p5z/8cIELmJy7chJVMEDGUUi3pAZirR8=;
        b=SWV8vB19P13tPiDINpYshWsalCwnRkNF5s0/BayHWdC76b/ZPKPEkF+jOeZ1KmXGcm
         y31G78HlKhIdGnsj7xj1oDUu1W22sVrDYLgRNfHMzI2pv20W/bPYrzC/NUm7VC0Gj1yU
         zfvqdRWOls6acdVHZ4Kw0EKQzjE4evZ6ieh1CXUEjlltdyp8kOwmeeXhkjGVQI0M11M9
         Ytwv8SaPL589Mwcy1oxoBXHoc3RZPx+9OOhiZXFpkW0PknHlUxuP4gpnAREp4fPdX/pI
         fzUnHVQQDs9viK5pB1d/xfoLO3wM7Q1wL2VERcDVBFrCt5XhDQeGoZxyKzGUCHOWx1rH
         wgvw==
X-Gm-Message-State: APjAAAXDxxkL5fSxB4Ibd9kbS2+3DaqsVOacJ25t27QaXsqEjuk6bnzT
        FuzsJ4gSbaXl/Dr//zaHNqaJWw==
X-Google-Smtp-Source: APXvYqwP2yeMVfgpj5IAJSVo21lcBFOvcGIwfuZQCYo5tTMis4c0FbPs3j4lcwnYFd0aeSJGTibCsQ==
X-Received: by 2002:a6b:f404:: with SMTP id i4mr7597663iog.251.1558360449000;
        Mon, 20 May 2019 06:54:09 -0700 (PDT)
Received: from localhost.localdomain (c-71-195-29-92.hsd1.mn.comcast.net. [71.195.29.92])
        by smtp.gmail.com with ESMTPSA id n17sm6581185ioa.0.2019.05.20.06.54.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 06:54:08 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     arnd@arndb.de, subashab@codeaurora.org, david.brown@linaro.org,
        agross@kernel.org, davem@davemloft.net
Cc:     bjorn.andersson@linaro.org, ilias.apalodimas@linaro.org,
        cpratapa@codeaurora.org, syadagir@codeaurora.org,
        evgreen@chromium.org, benchan@google.com, ejcaruso@google.com,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] net: qualcomm: rmnet: mark endianness of struct rmnet_map_dl_csum_trailer fields
Date:   Mon, 20 May 2019 08:53:53 -0500
Message-Id: <20190520135354.18628-8-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190520135354.18628-1-elder@linaro.org>
References: <20190520135354.18628-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two 16-bit fields (csum_start_offset and csum_length) in the
rmnet_map_dl_csum_trailer structure are currently defined to have
type u16.  But they are in fact big endian values, so should be
properly represented as __be16 values.

No existing code actually references these fields (they're ignored by
rmnet_map_ipv4_dl_csum_trailer() and rmnet_map_ipv6_dl_csum_trailer()).
Changing their type therefore causes no harm, so just fix them.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
index fb1cdb4ec41f..775b98d34e94 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
@@ -52,8 +52,8 @@ struct rmnet_map_header {
 struct rmnet_map_dl_csum_trailer {
 	u8  reserved1;
 	u8  flags;		/* RMNET_MAP_DL_* */
-	u16 csum_start_offset;
-	u16 csum_length;
+	__be16 csum_start_offset;
+	__be16 csum_length;
 	__be16 csum_value;
 } __aligned(1);
 
-- 
2.20.1

