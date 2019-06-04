Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62B7C33D3C
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 04:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbfFDCf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 22:35:27 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42819 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbfFDCf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 22:35:27 -0400
Received: by mail-pg1-f194.google.com with SMTP id e6so8143892pgd.9
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 19:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tGa9RS01vGpHQOleOaUe4nJ7FM2xlQiHP6+7RJgSjXE=;
        b=qyOw18AVAcOLjs7Z1nFSf/wGwpho+U1Yf6Yd8CCXMWCeVxUye8YPrXnxnoheG6zrvw
         9peKAkZnQ8MkQC1qOKZtnWk9ofiYmyfVSVIP2wlVr3N0S/BjiWYUN44/K1JwxzHGZa2u
         3KcxtBxPeTGcKAC0FkhM8X2eJLCm/6XENK+lYVTUs259omTngf4S3YTqP9mZARLy5aj9
         KPshv5vDquPc93duQlGVAPf8BGyp0PIcwh170Dn6gaNICLPeru13IQDDohnNP6dNWWJf
         NbCeMqDy/ahTMoijRSEXsk46dcQ2xQ9F/r+8QKS95o+vwVhNFayqREZ2DkCW+UKHAhHi
         91eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tGa9RS01vGpHQOleOaUe4nJ7FM2xlQiHP6+7RJgSjXE=;
        b=FIif1W82DDwuVuavKOeM0k61i9p8X7OskRSVPdznxcajOYjB090OQIecJT6pbuwLeF
         iBm7vNVQtnEHt3rYHNDNGNLDevP7wGLO4htCmnhRIW+7rqxtt6VsuyXSQDsszEM4zDwe
         wrBDraiBvtYXinQx+zLVRiqNlInYP1QT0iGP0idlHUiVcJZ4QiiTvtHDbpieElQHKo3s
         IOjgJ7udupTNXe7TCo0Q/fKqA+tgB26eFWahA18cpBqT3mz9qQv4OCrJTW6k9O3OjnDW
         ByYLiO3fHvEzu7WxilzQN0c8ZxrJbt4SP6yt6awy1PpDbZdxFmNPFgwXFD6AopSjgxIU
         rKyg==
X-Gm-Message-State: APjAAAXsOPKmiEvRQA5CkZNFxReCwwbOMhfA45DaM29Anurd4b/slnDg
        hzJUT2b0OP5+j+38HOnd+LPjCavFz7YiVg==
X-Google-Smtp-Source: APXvYqzjNT0GDJtobQSntl5xwo6n54WIG5JXTTfV53nutMoK929HJ9N8VLkDt95uA8IqZ/Uv7ljT+Q==
X-Received: by 2002:a17:90a:bf02:: with SMTP id c2mr7263360pjs.73.1559615726635;
        Mon, 03 Jun 2019 19:35:26 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v5sm14688030pfm.22.2019.06.03.19.35.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Jun 2019 19:35:25 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Sean Young <sean@mess.org>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH bpf] selftests/bpf: move test_lirc_mode2_user to TEST_GEN_PROGS_EXTENDED
Date:   Tue,  4 Jun 2019 10:35:05 +0800
Message-Id: <20190604023505.27390-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

test_lirc_mode2_user is included in test_lirc_mode2.sh test and should
not be run directly.

Fixes: 6bdd533cee9a ("bpf: add selftest for lirc_mode2 type program")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/bpf/Makefile | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 66f2dca1dee1..e36356e2377e 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -21,8 +21,8 @@ LDLIBS += -lcap -lelf -lrt -lpthread
 # Order correspond to 'make run_tests' order
 TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test_progs \
 	test_align test_verifier_log test_dev_cgroup test_tcpbpf_user \
-	test_sock test_btf test_sockmap test_lirc_mode2_user get_cgroup_id_user \
-	test_socket_cookie test_cgroup_storage test_select_reuseport test_section_names \
+	test_sock test_btf test_sockmap get_cgroup_id_user test_socket_cookie \
+	test_cgroup_storage test_select_reuseport test_section_names \
 	test_netcnt test_tcpnotify_user test_sock_fields test_sysctl
 
 BPF_OBJ_FILES = $(patsubst %.c,%.o, $(notdir $(wildcard progs/*.c)))
@@ -63,7 +63,8 @@ TEST_PROGS_EXTENDED := with_addr.sh \
 
 # Compile but not part of 'make run_tests'
 TEST_GEN_PROGS_EXTENDED = test_libbpf_open test_sock_addr test_skb_cgroup_id_user \
-	flow_dissector_load test_flow_dissector test_tcp_check_syncookie_user
+	flow_dissector_load test_flow_dissector test_tcp_check_syncookie_user \
+	test_lirc_mode2_user
 
 include ../lib.mk
 
-- 
2.19.2

