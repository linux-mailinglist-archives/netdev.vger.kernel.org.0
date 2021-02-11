Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ACAB319318
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 20:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbhBKT25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 14:28:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbhBKT2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 14:28:54 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAB54C061574;
        Thu, 11 Feb 2021 11:28:13 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id y11so6247825otq.1;
        Thu, 11 Feb 2021 11:28:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=X4RFIz1nlMIjFLH1ggjBq6W1dxoK55qBUpVsNZEKh9M=;
        b=DpFII89clys+NQIUdMXeGd4fyQOmO3tCHTi0rLcA4ChLAoyIPuWBZ9fzAv1+6W/vUN
         03/1qVTjFyI0lLQ+fYA7/P6F7q10H19/wWpsW03TtpXR5SnAU3UQzU7/sVPVjqgdmaEu
         NCHs1hnPhteIE3PzyhpRIJNkoRz3PKTZgB6ACblqqlD41anQx4to1F2PsjRNndRucDjv
         gteDElqJ7vr1cJ3mfccAU6qelmuBSseson4cKIop5OPEIJDPtiqeRVNXD6lSBfArOlqY
         jEgNH9fK9JTzNv+lBLhPXGPr7Q7aTIQw3Dgdq07NlPl1Rn6wlACXytcTgF/59PLTfqrA
         1AmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=X4RFIz1nlMIjFLH1ggjBq6W1dxoK55qBUpVsNZEKh9M=;
        b=dCkM7vPJ3zO46CAULAftYc85IGf1FBYUWKgLYLisbTZk+Hl0gBl+Z5NlYj0qSvThr3
         rCyp9WyoXlihomtdKyauffQ+KZzUAMhYJQItYNLNxKkggBq0y3XsKVjqK0cUUfq7aJU3
         sNGCzkaak/ZdKjU7e8bu8R5OpG2SU1xjCSzCz6gABG7LBoQ2W0m/yuCVwoHn22ooysJA
         5Mm20pV3tYM4ohdhzK4zJpeGPjg8RrZ23G0vJfrpIu4ZZUIR4BQVDpngGhVhoxixP2Aa
         CnSGb54NU4k6lO5NaEvP9k5y0uMJSo5il8xsvO1Mk70Sff3XEYBnR4wBaAM5jZuIodfB
         qxmg==
X-Gm-Message-State: AOAM533v77srG5Pk+xsYuuS8sehm7xdxJkpcjUwm22pzGH+9PH1dL3iG
        69cfAdsrMVh/DVJJWvDl4ERyhmylFJLXiRxn
X-Google-Smtp-Source: ABdhPJx/lkEKDmCSPq0zkGUazOSZ6ZLpbb2oDgPhYFVer/tMKrRzMVwPj/bDco/DhZ/9mL8T1HPCrA==
X-Received: by 2002:a9d:4c94:: with SMTP id m20mr6845758otf.294.1613071693244;
        Thu, 11 Feb 2021 11:28:13 -0800 (PST)
Received: from proxmox.local.lan (2603-80a0-0e01-cc2f-0226-b9ff-fe41-ba6b.res6.spectrum.com. [2603:80a0:e01:cc2f:226:b9ff:fe41:ba6b])
        by smtp.googlemail.com with ESMTPSA id c17sm1163975otp.58.2021.02.11.11.28.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 11:28:12 -0800 (PST)
From:   Tom Seewald <tseewald@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     tseewald@gmail.com, netdev@vger.kernel.org,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] staging: qlge: Remove duplicate word in comment
Date:   Thu, 11 Feb 2021 13:27:21 -0600
Message-Id: <20210211192721.17292-1-tseewald@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix this typo by simply removing the duplicate 'and'.

Signed-off-by: Tom Seewald <tseewald@gmail.com>
---
 drivers/staging/qlge/qlge_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index dfe8cdf38ce0..5516be3af898 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -3182,7 +3182,7 @@ static void qlge_enable_msix(struct qlge_adapter *qdev)
 		     "Running with legacy interrupts.\n");
 }
 
-/* Each vector services 1 RSS ring and and 1 or more
+/* Each vector services 1 RSS ring and 1 or more
  * TX completion rings.  This function loops through
  * the TX completion rings and assigns the vector that
  * will service it.  An example would be if there are
-- 
2.20.1

