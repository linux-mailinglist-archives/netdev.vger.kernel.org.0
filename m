Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A722911BB71
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 19:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731476AbfLKSQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 13:16:42 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:34200 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730431AbfLKSPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 13:15:20 -0500
Received: by mail-yw1-f68.google.com with SMTP id b186so2419327ywc.1;
        Wed, 11 Dec 2019 10:15:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KQntSsPAUtEB9BMBZ/3e2rZr1PM5BUjtq7Fl+Mpp/sk=;
        b=WcgDmgDCx9/OIl0tr+ajpacpBg+ZdEf6RxBUdL3zGVoXiIAeemYD5O+4eZRhvncaE2
         zxhbW46/CPFhKnWIPhD05TTG1LFmHhGpjJ9gG2sDa+J/JHrXWE5p3mA2InycUSaahLoC
         RSWC1vMpw5f/tuORD2cZX7NeJ6wslcKaS9lDKpZTPiPq3OfZ/KXKlpdsOcw7vee9Lkk9
         BylvaeiSRJIl7c4Z/Sap/66i5YV+pMbA1sE4dn7kplKTCmMLCtl1f5eJSYAHm0xVn+hc
         FJ4tAJTFrY/GakOWiW6/Jj71HNQ7n21XBBk6WiUFRUDfLtN53+DBWwAc4T08hHexue86
         fsLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KQntSsPAUtEB9BMBZ/3e2rZr1PM5BUjtq7Fl+Mpp/sk=;
        b=LPOz7Zh15T8trW3jsuM4Mm+PoJNczcnDdGp2lW+A/MpXsuwRKOVURTV2nNuA2gGFVR
         VOsm0TbPIEUto4ckHdaB5IgWhdeD+b0SPk/1Mz5tVnbWECY3yTVWxK7S/LMEbz2Tp5qY
         vwQKQ+hdLm9ZNPyO0h29klUb/9n/NOUayCUAOejGlpfxhiKdWPsJuEGa9R1RqPwhmWA6
         mw/v6foRPEX8PGUVEEWX23V5xXJpNCUwa4WcF6ud4NmItePnOnJltsKjGQ1rsUWVCAmG
         8GFUAcytsITF00h82vQI2vEp+SeopyCEElTy9O7aoqEaDDm9JrP1Nm3YPW2tXgCpp2JE
         mbJA==
X-Gm-Message-State: APjAAAWfxX6bnyv9XgUHWcPz2ftWi7czt4V2wczvBQ4QkumCZVYZV8Z5
        /J9ja1Poa+4ZLfI9Mwxh5GALdezWtehTWQ==
X-Google-Smtp-Source: APXvYqxZ0VsotfG3N2Oo/2dmOp/TuggB9nezCADiNrOqp8LLKmL64xXNzUVhzud/EVDeovSBW1WNXA==
X-Received: by 2002:a81:7b44:: with SMTP id w65mr858936ywc.87.1576088119319;
        Wed, 11 Dec 2019 10:15:19 -0800 (PST)
Received: from karen ([2604:2d80:d68a:cf00:a4bc:8e08:1748:387f])
        by smtp.gmail.com with ESMTPSA id i17sm1320402ywg.66.2019.12.11.10.15.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 10:15:19 -0800 (PST)
From:   Scott Schafer <schaferjscott@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     Scott Schafer <schaferjscott@gmail.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 10/23] staging: qlge: Fix CHECK: blank line after function/struct/union/enum declarations
Date:   Wed, 11 Dec 2019 12:12:39 -0600
Message-Id: <6801479fdbb77db607e1d8a3e2643b4c49aa26ce.1576086080.git.schaferjscott@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1576086080.git.schaferjscott@gmail.com>
References: <cover.1576086080.git.schaferjscott@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix CHECK: Please use a blank line after function/struct/union/enum
declarations in qlge_ethtool.c

Signed-off-by: Scott Schafer <schaferjscott@gmail.com>
---
 drivers/staging/qlge/qlge_ethtool.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/qlge/qlge_ethtool.c b/drivers/staging/qlge/qlge_ethtool.c
index f1654671ce80..794962ae642c 100644
--- a/drivers/staging/qlge/qlge_ethtool.c
+++ b/drivers/staging/qlge/qlge_ethtool.c
@@ -178,6 +178,7 @@ static const struct ql_stats ql_gstrings_stats[] = {
 static const char ql_gstrings_test[][ETH_GSTRING_LEN] = {
 	"Loopback test  (offline)"
 };
+
 #define QLGE_TEST_LEN (sizeof(ql_gstrings_test) / ETH_GSTRING_LEN)
 #define QLGE_STATS_LEN ARRAY_SIZE(ql_gstrings_stats)
 #define QLGE_RCV_MAC_ERR_STATS	7
-- 
2.20.1

