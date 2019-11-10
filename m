Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65710F6824
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 10:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbfKJJ0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 04:26:34 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:36589 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbfKJJ0d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 04:26:33 -0500
Received: by mail-lj1-f195.google.com with SMTP id k15so10608059lja.3
        for <netdev@vger.kernel.org>; Sun, 10 Nov 2019 01:26:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8aI8sjWlub3zpRJ8r4fpaJqD6GY3bsTASrTbl6sw7ss=;
        b=tvNtpFENS2mmFCAqz/ZOTYdjpoYKxyEk/pGN2a6uoO/Ao9sK+hHbCf2xaMd6Z1PAVY
         fB1Gal2+zjYVmE9alTs+fL4oQ3XRcTYXiUQsTvaJfh7sAw3GBfBJLrIcNBc3fFbWJeiR
         z1OoyPwAC8sOre56oJbVcH34BP07YSOVOqpSCL6CMfIdqcxHEGiCR7IPDOjVCBhvog8o
         cA2JwDdUoGXwY0+nz1dhVWA16Majv/9Si1mdVbGZ0AVXgQg6pq11oXlHz/mMptwKOBXk
         PU/DBrY3cchclak3Hhw8zXWwz/j7oDJBLly1iei0nU8oMKTgVK5vY0UmBu0eWHm00l/N
         WLxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8aI8sjWlub3zpRJ8r4fpaJqD6GY3bsTASrTbl6sw7ss=;
        b=CtBP3MELBeghqDNvjbcfOKIRxBdNznnl1peGIJusIMoi3CFbh/px5zgPig3LMUTEXC
         L9uJu61k/UpWKb9eCW8WJ6V+2DXUudf+VMsoG94/78mrwQYTIKVqSBp9pU45ieH88Sec
         M/f0ikqDuy5chLU+ZJ8EvVGfVeUzL6Un68jGLQ/ltbuPU5AsqepP4nS+h5SHesGxQTKU
         1469NjrCAn0mXvlGzSR8HJgmo+cFIGXc4Zm4X3cERIbcBuR2NTqSeTy9OxUYNbbXtkv1
         4pH4IQpIF8xXJXN9VHB2GJyPCZfOwoMdXDAG+zjK2gUG6tfIhwAH4Ze0wAJGXjDZqDK9
         S4ew==
X-Gm-Message-State: APjAAAW2utYJ3XUAirb0jVIdEDzeo2m+BL3EXYrVlcrhK9/yLABclTJv
        ZcfGgnf3Oac884s82Yp7/60FGA==
X-Google-Smtp-Source: APXvYqwcNJQjyfscWvq/5dHrCVAAp4pAqlltqEM8iziSqRzOTqevSOlTqB1O8P1FgFUO7gykSFzasw==
X-Received: by 2002:a2e:5c46:: with SMTP id q67mr11997066ljb.42.1573377991746;
        Sun, 10 Nov 2019 01:26:31 -0800 (PST)
Received: from localhost (c-413e70d5.07-21-73746f28.bbcust.telenor.se. [213.112.62.65])
        by smtp.gmail.com with ESMTPSA id o15sm5362013ljc.28.2019.11.10.01.26.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Nov 2019 01:26:31 -0800 (PST)
From:   Anders Roxell <anders.roxell@linaro.org>
To:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        shuah@kernel.org, songliubraving@fb.com,
        Anders Roxell <anders.roxell@linaro.org>
Subject: [PATCH bpf-next 2/2] selftests: bpf: test_tc_edt: add missing object file to TEST_FILES
Date:   Sun, 10 Nov 2019 10:26:16 +0100
Message-Id: <20191110092616.24842-2-anders.roxell@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110092616.24842-1-anders.roxell@linaro.org>
References: <20191110092616.24842-1-anders.roxell@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When installing kselftests to its own directory and running the
test_tc_edt.sh it will complain that test_tc_edt.o can't be find.

$ ./test_tc_edt.sh
Error opening object test_tc_edt.o: No such file or directory
Object hashing failed!
Cannot initialize ELF context!
Unable to load program

Rework to add test_tc_edt.o to TEST_FILES so the object file gets
installed when installing kselftest.

Fixes: 74b5a5968fe8 ("selftests/bpf: Replace test_progs and test_maps w/ general rule")
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
Acked-by: Song Liu <songliubraving@fb.com>
---
 tools/testing/selftests/bpf/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index cc09b5df9403..b03dc2298fea 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -38,7 +38,8 @@ TEST_GEN_PROGS += test_progs-bpf_gcc
 endif
 
 TEST_GEN_FILES =
-TEST_FILES = test_lwt_ip_encap.o
+TEST_FILES = test_lwt_ip_encap.o \
+	test_tc_edt.o
 
 # Order correspond to 'make run_tests' order
 TEST_PROGS := test_kmod.sh \
-- 
2.20.1

