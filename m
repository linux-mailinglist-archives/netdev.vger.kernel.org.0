Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44D431F6C5F
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 18:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgFKQtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 12:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726468AbgFKQts (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 12:49:48 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 902F6C08C5C1
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 09:49:47 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id v24so2531860plo.6
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 09:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/OantHyM9J2rt/HLD05eWdtDypkgDi3XkLdWdsHZQYc=;
        b=NfG8DHJU0NRmfrt9M40c0iLMdHR/Oy+5UON6bH0d/kCvmkjglNOzn7loXN0le9nSSo
         m+T/Df9wi7J3d5t72WilWv7NV9BlesC9KrXNK7qAUG+tEggvOefW9KgaV9EWDoDpjCW6
         CmLfD5axQPaQUZrFfrJdtq6bQCUTrJ6Rh8R+5yxrD+xR00dVgyIdmfug/Rh2wpLE/jj9
         awsAQy0hdN7xLtnShM81echONmHq9IYTUyA5COMKyRjLwi63vraUCmdOF5nvkjTSku5q
         MKp2V8tYfiGrPYXaiHqvmpSe/R3YT4iWjkSiQBGWGw1BoOpRgol3B6gU+6+RpQqEY2DI
         /Ddw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/OantHyM9J2rt/HLD05eWdtDypkgDi3XkLdWdsHZQYc=;
        b=g42Fg8B3/v/bEaL7B5c5jLumSR9voNI+u87dCgYL0AYtXnfZTPv7ZRy+mrtgALEdPb
         0FkmHCpkhqQuPmIkjc7tc49V0kT9iXbIFmTWFbmAepKUFYOL/RjmcjXwbqW71U+hqBbG
         Om/+dkxpCBMkv/HU9/H6aZFsLDmDL0U0czITyLVlxrB7W+xOb8VTm40N7MzNqIv3y4G/
         idw6ENka6JPhdnMu8dPyROiqdmENJiUbBnybEYdD47B7G0hpvWlxBJ1z9Knl70Lb+o7b
         cXMTSNpKD0ZIes/Owyv/EQ6B2KeWbQxUp9aKneNp7yWvZD14FdUSPnABLBQbfVDCFzyW
         GN3A==
X-Gm-Message-State: AOAM531EEPWAvt/um6wEYQ7uluQAy7qKR7pgtTL7CYf14WxA9zNRT2UR
        V/G9TFipNdCuMzDfU/EakRmIMe7AnZk=
X-Google-Smtp-Source: ABdhPJyd/HFZ3WEPpK7J4ga69kCNlX1LQReFWJ3FZEbGbwgmhKid3+ijFuvVPq6y5jXoJEaisZx5kA==
X-Received: by 2002:a17:90a:34cc:: with SMTP id m12mr8981326pjf.123.1591894186317;
        Thu, 11 Jun 2020 09:49:46 -0700 (PDT)
Received: from hermes.corp.microsoft.com (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id b3sm3578501pft.127.2020.06.11.09.49.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2020 09:49:44 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Dan Robertson <dan@dlrobertson.com>
Subject: [PATCH] devlink: update include files
Date:   Thu, 11 Jun 2020 09:49:36 -0700
Message-Id: <20200611164936.19501-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200608140404.1449-2-dan@dlrobertson.com>
References: <20200608140404.1449-2-dan@dlrobertson.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the tool iwyu to get more complete list of includes for
all the bits used by devlink.

This should also fix build with musl libc.

Fixes: c4dfddccef4e ("fix JSON output of mon command")
Reported-off-by: Dan Robertson <dan@dlrobertson.com>
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>

---
This is more complete version of suggested patch

 devlink/devlink.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 507972c360a7..ce2e46766617 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -19,18 +19,25 @@
 #include <limits.h>
 #include <errno.h>
 #include <inttypes.h>
+#include <signal.h>
+#include <time.h>
+#include <netinet/in.h>
+#include <arpa/inet.h>
 #include <sys/sysinfo.h>
 #define _LINUX_SYSINFO_H /* avoid collision with musl header */
 #include <linux/genetlink.h>
 #include <linux/devlink.h>
+#include <linux/netlink.h>
 #include <libmnl/libmnl.h>
 #include <netinet/ether.h>
+#include <sys/select.h>
+#include <sys/socket.h>
 #include <sys/types.h>
 
 #include "SNAPSHOT.h"
 #include "list.h"
 #include "mnlg.h"
-#include "json_writer.h"
+#include "json_print.h"
 #include "utils.h"
 #include "namespace.h"
 
-- 
2.26.2

