Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCE024F944D
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 13:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234895AbiDHLls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 07:41:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234889AbiDHLlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 07:41:45 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C63AC39B80;
        Fri,  8 Apr 2022 04:39:38 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 238Bd93v9021654, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 238Bd93v9021654
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 8 Apr 2022 19:39:09 +0800
Received: from RTEXMBS02.realtek.com.tw (172.21.6.95) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 8 Apr 2022 19:39:09 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS02.realtek.com.tw (172.21.6.95) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 8 Apr 2022 19:39:05 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::34e7:ab63:3da4:27c6]) by
 RTEXMBS04.realtek.com.tw ([fe80::34e7:ab63:3da4:27c6%5]) with mapi id
 15.01.2308.021; Fri, 8 Apr 2022 19:39:05 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "kvalo@kernel.org" <kvalo@kernel.org>,
        "cgel.zte@gmail.com" <cgel.zte@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "zealci@zte.com.cn" <zealci@zte.com.cn>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "lv.ruyi@zte.com.cn" <lv.ruyi@zte.com.cn>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] realtek: rtlwifi: Fix spelling mistake "cacluated" -> "calculated"
Thread-Topic: [PATCH] realtek: rtlwifi: Fix spelling mistake "cacluated" ->
 "calculated"
Thread-Index: AQHYSy8qwaRiOksxDkaBMSpto1BJm6zlXf6A
Date:   Fri, 8 Apr 2022 11:39:05 +0000
Message-ID: <5f42f648f74a826d7f177122ee46e93584df17ae.camel@realtek.com>
References: <20220408095803.2495336-1-lv.ruyi@zte.com.cn>
In-Reply-To: <20220408095803.2495336-1-lv.ruyi@zte.com.cn>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.1-2 
x-originating-ip: [125.224.82.63]
x-kse-serverinfo: RTEXMBS02.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzQvOCDkuIrljYggMDk6NDU6MDA=?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-ID: <03C4668D7ACE8B4B90D374F6A816785B@realtek.com>
Content-Transfer-Encoding: base64
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

T24gRnJpLCAyMDIyLTA0LTA4IGF0IDA5OjU4ICswMDAwLCBjZ2VsLnp0ZUBnbWFpbC5jb20gd3Jv
dGU6DQo+IEZyb206IEx2IFJ1eWkgPGx2LnJ1eWlAenRlLmNvbS5jbj4NCj4gDQo+IFRoZXJlIGFy
ZSBzb21lIHNwZWxsaW5nIG1pc3Rha2VzIGluIHRoZSBjb21tZW50cy4gRml4IGl0Lg0KPiANCj4g
UmVwb3J0ZWQtYnk6IFplYWwgUm9ib3QgPHplYWxjaUB6dGUuY29tLmNuPg0KPiBTaWduZWQtb2Zm
LWJ5OiBMdiBSdXlpIDxsdi5ydXlpQHp0ZS5jb20uY24+DQoNCg0KQWNrZWQtYnk6IFBpbmctS2Ug
U2hpaCA8cGtzaGloQHJlYWx0ZWsuY29tPg0KDQpbLi4uXQ0KDQo=
