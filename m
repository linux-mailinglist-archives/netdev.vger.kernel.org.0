Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB09311C47E
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 05:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727669AbfLLEAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 23:00:16 -0500
Received: from a27-55.smtp-out.us-west-2.amazonses.com ([54.240.27.55]:48888
        "EHLO a27-55.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726769AbfLLEAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 23:00:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1576123215;
        h=From:To:Cc:Subject:Date:Message-Id;
        bh=nFrIny+goxoJPzm1Wlqh/x57XfeOjZOQ5yYlxMFgxX0=;
        b=PouoISoe+IjXwCqbWyNcIKrjWPw6XlRtOw0sPyVKEkB17Zc5wMpTRj6fHkXZN6bf
        bXE0YxzT/hosOwwecfjoNHHH18rkw0TjC8B0DdbEgQ651uu+82VgacbwdQpfnsv/5Fk
        RoTCGUypogCEjUbOyNzT8wIcznf1WTADKK4o21AY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1576123215;
        h=From:To:Cc:Subject:Date:Message-Id:Feedback-ID;
        bh=nFrIny+goxoJPzm1Wlqh/x57XfeOjZOQ5yYlxMFgxX0=;
        b=BvaabkP6YAKhL8itjzTb4uyEfZTf6Ntq6UY1UdWVgIL4TwujpVOP0I6dx/rImDde
        g0ydsF2RaPwsQRA040iLVM2wsIGeBPHiEOaotXDQsq16cIypAD/wqEb2WlAgE6GgHWo
        tG+MRckf+ged52VOjNZWYCeRQ2euBL2zwpOCqzB0=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D17A9C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=subashab@codeaurora.org
From:   Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Sean Tranchetti <stranche@codeaurora.org>
Subject: [PATCH net-next] MAINTAINERS: Add maintainers for rmnet
Date:   Thu, 12 Dec 2019 04:00:15 +0000
Message-ID: <0101016ef843ac7a-9e999ba4-e595-43dc-8646-9fa3959fa4b8-000000@us-west-2.amazonses.com>
X-Mailer: git-send-email 1.9.1
X-SES-Outgoing: 2019.12.12-54.240.27.55
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add myself and Sean as maintainers for rmnet driver.

Signed-off-by: Sean Tranchetti <stranche@codeaurora.org>
Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
---
 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index a28c77e..2489e9d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13708,6 +13708,15 @@ L:	linux-arm-msm@vger.kernel.org
 S:	Maintained
 F:	drivers/iommu/qcom_iommu.c
 
+QUALCOMM RMNET DRIVER
+M:	Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
+M:	Sean Tranchetti <stranche@codeaurora.org>
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	drivers/net/ethernet/qualcomm/rmnet/
+F:	Documentation/networking/device_drivers/qualcomm/rmnet.txt
+F:	include/linux/if_rmnet.h
+
 QUALCOMM TSENS THERMAL DRIVER
 M:	Amit Kucheria <amit.kucheria@linaro.org>
 L:	linux-pm@vger.kernel.org
-- 
1.9.1

