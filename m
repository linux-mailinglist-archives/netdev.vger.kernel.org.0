Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0978E80173
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 21:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393946AbfHBT4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 15:56:08 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:35008 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393087AbfHBT4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 15:56:07 -0400
Received: by mail-qt1-f194.google.com with SMTP id d23so75193820qto.2;
        Fri, 02 Aug 2019 12:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+BctC5jWKogaVe7+UbMIlXNT7jLhgV51cvWIOtS6af4=;
        b=ScRD9wbQ/omA/d9fsFfShN0M+dsAUZ5uFcVWUV/FkR5YEkPwKafqHoZKaiORu33iyv
         zV4NRZwB8jn0KdmrkfcD8EpZsYDsZuBGcHo6sSIitZDoPbpRjhUvpe0xaMwG1RtWpxmQ
         RDpWAK65t3sA3WwaMAwmXD4Y9NsdEV5Sp1XWuXs/6oYubqxKlRHLT0/yyS06r+uGjuAS
         P0PkxmVb3Z2EWuHieWsA46prIenNaG+ouxYrslGbGjK36dMKne6VhChJR3Q/0IaEABMY
         MqW3tHzL17upAK1vGEXppDwdLc5bqzZtQsD+W0Jf8M2NJCDA+d5jFDRPMYOi4Xx1z7yo
         G1Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+BctC5jWKogaVe7+UbMIlXNT7jLhgV51cvWIOtS6af4=;
        b=WZAYe3cy9NlK2rdocTqTLvW0VU/2t5Q8lFBydjlurkJX5VMA6JjlzmHFWhL0pADV3Y
         mymV+5pWcTOx+C0kK/4wMK7/m0bsGoqqCAIwTvtuB866DfItz645dLaa4guj9oTPtZdv
         3t93sS73lbQPaLw3imhOoY/5aV1ogHarxBneoSdPCMVsvEFvZyuJCfdKfIPfd2kZ5JPp
         GKJueVoaunUmTh5JkIJ0XdUa6boqaKA+Cw2EUbcZTR4aItjbOG9KsDIkghF5M/a+/JBJ
         n+UIfbfGWX8ehULM7CZttlUbzBCi3GE4t0X+pGI6I99fKeLA8HLdA3Xjc7dByx2F1Dn7
         Y0/A==
X-Gm-Message-State: APjAAAXxa242SwgDl8b77QiqF3rHBcAg7LHPxvJ7YTILgO9k7BQI68Ho
        XMyi4+qu35Eow8Spf+dbR0E=
X-Google-Smtp-Source: APXvYqxKRujYjipBlqcoCW5qnSeveADtV9x9i/nbKHoKSeB55C2OFv2s/SASRVRL1PQ5ui8wuVElfQ==
X-Received: by 2002:ac8:27d4:: with SMTP id x20mr94666394qtx.138.1564775766288;
        Fri, 02 Aug 2019 12:56:06 -0700 (PDT)
Received: from 0366fb520575.ime.usp.br ([143.107.45.1])
        by smtp.gmail.com with ESMTPSA id q56sm38597831qtq.64.2019.08.02.12.56.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 12:56:05 -0700 (PDT)
From:   Jose Carlos Cazarin Filho <joseespiriki@gmail.com>
To:     isdn@linux-pingi.de, gregkh@linuxfoundation.org
Cc:     netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] isdn: hysdn: Fix error spaces around '*'
Date:   Fri,  2 Aug 2019 19:56:02 +0000
Message-Id: <20190802195602.28414-1-joseespiriki@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix checkpath error:
CHECK: spaces preferred around that '*' (ctx:WxV)
+extern hysdn_card *card_root;        /* pointer to first card */

Signed-off-by: Jose Carlos Cazarin Filho <joseespiriki@gmail.com>
---
 Hello all!
 This is my first commit to the Linux Kernel, I'm doing this to learn and be able
 to contribute more in the future
 Peace all! 

 drivers/staging/isdn/hysdn/hysdn_defs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/isdn/hysdn/hysdn_defs.h b/drivers/staging/isdn/hysdn/hysdn_defs.h
index cdac46a21..f20150d62 100644
--- a/drivers/staging/isdn/hysdn/hysdn_defs.h
+++ b/drivers/staging/isdn/hysdn/hysdn_defs.h
@@ -220,7 +220,7 @@ typedef struct hycapictrl_info hycapictrl_info;
 /*****************/
 /* exported vars */
 /*****************/
-extern hysdn_card *card_root;	/* pointer to first card */
+extern hysdn_card * card_root;	/* pointer to first card */
 
 
 
-- 
2.20.1

