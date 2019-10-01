Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1182C3262
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 13:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731338AbfJALXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 07:23:04 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45333 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbfJALXE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 07:23:04 -0400
Received: by mail-pg1-f194.google.com with SMTP id q7so9382613pgi.12;
        Tue, 01 Oct 2019 04:23:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3RJ117gHi9sUj8qt+VBfFz4EZYQo2wfsZBAfmwAinyI=;
        b=bWpao1UbKLZ5vdfFFpvQBVnrWMGZwrWXh5RH0yoT0CFcWQZsyod03p7/fg3sK1RoaJ
         M5lhkKCaUSDoqalvZbEQXwsQAvlatomKNJHb16rTalnD5qdWfnIkF7opmdS4kleOV7af
         bFofljbGiaBbR9PuYeQFnECoYVNo07aP2DkonJQ1MIGz17VvN8jXMS09cOKqGVcv5As1
         KzR+F4lVMtxm2OpAe62THuRKAyWVTtt7to+3CoXbiXdEqbtjiCfseUd9gTJbLrZdkFqt
         l+OjLSCyf2WZ6iW7vLK3x4Z6Oaf/nJqi3LYCcVaG36wD4SJNhRBGPIx4eiPgp1aPdiXZ
         o3AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3RJ117gHi9sUj8qt+VBfFz4EZYQo2wfsZBAfmwAinyI=;
        b=GhxJwLDktfCM1IT6WI3ercTi/9ft8EY62kZnWA3OdC+z/VC2b8w680OixnF4tV2a0g
         IT+G1DJDrep+1VcD9LRqDGOERosAZ1emY69PjYY+8ZukG3nrSZsrDuYaookvlA2zRsJy
         FX0mjUqi+eP49jpm4JIwkkUYjQjDKn687wWqUr2cpQAcUbORKVGcQDnm7KTbgQGXdRrt
         CmbFGEwhWIYxzECCIs6wou2FQQ24+jiP900OYrOwQ6ba490QsufxL5HavvcZfMG1+OpF
         8qFp7MxBdiSEBxQ+0M/uZPEgTrl5SpnwfJqI3/1OWph3Pl4jq6CjwuoNQsW8CVbvGbus
         vnvg==
X-Gm-Message-State: APjAAAXoS3dHee+s+y9r2Q9on0bVybMMrxM89Iw3aJ7EKgyaH/RKdEVE
        ty0RuhQwUvNabOSzPA7hLweG9TBYKVU=
X-Google-Smtp-Source: APXvYqyuiSulkSxXtffHndOosj4twhj2q6JGfb2gAtGd+/2qcb6hdjXV7GqmuKRbg7qHWFjcHBi3Gg==
X-Received: by 2002:a63:2216:: with SMTP id i22mr29406263pgi.430.1569928982981;
        Tue, 01 Oct 2019 04:23:02 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id h1sm15849488pfk.124.2019.10.01.04.22.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 04:23:02 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org
Subject: [PATCH bpf] samples/bpf: fix build for task_fd_query_user.c
Date:   Tue,  1 Oct 2019 13:22:49 +0200
Message-Id: <20191001112249.27341-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Add missing "linux/perf_event.h" include file.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 samples/bpf/task_fd_query_user.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/samples/bpf/task_fd_query_user.c b/samples/bpf/task_fd_query_user.c
index e39938058223..4c31b305e6ef 100644
--- a/samples/bpf/task_fd_query_user.c
+++ b/samples/bpf/task_fd_query_user.c
@@ -13,6 +13,7 @@
 #include <sys/resource.h>
 #include <sys/types.h>
 #include <sys/stat.h>
+#include <linux/perf_event.h>
 
 #include "libbpf.h"
 #include "bpf_load.h"
-- 
2.20.1

