Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B285E1888DC
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 16:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgCQPQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 11:16:54 -0400
Received: from mail-wm1-f45.google.com ([209.85.128.45]:37872 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726780AbgCQPQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 11:16:53 -0400
Received: by mail-wm1-f45.google.com with SMTP id a141so22439240wme.2
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 08:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qMexfxqVVNACAlGoW/qcax5zZd0UHBpzvUUZDaKUDcU=;
        b=JuWdj65KxhctTT2rpfiFs6WFFbO6XgH/bgkBLQGWGvMWXBfd0k2gmC7PGsgseXFua4
         d/i790DJftOaIhgQWsOtORXxjXYyNBTEb9JFntbaqkC9U3ygppV+lfT8RPJc9Qy/cgN3
         iFTBvYA3thSR3BwWN1/jqpd+QqCX8IBwJDsQM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qMexfxqVVNACAlGoW/qcax5zZd0UHBpzvUUZDaKUDcU=;
        b=DK9EDxeCjK7uz2OuG/2T7B+bkTDWBA1tkvDpyVCX6LhruzDwo/plRhJxm/Z1HGBxnK
         tDF0B1uUoKEdC3WL3g1DKnHeVBL8Nab+XrkovPz+I6npcMgbhBr3u1Pks1o97jRVNOic
         A8UnmpKU7UCXswR/ZGJqjCJueVK6ygyTUXEzuoB5JY2Zs7CWA3H9LnZ2/CcOPnOrS9Yj
         G6E5wFtTEgSIKmnkVtkGLN5DA3fw68UJkfihOCMBlaf9u88MO26K+ntqFvUpmfTXzKEP
         zsCOUmEnKuq9i6cjmMGAAwEfUBtXcvbtL/oJCK9uz2ics5ptndnHM0ODFfDA/402dilh
         kJ2w==
X-Gm-Message-State: ANhLgQ0Dyu2lSxum4Shtv+MCTGl55HKb2X6e1UZYmVTQJKfcZEBw/6YF
        Ram1mU60nIcUoS4Vk678Qb/krbJkO3k=
X-Google-Smtp-Source: ADFU+vvUiU1VlRvBNA4mGHbRHLgnRoTCh1nM72tLfQ1UyAkr+lo7pTecKAMfk9F1H+RyEctfXlNmCQ==
X-Received: by 2002:a1c:ab04:: with SMTP id u4mr5778043wme.88.1584458211218;
        Tue, 17 Mar 2020 08:16:51 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id x6sm4943916wrm.29.2020.03.17.08.16.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Mar 2020 08:16:50 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: [PATCH net-next 03/11] devlink: add macro for "hw.addr"
Date:   Tue, 17 Mar 2020 20:44:40 +0530
Message-Id: <1584458082-29207-4-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1584458082-29207-1-git-send-email-vasundhara-v.volam@broadcom.com>
References: <1584458082-29207-1-git-send-email-vasundhara-v.volam@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add definition and documentation for the new generic info "hw.addr".
"hw.addr" displays the hardware address of the interface.

Cc: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 Documentation/networking/devlink/devlink-info.rst | 5 +++++
 include/net/devlink.h                             | 3 +++
 2 files changed, 8 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-info.rst b/Documentation/networking/devlink/devlink-info.rst
index 0765a48..25658f2 100644
--- a/Documentation/networking/devlink/devlink-info.rst
+++ b/Documentation/networking/devlink/devlink-info.rst
@@ -65,6 +65,11 @@ drv.spec
 Firmware interface specification version of the software interfaces between
 driver and firmware. This tag displays spec version implemented by driver.
 
+hw.addr
+-------
+
+Hardware address of the interface.
+
 fw
 --
 
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 9c4d889..e130d24 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -479,6 +479,9 @@ enum devlink_param_generic_id {
 /* FW interface specification version implemented by driver */
 #define DEVLINK_INFO_VERSION_GENERIC_DRV_SPEC	"drv.spec"
 
+/* Hardware address */
+#define DEVLINK_INFO_VERSION_GENERIC_HW_ADDR	"hw.addr"
+
 /* Overall FW version */
 #define DEVLINK_INFO_VERSION_GENERIC_FW		"fw"
 /* Control processor FW version */
-- 
1.8.3.1

