Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC4B28015B
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 21:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404962AbfHBTuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 15:50:23 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:33368 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732050AbfHBTuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 15:50:23 -0400
Received: by mail-qk1-f196.google.com with SMTP id r6so55768214qkc.0;
        Fri, 02 Aug 2019 12:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=66NG3t8KGp5O2jbLHUXg4aRXKowYCNhtlwtdc5s4n4c=;
        b=LRwiku12x71QjV/t58PIvVEND2ubsG3jRpxjli3jlUl3CUlhSHh1f1qrg1aa3eZHPf
         Nt3qCFhv6QPhk8YQfiiZdUzpyXpBrVlRiCoZ6cnvcA8kQ4Lj3Tqtvt6tjoVSZLqhI4Kt
         2TIS4TAyorT5vY7knUniwqySKTRUUrOGdloyaplF0dVfmwia2Ojf+4OIsCr/95hGgwBZ
         9nicj3MxmURFL/qCqkqQ94+PnPSqDzyeiG6kh6tQCZ2bNfCRoOrIKFAavcI23ZA2jDWp
         c80pxd3g7OGFnCuXHRbFrQifV+eqwPIo087rJ7/2lS2iVnEAHKOuMbG5PuJ7gIWya2ON
         YGHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=66NG3t8KGp5O2jbLHUXg4aRXKowYCNhtlwtdc5s4n4c=;
        b=o24ksEavr44PZkx1m1+1Lfefqm0hEHShb7F3IPFNe++WTnq0wxXuq40gT70D7v6t2Y
         1pP5YfH+9g+uTIJaZRNvyY3KIZXkvyFSWa9u+jyhAiMNWUbGdWqQ1C45j0IXczW6q+nG
         nLgphH4GxOBUxsrJopdEkMKfQ4SGOre1g8UdiAHPumCdUrwi95ERicCW4NoDBfvkzTCu
         Sf+ynp9mvfFcoU67MKsSJPfalU2DlWWKxkabaPio76vsAqocjJXvEiQaRF8b5VNzG9gx
         zW5WptQ2wTRPB19jZXPi8u+uRF5Cmyi1J/wAxarnz7qZi+sSPSN0OkPK3StiRDp3mRlc
         lN/g==
X-Gm-Message-State: APjAAAV1DDGttYogMT9veJNtyaBDfkxe5GZP2rSKReS4y5fUHbPWp08R
        PzbOuB7KYApAfJp8s2uOD0Q=
X-Google-Smtp-Source: APXvYqxxi5StJ+CoZWd0WeQcyAYwg9+dgEw7II4ipdcZIhI84QNbArtqVVvfOR6XvEMEKXGytFxZ7g==
X-Received: by 2002:a05:620a:1034:: with SMTP id a20mr93591604qkk.165.1564775422005;
        Fri, 02 Aug 2019 12:50:22 -0700 (PDT)
Received: from 1e0f21a0da20.ime.usp.br ([143.107.45.1])
        by smtp.gmail.com with ESMTPSA id h18sm31198996qkk.93.2019.08.02.12.50.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 12:50:21 -0700 (PDT)
From:   Ricardo Bruno Lopes da Silva <ricardo6142@gmail.com>
To:     isdn@linux-pingi.de
Cc:     gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        lkcamp@lists.libreplanetbr.org
Subject: [PATCH] isdn: hysdn: fix code style error from checkpatch
Date:   Fri,  2 Aug 2019 19:50:17 +0000
Message-Id: <20190802195017.27845-1-ricardo6142@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix error bellow from checkpatch.

WARNING: Block comments use * on subsequent lines
+/***********************************************************
+

Signed-off-by: Ricardo Bruno Lopes da Silva <ricardo6142@gmail.com>
---
 Hi! This is my first patch, I am learning how to contribute to Linux
kernel. Let me know if you have any suggestions.

Thanks, 
Ricardo Bruno

 drivers/staging/isdn/hysdn/hycapi.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/staging/isdn/hysdn/hycapi.c b/drivers/staging/isdn/hysdn/hycapi.c
index a2c15cd7b..b7ba28d40 100644
--- a/drivers/staging/isdn/hysdn/hycapi.c
+++ b/drivers/staging/isdn/hysdn/hycapi.c
@@ -107,11 +107,8 @@ hycapi_remove_ctr(struct capi_ctr *ctrl)
 	card->hyctrlinfo = NULL;
 }
 
-/***********************************************************
-
-Queue a CAPI-message to the controller.
+/* Queue a CAPI-message to the controller. */
 
-***********************************************************/
 
 static void
 hycapi_sendmsg_internal(struct capi_ctr *ctrl, struct sk_buff *skb)
-- 
2.20.1

