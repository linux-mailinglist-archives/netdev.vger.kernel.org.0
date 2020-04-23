Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 981781B51DB
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 03:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgDWBeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 21:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgDWBen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 21:34:43 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39A66C03C1AA;
        Wed, 22 Apr 2020 18:34:43 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id m2so3393745lfo.6;
        Wed, 22 Apr 2020 18:34:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SjIpWwjlKzcDo7C6DWuyOHHv+FcusMs+xC0Ay0zQfow=;
        b=cm++pq9PqU09LWqOhZICWe+XkH+rovOt0WcKcXhCkV68g2OLmySWEs8eAD81MSrcw/
         Sy8Kt5GeHkQT+OEui9SMm19xLNGepSRVK807WGewtLrKHE1zOSjA+s+KWiPo6EkRpPC1
         qUhtor3UpK+M0NTcMHR21oJ9SoAIPc4Giu2g7/xmzL+mLc30/RHTuIWT1h0de6xYI/JP
         ZeBqb3tEwDtOvrsXWJbL1tzttr9/QZtRVEdc7HGRFaNn9NuSUgLla1y+FuN5Si5WVqsX
         /0BYtRb8PYZOBVCZJ57YuqEYSVQzr6pDansJMBrdSYrQRVC2OCjdptHXIkAg2PIHg29a
         RBQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SjIpWwjlKzcDo7C6DWuyOHHv+FcusMs+xC0Ay0zQfow=;
        b=gP3ePmyxa3+/JJZs8EtCL+gYB4u7KAS9wFw4XMUkfRr2i6t93gchQdXn5XMrEVfl49
         vuKfm3L3R8eLt8adOJaJrzHMLlRtCcICy2oa5iJ8IRlEoJT0sZd3Hob55kYu8eoO5E9a
         yVl5ONCN0JuLS3PPdtKvt9N5lGlecsTsLlS56IAjrYuKYlYXDI8YaEytRJlveQC4H70c
         t+8lW6TM/p2ZO4K3yyCAerVQGyYYp+SyQsxc/xkukNaB8/nrITReZyVX0kxFLvtD2h9J
         ixG3Bd3dyW301cyZFQzDjEKw0LpSvlV1ePbquJrXXNFwnII2zAkJJwRD8J0H5pJuC0xg
         OB/w==
X-Gm-Message-State: AGi0PuZaS4XbR2Mw0Z4RsNlHHTBjxQuWKBVsxoml39hLGFDjd/PFhHPV
        Q0LmEE6GBvGv2JGWG5aVgCQ=
X-Google-Smtp-Source: APiQypIyfajWd1CR5VR7pjWZXmAEpBB85Z/O3xF0H/BMnaIMr+pEz7yjtjAH8cE9ZAsZJiENbSjegg==
X-Received: by 2002:a19:4f48:: with SMTP id a8mr815575lfk.174.1587605681743;
        Wed, 22 Apr 2020 18:34:41 -0700 (PDT)
Received: from localhost.localdomain ([87.200.95.144])
        by smtp.gmail.com with ESMTPSA id h21sm564967lfp.1.2020.04.22.18.34.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 18:34:41 -0700 (PDT)
From:   Christian Hewitt <christianshewitt@gmail.com>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Christian Hewitt <christianshewitt@gmail.com>
Subject: [PATCH v2 2/3] Bluetooth: hci_qca: add compatible for QCA9377
Date:   Thu, 23 Apr 2020 01:34:29 +0000
Message-Id: <20200423013430.21399-3-christianshewitt@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200423013430.21399-1-christianshewitt@gmail.com>
References: <20200423013430.21399-1-christianshewitt@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a compatible so QCA9377 devices can be defined in device-tree.

Signed-off-by: Christian Hewitt <christianshewitt@gmail.com>
---
 drivers/bluetooth/hci_qca.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index d0ac554584a4..072983dc07e3 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -2058,6 +2058,7 @@ static SIMPLE_DEV_PM_OPS(qca_pm_ops, qca_suspend, qca_resume);
 static const struct of_device_id qca_bluetooth_of_match[] = {
 	{ .compatible = "qcom,qca6174-bt" },
 	{ .compatible = "qcom,qca6390-bt", .data = &qca_soc_data_qca6390},
+	{ .compatible = "qcom,qca9377-bt" },
 	{ .compatible = "qcom,wcn3990-bt", .data = &qca_soc_data_wcn3990},
 	{ .compatible = "qcom,wcn3991-bt", .data = &qca_soc_data_wcn3991},
 	{ .compatible = "qcom,wcn3998-bt", .data = &qca_soc_data_wcn3998},
-- 
2.17.1

