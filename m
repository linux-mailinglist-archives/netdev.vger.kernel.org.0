Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A852B680ECD
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 14:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236398AbjA3N1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 08:27:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbjA3N13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 08:27:29 -0500
Received: from exchange.fintech.ru (exchange.fintech.ru [195.54.195.159])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35F6A34004;
        Mon, 30 Jan 2023 05:27:28 -0800 (PST)
Received: from Ex16-02.fintech.ru (10.0.10.19) by exchange.fintech.ru
 (195.54.195.169) with Microsoft SMTP Server (TLS) id 14.3.498.0; Mon, 30 Jan
 2023 16:27:26 +0300
Received: from Ex16-01.fintech.ru (10.0.10.18) by Ex16-02.fintech.ru
 (10.0.10.19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Mon, 30 Jan
 2023 16:27:26 +0300
Received: from Ex16-01.fintech.ru ([fe80::2534:7600:5275:d3f9]) by
 Ex16-01.fintech.ru ([fe80::2534:7600:5275:d3f9%7]) with mapi id
 15.01.2242.004; Mon, 30 Jan 2023 16:27:26 +0300
From:   =?utf-8?B?0JbQsNC90LTQsNGA0L7QstC40Ycg0J3QuNC60LjRgtCwINCY0LPQvtGA0LU=?=
         =?utf-8?B?0LLQuNGH?= <n.zhandarovich@fintech.ru>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Alexey Khoroshilov" <khoroshilov@ispras.ru>,
        "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>
Subject: RE: [PATCH 5.10 1/1] mt76: fix mt7615_init_tx_queues() return value
Thread-Topic: [PATCH 5.10 1/1] mt76: fix mt7615_init_tx_queues() return value
Thread-Index: AQHZNKePV9Tuf82zRk2tMrTfyN8UZK62u2sAgAA3O6A=
Date:   Mon, 30 Jan 2023 13:27:26 +0000
Message-ID: <b945bd5f3d414ac5bc589d65cf439f7b@fintech.ru>
References: <20230130123655.86339-1-n.zhandarovich@fintech.ru>
 <20230130123655.86339-2-n.zhandarovich@fintech.ru>
 <Y9fAkt/5BRist//g@kroah.com>
In-Reply-To: <Y9fAkt/5BRist//g@kroah.com>
Accept-Language: ru-RU, en-US
Content-Language: ru-RU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.0.253.138]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBXaGF0IGlzIHRoZSBnaXQgY29tbWl0IGlkIG9mIHRoaXMgdXBzdHJlYW0/DQo+IA0KPiBBbmQg
SSBjYW4ndCBhcHBseSB0aGlzIGFzLWlzIGZvciB0aGUgb2J2aW91cyByZWFzb24gaXQgd291bGQg
bWVzcyB1cCB0aGUNCj4gY2hhbmdlbG9nLCBob3cgZGlkIHlvdSBjcmVhdGUgdGhpcz8NCj4gDQo+
IGNvbmZ1c2VkLA0KPiANCj4gZ3JlZyBrLWgNCg0KQ29tbWl0IGluIHF1ZXN0aW9uIGlzIGI2NzFk
YTMzZDFjNTk3M2Y5MGYwOThmZjY2YTkxOTUzNjkxZGY1ODIgdXBzdHJlYW0uIEkgd2Fzbid0IGNl
cnRhaW4gaXQgbWFrZXMgc2Vuc2UgdG8gYmFja3BvcnQgdGhlIHdob2xlIHBhdGNoIGFzIG9ubHkg
YSBzbWFsbCBwb3J0aW9uIG9mIGl0IHBlcnRhaW5zIHRvIHRoZSBmYXVsdCBhdCBxdWVzdGlvbi4N
Cg0KV291bGQgYmUgZXh0cmVtZWx5IGdyYXRlZnVsIGZvciBkaXJlY3Rpb25zIGhvdyB0byBwcm9j
ZWVkIGZyb20gaGVyZS4NCg0Kc29tZXdoYXQgZW1iYXJyYXNzZWQsDQoNCk5pa2l0YQ0K
