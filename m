Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90B253712BF
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 10:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232996AbhECI6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 04:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231531AbhECI6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 04:58:15 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77DA5C06174A;
        Mon,  3 May 2021 01:57:21 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id k3-20020a17090ad083b0290155b934a295so5346025pju.2;
        Mon, 03 May 2021 01:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=aVmQ6F1sr7YHQdVC5KJnsTGzhM9Kyq+Sq6e6K52pPeQ=;
        b=B15SthteEqs/8KkrOG++w0hTxpEQ0p/u8suDURltFhI2Sg/0sLAkWu34laM4eAlTou
         0hRXZuWD+xz3v1wJhbFeqM70TuB2BaZGXOV86nEYaxxPneCgkZuXNnjz11N0QT9EGsoT
         +8bsgHmniZZiynqW36SqdFaucZTtwRrwrERWn/MXFx8sbjiSmmeBDu6Un9wfozUWqe8x
         +K0qrJ9s81xp70uyNlC0Fm3IKv4moGh8plgX9Ievp8cy3ecDDk8HXlcJ4qFX6ih87J2B
         CnkSsOO+0rgM7x6SQpawB69+aI12/IvFOh4kjBETvtwgCpKDFeKS3wLuaXaOyOPmVvwQ
         MhGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=aVmQ6F1sr7YHQdVC5KJnsTGzhM9Kyq+Sq6e6K52pPeQ=;
        b=Pffw3Ql4SEa0nJ72/WwVx5DhdfnOmgJQa+RZDArg371wAknjZxNQp4XEOf9tbMToly
         nekJ4Uxqh+eE4Xa4bMQZFBFCcXCZSpL5KEH1d8NNlH4GSKsDBQqm/gFgkSSSCHv3SlaT
         QCSXPyWe1uqPI7xR8U2GH8Nyr6I4KKZmX7VqSSONkR24QZ7PTO9KgOOrGCSX9DTgYU37
         00uJlaz+trwn9XTCjrbxYR4+0UD4Ll4TxGROGCi+gOc32MijrDH8wGp51gnGPfSQayai
         tDbUQqvXPw3tDlN05dEt/Kx7879RHTS56J7Nev5D6QgYsbjlE/8bj2NBM7/MvEFlkzag
         CLuA==
X-Gm-Message-State: AOAM532rSMhWpl3TGBM+7vaekCPxn+R9OWi0f9ik6IQaMt0S+a43z62d
        tqkLZo3jbrG8SjmCzkd4CmGZQgvY2TY=
X-Google-Smtp-Source: ABdhPJxvZ64Sm0W2dnAfpZGoFfdVRxy8WaRYVBlDx607Ql9R4rCS8/Eb62UxmavFk8U1O2wTac/q1g==
X-Received: by 2002:a17:902:d4c6:b029:ee:a57c:1dcb with SMTP id o6-20020a170902d4c6b02900eea57c1dcbmr15902068plg.77.1620032241017;
        Mon, 03 May 2021 01:57:21 -0700 (PDT)
Received: from localhost ([157.45.34.47])
        by smtp.gmail.com with ESMTPSA id z13sm9382320pgc.60.2021.05.03.01.57.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 May 2021 01:57:20 -0700 (PDT)
Date:   Mon, 3 May 2021 14:27:13 +0530
From:   Shubhankar Kuranagatti <shubhankarvk@gmail.com>
To:     shubhankarvk@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers: nfc: port100.c: Shift closing */ of comment
Message-ID: <20210503085713.72prlvwtgulxwyvv@kewl-virtual-machine>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The * has been added to the starting of new line of comment
The closing */ has been shifted to a new line
This is done to maintain code uniformity

Signed-off-by: Shubhankar Kuranagatti <shubhankarvk@gmail.com>
---
 drivers/nfc/port100.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nfc/port100.c b/drivers/nfc/port100.c
index 8e4d355dc3ae..d8fa8a7a360f 100644
--- a/drivers/nfc/port100.c
+++ b/drivers/nfc/port100.c
@@ -40,7 +40,8 @@
 #define PORT100_FRAME_MAX_PAYLOAD_LEN 1001
 
 #define PORT100_FRAME_ACK_SIZE 6 /* Preamble (1), SoPC (2), ACK Code (2),
-				    Postamble (1) */
+				  * Postamble (1)
+				  */
 static u8 ack_frame[PORT100_FRAME_ACK_SIZE] = {
 	0x00, 0x00, 0xff, 0x00, 0xff, 0x00
 };
-- 
2.17.1

