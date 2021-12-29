Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F27484810A9
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 08:28:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239115AbhL2H2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 02:28:04 -0500
Received: from m12-16.163.com ([220.181.12.16]:44425 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239095AbhL2H2D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Dec 2021 02:28:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Message-ID:Date:MIME-Version:From:Subject; bh=yApBQ
        ejXLUlZRFU2jIalUtw1JYozO3kZcFyEnE66wT0=; b=Jdj/almZM9izv9ZSRQHYY
        Wu2lchUP45o+5PDlRkcU5ucZKWLzVecDXuPkDAqWNGDBBOF2BPpDmc/iiYIqIWlM
        Cy4bKagi4alJCSEoQzPjAzuWlY+B71+DdspWzlUO427j0F6JdlQa2HbPHdw0JBJQ
        GsLD2mrd5JvPJIwyiaxZWw=
Received: from [192.168.16.193] (unknown [110.86.5.92])
        by smtp12 (Coremail) with SMTP id EMCowAA3PpLiDcxhgfptDw--.67S2;
        Wed, 29 Dec 2021 15:27:39 +0800 (CST)
Message-ID: <d247d7c8-a03a-0abf-3c71-4006a051d133@163.com>
Date:   Wed, 29 Dec 2021 15:27:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>
From:   Jianguo Wu <wujianguo106@163.com>
Subject: [PATCH] selftests: net: Fix a typo in udpgro_fwd.sh
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: EMCowAA3PpLiDcxhgfptDw--.67S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtw47GF13Jw47Wr18Xw1rtFb_yoWfGrbEgF
        srKr4kWrs8AFW2vF17Jwn8ur4F9a15Cr4fJw45Xw1ak34UAa15WF1vyr4UAF4Fg3y5t342
        vFsYyFyYyr40vjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU8Hmh5UUUUU==
X-Originating-IP: [110.86.5.92]
X-CM-SenderInfo: 5zxmxt5qjx0iiqw6il2tof0z/1tbiRAt4kFSIjoUZvgAAsX
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianguo Wu <wujianguo@chinatelecom.cn>

Fixes: a062260a9d5f ("selftests: net: add UDP GRO forwarding self-tests")
Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
---
 tools/testing/selftests/net/udpgro_fwd.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/udpgro_fwd.sh b/tools/testing/selftests/net/udpgro_fwd.sh
index 7f26591f236b..6a3985b8cd7f 100755
--- a/tools/testing/selftests/net/udpgro_fwd.sh
+++ b/tools/testing/selftests/net/udpgro_fwd.sh
@@ -132,7 +132,7 @@ run_test() {
 	local rcv=`ip netns exec $NS_DST $ipt"-save" -c | grep 'dport 8000' | \
 							  sed -e 's/\[//' -e 's/:.*//'`
 	if [ $rcv != $pkts ]; then
-		echo " fail - received $rvs packets, expected $pkts"
+		echo " fail - received $rcv packets, expected $pkts"
 		ret=1
 		return
 	fi
-- 
1.8.3.1

