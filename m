Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06C94630AE1
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 03:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbiKSCzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 21:55:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiKSCzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 21:55:21 -0500
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 68286950CC;
        Fri, 18 Nov 2022 18:55:18 -0800 (PST)
Received: from loongson.cn (unknown [113.200.148.30])
        by gateway (Coremail) with SMTP id _____8BxXbeVRXhjfMoIAA--.15473S3;
        Sat, 19 Nov 2022 10:55:17 +0800 (CST)
Received: from linux.localdomain (unknown [113.200.148.30])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8AxPuCTRXhjEsQWAA--.60010S2;
        Sat, 19 Nov 2022 10:55:15 +0800 (CST)
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] samples: pktgen: Use "grep -E" instead of "egrep"
Date:   Sat, 19 Nov 2022 10:55:04 +0800
Message-Id: <1668826504-32162-1-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
X-CM-TRANSID: AQAAf8AxPuCTRXhjEsQWAA--.60010S2
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
X-Coremail-Antispam: 1Uk129KBjvdXoWruFWrur1kGFy3Gr1fGF4kJFb_yoWkZwc_Gr
        yfX3Z8J3yUXr1akr4UCayvyF4vk3srGFWrGrWFgrn8Ca4ay3y3AFZxGFyUC3W5Ww47uFWa
        9a1kXw1rCw17tjkaLaAFLSUrUUUU1b8apTn2vfkv8UJUUUU8wcxFpf9Il3svdxBIdaVrn0
        xqx4xG64xvF2IEw4CE5I8CrVC2j2Jv73VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUY
        q7kC6x804xWl14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3w
        AFIxvE14AKwVWUXVWUAwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK
        6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r1j6r4UM28EF7
        xvwVC2z280aVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVCY1x0267AKxVW8JVW8Jr1ln4kS
        14v26r1Y6r17M2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
        1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv
        67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2
        Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_Jrv_JF1lx2IqxVAq
        x4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r
        1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF
        7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxV
        W8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU
        4s2-UUUUU
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The latest version of grep claims the egrep is now obsolete so the build
now contains warnings that look like:
	egrep: warning: egrep is obsolescent; using grep -E
fix this up by moving the related file to use "grep -E" instead.

  sed -i "s/egrep/grep -E/g" `grep egrep -rwl samples/pktgen`

Here are the steps to install the latest grep:

  wget http://ftp.gnu.org/gnu/grep/grep-3.8.tar.gz
  tar xf grep-3.8.tar.gz
  cd grep-3.8 && ./configure && make
  sudo make install
  export PATH=/usr/local/bin:$PATH

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
---
 samples/pktgen/functions.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/pktgen/functions.sh b/samples/pktgen/functions.sh
index 9331942..dd4e53a 100644
--- a/samples/pktgen/functions.sh
+++ b/samples/pktgen/functions.sh
@@ -191,7 +191,7 @@ function extend_addr6()
     fi
 
     # if shrink '::' occurs multiple, it's malformed.
-    shrink=( $(egrep -o "$sep{2,}" <<< $addr) )
+    shrink=( $(grep -E -o "$sep{2,}" <<< $addr) )
     if [[ ${#shrink[@]} -ne 0 ]]; then
         if [[ ${#shrink[@]} -gt 1 || ( ${shrink[0]} != $sep2 ) ]]; then
             err 5 "Invalid IP6 address: $1"
-- 
2.1.0

