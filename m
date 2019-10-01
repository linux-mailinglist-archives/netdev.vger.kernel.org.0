Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A863C310B
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 12:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729892AbfJAKOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 06:14:48 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38834 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728579AbfJAKOs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 06:14:48 -0400
Received: by mail-pf1-f194.google.com with SMTP id h195so7588016pfe.5;
        Tue, 01 Oct 2019 03:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MFZWUe48F8FqF4puV27MK9pas35/k3jXlnTHpBQA4kI=;
        b=tPtiDHgVTz9FuodjoVwI/15unxtBd5b2D5c7F2SwnVxjaWcqBtkz5zc8Jbxej05NHi
         4aRjQu+XJYO6yudOSNfnSUhRswSXhXZZ1TPdAeFqEv+acI9AWoabh7HouzGXmRNFJuZa
         rqPAbrNrO6dNp86oKvUoWyZRu1vkz9SJLmMBfo+zx4QfJyPEYRzHHJLk4RH11nQ9eiZr
         yO9a7ZgiWZCweONVkT9VTCLlikpKjpX+oehsCF5Bt7w01IO6vh/B3X0JAmn3HbshJhBv
         l1qqhgLGXIdbpiDcFqdTEZR+jHuHlxoa+6gfqs1a/ev32Y0UY/MkqwcWGuIHUzY25fqv
         RGmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MFZWUe48F8FqF4puV27MK9pas35/k3jXlnTHpBQA4kI=;
        b=QC08DZEyOyGhB/WoR/sX1fg9BUzI5pak6frz4X2XzdC8kP2SLGhf6Ja/qMahBVxLyw
         l+I5N+taI2v1PnEGPBX1GvvloKfIzZkSOrKT30VxYcGuzSkxAYM9gKIlIAUSc3NLPInz
         PJhVlxoS7EQ8OficUeF/J5ZsDRKfKoTLyyWLWxNhwFrRQ9uV2ceMkzpcUGFY25MIZPXR
         AUfhZeucoQPul8D9Y0EdoqRmm/9gzqfZ5L/tnJjqX3vyWmmqLUWnwISNC9CwI3cREmxx
         /uZ+fuo1AWI31QI5iMEtpf+Bin6DJpGnr8hU4cYHfLORIoGuUU4Ah2OsE6OBP9BYvsRd
         0Oqg==
X-Gm-Message-State: APjAAAV49NheYO6L5oo8bAqCkTObjvc8+nnuyNPJla+nMP2rFR8/RpTn
        IA7nE31eWqruiljHEqL/Ftq1Y4E+Bm8=
X-Google-Smtp-Source: APXvYqwUnQKAuUPX3sdRWyh6/fvfyf/Mh8LXCsvtltOZ9RVvj24UPwyDsycpJVmn+KymcxZ0sn0nkg==
X-Received: by 2002:a63:ab05:: with SMTP id p5mr29354893pgf.414.1569924886959;
        Tue, 01 Oct 2019 03:14:46 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.43])
        by smtp.gmail.com with ESMTPSA id x10sm23976125pfr.44.2019.10.01.03.14.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 03:14:46 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        linux-kbuild@vger.kernel.org, bpf@vger.kernel.org,
        yamada.masahiro@socionext.com
Subject: [PATCH bpf] samples/bpf: kbuild: add CONFIG_SAMPLE_BPF Kconfig
Date:   Tue,  1 Oct 2019 12:14:29 +0200
Message-Id: <20191001101429.24965-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

This commit makes it possible to build the BPF samples via a Kconfig
option, CONFIG_SAMPLE_BPF. Further, it fixes that samples/bpf/ could
not be built due to a missing samples/Makefile subdir-y entry, after
the introduction of commit 394053f4a4b3 ("kbuild: make single targets
work more correctly").

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 samples/Kconfig  | 4 ++++
 samples/Makefile | 1 +
 2 files changed, 5 insertions(+)

diff --git a/samples/Kconfig b/samples/Kconfig
index c8dacb4dda80..054297ac89ad 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -169,4 +169,8 @@ config SAMPLE_VFS
 	  as mount API and statx().  Note that this is restricted to the x86
 	  arch whilst it accesses system calls that aren't yet in all arches.
 
+config SAMPLE_BPF
+	bool "BPF samples"
+	depends on HEADERS_INSTALL
+
 endif # SAMPLES
diff --git a/samples/Makefile b/samples/Makefile
index 7d6e4ca28d69..49aa2f7d044b 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -20,3 +20,4 @@ obj-$(CONFIG_SAMPLE_TRACE_PRINTK)	+= trace_printk/
 obj-$(CONFIG_VIDEO_PCI_SKELETON)	+= v4l/
 obj-y					+= vfio-mdev/
 subdir-$(CONFIG_SAMPLE_VFS)		+= vfs
+subdir-$(CONFIG_SAMPLE_BPF)		+= bpf
-- 
2.20.1

