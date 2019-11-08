Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA1BAF4E10
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 15:26:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbfKHO0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 09:26:37 -0500
Received: from mail-wm1-f49.google.com ([209.85.128.49]:39580 "EHLO
        mail-wm1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbfKHO0g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 09:26:36 -0500
Received: by mail-wm1-f49.google.com with SMTP id t26so6415114wmi.4
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 06:26:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+LWzjGDKIOnvaLVNQkz8X9nDLppZeuOSRc3lHHiDVPY=;
        b=jkJl6ZV3rRBUcgGU5EF+J2JOnC91LeeZs9dJwOPWtXvLef/OqjZPPO2O9gGcGWFUsY
         XjGPJjn6EhyRe7UOrXCmFGnD1EDC9+RTS+7vEz/w/Gn/DpMLJ34vLli6y1semWQV3K2W
         lx/vFk+S1KIE6BAVywkMAobgfeZYy7K/q+A2RhIYjG0Mw//NxmW6SXwhVH0ERFewrX6q
         hSXHP7f/o18gi8vuJJ3UbtAvseXvw2LTx7obDsUjKM9AHxZpQsNyyjBICY3Z+MMqCets
         cFdzuX1xvMgodmyL+trHqxHAQeqXd3P8tefUY8yv2gpgJWm5NHAvs0S1Hd0Np2hCDLxp
         t5mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+LWzjGDKIOnvaLVNQkz8X9nDLppZeuOSRc3lHHiDVPY=;
        b=qO2KFIvPbxr62CnH9daHiw8oXJcwwMmjAUPQsQmyMJVb4C3+nk1iCfIWMgOI9XyhU2
         Zmq0Y4t4tXAvt8+fy5yKEipDyZbWpkwKk2pk8PSQ7jzxDm0YJ1C/3TjjVkThPvGLKgwC
         znPgy9GkeQ4Q6gOH3ibPHA3FbSOf+M3dznz9kImyJccPz0S+sah/iJ0xldgkFZBQARAR
         90+JpldfHhnpe8w0tFOEJqtvNsnyBQJZAK29Ta0mh3an5XrXnMTPDLo2lujEGePDwmq2
         RDwOkT3VgFx+oltUNccdFyFkZ2pJ13aS5tSFz02wq/JC2XI/LQ9p73eFDywNCGUjt9Pi
         0pAg==
X-Gm-Message-State: APjAAAW9LI17P5mgoxUAKNmVjDUQLzxFL++hwUpah+CaYiHqXkWDuMlu
        X9/iuj/gmRJGVo0sw2rRSVkIe2ZduNs=
X-Google-Smtp-Source: APXvYqxQTkdMldOdzTpI7xHN1qCZGiQAcPIraoxJcJkSy1msdF6rj+spy9mWtWWrsbXGvYWWqkvn7Q==
X-Received: by 2002:a7b:c748:: with SMTP id w8mr8982020wmk.114.1573223193885;
        Fri, 08 Nov 2019 06:26:33 -0800 (PST)
Received: from localhost (ip-94-113-220-175.net.upcbroadband.cz. [94.113.220.175])
        by smtp.gmail.com with ESMTPSA id f188sm5045281wmf.3.2019.11.08.06.26.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 06:26:33 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, mlxsw@mellanox.com
Subject: [patch net-next] selftest: net: add alternative names test
Date:   Fri,  8 Nov 2019 15:26:33 +0100
Message-Id: <20191108142633.18041-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Add a simple test for recently added netdevice alternative names.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 tools/testing/selftests/net/altnames.sh | 75 +++++++++++++++++++++++++
 1 file changed, 75 insertions(+)
 create mode 100755 tools/testing/selftests/net/altnames.sh

diff --git a/tools/testing/selftests/net/altnames.sh b/tools/testing/selftests/net/altnames.sh
new file mode 100755
index 000000000000..4254ddc3f70b
--- /dev/null
+++ b/tools/testing/selftests/net/altnames.sh
@@ -0,0 +1,75 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+lib_dir=$(dirname $0)/forwarding
+
+ALL_TESTS="altnames_test"
+NUM_NETIFS=0
+source $lib_dir/lib.sh
+
+DUMMY_DEV=dummytest
+SHORT_NAME=shortname
+LONG_NAME=someveryveryveryveryveryverylongname
+
+altnames_test()
+{
+	RET=0
+	local output
+	local name
+
+	ip link property add $DUMMY_DEV altname $SHORT_NAME
+	check_err $? "Failed to add short alternative name"
+
+	output=$(ip -j -p link show $SHORT_NAME)
+	check_err $? "Failed to do link show with short alternative name"
+
+	name=$(echo $output | jq -e -r ".[0].altnames[0]")
+	check_err $? "Failed to get short alternative name from link show JSON"
+
+	[ "$name" == "$SHORT_NAME" ]
+	check_err $? "Got unexpected short alternative name from link show JSON"
+
+	ip -j -p link show $DUMMY_DEV &>/dev/null
+	check_err $? "Failed to do link show with original name"
+
+	ip link property add $DUMMY_DEV altname $LONG_NAME
+	check_err $? "Failed to add long alternative name"
+
+	output=$(ip -j -p link show $LONG_NAME)
+	check_err $? "Failed to do link show with long alternative name"
+
+	name=$(echo $output | jq -e -r ".[0].altnames[1]")
+	check_err $? "Failed to get long alternative name from link show JSON"
+
+	[ "$name" == "$LONG_NAME" ]
+	check_err $? "Got unexpected long alternative name from link show JSON"
+
+	ip link property del $DUMMY_DEV altname $SHORT_NAME
+	check_err $? "Failed to add short alternative name"
+
+	ip -j -p link show $SHORT_NAME &>/dev/null
+	check_fail $? "Unexpected success while trying to do link show with deleted short alternative name"
+
+	# long name is left there on purpose to be removed alongside the device
+
+	log_test "altnames test"
+}
+
+setup_prepare()
+{
+	ip link add name $DUMMY_DEV type dummy
+}
+
+cleanup()
+{
+	pre_cleanup
+	ip link del name $DUMMY_DEV
+}
+
+trap cleanup EXIT
+
+setup_prepare
+
+tests_run
+
+exit $EXIT_STATUS
-- 
2.21.0

