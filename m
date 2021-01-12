Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC9EF2F2CEB
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 11:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404146AbhALKcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 05:32:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729786AbhALKcp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 05:32:45 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 449D3C061786;
        Tue, 12 Jan 2021 02:32:05 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id m6so1150573pfk.1;
        Tue, 12 Jan 2021 02:32:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WyIEw//6LTZ4+K3k1L3A+4gXmL9AEDWs69yfo4jVc/o=;
        b=b4KLR/KTlQfTCN2uxIcE9VDQgq+34FPHCsfrWruEE+CBFFZfeuezvTqd3NJJvNq4W4
         82ui9LLV1tBvIMzsDcsVntr7UmPFCnmSxG4lcUFINJ2cH00t89cwBEfMaWIWCEgaSsdq
         J1UmJ8wv/l2fQxcbubCPXRjwAksFDtRI6uqgsTfaLHltZgcVTKdHb00VQorhk/FwgrVz
         IXa2+7ADOBMxDaiGuG8AfEh6za6oF9J/EZ8pC6hA/rumcksC8nxpa6b7yeNr9pbo3I/n
         sULO9gdp+IrGQfnaKBtRvDpF0JDdJM8Bc1BTpgaCi7CWryBfzYZASd7MQ8vUeNCLk9I9
         CE9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WyIEw//6LTZ4+K3k1L3A+4gXmL9AEDWs69yfo4jVc/o=;
        b=c6PFyFsbL7jXacafM4z9IYiHoxgxW+bl4DDXNueWj7Bg4t5hHOJhbki/6S7eQYBRLp
         Eokl8s7T8obklmVj49keRFkzcScuNBVDcrAbiKWgkFK2N9fTTX3wNZLhE7R/SQcOM5nA
         N5Wj2Q4CpFF6QaJZPJP+LVLkqjmJY0A3XE1dIvRSsJ2aroRUX400FbNlwIHa1faGUFBs
         0148wiQ4qHXDcik5VD9PzsOVRmyE8B71hDH2Xkya8b3ZpSZ/vS/MD7qqIkS+O9CxNQIM
         21OaO2vEMuJOWoL6DN/xBYtBKFNcJOzdw7+wbPbXNYskFhQUkQ80/ug8OoVzHqc8fi8T
         Yn6A==
X-Gm-Message-State: AOAM5317vVjKGFDIIo1xFUCyU2wuOHC0k04/4hwERJJAodYqf5viyKhV
        1Upf+3/X6G7Acp/1jN399bU=
X-Google-Smtp-Source: ABdhPJynuEsWgWuFjs9a07gDF0FJKcvxJ5EbXId+ECk2pkVZ0YHOxZDhzi+m5irwV3I9ynVrlSjiuA==
X-Received: by 2002:a63:e:: with SMTP id 14mr4071751pga.426.1610447524785;
        Tue, 12 Jan 2021 02:32:04 -0800 (PST)
Received: from localhost.localdomain ([103.66.11.206])
        by smtp.gmail.com with ESMTPSA id f193sm2822960pfa.81.2021.01.12.02.32.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 02:32:03 -0800 (PST)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     mw@semihalf.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gustavo@embeddedor.com
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH V3] drivers: net: marvell: Fixed two spellings,controling to controlling and oen to one
Date:   Tue, 12 Jan 2021 16:01:52 +0530
Message-Id: <20210112103152.13222-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/oen/one/
s/controling/controlling/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
Changes from V2 : Correct the versioning,mentioned both the changes

 drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.h
index 8867f25afab4..663157dc8062 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.h
@@ -143,7 +143,7 @@ struct mvpp2_cls_c2_entry {
 /* Number of per-port dedicated entries in the C2 TCAM */
 #define MVPP22_CLS_C2_PORT_N_FLOWS	MVPP2_N_RFS_ENTRIES_PER_FLOW

-/* Each port has oen range per flow type + one entry controling the global RSS
+/* Each port has one range per flow type + one entry controlling the global RSS
  * setting and the default rx queue
  */
 #define MVPP22_CLS_C2_PORT_RANGE	(MVPP22_CLS_C2_PORT_N_FLOWS + 1)
./--
2.26.2

