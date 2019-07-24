Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 029F0732BF
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 17:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728429AbfGXP35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 11:29:57 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41656 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727477AbfGXP34 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 11:29:56 -0400
Received: by mail-pf1-f196.google.com with SMTP id m30so21144839pff.8;
        Wed, 24 Jul 2019 08:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MZyKGz2Q8KY/7X0/vC/wmGNz/wuI/1hX+eXaejNddm8=;
        b=bT37riDxkXg7hPbTdAqFW9vRzkWfcC9zzkBWurgyJHeq+46NHoAWdWrXqbitVSQkxs
         cgvSFX7PhTrXXYdZ2+fgPp0uJl2KNBST2FfhgH+UDNAoO9nIBtyyAKO8VAAyoR0TS76Z
         lu57I6quZLQ0Ddt7JBK8kO81J5YmES6l1zQLPuWI7WFCom0CH/EMVEkyVQK19QclcD+2
         s/4BbK8esMg0968QDJvceqXSTb1YmlC4O57P4rFS3SGIpfdUfiM98FWO1rMeXFu/CBiL
         0Ly7ol8Z5r8+ehEr7iQkC/8y/U0oloDAvD0uJLZrhnu2kPnq5+6O2K/eq4oQC2OEoWmn
         f8/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MZyKGz2Q8KY/7X0/vC/wmGNz/wuI/1hX+eXaejNddm8=;
        b=ExusHJj2INY2baQgPAi2NEE2eUHs8+v725FcMXNKC4DET1PGJOTmaNxWhU85fTIOau
         WcnG4WNnTSjYaFP1Dq3Q1MGzb5hxq9eLAIt0reZe6/zR1ytnQ+6fYMihs95LEOGs6UeR
         jlyGQ8WPg3NOOpfXUFB6uAAaKZMkN9OtMLsDJ2IJ0tc0Gvi5TZn+FJk9O1UNueCQRmA/
         aHk96ylEOjhml+6IUdYvZQX91dIN4e9PvyVJE1oJj2eosIGdr9x65YYHNSYGGAtwhm+A
         dHSFXc4oDC4LBiedHsOCGC12rNfKUgLDLZwcuwoCtYx/zMp/beOhfsUpGQi8fwGS9/5G
         i80A==
X-Gm-Message-State: APjAAAWb1C2oSVLAi3YR1tBHFRF2N9iXgQx489h9RI1Cr5wjiDy9fypJ
        9C0STK00TomLNeqUIhA9ds4=
X-Google-Smtp-Source: APXvYqwuJGPxuWZefaf8Mi+AQwRdAYZaYczj2Ib+PrReI8r5VVpgBLb+D88GfvimxK4pGTs7Z8+I+A==
X-Received: by 2002:aa7:9591:: with SMTP id z17mr12046815pfj.215.1563982196241;
        Wed, 24 Jul 2019 08:29:56 -0700 (PDT)
Received: from masabert (i118-21-156-233.s30.a048.ap.plala.or.jp. [118.21.156.233])
        by smtp.gmail.com with ESMTPSA id u7sm31466731pfm.96.2019.07.24.08.29.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 08:29:55 -0700 (PDT)
Received: by masabert (Postfix, from userid 1000)
        id 45C53201374; Thu, 25 Jul 2019 00:29:53 +0900 (JST)
From:   Masanari Iida <standby24x7@gmail.com>
To:     shuah@kernel.org, linux-kernel@vger.kernel.org, jiri@mellanox.com,
        idosch@mellanox.com, linux-kselftest@vger.kernel.org,
        rdunlap@infradead.org, netdev@vger.kernel.org
Cc:     Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH net-next] selftests: mlxsw: Fix typo in qos_mc_aware.sh
Date:   Thu, 25 Jul 2019 00:29:51 +0900
Message-Id: <20190724152951.4618-1-standby24x7@gmail.com>
X-Mailer: git-send-email 2.22.0.545.g9c9b961d7eb1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fix some spelling typo in qos_mc_aware.sh

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
---
 tools/testing/selftests/drivers/net/mlxsw/qos_mc_aware.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/qos_mc_aware.sh b/tools/testing/selftests/drivers/net/mlxsw/qos_mc_aware.sh
index 71231ad2dbfb..47315fe48d5a 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/qos_mc_aware.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/qos_mc_aware.sh
@@ -262,7 +262,7 @@ test_mc_aware()
 
 	stop_traffic
 
-	log_test "UC performace under MC overload"
+	log_test "UC performance under MC overload"
 
 	echo "UC-only throughput  $(humanize $ucth1)"
 	echo "UC+MC throughput    $(humanize $ucth2)"
@@ -316,7 +316,7 @@ test_uc_aware()
 
 	stop_traffic
 
-	log_test "MC performace under UC overload"
+	log_test "MC performance under UC overload"
 	echo "    ingress UC throughput $(humanize ${uc_ir})"
 	echo "    egress UC throughput  $(humanize ${uc_er})"
 	echo "    sent $attempts BC ARPs, got $passes responses"
-- 
2.22.0.545.g9c9b961d7eb1

