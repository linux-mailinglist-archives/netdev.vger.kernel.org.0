Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37A673436E4
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 03:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbhCVCzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 22:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbhCVCz3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 22:55:29 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 555BFC061574;
        Sun, 21 Mar 2021 19:55:29 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id y5so7656941qkl.9;
        Sun, 21 Mar 2021 19:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oR1H5bxrFPySLuXWuSIjE3cyW9BaggyAThx0cwWxPsc=;
        b=Gq8ZQ3ucrk+9Obg7+gMsCexmW7aPbMC7+zpd/05zO0Nfva7QCwbxOft4Ll1XnTJY6u
         cE0twtfU/alR4XQ0SFBeGOah6BIdzeOpP8yPuX3xkGaKILywmjxJ8FxYM39YzRKrgGI8
         Ur9EOxurLGoH2G4SFOtii/WspoCiPwJUjAbtOH9EURcgDV7lGhzcRtpKlNqANtvTyyQK
         AtdR7ZL6xZOyNWmW5B8GsnswCaKebdkoyldIP3CAoyeC0ZbmroOUbiyqg+gnof3zeWgs
         yZGH1S0ek7/R8feUaMM5QV6aIFDNaqFq6Pe7KL7x/kXTBE5h65prgdQM4Trrl0DrQYKh
         FaPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oR1H5bxrFPySLuXWuSIjE3cyW9BaggyAThx0cwWxPsc=;
        b=GN15c+QX12uJNPS6T3vGU8MoADgDREBsWQac+SqUnVcTPdkB/eoCEvEFIJjKNng7hL
         B3s60Sj1fqbQ1zDFJxEfNjphydt59TH7YSvrDe7xQDyxlin0d1BlO8uH6ygaN3zEmIET
         jHjIirp05wiHEOoMcZq/vn4ruEL6dYQAkbZNhF8Ar31zPD+8YtSrdWhQSSpz13F6daMN
         Ax0V8vPAx7CwpSB0qZIISbS7sGOdzU+Mtd3NEk9LM+1mQvXkyTlQzBWC0Hr873J8u8of
         HzDGkZxo1AsjwidJ6eD57s34r4vNXKnCMuFA3/serboNS6JbcxhpFQIZFND3suW0GGmU
         Z9tw==
X-Gm-Message-State: AOAM533qFTWZXYgxi5gLNO/0vZgHcGjccn4wZdojLn+RZyZleb2sJEE4
        07I6WSeMOJSvvQBWTMuMZxFue9VePmmbDRbc
X-Google-Smtp-Source: ABdhPJyaowrx/fmTNly7fg26L93KEzLdl6Bi4IkqOsPg0oGq7B1hZ6fsq74RVrfk+RUPgbr54TP+7g==
X-Received: by 2002:a37:7305:: with SMTP id o5mr9168634qkc.21.1616381728663;
        Sun, 21 Mar 2021 19:55:28 -0700 (PDT)
Received: from localhost.localdomain ([156.146.54.190])
        by smtp.gmail.com with ESMTPSA id c5sm10173278qkg.105.2021.03.21.19.55.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 19:55:28 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] linux/qed: Mundane spelling fixes throughout the file
Date:   Mon, 22 Mar 2021 08:25:16 +0530
Message-Id: <20210322025516.968396-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


s/unrequired/"not required"/
s/consme/consume/ .....two different places
s/accros/across/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---

 include/linux/qed/qed_chain.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/qed/qed_chain.h b/include/linux/qed/qed_chain.h
index e339b48de32d..f34dbd0db795 100644
--- a/include/linux/qed/qed_chain.h
+++ b/include/linux/qed/qed_chain.h
@@ -19,7 +19,7 @@ enum qed_chain_mode {
 	/* Each Page contains a next pointer at its end */
 	QED_CHAIN_MODE_NEXT_PTR,

-	/* Chain is a single page (next ptr) is unrequired */
+	/* Chain is a single page (next ptr) is not required */
 	QED_CHAIN_MODE_SINGLE,

 	/* Page pointers are located in a side list */
@@ -56,13 +56,13 @@ struct qed_chain_pbl_u32 {
 };

 struct qed_chain_u16 {
-	/* Cyclic index of next element to produce/consme */
+	/* Cyclic index of next element to produce/consume */
 	u16						prod_idx;
 	u16						cons_idx;
 };

 struct qed_chain_u32 {
-	/* Cyclic index of next element to produce/consme */
+	/* Cyclic index of next element to produce/consume */
 	u32						prod_idx;
 	u32						cons_idx;
 };
@@ -270,7 +270,7 @@ static inline dma_addr_t qed_chain_get_pbl_phys(const struct qed_chain *chain)
 /**
  * @brief qed_chain_advance_page -
  *
- * Advance the next element accros pages for a linked chain
+ * Advance the next element across pages for a linked chain
  *
  * @param p_chain
  * @param p_next_elem
--
2.31.0

