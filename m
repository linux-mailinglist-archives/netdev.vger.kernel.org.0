Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9204310BC
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 08:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbhJRGoP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 02:44:15 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:39576 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230114AbhJRGoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 02:44:15 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R711e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0UsVRLbn_1634539321;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0UsVRLbn_1634539321)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 18 Oct 2021 14:42:02 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hangbin Liu <liuhangbin@gmail.com>,
        kernel test robot <oliver.sang@intel.com>,
        Philip Li <philip.li@intel.com>
Cc:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: [PATCH] selftests/tls: add SM4 algorithm dependency for tls selftests
Date:   Mon, 18 Oct 2021 14:42:01 +0800
Message-Id: <20211018064201.75308-1-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.3.ge56e4f7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kernel TLS test has added SM4 GCM/CCM algorithm support, but SM4
algorithm is not compiled by default, this patch add SM4 config
dependency.

Reported-by: Hangbin Liu <liuhangbin@gmail.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
---
 tools/testing/selftests/net/config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
index 21b646d10b88..86ab429fe7f3 100644
--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@ -43,3 +43,4 @@ CONFIG_NET_ACT_TUNNEL_KEY=m
 CONFIG_NET_ACT_MIRRED=m
 CONFIG_BAREUDP=m
 CONFIG_IPV6_IOAM6_LWTUNNEL=y
+CONFIG_CRYPTO_SM4=y
-- 
2.19.1.3.ge56e4f7

