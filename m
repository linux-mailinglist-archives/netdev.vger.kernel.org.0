Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37AA233EC1A
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 10:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbhCQJBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 05:01:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbhCQJBT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 05:01:19 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A64C06174A;
        Wed, 17 Mar 2021 02:01:19 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id x10so38115474qkm.8;
        Wed, 17 Mar 2021 02:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OOGalcDRWwdkAJXAlYfO7jnsNJIQo9l/xYUGpYBQdO4=;
        b=GRfvE3UKtmfM7Crem5G2ZbN0Kl6XApuimBKwVqNXcaChLjetVEav/7YuuovCBZJkjR
         GIsNrytiGg9jZU9ANfpqq2UKbNQi+aGI6wjjMekldVsWUwpSTraxtxFLqsEwHIOJP9xy
         5bDS5EtT3KM1I5VBlo/WVZo2hn4fynC3Zb+iJZNljGHMdOnpjVZ51sXprPvSqa0SRZl5
         khlvPs4DBVvMKxCtgSQIAdctS/4qEGA1dCgRXmDtxgJpFs2sB4Am0jlhHVElK1LThjhz
         I3/zy2R5GXww72vAqBukJHmdbP8vUzpTxfPyVbIA4c2g1NNQNyxfGRD16TWjWynbyHtH
         +SYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OOGalcDRWwdkAJXAlYfO7jnsNJIQo9l/xYUGpYBQdO4=;
        b=Artl6IdcZtui5IkOALM7qCbZ/aSi7uNLmXP7tFuf4JJURx75nJCMIxYOCFxLqTvMqq
         Rbhu3Fjdo4TJ/XUuK68POV7WcL6bOhMnufJvqst1wGTPczRIcprMgb7rnZbIOtmOcPQk
         VsCRbl0Fe5vh8tJoNhKqUOq+BEDlojROZMNF5W92aWr78+aa257WH+wwAsrXIUx4qOpk
         OuqqtW3mCcXy1iFo5Mb/JA64X+JymQi5KpUChpWDCUZLJKOvSx/ubr6I7r2HIK41WJOi
         1Q0rUaB3Oi3ANZGf/IvjFY/tJQQIiXAxFPa9mMFqTg5EnMEyu9biyANVm78GHcoq5XlL
         QFvw==
X-Gm-Message-State: AOAM531emR3KcyNknEknqk0yD7iWYyy42vFGgo5wc4xtrEePUZFnjWYe
        xhPuUOyU0y7a7jS8Yn3NA/I=
X-Google-Smtp-Source: ABdhPJzW/jbru4vvcnwvb6kLLw2KTUVMy2V0GQcN9LTEWJpJJWe3emkAApbrVZcAD5V136dRWvGZvQ==
X-Received: by 2002:a37:a38e:: with SMTP id m136mr3627415qke.250.1615971678602;
        Wed, 17 Mar 2021 02:01:18 -0700 (PDT)
Received: from localhost.localdomain ([37.19.198.48])
        by smtp.gmail.com with ESMTPSA id e190sm17004163qkd.122.2021.03.17.02.01.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 02:01:18 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     mostrows@earthlink.net, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] net: ppp: Mundane typo fixes in the file pppoe.c
Date:   Wed, 17 Mar 2021 14:30:59 +0530
Message-Id: <20210317090059.4145144-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


s/procesing/processing/
s/comparations/comparisons/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 drivers/net/ppp/pppoe.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c
index d7f50b835050..9dc7f4b93d51 100644
--- a/drivers/net/ppp/pppoe.c
+++ b/drivers/net/ppp/pppoe.c
@@ -25,7 +25,7 @@
  *		in pppoe_release.
  * 051000 :	Initialization cleanup.
  * 111100 :	Fix recvmsg.
- * 050101 :	Fix PADT procesing.
+ * 050101 :	Fix PADT processing.
  * 140501 :	Use pppoe_rcv_core to handle all backlog. (Alexey)
  * 170701 :	Do not lock_sock with rwlock held. (DaveM)
  *		Ignore discovery frames if user has socket
@@ -96,7 +96,7 @@ struct pppoe_net {
 	 * we could use _single_ hash table for all
 	 * nets by injecting net id into the hash but
 	 * it would increase hash chains and add
-	 * a few additional math comparations messy
+	 * a few additional math comparisons messy
 	 * as well, moreover in case of SMP less locking
 	 * controversy here
 	 */
--
2.30.2

