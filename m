Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3DE22835
	for <lists+netdev@lfdr.de>; Sun, 19 May 2019 20:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729367AbfESSGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 May 2019 14:06:40 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46632 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725784AbfESSGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 May 2019 14:06:40 -0400
Received: by mail-pl1-f196.google.com with SMTP id r18so5617031pls.13;
        Sun, 19 May 2019 11:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=/yfHy3bk4VUcjD3ax5K1r2nhCYKz0EKfsLspUQgIkNM=;
        b=qpTB0CGHhgm6kB7Asz+LTQATMNUrHvFESjOFyFQkpIbY8ZTMXTF15hKISipKb3Tmq1
         fUzQ0BktEJdNVAuxVvRSSvOirFbpZoDjLloYoytKaQFVXL/NHYf1NDok0WdFtDtuB/+z
         k2XMZbe45GE1FlJj9D1on78NNVHpf7AUNrfZI9W4kkBxIpRnze3TxIry3EVec+krfeCf
         XO91hI39rrlmYnk0zgOLMXSBVDkZcYvKR7hu6I6aKK2JhFgtBb4BBoOLSxE6WIED/s4G
         aP8/QPSG8XkX1vJGvSCOt7zfW0GhrWPPg7NrHbr8M0jEILuR70WBBiU9z8n5Aq43DT9F
         TLUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=/yfHy3bk4VUcjD3ax5K1r2nhCYKz0EKfsLspUQgIkNM=;
        b=pr3NoH9R3txdVi80ZJHORYaZ63hwDTHZ/vHkhogVaBmyKOG5EH2EM6ktHdFSAbEOmv
         y6nIVNvz4uZKJn9E8i0QRChSQY8BzP0FLu+YUD/8wq9QUUlZ5kqyYsAHYCnmL2bAIpdk
         KYI7vLRV+aAfT59ZJJOFpaoG2O9tFGqjhWf2uHUzDMIyl1CNxGnprd4cHW42HAqxtYeu
         qGFs54eUOKqZiHesUHCU9RSdPjZdb+IudVG2146ZzCXXIzKP7s/O5G5VrfEus2EdehYV
         uTF3njOTDPMOOAheJygywsjWdfenWe8FSAd5fQdK7X6+z1ZRSqQaJfI2oPXkioqzwGUE
         rOHQ==
X-Gm-Message-State: APjAAAUKFLyx6t+NrDVrqLWO3kS8SopuAy2ku0kMy8nSZQhA1UcYQJcK
        LhQtcJwOyZidlf24AAPyOrzyRuktc9w=
X-Google-Smtp-Source: APXvYqzJWyPH4c0OA+p7Jv8rB/YaV8UG3Uuyxc2txQmVThUeRU8CVh+u5hb7nQnBHmCVfJgeeDVrsA==
X-Received: by 2002:a17:902:6b:: with SMTP id 98mr68143824pla.271.1558236699451;
        Sat, 18 May 2019 20:31:39 -0700 (PDT)
Received: from localhost ([43.224.245.181])
        by smtp.gmail.com with ESMTPSA id e123sm15745920pgc.29.2019.05.18.20.31.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 18 May 2019 20:31:38 -0700 (PDT)
From:   Weitao Hou <houweitaoo@gmail.com>
To:     stas.yakovlev@gmail.com, kvalo@codeaurora.org, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Weitao Hou <houweitaoo@gmail.com>
Subject: [PATCH] wireless: fix intel typos in code comments
Date:   Sun, 19 May 2019 11:31:14 +0800
Message-Id: <20190519033114.20271-1-houweitaoo@gmail.com>
X-Mailer: git-send-email 2.18.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fix lengh to length

Signed-off-by: Weitao Hou <houweitaoo@gmail.com>
---
 drivers/net/wireless/intel/ipw2x00/ipw2200.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
index fa400f92d7e2..807b2c11215a 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -774,7 +774,7 @@ static int ipw_get_ordinal(struct ipw_priv *priv, u32 ord, void *val, u32 * len)
 		 *
 		 * This table consist of six values, each containing
 		 *     - dword containing the starting offset of the data
-		 *     - dword containing the lengh in the first 16bits
+		 *     - dword containing the length in the first 16bits
 		 *       and the count in the second 16bits
 		 */
 
-- 
2.18.0

