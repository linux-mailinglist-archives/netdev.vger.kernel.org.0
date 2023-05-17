Return-Path: <netdev+bounces-3146-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 580D3705C92
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 03:43:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F2EC41C20CE4
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 01:42:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0E1217CF;
	Wed, 17 May 2023 01:42:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2797A17C8
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 01:42:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67426C433D2;
	Wed, 17 May 2023 01:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684287777;
	bh=qPchDZ4JltCfg8LHTV0e81Ry4562N+CnZS1hc8Fw2OA=;
	h=From:To:Cc:Subject:Date:From;
	b=rN7SdlpPpgGhcpn67Dcl1fcZ8EpDEpM8Do7gmj4gu4r6+3H6eNrD/lAaDxM0f+sjk
	 8Sp5xGQY9T6urMKFmtCTk42mMNBR7jO7W4IC7cHrJ3gIZ/AYtiJqgb/F6XYiOSMFM0
	 fVKDYQ5OLhq6DMxC9HkY4TYYW94UKIF8OyacDnVKyFm5g3qiCUp/l5lFSdvHq//ynp
	 9MHhrRuaiURhg1s1EvuO6yfwrnxaKqVP/vp+ci9cVgUmdsi/M1oB6z8P7Vg5iBExJP
	 3uCJ/F5nN3DXyeU38ZGWN7XLBVphUru14/RCxAPA0G3yPcgyedf53wnyl3IJYgboyY
	 iPPA2hprE4Eww==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	Jakub Kicinski <kuba@kernel.org>,
	marcel@holtmann.org,
	johan.hedberg@gmail.com,
	luiz.dentz@gmail.com,
	linux-bluetooth@vger.kernel.org
Subject: [PATCH net] MAINTAINERS: skip CCing netdev for Bluetooth patches
Date: Tue, 16 May 2023 18:42:53 -0700
Message-Id: <20230517014253.1233333-1-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As requested by Marcel skip netdev for Bluetooth patches.
Bluetooth has its own mailing list and overloading netdev
leads to fewer people reading it.

Link: https://lore.kernel.org/netdev/639C8EA4-1F6E-42BE-8F04-E4A753A6EFFC@holtmann.org/
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: marcel@holtmann.org
CC: johan.hedberg@gmail.com
CC: luiz.dentz@gmail.com
CC: linux-bluetooth@vger.kernel.org
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4a62fc5c6551..112bde4d6d26 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14638,6 +14638,7 @@ F:	include/uapi/linux/netdevice.h
 F:	lib/net_utils.c
 F:	lib/random32.c
 F:	net/
+X:	net/bluetooth/
 F:	tools/net/
 F:	tools/testing/selftests/net/
 
-- 
2.40.1


