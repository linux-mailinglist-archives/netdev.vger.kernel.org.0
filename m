Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A63B71856D
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 08:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbfEIG2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 02:28:09 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33297 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726683AbfEIG2J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 02:28:09 -0400
Received: by mail-pf1-f196.google.com with SMTP id z28so767610pfk.0;
        Wed, 08 May 2019 23:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=kZP2HNmj7RyfgLD/k4GFEwG7diYZHNIz0jKW+sjV7dY=;
        b=kJdIeVj20YPNax6R//2oL4+3b3zAg9mBiPdQii0EFALNz6nawDXt5ZLFF9JOZOwDbU
         0PfdrLG7XfldqGaiY7oVxg97+uUgZz1xbEiYa12GlBrR6SF/UCNsY9/B99lJZrKo3+//
         i5GmTHOiwbaiBXQk3Ko0F+5PrrxAoEozo46fkOHVLQtvzMYNCQcn3Qulfyha5PVcq+qt
         dkaz56y2FEavnc8tNQ3s7Mkz5Lewnl/LUZaRfE6hhRmQl818L3YgYXydkaKWD9Fgcwip
         Ncix/w33UNeJyki4pppgmtjKXZNEfCiq/P344YytaRR6VEFqgxqzzAoZzEwO0E7gCgu3
         0cqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=kZP2HNmj7RyfgLD/k4GFEwG7diYZHNIz0jKW+sjV7dY=;
        b=hr5Th+gRUfmtOI33Ys403ag/oRjyGA+Zo9M2DwrkliQktNcrhT4dE4etLogJwUlrht
         kMOA+igNPfuBBPQlwW9HVEjMXlgbDRLq87km2qowPF7AwceYDHMqHl4RMGFBkx9PDRrJ
         Ye6gFOf/QPsTv41tZE7Wcu6F8WxpLOZJhs2Y4rovhG5iuQA3JMrUuWRXy0Sd1yWO3nmB
         EkAPS5ApE6wgGIAJNSBvH6VTZRPLd5/ceJjM/z+LDNWBxpj/5mP9579ftlxteQngWcUK
         sBkgpC3t0igaMdna7U25y7EH0vrsOmnSwydDpFTif/V9dxx9krAPHRJR3hefPsdrVN/u
         Bbaw==
X-Gm-Message-State: APjAAAW+W6o4BsDpjOx0JkqyqXUoKt+AeXZAEcOHXy7ZWVbS3D8e/X8Q
        9o5FEr5L/5CRs9PWONY+Q9S6inU7lcs=
X-Google-Smtp-Source: APXvYqzuUjgWDV+BTb9/6AwjOrcKMgWdGbWv5byTg5eDfge6htxau1FAoIeYwTL2yY/Fik3EBfQCzg==
X-Received: by 2002:a63:4006:: with SMTP id n6mr3290737pga.424.1557383288312;
        Wed, 08 May 2019 23:28:08 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w12sm2897779pfj.41.2019.05.08.23.28.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 May 2019 23:28:07 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net
Subject: [PATCH net-next] sctp: remove unused cmd SCTP_CMD_GEN_INIT_ACK
Date:   Thu,  9 May 2019 14:28:00 +0800
Message-Id: <fa41cfdb9f8919d1420d12d270d97e3b17a0fb18.1557383280.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SCTP_CMD_GEN_INIT_ACK was introduced since very beginning, but never
got used. So remove it.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/command.h |  1 -
 net/sctp/sm_sideeffect.c   | 11 -----------
 2 files changed, 12 deletions(-)

diff --git a/include/net/sctp/command.h b/include/net/sctp/command.h
index 6d5beac..b4e8706 100644
--- a/include/net/sctp/command.h
+++ b/include/net/sctp/command.h
@@ -48,7 +48,6 @@ enum sctp_verb {
 	SCTP_CMD_REPORT_TSN,	/* Record the arrival of a TSN.  */
 	SCTP_CMD_GEN_SACK,	/* Send a Selective ACK (maybe).  */
 	SCTP_CMD_PROCESS_SACK,	/* Process an inbound SACK.  */
-	SCTP_CMD_GEN_INIT_ACK,	/* Generate an INIT ACK chunk.  */
 	SCTP_CMD_PEER_INIT,	/* Process a INIT from the peer.  */
 	SCTP_CMD_GEN_COOKIE_ECHO, /* Generate a COOKIE ECHO chunk. */
 	SCTP_CMD_CHUNK_ULP,	/* Send a chunk to the sockets layer.  */
diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 4aa0358..233ee80 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -1364,17 +1364,6 @@ static int sctp_cmd_interpreter(enum sctp_event_type event_type,
 						      cmd->obj.chunk);
 			break;
 
-		case SCTP_CMD_GEN_INIT_ACK:
-			/* Generate an INIT ACK chunk.  */
-			new_obj = sctp_make_init_ack(asoc, chunk, GFP_ATOMIC,
-						     0);
-			if (!new_obj)
-				goto nomem;
-
-			sctp_add_cmd_sf(commands, SCTP_CMD_REPLY,
-					SCTP_CHUNK(new_obj));
-			break;
-
 		case SCTP_CMD_PEER_INIT:
 			/* Process a unified INIT from the peer.
 			 * Note: Only used during INIT-ACK processing.  If
-- 
2.1.0

