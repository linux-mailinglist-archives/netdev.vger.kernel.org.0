Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47B3BA76F3
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 00:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbfICW2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 18:28:48 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39077 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbfICW2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 18:28:47 -0400
Received: by mail-pf1-f195.google.com with SMTP id s12so4800639pfe.6
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 15:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7yfNw4Bdv3WfiviWWXtK52ymqe99jl6lzT3pr4gmL1E=;
        b=Zk//QjdfeBkhiNPlqbfMPYLe9o159h8seEaJ58RgROiLMsjuL2x/tQ7SqIFoHIDqQS
         zM2UC6IHlbDUasNlmqMx+t5OtK+xwct5jP+sdDxzng7bM7857UteWxZC5eDz3KAn3AeJ
         b6xs6l2Re7b8JsUsk3Fo7nOExcmoQdb9sUyjiXwCHzHxRTYTlf2R1uDjQ3ty9EcfGcfK
         X5mv15ENZ/R4QD07mRYYH68iphKhBPERMNteBBWs/8d/3SJtfHcE59BJsBMtDfIThh7X
         GqFiKh98nm/6WPthFulj/uFkNWgz+Rh7h8iz/88Fl1z/bKUU+0tPmZ/CsJKg0hR5AyJ9
         xp3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7yfNw4Bdv3WfiviWWXtK52ymqe99jl6lzT3pr4gmL1E=;
        b=l7aZwRDE0TN7R1MxS8E6ZM1+Po7bDJg6uo4LchR656Ql9ctHcfkST/wXsMsJWltsG8
         KWFUIk2gCHikPx2nYBbZHkg6R66tHAxoq5YAWUA2agoBp/g/jP7q7mBzYiDv7Y/w68uY
         DujOBe9uIiI7am6FlUbShmJJQNk54lxFHJDJpxfK+4BXmNEkowwuheo/KINnmyWcp4Lj
         3aV+iWU2u4lt9OCwYPaEOAZOBzumn5U0lQ+VPwySWDCXkxFg+GfEpBWT0Yv2Jl0Zn+OS
         REoYgXQ0LXPI2Pd8tokzHcdZ+Ne7mkusYh7AF3cKemeoDnXPJeM3kVW5JRSAU6zheXLY
         ymMQ==
X-Gm-Message-State: APjAAAUevQ7tJ3+HQHZJO8eIFO+Js6avErqxVuyCcguK/4jIIzU5T9wB
        fPPpC3EyHyiBehrjXqvud4DBSbElD2RRcQ==
X-Google-Smtp-Source: APXvYqy4avznJ8mTUG3T5etKCje9fDxR+/N5KIUekS3FGBTqyPfhqcZ5DsVW+HzpSMHsUfzOzk9vZw==
X-Received: by 2002:a17:90a:983:: with SMTP id 3mr1690701pjo.57.1567549727251;
        Tue, 03 Sep 2019 15:28:47 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id e17sm520520pjt.6.2019.09.03.15.28.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Sep 2019 15:28:46 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org, davem@davemloft.net
Cc:     Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH v7 net-next 01/19] devlink: Add new info version tags for ASIC and FW
Date:   Tue,  3 Sep 2019 15:28:03 -0700
Message-Id: <20190903222821.46161-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190903222821.46161-1-snelson@pensando.io>
References: <20190903222821.46161-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current tag set is still rather small and needs a couple
more tags to help with ASIC identification and to have a
more generic FW version.

Cc: Jiri Pirko <jiri@resnulli.us>
Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../networking/devlink-info-versions.rst         | 16 ++++++++++++++++
 include/net/devlink.h                            |  7 +++++++
 2 files changed, 23 insertions(+)

diff --git a/Documentation/networking/devlink-info-versions.rst b/Documentation/networking/devlink-info-versions.rst
index 4316342b7746..4914f581b1fd 100644
--- a/Documentation/networking/devlink-info-versions.rst
+++ b/Documentation/networking/devlink-info-versions.rst
@@ -14,11 +14,27 @@ board.rev
 
 Board design revision.
 
+asic.id
+=======
+
+ASIC design identifier.
+
+asic.rev
+========
+
+ASIC design revision.
+
 board.manufacture
 =================
 
 An identifier of the company or the facility which produced the part.
 
+fw
+==
+
+Overall firmware version, often representing the collection of
+fw.mgmt, fw.app, etc.
+
 fw.mgmt
 =======
 
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 7f43c48f54cd..b5476db66cfa 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -458,6 +458,13 @@ enum devlink_param_generic_id {
 /* Maker of the board */
 #define DEVLINK_INFO_VERSION_GENERIC_BOARD_MANUFACTURE	"board.manufacture"
 
+/* Part number, identifier of asic design */
+#define DEVLINK_INFO_VERSION_GENERIC_ASIC_ID	"asic.id"
+/* Revision of asic design */
+#define DEVLINK_INFO_VERSION_GENERIC_ASIC_REV	"asic.rev"
+
+/* Overall FW version */
+#define DEVLINK_INFO_VERSION_GENERIC_FW		"fw"
 /* Control processor FW version */
 #define DEVLINK_INFO_VERSION_GENERIC_FW_MGMT	"fw.mgmt"
 /* Data path microcode controlling high-speed packet processing */
-- 
2.17.1

