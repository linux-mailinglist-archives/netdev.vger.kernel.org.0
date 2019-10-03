Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B557EC9A32
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 10:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729183AbfJCIoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 04:44:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33658 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728873AbfJCIoE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Oct 2019 04:44:04 -0400
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com [209.85.167.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0574DC058CB8
        for <netdev@vger.kernel.org>; Thu,  3 Oct 2019 08:44:04 +0000 (UTC)
Received: by mail-lf1-f72.google.com with SMTP id m17so198166lfl.11
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 01:44:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PzHNU38txAalUSBk1bXYsOjn6NQRGTI31cw8NynxL64=;
        b=hjXy9fRK7GapzG3Mu7kAAabnHRZuoZWnGVCj0XKUst9MZd5At2+ezxIekuSKnzauiP
         q+u5+fgGhR7CDPaDScVMzl+sKqV4Ae67rUzTgWRkWWJxvdbDPZ+p9O+gYbD7a8QFYFg4
         pH4MEHPUq/sR1jq7RpHEZfzpkJnZ+AKR9NepuCeYHjDEDxiHljt9VsSNyai/BP1Ui2P9
         of3CpwOxcSdrQKrDjQ++Wlm1OUZrR5p37f2ZVxe3gF7hrioAVV3S9GdinK21CwQ1i0pr
         WDmYUc3Wx3sQvYhcmCbigwaLxX4dORUezyQjaQE7+Q7CGIhqCKkt98I34ouipUb7qKp5
         Pr/w==
X-Gm-Message-State: APjAAAUSa+m6NjQrHQ/mxNSKN24c9X3VN132+1gOSGcagF0njt7I1ALo
        1CWkw4UMD9kEsKN1EH3YeCaWT1M6XVPplxBNWblgGEXafBgorVqVEkyNDMJD6ptDat+6KDgfqZs
        MyQVitjIQSvw67/Br
X-Received: by 2002:ac2:554e:: with SMTP id l14mr5402765lfk.32.1570092242529;
        Thu, 03 Oct 2019 01:44:02 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzymPFpuHFhKyn5oDKRe5DTDqE/dYm4jA2UMZk2t+bMfLInhNq6QEEiptCNN8oaPdEOGvNveQ==
X-Received: by 2002:ac2:554e:: with SMTP id l14mr5402755lfk.32.1570092242360;
        Thu, 03 Oct 2019 01:44:02 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id w30sm308525lfn.82.2019.10.03.01.44.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 01:44:01 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 4D69018063D; Thu,  3 Oct 2019 10:44:00 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     daniel@iogearbox.net, ast@fb.com
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        andriin@fb.com, bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next] libbpf: Add cscope and TAGS targets to Makefile
Date:   Thu,  3 Oct 2019 10:43:21 +0200
Message-Id: <20191003084321.1431906-1-toke@redhat.com>
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

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/.gitignore |  2 ++
 tools/lib/bpf/Makefile   | 10 +++++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/.gitignore b/tools/lib/bpf/.gitignore
index d9e9dec04605..c1057c01223e 100644
--- a/tools/lib/bpf/.gitignore
+++ b/tools/lib/bpf/.gitignore
@@ -3,3 +3,5 @@ libbpf.pc
 FEATURE-DUMP.libbpf
 test_libbpf
 libbpf.so.*
+TAGS
+cscope.*
diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index c6f94cffe06e..57df6b933196 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -262,7 +262,7 @@ clean:
 
 
 
-PHONY += force elfdep bpfdep
+PHONY += force elfdep bpfdep cscope TAGS
 force:
 
 elfdep:
@@ -271,6 +271,14 @@ elfdep:
 bpfdep:
 	@if [ "$(feature-bpf)" != "1" ]; then echo "BPF API too old"; exit 1 ; fi
 
+cscope:
+	(echo \-k; echo \-q; for f in *.c *.h; do echo $$f; done) > cscope.files
+	cscope -b -f cscope.out
+
+TAGS:
+	rm -f TAGS
+	echo *.c *.h | xargs etags -a
+
 # Declare the contents of the .PHONY variable as phony.  We keep that
 # information in a variable so we can use it in if_changed and friends.
 .PHONY: $(PHONY)
-- 
2.23.0

