Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3489C60B4BE
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 20:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbiJXSCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 14:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232710AbiJXSCN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 14:02:13 -0400
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D2D2AC2A6
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 09:42:33 -0700 (PDT)
Received: by mail-wr1-f53.google.com with SMTP id o4so8906401wrq.6
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 09:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kgz6zkbhV+/M/hhXHkqSL44j09J30fQL6xdo24kkgPo=;
        b=dvaaHytkbIhxR1Oh9OIeGJEMkksawm686JOuTFw+2KCwAk1mUt+Hv82XBVWf3TsM8M
         yYl9vMyIH7JFPkmwkjSxzAkyOM/jzqwNMn29TsY4LQ+F2kr3qpnxUk3YZ2g1f24bjDcS
         N2ZoB1D+a8B6Z9w6qdCgolXFKGaXlBpyXfjnNhlzpR7rG5SxlVFD+YDDWQ5Sq3C3+yUh
         BQyKI27mM04UarDwuFtKwPkaHvH0qo9dI1O7+WHSAM+UeTFt5l6Cs8JSbvoqQeJYO2SO
         o3/wpyv6rLKeUCF1FJLKE01uSqp7Yp8wxocvE3JUOodFMltkkBKOX3yqr7kfPzz1QkCv
         D2WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kgz6zkbhV+/M/hhXHkqSL44j09J30fQL6xdo24kkgPo=;
        b=RfO6Wm1x/AwJKCXSfUrL2IIamWS81SWpLeONsbxo+ZO2Wf1BKBdbQ2cwN28r0Uzecd
         5Xt0UWazCU6TVdjCZ5hSjL9JveEi/rEWlKsaDOT8+92PSBW4v6s0RlVqO32aB9YcSE42
         Fcb433f138XR/fiL9MCOvjLJPOBD3MXa67+qTCkatREk7YehyaVJQTXzVpAbRqFCxQAu
         mNa02Niw+WRtEgfsgKPDqFyom+0v49px/4pw4MU4wxWOOPoBSpaeaQkpAzL4o4ve5zLt
         3ZXHglKcxezpzjEOMTKGZc/rb5Xodh+MfvFPFjwZHXfV8iCH3CxIBsL2aOGlfxf7UTFX
         8/mQ==
X-Gm-Message-State: ACrzQf3QQCh/JJRzYes/7DhjDwUsMIFwBHmI++qYJ2XEnxJStk+AR4j5
        jgjjgg4zlCtFHh5zWCEt1A==
X-Google-Smtp-Source: AMsMyM6V+5BJ5d0bFAo/1bPLsGAy/Dvh3IKBt4nEYVsgBE+T53v5CwWYBVomBCZd97Eb9soX0AEOFw==
X-Received: by 2002:a05:6000:144d:b0:231:5786:f763 with SMTP id v13-20020a056000144d00b002315786f763mr22058182wrx.313.1666629588856;
        Mon, 24 Oct 2022 09:39:48 -0700 (PDT)
Received: from localhost (187.red-88-28-7.dynamicip.rima-tde.net. [88.28.7.187])
        by smtp.gmail.com with ESMTPSA id q12-20020a05600c46cc00b003c70191f267sm9045051wmo.39.2022.10.24.09.39.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 09:39:48 -0700 (PDT)
From:   Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc:     Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        NETDEV ML <netdev@vger.kernel.org>
Subject: [PATCH] ethtool: fix man page errors
Date:   Mon, 24 Oct 2022 18:39:46 +0200
Message-Id: <20221024163946.7170-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

troff: <standard input>:82: warning: macro '.' not defined
troff: <standard input>:252: warning: macro 'RN' not defined
troff: <standard input>:698: warning: macro 'E' not defined

Cc: Michal Kubecek <mkubecek@suse.cz>
Cc: NETDEV ML <netdev@vger.kernel.org>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
Tested with:
man --warnings -E UTF-8 -l -Tutf8 -Z ethtool.8 > /dev/null
groff -z -wall -b -e -t ethtool.8

---
 ethtool.8.in | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/ethtool.8.in b/ethtool.8.in
index dee39dd..c4477f0 100644
--- a/ethtool.8.in
+++ b/ethtool.8.in
@@ -79,7 +79,7 @@
 .\"	\(*NC - Network Classifier type values
 .\"
 .ds NC \fBether\fP|\fBip4\fP|\fBtcp4\fP|\fBudp4\fP|\fBsctp4\fP|\fBah4\fP|\fBesp4\fP|\fBip6\fP|\fBtcp6\fP|\fBudp6\fP|\fBah6\fP|\fBesp6\fP|\fBsctp6\fP
-..
+.
 .\"
 .\" Start URL.
 .de UR
@@ -249,7 +249,7 @@ ethtool \- query or control network driver and hardware settings
 .RB [\fBeth\-phy\fP]
 .RB [\fBeth\-mac\fP]
 .RB [\fBeth\-ctrl\fP]
-.RN [\fBrmon\fP]
+.RB [\fBrmon\fP]
 .RB ]
 .HP
 .B ethtool \-\-phy\-statistics
@@ -695,7 +695,7 @@ naming of NIC- and driver-specific statistics across vendors.
 .RS 4
 .TP
 .B \fB\-\-all\-groups
-.E
+.RE
 .TP
 .B \fB\-\-groups [\fBeth\-phy\fP] [\fBeth\-mac\fP] [\fBeth\-ctrl\fP] [\fBrmon\fP]
 Request groups of standard device statistics.
-- 
2.38.1

