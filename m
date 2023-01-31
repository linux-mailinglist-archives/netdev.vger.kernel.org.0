Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA266824E3
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 07:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbjAaGyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 01:54:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjAaGyi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 01:54:38 -0500
Received: from mxct.zte.com.cn (mxct.zte.com.cn [58.251.27.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B322123673;
        Mon, 30 Jan 2023 22:54:35 -0800 (PST)
Received: from mxde.zte.com.cn (unknown [10.35.20.121])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mxct.zte.com.cn (FangMail) with ESMTPS id 4P5bC13zMgzW2d;
        Tue, 31 Jan 2023 14:45:01 +0800 (CST)
Received: from mxus.zte.com.cn (unknown [10.36.20.194])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mxde.zte.com.cn (FangMail) with ESMTPS id 4P5b9V3ShBzBRK7Z;
        Tue, 31 Jan 2023 14:43:42 +0800 (CST)
Received: from mxhk.zte.com.cn (unknown [192.168.250.137])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mxus.zte.com.cn (FangMail) with ESMTPS id 4P5b8v2Wsjz513P9;
        Tue, 31 Jan 2023 14:43:11 +0800 (CST)
Received: from mxct.zte.com.cn (unknown [192.168.251.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mxhk.zte.com.cn (FangMail) with ESMTPS id 4P5b8H5ZN1z8R039;
        Tue, 31 Jan 2023 14:42:39 +0800 (CST)
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxct.zte.com.cn (FangMail) with ESMTPS id 4P5b6K6JXrz501Qw;
        Tue, 31 Jan 2023 14:40:57 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
        by mse-fl1.zte.com.cn with SMTP id 30V6ensk051396;
        Tue, 31 Jan 2023 14:40:49 +0800 (+08)
        (envelope-from ye.xingchen@zte.com.cn)
Received: from mapi (xaxapp01[null])
        by mapi (Zmail) with MAPI id mid31;
        Tue, 31 Jan 2023 14:40:51 +0800 (CST)
Date:   Tue, 31 Jan 2023 14:40:51 +0800 (CST)
X-Zmail-TransId: 2af963d8b7f3ffffffffcd607117
X-Mailer: Zmail v1.0
Message-ID: <202301311440516312161@zte.com.cn>
Mime-Version: 1.0
From:   <ye.xingchen@zte.com.cn>
To:     <ast@kernel.org>
Cc:     <daniel@iogearbox.net>, <davem@davemloft.net>, <kuba@kernel.org>,
        <hawk@kernel.org>, <john.fastabend@gmail.com>, <andrii@kernel.org>,
        <martin.lau@linux.dev>, <song@kernel.org>, <yhs@fb.com>,
        <kpsingh@kernel.org>, <sdf@google.com>, <haoluo@google.com>,
        <jolsa@kernel.org>, <mykolal@fb.com>, <shuah@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIXSBzZWxmdGVzdHMvYnBmOiByZW1vdmUgZHVwbGljYXRlIGluY2x1ZGUgaGVhZGVyIGluIGZpbGVz?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl1.zte.com.cn 30V6ensk051396
X-FangMail-Miltered: at esgde01-2.novalocal with ID 63D8B89D.000 by FangMail milter!
X-FangMail-Envelope: 1675147422/4P5b9V3ShBzBRK7Z/63D8B89D.000/10.36.20.194/[10.36.20.194]/mxus.zte.com.cn/<ye.xingchen@zte.com.cn>
X-Fangmail-Gw-Spam-Type: 0
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 63D8B8EC.000/4P5bC13zMgzW2d
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: ye xingchen <ye.xingchen@zte.com.cn>

linux/net_tstamp.h is included more than once.

Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
---
 tools/testing/selftests/bpf/xdp_hw_metadata.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/xdp_hw_metadata.c b/tools/testing/selftests/bpf/xdp_hw_metadata.c
index 3823b1c499cc..184046021114 100644
--- a/tools/testing/selftests/bpf/xdp_hw_metadata.c
+++ b/tools/testing/selftests/bpf/xdp_hw_metadata.c
@@ -24,7 +24,6 @@
 #include <linux/net_tstamp.h>
 #include <linux/udp.h>
 #include <linux/sockios.h>
-#include <linux/net_tstamp.h>
 #include <sys/mman.h>
 #include <net/if.h>
 #include <poll.h>
-- 
2.25.1
