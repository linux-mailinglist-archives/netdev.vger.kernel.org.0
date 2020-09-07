Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF2725FFE6
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 18:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730878AbgIGQlS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 12:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730933AbgIGQkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 12:40:25 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16341C061756
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 09:40:24 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id o5so16382855wrn.13
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 09:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dmD2b8RGT1c+PL+8f8t7lEov0+eIeTHs2a/hYyfmvv8=;
        b=EdcltclXIb0L7iqZaFmlFZpp8qdLKnXAL2omTAKGhcG8eJ1b8SX9dco7Ui4ka/6NNx
         IwfQRvVzZwfMBfKYiJDpPlKc2zvGfkhD8ZpWj/NvwV3zgNg3BR8hFsdudATYLrTNXI3E
         8pEGDzFatNWDuxjELS9idZmiXPizgK1NaCAwaGldEOLvOTXzn7bmYaGx2aXve+UZfwCa
         siFf6dWudNRU2iXdD1cMa96vJOKsHWSXUAfbMcLzMRWCXqv8Pwzv5cFSQ6nrMYuPmNoH
         cLEBjQKJaf994SciO1CLyfmlaILNTTabTt0kzaHcb2ehkNqV+anJlifzWjARz9KkuPEi
         I20Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dmD2b8RGT1c+PL+8f8t7lEov0+eIeTHs2a/hYyfmvv8=;
        b=O+7L71ZPaIcd7k0IcpK37hYF/8BLW2Y4J+BXiXlYvUffNNpK0Ow1LU3krmfv+9K5eY
         D7iml68Gn5UFnjkPmzrN4py/RsoRizZpUJkC1oocDku8zqPnIOXHXx/4j7HMZI/gMu2L
         CF5RsbqbIymu2nSH2FGoPsm7IpjNvxEHFBegBEfs80SIiC69kRXzCFTKKmcPndXZgdKL
         yvH580yv8uv0NLsBtJC9olrpNmmB7YeWzXzI5+HWz2lSSntz2O/Bvy/HSWQh/hqyjVb2
         5bu5w1xBvpRbMYrz0+pppZijC+TRJbi0xnqhn+w5E99/RJYGMqQELykSQDmx7GjaoS1C
         dD1g==
X-Gm-Message-State: AOAM531bDPYDsxUtEslo1xQOwk6Fm5XroUp0WdLFfR1dkRi7/fvc3NMe
        aUb5/bJLgdscvDpWu0sGF00YWjOP2Cq1ipLp
X-Google-Smtp-Source: ABdhPJx9mk/XHsQJvxR3aFpKfZrDwQhWme7+dEKdu79Tn4K1QRVInFlJLIEkcma3dF/ouM+DPChCIg==
X-Received: by 2002:a5d:69c9:: with SMTP id s9mr4767972wrw.348.1599496822762;
        Mon, 07 Sep 2020 09:40:22 -0700 (PDT)
Received: from localhost.localdomain ([194.35.119.187])
        by smtp.gmail.com with ESMTPSA id d2sm9934895wro.34.2020.09.07.09.40.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 09:40:22 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 2/2] selftests, bpftool: add bpftool (and eBPF helpers) documentation build
Date:   Mon,  7 Sep 2020 17:40:17 +0100
Message-Id: <20200907164017.30644-3-quentin@isovalent.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200907164017.30644-1-quentin@isovalent.com>
References: <20200907164017.30644-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

eBPF selftests include a script to check that bpftool builds correctly
with different command lines. Let's add one build for bpftool's
documentation so as to detect errors or warning reported by rst2man when
compiling the man pages.

This also builds and checks warnings for the man page for eBPF helpers,
which is built along bpftool's documentation.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 .../selftests/bpf/test_bpftool_build.sh       | 23 +++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_bpftool_build.sh b/tools/testing/selftests/bpf/test_bpftool_build.sh
index ac349a5cea7e..22fbf1bf6eec 100755
--- a/tools/testing/selftests/bpf/test_bpftool_build.sh
+++ b/tools/testing/selftests/bpf/test_bpftool_build.sh
@@ -85,6 +85,25 @@ make_with_tmpdir() {
 	echo
 }
 
+make_doc_and_clean() {
+	echo -e "\$PWD:    $PWD"
+	echo -e "command: make -s $* doc >/dev/null"
+	# rst2man returns 0 even in case of warnings/errors, so we check that
+	# stderr is empty.
+	make $J -s $* doc |& tee /dev/stderr | [ $(wc -l) -eq 0 ] || false
+	if [ $? -ne 0 ] ; then
+		ERROR=1
+		printf "FAILURE: Errors or warnings when building documentation\n"
+	fi
+	(
+		if [ $# -ge 1 ] ; then
+			cd ${@: -1}
+		fi
+		make -s doc-clean
+	)
+	echo
+}
+
 echo "Trying to build bpftool"
 echo -e "... through kbuild\n"
 
@@ -145,3 +164,7 @@ make_and_clean
 make_with_tmpdir OUTPUT
 
 make_with_tmpdir O
+
+echo -e "Checking documentation build\n"
+# From tools/bpf/bpftool
+make_doc_and_clean
-- 
2.25.1

