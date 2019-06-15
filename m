Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9E51471F1
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 21:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbfFOTlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 15:41:53 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:44556 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725270AbfFOTlw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 15:41:52 -0400
Received: by mail-io1-f66.google.com with SMTP id s7so13002080iob.11
        for <netdev@vger.kernel.org>; Sat, 15 Jun 2019 12:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=7aWNaMRNsbhgc2ToPhRz0aX4y9G2Qjxiym+FFncwxYk=;
        b=OMUSbtoL0J7eS1+CpxphalmA4XilFUfEU6xk7vKlIWN0Gd2US7b3Cq6/JJ+V0JHR/6
         hwuqIgZztsjiropLCKmcqcFKwJ08smmn4lA1SP4wdvpUV32+YMpdDlhFBt8ofrp9FbA8
         bdICAPg6gZ3o0ep3M+ZDdcxPVdFjcdpsZCZoYyec8uc5cEMzoqwFiK4zxm2UVuyTsRHh
         CAxKUcveseGL4FFAmMiZ1FPU+U7S0AecgFhrURICFlInSN4pdfwabg7+k8c4tLcV4eoN
         cBieUBBR0pfMKVIvdRGHafxKCBITZvB+I99O1CuQobQ56SeL2i+V6T7BEpA0TkyE7uoI
         wAEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=7aWNaMRNsbhgc2ToPhRz0aX4y9G2Qjxiym+FFncwxYk=;
        b=dVfWWhnVsJHlAJ8ef+VlM0ejlxXR/UYZdmuE2XKK3C3OFD2E//wuUc6INH3E5hzIiW
         6KjCLBnNd1f79VtLHcTcwDnT80aeMg8LmKNXj/6ieHfGq9CIbxacc2oVchI3nn7390fk
         LpKI7LgZkfovIt/OVZW6Vw+9Q2yH/U+hanzpJGDnb6GnXvIAdbhSSPY5bwDMY2R9fIXQ
         luXP9JCYhRsb57GVc2c2KLkC4LQoDWrEiWpT0qGxeA+/OMEWs2vL21Ejt34pTp39y4Vn
         TUtxA0OsEsNCCFvOR5CXaF8ANNJbsEnAvNaOLEdNJh2A1YXg+4NhHVz+E+o1Q8AmloD7
         7ywg==
X-Gm-Message-State: APjAAAWs6w7uvBk7VQFvj7+RwsiE8fiPqpIoPYzwfTZ6kEVHxhfh0dMK
        OI00N9NYobpSgYKa8bDv1b4RfQ==
X-Google-Smtp-Source: APXvYqzYl8KF4lxQnwpFVFLYAvRj+I6SHfSrvSPEF0GicItIN5RnDUz9csosjYkOGjOewucKXfIAtA==
X-Received: by 2002:a5d:9282:: with SMTP id s2mr22609819iom.36.1560627711892;
        Sat, 15 Jun 2019 12:41:51 -0700 (PDT)
Received: from mojatatu.com ([64.26.149.125])
        by smtp.gmail.com with ESMTPSA id p10sm4640332iob.54.2019.06.15.12.41.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 15 Jun 2019 12:41:51 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH net-next 1/1] tc-tests: added path to ip command in tdc
Date:   Sat, 15 Jun 2019 15:41:43 -0400
Message-Id: <1560627703-1844-1-git-send-email-mrv@mojatatu.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This macro $IP will be used in upcoming tc tests, which require
to create interfaces etc.

Signed-off-by: Roman Mashak <mrv@mojatatu.com>
---
 tools/testing/selftests/tc-testing/tdc_config.py | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/tdc_config.py b/tools/testing/selftests/tc-testing/tdc_config.py
index 942c70c041be..b771d4c89621 100644
--- a/tools/testing/selftests/tc-testing/tdc_config.py
+++ b/tools/testing/selftests/tc-testing/tdc_config.py
@@ -10,6 +10,8 @@ Copyright (C) 2017 Lucas Bates <lucasb@mojatatu.com>
 NAMES = {
           # Substitute your own tc path here
           'TC': '/sbin/tc',
+          # Substitute your own ip path here
+          'IP': '/sbin/ip',
           # Name of veth devices to be created for the namespace
           'DEV0': 'v0p0',
           'DEV1': 'v0p1',
-- 
2.7.4

