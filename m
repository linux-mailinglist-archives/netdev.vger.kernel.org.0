Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD91A96083
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 15:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730412AbfHTNld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 09:41:33 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:32805 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730386AbfHTNl1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 09:41:27 -0400
Received: by mail-lf1-f66.google.com with SMTP id x3so4174701lfc.0
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 06:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RAAFc3+apg9ghKgSz+2bVCqiXJK62BSpSIfioRn9dmg=;
        b=MTqrFrq7NfIcYX9hZQL8gHvCMgEAMVDAzMl6TymnK6KbYCaZv69caw+OpIpdvI9Px5
         gDX4Zxaq2sS7V5U6g6Y/wPqNyTlwjF4jy+xRb9RcnrN+1+KuJ4n09lIPFEtdM8WlqHsh
         ia6xuVPFx58wyVZKboIoFB4vQsEsMVTB9yIIUxgUBd7I431PQ+F7yu9v2iL3YFwYYgR+
         HWqVclyuJVe663v+Ns1j9KQ/wgT0wbivkUt1hyUgsaPfOD6Gb5ed0vWf0QBRIQGp52ks
         Qvr00G+cTcj6ScQunx7eluB+rl8OBiBc8XVMdWN9nWDKOD6Vu21s8yo0bPQeJ4u5lZwE
         hgng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RAAFc3+apg9ghKgSz+2bVCqiXJK62BSpSIfioRn9dmg=;
        b=DOnTIfq/1R95lUsGG183rL9Aj1+SkVjmDxsPveYx9p8s0rT+eDli19cv6Z/KX9uQeM
         5t7s3KAwEBkWfOxAY4/vGpHrcLRTdpLwT6Ogv73m6G2kQlGneZMNj9YypO3n2znP+eQt
         3icsYBNJImw6UdQ73uAKy+OOiQ6JaxLHiy0gHGKjsums4y8O75H9obri6E2eAAhwGHFP
         Mk5KiLT2pMVvEkBre1ggSMicPL2YQxM1ZozVT8XlPaNJdlJ3WxsnVD4KjXzkDN+cvji4
         omtSp3kJSoINj/jTMkKY5I6X1ne3O+pfUBxh59axIdOmf4UqeLUQn9nqx6u20JRCN9Fm
         aaKQ==
X-Gm-Message-State: APjAAAWUMpt7q+oCTUKnHg3DJn/2T2Q6nEB4iPkZZ9dTWC3YGWUVxww9
        50wKqTg2ERz5CSy1jmC7pNDRGA==
X-Google-Smtp-Source: APXvYqyvwdCS8wFTEeve9kgL335NwHhmLcAkFv5HfhnI2TJSfJ1PR0BGeJVDiZ1r7BJ+GzhNm2aF+g==
X-Received: by 2002:ac2:4a75:: with SMTP id q21mr14989391lfp.175.1566308486105;
        Tue, 20 Aug 2019 06:41:26 -0700 (PDT)
Received: from localhost (c-243c70d5.07-21-73746f28.bbcust.telenor.se. [213.112.60.36])
        by smtp.gmail.com with ESMTPSA id d21sm2861682lfc.73.2019.08.20.06.41.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 06:41:24 -0700 (PDT)
From:   Anders Roxell <anders.roxell@linaro.org>
To:     shuah@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com
Cc:     linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>
Subject: [PATCH] selftests: bpf: install files test_xdp_vlan.sh
Date:   Tue, 20 Aug 2019 15:41:21 +0200
Message-Id: <20190820134121.25728-1-anders.roxell@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When ./test_xdp_vlan_mode_generic.sh runs it complains that it can't
find file test_xdp_vlan.sh.

 # selftests: bpf: test_xdp_vlan_mode_generic.sh
 # ./test_xdp_vlan_mode_generic.sh: line 9: ./test_xdp_vlan.sh: No such
 file or directory

Rework so that test_xdp_vlan.sh gets installed, added to the variable
TEST_PROGS_EXTENDED.

Fixes: d35661fcf95d ("selftests/bpf: add wrapper scripts for test_xdp_vlan.sh")
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
---
 tools/testing/selftests/bpf/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 1faad0c3c3c9..d7968e20463c 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -68,7 +68,8 @@ TEST_PROGS := test_kmod.sh \
 TEST_PROGS_EXTENDED := with_addr.sh \
 	with_tunnels.sh \
 	tcp_client.py \
-	tcp_server.py
+	tcp_server.py \
+	test_xdp_vlan.sh
 
 # Compile but not part of 'make run_tests'
 TEST_GEN_PROGS_EXTENDED = test_libbpf_open test_sock_addr test_skb_cgroup_id_user \
-- 
2.20.1

