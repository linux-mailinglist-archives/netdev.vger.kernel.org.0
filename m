Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE7657E02E
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 12:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234494AbiGVKon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 06:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233186AbiGVKom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 06:44:42 -0400
Received: from mail-m971.mail.163.com (mail-m971.mail.163.com [123.126.97.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C0FC9BB5C4;
        Fri, 22 Jul 2022 03:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=Gychz
        J0iPpXunmsp/gWRd2qFA9Qg4Kvr1bpS0rgmKxU=; b=iogwW+rtcIOZjYwa2ViFh
        pgqXrJjcTtia0/uAiai40DvxEIfUj+FaR788kGfjQ5MFbUFrQGW+UUumP6/g0Q08
        xBAPrslrO6ms7hzeeEFeVrfUytvuizz4wroGItHm7lwr+yNVHg/lHD27VgdfChzY
        VZXrXMnppNdy00J07Kvg2Y=
Received: from localhost.localdomain (unknown [112.97.59.29])
        by smtp1 (Coremail) with SMTP id GdxpCgDX3580f9piU1cyPw--.23671S2;
        Fri, 22 Jul 2022 18:43:03 +0800 (CST)
From:   Slark Xiao <slark_xiao@163.com>
To:     tglx@linutronix.de, mingo@redhat.com, shuah@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, peterz@infradead.org, dvhart@infradead.org,
        dave@stgolabs.net, andrealmeid@igalia.com
Cc:     linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, Slark Xiao <slark_xiao@163.com>
Subject: [PATCH] selftests: Fix typo 'the the' in comment
Date:   Fri, 22 Jul 2022 18:42:59 +0800
Message-Id: <20220722104259.83599-1-slark_xiao@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: GdxpCgDX3580f9piU1cyPw--.23671S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7uF4rZry3Ww13tw4xuryDZFb_yoW8Ww15p3
        y8tr1YkFy0q3W7Ww18Gan3ZF48GF4kJFWxGr1fXryfZ3y5Xas3XFnrKF17JF1agrWkZw1r
        A3y2gryjvFs7ZaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pEEoGwUUUUU=
X-Originating-IP: [112.97.59.29]
X-CM-SenderInfo: xvod2y5b0lt0i6rwjhhfrp/1tbiJRdGZGAJpKgZ6wAAsH
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace 'the the' with 'the' in the comment.

Signed-off-by: Slark Xiao <slark_xiao@163.com>
---
 .../futex/functional/futex_requeue_pi_signal_restart.c          | 2 +-
 tools/testing/selftests/net/forwarding/vxlan_asymmetric.sh      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/futex/functional/futex_requeue_pi_signal_restart.c b/tools/testing/selftests/futex/functional/futex_requeue_pi_signal_restart.c
index f8c43ce8fe66..c6b8f32990c8 100644
--- a/tools/testing/selftests/futex/functional/futex_requeue_pi_signal_restart.c
+++ b/tools/testing/selftests/futex/functional/futex_requeue_pi_signal_restart.c
@@ -184,7 +184,7 @@ int main(int argc, char *argv[])
 		/*
 		 * If res is non-zero, we either requeued the waiter or hit an
 		 * error, break out and handle it. If it is zero, then the
-		 * signal may have hit before the the waiter was blocked on f1.
+		 * signal may have hit before the waiter was blocked on f1.
 		 * Try again.
 		 */
 		if (res > 0) {
diff --git a/tools/testing/selftests/net/forwarding/vxlan_asymmetric.sh b/tools/testing/selftests/net/forwarding/vxlan_asymmetric.sh
index 0727e2012b68..43469c7de118 100755
--- a/tools/testing/selftests/net/forwarding/vxlan_asymmetric.sh
+++ b/tools/testing/selftests/net/forwarding/vxlan_asymmetric.sh
@@ -525,7 +525,7 @@ arp_suppression()
 
 	log_test "neigh_suppress: on / neigh exists: yes"
 
-	# Delete the neighbour from the the SVI. A single ARP request should be
+	# Delete the neighbour from the SVI. A single ARP request should be
 	# received by the remote VTEP
 	RET=0
 
-- 
2.25.1

