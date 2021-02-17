Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10CC431D3A6
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 02:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbhBQBLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 20:11:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231423AbhBQBJa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 20:09:30 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47AA9C0617A7;
        Tue, 16 Feb 2021 17:08:55 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id y25so4065333pfp.5;
        Tue, 16 Feb 2021 17:08:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MiVaeokbQ1fWDcSWZ7ac5Jz6/tMfL2yhVQN5dJlBHbk=;
        b=QZncIX05i8DnwM1dMWrk2srvmO5i43J4JKbAIY6IdcppAilMWI34QmXeGt0Ut4yPRI
         MDpV3qEXH0FBTHJfRHl516QbhHcShsh+e5OT/n34IsMI8UHneyqa4hC5uBS+c1c31yQ3
         LAb8RZD+jUOPn/ab0vbYRYSWrkMsA9CEiXFmKP9AkTQmZZsx4ui4xkjDwWejQp0jjPjf
         uaJ8qjt+yH4FSnhbXxkepxEb38GrvCP5++qNzWryau8UP/G9YvFMRMnbEG2D5xPOO8/i
         E55CiLVjUn/v/KqR52BGrQVztAtjSJN4nOP4dY7m5jUtjQMGbaZoHVkezCDOr04Go9Oh
         IEiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=MiVaeokbQ1fWDcSWZ7ac5Jz6/tMfL2yhVQN5dJlBHbk=;
        b=LW1OZ6fEOnJ+huV7AHQecaQSSdqJGLjqJK0biycOQR/GGpzWYBoySEBVBxnbbn4d6E
         VJUHvmVneOZCDVLwgo88Hyyt6kvhq9s4nt2eKUmUu6U+JDU1ofvFIpc/g36kFu6i0/7W
         qYjJLcZH4zjXDdNy+0qZCKyPt+1AhOPCO7VeBTr0P2C4ZF5Q8hd8XpWBRo0hpgi0tVr1
         1wu6BiM2uvHG4iOT53eB68ruHouOxTcNrWOEXIJQDqs/m9KWf91OX4V+GX5DUZVVtNmC
         UxwKDKWYipKlonCPPgtWCsyePmbOpJfkgzgb4i6SNaIBg1CWUS+66n1JBO1FkVW1N7+I
         g8Ww==
X-Gm-Message-State: AOAM530Jyk7/W2j8lnn2MUoxot5frg2xN5hKYPXyec3FMJhSyr8esSC6
        hU1Y++wethFvfCp0KPdsOzYhByrb55gN+w==
X-Google-Smtp-Source: ABdhPJxRyb2Ya6+5bqzpp6vf+uDq2zJoR2cCeXRkTc01HAVwai4MkGBGq+faEb+I6CSzGjokjJ2+Ew==
X-Received: by 2002:a65:6418:: with SMTP id a24mr21847515pgv.33.1613524134543;
        Tue, 16 Feb 2021 17:08:54 -0800 (PST)
Received: from localhost.localdomain (c-73-93-5-123.hsd1.ca.comcast.net. [73.93.5.123])
        by smtp.gmail.com with ESMTPSA id c22sm175770pfc.12.2021.02.16.17.08.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 17:08:53 -0800 (PST)
Sender: Joe Stringer <joestringernz@gmail.com>
From:   Joe Stringer <joe@wand.net.nz>
To:     bpf@vger.kernel.org
Cc:     Joe Stringer <joe@cilium.io>, netdev@vger.kernel.org,
        daniel@iogearbox.net, ast@kernel.org, mtk.manpages@gmail.com,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 12/17] tools/bpf: Rename Makefile.{helpers,docs}
Date:   Tue, 16 Feb 2021 17:08:16 -0800
Message-Id: <20210217010821.1810741-13-joe@wand.net.nz>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210217010821.1810741-1-joe@wand.net.nz>
References: <20210217010821.1810741-1-joe@wand.net.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Stringer <joe@cilium.io>

In anticipation of including make targets for other manual pages in this
makefile, rename it to something a bit more generic.

Reviewed-by: Quentin Monnet <quentin@isovalent.com>
Signed-off-by: Joe Stringer <joe@cilium.io>
---
 tools/bpf/{Makefile.helpers => Makefile.docs} | 2 +-
 tools/bpf/bpftool/Documentation/Makefile      | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)
 rename tools/bpf/{Makefile.helpers => Makefile.docs} (95%)

diff --git a/tools/bpf/Makefile.helpers b/tools/bpf/Makefile.docs
similarity index 95%
rename from tools/bpf/Makefile.helpers
rename to tools/bpf/Makefile.docs
index a26599022fd6..dc4ce82ada33 100644
--- a/tools/bpf/Makefile.helpers
+++ b/tools/bpf/Makefile.docs
@@ -3,7 +3,7 @@ ifndef allow-override
   include ../scripts/Makefile.include
   include ../scripts/utilities.mak
 else
-  # Assume Makefile.helpers is being run from bpftool/Documentation
+  # Assume Makefile.docs is being run from bpftool/Documentation
   # subdirectory. Go up two more directories to fetch bpf.h header and
   # associated script.
   UP2DIR := ../../
diff --git a/tools/bpf/bpftool/Documentation/Makefile b/tools/bpf/bpftool/Documentation/Makefile
index f33cb02de95c..bb7842efffd6 100644
--- a/tools/bpf/bpftool/Documentation/Makefile
+++ b/tools/bpf/bpftool/Documentation/Makefile
@@ -16,8 +16,8 @@ prefix ?= /usr/local
 mandir ?= $(prefix)/man
 man8dir = $(mandir)/man8
 
-# Load targets for building eBPF helpers man page.
-include ../../Makefile.helpers
+# Load targets for building eBPF man page.
+include ../../Makefile.docs
 
 MAN8_RST = $(wildcard bpftool*.rst)
 
-- 
2.27.0

