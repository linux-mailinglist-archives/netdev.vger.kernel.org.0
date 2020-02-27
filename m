Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0707A1711C3
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 08:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728589AbgB0Huq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 02:50:46 -0500
Received: from mail-wm1-f52.google.com ([209.85.128.52]:39810 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728420AbgB0Hun (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 02:50:43 -0500
Received: by mail-wm1-f52.google.com with SMTP id c84so2196347wme.4
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 23:50:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+BYUl5E8HS+BoOqdXIBVlH04Ok6pveU38Xhautf0ypI=;
        b=RS2fawju/wUN7HXPZ6fZx2kUEvvIqnzJ07dX6Eh239TD+cwHOvBJoyFMoehUNsM4Qk
         pU9s2procfv5/fUd3itcBkLN2fczku0zmf5R3QzermoHAoV7NFXrakScV1VyFzX0MTiY
         eZo2HsNVxMD9Jx3cenh3IJvkt/PaAkJKGx//vgp282lqn7kJOnWoByW5AkUXikUH/6aX
         mOLTu9d21Kc78ZTYV89kjQmoPOSzi93mBpDmGKYWp+ClLrBi2ZR1nhh4vdgpXLkfDDjt
         0R8nkCPhWmUFt7OQAgFO65YLIE8RZTonaFiM0IOPozxzdAll3w57+EOVjUAgJ6+E6C8L
         IZzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+BYUl5E8HS+BoOqdXIBVlH04Ok6pveU38Xhautf0ypI=;
        b=KmKSEq/Rauco0wBXfGjJAZEDSNV2qc3jYOoV3wVX5D9KwERPsb9gtO4uXOcEN5mA0A
         mNW3Z2t4AZnStpmme/EUpgzi4uszvuLl83FjfEcDnFzMmwWiMQvQD3Ja7Kj9DnUEaR6C
         Ae02NAUGza+/F3KajeTgpfy6f5skcwji6MJDL/hWR8GWkjcCl6qKCROq7D9A/z3XsWJT
         cxKjXKKT2yqMHRkDl+2wn+psPWXwH+0GTBwrdcpY3DgU9QUEIFtqixt3K7xiu+oZV8Co
         xYufHMxziJ0cvNPj+W40mfXxmm2CTG11lE3l2EEU2plm+6ssTDeX2CkerdmGrZTRpOCw
         +yYQ==
X-Gm-Message-State: APjAAAV9wQneD4yp+fFiU79X6t8fb6ObURSd0pBEybuzu6q59xYM/Bcn
        YlK7rXDMKPmooa0Cv2LIhP35nbmsoUY=
X-Google-Smtp-Source: APXvYqwbNl1y68mJCmiJO5WNO24Tehg8Eq6d2hzj4UHuY6pGSjF/yV6ytc9M/QfxyBHMxo4ILuAUpg==
X-Received: by 2002:a05:600c:242:: with SMTP id 2mr3485647wmj.2.1582789841939;
        Wed, 26 Feb 2020 23:50:41 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id h3sm7271980wrb.23.2020.02.26.23.50.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 23:50:41 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com, shuah@kernel.org
Subject: [patch net-next 16/16] selftests: mlxsw: resource_scale: Invoke for Spectrum-3
Date:   Thu, 27 Feb 2020 08:50:21 +0100
Message-Id: <20200227075021.3472-17-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200227075021.3472-1-jiri@resnulli.us>
References: <20200227075021.3472-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

The scale test for Spectrum-2 should be invoked for Spectrum-2 and
Spectrum-3. Add the appropriate device ID.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 .../selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
index 7b2acba82a49..fd583a171db7 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
@@ -8,8 +8,9 @@ source $lib_dir/lib.sh
 source $lib_dir/tc_common.sh
 source $lib_dir/devlink_lib.sh
 
-if [ "$DEVLINK_VIDDID" != "15b3:cf6c" ]; then
-	echo "SKIP: test is tailored for Mellanox Spectrum-2"
+if [[ "$DEVLINK_VIDDID" != "15b3:cf6c" && \
+	"$DEVLINK_VIDDID" != "15b3:cf70" ]]; then
+	echo "SKIP: test is tailored for Mellanox Spectrum-2 and Spectrum-3"
 	exit 1
 fi
 
-- 
2.21.1

