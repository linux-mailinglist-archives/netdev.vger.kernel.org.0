Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B891938989E
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 23:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbhESVe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 17:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbhESVe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 17:34:57 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B3F9C061760
        for <netdev@vger.kernel.org>; Wed, 19 May 2021 14:33:37 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id o11-20020a62f90b0000b02902db3045f898so6867562pfh.23
        for <netdev@vger.kernel.org>; Wed, 19 May 2021 14:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=cOO+IbBZ9Kvoj3lhh1iacoy/r2F7rXeqm3ad3wDL1+A=;
        b=QL5KNau84Zofl1F+WtBRi/h47IQG2BL/RYC3SXQIq8xmnlbfB/ewUwBlTapbQE7zHe
         Xcwtm20YrEqg6Jw+ks9JiYc/AvXhD6zw/Qb+yL2WI0sedjOTEidDHjZqi1/FjsIbDtuF
         laNuORopKhlB75G8MLsO4mBBh4tNZ7ImWLXA+Y5IxVsTQFJGdF/O8IuIKPGTnVXAIdrt
         NQr6lXNAkGvRL5uXT8Z+QYudZPPXLbG5c9Bwg6e6njIFG7sFyDTVPhaqaPSkQuG+YuEF
         JOTX2jersLEu18Zums9wfZDXuuKBieLTu1/JGIn0g9e/NVa1jaNWDZi1umQM0Jjv7AVn
         1VuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=cOO+IbBZ9Kvoj3lhh1iacoy/r2F7rXeqm3ad3wDL1+A=;
        b=PAP7p8w1ExG1O+f7HWzTfHyGRwxZF/weSyUM2710k+7raYTIJqoexUqni/rMXFpLf2
         IVShB5J3hyOQGTT5C1HmpGoNiNm7sGfBx6CjE1xkXo0RchUpsgcdQMGRsJh0oF1uI9vn
         ZmPxwXxt7fKv7AtL7SAbLnOG0GVW5uB+xS5x+RDTtb86W7piYeUdBbgXWj40D4qUnT13
         VVKkGm5MA8hhJo3pY8TIFA+PgZqXlHqs29ko4M7YJP/ECrXiR/lnFlEIFSbWGQYZlV8x
         gYE7V2YJnOcXY3ZUxk+nDMRzLZW46C2aN689yWydkLr65hJ3jWdVHufqQCxsbu1wEK8E
         UT0g==
X-Gm-Message-State: AOAM533M4f/6c2aRO8p64PA3K6gyiHZVVJPv9aobyBITpPfgYDzCXFPi
        QkBOfGuhqQTjh8NMkxiN93swyrc2H+215enr5WTwmbpZL+b6yDpBv24mm4WuZtaxkXPQC63pyE6
        b0pSc5jZUL3fw+7sy8/3Gv8HOUI2td7QkToXW7jijsuk7/9O5zP2wvJoCRKGONr/4OLo=
X-Google-Smtp-Source: ABdhPJwfEtI2Tb/Dbt51r4gCfKogUfwd+BTKpwkLXh2ttiFh3LhfopdSyM6m4UCPTJFHBUEee/JNnaiFwdUeNw==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a62:30c2:0:b029:289:116c:ec81 with SMTP
 id w185-20020a6230c20000b0290289116cec81mr1112723pfw.42.1621460016669; Wed,
 19 May 2021 14:33:36 -0700 (PDT)
Date:   Wed, 19 May 2021 21:33:33 +0000
Message-Id: <20210519213333.3947830-1-dmatlack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.751.gd2f1c929bd-goog
Subject: [PATCH] selftests: Add .gitignore for nci test suite
From:   David Matlack <dmatlack@google.com>
To:     netdev@vger.kernel.org, linux-nfc@lists.01.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Bongsu Jeon <bongsu.jeon@samsung.com>,
        Shuah Khan <shuah@kernel.org>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Building the nci test suite produces a binary, nci_dev, that git then
tries to track. Add a .gitignore file to tell git to ignore this binary.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/nci/.gitignore | 1 +
 1 file changed, 1 insertion(+)
 create mode 100644 tools/testing/selftests/nci/.gitignore

diff --git a/tools/testing/selftests/nci/.gitignore b/tools/testing/selftests/nci/.gitignore
new file mode 100644
index 000000000000..448eeb4590fc
--- /dev/null
+++ b/tools/testing/selftests/nci/.gitignore
@@ -0,0 +1 @@
+/nci_dev
-- 
2.31.1.751.gd2f1c929bd-goog

