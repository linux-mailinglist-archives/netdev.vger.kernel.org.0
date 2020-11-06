Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 073A32A9237
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 10:14:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgKFJOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 04:14:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbgKFJOn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 04:14:43 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC4FC0613CF;
        Fri,  6 Nov 2020 01:14:43 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id 72so743304pfv.7;
        Fri, 06 Nov 2020 01:14:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=xWD6H4YfLBIgZGKjax+AFoeOAhrK/THIB6kdeDCShJY=;
        b=GzHqAIoDzpgOzhilppD8kn7BpKL6BJeSVIQ3Uo+coa5gtDSC0KMxA+4hUFNBSDE1mq
         He6WUprAfACDfjaPXJtlF0J1b+NlvQlOm9tfskNUoLnLa6eLFj7OVd4WTGq9v359ALRM
         WPLLUOUaBuOU4JinhRGEBCuQIFG6OJZjOpzdl6LD+DnaLvqRT6xKNSf6tzJ+5iro1K5i
         IEGf9+JK/xro0eGS5+eklHFc5uTcS+YL3j/LC4E+T/AZpzMZg1n1fnod/7QUwKBZelb0
         Dx9w1qORlRdp/6n4Ysus5Bp9gSKNxRGxWk8VIXLLWYfdC6jBGyXhvsuRC0lUBkAQjeNM
         PglA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=xWD6H4YfLBIgZGKjax+AFoeOAhrK/THIB6kdeDCShJY=;
        b=UKhSFpJf+VsDS+A4NTqMIe0gNokJK7cb0aeAy9sojnfmWlRiNXpA58AAXn7+FhZ5Jl
         Xe+knlFTV6KrQutv4ogI4eDBzjdIMvfWHsd2tkJLm1G5KP+c/U28kHxKhRUdH89wmUhk
         n1V7Gj45S3W6X8QXD4d/isQgecAYpqYBAktqD9KQcZhwwrvwn8bdLUyxkEaQyrAgzDbg
         oQCpYPNRDxd/IBIKWbLNVABUuyCsi0NiBkmJAPDZd5MlbdmqMZGcrKIvNQurXuzGF1ZI
         rG+FaoEbJ3rCBbVwQNiJrcSHmPWzr86I+8wO1uvCR1bi0vhwWUOmfQuQsvMT4oXP6Pft
         DdOw==
X-Gm-Message-State: AOAM533crPifxy6jE4CayIGxm2esC3GF36JpNn93sg5Mk2QlkZaoULpF
        qPVpvLMHtD7TUuxxZ0aoQkI=
X-Google-Smtp-Source: ABdhPJx1Jz7z3zuiEau+Ca8VYfyduHHSG12aO00hzV3HQAjIHEABseinOucxdlMp4LH/8wpnoyUFJQ==
X-Received: by 2002:a63:354c:: with SMTP id c73mr1000958pga.315.1604654082944;
        Fri, 06 Nov 2020 01:14:42 -0800 (PST)
Received: from localhost.localdomain ([154.93.3.113])
        by smtp.gmail.com with ESMTPSA id e8sm1323167pfj.157.2020.11.06.01.14.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Nov 2020 01:14:42 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: dong.menglong@zte.com.cn
To:     daniel@iogearbox.net
Cc:     ast@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        andrii@kernel.org, john.fastabend@gmail.cm, kpsingh@chromium.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Menglong Dong <dong.menglong@zte.com.cn>
Subject: [PATCH] samples/bpf: remove duplicate include
Date:   Fri,  6 Nov 2020 04:13:54 -0500
Message-Id: <1604654034-52821-1-git-send-email-dong.menglong@zte.com.cn>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <dong.menglong@zte.com.cn>

Obviously, 'bpf/bpf.h' in 'samples/bpf/hbm.c' is duplicated.

Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
---
 samples/bpf/hbm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/samples/bpf/hbm.c b/samples/bpf/hbm.c
index ff4c533..400e741 100644
--- a/samples/bpf/hbm.c
+++ b/samples/bpf/hbm.c
@@ -51,7 +51,6 @@
 #include "cgroup_helpers.h"
 #include "hbm.h"
 #include "bpf_util.h"
-#include <bpf/bpf.h>
 #include <bpf/libbpf.h>
 
 bool outFlag = true;
-- 
2.7.4

