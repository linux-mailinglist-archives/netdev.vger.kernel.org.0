Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15BE66651EB
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 03:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbjAKCf3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 10 Jan 2023 21:35:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235651AbjAKCe6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 21:34:58 -0500
Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B529360DC
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 18:34:24 -0800 (PST)
X-QQ-mid: bizesmtp74t1673404428t33f83ck
Received: from smtpclient.apple ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 11 Jan 2023 10:33:47 +0800 (CST)
X-QQ-SSF: 00400000000000M0N000000A0000000
X-QQ-FEAT: QityeSR92A3QjcraU8bmwYT+RX2FDb7CEAvXrePu3sghUdjXbsH6kPqbqgTe7
        pAIpWUSYdWcTl1HWORC2gKBuMURa4Miq+K8yfLmSY2Igh7kFkZYPMfQibbvwjoyYLgub6qk
        WOlDodg9lDVLsMxOGJ2/8BZPBTCGemnq8stqKtO0aiXzT1tSy3QJnEGmEul0MJ7lwiKHPdH
        7mXaD8klgQM7zri3mZZma5KbIR4P+FjKwEiM1+cOIVVCwOa5wscucIM4ZumYkkOHeeTpYxb
        fgz+W8PTGc6mZ/1UkpZQwyuFAcIusBe1dyI78hSGd7cu3ltVHjf1mtt+fEkeiG6Jr6AeU5A
        KmOhUjc/n+w708KXISbtMkl1o3LwVSMKnW0Fx5ubUE6psbLKWKNdt8JIc1U1ejpyXwD3hMB
X-QQ-GoodBg: 2
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.300.51\))
Subject: Re: [PATCH net-next v7] net: ngbe: Add ngbe mdio bus driver.
From:   "mengyuanlou@net-swift.com" <mengyuanlou@net-swift.com>
In-Reply-To: <Y74euxqQUpXR6OGZ@lunn.ch>
Date:   Wed, 11 Jan 2023 10:33:36 +0800
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Jiawen Wu <jiawenwu@trustnetic.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <1DCC7B2D-467D-4756-B2C5-6C57A3ABB673@net-swift.com>
References: <20230109153508.37084-1-mengyuanlou@net-swift.com>
 <Y7xFiNoTS6FdQa97@lunn.ch> <20230110181907.5e4abbcd@kernel.org>
 <Y74euxqQUpXR6OGZ@lunn.ch>
To:     Andrew Lunn <andrew@lunn.ch>
X-Mailer: Apple Mail (2.3731.300.51)
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvr:qybglogicsvr1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks。
I will spilt them.

> 2023年1月11日 10:28，Andrew Lunn <andrew@lunn.ch> 写道：
> 
> Thanks for merging these patches. I forget how many patches there are
> in total, something like 60, so there are a few more series to
> come. Many more drivers still need splitting.
> 
> If Mengyuan wants to split C22 and C45 that would be nice, but since
> this is a new requirement, i would not insist on it.


