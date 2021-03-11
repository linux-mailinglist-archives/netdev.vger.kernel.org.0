Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73A34337FE0
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 22:49:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbhCKVsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 16:48:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbhCKVsj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 16:48:39 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDD7CC061574
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 13:48:38 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id cl21-20020a17090af695b02900c61ac0f0e9so3825591pjb.1
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 13:48:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3+CIhpA1m62Ph557v4cOEjCgNrX3ZeXRVo+vSbxcOIA=;
        b=Q7srQEBm9GSYUqtFO7m7ol/3TfksJuPrWe7oMh0mbXNfnnk4UOXxeV8J9ObnJYzPqJ
         DfnvmtUDXcPvWOXP6gV3TaPhLz67DzYrC4sUX4sqLsFiMi1u3ozYD1/gCkMFbygL02Oq
         dMXHqhVWyhgFeomAyDdyR2Znrrcw6ODr5qd1B0CAvYtJ7WC2Xtm9yaoUlEzji8D5XE8n
         LHgk5vRMYuZM3vw+w64eWJygFqKivU62TqPqhiWdu4AAdp1eyFKiWFuiIdEc83dmQC84
         rQV+d3iFD22axo4dImUgI8HRrdkI7tPLZi/loAhFD3OJkVL6OgLNrnJfnSjRf1cHdTDN
         BpRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3+CIhpA1m62Ph557v4cOEjCgNrX3ZeXRVo+vSbxcOIA=;
        b=Ox1yxohlpQ0O8ni1RebifPyWJWO+pb6DfGl323hjKffAvmQmkfGBDZ2o0N0CHT55rR
         Gm1ZYEl891VV5rq8NSeme2ZIBXRgoevEyMIWTeadHj0rODMa3+pg3aI+mV3+W0QRL2l2
         WOsuxZwOno7IzV9v/kl4O2WLS/cvhY2p5xPODVqOxtcCuZEZnX1q/uhA0iyFjdbMaO0G
         IK/UmbgFOtUNKZ/H10cPLTNBolz6vT9cYtSANlDSvhVFLjkwGS+YAl4RFl35HWOUJBSI
         gvqLlfcGhBalKRQYfsLc2siO/bC+bQzzSKliGQh/S6Reb215NT4fmG73CaUjGVLbAfOC
         nhOg==
X-Gm-Message-State: AOAM533f0PYr6eTuZsLYaz5NcKhgmSdQmJlTSOxomqj1FtMwEVJFDSjx
        bV8w5bjQ4Yw0V2nVFYXeXr0=
X-Google-Smtp-Source: ABdhPJzicsjzk9PusYqdRCiLQo4oS1ycnfasKeWYpvcSy+d/euR6kddeOjcfvi4daAYuVOfxShiJjg==
X-Received: by 2002:a17:90a:d907:: with SMTP id c7mr10407014pjv.45.1615499318273;
        Thu, 11 Mar 2021 13:48:38 -0800 (PST)
Received: from localhost.localdomain ([2001:470:e92d:10:c82a:4639:bab2:3dcf])
        by smtp.gmail.com with ESMTPSA id n11sm3120022pgm.30.2021.03.11.13.48.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 13:48:37 -0800 (PST)
From:   Tony Ambardar <tony.ambardar@gmail.com>
X-Google-Original-From: Tony Ambardar <Tony.Ambardar@gmail.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Tony Ambardar <Tony.Ambardar@gmail.com>, netdev@vger.kernel.org,
        Rui Salvaterra <rsalvaterra@gmail.com>
Subject: [PATCH iproute2] lib/bpf: add missing limits.h includes
Date:   Thu, 11 Mar 2021 13:47:54 -0800
Message-Id: <20210311214754.3566712-1-Tony.Ambardar@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Several functions in bpf_glue.c and bpf_libbpf.c rely on PATH_MAX, which is
normally included from <limits.h> in other iproute2 source files.

It fixes errors seen using gcc 10.2.0, binutils 2.35.1 and musl 1.1.24:

bpf_glue.c: In function 'get_libbpf_version':
bpf_glue.c:46:11: error: 'PATH_MAX' undeclared (first use in this function);
did you mean 'AF_MAX'?
   46 |  char buf[PATH_MAX], *s;
      |           ^~~~~~~~
      |           AF_MAX

Reported-by: Rui Salvaterra <rsalvaterra@gmail.com>
Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
---
 lib/bpf_glue.c   | 2 ++
 lib/bpf_libbpf.c | 1 +
 2 files changed, 3 insertions(+)

diff --git a/lib/bpf_glue.c b/lib/bpf_glue.c
index d00a0dc1..eaa9504f 100644
--- a/lib/bpf_glue.c
+++ b/lib/bpf_glue.c
@@ -4,6 +4,8 @@
  * Authors:	Hangbin Liu <haliu@redhat.com>
  *
  */
+#include <limits.h>
+
 #include "bpf_util.h"
 #ifdef HAVE_LIBBPF
 #include <bpf/bpf.h>
diff --git a/lib/bpf_libbpf.c b/lib/bpf_libbpf.c
index d05737a4..864f8c35 100644
--- a/lib/bpf_libbpf.c
+++ b/lib/bpf_libbpf.c
@@ -13,6 +13,7 @@
 #include <stdint.h>
 #include <errno.h>
 #include <fcntl.h>
+#include <limits.h>
 
 #include <libelf.h>
 #include <gelf.h>
-- 
2.25.1

