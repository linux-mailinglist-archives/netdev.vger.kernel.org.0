Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D086D4D9197
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 01:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343875AbiCOAbf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 14 Mar 2022 20:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245422AbiCOAbe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 20:31:34 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E21A5C75;
        Mon, 14 Mar 2022 17:30:09 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 22F0TcrA6020571, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 22F0TcrA6020571
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 15 Mar 2022 08:29:39 +0800
Received: from RTEXDAG01.realtek.com.tw (172.21.6.100) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 15 Mar 2022 08:29:38 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG01.realtek.com.tw (172.21.6.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 15 Mar 2022 08:29:38 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::41d7:1d2e:78a6:ff34]) by
 RTEXMBS04.realtek.com.tw ([fe80::41d7:1d2e:78a6:ff34%5]) with mapi id
 15.01.2308.021; Tue, 15 Mar 2022 08:29:38 +0800
From:   Pkshih <pkshih@realtek.com>
To:     Julia Lawall <Julia.Lawall@inria.fr>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 19/30] rtlwifi: rtl8821ae: fix typos in comments
Thread-Topic: [PATCH 19/30] rtlwifi: rtl8821ae: fix typos in comments
Thread-Index: AQHYN6HMP5yGw8lukkKKZY4Z38Lnb6y/mBDA
Date:   Tue, 15 Mar 2022 00:29:38 +0000
Message-ID: <b569fe0a0a6c4af583fe62c83476842d@realtek.com>
References: <20220314115354.144023-1-Julia.Lawall@inria.fr>
 <20220314115354.144023-20-Julia.Lawall@inria.fr>
In-Reply-To: <20220314115354.144023-20-Julia.Lawall@inria.fr>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXDAG01.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/3/14_=3F=3F_10:52:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36504.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Julia Lawall <Julia.Lawall@inria.fr>
> Sent: Monday, March 14, 2022 7:54 PM
> To: Pkshih <pkshih@realtek.com>
> Cc: kernel-janitors@vger.kernel.org; Kalle Valo <kvalo@kernel.org>; David S. Miller <davem@davemloft.net>;
> Jakub Kicinski <kuba@kernel.org>; linux-wireless@vger.kernel.org; netdev@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: [PATCH 19/30] rtlwifi: rtl8821ae: fix typos in comments
> 
> Various spelling mistakes in comments.
> Detected with the help of Coccinelle.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Thank you.

[...]

