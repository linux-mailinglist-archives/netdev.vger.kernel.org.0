Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 787CA2CC8F0
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 22:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbgLBV3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 16:29:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36536 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725900AbgLBV3r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 16:29:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606944500;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=R3y59cFkBFhJHLAJHRUlQeF2BXj1DNnEUxvigbFgejc=;
        b=AOd3ogqo0hIaJs0UHkGYKHzClIVQSqgzsaPRSzsizDLl7aj7iXGLZSAgN0bv5Qf8y3Btsk
        RJOc/v1VnjewL3zpVrRYmOrsvpGWsnk2O641fXn+0iamKlhgOQ5HoP8y/3s7t8Ba9Zwpda
        hEoTLHQMA8jTXES+VuNMpxVsgApkZTY=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-gXYSXS-nNtuADls3DxgHQQ-1; Wed, 02 Dec 2020 16:28:19 -0500
X-MC-Unique: gXYSXS-nNtuADls3DxgHQQ-1
Received: by mail-qt1-f198.google.com with SMTP id o12so2429267qtw.14
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 13:28:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=R3y59cFkBFhJHLAJHRUlQeF2BXj1DNnEUxvigbFgejc=;
        b=mqNkDIaHIM4STOiadTqxE/7r0ec0Z31d5kn3bLG6zhgTEpYubq09Vt7vjMBd16vLKE
         LmC3KancBjlDr+srTn/MTqTZPLNCI2yA5v/Vete9D9jr81vIOl3lcu47b/QQXtqEhfgV
         O21yMyUC01jOm04IA0Ep8MmJPunrdwsdxKwcf/Y4c5xbPrn+6xay4/4RmHtyuMvgPKxK
         kzFuk6E5ulyARuIjj2US0J3T698SP/XOLAyjjtXzdSh0VR63Bhz+6tLC4fMvoIH46iFh
         G0czucnvyIEauMhSziZnMwvlD3A222uaUAIXVpm/oHflFR0I2LZ07wA8vw8ViKW5Sppv
         SMNA==
X-Gm-Message-State: AOAM531/vEdE8cnCFeAUrT9c2njdvoeRua8wft2FeiP/7CwmQ2z0sF0A
        LZpF6z55UKjII73p1II7UGnPWf9aivon/l28dx775ivx7AamgljsPT2cUkkPbhltQ5RRIAqWo6H
        gRgozIl4/BuiVvUg1
X-Received: by 2002:aed:308a:: with SMTP id 10mr141335qtf.312.1606944498914;
        Wed, 02 Dec 2020 13:28:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxMQAv9tZIsxapcS/KocPHAZTfaCE23GVIln0P+rFylEHpjwCBMxSLkJjYKU3ZJT2kBE1904g==
X-Received: by 2002:aed:308a:: with SMTP id 10mr141308qtf.312.1606944498652;
        Wed, 02 Dec 2020 13:28:18 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id q20sm2873760qke.0.2020.12.02.13.28.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 13:28:17 -0800 (PST)
From:   trix@redhat.com
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: [PATCH v2] bpf: remove trailing semicolon in macro definition
Date:   Wed,  2 Dec 2020 13:28:10 -0800
Message-Id: <20201202212810.3774614-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

The macro use will already have a semicolon.
Clean up escaped newlines

Signed-off-by: Tom Rix <trix@redhat.com>
---
v2: more macros fixed, escaped newlines cleaned
---
 include/trace/events/xdp.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/trace/events/xdp.h b/include/trace/events/xdp.h
index cd24e8a59529..76a97176ab81 100644
--- a/include/trace/events/xdp.h
+++ b/include/trace/events/xdp.h
@@ -145,17 +145,17 @@ DEFINE_EVENT(xdp_redirect_template, xdp_redirect_err,
 	TP_ARGS(dev, xdp, tgt, err, map, index)
 );
 
-#define _trace_xdp_redirect(dev, xdp, to)		\
-	 trace_xdp_redirect(dev, xdp, NULL, 0, NULL, to);
+#define _trace_xdp_redirect(dev, xdp, to)				\
+	 trace_xdp_redirect(dev, xdp, NULL, 0, NULL, to)
 
-#define _trace_xdp_redirect_err(dev, xdp, to, err)	\
-	 trace_xdp_redirect_err(dev, xdp, NULL, err, NULL, to);
+#define _trace_xdp_redirect_err(dev, xdp, to, err)			\
+	 trace_xdp_redirect_err(dev, xdp, NULL, err, NULL, to)
 
 #define _trace_xdp_redirect_map(dev, xdp, to, map, index)		\
-	 trace_xdp_redirect(dev, xdp, to, 0, map, index);
+	 trace_xdp_redirect(dev, xdp, to, 0, map, index)
 
 #define _trace_xdp_redirect_map_err(dev, xdp, to, map, index, err)	\
-	 trace_xdp_redirect_err(dev, xdp, to, err, map, index);
+	 trace_xdp_redirect_err(dev, xdp, to, err, map, index)
 
 /* not used anymore, but kept around so as not to break old programs */
 DEFINE_EVENT(xdp_redirect_template, xdp_redirect_map,
-- 
2.18.4

