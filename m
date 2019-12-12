Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE7511C5D5
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 07:08:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727962AbfLLGIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 01:08:34 -0500
Received: from a27-55.smtp-out.us-west-2.amazonses.com ([54.240.27.55]:60456
        "EHLO a27-55.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726784AbfLLGIe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 01:08:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1576130913;
        h=From:To:Cc:Subject:Date:Message-Id;
        bh=Msv++6Uc9+j+ovRizdCpCJpui0/hXtGDn0hO1MZQkrU=;
        b=ZwaDYbcvEsy+DFDpkuRA/7ulcnIspIwCKOoCicOTgjnG4BabNwVOtjG5G8fey8iL
        qNXSRmFwox7jZVJYIpoHWQIjO681w49bj3B+ssprihr8dGSQ9GhpLXUdFvm5zWFz/Le
        JN5nGMSmyejgZAlgWT+Jft4ZQnTi5uRnqdrXhXI0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1576130913;
        h=From:To:Cc:Subject:Date:Message-Id:Feedback-ID;
        bh=Msv++6Uc9+j+ovRizdCpCJpui0/hXtGDn0hO1MZQkrU=;
        b=NsLPmDQ0cIwLXksQnyQ+gX1Idx6qNizULcgOnM45Q33D2cBPX/w1uoTYdjjO3uOu
        OPliurc4JbKVFhgGVgM4wdkXk09ByPsOvaJLalStOe8QPLMKlyfepSXtrtwePusBttX
        AY3htGBp/hSkZPb1fpPEdL8P1X7GuiS7q0PvUWAA=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3E68BC433A2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=rjliao@codeaurora.org
From:   Rocky Liao <rjliao@codeaurora.org>
To:     robh+dt@kernel.org, mark.rutland@arm.com, marcel@holtmann.org,
        johan.hedberg@gmail.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, bgodavar@codeaurora.org,
        Rocky Liao <rjliao@codeaurora.org>
Subject: [PATCH v1 2/2] dt-bindings: net: bluetooth: Add device tree bindings for QCA6390
Date:   Thu, 12 Dec 2019 06:08:33 +0000
Message-ID: <0101016ef8b923cf-ef36a521-9c4b-4360-842d-d641e0eaaf0e-000000@us-west-2.amazonses.com>
X-Mailer: git-send-email 2.17.1
X-SES-Outgoing: 2019.12.12-54.240.27.55
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add compatible string for the Qualcomm QCA6390 Bluetooth controller

Signed-off-by: Rocky Liao <rjliao@codeaurora.org>
---
 Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt b/Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt
index 68b67d9db63a..87b7f9d22414 100644
--- a/Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt
+++ b/Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt
@@ -10,6 +10,7 @@ device the slave device is attached to.
 Required properties:
  - compatible: should contain one of the following:
    * "qcom,qca6174-bt"
+   * "qcom,qca6390-bt"
    * "qcom,wcn3990-bt"
    * "qcom,wcn3998-bt"
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project

