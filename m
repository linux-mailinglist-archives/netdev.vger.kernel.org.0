Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B09A6AA72B
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 02:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbjCDBNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 20:13:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjCDBNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 20:13:33 -0500
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53EC26905F;
        Fri,  3 Mar 2023 17:12:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1677892370; x=1709428370;
  h=from:to:cc:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=TKkCy9MQWPe26af66Jtc6RNDhQIKiJE1VscCTO9qc5I=;
  b=eP9747oLA12iEJ1x17ddsMt0jcEmeIu8A5WblHhkqMPV0XhTE8N+PpYl
   rt5OR7aQiP4S9kpmTqFNO4eCfqXFlXZ2yGL+eKTF2wEGB9ETm2hyJjXC4
   gHEB6DUlNy3lbDzzjcAPWWtBwzt54J1ruS8rElwJ6Vy4z0Q/3916K4DJ6
   o=;
X-IronPort-AV: E=Sophos;i="5.98,232,1673913600"; 
   d="scan'208";a="189587246"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-dc7c3f8b.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2023 01:12:50 +0000
Received: from EX13MTAUWB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-m6i4x-dc7c3f8b.us-west-2.amazon.com (Postfix) with ESMTPS id 672C1A281A;
        Sat,  4 Mar 2023 01:12:49 +0000 (UTC)
Received: from EX19D004ANA004.ant.amazon.com (10.37.240.146) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Sat, 4 Mar 2023 01:12:48 +0000
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19D004ANA004.ant.amazon.com (10.37.240.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.24;
 Sat, 4 Mar 2023 01:12:47 +0000
Received: from EX19D004ANA001.ant.amazon.com ([fe80::f099:cbca:cc6b:91ec]) by
 EX19D004ANA001.ant.amazon.com ([fe80::f099:cbca:cc6b:91ec%5]) with mapi id
 15.02.1118.024; Sat, 4 Mar 2023 01:12:47 +0000
From:   "Iwashima, Kuniyuki" <kuniyu@amazon.co.jp>
To:     "liujian (CE)" <liujian56@huawei.com>
CC:     Paolo Abeni <pabeni@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "Iwashima, Kuniyuki" <kuniyu@amazon.co.jp>,
        "Jakub Kicinski" <kuba@kernel.org>
Subject: Re: [Qestion] abort backport commit ("net/ulp: prevent ULP without
 clone op from entering the LISTEN status") in stable-4.19.x
Thread-Topic: [Qestion] abort backport commit ("net/ulp: prevent ULP without
 clone op from entering the LISTEN status") in stable-4.19.x
Thread-Index: AQHZTjZuz5/tmCdRV0SvYVUmOc0auA==
Date:   Sat, 4 Mar 2023 01:12:47 +0000
Message-ID: <D899D5DA-C73C-46C4-A123-A10F0D389D0D@amazon.co.jp>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.85.17.76]
Content-Type: text/plain; charset="utf-8"
Content-ID: <1BC5C026AB1400448F3312B6826F5EB4@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz4NCkRhdGU6IEZyaSwgMyBNYXIg
MjAyMyAxNzowNjowOCAtMDgwMA0KPiBPbiBGcmksIDMgTWFyIDIwMjMgMTA6NTI6MTUgKzAwMDAg
bGl1amlhbiAoQ0UpIHdyb3RlOg0KPiA+IFdoZW4gSSB3YXMgd29ya2luZyBvbiBDVkUtMjAyMy0w
NDYxLCBJIGZvdW5kIHRoZSBiZWxvdyBiYWNrcG9ydCBjb21taXQgaW4gc3RhYmxlLTQuMTkueCBt
YXliZSBzb21ldGhpbmcgd3Jvbmc/DQo+ID4NCj4gPiA3NTUxOTNmMjUyM2MgKCJuZXQvdWxwOiBw
cmV2ZW50IFVMUCB3aXRob3V0IGNsb25lIG9wIGZyb20gZW50ZXJpbmcgdGhlIExJU1RFTiBzdGF0
dXMiKQ0KPiA+DQo+ID4gMS4gIGVyciA9IC1FQUREUklOVVNFIGluIGluZXRfY3NrX2xpc3Rlbl9z
dGFydCgpIHdhcyByZW1vdmVkLiBCdXQgaXQNCj4gPiAgICAgaXMgdGhlIGVycm9yIGNvZGUgd2hl
biBnZXRfcG9ydCgpIGZhaWxzLg0KPiANCj4gSSB0aGluayB5b3UncmUgcmlnaHQsIHdlIHNob3Vs
ZCBhZGQgc2V0dGluZyB0aGUgZXJyIGJhY2suDQoNClllcywgdGhlIHNhbWUgaXNzdWUgaGFwcGVu
ZWQgb24gNS4xNS44OCwgYnV0IEkgZm9yZ290IHRvIGNoZWNrIG90aGVyIHN0YWJsZSBicmFuY2hl
cy4NCkknbGwgY2hlY2sgdGhlbSBhbmQgcG9zdCBmaXhlcyBsYXRlci4NCmh0dHBzOi8vbG9yZS5r
ZXJuZWwub3JnL3N0YWJsZS8yMDIzMDIyMDEzMzU1NS4xNDA4NjU2ODVAbGludXhmb3VuZGF0aW9u
Lm9yZy8NCg0KDQo+IA0KPiA+ICAyLiBUaGUgY2hhbmdlIGluIF9fdGNwX3NldF91bHAoKSBzaG91
bGQgbm90IGJlIGRpc2NhcmRlZD8NCj4gDQo+IFRoYXQgcGFydCBzaG91bGQgYmUgZmluZSwgYWxs
IFVMUHMgaW4gNC4xOSAoaS5lLiBUTFMpIHNob3VsZCBmYWlsDQo+IHRoZSAtPmluaXQoKSBjYWxs
IGlmIHNrX3N0YXRlICE9IEVTVEFCTElTSEVELg0KDQo=
