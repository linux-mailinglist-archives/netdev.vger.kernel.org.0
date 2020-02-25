Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE12216F0AD
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 21:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729483AbgBYUyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 15:54:45 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34419 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728714AbgBYUyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 15:54:45 -0500
Received: by mail-wr1-f65.google.com with SMTP id z15so357731wrl.1
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 12:54:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=28TDunclJ0ED67dbx8CkZqbh/7wdN9qJRWSOtwdsi1s=;
        b=UoHTD/6+hk2QYtP059qZLw3RRZ16mc3CjCh2ZZwsu0a7xHxNMua3zoubg3FnJlMpfT
         h9ft7NT72oICgPc9WavKnXNoQg4dLsDOs92lfQDDJOEaG24d44X339XfYqFwcRKl1+hz
         FaPA+pFgOHmZtoFQij9N6yoY6Gloe1pEwStUk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=28TDunclJ0ED67dbx8CkZqbh/7wdN9qJRWSOtwdsi1s=;
        b=Nrkd2gxHtol+rmFRMWW3SLEVdBB9WhYizsgkQiyl20aw4zG3VhuPhQSOv5mfeu/U21
         anuwSDdBLuQgbMMrcs/OU33g79ycnHZNdfv7M81iS9gHQ9acJvC4ViY1d1JlkMf9sDjU
         UCzk4xNTyDstE+UmHYql2MfTCKq4Hk4CECFMrQevJMaKfV9tpvdqttlgsCMHuVLSw7na
         dbJ8kcEqMI8yPVJqneAhuKkTuwqE8t55n8Dclt5pRXuWL2MGwrvSrRE/ElnjKBb5/BkZ
         EercpuzaRDQyYvtGdNfrcQmPwsd8ikCCEUtlIKuv0a0rJCYNRV9NCcThfM1VjMvy00C1
         QnKA==
X-Gm-Message-State: APjAAAXLxxN1IYXIhEYL4ANwa8+gsAasZzkesbT08IRhDQ/gHpXqHwBL
        MdY/sAunZ02XOMkuc1AIY8Z/EQ==
X-Google-Smtp-Source: APXvYqxs5Dht7wCnHgNaDyHKMXo95ql8ZEwhG4lxizSll22ZJBzPc0J3TZ9jyuOGIAHL1lrfaQwGNg==
X-Received: by 2002:adf:de0b:: with SMTP id b11mr932096wrm.89.1582664082855;
        Tue, 25 Feb 2020 12:54:42 -0800 (PST)
Received: from lbrmn-lnxub113.broadcom.net ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id t13sm104852wrw.19.2020.02.25.12.54.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 12:54:42 -0800 (PST)
From:   Scott Branden <scott.branden@broadcom.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        Scott Branden <scott.branden@broadcom.com>
Subject: [PATCH] scripts/bpf: switch to more portable python3 shebang
Date:   Tue, 25 Feb 2020 12:54:26 -0800
Message-Id: <20200225205426.6975-1-scott.branden@broadcom.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change "/usr/bin/python3" to "/usr/bin/env python3" for
more portable solution in bpf_helpers_doc.py.

Signed-off-by: Scott Branden <scott.branden@broadcom.com>
---
 scripts/bpf_helpers_doc.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/bpf_helpers_doc.py b/scripts/bpf_helpers_doc.py
index 90baf7d70911..cebed6fb5bbb 100755
--- a/scripts/bpf_helpers_doc.py
+++ b/scripts/bpf_helpers_doc.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python3
+#!/usr/bin/env python3
 # SPDX-License-Identifier: GPL-2.0-only
 #
 # Copyright (C) 2018-2019 Netronome Systems, Inc.
-- 
2.17.1

