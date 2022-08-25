Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 546945A0B30
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 10:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239624AbiHYIUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 04:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239604AbiHYIUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 04:20:32 -0400
X-Greylist: delayed 900 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 25 Aug 2022 01:20:17 PDT
Received: from mail10.tencent.com (mail10.tencent.com [14.18.183.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB8A471739;
        Thu, 25 Aug 2022 01:20:17 -0700 (PDT)
Received: from EX-SZ022.tencent.com (unknown [10.28.6.88])
        by mail10.tencent.com (Postfix) with ESMTP id D55DBD46BD;
        Thu, 25 Aug 2022 15:55:36 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tencent.com;
        s=s202002; t=1661414136;
        bh=cXR/p7SatqK54AtwJOaWVlrYZCN2ej8Vbu9R6UgHa7o=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=eb69BX9fx8nBjcqmR+oHI6qoh7CZgbo3Lhs58xR2pjS9qqBSwylUQuRL7P4Z+3VOX
         wdGxpAPK5gILJ0t8bk1QgthqEiYjjaBdPy9FHtu0bjeWX7egVFyWkjamgUKQNvIwpZ
         SdKzgIC4VPdvovtY6pjpZGJ68JpACz5DkLw/VFqc=
Received: from EX-SZ086.tencent.com (10.28.6.127) by EX-SZ022.tencent.com
 (10.28.6.88) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Thu, 25 Aug
 2022 15:55:36 +0800
Received: from EX-SZ079.tencent.com (10.28.6.51) by EX-SZ086.tencent.com
 (10.28.6.127) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Thu, 25 Aug
 2022 15:55:36 +0800
Received: from EX-SZ079.tencent.com ([fe80::9139:f467:e23f:e2b7]) by
 EX-SZ079.tencent.com ([fe80::9139:f467:e23f:e2b7%3]) with mapi id
 15.01.2242.008; Thu, 25 Aug 2022 15:55:36 +0800
From:   =?utf-8?B?aW1hZ2Vkb25nKOiRo+aipum+mSk=?= <imagedong@tencent.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
CC:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Linux Next Mailing List" <linux-next@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [Internet]linux-next: build warning after merge of the net-next
 tree
Thread-Topic: [Internet]linux-next: build warning after merge of the net-next
 tree
Thread-Index: AQHYuEVTMflASOI/8Ey1NaP00fjp5K2/P5MA
Date:   Thu, 25 Aug 2022 07:55:36 +0000
Message-ID: <07263247-4906-4A72-A1A2-CAB41F115EB7@tencent.com>
References: <20220825154105.534d78ab@canb.auug.org.au>
In-Reply-To: <20220825154105.534d78ab@canb.auug.org.au>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [9.218.225.5]
Content-Type: text/plain; charset="utf-8"
Content-ID: <97D0694AA2B3404BA5BB7FA6EDEC218A@tencent.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_HELO_TEMPERROR,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIZWxsbywNCg0KT24gMjAyMi84LzI1IDEzOjQx77yM4oCcU3RlcGhlbiBSb3Rod2VsbOKAnTxz
ZnJAY2FuYi5hdXVnLm9yZy5hdT4gd3JpdGU6DQoNCj4gSGkgYWxsLA0KPiANCj4gQWZ0ZXIgbWVy
Z2luZyB0aGUgbmV0LW5leHQgdHJlZSwgdG9kYXkncyBsaW51eC1uZXh0IGJ1aWxkIChodG1sZG9j
cykNCj4gcHJvZHVjZWQgdGhpcyB3YXJuaW5nOg0KPiANCj4gRG9jdW1lbnRhdGlvbi9uZXR3b3Jr
aW5nL2thcGk6MjY6IG5ldC9jb3JlL3NrYnVmZi5jOjc4MDogV0FSTklORzogRXJyb3IgaW4gZGVj
bGFyYXRvciBvciBwYXJhbWV0ZXJzDQo+IEludmFsaWQgQyBkZWNsYXJhdGlvbjogRXhwZWN0aW5n
ICIoIiBpbiBwYXJhbWV0ZXJzLiBbZXJyb3IgYXQgMTldDQo+ICAgdm9pZCBfX2ZpeF9hZGRyZXNz
IGtmcmVlX3NrYl9yZWFzb24gKHN0cnVjdCBza19idWZmICpza2IsIGVudW0gc2tiX2Ryb3BfcmVh
c29uIHJlYXNvbikNCj4gICAtLS0tLS0tLS0tLS0tLS0tLS0tXg0KPiANCj4gSW50cm9kdWNlZCBi
eSBjb21taXQNCj4gDQo+ICAgYzIwNWNjNzUzNGE5ICgibmV0OiBza2I6IHByZXZlbnQgdGhlIHNw
bGl0IG9mIGtmcmVlX3NrYl9yZWFzb24oKSBieSBnY2MiKQ0KPiANCg0KWWVhaCwgSSBjb21taXRl
ZCB0aGlzIHBhdGNoLiBNYXkgSSBhc2sgd2hhdCBjb21tYW5kIGRpZCB5b3UgdXNlIHRvDQpwcm9k
dWNlIHRoaXMgd2FybmluZz8gSSB0cmllZCB0aGUgZm9sbG93aW5nIGNvbW1hbmQsIGJ1dCBub3Qg
c3VjY2VzczoNCg0KICBtYWtlIFY9MiBTUEhJTlhESVJTPSJuZXR3b3JraW5nIiBodG1sZG9jcw0K
DQpIbW0uLi4uLi4ud2hhdCBkb2VzIHRoaXMgd2FybmluZyBtZWFucz8gRG9lcyBpdCBkb24ndCBs
aWtlIHRoaXMNCmZ1bmN0aW9uIGF0dHJpYnV0ZT8NCg0KVGhhbmtzIQ0KTWVuZ2xvbmcgRG9uZw0K
DQo+IC0tIA0KPiBDaGVlcnMsDQo+IFN0ZXBoZW4gUm90aHdlbGwNCg0K
