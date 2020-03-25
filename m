Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F07E191F06
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 03:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727402AbgCYC1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 22:27:10 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:10432 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727392AbgCYC1J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 22:27:09 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1585103229; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=USZAk4RWfl+3BaGnO6xeQNGm9pJfXCrGQM3bHgH2TZ0=; b=KbucerorGN47MqNa8ZSXX4R7QdPhSYUSIN8FEdIR7QZ/PKqFfj/fb52JAcqBHCfKxStyhQkM
 sYt0oKTVyJV7dH1s9pO3MMATVxWbz4wjzG6Z6ZZ5IvL0t/NAWrdGNtTu7GA7ewi8LOtPz3Dq
 fYPjjOx9f3rpQY62M4WZYxUF++o=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e7ac17c.7fa599f24c38-smtp-out-n02;
 Wed, 25 Mar 2020 02:27:08 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4607AC44788; Wed, 25 Mar 2020 02:27:07 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.0
Received: from localhost.localdomain (unknown [112.64.2.157])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: rjliao)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 08E52C433BA;
        Wed, 25 Mar 2020 02:27:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 08E52C433BA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=rjliao@codeaurora.org
From:   Rocky Liao <rjliao@codeaurora.org>
To:     robh+dt@kernel.org, mark.rutland@arm.com, marcel@holtmann.org,
        johan.hedberg@gmail.com, thierry.escande@linaro.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, bgodavar@codeaurora.org,
        c-hbandi@codeaurora.org, hemantg@codeaurora.org, mka@chromium.org,
        Rocky Liao <rjliao@codeaurora.org>
Subject: [PATCH v2 2/2] dt-bindings: net: bluetooth: Add device tree bindings for QCA chip QCA6390
Date:   Wed, 25 Mar 2020 10:26:38 +0800
Message-Id: <20200325022638.14325-2-rjliao@codeaurora.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200325022638.14325-1-rjliao@codeaurora.org>
References: <20200314094328.3331-1-rjliao@codeaurora.org>
 <20200325022638.14325-1-rjliao@codeaurora.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds compatible string for the QCA chip QCA6390.

Signed-off-by: Rocky Liao <rjliao@codeaurora.org>
---

Changes in v2: None

 Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt b/Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt
index beca6466d59a..badf597c0e58 100644
--- a/Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt
+++ b/Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt
@@ -13,6 +13,7 @@ Required properties:
    * "qcom,wcn3990-bt"
    * "qcom,wcn3991-bt"
    * "qcom,wcn3998-bt"
+   * "qcom,qca6390-bt"
 
 Optional properties for compatible string qcom,qca6174-bt:
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project
