Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22FDA628F99
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 02:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232242AbiKOBze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 20:55:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231589AbiKOBzd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 20:55:33 -0500
Received: from mail.nfschina.com (mail.nfschina.com [124.16.136.209])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2F07717421;
        Mon, 14 Nov 2022 17:55:32 -0800 (PST)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id C69E61E80DC8;
        Tue, 15 Nov 2022 09:52:33 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Tyl9YcZ3otWi; Tue, 15 Nov 2022 09:52:28 +0800 (CST)
Received: from localhost.localdomain (unknown [219.141.250.2])
        (Authenticated sender: zeming@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 5C2F91E80DC6;
        Tue, 15 Nov 2022 09:52:28 +0800 (CST)
From:   Li zeming <zeming@nfschina.com>
To:     vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Li zeming <zeming@nfschina.com>
Subject: [PATCH] =?UTF-8?q?sctp:=20sm=5Fstatefuns:=20Remove=20unnecessary?= =?UTF-8?q?=20=E2=80=98NULL=E2=80=99=20values=20from=20Pointer?=
Date:   Tue, 15 Nov 2022 09:55:08 +0800
Message-Id: <20221115015508.3054-1-zeming@nfschina.com>
X-Mailer: git-send-email 2.18.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The packet pointer is assigned first. It does not need to initialize the
assignment.

Signed-off-by: Li zeming <zeming@nfschina.com>
---
 net/sctp/sm_statefuns.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index f6ee7f4040c1..714605746fee 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -3781,7 +3781,7 @@ static enum sctp_disposition sctp_sf_shut_8_4_5(
 					void *arg,
 					struct sctp_cmd_seq *commands)
 {
-	struct sctp_packet *packet = NULL;
+	struct sctp_packet *packet;
 	struct sctp_chunk *chunk = arg;
 	struct sctp_chunk *shut;
 
-- 
2.18.2

