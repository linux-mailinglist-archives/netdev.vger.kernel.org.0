Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45C39432B92
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 03:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbhJSBsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 21:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbhJSBsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 21:48:08 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5804C06161C;
        Mon, 18 Oct 2021 18:45:56 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id q10-20020a17090a1b0a00b001a076a59640so1007782pjq.0;
        Mon, 18 Oct 2021 18:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bmyYiX/NUQLZNLOTI9xr+fYlkHKgPJ5IMoked9OK5MA=;
        b=jCP4Lvv+aWKjRvppe76F6YyPxRIbsryzzfSIAsHMZxxWKS4Qn6vXKbOXjcADUHcYrr
         Da3ieWamwcyCbqnLB9Gk3Fz2RKaFx72rZwkui6wD+gjRsZcZdkhlzO1KD8UQYjWnRoUJ
         At/MmE8+a51zC7Z077B7ifLKSXFBW9I8OUS5KG1rsyFD5x2G45msW/Kyd+M5HoOKCBw8
         oZkYdO9XzWcuoVZ0zE35dBY0s6HuXUIQE40JW0ORvlDR90B/4dsnu4Z8g9pWBP4AP8Fv
         Gw+Ilps/cxOUD95DgG5RCnW+73Qn33JsMmmc35JPN+SowzQVPSpqURJDpACRmCHL64HB
         U4VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bmyYiX/NUQLZNLOTI9xr+fYlkHKgPJ5IMoked9OK5MA=;
        b=TLGjRudO0iZFk6b+5FWNjyZghmohJ0ilCOiK1w77KgbrVpo1MXnv5rSzRdg9HrNDCp
         LwPgOfm45iy6MFba1CBxPAyCGCy+yDo/J3obD5BgwDxtdQ3mgAR1worAzKNQRaHo+CfK
         kUPd39oT9JmrLvqGTL6Kp+AJwYSop94+3fM56N3CvY44bNU/JnoaCv4Fh92JqUFLU+Ff
         V3THBy++MwLiSsfsvHZsaqye19V/8P6RQpq3VfY7Sg0nPXV9JDEfEzEvb3ioR98IgdlE
         r26ujY3AqCP6PAGLpudvTewcPD87aYEvxEQ/v+TaIxNRWvG3NCHyD2LCdVxiCuJC87Yw
         1/LA==
X-Gm-Message-State: AOAM531d2S3SYWge8YNNSWfzrJsyVWA8xSwKJfZU48z4aQcVLr3tzUZk
        w0ZiJUqsaf9LBeGOcMIXm9g=
X-Google-Smtp-Source: ABdhPJxZDkNjdM3kjqmX7ea+2BkW87DY3mmDG0E7+E9cIxCMRv7Pf9bsjGVqYHX1pfvqlIMdpEqg4Q==
X-Received: by 2002:a17:90a:3189:: with SMTP id j9mr3022471pjb.54.1634607956531;
        Mon, 18 Oct 2021 18:45:56 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id t22sm10719891pfg.148.2021.10.18.18.45.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 18:45:56 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: ran.jianping@zte.com.cn
To:     shuah@kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ran Jianping <ran.jianping@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH selftests/bpf] selftests/bpf: remove duplicate include in cgroup_helpers.c.
Date:   Tue, 19 Oct 2021 01:45:49 +0000
Message-Id: <20211019014549.970830-1-ran.jianping@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ran Jianping <ran.jianping@zte.com.cn>

unistd.h included in '/tools/testing/selftests/bpf/cgroup_helpers.c'
 is duplicated.It is also included on the 14 line.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Ran Jianping <ran.jianping@zte.com.cn>
---
 tools/testing/selftests/bpf/cgroup_helpers.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/cgroup_helpers.c b/tools/testing/selftests/bpf/cgroup_helpers.c
index 8fcd44841bb2..9d59c3990ca8 100644
--- a/tools/testing/selftests/bpf/cgroup_helpers.c
+++ b/tools/testing/selftests/bpf/cgroup_helpers.c
@@ -11,7 +11,6 @@
 #include <fcntl.h>
 #include <unistd.h>
 #include <ftw.h>
-#include <unistd.h>
 
 #include "cgroup_helpers.h"
 
-- 
2.25.1

