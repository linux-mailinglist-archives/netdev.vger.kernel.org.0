Return-Path: <netdev+bounces-8501-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EFEF072453B
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 16:05:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1A1541C20B7C
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 14:05:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0997F2DBA6;
	Tue,  6 Jun 2023 14:05:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F285A37B71
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 14:05:23 +0000 (UTC)
Received: from xavier.telenet-ops.be (xavier.telenet-ops.be [IPv6:2a02:1800:120:4::f00:14])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB4D10D1
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 07:05:21 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed30:a3e8:6562:a823:d832])
	by xavier.telenet-ops.be with bizsmtp
	id 5q5K2A0061Tjf1k01q5Krb; Tue, 06 Jun 2023 16:05:19 +0200
Received: from rox.of.borg ([192.168.97.57])
	by ramsan.of.borg with esmtp (Exim 4.95)
	(envelope-from <geert@linux-m68k.org>)
	id 1q6XIw-007sP5-9u;
	Tue, 06 Jun 2023 16:05:19 +0200
Received: from geert by rox.of.borg with local (Exim 4.95)
	(envelope-from <geert@linux-m68k.org>)
	id 1q6XJH-00EiHe-2T;
	Tue, 06 Jun 2023 16:05:19 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Eric Dumazet <edumazet@google.com>,
	"David S . Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH RESEND net-next] tcp: Spelling s/curcuit/circuit/
Date: Tue,  6 Jun 2023 16:05:12 +0200
Message-Id: <41454fc12506c2620d2dbc03e59a4ba28fd48f22.1686045877.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Geert Uytterhoeven <geert+renesas@glider.be>

Fix a misspelling of "circuit".

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 net/ipv4/tcp_input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index bf8b22218dd46863..3403ed457baf781e 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1131,7 +1131,7 @@ static void tcp_count_delivered(struct tcp_sock *tp, u32 delivered,
  * L|R	1		- orig is lost, retransmit is in flight.
  * S|R  1		- orig reached receiver, retrans is still in flight.
  * (L|S|R is logically valid, it could occur when L|R is sacked,
- *  but it is equivalent to plain S and code short-curcuits it to S.
+ *  but it is equivalent to plain S and code short-circuits it to S.
  *  L|S is logically invalid, it would mean -1 packet in flight 8))
  *
  * These 6 states form finite state machine, controlled by the following events:
-- 
2.34.1


