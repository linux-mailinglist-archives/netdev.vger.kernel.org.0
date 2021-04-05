Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 885CB353B2A
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 06:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbhDEEBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 00:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbhDEEBv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 00:01:51 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E61A1C061756;
        Sun,  4 Apr 2021 21:01:45 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id z12so1000207plb.9;
        Sun, 04 Apr 2021 21:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PDFygVdRC4jKdnikvmKXB+IbIVJh+o4K3UKwARLovJg=;
        b=Wwru1snon1dQV46ne9ocYmXCzU13RltKV1DMzj48CAyVOUoO3m98hfVYE0Kah8tXHA
         HEfjI7T01WOkky5Rmw1RD3oRyqn8Z7MAcz5vnNp2tICsOOpXm9/lWYa3XZ+DIhkMGw8Y
         Pqli5ETONBJim/2qrd1owXIZF4URBEtcbcI4gPJFk7bTtAiRgXpjPmKNK4IhVfycMerD
         4d4TGTn1xGNhmRtiQAjopckbnzx8sGE7Nkri5Jl3ZNzxd0Y2AtKYbZ/d31rgCRMT54l/
         haOi9LIOoahjpV24YGZ3CzBdpm/qdMBs0gvfrGZsLpst0r1EoHbXRVd23XB5Wemw7zzz
         p//w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PDFygVdRC4jKdnikvmKXB+IbIVJh+o4K3UKwARLovJg=;
        b=jtosON9wOWa43gnUf8tS7GbkOZthCrrffN2VhZ4+vHn1ZxAVKscspCSxei6vgbpZaM
         Bj5s9y/q+DtKMMHIDjSR2jHjEyC+meTJIjgVn+K1bUmEsCk/GRtAZ89z5zyBJs9eIhgZ
         z/J2lKCLq9sA6H0lzXp+kME0sA45vKezEUFb4bRdeo+F4FFxbH2peWFvfJcxCuAkxqix
         uOaOiykMQanFX17bpF51lfZWO6KgrE2YTTpAHdTOTP0X5G4ZQooP7xMfthBsbF+G4IUQ
         MghfxXrDn9/yKFwuIcTRo7kdPmRn6aaP/O9f171jzmcCvraOgDVMZn+5+SzxbRJUeXyw
         8U6g==
X-Gm-Message-State: AOAM532JlfAiE3PwxkfyTUV8TggxGyz9KGJdYwwy+FefCMEkG+S4wTK6
        HluV+/CbVOR1bUYcQ5j8G6g2nv4vtrt/0R1N
X-Google-Smtp-Source: ABdhPJxyrDVIIdh71T8+5S7yXEKrqNV7t9vtNithJoJJqbBnl14tUjJB2gAMNUHgI/JVqq+eKFxr/w==
X-Received: by 2002:a17:90a:86c2:: with SMTP id y2mr4522331pjv.164.1617595305282;
        Sun, 04 Apr 2021 21:01:45 -0700 (PDT)
Received: from localhost.localdomain ([119.28.83.143])
        by smtp.gmail.com with ESMTPSA id q8sm13873051pgn.22.2021.04.04.21.01.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Apr 2021 21:01:44 -0700 (PDT)
From:   Hengqi Chen <hengqi.chen@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, andrii@kernel.org, yhs@fb.com,
        hengqi.chen@gmail.com
Subject: [PATCH bpf-next] libbpf: Fix KERNEL_VERSION macro
Date:   Mon,  5 Apr 2021 12:01:19 +0800
Message-Id: <20210405040119.802188-1-hengqi.chen@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing ')' for KERNEL_VERSION macro.

Signed-off-by: Hengqi Chen <hengqi.chen@gmail.com>
---
 tools/lib/bpf/bpf_helpers.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
index cc2e51c64a54..b904128626c2 100644
--- a/tools/lib/bpf/bpf_helpers.h
+++ b/tools/lib/bpf/bpf_helpers.h
@@ -51,7 +51,7 @@
 #endif
 
 #ifndef KERNEL_VERSION
-#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + ((c) > 255 ? 255 : (c))
+#define KERNEL_VERSION(a, b, c) (((a) << 16) + ((b) << 8) + ((c) > 255 ? 255 : (c)))
 #endif
 
 /*
-- 
2.25.1

