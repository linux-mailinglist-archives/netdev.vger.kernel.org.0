Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70601646657
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 02:13:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbiLHBNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 20:13:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbiLHBMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 20:12:51 -0500
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [63.216.63.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E968DFC9;
        Wed,  7 Dec 2022 17:12:11 -0800 (PST)
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxhk.zte.com.cn (FangMail) with ESMTPS id 4NSGMs1fJpz8RV7D;
        Thu,  8 Dec 2022 09:12:09 +0800 (CST)
Received: from szxlzmapp03.zte.com.cn ([10.5.231.207])
        by mse-fl2.zte.com.cn with SMTP id 2B81C5iX008747;
        Thu, 8 Dec 2022 09:12:05 +0800 (+08)
        (envelope-from yang.yang29@zte.com.cn)
Received: from mapi (szxlzmapp02[null])
        by mapi (Zmail) with MAPI id mid14;
        Thu, 8 Dec 2022 09:12:06 +0800 (CST)
Date:   Thu, 8 Dec 2022 09:12:06 +0800 (CST)
X-Zmail-TransId: 2b04639139e6ffffffffe9ffab4d
X-Mailer: Zmail v1.0
Message-ID: <202212080912066313234@zte.com.cn>
In-Reply-To: <20221207153256.6c0ec51a@kernel.org>
References: CANn89iKqb64sLT2r+2YrpDyMfZ8T6z2Ygtby-ruVNNYvniaV0g@mail.gmail.com,20221207153256.6c0ec51a@kernel.org
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
X-MAIL: mse-fl2.zte.com.cn 2B81C5iX008747
X-Fangmail-Gw-Spam-Type: 0
X-FangMail-Miltered: at cgslv5.04-192.168.250.137.novalocal with ID 639139E9.000 by FangMail milter!
X-FangMail-Envelope: 1670461929/4NSGMs1fJpz8RV7D/639139E9.000/10.5.228.133/[10.5.228.133]/mse-fl2.zte.com.cn/<yang.yang29@zte.com.cn>
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 639139E9.000/4NSGMs1fJpz8RV7D
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> In my experience - no this is not useful.

Received, thanks!

> Sorry if this is too direct, but it seems to me like you're trying hard
> to find something useful to do in this area without a clear use case. 
I see maybe this is a too special scenes, not suitable. The motivation
is we see lots of time_squeeze on our working machines, and want to
tuning, but our kernel are not ready to use threaded NAPI. And we
did see performance difference on different netdev_budget* in
preliminary tests.

> We have coding tasks which would definitely be useful and which nobody
> has time to accomplish. Please ask if you're trying to find something
> to do.

We focus on 5G telecom machine, which has huge TIPC packets in the
intranet. If it's related, we are glad to do it with much appreciate of your
indicate!

Thanks.
