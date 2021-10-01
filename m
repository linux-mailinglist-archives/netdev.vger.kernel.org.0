Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED7AF41EB6E
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 13:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353582AbhJALLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 07:11:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353580AbhJALLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 07:11:08 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8A93C061775
        for <netdev@vger.kernel.org>; Fri,  1 Oct 2021 04:09:23 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id d21so14842097wra.12
        for <netdev@vger.kernel.org>; Fri, 01 Oct 2021 04:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=C6sdHrUdi9BDM1rYxYocEEgrTC9SSamTyBYNfJp2XuY=;
        b=TfR2ECMeIMEB4jKJmdANQyuA9XvSqRaRtg9g9hX1rmkNVhULUrtfpaluTnH9c1htJk
         qoSXyeeEh1koKk9Zo47+rBcwiSKE1/XmVVFLmiiv4+W64tYufacXtbGc+kLGCZ+fXQwe
         2+eX9QDJtiaMAnG7VSrQwNOp5o19U8rziT2aPsycSIEMO93OT2W/shYTO9jao4OEBFLN
         n8LENfdDw+Yypky8vcEEobz/PCG32Lhall42NYyQxDL3Xg+pA7q3UsuaFCmqdsV8tr/8
         hNHITaczwyNJ/MhZmemr0ViCa2XeCqz6r9bEeY6qs6GXC+4mbazu6NsZEi6q/fRUTbro
         aO/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C6sdHrUdi9BDM1rYxYocEEgrTC9SSamTyBYNfJp2XuY=;
        b=26WSRvldq+lzj1SOzdy7WkHM6d+yLiszWlNbXWawI7LCxyKpiKEZBNCDrSNL9+ugZ7
         bF5KIajnYhYL/wkfSEcCnazNnTGCVzX5I0WHlXPuZmS6Aj0PIYa/1KUTUY9fpJrWfPwO
         +P4JGYyAKfz3atk3bPJLpAH6oyfBfVkWG+/+XGjgzs3PKYlve8+5nz7xpbptiVwET/TZ
         dqFzKJZQHWxuRK8OLQLSPYa+tOTO0JKfwh6SEfg40Kq/mEnJ6mFqd3NWSozy99ezYZcX
         pa7omDy7t69BF2v79MJkhN4BDw++ygwafFcR/9Bb7p+oh75KlQnoyI/NLCepj5jD66O9
         gjMw==
X-Gm-Message-State: AOAM532iHqKXMBwSdZXOm1cmOgplngXJiT6C0Bqo4b7LLrRUHnm0JQvF
        TPM4OFx/wW+5lPaFotVga+h1YQ==
X-Google-Smtp-Source: ABdhPJy1ada11pnipFClBMI16iIRjtiTPaJQK/V9WOnFbkMqYdNAX39z5VvgD/ZyyY4ayfskSYNyzA==
X-Received: by 2002:adf:fb89:: with SMTP id a9mr11578044wrr.164.1633086562462;
        Fri, 01 Oct 2021 04:09:22 -0700 (PDT)
Received: from localhost.localdomain ([149.86.91.69])
        by smtp.gmail.com with ESMTPSA id v17sm5903271wro.34.2021.10.01.04.09.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 04:09:22 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v2 1/9] tools: bpftool: remove unused includes to <bpf/bpf_gen_internal.h>
Date:   Fri,  1 Oct 2021 12:08:48 +0100
Message-Id: <20211001110856.14730-2-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211001110856.14730-1-quentin@isovalent.com>
References: <20211001110856.14730-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It seems that the header file was never necessary to compile bpftool,
and it is not part of the headers exported from libbpf. Let's remove the
includes from prog.c and gen.c.

Fixes: d510296d331a ("bpftool: Use syscall/loader program in "prog load" and "gen skeleton" command.")
Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/bpftool/gen.c  | 1 -
 tools/bpf/bpftool/prog.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index cc835859465b..b2ffc18eafc1 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -18,7 +18,6 @@
 #include <sys/stat.h>
 #include <sys/mman.h>
 #include <bpf/btf.h>
-#include <bpf/bpf_gen_internal.h>
 
 #include "json_writer.h"
 #include "main.h"
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 9c3e343b7d87..7323dd490873 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -25,7 +25,6 @@
 #include <bpf/bpf.h>
 #include <bpf/btf.h>
 #include <bpf/libbpf.h>
-#include <bpf/bpf_gen_internal.h>
 #include <bpf/skel_internal.h>
 
 #include "cfg.h"
-- 
2.30.2

