Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA042481DFB
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 17:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241158AbhL3QMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 11:12:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236629AbhL3QMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 11:12:38 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 280ECC061574;
        Thu, 30 Dec 2021 08:12:38 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id l4so15897666wmq.3;
        Thu, 30 Dec 2021 08:12:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0Pnjdq429wkLvZ7QQ8EgNC1pfMpkmAT54Uvk5bVoFhM=;
        b=BEiSf4gbp1br/LVg3r+zcs+4bkXIDqrEeZ85F9p58DS3Qt02rlPTygB3F5hgf5kbTz
         FDipKDJduJOGHsrGf8lv3+Tkw0ieW3jmAOrem+U0/Z2gGjpHDWWpM/ZM2A+k4VuSgy5A
         GDgjKrEZj3y1iPneHT+EJOvU1dH4FFTuGbRrv4qYMN8qW/ciRXMLT+Z6/Jvfy390SZ3V
         ElLRAc7herXxFKTThTPXr9m8FoRPtzECxfrP/S1N1vTNOZfFBKc0jgc+oX9HWBx6AsbS
         C0J3/uGz8XIzuov5xDD+Vb4vfC4ngCdM3F1SRlgY7cMgnYt5UcKkH4/EBKlITRZpFTos
         4zhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0Pnjdq429wkLvZ7QQ8EgNC1pfMpkmAT54Uvk5bVoFhM=;
        b=JL+HuhWzxlRyacx1B9pK2PPPISlAFzhdNk2+lEI4SZV4lrMHBW859rBlpu7J0MjJpQ
         vdEMnSPidncx5USJNl5L1ttyqahP7B8q6ANrvaWzKByoS2ZgOTuRMPwGLO4cEnfGvSZv
         7Ak7CUE6DmaiwhzEZ4d2AjMJPySnpxyezzO8Av3xQ2WBvHMldbuLW2ZaZCNNn4RhU7t1
         sQad2zfADiNK/fe4gxNT7wpxDE7xo6DtDDYuo5rolIuBmpoLSwig+07tS2e6JUuCCVhX
         NWUKs9AXbFFGF7qBdSAQuDSEp1js6PBgQJT3FKxl3g1ZvJROG0l5N65NoyBm8XiY5s4k
         F5Iw==
X-Gm-Message-State: AOAM532rDpBlsbEnrD3eBCY4BxDzs+T3dmrEM6p++wcvdUrLVd4zDFv2
        +L5OHhS3Sgl6fSFW62SrxB0=
X-Google-Smtp-Source: ABdhPJy2dR79PiS8oIFSey0wDOUHMJPpwdSHdt3d8X6C2mRhOqvFfHypLxgtkKGOIHePbSSjleoqZA==
X-Received: by 2002:a7b:c958:: with SMTP id i24mr26172837wml.75.1640880751645;
        Thu, 30 Dec 2021 08:12:31 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id m17sm24300651wrw.11.2021.12.30.08.12.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 08:12:31 -0800 (PST)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, llvm@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: [PATCH] nfc: st21nfca: remove redundant assignment to variable i
Date:   Thu, 30 Dec 2021 16:12:30 +0000
Message-Id: <20211230161230.428457-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable i is being assigned a value that is never read, the
assignment is redundant and can be removed. Cleans up clang-scan
build warning:

drivers/nfc/st21nfca/i2c.c:319:4: warning: Value stored to 'i'
is never read [deadcode.DeadStores]
                        i = 0;

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/nfc/st21nfca/i2c.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/nfc/st21nfca/i2c.c b/drivers/nfc/st21nfca/i2c.c
index f126ce96a7df..05157fc0f4eb 100644
--- a/drivers/nfc/st21nfca/i2c.c
+++ b/drivers/nfc/st21nfca/i2c.c
@@ -315,10 +315,8 @@ static int st21nfca_hci_i2c_repack(struct sk_buff *skb)
 		skb_pull(skb, 1);
 
 		r = check_crc(skb->data, skb->len);
-		if (r != 0) {
-			i = 0;
+		if (r != 0)
 			return -EBADMSG;
-		}
 
 		/* remove headbyte */
 		skb_pull(skb, 1);
-- 
2.33.1

