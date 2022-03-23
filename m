Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 187594E4CBF
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 07:31:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241293AbiCWGcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 02:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiCWGc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 02:32:29 -0400
Received: from mail.meizu.com (edge05.meizu.com [157.122.146.251])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F206D710F4;
        Tue, 22 Mar 2022 23:30:58 -0700 (PDT)
Received: from IT-EXMB-1-123.meizu.com (172.16.1.123) by mz-mail12.meizu.com
 (172.16.1.108) with Microsoft SMTP Server (TLS) id 14.3.487.0; Wed, 23 Mar
 2022 14:30:58 +0800
Received: from IT-EXMB-1-125.meizu.com (172.16.1.125) by
 IT-EXMB-1-123.meizu.com (172.16.1.123) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 23 Mar 2022 14:30:56 +0800
Received: from IT-EXMB-1-125.meizu.com ([fe80::7481:7d92:3801:4575]) by
 IT-EXMB-1-125.meizu.com ([fe80::7481:7d92:3801:4575%3]) with mapi id
 15.01.2308.014; Wed, 23 Mar 2022 14:30:56 +0800
From:   =?gb2312?B?sNe6xs7E?= <baihaowen@meizu.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: =?gb2312?B?tPC4tDogW1BBVENIXSBuZXQ6IGwydHA6IEZpeCBkdXBsaWNhdGUgaW5jbHVk?=
 =?gb2312?Q?ed_trace.h?=
Thread-Topic: [PATCH] net: l2tp: Fix duplicate included trace.h
Thread-Index: AQHYPmd0se+T/7P3CU2M/VTl+cE8UazL5sYAgACbYPY=
Date:   Wed, 23 Mar 2022 06:30:56 +0000
Message-ID: <710ae0adfbc343aa81403055c31665c6@meizu.com>
References: <1648006705-30269-1-git-send-email-baihaowen@meizu.com>,<20220322221418.55f6a665@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220322221418.55f6a665@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.137.70]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-1.0 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dGh4IGZvciBwb2ludGluZyBvdXQgbXkgbWlzdGFrZW4uDQpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fDQq3orz+yMs6IEpha3ViIEtpY2luc2tpIDxrdWJhQGtlcm5lbC5v
cmc+DQq3osvNyrG85DogMjAyMsTqM9TCMjPI1SAxMzoxNDoxOA0KytW8/sjLOiCw17rGzsQNCrOt
y806IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IHBhYmVuaUByZWRoYXQuY29tOyBuZXRkZXZAdmdlci5r
ZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQrW98ziOiBSZTogW1BBVENI
XSBuZXQ6IGwydHA6IEZpeCBkdXBsaWNhdGUgaW5jbHVkZWQgdHJhY2UuaA0KDQpPbiBXZWQsIDIz
IE1hciAyMDIyIDExOjM4OjI1ICswODAwIEhhb3dlbiBCYWkgd3JvdGU6DQo+IENsZWFuIHVwIHRo
ZSBmb2xsb3dpbmcgaW5jbHVkZWNoZWNrIHdhcm5pbmc6DQo+DQo+IG5ldC9sMnRwL2wydHBfY29y
ZS5jOiB0cmFjZS5oIGlzIGluY2x1ZGVkIG1vcmUgdGhhbiBvbmNlLg0KPg0KPiBObyBmdW5jdGlv
bmFsIGNoYW5nZS4NCg0KVGhpcyBvbmUgZG9lc24ndCBidWlsZCBlaXRoZXIuDQoNCllvdSBtdXN0
IHZhbGlkYXRlIHlvdXIgcGF0Y2hlcyB0byB0aGUgYmVzdCBvZiB5b3VyIGFiaWxpdHkuDQpJZiB0
aGUgYmVzdCBvZiB5b3VyIGFiaWxpdHkgZG9lcyBub3QgaW5jbHVkZSBmaXJpbmcgdXANCmEgY29t
cGlsZXIgLSB0aGF0IHdpbGwgYmUgYSBwcm9ibGVtLg0K
