Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC83CCC7C
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 21:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729389AbfJETW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 15:22:27 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:40666 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728961AbfJETW1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 15:22:27 -0400
Received: by mail-pl1-f195.google.com with SMTP id d22so4762124pll.7
        for <netdev@vger.kernel.org>; Sat, 05 Oct 2019 12:22:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sage.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=egI3Lzn5J+3ZS1vrYh1u58rnDHSDofBO/EJHma4TvZU=;
        b=DLnlnW6oTYVZbnSF3kDpJ4PKFM6Je8A9tUucSZBn5Mu9i6xqh8Kr48xCpSD+waX1+s
         Zb6vC49HzuPX95Kwck1azeOfyh5Wd2FnUwxqAX2vMv9XD5gOnhTYajSHC5dgU89sP2/F
         /QdOlM/uPHiKTo3spnUL7TfoAp5lfD2+b7vEzQ9BT/tk3agzlkLuro0HarCXdKePyN+s
         iQfG8o6HR2VGr4fMglfylC7uKa+A0sKlicCoTPys99i4G45gSmTcuJqnmpb0iWvB6YuF
         5i5y3a/BY59ceMwF3sGJjeQ+WbDkbJIRaAGif8uPMh9uyA1dZ45lofsU4zn0RSnLI02X
         Mj7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=egI3Lzn5J+3ZS1vrYh1u58rnDHSDofBO/EJHma4TvZU=;
        b=ufuIaxBhikj0hBdvgphzRSHKsyAPnFB/ZqLSHJL5rJXAt9TcXGDUCKs6oR4zQ5DmEh
         ZczFbxKfuZ2gKJ6MpfjfuBhSU1nHMfS7DoHIpsWIcKJqw53p6q1TAYZYVsll8Fg9qmHl
         ropbGuPrTCD13UFlIbXDlkqBKIr/Op+uTMEIxXWtBCNJQPTPjdWo5yr08vAYRTyK2oyk
         IxPcvvQz/aS4o13+Eeg6EXbvw08ZvktC6L2zAg++RVOw/G9MPo9Y3LmdYjU4vo4YL8sL
         v7kcQzolsO45UC5tRsHKcOulHNNk7LRD+8pfXv2NB4Xn6Dy2sbRr9d2ojmbpLh4NjrSP
         q/Cg==
X-Gm-Message-State: APjAAAWG6BiPAJTPtfYWCS1wcvtMN4CErNnIoXj+H3dW1TDyTks1WB+J
        keLsWAg+0eM6/DU9B7LtWpaKWymnTUyRCKJL
X-Google-Smtp-Source: APXvYqzMkpr2ME4mA22jKU19DERTN42LvgfIBDtz6oU18uFC107kOFDOaJAsxNobGKOEewxGTsB4zQ==
X-Received: by 2002:a17:902:8691:: with SMTP id g17mr21247589plo.141.1570303345996;
        Sat, 05 Oct 2019 12:22:25 -0700 (PDT)
Received: from dev-instance.c.sage-org.internal (143.139.82.34.bc.googleusercontent.com. [34.82.139.143])
        by smtp.googlemail.com with ESMTPSA id b14sm10462336pfi.95.2019.10.05.12.22.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Oct 2019 12:22:25 -0700 (PDT)
From:   Eric Sage <eric@sage.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, daniel@iogearbox.net,
        xdp-newbies@vger.kernel.org, ast@kernel.org,
        Eric Sage <eric@sage.org>
Subject: Re: samples/bpf not working?
Date:   Sat,  5 Oct 2019 19:20:41 +0000
Message-Id: <20191005192040.20308-1-eric@sage.org>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <CAEKGpzhoYHrE4NTvaWSpy-R6CiLYehGHzLM6v+-9j8iemNyK0g@mail.gmail.com>
References: <CAEKGpzhoYHrE4NTvaWSpy-R6CiLYehGHzLM6v+-9j8iemNyK0g@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

394053f4a4b3 ("kbuild: make single targets work more correctly")
changed the way single target builds work. For example,
'make samples/bpf/' in the previous commit matched:

Makefile:1787
%/: prepare FORCE
  $(Q)$(MAKE) KBUILD_MODULES=1 $(build)=$(build-dir) need-modorder=1

So that 'samples/bpf/Makefile' was processed directly.
Commit 394053f4a4b3 removed this rule and now requires that
'CONFIG_SAMPLES=y' and that 'bpf/' be added to 'samples/Makefile'
so it is added to the list of targets processed by the new
'ifdef single-build' section of 'scripts/Makefile.build'.

This commit adds a new 'CONFIG_SAMPLE_BPF' under 'CONFIG_SAMPLES' to
match what the other sample subdirs have done.

Signed-off-by: Eric Sage <eric@sage.org>
---
 samples/Kconfig  | 6 ++++++
 samples/Makefile | 1 +
 2 files changed, 7 insertions(+)

diff --git a/samples/Kconfig b/samples/Kconfig
index c8dacb4dda80..396e87ba97e0 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -6,6 +6,12 @@ menuconfig SAMPLES
 
 if SAMPLES
 
+config SAMPLE_BPF
+	tristate "Build bpf examples"
+	depends on EVENT_TRACING && m
+	help
+	  This builds the bpf example modules.
+
 config SAMPLE_TRACE_EVENTS
 	tristate "Build trace_events examples -- loadable modules only"
 	depends on EVENT_TRACING && m
diff --git a/samples/Makefile b/samples/Makefile
index 7d6e4ca28d69..e133a78f3fb8 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -2,6 +2,7 @@
 # Makefile for Linux samples code
 
 obj-$(CONFIG_SAMPLE_ANDROID_BINDERFS)	+= binderfs/
+obj-$(CONFIG_SAMPLE_BPF) += bpf/
 obj-$(CONFIG_SAMPLE_CONFIGFS)		+= configfs/
 obj-$(CONFIG_SAMPLE_CONNECTOR)		+= connector/
 subdir-$(CONFIG_SAMPLE_HIDRAW)		+= hidraw
-- 
2.18.1

