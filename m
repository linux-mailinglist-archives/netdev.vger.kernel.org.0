Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA5F4E4CAE
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 07:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232696AbiCWGWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 02:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240189AbiCWGWp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 02:22:45 -0400
Received: from mail.meizu.com (unknown [14.29.68.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFA976E8F4;
        Tue, 22 Mar 2022 23:21:12 -0700 (PDT)
Received: from IT-EXMB-1-123.meizu.com (172.16.1.123) by mz-mail04.meizu.com
 (172.16.1.16) with Microsoft SMTP Server (TLS) id 14.3.487.0; Wed, 23 Mar
 2022 14:21:14 +0800
Received: from IT-EXMB-1-125.meizu.com (172.16.1.125) by
 IT-EXMB-1-123.meizu.com (172.16.1.123) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 23 Mar 2022 14:21:10 +0800
Received: from IT-EXMB-1-125.meizu.com ([fe80::7481:7d92:3801:4575]) by
 IT-EXMB-1-125.meizu.com ([fe80::7481:7d92:3801:4575%3]) with mapi id
 15.01.2308.014; Wed, 23 Mar 2022 14:21:10 +0800
From:   =?gb2312?B?sNe6xs7E?= <baihaowen@meizu.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "pablo@netfilter.org" <pablo@netfilter.org>,
        "kadlec@netfilter.org" <kadlec@netfilter.org>,
        "fw@strlen.de" <fw@strlen.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: =?gb2312?B?tPC4tDogW1BBVENIXSBuZXRmaWx0ZXI6IGlwc2V0OiBGaXggZHVwbGljYXRl?=
 =?gb2312?B?IGluY2x1ZGVkIGlwX3NldF9oYXNoX2dlbi5o?=
Thread-Topic: [PATCH] netfilter: ipset: Fix duplicate included
 ip_set_hash_gen.h
Thread-Index: AQHYPmWRr8jWS7XIQEWQhhdkMvav8azL5gWAgACZQxA=
Date:   Wed, 23 Mar 2022 06:21:09 +0000
Message-ID: <269af0be3a144707b6df47c3ecb7e54f@meizu.com>
References: <1648005894-28708-1-git-send-email-baihaowen@meizu.com>,<20220322221133.7475f708@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220322221133.7475f708@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.137.70]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_00,MAY_BE_FORGED,
        SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

U29ycnkgZm9yIG15IGZhdWx0IGFuZCBtaXN0YWtlbi4NCl9fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX18NCreivP7IyzogSmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9y
Zz4NCreiy83KsbzkOiAyMDIyxOoz1MIyM8jVIDEzOjExOjMzDQrK1bz+yMs6ILDXusbOxA0Ks63L
zTogcGFibG9AbmV0ZmlsdGVyLm9yZzsga2FkbGVjQG5ldGZpbHRlci5vcmc7IGZ3QHN0cmxlbi5k
ZTsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgbmV0ZmlsdGVyLWRldmVsQHZnZXIua2VybmVsLm9yZzsg
Y29yZXRlYW1AbmV0ZmlsdGVyLm9yZzsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgta2Vy
bmVsQHZnZXIua2VybmVsLm9yZw0K1vfM4jogUmU6IFtQQVRDSF0gbmV0ZmlsdGVyOiBpcHNldDog
Rml4IGR1cGxpY2F0ZSBpbmNsdWRlZCBpcF9zZXRfaGFzaF9nZW4uaA0KDQpPbiBXZWQsIDIzIE1h
ciAyMDIyIDExOjI0OjU0ICswODAwIEhhb3dlbiBCYWkgd3JvdGU6DQo+IE5vIGZ1bmN0aW9uYWwg
Y2hhbmdlLg0KDQpJbiBzb21lIGRlZXBseSBwaGlsb3NvcGhpY2FsIHNlbnNlPyBUaGlzIHBhdGNo
IGRvZXMgbm90IGJ1aWxkLg0K
