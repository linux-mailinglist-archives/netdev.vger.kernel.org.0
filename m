Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB004B3546
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 14:28:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234508AbiBLN2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Feb 2022 08:28:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbiBLN17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Feb 2022 08:27:59 -0500
Received: from smtp.smtpout.orange.fr (smtp01.smtpout.orange.fr [80.12.242.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08AF7B9
        for <netdev@vger.kernel.org>; Sat, 12 Feb 2022 05:27:54 -0800 (PST)
Received: from localhost.localdomain ([124.33.176.97])
        by smtp.orange.fr with ESMTPA
        id IsR7niVP1u3WEIsRKn94XY; Sat, 12 Feb 2022 14:27:53 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: MDU0YmViZGZmMDIzYiBlMiM2NTczNTRjNWZkZTMwOGRiOGQ4ODf3NWI1ZTMyMzdiODlhOQ==
X-ME-Date: Sat, 12 Feb 2022 14:27:53 +0100
X-ME-IP: 124.33.176.97
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-can@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH iproute2] iplink_can: print_usage: typo fix, add missing spaces
Date:   Sat, 12 Feb 2022 22:27:27 +0900
Message-Id: <20220212132727.3710-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The can help menu misses three spaces for the TDCV, TDCO and TDCF
parameters, making the closing curly bracket unaligned.

For reference, before this patch:

| $ ip link help can
| Usage: ip link set DEVICE type can
| 	[ bitrate BITRATE [ sample-point SAMPLE-POINT] ] |
| 	[ tq TQ prop-seg PROP_SEG phase-seg1 PHASE-SEG1
|  	  phase-seg2 PHASE-SEG2 [ sjw SJW ] ]
|
| 	[ dbitrate BITRATE [ dsample-point SAMPLE-POINT] ] |
| 	[ dtq TQ dprop-seg PROP_SEG dphase-seg1 PHASE-SEG1
|  	  dphase-seg2 PHASE-SEG2 [ dsjw SJW ] ]
| 	[ tdcv TDCV tdco TDCO tdcf TDCF ]
|
| 	[ loopback { on | off } ]
| 	[ listen-only { on | off } ]
| 	[ triple-sampling { on | off } ]
| 	[ one-shot { on | off } ]
| 	[ berr-reporting { on | off } ]
| 	[ fd { on | off } ]
| 	[ fd-non-iso { on | off } ]
| 	[ presume-ack { on | off } ]
| 	[ cc-len8-dlc { on | off } ]
| 	[ tdc-mode { auto | manual | off } ]
|
| 	[ restart-ms TIME-MS ]
| 	[ restart ]
|
| 	[ termination { 0..65535 } ]
|
| 	Where: BITRATE	:= { NUMBER in bps }
| 		  SAMPLE-POINT	:= { 0.000..0.999 }
| 		  TQ		:= { NUMBER in ns }
| 		  PROP-SEG	:= { NUMBER in tq }
| 		  PHASE-SEG1	:= { NUMBER in tq }
| 		  PHASE-SEG2	:= { NUMBER in tq }
| 		  SJW		:= { NUMBER in tq }
| 		  TDCV		:= { NUMBER in tc}
| 		  TDCO		:= { NUMBER in tc}
| 		  TDCF		:= { NUMBER in tc}
| 		  RESTART-MS	:= { 0 | NUMBER in ms }

... and after this patch:

| $ ip link help can
| Usage: ip link set DEVICE type can
| 	[ bitrate BITRATE [ sample-point SAMPLE-POINT] ] |
| 	[ tq TQ prop-seg PROP_SEG phase-seg1 PHASE-SEG1
|  	  phase-seg2 PHASE-SEG2 [ sjw SJW ] ]
|
| 	[ dbitrate BITRATE [ dsample-point SAMPLE-POINT] ] |
| 	[ dtq TQ dprop-seg PROP_SEG dphase-seg1 PHASE-SEG1
|  	  dphase-seg2 PHASE-SEG2 [ dsjw SJW ] ]
| 	[ tdcv TDCV tdco TDCO tdcf TDCF ]
|
| 	[ loopback { on | off } ]
| 	[ listen-only { on | off } ]
| 	[ triple-sampling { on | off } ]
| 	[ one-shot { on | off } ]
| 	[ berr-reporting { on | off } ]
| 	[ fd { on | off } ]
| 	[ fd-non-iso { on | off } ]
| 	[ presume-ack { on | off } ]
| 	[ cc-len8-dlc { on | off } ]
| 	[ tdc-mode { auto | manual | off } ]
|
| 	[ restart-ms TIME-MS ]
| 	[ restart ]
|
| 	[ termination { 0..65535 } ]
|
| 	Where: BITRATE	:= { NUMBER in bps }
| 		  SAMPLE-POINT	:= { 0.000..0.999 }
| 		  TQ		:= { NUMBER in ns }
| 		  PROP-SEG	:= { NUMBER in tq }
| 		  PHASE-SEG1	:= { NUMBER in tq }
| 		  PHASE-SEG2	:= { NUMBER in tq }
| 		  SJW		:= { NUMBER in tq }
| 		  TDCV		:= { NUMBER in tc }
| 		  TDCO		:= { NUMBER in tc }
| 		  TDCF		:= { NUMBER in tc }
| 		  RESTART-MS	:= { 0 | NUMBER in ms }

Fixes: 0c263d7c36ff ("iplink_can: add new CAN FD bittiming parameters:
Transmitter Delay Compensat ion (TDC)")
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 ip/iplink_can.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/ip/iplink_can.c b/ip/iplink_can.c
index 6ea02a2a..0e670a6c 100644
--- a/ip/iplink_can.c
+++ b/ip/iplink_can.c
@@ -53,9 +53,9 @@ static void print_usage(FILE *f)
 		"\t	  PHASE-SEG1	:= { NUMBER in tq }\n"
 		"\t	  PHASE-SEG2	:= { NUMBER in tq }\n"
 		"\t	  SJW		:= { NUMBER in tq }\n"
-		"\t	  TDCV		:= { NUMBER in tc}\n"
-		"\t	  TDCO		:= { NUMBER in tc}\n"
-		"\t	  TDCF		:= { NUMBER in tc}\n"
+		"\t	  TDCV		:= { NUMBER in tc }\n"
+		"\t	  TDCO		:= { NUMBER in tc }\n"
+		"\t	  TDCF		:= { NUMBER in tc }\n"
 		"\t	  RESTART-MS	:= { 0 | NUMBER in ms }\n"
 		);
 }
-- 
2.34.1

