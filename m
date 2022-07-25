Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D45457F81D
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 04:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232755AbiGYCBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 22:01:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiGYCBu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 22:01:50 -0400
Received: from mail-m971.mail.163.com (mail-m971.mail.163.com [123.126.97.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 81A2CDAC;
        Sun, 24 Jul 2022 19:01:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=wt9S6
        Qf8Z2rE/2NJrQ1f776rMFQZnMDyAMvGq/52fCI=; b=AGvbX8r+wkHxk1PtbxVyl
        MdNlKtRdpUrrWWR2+FfaX91aDM6JkhJhw5f9VSCjmKdTZB9ifb7YvUpQAkEbSd23
        DBYWTLn8Iy8a01Iqg6sjsxWMjLPqkuGXlGqD3PNGgzPOnvpuERM7EldYid6oHAaP
        jlf8cNWR6OnDlhg0vLrUT8=
Received: from localhost.localdomain (unknown [112.97.48.126])
        by smtp1 (Coremail) with SMTP id GdxpCgAnOnV3+d1i4TNOQQ--.98S2;
        Mon, 25 Jul 2022 10:01:30 +0800 (CST)
From:   Slark Xiao <slark_xiao@163.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, shuah@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Slark Xiao <slark_xiao@163.com>
Subject: [PATCH] selftests: net: Fix typo 'the the' in comment
Date:   Mon, 25 Jul 2022 10:01:24 +0800
Message-Id: <20220725020124.5760-1-slark_xiao@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: GdxpCgAnOnV3+d1i4TNOQQ--.98S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZFykWry8KFy3Zr1xWFyUZFb_yoWfJFbEqw
        4vqF97AFs0yF1UtF45uFWrCw18Cw4UuFWkAF47XasIqryYva15uF1kuFWUJF95WrZ0qrZ2
        gFsYvF13Ca1qqjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRPsgYJUUUUU==
X-Originating-IP: [112.97.48.126]
X-CM-SenderInfo: xvod2y5b0lt0i6rwjhhfrp/xtbBDRpJZFaEKDwsyAAAsY
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
 tools/testing/selftests/net/forwarding/vxlan_asymmetric.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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

