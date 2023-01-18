Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11CC767112A
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 03:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbjARCaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 21:30:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjARCaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 21:30:07 -0500
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [63.216.63.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58AFA48616;
        Tue, 17 Jan 2023 18:30:05 -0800 (PST)
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxhk.zte.com.cn (FangMail) with ESMTPS id 4NxV8r0Rqyz6FK2P;
        Wed, 18 Jan 2023 10:30:04 +0800 (CST)
Received: from szxlzmapp03.zte.com.cn ([10.5.231.207])
        by mse-fl1.zte.com.cn with SMTP id 30I2Tv6c057239;
        Wed, 18 Jan 2023 10:29:57 +0800 (+08)
        (envelope-from yang.yang29@zte.com.cn)
Received: from mapi (szxlzmapp04[null])
        by mapi (Zmail) with MAPI id mid14;
        Wed, 18 Jan 2023 10:29:58 +0800 (CST)
Date:   Wed, 18 Jan 2023 10:29:58 +0800 (CST)
X-Zmail-TransId: 2b0663c759a641c6b2d0
X-Mailer: Zmail v1.0
Message-ID: <202301181029586718612@zte.com.cn>
In-Reply-To: <6fb9fc37203bab5082603caf4b4fbecdd3241541.camel@sipsolutions.net>
References: 202212231056165052797@zte.com.cn,6fb9fc37203bab5082603caf4b4fbecdd3241541.camel@sipsolutions.net
Mime-Version: 1.0
From:   <yang.yang29@zte.com.cn>
To:     <johannes@sipsolutions.net>
Cc:     <stas.yakovlev@gmail.com>, <kvalo@kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <xu.panda@zte.com.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCBuZXQtbmV4dF0gd2lmaTogaXB3MjIwMDogdXNlIHN0cnNjcHkoKSB0byBpbnN0ZWFkIG9mIHN0cm5jcHkoKQ==?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl1.zte.com.cn 30I2Tv6c057239
X-Fangmail-Gw-Spam-Type: 0
X-FangMail-Miltered: at cgslv5.04-192.168.250.138.novalocal with ID 63C759AC.000 by FangMail milter!
X-FangMail-Envelope: 1674009004/4NxV8r0Rqyz6FK2P/63C759AC.000/10.5.228.132/[10.5.228.132]/mse-fl1.zte.com.cn/<yang.yang29@zte.com.cn>
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 63C759AC.000/4NxV8r0Rqyz6FK2P
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        T_SPF_PERMERROR,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> But anyway - why bother ... ancient drivers, clearly OK code.

Thank you, got it, it's useful information. Sorry for to bother and
please ignore this patch.
