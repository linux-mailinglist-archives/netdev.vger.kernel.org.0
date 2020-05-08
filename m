Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8301CB899
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 21:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbgEHTvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 15:51:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:59060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726767AbgEHTvt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 15:51:49 -0400
Received: from pali.im (pali.im [31.31.79.79])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A4C221841;
        Fri,  8 May 2020 19:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588967509;
        bh=OVuxbhvIBcgPH7Y4k3MgKcgqbkz0nC6rL/mG3dUjm74=;
        h=From:To:Cc:Subject:Date:From;
        b=zW7UOjMShQ7VFDxfSzaTkEdRzsFE7ct+vlTB+aXDLItfvmWcphWrIJ6zA4HCOkWr0
         WvPIDdW/c3fO/tMBlBcNIED2dpCYmtM3nMNKDhwJ+MPxiAGci+U6lyjuJrThhBJeVq
         gX2kobL5dy2G4mySR6pCYeMOhzSwZ9JtKnolJoI0=
Received: by pali.im (Postfix)
        id 350837F5; Fri,  8 May 2020 21:51:47 +0200 (CEST)
From:   =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To:     Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ipw2x00: Fix comment for CLOCK_BOOTTIME constant
Date:   Fri,  8 May 2020 21:51:39 +0200
Message-Id: <20200508195139.20078-1-pali@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Correct name of constant is CLOCK_BOOTTIME and not CLOCK_BOOTIME.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 drivers/net/wireless/intel/ipw2x00/ipw2200.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.h b/drivers/net/wireless/intel/ipw2x00/ipw2200.h
index 4346520545c4..91864e146761 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.h
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.h
@@ -1329,7 +1329,7 @@ struct ipw_priv {
 
 	s8 tx_power;
 
-	/* Track time in suspend using CLOCK_BOOTIME */
+	/* Track time in suspend using CLOCK_BOOTTIME */
 	time64_t suspend_at;
 	time64_t suspend_time;
 
-- 
2.20.1

