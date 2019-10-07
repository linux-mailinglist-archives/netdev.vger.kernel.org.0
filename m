Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCF06CDDB7
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 10:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727365AbfJGIvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 04:51:16 -0400
Received: from ivanoab7.miniserver.com ([37.128.132.42]:33366 "EHLO
        www.kot-begemot.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727305AbfJGIvQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 04:51:16 -0400
X-Greylist: delayed 1466 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Oct 2019 04:51:15 EDT
Received: from tun252.jain.kot-begemot.co.uk ([192.168.18.6] helo=jain.kot-begemot.co.uk)
        by www.kot-begemot.co.uk with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <anton.ivanov@cambridgegreys.com>)
        id 1iHOLp-0007In-Eo; Mon, 07 Oct 2019 08:26:41 +0000
Received: from jain.kot-begemot.co.uk ([192.168.3.3])
        by jain.kot-begemot.co.uk with esmtp (Exim 4.92)
        (envelope-from <anton.ivanov@cambridgegreys.com>)
        id 1iHOLm-0003pm-In; Mon, 07 Oct 2019 09:26:40 +0100
From:   Anton Ivanov <anton.ivanov@cambridgegreys.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com, yhs@fb.com,
        netdev@vger.kernel.org,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>
Subject: [PATCH] samples: Trivial - fix spelling mistake in usage
Date:   Mon,  7 Oct 2019 09:26:36 +0100
Message-Id: <20191007082636.14686-1-anton.ivanov@cambridgegreys.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -1.0
X-Spam-Score: -1.0
X-Clacks-Overhead: GNU Terry Pratchett
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Anton Ivanov <anton.ivanov@cambridgegreys.com>
---
 samples/bpf/xdpsock_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index d08ee1ab7bb4..eb78159376eb 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -361,7 +361,7 @@ static void usage(const char *prog)
 		"  -q, --queue=n	Use queue n (default 0)\n"
 		"  -p, --poll		Use poll syscall\n"
 		"  -S, --xdp-skb=n	Use XDP skb-mod\n"
-		"  -N, --xdp-native=n	Enfore XDP native mode\n"
+		"  -N, --xdp-native=n	Enforce XDP native mode\n"
 		"  -n, --interval=n	Specify statistics update interval (default 1 sec).\n"
 		"  -z, --zero-copy      Force zero-copy mode.\n"
 		"  -c, --copy           Force copy mode.\n"
-- 
2.20.1

