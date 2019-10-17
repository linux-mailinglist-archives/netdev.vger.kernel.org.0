Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 091CBDB5EA
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 20:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503276AbfJQSW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 14:22:26 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:43175 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503264AbfJQSWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 14:22:25 -0400
Received: by mail-pg1-f193.google.com with SMTP id i32so1810420pgl.10
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 11:22:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sVXj4QsTp2+j0xPd9mlp//c3lsreZ1t/FKSxtEwd+Qg=;
        b=g7U95ug20YN7wGXLU32e09eYFLoF1sNrslvMwDe7ldzkO/OizTi7M6NXePX2FzTlsr
         KwGzl3LJtQWnyRtrdvskWAhR9MuKK8UnhKU0VPu3slmiqSBElt5okdBdJ2NQNHF42hhB
         96UdljDfM2FiB83BBe+qM3HGl2MaKgLgoudPNcm9p1j3mkifzaRmoCXuMIY9WtN8PdKL
         oIexssnRTL6c+QNO60QpqX5aKzCzj2cf7PnJuhdurfxaSt/LpRFD4eYYKtJSLEyuwI38
         gDfbhw3eFSLBvbM7lvT7erBc8ShMRrAWqPkTNSzG09YlqVh1ZOx2u93Hd/bf6wiCHD8I
         xaVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sVXj4QsTp2+j0xPd9mlp//c3lsreZ1t/FKSxtEwd+Qg=;
        b=WMgiCw5NppEsUba5a9QYC8yi/H7lUDrZgvngyrA8uKJ4tarm8z2F76BMZAm3u0BabM
         74ViBXDjFkiHxqwwLApCCgFvy7yPm7LMhH9JOonGdtd191o3P4xSyyl32lFjLVPrCHUe
         UBx2l4ndngHacFUqKEobIXPklNSOwUNok2ISmrZFiH1xhI0QLkMqsYFx/ZjRnUHJvoWo
         JxVIhh1100oN6kseaV/mmeyV0LXCF9vbBEgp6F9KRB41/SGpQcqn+jAxrkO9Um0g7WvU
         crOGGM/LUV0aBlJwbAr/x6X2nPopKY46WoSg7zzJXoLJ46sZA6sRFTb5oE897M46mKiz
         e0Yg==
X-Gm-Message-State: APjAAAX80bGyeuZzG2K9+DADwvE5HeEK49fZlzTTCIZmkHbxaaM0VVpB
        0b8n+6cfMy6LXiB70r7LinY=
X-Google-Smtp-Source: APXvYqwyysFsBBdmzJYRP8X9qFVKdscj6XaKT/s8IkmCdeWadaV343N3N1UHkgXKYaj6jxvDNVIKGg==
X-Received: by 2002:a17:90a:aa97:: with SMTP id l23mr5947288pjq.7.1571336544184;
        Thu, 17 Oct 2019 11:22:24 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id p24sm6174603pgc.72.2019.10.17.11.22.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 11:22:23 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "John W . Linville" <linville@tuxdriver.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH 33/33] fix unused parameter warning in e1000_get_mac_type()
Date:   Thu, 17 Oct 2019 11:21:21 -0700
Message-Id: <20191017182121.103569-33-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
In-Reply-To: <20191017182121.103569-1-zenczykowski@gmail.com>
References: <CAHo-Ooze4yTO_yeimV-XSD=AXvvd0BmbKdvUK4bKWN=+LXirYQ@mail.gmail.com>
 <20191017182121.103569-1-zenczykowski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

This fixes:
  external/ethtool/e1000.c:258:38: error: unused parameter 'revision_id' [-Werror,-Wunused-parameter]
  e1000_get_mac_type(u16 device_id, u8 revision_id)

Signed-off-by: Maciej Żenczykowski <maze@google.com>
Change-Id: I2469ef61996fd273cc3a2a6a7af0ae889c81b02b
---
 e1000.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/e1000.c b/e1000.c
index da057b7..91e5bc1 100644
--- a/e1000.c
+++ b/e1000.c
@@ -254,8 +254,7 @@ enum e1000_mac_type {
 	e1000_num_macs
 };
 
-static enum e1000_mac_type
-e1000_get_mac_type(u16 device_id, u8 revision_id)
+static enum e1000_mac_type e1000_get_mac_type(u16 device_id)
 {
 	enum e1000_mac_type mac_type = e1000_undefined;
 
@@ -369,7 +368,7 @@ int e1000_dump_regs(struct ethtool_drvinfo *info maybe_unused,
 {
 	u32 *regs_buff = (u32 *)regs->data;
 	u16 hw_device_id = (u16)regs->version;
-	u8 hw_revision_id = (u8)(regs->version >> 16);
+	/* u8 hw_revision_id = (u8)(regs->version >> 16); */
 	u8 version = (u8)(regs->version >> 24);
 	enum e1000_mac_type mac_type;
 	u32 reg;
@@ -377,7 +376,7 @@ int e1000_dump_regs(struct ethtool_drvinfo *info maybe_unused,
 	if (version != 1)
 		return -1;
 
-	mac_type = e1000_get_mac_type(hw_device_id, hw_revision_id);
+	mac_type = e1000_get_mac_type(hw_device_id);
 
 	if(mac_type == e1000_undefined)
 		return -1;
-- 
2.23.0.866.gb869b98d4c-goog

