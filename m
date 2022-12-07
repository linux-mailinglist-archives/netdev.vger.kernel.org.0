Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 772CF645555
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 09:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiLGIRn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 03:17:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiLGIRm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 03:17:42 -0500
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C41E31109;
        Wed,  7 Dec 2022 00:17:40 -0800 (PST)
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxct.zte.com.cn (FangMail) with ESMTPS id 4NRqsH1cMkz4y0tx;
        Wed,  7 Dec 2022 16:17:39 +0800 (CST)
Received: from szxlzmapp04.zte.com.cn ([10.5.231.166])
        by mse-fl1.zte.com.cn with SMTP id 2B78HT1m009821;
        Wed, 7 Dec 2022 16:17:29 +0800 (+08)
        (envelope-from yang.yang29@zte.com.cn)
Received: from mapi (szxlzmapp02[null])
        by mapi (Zmail) with MAPI id mid14;
        Wed, 7 Dec 2022 16:17:32 +0800 (CST)
Date:   Wed, 7 Dec 2022 16:17:32 +0800 (CST)
X-Zmail-TransId: 2b0463904c1cffffffffd7c1400c
X-Mailer: Zmail v1.0
Message-ID: <202212071617323068233@zte.com.cn>
In-Reply-To: <CANn89iKqb64sLT2r+2YrpDyMfZ8T6z2Ygtby-ruVNNYvniaV0g@mail.gmail.com>
References: 20221205184742.0952fc75@kernel.org,202212071527223155626@zte.com.cn,CANn89iKqb64sLT2r+2YrpDyMfZ8T6z2Ygtby-ruVNNYvniaV0g@mail.gmail.com
Mime-Version: 1.0
From:   <yang.yang29@zte.com.cn>
To:     <edumazet@google.com>
Cc:     <kuba@kernel.org>, <davem@davemloft.net>, <pabeni@redhat.com>,
        <bigeasy@linutronix.de>, <imagedong@tencent.com>,
        <kuniyu@amazon.com>, <petrm@nvidia.com>, <liu3101@purdue.edu>,
        <wujianguo@chinatelecom.cn>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <tedheadster@gmail.com>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCBsaW51eC1uZXh0XSBuZXQ6IHJlY29yZCB0aW1lcyBvZiBuZXRkZXZfYnVkZ2V0IGV4aGF1c3RlZA==?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl1.zte.com.cn 2B78HT1m009821
X-Fangmail-Gw-Spam-Type: 0
X-FangMail-Miltered: at cgslv5.04-192.168.251.13.novalocal with ID 63904C23.000 by FangMail milter!
X-FangMail-Envelope: 1670401059/4NRqsH1cMkz4y0tx/63904C23.000/10.5.228.132/[10.5.228.132]/mse-fl1.zte.com.cn/<yang.yang29@zte.com.cn>
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 63904C23.000/4NRqsH1cMkz4y0tx
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Sure, but netdev_budget set to 1 is extreme, don't you think ???

Yes of course, that is just a test to show the difference.

> We prefer not changing /proc file format as much as we can, they are
> deprecated/legacy.

Should we add some explain of the deprecation in code or doc?
As it's deprecated, I think it's NAK for this patch.

> Presumably, modern tracing techniques can let you do what you want
> without adding new counters.

Totally agree.
