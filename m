Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B000671115
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 03:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbjARCW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 21:22:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjARCWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 21:22:25 -0500
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [63.216.63.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98E83521E8;
        Tue, 17 Jan 2023 18:22:23 -0800 (PST)
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxhk.zte.com.cn (FangMail) with ESMTPS id 4NxTzx6TQ9z8RTZH;
        Wed, 18 Jan 2023 10:22:21 +0800 (CST)
Received: from szxlzmapp04.zte.com.cn ([10.5.231.166])
        by mse-fl1.zte.com.cn with SMTP id 30I2MIW2051571;
        Wed, 18 Jan 2023 10:22:18 +0800 (+08)
        (envelope-from yang.yang29@zte.com.cn)
Received: from mapi (szxlzmapp04[null])
        by mapi (Zmail) with MAPI id mid14;
        Wed, 18 Jan 2023 10:22:19 +0800 (CST)
Date:   Wed, 18 Jan 2023 10:22:19 +0800 (CST)
X-Zmail-TransId: 2b0663c757dbffffffffeeb53db7
X-Mailer: Zmail v1.0
Message-ID: <202301181022195938376@zte.com.cn>
In-Reply-To: <a81cb8cd088e715936895ec6bb07cfdc8fec37c1.camel@sipsolutions.net>
References: 202212231052044562664@zte.com.cn,a81cb8cd088e715936895ec6bb07cfdc8fec37c1.camel@sipsolutions.net
Mime-Version: 1.0
From:   <yang.yang29@zte.com.cn>
To:     <johannes@sipsolutions.net>
Cc:     <kvalo@kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>,
        <akpm@linux-foundation.org>, <songmuchun@bytedance.com>,
        <brauner@kernel.org>, <julia.lawall@inria.fr>,
        <gustavoars@kernel.org>, <jason@zx2c4.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <xu.panda@zte.com.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCBuZXQtbmV4dF0gd2lmaTogYWlybzogdXNlIHN0cnNjcHkoKSB0byBpbnN0ZWFkIG9mIHN0cm5jcHkoKQ==?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl1.zte.com.cn 30I2MIW2051571
X-Fangmail-Gw-Spam-Type: 0
X-FangMail-Miltered: at cgslv5.04-192.168.250.137.novalocal with ID 63C757DD.000 by FangMail milter!
X-FangMail-Envelope: 1674008541/4NxTzx6TQ9z8RTZH/63C757DD.000/10.5.228.132/[10.5.228.132]/mse-fl1.zte.com.cn/<yang.yang29@zte.com.cn>
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 63C757DD.000/4NxTzx6TQ9z8RTZH
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,T_SPF_PERMERROR,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Again, why bother. But is this even correct/identical behaviour?>>
> Wouldn't it potentially read 17 input bytes before forcing NUL-
> termination?

Thank you for your reminder. This is a terrible error. Strscpy() may
cause the array to be out of bounds. I should be more cautious
next time.

Xu and Yang
