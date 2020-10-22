Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CCAA295FF5
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 15:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2899768AbgJVNZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 09:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2894957AbgJVNZn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 09:25:43 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CF8BC0613CE;
        Thu, 22 Oct 2020 06:25:43 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id 33so1736655edq.13;
        Thu, 22 Oct 2020 06:25:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=f4qzo7l2XRXPibYCmsETjjzPgdp095iWPj5AGr/pxpg=;
        b=Iuzy4qwCkg0a6mh3LwbSx8O0wmwrtlwfso3MYI4eJO8ec3QjJnUv50v6zQ0fzBzF6d
         EdsVHFA2Vydovh/4d9qiQW3C76VHtMcINjvjS6j888Z5U41WPsrlAZe+Fkyyx3pASaRn
         wCwwj6FRUrhUurd82IqdepURLh93C+vDEibhB3jfzo7weHmL+aXIoHgCqlZRAHGvWD3o
         ojMZvg96bFG8uJcWl0mm2eoQtqg7KAaE7IY74Vei3tjteYBbnXN1Rq5DJgVsSYmnCJlL
         VGC2EIdbGENxqOA08mnuv71jclu8ve4VMzQzNBsZFFYSNVXJtQQdRuYc6GPiRFUy1k7o
         cpIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=f4qzo7l2XRXPibYCmsETjjzPgdp095iWPj5AGr/pxpg=;
        b=pUnuuN5wibGo+9MYC0DBVtrKFRv76EKI/Ax8zhsNVsiffCmmbOcrZbZQ1hET5Rl8UG
         1wgRNdY/b9lU9n7fvlDGiKKydzAq/UUTlesUsEdRCmJSBncWrHx2c1MvmdR0Eep7lyK1
         ay6RrFLg6KjvVve34PEnxYbyYYdYUKlW+IJD1rI9lXHmivK9t4dPThjMZztRvmDoG1cL
         uXUrZvoRzn4HfRshlmUMu5CVUHvtuoC9R4Pt0VmZd1RcJbtAUl+v2BXOh96I6QKIlWJ2
         vpRU6pgiiRA09IacfC4qdc+XhP3c8+DDgpuvjP5oBIc/8ZvOEyarq8LkiWiuB58Uo+5i
         20Zg==
X-Gm-Message-State: AOAM531BDqj0ACHuGECgulQ1qgTaVT8jD1bPG1YETVvqyZlmD7q7M9Dd
        FFe3hZF3lUZlAPKIqLihoP6OlFqVrvM=
X-Google-Smtp-Source: ABdhPJyPSBuzZFkxp36I5C3eTIv0SwlPqKbewFltadF8+AjiJVRDuvzsT8lHgfXNDQQV1nM1U8FhTw==
X-Received: by 2002:aa7:d892:: with SMTP id u18mr2281589edq.305.1603373142043;
        Thu, 22 Oct 2020 06:25:42 -0700 (PDT)
Received: from development1.visionsystems.de (mail.visionsystems.de. [213.209.99.202])
        by smtp.gmail.com with ESMTPSA id pj5sm843452ejb.118.2020.10.22.06.25.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Oct 2020 06:25:41 -0700 (PDT)
From:   yegorslists@googlemail.com
To:     linux-can@vger.kernel.org
Cc:     mkl@pengutronix.de, netdev@vger.kernel.org,
        dev.kurt@vandijck-laurijssen.be,
        Yegor Yefremov <yegorslists@googlemail.com>
Subject: [PATCH v2] can: j1939: convert PGN structure to a table
Date:   Thu, 22 Oct 2020 15:25:34 +0200
Message-Id: <20201022132534.22888-1-yegorslists@googlemail.com>
X-Mailer: git-send-email 2.17.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yegor Yefremov <yegorslists@googlemail.com>

Use table markup to show the PGN structure.

Signed-off-by: Yegor Yefremov <yegorslists@googlemail.com>
---
Changes v1 -> v2:
  - add descrption for the bit position

 Documentation/networking/j1939.rst | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/j1939.rst b/Documentation/networking/j1939.rst
index faf2eb5c5052..bd1584ec90f9 100644
--- a/Documentation/networking/j1939.rst
+++ b/Documentation/networking/j1939.rst
@@ -71,10 +71,14 @@ PGN
 
 The PGN (Parameter Group Number) is a number to identify a packet. The PGN
 is composed as follows:
-1 bit  : Reserved Bit
-1 bit  : Data Page
-8 bits : PF (PDU Format)
-8 bits : PS (PDU Specific)
+
+  ============  ==============  ===============  =================
+  Bit position of PGN fields in the 29-bit CAN identifier
+  ----------------------------------------------------------------
+  25            24              23 ... 16        15 ... 8
+  ============  ==============  ===============  =================
+  R (Reserved)  DP (Data Page)  PF (PDU Format)  PS (PDU Specific)
+  ============  ==============  ===============  =================
 
 In J1939-21 distinction is made between PDU1 format (where PF < 240) and PDU2
 format (where PF >= 240). Furthermore, when using the PDU2 format, the PS-field
-- 
2.17.0

