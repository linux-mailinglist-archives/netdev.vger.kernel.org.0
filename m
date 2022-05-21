Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA3352FA5A
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 11:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242124AbiEUJhi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 05:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238242AbiEUJhh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 05:37:37 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [46.235.227.227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 980A5A7E3D;
        Sat, 21 May 2022 02:37:36 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: usama.anjum)
        with ESMTPSA id CDF301F41DE4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1653125855;
        bh=GBarC/KmBBn1x+zZIBSt3K7iXAx+oRve73M9dZOIV+g=;
        h=From:To:Cc:Subject:Date:From;
        b=KKNoPqiYwDba5yjKLaY/6heeSlCR0pdjyBk8Uxxs6xcoIIWkynT+Z83A3a1cxT6qn
         IUz+25BuBQ5bttL0KEd+u1K91MEwmtw4+A4jiOZO9DGG3LtzY/e2ygbggN42RsDJKm
         1hBJS2WRQdyjFUCExmoXBrY9w+Nh+8Tz6181YDYXvNclETVYUD/3vROsA7oqG/cyg3
         RFyUFtorhSAyeAkQuGHOPczWPBuiPaPwAYe/4JU8hHvYUjO3/2NYsZVUu/5pJRkqQW
         AA6txrqb+/wvtm3CWG4oBlL+YIegtOna7TulO5um3a2UkNF295CcoNrzHob/iNhQ3K
         SORp45W/tUO8g==
From:   Muhammad Usama Anjum <usama.anjum@collabora.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     Muhammad Usama Anjum <usama.anjum@collabora.com>,
        kernel@collabora.com, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: selftests: Add stress_reuseport_listen to .gitignore
Date:   Sat, 21 May 2022 14:37:06 +0500
Message-Id: <20220521093706.157595-1-usama.anjum@collabora.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add newly added stress_reuseport_listen object to .gitignore file.

Fixes: ec8cb4f617a2 ("net: selftests: Stress reuseport listen")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
---
 tools/testing/selftests/net/.gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
index 21a411b048900..a29f796189347 100644
--- a/tools/testing/selftests/net/.gitignore
+++ b/tools/testing/selftests/net/.gitignore
@@ -5,6 +5,7 @@ socket
 psock_fanout
 psock_snd
 psock_tpacket
+stress_reuseport_listen
 reuseport_addr_any
 reuseport_bpf
 reuseport_bpf_cpu
-- 
2.30.2

