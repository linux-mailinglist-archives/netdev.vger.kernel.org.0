Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFBEB8D74A
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 17:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbfHNPhl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 11:37:41 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38603 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfHNPhk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 11:37:40 -0400
Received: by mail-wr1-f67.google.com with SMTP id g17so111530470wrr.5
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 08:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wtE20u3smDLyIolTCA3NjZ3CY2S/HZyL9HspiOTh8OM=;
        b=Cyl0d/D4Kgtblm4KExbJ7HSyZ0clfpYS4GTlNz/j7tJ0xkz4aSugpfP22hZ1paxX5j
         KDLxGPUcIGvqVKljKPH06XDUVuu6JErbBIeXJnaY7UUPd7E1hmv6KCgoSarRXzUmLwOP
         /18ARmKVG01iqC1jArKQKrA7pgwtcRTNY58EFng55D+QuOK1Aw2p2MmxcCeehB3qyLkM
         0K528f3AsjBP1yErrH1ssRApZM367p9cXz+GCMwkUN/zzvEVzsbHJz/M5JflJm06ACat
         thOvok0+dGLKVI0Q2kUZjWEQXtk8d0kiiOpNZDyW4hpsgE4WlhRF7oVzDhdw9l5eSloj
         w09Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wtE20u3smDLyIolTCA3NjZ3CY2S/HZyL9HspiOTh8OM=;
        b=CfQIQXLtQtreJPpsvoNpxOM3YZbx8QKefsXaDKQcvweCknQqw4YH5GGVUPdWeUe8V1
         U0eQUGx2AytiBpfaYSS4/vMDsjrM/2XlRzR73aHZrwmM/Sl8XQ+NphnUydMie+2Aw4Tu
         ZhVV3UgMGoc8gWilz2pzClGhJ7vxqtFdbej5GXfY5YBZcmedkjekxpd+jeIa8DZnZHLK
         sy5nqy3oocEw20/7a1EE4z9LYA+nR9lTd6zYLhTw7OJRUsdSqooBsecBZlgk2EEtrgdS
         WPQGjbPmgMhPTrGwi04pzEGxYOmRw/FbnOsclW9J+FkoiY1jdJf0L4fjxDWH671ZEB2J
         tXMg==
X-Gm-Message-State: APjAAAXBlF9FxE6195/zaBS6fAYtzUaG8D3mrwypWCrFz+l3rESI/sP0
        tz5FlKjdgTfCW02aq77f94ku1bCrhTY=
X-Google-Smtp-Source: APXvYqw7QLc9VAU2xlA4VSkTH8jtXPYTpnA/cv9E6L5cLgWtydES6E6yfP4VCCIibNULpyJHMAou0g==
X-Received: by 2002:adf:9482:: with SMTP id 2mr305933wrr.91.1565797058075;
        Wed, 14 Aug 2019 08:37:38 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id t24sm25048wmj.14.2019.08.14.08.37.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 14 Aug 2019 08:37:37 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        mlxsw@mellanox.com
Subject: [patch net-next v3 2/2] selftests: netdevsim: add devlink regions tests
Date:   Wed, 14 Aug 2019 17:37:35 +0200
Message-Id: <20190814153735.6923-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190814153735.6923-1-jiri@resnulli.us>
References: <20190814153735.6923-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Test netdevsim devlink region implementation.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v1->v2:
- new patch
---
 .../drivers/net/netdevsim/devlink.sh          | 54 ++++++++++++++++++-
 1 file changed, 53 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
index 6828e9404460..115837355eaf 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
@@ -3,7 +3,7 @@
 
 lib_dir=$(dirname $0)/../../../net/forwarding
 
-ALL_TESTS="fw_flash_test params_test"
+ALL_TESTS="fw_flash_test params_test regions_test"
 NUM_NETIFS=0
 source $lib_dir/lib.sh
 
@@ -90,6 +90,58 @@ params_test()
 	log_test "params test"
 }
 
+check_region_size()
+{
+	local name=$1
+	local size
+
+	size=$(devlink region show $DL_HANDLE/$name -j | jq -e -r '.[][].size')
+	check_err $? "Failed to get $name region size"
+	[ $size -eq 32768 ]
+	check_err $? "Invalid $name region size"
+}
+
+check_region_snapshot_count()
+{
+	local name=$1
+	local phase_name=$2
+	local expected_count=$3
+	local count
+
+	count=$(devlink region show $DL_HANDLE/$name -j | jq -e -r '.[][].snapshot | length')
+	[ $count -eq $expected_count ]
+	check_err $? "Unexpected $phase_name snapshot count"
+}
+
+regions_test()
+{
+	RET=0
+
+	local count
+
+	check_region_size dummy
+	check_region_snapshot_count dummy initial 0
+
+	echo ""> $DEBUGFS_DIR/take_snapshot
+	check_err $? "Failed to take first dummy region snapshot"
+	check_region_snapshot_count dummy post-first-snapshot 1
+
+	echo ""> $DEBUGFS_DIR/take_snapshot
+	check_err $? "Failed to take second dummy region snapshot"
+	check_region_snapshot_count dummy post-second-snapshot 2
+
+	echo ""> $DEBUGFS_DIR/take_snapshot
+	check_err $? "Failed to take third dummy region snapshot"
+	check_region_snapshot_count dummy post-third-snapshot 3
+
+	devlink region del $DL_HANDLE/dummy snapshot 1
+	check_err $? "Failed to delete first dummy region snapshot"
+
+	check_region_snapshot_count dummy post-first-delete 2
+
+	log_test "regions test"
+}
+
 setup_prepare()
 {
 	modprobe netdevsim
-- 
2.21.0

