Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2966637CD1
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 16:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbiKXPUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 10:20:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbiKXPTx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 10:19:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4347116FB08
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 07:16:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669302995;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EX0J0sgPn3/VZ/zS9HOQelAJB+dUZIbAy2+CqEVbXFE=;
        b=GzREFHSg4+JUYOVAqypnJ24KOCm44GSuva/NJ7uomTuWgtwGKR/N5u3RScAaMO7tEKOGaB
        uCvN412MK4jjZZoUaHph9G3LedPV+y+Rer+AlTGJRmSitPm6GHsiHCxzi3gU03y4wSIfkx
        DxmI8Pp7hX+H63klwXnn2Z1x07Dh6V0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-518-6XjPAMALPxCvtgClpPRx1Q-1; Thu, 24 Nov 2022 10:16:30 -0500
X-MC-Unique: 6XjPAMALPxCvtgClpPRx1Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B6B801C05B0E;
        Thu, 24 Nov 2022 15:16:29 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.193.200])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 01A3B40C2064;
        Thu, 24 Nov 2022 15:16:27 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [RFC hid v1 10/10] wip: vmtest aarch64
Date:   Thu, 24 Nov 2022 16:16:03 +0100
Message-Id: <20221124151603.807536-11-benjamin.tissoires@redhat.com>
In-Reply-To: <20221124151603.807536-1-benjamin.tissoires@redhat.com>
References: <20221124151603.807536-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

untested

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 tools/testing/selftests/hid/config.aarch64 | 39 ++++++++++++++++++++++
 tools/testing/selftests/hid/vmtest.sh      |  6 +++-
 2 files changed, 44 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/hid/config.aarch64

diff --git a/tools/testing/selftests/hid/config.aarch64 b/tools/testing/selftests/hid/config.aarch64
new file mode 100644
index 000000000000..76581bc6395b
--- /dev/null
+++ b/tools/testing/selftests/hid/config.aarch64
@@ -0,0 +1,39 @@
+# EFI
+CONFIG_EFI_PARAMS_FROM_FDT=y
+CONFIG_EFI_GENERIC_STUB=y
+CONFIG_EFI_ARMSTUB_DTB_LOADER=y
+
+# Disable unsupported AARCH64 platforms
+CONFIG_ARCH_ACTIONS=n
+CONFIG_ARCH_SUNXI=n
+CONFIG_ARCH_ALPINE=n
+CONFIG_ARCH_APPLE=n
+CONFIG_ARCH_BERLIN=n
+CONFIG_ARCH_EXYNOS=n
+CONFIG_ARCH_K3=n
+CONFIG_ARCH_LAYERSCAPE=n
+CONFIG_ARCH_LG1K=n
+CONFIG_ARCH_HISI=n
+CONFIG_ARCH_KEEMBAY=n
+CONFIG_ARCH_MEDIATEK=n
+CONFIG_ARCH_MESON=n
+CONFIG_ARCH_MVEBU=n
+CONFIG_ARCH_MXC=n
+CONFIG_ARCH_QCOM=n
+CONFIG_ARCH_RENESAS=n
+CONFIG_ARCH_S32=n
+CONFIG_ARCH_SEATTLE=n
+CONFIG_ARCH_INTEL_SOCFPGA=n
+CONFIG_ARCH_SYNQUACER=n
+CONFIG_ARCH_TEGRA=n
+CONFIG_ARCH_TESLA_FSD=n
+CONFIG_ARCH_SPRD=n
+CONFIG_ARCH_THUNDER=n
+CONFIG_ARCH_THUNDER2=n
+CONFIG_ARCH_UNIPHIER=n
+CONFIG_ARCH_VEXPRESS=n
+CONFIG_ARCH_VISCONTI=n
+CONFIG_ARCH_XGENE=n
+CONFIG_ARCH_ZYNQMP=n
+
+CONFIG_NET_VENDOR_MELLANOX=n
diff --git a/tools/testing/selftests/hid/vmtest.sh b/tools/testing/selftests/hid/vmtest.sh
index bd60f65acb72..d9e4a4c0557a 100755
--- a/tools/testing/selftests/hid/vmtest.sh
+++ b/tools/testing/selftests/hid/vmtest.sh
@@ -4,9 +4,13 @@
 set -u
 set -e
 
-# This script currently only works for x86_64
+# This script currently only works for x86_64 and aarch64.
 ARCH="$(uname -m)"
 case "${ARCH}" in
+aarch64)
+	QEMU_BINARY=qemu-system-aarch64
+	BZIMAGE="arch/aarch64/boot/bzImage"
+	;;
 x86_64)
 	QEMU_BINARY=qemu-system-x86_64
 	BZIMAGE="arch/x86/boot/bzImage"
-- 
2.38.1

