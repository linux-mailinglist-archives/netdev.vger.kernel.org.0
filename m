Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E513E646697
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 02:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbiLHBmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 20:42:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbiLHBmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 20:42:09 -0500
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [63.216.63.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D654E695;
        Wed,  7 Dec 2022 17:42:08 -0800 (PST)
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxhk.zte.com.cn (FangMail) with ESMTPS id 4NSH2R01gNz4xVnd;
        Thu,  8 Dec 2022 09:42:07 +0800 (CST)
Received: from szxlzmapp05.zte.com.cn ([10.5.230.85])
        by mse-fl1.zte.com.cn with SMTP id 2B81g0Rk085065;
        Thu, 8 Dec 2022 09:42:00 +0800 (+08)
        (envelope-from yang.yang29@zte.com.cn)
Received: from mapi (szxlzmapp02[null])
        by mapi (Zmail) with MAPI id mid14;
        Thu, 8 Dec 2022 09:42:01 +0800 (CST)
Date:   Thu, 8 Dec 2022 09:42:01 +0800 (CST)
X-Zmail-TransId: 2b04639140e939a55fed
X-Mailer: Zmail v1.0
Message-ID: <202212080942014374852@zte.com.cn>
In-Reply-To: <20221207172321.7da162c7@kernel.org>
References: 20221207153256.6c0ec51a@kernel.org,20221207172321.7da162c7@kernel.org
Mime-Version: 1.0
From:   <yang.yang29@zte.com.cn>
To:     <kuba@kernel.org>
Cc:     <edumazet@google.com>, <davem@davemloft.net>, <pabeni@redhat.com>,
        <bigeasy@linutronix.de>, <imagedong@tencent.com>,
        <kuniyu@amazon.com>, <petrm@nvidia.com>, <liu3101@purdue.edu>,
        <wujianguo@chinatelecom.cn>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <tedheadster@gmail.com>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCBsaW51eC1uZXh0XSBuZXQ6IHJlY29yZCB0aW1lcyBvZiBuZXRkZXZfYnVkZ2V0IGV4aGF1c3RlZA==?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl1.zte.com.cn 2B81g0Rk085065
X-Fangmail-Gw-Spam-Type: 0
X-FangMail-Miltered: at cgslv5.04-192.168.250.138.novalocal with ID 639140EE.001 by FangMail milter!
X-FangMail-Envelope: 1670463727/4NSH2R01gNz4xVnd/639140EE.001/10.5.228.132/[10.5.228.132]/mse-fl1.zte.com.cn/<yang.yang29@zte.com.cn>
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 639140EE.001/4NSH2R01gNz4xVnd
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> ime_squeeze is a terrible metric, if you can find a direct metric
> in terms of application latency or max PPS, that's much more valuable.

Actually we are working on measure the latency of packets between
inqueue and dequeue in eBPF way, we add new tracepoint to help
do that. And we are also consider using PSI to measure it. 

We will submit patches when it's ready, thanks!
