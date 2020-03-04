Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80F2C1790AF
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 13:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729410AbgCDM4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 07:56:23 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:38016 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729256AbgCDM4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 07:56:23 -0500
Received: by mail-yw1-f68.google.com with SMTP id 10so1798098ywv.5
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 04:56:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=p5FgOQvinEPAkC716H56BJiExSQOWJ/ens3qt/F5d6o=;
        b=v4W4PLp6cHKhJJhw8He6ezUP57E+xMucCXrmDkRSr4KRlBnA2MWPiwej/yzxQZeYIw
         8fuvYCTSjQSmeAPbEL4t9PQgw3LQYMA5WswTctLFqw/ztMai4qzYu/PJQLMxoVGSvXT/
         RMdXL0mzJIuZ/QFGsndkMqcsU8diGzpjgx1iFc0EqZaH8PCnHxgjnzDfpHcFenjO9bsF
         fEqexzdbb6OPpqttkUMJJTOLSBAURAtKIlHlGjA2LSPfnIntTqCRuNPjmmFs8KH8ghGL
         r0W/CIwx6olE44e778bOqkRpsZHPjh9JzqDAgZwj+rG0GXV6GxeXxjeaEE+Tk61fWrDG
         rbag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=p5FgOQvinEPAkC716H56BJiExSQOWJ/ens3qt/F5d6o=;
        b=rPx5IAUrgrAXKPB7HwU/J6Mgjdou7NQmPN0vs3kvTKWy9O5+KFk+jKxwhhxme+I3d/
         6U9KCD+0dxXKbj2uDztbAy1ADbi+a4spdPuUBcSdfEGC2xRovH2kyVlqhHoV01S7L9/B
         rNmiRmG9nzK46IV/N7dBY2h4687PyrUoisOWykvLopyBZJUPbT9J2jV5JF1+g3QkbcNg
         sFRrQY9rrFyCeGBG8/rrwdi4qVMm3SwUGdYAquOMKrd5/KdtiGIsbPBVR2YA2813Hqat
         dxMuKRc7soHiE0oQ6ozQ65wNaJkPnSdzeQeX/14uQrJs9Yfr3U2nGtPeZZ2q9zqa44TN
         V+JQ==
X-Gm-Message-State: ANhLgQ0HU0QAxLxmb5ZOsXp7d7QlXarPplh2lWdfHHqPG+hiqnRz/t/n
        iKkdVCMI5rpNoWinDkz9YBEElA==
X-Google-Smtp-Source: ADFU+vvZ7AafZo+3PX6b7TOmLz6YuVc88LjdG1zVA+YcFQNrH+lwHu+28cyy8TEoVbhng8oKYqNbUA==
X-Received: by 2002:a25:47d5:: with SMTP id u204mr2270190yba.500.1583326580568;
        Wed, 04 Mar 2020 04:56:20 -0800 (PST)
Received: from mojatatu.com ([74.127.202.122])
        by smtp.gmail.com with ESMTPSA id y189sm10481104ywe.21.2020.03.04.04.56.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 04 Mar 2020 04:56:20 -0800 (PST)
From:   Roman Mashak <mrv@mojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH net-next 1/2] tc-testing: list kernel options for basic filter with canid ematch.
Date:   Wed,  4 Mar 2020 07:55:46 -0500
Message-Id: <1583326547-23121-1-git-send-email-mrv@mojatatu.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Roman Mashak <mrv@mojatatu.com>
---
 tools/testing/selftests/tc-testing/config | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/config b/tools/testing/selftests/tc-testing/config
index 477bc61b374a..c812faa29f36 100644
--- a/tools/testing/selftests/tc-testing/config
+++ b/tools/testing/selftests/tc-testing/config
@@ -31,6 +31,7 @@ CONFIG_NET_EMATCH_U32=m
 CONFIG_NET_EMATCH_META=m
 CONFIG_NET_EMATCH_TEXT=m
 CONFIG_NET_EMATCH_IPSET=m
+CONFIG_NET_EMATCH_CANID=m
 CONFIG_NET_EMATCH_IPT=m
 CONFIG_NET_CLS_ACT=y
 CONFIG_NET_ACT_POLICE=m
@@ -57,3 +58,8 @@ CONFIG_NET_IFE_SKBMARK=m
 CONFIG_NET_IFE_SKBPRIO=m
 CONFIG_NET_IFE_SKBTCINDEX=m
 CONFIG_NET_SCH_FIFO=y
+
+#
+## Network testing
+#
+CONFIG_CAN=m
-- 
2.7.4

