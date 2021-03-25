Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 727E23487F0
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 05:37:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbhCYEgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 00:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbhCYEga (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 00:36:30 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46AA7C06174A;
        Wed, 24 Mar 2021 21:36:30 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id a11so836263qto.2;
        Wed, 24 Mar 2021 21:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QNLSpuaSGZ7eZE6VAXF3CpdULepYwsL40rZNMMcwrng=;
        b=KVhXXYddGdvdPW6Dii4Pagk4F2/LvqnRjvVmV2MDK+Xq5rxlBRvxxswaYcYozk+mDD
         VTj0TytRgi+15R4u0Jh2SeDZpamF76AHQJGnDG8/1pgOoXPcp41iZBCPn4kq+WDexDuQ
         ThWEPxflYbBxE5AvWdC1bfV8gY6E0u6tqgkT3kUjcHCNErkH9wo5Pl0xiWtIWKy9It6f
         rHLLcb+oESyRDKY4QgumcOL13gmM+UmwA5s9I3KTx6/WHm5fP+em+rMQLpHQolJEyNPP
         BzU+MR2WZPMmv8UfS/h/Ghekk+KNTiFFbM8HS7kDd7CZEhsZs41ZlibBa+oOYoqaF/1R
         lY5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QNLSpuaSGZ7eZE6VAXF3CpdULepYwsL40rZNMMcwrng=;
        b=C+nmmWxySYHcrUDvCORcS7sMmlbDTM+/ss+lsMpNdJm2pXp5qC9OUGd4WyJp+jtTZL
         AKXcnOJUiaJFA6DDP7Wcl1Ur/M71bJzTjz9V4ELkNDzDEAzEtwoJmQEhdehTvi1zvMNr
         csGRRh32rF5vwRjoAyY3mvVRbIbRNpl/pFpyujGTSnwnLJZ8egvr7EgYW+c0c2yqOvnM
         1/h+DDuCoV1rwrmU5veOZkJAZTrApL6pZ4jI77I8HrnqIBMbiwvbZIaGpgSUZ0AMGJMH
         gddeP/bnvnPfmHfD/7a8/3tbUpTQ97+cWn6OuALI54oMATvaljCzwDu+MVqaJPFHx57X
         /Dvg==
X-Gm-Message-State: AOAM531f/XA1fojO0zIliQD7w2/ZGLlIy1+kp920giZKaYEjAwBWy54g
        F9p0XMOw3RdoONij2irRzBc=
X-Google-Smtp-Source: ABdhPJwlIdLrbM1cFETdf6pCBkDbpOiozDh7cf3dBV+mCCaJL2XyjH0U7ti13g6V2oiPWzeGLWzTtw==
X-Received: by 2002:ac8:734c:: with SMTP id q12mr6197611qtp.160.1616646989600;
        Wed, 24 Mar 2021 21:36:29 -0700 (PDT)
Received: from Slackware.localdomain ([156.146.55.176])
        by smtp.gmail.com with ESMTPSA id 66sm3401656qkk.18.2021.03.24.21.36.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 21:36:29 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] Bluetooth: L2CAP: Rudimentary typo fixes
Date:   Thu, 25 Mar 2021 10:05:44 +0530
Message-Id: <20210325043544.29248-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


s/minium/minimum/
s/procdure/procedure/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 net/bluetooth/l2cap_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 72c2f5226d67..b38e80a0e819 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -1690,7 +1690,7 @@ static void l2cap_le_conn_ready(struct l2cap_conn *conn)
 		smp_conn_security(hcon, hcon->pending_sec_level);

 	/* For LE slave connections, make sure the connection interval
-	 * is in the range of the minium and maximum interval that has
+	 * is in the range of the minimum and maximum interval that has
 	 * been configured for this connection. If not, then trigger
 	 * the connection update procedure.
 	 */
@@ -7542,7 +7542,7 @@ static void l2cap_data_channel(struct l2cap_conn *conn, u16 cid,
 	BT_DBG("chan %p, len %d", chan, skb->len);

 	/* If we receive data on a fixed channel before the info req/rsp
-	 * procdure is done simply assume that the channel is supported
+	 * procedure is done simply assume that the channel is supported
 	 * and mark it as ready.
 	 */
 	if (chan->chan_type == L2CAP_CHAN_FIXED)
--
2.30.1

