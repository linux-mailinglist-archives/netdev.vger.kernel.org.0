Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18D20643CC2
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 06:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231906AbiLFFsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 00:48:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiLFFsY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 00:48:24 -0500
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C12A13F64;
        Mon,  5 Dec 2022 21:48:22 -0800 (PST)
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxct.zte.com.cn (FangMail) with ESMTPS id 4NR8bR6Djjz4y3ZX;
        Tue,  6 Dec 2022 13:48:19 +0800 (CST)
Received: from szxlzmapp03.zte.com.cn ([10.5.231.207])
        by mse-fl1.zte.com.cn with SMTP id 2B65mAjr099460;
        Tue, 6 Dec 2022 13:48:10 +0800 (+08)
        (envelope-from yang.yang29@zte.com.cn)
Received: from mapi (szxlzmapp02[null])
        by mapi (Zmail) with MAPI id mid14;
        Tue, 6 Dec 2022 13:48:12 +0800 (CST)
Date:   Tue, 6 Dec 2022 13:48:12 +0800 (CST)
X-Zmail-TransId: 2b04638ed79c441a7331
X-Mailer: Zmail v1.0
Message-ID: <202212061348121276979@zte.com.cn>
In-Reply-To: <CANn89iK4Cn-+BgJEuGSWF=PTfDPWuCy8ci75664+98ajt_+3Xw@mail.gmail.com>
References: 202212050936120314474@zte.com.cn,20221205175354.3949c6bb@kernel.org,CANn89iK4Cn-+BgJEuGSWF=PTfDPWuCy8ci75664+98ajt_+3Xw@mail.gmail.com
Mime-Version: 1.0
From:   <yang.yang29@zte.com.cn>
To:     <edumazet@google.com>
Cc:     <kuba@kernel.org>, <davem@davemloft.net>, <pabeni@redhat.com>,
        <bigeasy@linutronix.de>, <imagedong@tencent.com>,
        <kuniyu@amazon.com>, <petrm@nvidia.com>, <liu3101@purdue.edu>,
        <wujianguo@chinatelecom.cn>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCBsaW51eC1uZXh0IHYyXSBuZXQ6IHJlY29yZCB0aW1lcyBvZiBuZXRkZXZfYnVkZ2V0IGV4aGF1c3RlZA==?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl1.zte.com.cn 2B65mAjr099460
X-Fangmail-Gw-Spam-Type: 0
X-FangMail-Miltered: at cgslv5.04-192.168.251.13.novalocal with ID 638ED7A3.000 by FangMail milter!
X-FangMail-Envelope: 1670305699/4NR8bR6Djjz4y3ZX/638ED7A3.000/10.5.228.132/[10.5.228.132]/mse-fl1.zte.com.cn/<yang.yang29@zte.com.cn>
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 638ED7A3.000/4NR8bR6Djjz4y3ZX
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 6, 2022 at 11:18 AM Eric Dumazet <edumazet@google.com,> wrote:
> Yes, and if we really want to track all these kinds of events the
> break caused by need_resched() in do_softirq would
> also need some monitoring.

I think this situation is a bit different. The break caused by
need_resched() in __do_softirq() is some kind of internal
events, kernel hacker may track it by something like tracepoint.

But netdev_budget* are sysctl for administrator, when
administrator adjust them, they may want to see the
effect in a direct or easy way.
