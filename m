Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 346CF1711BB
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 08:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbgB0Huk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 02:50:40 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41030 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728547AbgB0Hui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 02:50:38 -0500
Received: by mail-wr1-f65.google.com with SMTP id v4so2032283wrs.8
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 23:50:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zAuvfwfSoLJSgnbdSd3wImTQKxFcl6AgvX+V5pkiS5k=;
        b=X5rKi7qEsgz4frh8duj31IGsLqA0yUJyVMB36+OSQT+PUHBMGf4onwkUmrrlZfA06g
         qPvL55CLa8gJ1RmBNai7NkaYmnI79LPrxxL3X7Kqvd8UA2ZB84cWKpIAeQmbEb0YkIDP
         v748NLGh548G4OCCOFc93GygaX3FjYRhybS5VtFYOx+JvZV79ut90r77VCqk2rDx4Ag2
         ZX+9W1yRibdSJnIP5nOIfATZe/PIlQ6cMe/gtDvH1Qp59b2AbN6IK2lCeqygwG8sR4Ok
         NnLw0MWzfh8EB5WF9+N3gcBVSOzAsT+tWTxLBWdvuRSLLHwfeZMgRqRlBzfRL3pYBAZR
         o2lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zAuvfwfSoLJSgnbdSd3wImTQKxFcl6AgvX+V5pkiS5k=;
        b=VaVisekwAm61F0tgG3KcPprrsxDlKsJ/NYieRObOiSrnH1GNY/CbD1CbPzGz74GYOg
         4CAB+7yMVnT+DDEWpS+K0dAveMC85gTsgeVNsdhZQI7GDPa6vYcENeC+9LSTZfRf5c9N
         awZaDPHIu08RFsKOAi2xKMqqR2dtwgxl1L0XEIzzOGJJn2jE+S+JM6mlltvrti2SSc1F
         oXm4H20jPzg3ChoaADy+StDP6mBBFAryQ/sR9eEvok0Jqq9F2fTcSqFXPwOILJpY4Ghj
         sNP1dkUTCnOcehGqCnR3hwS5RKQ5EMfJt7UzuQlDS8g0YOrJmQaRrW99aH6R/Qj/PS0/
         F0Xw==
X-Gm-Message-State: APjAAAWZOVZRwTziapRAff2hC3HBRHbSssb0iOb+Hk1tx4RCV18TjfDZ
        y3nojsBb0eK9vTxHH1OaRiMWmA7QfDw=
X-Google-Smtp-Source: APXvYqwxv1GCOUC2F5Q9zRWqq/b6O/3aRa94MylQOeJzjHxOWkwCX2i9//bXbnCqGuQlHSvadfmVDg==
X-Received: by 2002:adf:e910:: with SMTP id f16mr3269325wrm.20.1582789836772;
        Wed, 26 Feb 2020 23:50:36 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id h17sm7123479wro.52.2020.02.26.23.50.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 23:50:36 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com, shuah@kernel.org
Subject: [patch net-next 12/16] selftests: mlxsw: Add mlxsw lib
Date:   Thu, 27 Feb 2020 08:50:17 +0100
Message-Id: <20200227075021.3472-13-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200227075021.3472-1-jiri@resnulli.us>
References: <20200227075021.3472-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shalom Toledo <shalomt@mellanox.com>

Add mlxsw lib for common defines, helpers etc.

Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 .../selftests/drivers/net/mlxsw/mlxsw_lib.sh        | 13 +++++++++++++
 1 file changed, 13 insertions(+)
 create mode 100644 tools/testing/selftests/drivers/net/mlxsw/mlxsw_lib.sh

diff --git a/tools/testing/selftests/drivers/net/mlxsw/mlxsw_lib.sh b/tools/testing/selftests/drivers/net/mlxsw/mlxsw_lib.sh
new file mode 100644
index 000000000000..cbe50f260a40
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/mlxsw_lib.sh
@@ -0,0 +1,13 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+##############################################################################
+# Defines
+
+if [[ ! -v MLXSW_CHIP ]]; then
+	MLXSW_CHIP=$(devlink -j dev info $DEVLINK_DEV | jq -r '.[][]["driver"]')
+	if [ -z "$MLXSW_CHIP" ]; then
+		echo "SKIP: Device $DEVLINK_DEV doesn't support devlink info command"
+		exit 1
+	fi
+fi
-- 
2.21.1

