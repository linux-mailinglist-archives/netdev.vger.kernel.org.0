Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2483835E6A
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 15:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728166AbfFENyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 09:54:04 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41689 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726442AbfFENyE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 09:54:04 -0400
Received: by mail-wr1-f67.google.com with SMTP id c2so19572852wrm.8;
        Wed, 05 Jun 2019 06:54:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=1Kpp3N9TCra6dfSaYm7bsRqEqwflkRsTfjv3dARv+9E=;
        b=o673s0q9P/HJY2a3F5pyFquBsvQpq/nhso43cjvZdJx8HpT3qldz4AE5r9Yyenr0kM
         yMnj/NDBZSz3Vd0wabkBW8hic/3cd48wt+yVUwEsxLkYXjoneN9dmE0rdTO6s8VnZg6z
         mo49Ry3WxTPPjrnjJdx9oBo04xlHbyNUXVixY8y5+Z0nyuNE57a1k+V+nHtEOzMhoZzG
         48IAJAIkZXsm8Nd3/g3Hom/zw7U9/X2aIrbS4lXpnBzoUP/lzNvSHd1PQug3XeDh1Bbl
         nphStXkWJEoVqJo8tO58q26HPTgbYxqqgNBceSdNS1h9kR7USIu33HLSUn5E8trZ9YbS
         NvWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=1Kpp3N9TCra6dfSaYm7bsRqEqwflkRsTfjv3dARv+9E=;
        b=CSt6tnsGm7m7wak7U98DDMs5A85QJLEDqsvE6Vt97KT+vMgdnCZZZM3/l8M3eszpRn
         OoNPGfkmxejIL2D8PkNhLi6Vxu8p5bsqzR5CrY40DEYaQ9eNgQXvP1AHV02SebNC3qY1
         u7/kcer57RJDRLrxhhDJPAZ1QEDIUcaABLTCMFdCFP1y2OjdrSUUPQ7l34uDCQiEAzfG
         hke70AYXNZvwQekeeyWK6JtwI84sFMvpkxAoQuCKeAeF39fdHJeXwEn7dhrr9yxmG6fa
         +4enZ/45aYy3vmijRPZmoW5jO8F718vOLQUNWB67v362K3Upcs3H4Hyp2XCRUwBwBQ0i
         xxhA==
X-Gm-Message-State: APjAAAV/Mjfrovu5XhDU8mLM9j/vySQnd/HBci9o6cDcP34nAtPRzP9C
        OBa9NqYdT94t0SpEwFKZcn0=
X-Google-Smtp-Source: APXvYqydDPbAyAPz1moz/V7X8sI8A9+bJPkFjrETW0BldN394E9p2BhRgAAGN5X1dOXMSHvYHoIFag==
X-Received: by 2002:adf:f946:: with SMTP id q6mr4724343wrr.109.1559742842563;
        Wed, 05 Jun 2019 06:54:02 -0700 (PDT)
Received: from localhost.localdomain (host228-128-static.243-194-b.business.telecomitalia.it. [194.243.128.228])
        by smtp.googlemail.com with ESMTPSA id h21sm17859037wmb.47.2019.06.05.06.54.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Jun 2019 06:54:02 -0700 (PDT)
From:   Valerio Genovese <valerio.click@gmail.com>
To:     isdn@linux-pingi.de, gregkh@linuxfoundation.org
Cc:     netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Valerio Genovese <valerio.click@gmail.com>
Subject: [PATCH] staging: isdn: hysdn: fix symbol 'hysdn_proc_entry' was not declared.
Date:   Wed,  5 Jun 2019 15:53:49 +0200
Message-Id: <20190605135349.6840-1-valerio.click@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This was reported by sparse:
drivers/staging/isdn/hysdn/hysdn_procconf.c:352:23: warning: symbol 'hysdn_proc_entry' was not declared. Should it be static?

Signed-off-by: Valerio Genovese <valerio.click@gmail.com>
---
 drivers/staging/isdn/hysdn/hysdn_defs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/isdn/hysdn/hysdn_defs.h b/drivers/staging/isdn/hysdn/hysdn_defs.h
index cdac46a21692..a651686b1787 100644
--- a/drivers/staging/isdn/hysdn/hysdn_defs.h
+++ b/drivers/staging/isdn/hysdn/hysdn_defs.h
@@ -221,7 +221,7 @@ typedef struct hycapictrl_info hycapictrl_info;
 /* exported vars */
 /*****************/
 extern hysdn_card *card_root;	/* pointer to first card */
-
+extern struct proc_dir_entry *hysdn_proc_entry; /* hysdn subdir in /proc/net
 
 
 /*************************/
-- 
2.17.1

