Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B81857CFCB
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 17:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232939AbiGUPjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 11:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232543AbiGUPi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 11:38:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E81C488F25
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 08:37:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658417851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+w7mjnwOlINJMKCuWIn64MJoJuBpfG6APw9NPBjcvFw=;
        b=KocWWMoiR8oByH4H4plT+xW5MTYcr8eHuM3JV4+GTQYy/WgrifbeekFGcALmxzN70JV9Bn
        j58wZylZ8u/P05yPasI5eVPJKAS073wvVXxmw+DprJCh53rqt+SWoK13hd3fqJfKouvK+6
        nRjDUJ/ElLZ7jiZmSnkNC/hDozJrG+M=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-215-vGkUN8vHOoeMb4-OVYfjpw-1; Thu, 21 Jul 2022 11:37:28 -0400
X-MC-Unique: vGkUN8vHOoeMb4-OVYfjpw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BFD213817A75;
        Thu, 21 Jul 2022 15:37:26 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.194.200])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9E1312166B26;
        Thu, 21 Jul 2022 15:37:23 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>
Cc:     Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH bpf-next v7 16/24] selftests/bpf/hid: add test to change the report size
Date:   Thu, 21 Jul 2022 17:36:17 +0200
Message-Id: <20220721153625.1282007-17-benjamin.tissoires@redhat.com>
In-Reply-To: <20220721153625.1282007-1-benjamin.tissoires@redhat.com>
References: <20220721153625.1282007-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use a different report with a bigger size and ensures we are doing
things properly.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

no changes in v7

no changes in v6

new in v5
---
 tools/testing/selftests/bpf/prog_tests/hid.c | 60 ++++++++++++++++++++
 tools/testing/selftests/bpf/progs/hid.c      | 15 ++++-
 2 files changed, 74 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/hid.c b/tools/testing/selftests/bpf/prog_tests/hid.c
index 719d220c8d86..47bc0a30c275 100644
--- a/tools/testing/selftests/bpf/prog_tests/hid.c
+++ b/tools/testing/selftests/bpf/prog_tests/hid.c
@@ -17,6 +17,17 @@ static unsigned char rdesc[] = {
 	0xa1, 0x01,		/* COLLECTION (Application) */
 	0x09, 0x01,			/* Usage (Vendor Usage 0x01) */
 	0xa1, 0x00,			/* COLLECTION (Physical) */
+	0x85, 0x02,				/* REPORT_ID (2) */
+	0x19, 0x01,				/* USAGE_MINIMUM (1) */
+	0x29, 0x08,				/* USAGE_MAXIMUM (3) */
+	0x15, 0x00,				/* LOGICAL_MINIMUM (0) */
+	0x25, 0xff,				/* LOGICAL_MAXIMUM (255) */
+	0x95, 0x08,				/* REPORT_COUNT (8) */
+	0x75, 0x08,				/* REPORT_SIZE (8) */
+	0x81, 0x02,				/* INPUT (Data,Var,Abs) */
+	0xc0,				/* END_COLLECTION */
+	0x09, 0x01,			/* Usage (Vendor Usage 0x01) */
+	0xa1, 0x00,			/* COLLECTION (Physical) */
 	0x85, 0x01,				/* REPORT_ID (1) */
 	0x06, 0x00, 0xff,			/* Usage Page (Vendor Defined Page 1) */
 	0x19, 0x01,				/* USAGE_MINIMUM (1) */
@@ -635,6 +646,53 @@ static int test_attach_detach(int uhid_fd, int dev_id)
 	return ret;
 }
 
+/*
+ * Attach hid_change_report_id to the given uhid device,
+ * retrieve and open the matching hidraw node,
+ * inject one event in the uhid device,
+ * check that the program sees it and can change the data
+ */
+static int test_hid_change_report(int uhid_fd, int dev_id)
+{
+	struct test_params params;
+	int err, hidraw_fd = -1;
+	u8 buf[10] = {0};
+	int ret = -1;
+
+	err = prep_test(dev_id, "hid_change_report_id", &params);
+	if (!ASSERT_EQ(err, 0, "prep_test(hid_change_report_id)"))
+		goto cleanup;
+
+	hidraw_fd = params.hidraw_fd;
+
+	/* inject one event */
+	buf[0] = 1;
+	buf[1] = 42;
+	send_event(uhid_fd, buf, 6);
+
+	/* read the data from hidraw */
+	memset(buf, 0, sizeof(buf));
+	err = read(hidraw_fd, buf, sizeof(buf));
+	if (!ASSERT_EQ(err, 9, "read_hidraw"))
+		goto cleanup;
+
+	if (!ASSERT_EQ(buf[0], 2, "hid_change_report_id"))
+		goto cleanup;
+
+	if (!ASSERT_EQ(buf[1], 42, "hid_change_report_id"))
+		goto cleanup;
+
+	if (!ASSERT_EQ(buf[2], 0, "leftovers_from_previous_test"))
+		goto cleanup;
+
+	ret = 0;
+
+cleanup:
+	cleanup_test(&params);
+
+	return ret;
+}
+
 void serial_test_hid_bpf(void)
 {
 	int err, uhid_fd;
@@ -660,6 +718,8 @@ void serial_test_hid_bpf(void)
 	ASSERT_OK(err, "hid");
 	err = test_attach_detach(uhid_fd, dev_id);
 	ASSERT_OK(err, "hid_attach_detach");
+	err = test_hid_change_report(uhid_fd, dev_id);
+	ASSERT_OK(err, "hid_change_report");
 
 	destroy(uhid_fd);
 
diff --git a/tools/testing/selftests/bpf/progs/hid.c b/tools/testing/selftests/bpf/progs/hid.c
index fc0a4241643a..ee7529c47ad8 100644
--- a/tools/testing/selftests/bpf/progs/hid.c
+++ b/tools/testing/selftests/bpf/progs/hid.c
@@ -32,7 +32,20 @@ int BPF_PROG(hid_first_event, struct hid_bpf_ctx *hid_ctx)
 
 	rw_data[2] = rw_data[1] + 5;
 
-	return 0;
+	return hid_ctx->size;
+}
+
+SEC("?fmod_ret/hid_bpf_device_event")
+int BPF_PROG(hid_change_report_id, struct hid_bpf_ctx *hid_ctx)
+{
+	__u8 *rw_data = hid_bpf_get_data(hid_ctx, 0 /* offset */, 3 /* size */);
+
+	if (!rw_data)
+		return 0; /* EPERM check */
+
+	rw_data[0] = 2;
+
+	return 9;
 }
 
 SEC("syscall")
-- 
2.36.1

