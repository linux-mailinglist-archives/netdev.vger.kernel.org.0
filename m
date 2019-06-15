Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16517470BD
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 17:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbfFOPPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 11:15:00 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39370 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbfFOPPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 11:15:00 -0400
Received: by mail-pf1-f193.google.com with SMTP id j2so3181125pfe.6
        for <netdev@vger.kernel.org>; Sat, 15 Jun 2019 08:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Xk8GqM0y7LWxkpwpgictPnCd9XlrKhR7WE/MIG3kzcI=;
        b=G+lkVhvfRXHc+LRfLIRHPMEJS6Z4/BsQgpDbeBnqrnR26VYxSvgsfy8/R4G+1Kk690
         k61NOdGkFBb+iYzYsrNsj0uc15umGH298nOAvdrIzLKH6WIUUIerbGpCbJwhBWBf5jT5
         PtPmAygFxAEIzNAku4iui29C2taH7qbG8ar+wx2VBgljh/+/JINJahZPcedYQrUB3aWe
         PdOp6XNXsyPE/5Xvs9vUKZKkGfjOdnE6H0pAPZ/Sovplflk4r+BejvHXWyxiiw9HkfAb
         6eOzv3b+0X3Nz7VITuusv9y/ZEO8eQOV+Ohz3KiBABO6pEpUTBNvbGFo8vXStw18ufus
         ikIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Xk8GqM0y7LWxkpwpgictPnCd9XlrKhR7WE/MIG3kzcI=;
        b=bbb4Kzp38gsqGdNhQTzJCPEIy49SK47jFPA34uyf2AkQD54PA7RsC/70EJdb6j/hke
         D1dvWDPVnkCuVSdQ4XP4u9kqBN0nMCaE/Rd+VoEiWum8f1qyWHk0lNSEjgoO9e8fFhIQ
         IAU2tuh3yWCT3qRv+CNDPuAht//1IHlA0G4wcAR1x68mkJEUUoujd40S+OjWrntoShs6
         8F96e5k9gJJtlPhxigGwcVaWWxyoxvMQrr2PvPtcmo0lkKjcXFIrXFbyjkqax2Ua+5ho
         SUEDtZo7YYSOFQcZbslqGM4em3QrQwKo45wgsql75qLISIA7Ae7mEt0P/pu035l6TtAR
         WQqw==
X-Gm-Message-State: APjAAAVqLNB6g0FWcJTKtECL6yVxk+/L7G3ZgjetBqIU8s7N3fIZAYLf
        xt13MpPPGfcWLdIr3v8Kz7B0KXZUHQ==
X-Google-Smtp-Source: APXvYqzcUb/DUDjGS0Lf8Zu6e9gCMNX5mI8YIjwfi4UBZpM3EstW4g/ALCVllMhtvaPX+JGCW808KQ==
X-Received: by 2002:a63:6ecf:: with SMTP id j198mr27487911pgc.437.1560611699308;
        Sat, 15 Jun 2019 08:14:59 -0700 (PDT)
Received: from localhost.localdomain ([111.118.56.180])
        by smtp.gmail.com with ESMTPSA id y22sm6158557pfm.70.2019.06.15.08.14.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 15 Jun 2019 08:14:58 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH 1/2] samples: bpf: remove unnecessary include options in Makefile
Date:   Sun, 16 Jun 2019 00:14:46 +0900
Message-Id: <20190615151447.10546-1-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Due to recent change of include path at commit b552d33c80a9
("samples/bpf: fix include path in Makefile"), some of the
previous include options became unnecessary.

This commit removes duplicated include options in Makefile.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/Makefile | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 34bc7e17c994..0917f8cf4fab 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -176,15 +176,6 @@ KBUILD_HOSTCFLAGS += -I$(srctree)/tools/lib/ -I$(srctree)/tools/include
 KBUILD_HOSTCFLAGS += -I$(srctree)/tools/perf
 
 HOSTCFLAGS_bpf_load.o += -I$(objtree)/usr/include -Wno-unused-variable
-HOSTCFLAGS_trace_helpers.o += -I$(srctree)/tools/lib/bpf/
-
-HOSTCFLAGS_trace_output_user.o += -I$(srctree)/tools/lib/bpf/
-HOSTCFLAGS_offwaketime_user.o += -I$(srctree)/tools/lib/bpf/
-HOSTCFLAGS_spintest_user.o += -I$(srctree)/tools/lib/bpf/
-HOSTCFLAGS_trace_event_user.o += -I$(srctree)/tools/lib/bpf/
-HOSTCFLAGS_sampleip_user.o += -I$(srctree)/tools/lib/bpf/
-HOSTCFLAGS_task_fd_query_user.o += -I$(srctree)/tools/lib/bpf/
-HOSTCFLAGS_xdp_sample_pkts_user.o += -I$(srctree)/tools/lib/bpf/
 
 KBUILD_HOSTLDLIBS		+= $(LIBBPF) -lelf
 HOSTLDLIBS_tracex4		+= -lrt
-- 
2.17.1

