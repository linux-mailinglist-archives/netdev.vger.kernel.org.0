Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51CF48ED28
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 15:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732434AbfHONmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 09:42:36 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34823 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729918AbfHONmf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 09:42:35 -0400
Received: by mail-wr1-f67.google.com with SMTP id k2so2278218wrq.2
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 06:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oxRwEXAVstWIzVhCtKLI+uJftYF7Jca1fTx4xr/sTgc=;
        b=WUIMRYGw2cOYGt85UafqO7fuoGqoRNwEjz/vu11H7b9o5MRdn/qD4WodXBoErYpZaS
         G5v47wpmHg/D8rliMjBo/y0qaTm2h4TKiUE1Pvho4ool2ZZB/RLuidCkiTiIpxv7dcPV
         ZWeuc2usD8O0WoTT28iBAmqK6+42mLwK6w24PnteM/SSi6jo3B80QVS87xMhn/tC07Wi
         22D4dKxd4PVKj7MOODP8vSjyOnP8GpVfgs5GiM+8Jrs4dHaprXYMa263Rr6jt21ohTie
         RY3Qx0152dQqRopFhQCZP/XT3fbbI/naPewiaomixkShdGSKINI9D8wJ2//QmUp1cVgX
         puWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oxRwEXAVstWIzVhCtKLI+uJftYF7Jca1fTx4xr/sTgc=;
        b=PuIC206OFrkLfDsVFJzfzieK8p8J8QkIgNFXqBBXoAaZJjuzb9WubQqFJrcug5RWek
         Nph1xPsIIvRu7N2MIOm2px1wk2QH6xP8GKbyoGpJXFgftVcdtp4igkYYSbp6DO58wsla
         4/mxybd4ceca/bf5XF3W+aen0FQ6l4X6+IkZpxFB/dZFRMFZlVj4LvSgQr4dYQHA1Ayt
         MEQYmfIzbWL1JPdBEV2poqhWCdUZWCCmviXFg1iLjsYOi3eHi3AA5Q2hbS7anOaLPWsK
         r3XJCOxRH6ePuEkzFX4CMTYxqA4/HMWaANwLHHdK2Bhze0IJP+TqOe6hU8ebL0Kv4WBB
         5BMQ==
X-Gm-Message-State: APjAAAXa0/be9q00plRvluoRzx+QtA+r8JbFeYzw4AHIR99pE112R3B7
        ApCXuq1prvElh5FeIG9NZoY9YJSZ3r8=
X-Google-Smtp-Source: APXvYqw+w3OrX09N9xbBe5z/073oJ4w5VhPVHr4HWkTEffNe1oV9SRtynTmS50X/rO2UsXpahetASg==
X-Received: by 2002:adf:ffc2:: with SMTP id x2mr1743346wrs.338.1565876553230;
        Thu, 15 Aug 2019 06:42:33 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id h2sm1196198wmb.28.2019.08.15.06.42.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 15 Aug 2019 06:42:32 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        mlxsw@mellanox.com
Subject: [patch net-next v3 2/2] selftests: netdevsim: add devlink params tests
Date:   Thu, 15 Aug 2019 15:42:29 +0200
Message-Id: <20190815134229.8884-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190815134229.8884-1-jiri@resnulli.us>
References: <20190815134229.8884-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Test recently added netdevsim devlink param implementation.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v1->v2:
-using cmd_jq helper
---
 .../drivers/net/netdevsim/devlink.sh          | 62 ++++++++++++++++++-
 1 file changed, 61 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
index 9d8baf5d14b3..6828e9404460 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
@@ -3,7 +3,7 @@
 
 lib_dir=$(dirname $0)/../../../net/forwarding
 
-ALL_TESTS="fw_flash_test"
+ALL_TESTS="fw_flash_test params_test"
 NUM_NETIFS=0
 source $lib_dir/lib.sh
 
@@ -30,6 +30,66 @@ fw_flash_test()
 	log_test "fw flash test"
 }
 
+param_get()
+{
+	local name=$1
+
+	cmd_jq "devlink dev param show $DL_HANDLE name $name -j" \
+	       '.[][][].values[] | select(.cmode == "driverinit").value'
+}
+
+param_set()
+{
+	local name=$1
+	local value=$2
+
+	devlink dev param set $DL_HANDLE name $name cmode driverinit value $value
+}
+
+check_value()
+{
+	local name=$1
+	local phase_name=$2
+	local expected_param_value=$3
+	local expected_debugfs_value=$4
+	local value
+
+	value=$(param_get $name)
+	check_err $? "Failed to get $name param value"
+	[ "$value" == "$expected_param_value" ]
+	check_err $? "Unexpected $phase_name $name param value"
+	value=$(<$DEBUGFS_DIR/$name)
+	check_err $? "Failed to get $name debugfs value"
+	[ "$value" == "$expected_debugfs_value" ]
+	check_err $? "Unexpected $phase_name $name debugfs value"
+}
+
+params_test()
+{
+	RET=0
+
+	local max_macs
+	local test1
+
+	check_value max_macs initial 32 32
+	check_value test1 initial true Y
+
+	param_set max_macs 16
+	check_err $? "Failed to set max_macs param value"
+	param_set test1 false
+	check_err $? "Failed to set test1 param value"
+
+	check_value max_macs post-set 16 32
+	check_value test1 post-set false Y
+
+	devlink dev reload $DL_HANDLE
+
+	check_value max_macs post-reload 16 16
+	check_value test1 post-reload false N
+
+	log_test "params test"
+}
+
 setup_prepare()
 {
 	modprobe netdevsim
-- 
2.21.0

