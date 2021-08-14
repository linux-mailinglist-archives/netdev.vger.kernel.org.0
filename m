Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 448123EC1C9
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 11:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237762AbhHNJ4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 05:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237703AbhHNJ4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 05:56:00 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E229C061764
        for <netdev@vger.kernel.org>; Sat, 14 Aug 2021 02:55:32 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id a5so15146470plh.5
        for <netdev@vger.kernel.org>; Sat, 14 Aug 2021 02:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YiG0yf/5wgs/7bW0GtAApT1I94eSGtteWf/SCyGxK60=;
        b=IlrAQcaRs4egO7XI6fvo5e/R3y1djXS1GoZTlfTZYyUiaUiYjB3b/kipNfh6gHKDgv
         7+SDF6732UOCQ4XJXqEGyVEVNOZlBjDGwbaQ3BIAnSerYmHNOtppoNmx9LOkivOzAb4t
         +KUdpQRPuZF+GQn6A9lN3UvqpQTgJnQhcNQ6PSo2+b2zj8oH4/pyQ00VkH+89CVXdQgL
         PfsSzzkUN9+ENwVA0lf8jLWwMkpRLBJNCkjdMSJ9t/1/iz6kHixM3/1Xfu750lOKIIKE
         Ttt2cabCKtuc1z0LLiAHbUaKeg55Ny8XALmVL5WT+xuQjs3lCAbjnDh1csSOIiEyv8Il
         2ugQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YiG0yf/5wgs/7bW0GtAApT1I94eSGtteWf/SCyGxK60=;
        b=qCa2AGaSL01FpoDikD0HZBMVvSOZWdZwbUi1X/1Io81owGd5oRKxq2UiqNVlVSj20x
         CCBNMheoIjJHKdVcW7lggAEDtxoTELT2ha3JP9xvsxo+DYeQkOisHD4/+xQD8WziiFTd
         3KTt7lUZfwDkcM2zKmrXzV4HVF7DSoDAVeYkz/fLlNpoUMrCZEHObaCxMOiQ2dpuRg2K
         5wwwY/uIX8ziJG1F/VQcXvqhv55USPrQPUFnevl8l1pRZTSWyFpqA4Vs4muCwbQl194D
         2GK/dnzzzdXDVyQn0+cC8VALsLya5wP4GfsYLrs5npPH5H+ax6HPFueqOS4BCbwQHBV+
         XTYw==
X-Gm-Message-State: AOAM531+hdOjCwaErRI03oENl6E9hQd7W5qhzMuXBExTqEi90VwYpS/p
        56MBxUdfpyo6gLKbtvYeKdD4vnMhjP2zmQ==
X-Google-Smtp-Source: ABdhPJy2c3zSxNse2446TRiHXHpozy4gWMphDEN3Ke3YW6chanqBtVieG0ER3Tm7XHZwa7qCgaXfvQ==
X-Received: by 2002:a17:90a:bc84:: with SMTP id x4mr6922370pjr.36.1628934931789;
        Sat, 14 Aug 2021 02:55:31 -0700 (PDT)
Received: from lattitude.lan ([49.206.113.179])
        by smtp.googlemail.com with ESMTPSA id y7sm5220436pfp.102.2021.08.14.02.55.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Aug 2021 02:55:31 -0700 (PDT)
From:   Gokul Sivakumar <gokulkumar792@gmail.com>
To:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>
Cc:     Gokul Sivakumar <gokulkumar792@gmail.com>
Subject: [PATCH iproute2-next 3/3] man: bridge: fix the typo to change "-c[lor]" into "-c[olor]" in man page
Date:   Sat, 14 Aug 2021 15:24:39 +0530
Message-Id: <20210814095439.1736737-4-gokulkumar792@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210814095439.1736737-1-gokulkumar792@gmail.com>
References: <20210814095439.1736737-1-gokulkumar792@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes: 3a1ca9a5b ("bridge: update man page for new color and json changes")
Signed-off-by: Gokul Sivakumar <gokulkumar792@gmail.com>
---
 man/man8/bridge.8 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index eec7df43..db83a2a6 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -22,7 +22,7 @@ bridge \- show / manipulate bridge addresses and devices
 \fB\-s\fR[\fItatistics\fR] |
 \fB\-n\fR[\fIetns\fR] name |
 \fB\-b\fR[\fIatch\fR] filename |
-\fB\-c\fR[\folor\fR] |
+\fB\-c\fR[\fIolor\fR] |
 \fB\-p\fR[\fIretty\fR] |
 \fB\-j\fR[\fIson\fR] |
 \fB\-o\fR[\fIneline\fr] }
-- 
2.25.1

