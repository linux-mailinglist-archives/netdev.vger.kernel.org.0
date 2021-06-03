Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3540399952
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 06:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbhFCEvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 00:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbhFCEvw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 00:51:52 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83FEEC06175F;
        Wed,  2 Jun 2021 21:50:08 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id i9so6804205lfe.13;
        Wed, 02 Jun 2021 21:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x4E5XTU7wD0xWqzH6jn3ez00Wy8uYqD5Mj232oqDNsc=;
        b=eSLOFmSpN0Bfsyg7YN/0klrX/bMhgfpC0raOfDEdildqldck+gVj30/hLvyhUWaaLA
         OWqACChSQVNqKOb7qefVQmXZmg6C+f6/6zrdcUT427v05KeLUqo9Bx1JSHd6OQcrHIk/
         DGMQahAUvbivHH1CQ/gtmrU5K1QbWSCk8TVkJ7tjkkJFx91uSjhClB8lWyBpq7Eno6WC
         /ktbYcBZzZgobvyGUQN18u9om1hlAmL9lGIQORIEJGWtbvkC2Y9oeXqpKGgNTT1g3OGR
         o7kCTHYyV9Z6RArcDfjoIlR6YSCcOauDa6KnlTCmdVk23htJn6pXyfwVYokToQZKruHN
         O2rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x4E5XTU7wD0xWqzH6jn3ez00Wy8uYqD5Mj232oqDNsc=;
        b=jLq0FjfiRL4eFp6fl5USSUdI2+VbigorO6xPbSi3U8qYO05igEUsO7s+v1BKwITTMz
         KS6DmtJ7hkl79N/5q1ZFWODc/2A8ItjVtg8hAEOq9xhSoZOJYKTjC2R3sjsGDetnQCGG
         UEWr2hZRPlOJ5F1NboBiZidovy1SRw13FniIG8lNnVFBJDMKhkfK9UyBQURvEDtCsCU8
         e9ZLkkP8w5pJzQDHF6baFMt8lZuNtpwIkkgxv7ILsuv2y14y/NQKy4fMED3xKWjhyckl
         6pY3o7+2rjT4QAI0W15iF8LReJ2LDId0wi+2x8Yd4Ncz0ockd2qn6NXZYZfzfSsttkBe
         NFEw==
X-Gm-Message-State: AOAM533ZO5RYcm0X7iBjbT45lpK0MKk/z/Lh71KrRIcdHvgok0W2L1Ka
        zobq91zRC9Ff4aTBOABMeZWoGeomFE4=
X-Google-Smtp-Source: ABdhPJw/S5Yo2Yo1LzYzIVt579lrIsi7FuNnPKhzsIni/2IlkV+ANwej29J/SFFYAkF750OJ8UvxHQ==
X-Received: by 2002:ac2:560f:: with SMTP id v15mr14866462lfd.431.1622695806931;
        Wed, 02 Jun 2021 21:50:06 -0700 (PDT)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id z2sm191328lfe.229.2021.06.02.21.50.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 21:50:06 -0700 (PDT)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>
Cc:     M Chetan Kumar <m.chetan.kumar@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [RFC 4/6 iproute2] Update kernel headers
Date:   Thu,  3 Jun 2021 07:49:52 +0300
Message-Id: <20210603044954.8091-5-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210603044954.8091-1-ryazanov.s.a@gmail.com>
References: <20210603044954.8091-1-ryazanov.s.a@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A partial headers update that brings WWAN-related attributes. Included
in the series mainly to make it possible to quickly compile and test the
utility.

Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
---
 include/uapi/linux/if_link.h |  6 ++++++
 include/uapi/linux/wwan.h    | 16 ++++++++++++++++
 2 files changed, 22 insertions(+)
 create mode 100644 include/uapi/linux/wwan.h

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 50193377..1cf48416 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -341,6 +341,12 @@ enum {
 	IFLA_ALT_IFNAME, /* Alternative ifname */
 	IFLA_PERM_ADDRESS,
 	IFLA_PROTO_DOWN_REASON,
+
+	/* device (sysfs) name as parent, used instead
+	 * of IFLA_LINK where there's no parent netdev
+	 */
+	IFLA_PARENT_DEV_NAME,
+
 	__IFLA_MAX
 };
 
diff --git a/include/uapi/linux/wwan.h b/include/uapi/linux/wwan.h
new file mode 100644
index 00000000..32a2720b
--- /dev/null
+++ b/include/uapi/linux/wwan.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0-only WITH Linux-syscall-note */
+/*
+ * Copyright (C) 2021 Intel Corporation.
+ */
+#ifndef _UAPI_WWAN_H_
+#define _UAPI_WWAN_H_
+
+enum {
+	IFLA_WWAN_UNSPEC,
+	IFLA_WWAN_LINK_ID, /* u32 */
+
+	__IFLA_WWAN_MAX
+};
+#define IFLA_WWAN_MAX (__IFLA_WWAN_MAX - 1)
+
+#endif /* _UAPI_WWAN_H_ */
-- 
2.26.3

