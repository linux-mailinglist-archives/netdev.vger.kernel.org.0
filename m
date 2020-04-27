Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB7A31BB228
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 01:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbgD0XvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 19:51:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726244AbgD0XvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 19:51:02 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E0BFC0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 16:51:02 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id f7so9779423pfa.9
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 16:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=vtY0fL5ZVtBrIXBGjRdLuaI2tiIhNBnCzlrDeA3osCs=;
        b=TKenPXtelDxBJbE6h7L3/jHw59uWmw9MFIvARi8EkCFlRCKepM4Kpd9m82y/TX7azM
         lF5Y0WzzvgOcRElHjc5NecfU2xgx99/ORZqzmh13n+W0dWCVjZtL44/F/T7vMQ2C1ZXm
         OzaX5a6cGXD8mjsEDI3x9VKpYRH9MCUvwuvj8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vtY0fL5ZVtBrIXBGjRdLuaI2tiIhNBnCzlrDeA3osCs=;
        b=tqWL8EgKMZwg92gx4F9ojM0UlMaXbKzncP8Yqx+j6W18tytp+vjyl1XAA8V93LJHVk
         DPMwZ59TAWxH34BztJxtTESxmfOIie/YbmEp9P/tA12v+Gd77jdijBSKlyXfXDfa91GR
         eNW96peAlNYvSMHQIosYVgKaBMtf7mHh9a05jrv8ADpY29HllVijHevLRwjcOvFu2tCe
         xraBXpb2+2MxUfSSa10NfBIWvItWBZakoR3/gwTEXOFjWAXDylTCsP2zoWqlg3P9TrTV
         dxIYhlCuZEK9fEpqHDDxuixQoGlgPHYRXygLzFqxtPzfz3O5DLGku9oijiRdBls5psLZ
         s/jQ==
X-Gm-Message-State: AGi0PubcToUw2pucWbIAZl8fRd28Z+00AzLn4c4rlwgQ69dhNwyVRSI2
        qQpRXAbBW01k208nvXgoqG2kIgRXOjI=
X-Google-Smtp-Source: APiQypIsK6NhWzpYIyIDv2eF3v1gtF7tLOcTzJm9LEo4Aavw1WLYTx+dr4eV+1vP81en2x9fJSDGBQ==
X-Received: by 2002:a63:ac57:: with SMTP id z23mr6621355pgn.423.1588031461235;
        Mon, 27 Apr 2020 16:51:01 -0700 (PDT)
Received: from f3.synalogic.ca (ae055068.dynamic.ppp.asahi-net.or.jp. [14.3.55.68])
        by smtp.gmail.com with ESMTPSA id 128sm13058106pfy.5.2020.04.27.16.51.00
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 16:51:00 -0700 (PDT)
From:   Benjamin Poirier <bpoirier@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Subject: [PATCH iproute2 2/7] bridge: Use consistent column names in vlan output
Date:   Tue, 28 Apr 2020 08:50:46 +0900
Message-Id: <20200427235051.250058-3-bpoirier@cumulusnetworks.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200427235051.250058-1-bpoirier@cumulusnetworks.com>
References: <20200427235051.250058-1-bpoirier@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix singular vs plural. Add a hyphen to clarify that each of those are
single fields.

Signed-off-by: Benjamin Poirier <bpoirier@cumulusnetworks.com>
---
 bridge/vlan.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/bridge/vlan.c b/bridge/vlan.c
index 08b19897..a708e6d2 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -538,9 +538,9 @@ static int vlan_show(int argc, char **argv, int subject)
 		}
 
 		if (!is_json_context()) {
-			printf("port\tvlan ids");
+			printf("port\tvlan-id");
 			if (subject == VLAN_SHOW_TUNNELINFO)
-				printf("\ttunnel id");
+				printf("\ttunnel-id");
 			printf("\n");
 		}
 
@@ -559,7 +559,7 @@ static int vlan_show(int argc, char **argv, int subject)
 		}
 
 		if (!is_json_context())
-			printf("%-16s vlan id\n", "port");
+			printf("%-16s vlan-id\n", "port");
 
 		if (rtnl_dump_filter(&rth, print_vlan_stats, stdout) < 0) {
 			fprintf(stderr, "Dump terminated\n");
-- 
2.26.0

