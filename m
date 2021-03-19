Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62F98341461
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 05:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233645AbhCSEtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 00:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231599AbhCSEsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 00:48:40 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F045C06174A;
        Thu, 18 Mar 2021 21:48:40 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id cx5so4414289qvb.10;
        Thu, 18 Mar 2021 21:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uWTbNHoJ2SWjyCkOqghCnERP3wInwC93RX0JLjnyB3k=;
        b=dyEqCt7ofHAuAsvWaC9GmS/Tz13XCHw7soVOYZKcUsPQZ4IWKpxS2UzEpCHyyWX0VU
         d5SjcPzMEkXPW8vNya+JYtXNBH1tEhITZafhFZFsHDlqGZ/XR4CHzXqB+S/E/ppYwc/M
         U47M1n6jCQ3ZXI/RgFVbxWFIGXzZKoBUYuT1uNU1pUfbgYo93L6p9LNaGhEGQkmuRimq
         t/8bx7vuVlaj1JLN5G/dMYhgP3cg57Gn61NkQIbeL7DZvptEz57h+MaBd+oG9o7P2xta
         xyXmHeMkU7GG+YLRo40avlwlmgGLgFANCnv5WBVHQk3yOEYxfiSyP6b2BeaV/a7y1jht
         8myw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uWTbNHoJ2SWjyCkOqghCnERP3wInwC93RX0JLjnyB3k=;
        b=UBl6ffzD2tCtI+pZQSRDUFKIg0r0YoEq3uLIfcFhhdtRStoFSnc94c4QKFY2CgAA0I
         m5VRdHslS4HOpxpsSXbTC7aH84FnqXmGDaaOCwp423jN6UI78uplLMkgNKWkWyn3Ns+O
         GukjeE27jazFO3j7+4XV1nJ43MzfP7f3BsAHQDIrwWMatNDBwvmiNtXSLpvlUSuonBzF
         NeWm3XtAskWKKulGF7O6GxpIAql03Uci7vnPUN27BiOdTeQB2NVbh/NuEh2EZkvVQgKP
         oOwO0E+bbAjnpW6e/oWuP6h9jFFctkolaWLmlijM4PY1TEaxX9Ks9opo4jOgXR1xmS1r
         BWzg==
X-Gm-Message-State: AOAM532xj1n8RnL2VBGrBw/PwJX1K+b43pQNF2MnDXU/BybEhmomOSKb
        Ye8MGtSLqJuZocus9Y/BXHA=
X-Google-Smtp-Source: ABdhPJzBeYYamAvgWDrqvEeXXE97+IoFF94b/GN77JgnCqbWSj7MxGYYNIQcC+RtQxqhq4843R+XqQ==
X-Received: by 2002:a0c:f702:: with SMTP id w2mr7908272qvn.0.1616129319648;
        Thu, 18 Mar 2021 21:48:39 -0700 (PDT)
Received: from localhost.localdomain ([37.19.198.87])
        by smtp.gmail.com with ESMTPSA id l186sm3492018qke.92.2021.03.18.21.48.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 21:48:38 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] sch_red: Fix a typo
Date:   Fri, 19 Mar 2021 10:16:23 +0530
Message-Id: <20210319044623.20396-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


s/recalcultion/recalculation/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 include/net/red.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/red.h b/include/net/red.h
index 932f0d79d60c..6b418b69dc48 100644
--- a/include/net/red.h
+++ b/include/net/red.h
@@ -287,7 +287,7 @@ static inline unsigned long red_calc_qavg_from_idle_time(const struct red_parms
 	int  shift;

 	/*
-	 * The problem: ideally, average length queue recalcultion should
+	 * The problem: ideally, average length queue recalculation should
 	 * be done over constant clock intervals. This is too expensive, so
 	 * that the calculation is driven by outgoing packets.
 	 * When the queue is idle we have to model this clock by hand.
--
2.26.2

