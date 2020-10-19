Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 860B1292C9A
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 19:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731033AbgJSRYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 13:24:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33503 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730186AbgJSRYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 13:24:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603128261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=GlNRdQUy+AGKN2OBLvxM70f2rqnujuydEmx9LlvXhbI=;
        b=PGIT5IWEb8BBQWYvfEAvxxpioKhjAnMpXzvP82MrRX8SWQ4pD48w/WfPeAdbSeJ3NDZc0i
        0rYebwmlYu2Knvek1zNFhtHOk7CrdPXPn4zrJsWCgFRP/F0DtwYGrxtwaEzTCxNY2UlVEI
        W0sbwW3+cfucGjij0CsqHhCMVgdk3OQ=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-463-j5xyVmvVMMClELReIpyV6A-1; Mon, 19 Oct 2020 13:24:19 -0400
X-MC-Unique: j5xyVmvVMMClELReIpyV6A-1
Received: by mail-qt1-f200.google.com with SMTP id l12so370911qtu.22
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 10:24:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=GlNRdQUy+AGKN2OBLvxM70f2rqnujuydEmx9LlvXhbI=;
        b=tCRFjjmF4DvtjxFtMILWlk9e6lJat+YXoeA9cqVYq+QdrgIuxNTCKgq2hxf72ZYvqU
         o+thWPVJZm398OtQLd+JAV2v2/QJsq8dC3uxIjVBVoGErcJ7LqmTed5jY1Vje8xdNWYe
         ieyqqhW7SJN0K3IaMFHhNDROBXGR5JraDl4PsMEo8a6PayaKRHEk/OHtQa2weLMQIAfk
         uOitrlhw2t1t18MRrRTQxsbr4JwIVfnSq/FbGmbc0O9sJD/Yq/bjjx969NNgC809pf4j
         lW03M+FIsBIW0GMPhyjTPB+luxhHUuMyYcdNwqGZlWez2VmVkv4FOQp7UsVWycIQq1RV
         B+DA==
X-Gm-Message-State: AOAM531/bTQPTumC/s/SvwtRSK79Od3BlOXBhtwWh1KF7X8WBqB9p2MY
        BajeoC9CKFIXhFihpEXyS7DeAM5i7RCod9Hh87kkG3a7cZMucx9MHvvQfc32kMpPqd+sCwUwdHo
        bbC9gDbIEZ7FkohHA
X-Received: by 2002:ad4:456c:: with SMTP id o12mr941401qvu.48.1603128259073;
        Mon, 19 Oct 2020 10:24:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy1IY0STp8Q6ypEf1lWhvSs2JcyK6xaHXzjj4/dVdBi8JhNegNGdN/AJqDRKfg+58L+7+NNYg==
X-Received: by 2002:ad4:456c:: with SMTP id o12mr941370qvu.48.1603128258823;
        Mon, 19 Oct 2020 10:24:18 -0700 (PDT)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id s22sm222627qtc.33.2020.10.19.10.24.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 10:24:18 -0700 (PDT)
From:   trix@redhat.com
To:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        kuba@kernel.org, thomas.kopp@microchip.com,
        dan.carpenter@oracle.com, dev.kurt@vandijck-laurijssen.be
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: [PATCH] net: can: remove unneeded break
Date:   Mon, 19 Oct 2020 10:24:12 -0700
Message-Id: <20201019172412.31143-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

A break is not needed if it is preceded by a return

Signed-off-by: Tom Rix <trix@redhat.com>
---
 .../net/can/spi/mcp251xfd/mcp251xfd-core.c    | 22 +++++++++----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index c3f49543ff26..9c215f7c5f81 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -75,11 +75,11 @@ static const char *__mcp251xfd_get_model_str(enum mcp251xfd_model model)
 {
 	switch (model) {
 	case MCP251XFD_MODEL_MCP2517FD:
-		return "MCP2517FD"; break;
+		return "MCP2517FD";
 	case MCP251XFD_MODEL_MCP2518FD:
-		return "MCP2518FD"; break;
+		return "MCP2518FD";
 	case MCP251XFD_MODEL_MCP251XFD:
-		return "MCP251xFD"; break;
+		return "MCP251xFD";
 	}
 
 	return "<unknown>";
@@ -95,21 +95,21 @@ static const char *mcp251xfd_get_mode_str(const u8 mode)
 {
 	switch (mode) {
 	case MCP251XFD_REG_CON_MODE_MIXED:
-		return "Mixed (CAN FD/CAN 2.0)"; break;
+		return "Mixed (CAN FD/CAN 2.0)";
 	case MCP251XFD_REG_CON_MODE_SLEEP:
-		return "Sleep"; break;
+		return "Sleep";
 	case MCP251XFD_REG_CON_MODE_INT_LOOPBACK:
-		return "Internal Loopback"; break;
+		return "Internal Loopback";
 	case MCP251XFD_REG_CON_MODE_LISTENONLY:
-		return "Listen Only"; break;
+		return "Listen Only";
 	case MCP251XFD_REG_CON_MODE_CONFIG:
-		return "Configuration"; break;
+		return "Configuration";
 	case MCP251XFD_REG_CON_MODE_EXT_LOOPBACK:
-		return "External Loopback"; break;
+		return "External Loopback";
 	case MCP251XFD_REG_CON_MODE_CAN2_0:
-		return "CAN 2.0"; break;
+		return "CAN 2.0";
 	case MCP251XFD_REG_CON_MODE_RESTRICTED:
-		return "Restricted Operation"; break;
+		return "Restricted Operation";
 	}
 
 	return "<unknown>";
-- 
2.18.1

