Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A52ED19EB9A
	for <lists+netdev@lfdr.de>; Sun,  5 Apr 2020 15:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbgDENuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Apr 2020 09:50:05 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41094 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726628AbgDENuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Apr 2020 09:50:05 -0400
Received: by mail-wr1-f66.google.com with SMTP id h9so14176285wrc.8
        for <netdev@vger.kernel.org>; Sun, 05 Apr 2020 06:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references:reply-to
         :mime-version:content-transfer-encoding;
        bh=ry4zHGtI1LEhv5RTuXljYcf0btJzowLcpN4kd/wOMi0=;
        b=qolrEZU4h9jqi3SEuzv++Jx011/eHrhxgZaPmlU8eOOjKG2DiH3AMA+fN5T3JykTxw
         1ioZj9ae+fZj78iCRaNdSrSnqwjqrWdH9jaEIy8yGNTRtQWOayxpSdOKj3RKlxOKfDLs
         Nxxy3T1Mmfrjyd+dQEW5/fFHiCf6mFHhr+PLqsVHzJs5oD6CDvs//HkeWx9tDJPiZZxp
         Mpn7jhUWJsPIEj1CFE/K6qy9vIxk3Gp9VYRN2TD26ex4LtihtO53PhMxSuIVHNUs21gC
         TD50PCx7NQUd+0x+uK035Jth6QONgJPGdVP39F3tHUNYKS0Pt2bQl6j98Jcv+T5p96YP
         pV8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:reply-to:mime-version:content-transfer-encoding;
        bh=ry4zHGtI1LEhv5RTuXljYcf0btJzowLcpN4kd/wOMi0=;
        b=OGhVes9SAQXyTPaQBuCI5z+tC4N02Fsg2t5C9FzTCiEiY4MKPc4ZkXJXFNTFe0Rawc
         oHaMHp3fDBG9dOtc6JvGNMfpOJmEGefjAALQWGhZFqTHXxz3UEFnKiPSBb+ekDSRcJ3Z
         ABFR7Tfq5TqS5cEQ8fHrLFFkdPXq5T4mdw+rysNXsrsdBRjq8QX65kgxLZAo+EFS6RXM
         +6rGd/6dld+uRh5CtKkQ5f50V2H0ZoVYGgilktONxgnmwkwsEvK0yGcia8XDp1MfsaMv
         UngY3g9hxz8H6Mb/HsVJ5HUl4XTRvMFp2+s3OinHuaT6L/z+tfti5cjGdfjuvwkwRlCd
         1J9A==
X-Gm-Message-State: AGi0Pua+2z6lspwlODUPYkJnipYn4XnHqaMu2KVjX5Kv9hpiA7jVx9PU
        p9YUHluHz3CWxDLbN9YScix2i5VW
X-Google-Smtp-Source: APiQypJnZOwute9toRBWCWfZ8tfd4U3lQMZi23RXctIdcNISDq8u/j8iM9j5CSgCk6VZYWYRMX1taQ==
X-Received: by 2002:adf:edd0:: with SMTP id v16mr18526739wro.113.1586094601520;
        Sun, 05 Apr 2020 06:50:01 -0700 (PDT)
Received: from localhost ([2a01:e35:2f01:a61:fc49:14b:88c:2a9c])
        by smtp.gmail.com with ESMTPSA id y20sm11091609wmi.31.2020.04.05.06.49.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2020 06:50:00 -0700 (PDT)
From:   "=?UTF-8?q?Bastien=20Roucari=C3=A8s?=" <roucaries.bastien@gmail.com>
X-Google-Original-From: =?UTF-8?q?Bastien=20Roucari=C3=A8s?= <rouca@debian.org>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bastien=20Roucari=C3=A8s?= <rouca@debian.org>
Subject: [PATCH iproute2 3/6] Document BPDU filter option
Date:   Sun,  5 Apr 2020 15:48:55 +0200
Message-Id: <20200405134859.57232-4-rouca@debian.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200405134859.57232-1-rouca@debian.org>
References: <20200405134859.57232-1-rouca@debian.org>
Reply-To: rouca@debian.org
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Disabled state is also BPDU filter
---
 man/man8/bridge.8 | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index 4dc8a63c..c8e15416 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -293,32 +293,45 @@ droot port selectio algorithms.
 
 .TP
 .BI state " STATE "
-the operation state of the port. This is primarily used by user space STP/RSTP
+the operation state of the port. Except state 0 (disabled),
+this is primarily used by user space STP/RSTP
 implementation. One may enter a lowercased port state name, or one of the
 numbers below. Negative inputs are ignored, and unrecognized names return an
 error.
 
 .B 0
-- port is DISABLED. Make this port completely inactive.
+- port is in
+.B DISABLED
+state. Make this port completely inactive. This is also called
+BPDU filter and could be used to disable STP on an untrusted port, like
+a leaf virtual devices.
 .sp
 
 .B 1
-- STP LISTENING state. Only valid if STP is enabled on the bridge. In this
+- STP
+.B LISTENING
+state. Only valid if STP is enabled on the bridge. In this
 state the port listens for STP BPDUs and drops all other traffic frames.
 .sp
 
 .B 2
-- STP LEARNING state. Only valid if STP is enabled on the bridge. In this
+- STP
+.B LEARNING
+state. Only valid if STP is enabled on the bridge. In this
 state the port will accept traffic only for the purpose of updating MAC
 address tables.
 .sp
 
 .B 3
-- STP FORWARDING state. Port is fully active.
+- STP
+.B FORWARDING
+state. Port is fully active.
 .sp
 
 .B 4
-- STP BLOCKING state. Only valid if STP is enabled on the bridge. This state
+- STP
+.B BLOCKING
+state. Only valid if STP is enabled on the bridge. This state
 is used during the STP election process. In this state, port will only process
 STP BPDUs.
 .sp
-- 
2.25.1

