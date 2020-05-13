Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BFA41D04C8
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 04:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728673AbgEMCTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 22:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728466AbgEMCTe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 22:19:34 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17DADC05BD09
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 19:19:34 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id w65so7307360pfc.12
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 19:19:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5Y23e1WcGS/7zRXLgOmzbHP/L0sZSiIPexTD/XzyCks=;
        b=iN7ylJiSjv8PKHyMFgypEVb1YjwQJf4wJFiDlQmJ5ICYyYFJv+60LNuEIWETpl3Cf4
         SHLjln9qymrA0qTvUIjYOERc3AA3mBSynP4xEN/rfnrwa0ccI5rkkb2EUP9KRZ/sugPs
         /Vz7pMmyPVQwtwGTaI50MI1Xtcjpf3gTttGwk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5Y23e1WcGS/7zRXLgOmzbHP/L0sZSiIPexTD/XzyCks=;
        b=B0bk5GxT1WsGrbGTMsX9n5oAvQMRTkpNbZDVTZeNGB0EQoOz7SWfmMPR0Pa7eCLkEt
         VS+A7sccxUVVo0H/e1dckGmoje64PN0bJnV1Ae9XAzkA22nN1rDjwiOR3gXMs1mP4rdE
         3D7EGNtsNZ1SN14FhBaXtqhBwJ2vE900zBBaZL4x6Lb0RbiQ8CriAv1VQd9di0gSnOOW
         hO+y412QXNQWcH0UBOgipWC3cO+CKEvwJQGLz5lJ+t9PRUaT8eoPbHYE+coFEP4pGJhf
         jPlvo58CaCLmvdSMXzhC5aNWiNxcWvHkfFslj8nspHy9udQM/ZUaZcrW1yG+p6xpoS+J
         egrQ==
X-Gm-Message-State: AGi0PuZnzjrtmCsxylWB21vuzYF0vV1tNzkNMwFskWuXVoILdRgARLLz
        8soOWcTWwfYENANYEwvlzgOrGQ==
X-Google-Smtp-Source: APiQypIGZMF+bReUAlPyPZkyGkptCxIQx2Cnc6lQHTEj/Z5UeI4rP7JeXxIExcBcUOvRRF7LXyNaDw==
X-Received: by 2002:a63:d24a:: with SMTP id t10mr22052326pgi.326.1589336373592;
        Tue, 12 May 2020 19:19:33 -0700 (PDT)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:e09a:8d06:a338:aafb])
        by smtp.gmail.com with ESMTPSA id w2sm14170600pja.53.2020.05.12.19.19.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 19:19:33 -0700 (PDT)
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
To:     marcel@holtmann.org, linux-bluetooth@vger.kernel.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 1/3] Bluetooth: Rename BT_SUSPEND_COMPLETE
Date:   Tue, 12 May 2020 19:19:25 -0700
Message-Id: <20200512191838.1.I14aad9cc7f34b095b49d17e8ff2688707d23ffae@changeid>
X-Mailer: git-send-email 2.26.2.645.ge9eca65c58-goog
In-Reply-To: <20200513021927.115700-1-abhishekpandit@chromium.org>
References: <20200513021927.115700-1-abhishekpandit@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Renamed BT_SUSPEND_COMPLETE to BT_SUSPEND_CONFIGURE_WAKE since it sets
up the event filter and whitelist for wake-up.

Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Reviewed-by: Alain Michaud <alainm@chromium.org>
---

 include/net/bluetooth/hci_core.h | 2 +-
 net/bluetooth/hci_core.c         | 2 +-
 net/bluetooth/hci_request.c      | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 0c7f3ad766652..869ee2b30a4c1 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -110,7 +110,7 @@ enum suspend_tasks {
 enum suspended_state {
 	BT_RUNNING = 0,
 	BT_SUSPEND_DISCONNECT,
-	BT_SUSPEND_COMPLETE,
+	BT_SUSPEND_CONFIGURE_WAKE,
 };
 
 struct hci_conn_hash {
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 51d3992732762..de1f4e72ec065 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3353,7 +3353,7 @@ static int hci_suspend_notifier(struct notifier_block *nb, unsigned long action,
 		/* Only configure whitelist if disconnect succeeded */
 		if (!ret)
 			ret = hci_change_suspend_state(hdev,
-						       BT_SUSPEND_COMPLETE);
+						BT_SUSPEND_CONFIGURE_WAKE);
 	} else if (action == PM_POST_SUSPEND) {
 		ret = hci_change_suspend_state(hdev, BT_RUNNING);
 	}
diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index 3f470f0e432c7..88941a2131c4d 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -1090,7 +1090,7 @@ void hci_req_prepare_suspend(struct hci_dev *hdev, enum suspended_state next)
 				   disconnect_counter);
 			set_bit(SUSPEND_DISCONNECTING, hdev->suspend_tasks);
 		}
-	} else if (next == BT_SUSPEND_COMPLETE) {
+	} else if (next == BT_SUSPEND_CONFIGURE_WAKE) {
 		/* Unpause to take care of updating scanning params */
 		hdev->scanning_paused = false;
 		/* Enable event filter for paired devices */
-- 
2.26.2.645.ge9eca65c58-goog

