Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 718874B46FF
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 10:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245257AbiBNJo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 04:44:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244824AbiBNJo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 04:44:27 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B0DA6D19B;
        Mon, 14 Feb 2022 01:38:12 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id v12so25826263wrv.2;
        Mon, 14 Feb 2022 01:38:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FwbcItNcsm7dTxEvHbAh6CvI7B2XT+qjV62cTTFagwM=;
        b=Wxl6CgXnSUYOyv/ar/mxtQlrXLh8EkeQAWWUad/KB2GpooYqEDig6Whv+L1vujQ/Cv
         nXShHlHkx+nP6XkAZXx01VOX8xuWX6val0flPOygMlds+P99XX22X3o6aGuML35xA/y8
         WnqMaTdVdUMVK/qdv+cAXfpO2fvbgkLWEIWlRTdKO7ziHnf0KWCRo4AEj0Jt9kjnAEZU
         1JRIFGuL6+DQ2sUyq4+cmVdTPm2chhpHQRwYURsTqzVLOunL5ezIiEedzv7jKMogU+UL
         Uzpqiji2BoveSh/Gwh0uTkyPSB7ovGn7tjtwZe4Xtf2ansjkSciYeJOuoccTm8nIsDPg
         YlqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FwbcItNcsm7dTxEvHbAh6CvI7B2XT+qjV62cTTFagwM=;
        b=gy7KkrniwE63igaSRUiBsK9QyTNFLOzrq2BJKqnZvU/Lo/5BqMeGCiawtsBVzTTohR
         gFXbOhuc3bSFRH7Dmjcp38Hx7nprtCeLRhgF3bFrCZVlrxT17qQ9qQMXPc49bnCBmAcH
         pHMXlKuzfl2XNt+kHYQgCvIssWqEksSOdN3tKHzRIlHHN4CZp6xKlWZqUKLHcnIrKFTB
         3/ncfFs5m7ZnvKBDjdsjUu5idSuafB0ajdw73/gjruRlE8sQvrRxWQEDUdk+3p4iqAeb
         sivm+m1R1KmbTsMEaHxulQ+XuJldp2T8att3ll9Z0X8MbV2a3H6mQo3nzewCDtbc6Jns
         RkGQ==
X-Gm-Message-State: AOAM5328AaivoWRvuDyZiyb7d5rqYD5yDzFW9XrPvtcuxLjX0P+A777N
        h5Pw84YtV233Xoa7fPHbyHg=
X-Google-Smtp-Source: ABdhPJxCUP1Y6OAuh3WjUMVMTHkWbPFYNV6VCirBHLjl5MEXY+oDXSnD8aIzgRd4bO8NRi3OukbljA==
X-Received: by 2002:a5d:6888:: with SMTP id h8mr10351125wru.57.1644831491109;
        Mon, 14 Feb 2022 01:38:11 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id t18sm30595213wri.34.2022.02.14.01.38.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 01:38:10 -0800 (PST)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] selftests: net: cmsg_sender: Fix spelling mistake "MONOTINIC" -> "MONOTONIC"
Date:   Mon, 14 Feb 2022 09:38:10 +0000
Message-Id: <20220214093810.44792-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a spelling mistake in an error message. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 tools/testing/selftests/net/cmsg_sender.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/cmsg_sender.c b/tools/testing/selftests/net/cmsg_sender.c
index 24444dc72543..efa617bd34e2 100644
--- a/tools/testing/selftests/net/cmsg_sender.c
+++ b/tools/testing/selftests/net/cmsg_sender.c
@@ -341,7 +341,7 @@ int main(int argc, char *argv[])
 	if (clock_gettime(CLOCK_REALTIME, &time_start_real))
 		error(ERN_GETTIME, errno, "gettime REALTIME");
 	if (clock_gettime(CLOCK_MONOTONIC, &time_start_mono))
-		error(ERN_GETTIME, errno, "gettime MONOTINIC");
+		error(ERN_GETTIME, errno, "gettime MONOTONIC");
 
 	iov[0].iov_base = buf;
 	iov[0].iov_len = sizeof(buf);
-- 
2.34.1

