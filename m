Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB45865581F
	for <lists+netdev@lfdr.de>; Sat, 24 Dec 2022 03:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233418AbiLXCr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 21:47:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230505AbiLXCr0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 21:47:26 -0500
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [63.216.63.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F47D1900D;
        Fri, 23 Dec 2022 18:47:24 -0800 (PST)
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxhk.zte.com.cn (FangMail) with ESMTPS id 4Nf7kG2Sksz8QrkZ;
        Sat, 24 Dec 2022 10:47:18 +0800 (CST)
Received: from szxlzmapp02.zte.com.cn ([10.5.231.79])
        by mse-fl1.zte.com.cn with SMTP id 2BO2lCEK020722;
        Sat, 24 Dec 2022 10:47:12 +0800 (+08)
        (envelope-from yang.yang29@zte.com.cn)
Received: from mapi (szxlzmapp02[null])
        by mapi (Zmail) with MAPI id mid14;
        Sat, 24 Dec 2022 10:47:13 +0800 (CST)
Date:   Sat, 24 Dec 2022 10:47:13 +0800 (CST)
X-Zmail-TransId: 2b0463a66831ffffffffb7a3b4cd
X-Mailer: Zmail v1.0
Message-ID: <202212241047135426119@zte.com.cn>
In-Reply-To: <Y6XDHRVgKLbDLPNj@bombadil.infradead.org>
References: 202212231034450492161@zte.com.cn,Y6XDHRVgKLbDLPNj@bombadil.infradead.org
Mime-Version: 1.0
From:   <yang.yang29@zte.com.cn>
To:     <mcgrof@kernel.org>
Cc:     <jirislaby@kernel.org>, <mickflemm@gmail.com>, <kvalo@kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <xu.panda@zte.com.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCBuZXQtbmV4dF0gYXRoNWs6IHVzZSBzdHJzY3B5KCkgdG8gaW5zdGVhZCBvZiBzdHJuY3B5KCk=?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl1.zte.com.cn 2BO2lCEK020722
X-Fangmail-Gw-Spam-Type: 0
X-FangMail-Miltered: at cgslv5.04-192.168.250.137.novalocal with ID 63A66836.000 by FangMail milter!
X-FangMail-Envelope: 1671850038/4Nf7kG2Sksz8QrkZ/63A66836.000/10.5.228.132/[10.5.228.132]/mse-fl1.zte.com.cn/<yang.yang29@zte.com.cn>
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 63A66836.000/4Nf7kG2Sksz8QrkZ
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> According to who? Are you sure you are not just sending stupid commits
> to get an increase in your kernel commit count? Because this is an old
> driver and who cares?

This is suggested by Petr Mladek, please see:
https://lore.kernel.org/all/Y4cz27AbZVVd9pLJ@alley/

And if the driver no one cares, we may stop modify it.
