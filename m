Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E167C47AD77
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 15:53:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237534AbhLTOwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 09:52:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238273AbhLTOuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 09:50:23 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BDD2C08EA73
        for <netdev@vger.kernel.org>; Mon, 20 Dec 2021 06:46:22 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id o10so9529744qvc.5
        for <netdev@vger.kernel.org>; Mon, 20 Dec 2021 06:46:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z6tliMnyhJ1OU6veIIRTxo0vN8f5agJ/oQ8/z3fOZwM=;
        b=iNGokSc7XHPCOi/lvRBMtP2Htlw6qPevzIeete3ecngFjMGTf7hJJ8uTN3WBrrr9hk
         e2a7i7k6TqUV85jBtsMh1ww34Z1GxcGXCOwnZqTRwFRjRBYo/ZgC6RY1bNTdizHx31iM
         yWVrL2uB+cy8HRa7s8cN9vRHOrEe1l8ZtzOfKiZwDOKOJXA4aEBrNUjq2PZTjSjHJnlT
         kDgoXTwgIcCykBJ5Es+vVBXwWsJ/PQn+f1cfA2SUm8je+dGzPk5+waK+lYqNfZcir5BM
         KuM9oKDQxTFUTcUlcelZPl6VlHbZTE3Uz1ySs98dVvfi3fnC4+GwlRpigyW4joSEUc40
         a4QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z6tliMnyhJ1OU6veIIRTxo0vN8f5agJ/oQ8/z3fOZwM=;
        b=K0+meYIrONnCSiDAwtkNngGJDtC7kQehlVgYeZ0x4R/ZcGpFddGjf8miyfuvXLrMx8
         JHjG6PwAhYzo+nuLkeCtMELQsDCogNb18fyFPuw1H3J+CsL5Po1iJkMkYDUfyKdQrvgV
         p00cDYPck/VQXqXGi2TVpVPL6mYqyKb7qEPh2BgUA1qkGNidjfzvpkiTXulx/afvoQZm
         XmU07/IyybxPGOmfEj0iyW6gJuV2geExFkk5ezKb3Y5quWBoDmlfKawTOPTUJfqLjZWh
         U6FKnPpp5+C28ALXrACOk+SHgUJo32NcABNMEOGo0etEYxB+j8FxDM4gN/78/sZ/6WcL
         ESYg==
X-Gm-Message-State: AOAM532zRAYhRyCUcKpo3X4ZT1QZD/W2sl+Q1smbleGIegHp1vxnZT5l
        Wy2fqolVqnjvxgdqVsJLdXKomzv9IPM=
X-Google-Smtp-Source: ABdhPJwmyf/iHbiIT3AhZyj5FPwo4bdaVcIKQlyJChEBxLlEDA5iXEdlH+QaEQ8wk1AKNlVqbRWQ2Q==
X-Received: by 2002:ad4:5bca:: with SMTP id t10mr12986701qvt.35.1640011581289;
        Mon, 20 Dec 2021 06:46:21 -0800 (PST)
Received: from willemb.c.googlers.com.com (55.87.194.35.bc.googleusercontent.com. [35.194.87.55])
        by smtp.gmail.com with ESMTPSA id l2sm14769163qtk.41.2021.12.20.06.46.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 06:46:20 -0800 (PST)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, patrick.ohly@intel.com,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net] docs: networking: replace skb_hwtstamp_tx with skb_tstamp_tx
Date:   Mon, 20 Dec 2021 09:46:08 -0500
Message-Id: <20211220144608.2783526-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

Tiny doc fix. The hardware transmit function was called skb_tstamp_tx
from its introduction in commit ac45f602ee3d ("net: infrastructure for
hardware time stamping") in the same series as this documentation.

Fixes: cb9eff097831 ("net: new user space API for time stamping of incoming and outgoing packets")
Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 Documentation/networking/timestamping.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/timestamping.rst b/Documentation/networking/timestamping.rst
index 80b13353254a..f5809206eb93 100644
--- a/Documentation/networking/timestamping.rst
+++ b/Documentation/networking/timestamping.rst
@@ -582,8 +582,8 @@ Time stamps for outgoing packets are to be generated as follows:
   and hardware timestamping is not possible (SKBTX_IN_PROGRESS not set).
 - As soon as the driver has sent the packet and/or obtained a
   hardware time stamp for it, it passes the time stamp back by
-  calling skb_hwtstamp_tx() with the original skb, the raw
-  hardware time stamp. skb_hwtstamp_tx() clones the original skb and
+  calling skb_tstamp_tx() with the original skb, the raw
+  hardware time stamp. skb_tstamp_tx() clones the original skb and
   adds the timestamps, therefore the original skb has to be freed now.
   If obtaining the hardware time stamp somehow fails, then the driver
   should not fall back to software time stamping. The rationale is that
-- 
2.34.1.173.g76aa8bc2d0-goog

