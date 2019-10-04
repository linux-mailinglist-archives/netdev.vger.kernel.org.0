Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB8CECBF49
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 17:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389839AbfJDPfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 11:35:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50094 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389620AbfJDPfn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Oct 2019 11:35:43 -0400
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com [209.85.167.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A487763704
        for <netdev@vger.kernel.org>; Fri,  4 Oct 2019 15:35:42 +0000 (UTC)
Received: by mail-lf1-f72.google.com with SMTP id t84so745026lff.10
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 08:35:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mSjDVZs7yZyvp7tYsPDuu5P8/DKobkJVpszPyt8bpUc=;
        b=ASvwPFbnNln+IS/0Sz7HhKFUR586xXTAysUinFLazuIq2MHkw8/cugqmERVKmPccU1
         axbxCYS7Va5sUzf7AEj5xBT1XvhVoySV8Mmpt9/jZw1RDOdiHY4WGlGEF1VQFIjKV0BZ
         P+q1cIoM45ymePLQYbbzXJz75zHziN4ltMNOxjaDr94bN7Kd5W6Gh1tShUe62wOdTdAK
         PDqKG2IJGSjDE07yv8vwSCsp9WH+x7tE7+PbW6A/VstWGjRYKsbni0fJaOvWgxdaozeb
         p7tWpwE/KFe1spIObO3VH/cAJDDEOsEb1ER/zQH1QzSX4n54dXr7aSanOVb/kWEbQDEp
         XgJQ==
X-Gm-Message-State: APjAAAWYNfxPyErV9ZwQaCIBXHRGx5zuKqHym/ww5DJLMhRRakYhXD9Z
        bByBmWzf1YAHC1uxTRbe9EHBoRgIfskbAlmHV6/ojyvULEtqM2PVqH3Ql3faMCOBjBug3R8KZZ4
        UQtN3HXw8Hk+kOHGB
X-Received: by 2002:a2e:761a:: with SMTP id r26mr2099112ljc.137.1570203340893;
        Fri, 04 Oct 2019 08:35:40 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwoYEsKvr2RkSp5/QzdVvpyKMaf0KNWME56kF4E7XcDEzvNiA1999Zz+XpiUMEVFG8ob39KdA==
X-Received: by 2002:a2e:761a:: with SMTP id r26mr2099099ljc.137.1570203340726;
        Fri, 04 Oct 2019 08:35:40 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id d3sm1316121ljc.66.2019.10.04.08.35.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 08:35:40 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 1E9FA18063D; Fri,  4 Oct 2019 17:35:39 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     daniel@iogearbox.net, ast@fb.com
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        andriin@fb.com, bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next v2] libbpf: Add cscope and tags targets to Makefile
Date:   Fri,  4 Oct 2019 17:34:44 +0200
Message-Id: <20191004153444.1711278-1-toke@redhat.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using cscope and/or TAGS files for navigating the source code is useful.
Add simple targets to the Makefile to generate the index files for both
tools.

Acked-by: Andrii Nakryiko <andriin@fb.com>
Tested-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
v2:
  - Use lower-case 'tags' for Makefile target
  - Use -I to cscope instead of -k
  - Support both ctags and etags
  - Pass options directly to cscope instead of putting them in cscope.files
  - Use 'ls' to list files
 tools/lib/bpf/.gitignore |  3 +++
 tools/lib/bpf/Makefile   | 12 +++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/.gitignore b/tools/lib/bpf/.gitignore
index d9e9dec04605..12382b0c71c7 100644
--- a/tools/lib/bpf/.gitignore
+++ b/tools/lib/bpf/.gitignore
@@ -3,3 +3,6 @@ libbpf.pc
 FEATURE-DUMP.libbpf
 test_libbpf
 libbpf.so.*
+TAGS
+tags
+cscope.*
diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index c6f94cffe06e..10b77644a17c 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -133,6 +133,8 @@ LIB_TARGET	:= $(addprefix $(OUTPUT),$(LIB_TARGET))
 LIB_FILE	:= $(addprefix $(OUTPUT),$(LIB_FILE))
 PC_FILE		:= $(addprefix $(OUTPUT),$(PC_FILE))
 
+TAGS_PROG := $(if $(shell which etags 2>/dev/null),etags,ctags)
+
 GLOBAL_SYM_COUNT = $(shell readelf -s --wide $(BPF_IN) | \
 			   cut -d "@" -f1 | sed 's/_v[0-9]_[0-9]_[0-9].*//' | \
 			   awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$8}' | \
@@ -262,7 +264,7 @@ clean:
 
 
 
-PHONY += force elfdep bpfdep
+PHONY += force elfdep bpfdep cscope tags
 force:
 
 elfdep:
@@ -271,6 +273,14 @@ elfdep:
 bpfdep:
 	@if [ "$(feature-bpf)" != "1" ]; then echo "BPF API too old"; exit 1 ; fi
 
+cscope:
+	ls *.c *.h > cscope.files
+	cscope -b -q -I $(srctree)/include -f cscope.out
+
+tags:
+	rm -f TAGS tags
+	ls *.c *.h | xargs $(TAGS_PROG) -a
+
 # Declare the contents of the .PHONY variable as phony.  We keep that
 # information in a variable so we can use it in if_changed and friends.
 .PHONY: $(PHONY)
-- 
2.23.0

