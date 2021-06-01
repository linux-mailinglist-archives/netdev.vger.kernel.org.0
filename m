Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9D3F396D64
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 08:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233026AbhFAGfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 02:35:50 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2921 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233014AbhFAGfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 02:35:47 -0400
Received: from dggeme759-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FvMk337J0z64ZS;
        Tue,  1 Jun 2021 14:31:07 +0800 (CST)
Received: from dggeme760-chm.china.huawei.com (10.3.19.106) by
 dggeme759-chm.china.huawei.com (10.3.19.105) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 1 Jun 2021 14:34:04 +0800
Received: from dggeme760-chm.china.huawei.com ([10.6.80.70]) by
 dggeme760-chm.china.huawei.com ([10.6.80.70]) with mapi id 15.01.2176.012;
 Tue, 1 Jun 2021 14:34:04 +0800
From:   zhengyongjun <zhengyongjun3@huawei.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "trond.myklebust@hammerspace.com" <trond.myklebust@hammerspace.com>,
        "anna.schumaker@netapp.com" <anna.schumaker@netapp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>
Subject: =?gb2312?B?tPC4tDogW1BBVENIIG5ldC1uZXh0XSB4cHJ0cmRtYTogRml4IHNwZWxsaW5n?=
 =?gb2312?Q?_mistakes?=
Thread-Topic: [PATCH net-next] xprtrdma: Fix spelling mistakes
Thread-Index: AQHXVeVpMNGWR7lJskGFmjxjGRAR5Kr+G62AgACYXYA=
Date:   Tue, 1 Jun 2021 06:34:04 +0000
Message-ID: <6b737fb5440d4fe3a53a163624d9cbf8@huawei.com>
References: <20210531063640.3018843-1-zhengyongjun3@huawei.com>
 <20210531222719.3e742ed6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20210531222719.3e742ed6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.176.64]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

U2hvdWxkIEkgcmVtb3ZlIG5ldC1uZXh0IHRhZyBhbmQgc2VuZCBwYXRjaCB2Mj8gV2FpdGluZyBm
b3IgeW91ciBzdWdnZXN0IDopDQoNCi0tLS0t08q8/tStvP4tLS0tLQ0Kt6K8/sjLOiBKYWt1YiBL
aWNpbnNraSBbbWFpbHRvOmt1YmFAa2VybmVsLm9yZ10gDQq3osvNyrG85DogMjAyMcTqNtTCMcjV
IDEzOjI3DQrK1bz+yMs6IHpoZW5neW9uZ2p1biA8emhlbmd5b25nanVuM0BodWF3ZWkuY29tPg0K
s63LzTogdHJvbmQubXlrbGVidXN0QGhhbW1lcnNwYWNlLmNvbTsgYW5uYS5zY2h1bWFrZXJAbmV0
YXBwLmNvbTsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgbGludXgtbmZzQHZnZXIua2VybmVsLm9yZzsg
bmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgYmZp
ZWxkc0BmaWVsZHNlcy5vcmc7IGNodWNrLmxldmVyQG9yYWNsZS5jb20NCtb3zOI6IFJlOiBbUEFU
Q0ggbmV0LW5leHRdIHhwcnRyZG1hOiBGaXggc3BlbGxpbmcgbWlzdGFrZXMNCg0KT24gTW9uLCAz
MSBNYXkgMjAyMSAxNDozNjo0MCArMDgwMCBaaGVuZyBZb25nanVuIHdyb3RlOg0KPiBGaXggc29t
ZSBzcGVsbGluZyBtaXN0YWtlcyBpbiBjb21tZW50czoNCj4gc3VjY2VzICA9PT4gc3VjY2Vzcw0K
PiANCj4gU2lnbmVkLW9mZi1ieTogWmhlbmcgWW9uZ2p1biA8emhlbmd5b25nanVuM0BodWF3ZWku
Y29tPg0KDQpUaGlzIHNob3VsZCBub3QgaGF2ZSBiZWVuIHRhZ2dlZCBmb3IgbmV0LW5leHQsIGxl
YXZpbmcgaXQgdG8gVHJvbmQuDQo=
