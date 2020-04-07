Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D79A1A127B
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 19:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbgDGRNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 13:13:49 -0400
Received: from mail-qv1-f47.google.com ([209.85.219.47]:36437 "EHLO
        mail-qv1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbgDGRNs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 13:13:48 -0400
Received: by mail-qv1-f47.google.com with SMTP id z13so2213655qvw.3
        for <netdev@vger.kernel.org>; Tue, 07 Apr 2020 10:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=za9mZgZMFIIRg3GpMvsNl2kwUYzssn+fn7P0K8O4oYY=;
        b=AFpHJsNA/2WF5GDUPhm9q9UT3xZp1mbLKf6GDkvtdLScqROvu4LOBDTvb1et05YF7y
         2s8DXYgBb9XTwxo85rURlzjT9/In1xNXEj2koBE92DlW1wBy6NO+V075BL9+7yCcAKX+
         za21V1+s8DHlYUHJXgj8n4LEvqcMRYUNNyXDQwBFmIpg6JmRqymzg+q/kDk8pqCyoiM3
         WBaEgruJWj2zRIvy50uSYbMJ6DTsOYXZCzPNWtQ139CrMYFX6UzmQEsNbjHOAtSMlmEE
         ATpwrgPW+UCcKoI02arVusNwF8PkLTty5YNqvE4w+pywTn6cWczNO8I1gBJL3yYNOgb7
         HxQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=za9mZgZMFIIRg3GpMvsNl2kwUYzssn+fn7P0K8O4oYY=;
        b=LluZXmBJJEjHaIg6d+maaRCKDutIZuq3FiD7+p1gF1Oi1C7Qj6FqhOZGq34B2krkPm
         FsYXMowFAlrJdEBYjh1r4XuNuhfYOm32KeHTQnO61KCItCFZZZhnQF5p5F/5YsChItsf
         rZT4PjsSNxC6uBKxoiJHiojROpLbXs3xf8ot8UUh3R4bxjGaQ6ns+NSn/51fpgN4jrKr
         mh71EPZmfxvP3kwqGZBweakC2c0z6KuZtPoqAkzFcyb9CUc8GBaSPQIjihVXmRB2sKy4
         TGN7bIOjOjC3si7BckOwXtlXhAH5KoiJ2mZa4w+PKOKpR6UvzZXhc4a7xGcxvtnM+xDI
         IOlA==
X-Gm-Message-State: AGi0PubIDr3LuERfP1p89DryT9AFTDmDd3P4tczLkVDXqzw6nu2AeDeB
        iJk/wYdxNJmHIrjd+2dtaH66sw==
X-Google-Smtp-Source: APiQypL5v98splBWn64XF9b6rs7+8CXL0VOOmIa7E3k/ulontEPPpHTZqFUj9e+LU/f+0d6T9bG1zQ==
X-Received: by 2002:a05:6214:154c:: with SMTP id t12mr3376288qvw.218.1586279627457;
        Tue, 07 Apr 2020 10:13:47 -0700 (PDT)
Received: from mojatatu.com ([74.127.203.199])
        by smtp.gmail.com with ESMTPSA id v77sm13963962qkb.24.2020.04.07.10.13.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 07 Apr 2020 10:13:46 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, lucasb@mojatatu.com,
        Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH net 1/1] tc-testing: remove duplicate code in tdc.py
Date:   Tue,  7 Apr 2020 13:13:25 -0400
Message-Id: <1586279605-6689-1-git-send-email-mrv@mojatatu.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In set_operation_mode() function remove duplicated check for args.list
parameter, which is already done one line before.

Signed-off-by: Roman Mashak <mrv@mojatatu.com>
---
 tools/testing/selftests/tc-testing/tdc.py | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/tc-testing/tdc.py b/tools/testing/selftests/tc-testing/tdc.py
index e566c70e64a1..a3e43189d940 100755
--- a/tools/testing/selftests/tc-testing/tdc.py
+++ b/tools/testing/selftests/tc-testing/tdc.py
@@ -713,9 +713,8 @@ def set_operation_mode(pm, parser, args, remaining):
         exit(0)
 
     if args.list:
-        if args.list:
-            list_test_cases(alltests)
-            exit(0)
+        list_test_cases(alltests)
+        exit(0)
 
     if len(alltests):
         req_plugins = pm.get_required_plugins(alltests)
-- 
2.7.4

