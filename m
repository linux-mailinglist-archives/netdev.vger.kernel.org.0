Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F43E2C6C2A
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 20:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730469AbgK0Tuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 14:50:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28905 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730340AbgK0Tt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 14:49:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606506552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=9qJpD7PFdKgMu/xcOXN6q7idq5UlxcE8KGC0MQOhIgM=;
        b=SVfRrTvl+6ngJZixTRJZdYyfmhlK14JbxvmwkRM7NzRX5RSkZW8Cyg//7TYVzta/OLM3XG
        Ba1JM6wwFb8TtJIiGQTN46926TMJw69Tgcsmwh8QO2ouqBnu81Q+E2yP8fswIrOFELZAUE
        cZCH/NQ32+98ut1AK6E8yhVglZb/XFI=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-420-czWn_6BePvWChMp6rAIkZQ-1; Fri, 27 Nov 2020 14:27:42 -0500
X-MC-Unique: czWn_6BePvWChMp6rAIkZQ-1
Received: by mail-qv1-f70.google.com with SMTP id p3so3566712qvn.15
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 11:27:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=9qJpD7PFdKgMu/xcOXN6q7idq5UlxcE8KGC0MQOhIgM=;
        b=qa6uI7bRouBlhsOza0PW7DWR4wbhVLEYiYIa6g+TLnC1kfvN0eOJRRhJC1gnsZ/OTT
         ObCZrTAr8+F1x9tGG/qS9G5e3I1Q0imVgRkY935v4m7wgQjH+ZUfAyZQw/C0b84aqDjX
         +p8fZPIm5oHfpm+0zEqibHI1NLaAdreZS5kHqztdr3MbwbPBNZU1iCP5Worgve2uGkWI
         /ObiVRWURalkVplT6qVSf+KCr+PlgU5mkSXl19E8T2NTxPLsT40Hs/5BqW8ABSvMaPOb
         mZpk5BfFnogFP5WIuuiGLySz6ATUHluHPa8i49+ntSB4MdA2tXlnnbe78HnzAYBvwqFC
         4J/w==
X-Gm-Message-State: AOAM533OxBMAotO7NZS4a1DsXsp2sFi0NEL3+md5RccZ1ZEj6gDOGIjX
        XVYZ4MZXCyHO+qgrELzDBdGW3ZvFvKmm4id7OUKmH528CCvLnz0iXob3aOCfcDY9F2OTf0IvoKo
        HivznmQPJbAhRyXBK
X-Received: by 2002:ad4:5544:: with SMTP id v4mr9383587qvy.43.1606505261709;
        Fri, 27 Nov 2020 11:27:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxuNWhcU9Ar3O10Wn0TX41HHp7RN7H86NAdJD2PtPOP28EoXt8oYhhMF7eDA1G5lCwZpeGCiA==
X-Received: by 2002:ad4:5544:: with SMTP id v4mr9383569qvy.43.1606505261511;
        Fri, 27 Nov 2020 11:27:41 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id w54sm7395471qtb.0.2020.11.27.11.27.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 11:27:40 -0800 (PST)
From:   trix@redhat.com
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: [PATCH] bpf: remove trailing semicolon in macro definition
Date:   Fri, 27 Nov 2020 11:27:34 -0800
Message-Id: <20201127192734.2865832-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

The macro use will already have a semicolon.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 include/trace/events/xdp.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/xdp.h b/include/trace/events/xdp.h
index cd24e8a59529..65ffedf8386f 100644
--- a/include/trace/events/xdp.h
+++ b/include/trace/events/xdp.h
@@ -146,13 +146,13 @@ DEFINE_EVENT(xdp_redirect_template, xdp_redirect_err,
 );
 
 #define _trace_xdp_redirect(dev, xdp, to)		\
-	 trace_xdp_redirect(dev, xdp, NULL, 0, NULL, to);
+	 trace_xdp_redirect(dev, xdp, NULL, 0, NULL, to)
 
 #define _trace_xdp_redirect_err(dev, xdp, to, err)	\
 	 trace_xdp_redirect_err(dev, xdp, NULL, err, NULL, to);
 
 #define _trace_xdp_redirect_map(dev, xdp, to, map, index)		\
-	 trace_xdp_redirect(dev, xdp, to, 0, map, index);
+	 trace_xdp_redirect(dev, xdp, to, 0, map, index)
 
 #define _trace_xdp_redirect_map_err(dev, xdp, to, map, index, err)	\
 	 trace_xdp_redirect_err(dev, xdp, to, err, map, index);
-- 
2.18.4

