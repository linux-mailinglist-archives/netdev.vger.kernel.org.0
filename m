Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 788188ED3A
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 15:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732481AbfHONql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 09:46:41 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:56159 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732411AbfHONqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 09:46:39 -0400
Received: by mail-wm1-f66.google.com with SMTP id f72so1330272wmf.5
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 06:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wtE20u3smDLyIolTCA3NjZ3CY2S/HZyL9HspiOTh8OM=;
        b=P3mdbapBuyfjiw7MxDbfK3qjqyfG3sIDvES/44JroYmaq3c9bDBk8G3mldgDOrEL3H
         vy7D93nrb1vZIoq80A4XPXvCS82RES2cQnhcmZoNSzF3T2mY8oD53gMroCBo1ZAqpWvr
         p9JVgX4usGqm2UpZACi+82JOvCDbSSbTxtkalrCRS3c3ULueW3K6owZOtOz5BpqDmzXT
         C4MY1TXqLvbGC/cRSqlAiyb/dDe2t4rh55b2GIKcBGlWqPlhYeI2t/VQ679ixbk+S7zp
         RK4ItWDNZ2GpTKYSsD2PcvFQSKllZB6qMvLkdDfkzvwQB645SHSFohsOmSpkNEy3HGAh
         sJ3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wtE20u3smDLyIolTCA3NjZ3CY2S/HZyL9HspiOTh8OM=;
        b=azvSAJ0dRsDkIyiWfyhc8rbBsvakLxE5c1JfxaVOFCeTE1Ko932lLHokL5+ge8+etn
         viVjjJ6RqCgaH2jiPnacztDBQgvM3IUDtZI3Fjgi1OB3rbjYEJjnVTnSnsWDyE9TZG2C
         NeuEHzfgJ3zThHKugzMV3P1Opipgn1muIgLy1HJzZTk1mkYiFgIlIEiI3oZ7Bb8RL/Qm
         D/T7OiEdYEwrtV+vKiX++GPD3UMWTXT+Iu3BmvaG5nMYoSfhn7c0VAUwhmjWwdxr7U/b
         yt+YyWbBOtbDrnVRwHZ7YbJ5hZHPkJJ7o6s8ci//1X1HASOxzmQQxONDdj6VymYuO87A
         sUmw==
X-Gm-Message-State: APjAAAXnLyJSDjPxg/VRGqJuqL3Uz0gbvCMKHSIJ/BPLCjfMtq4B6A7g
        rNqoulrAInUAb3cwkmGMsCFbXeuik7g=
X-Google-Smtp-Source: APXvYqxuKNSeFz1C+nBDsq43mvjXhYdVh0K127lyyGuMeAHul+AvxJJ8zwUslbKQoWU+WBuSQSdynw==
X-Received: by 2002:a7b:cbc6:: with SMTP id n6mr2995191wmi.6.1565876797246;
        Thu, 15 Aug 2019 06:46:37 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id i5sm2394682wrn.48.2019.08.15.06.46.36
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 15 Aug 2019 06:46:36 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        mlxsw@mellanox.com
Subject: [patch net-next v4 2/2] selftests: netdevsim: add devlink regions tests
Date:   Thu, 15 Aug 2019 15:46:34 +0200
Message-Id: <20190815134634.9858-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190815134634.9858-1-jiri@resnulli.us>
References: <20190815134634.9858-1-jiri@resnulli.us>
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

