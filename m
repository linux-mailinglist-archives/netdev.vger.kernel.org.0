Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2D934D801E
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 11:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238661AbiCNKpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 06:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238659AbiCNKpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 06:45:12 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1F6FCBC3E
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 03:44:01 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-405-xB69G3nOOuef7tBQjIgr_Q-1; Mon, 14 Mar 2022 10:43:59 +0000
X-MC-Unique: xB69G3nOOuef7tBQjIgr_Q-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.32; Mon, 14 Mar 2022 10:43:58 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.033; Mon, 14 Mar 2022 10:43:58 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Dmitry Vyukov' <dvyukov@google.com>,
        syzbot <syzbot+0600986d88e2d4d7ebb8@syzkaller.appspotmail.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        linux-riscv <linux-riscv@lists.infradead.org>
Subject: RE: [syzbot] kernel panic: corrupted stack end in rtnl_newlink
Thread-Topic: [syzbot] kernel panic: corrupted stack end in rtnl_newlink
Thread-Index: AQHYN4MkQzi6nDqsbUGqHyChCsNTUKy+sQcw
Date:   Mon, 14 Mar 2022 10:43:58 +0000
Message-ID: <fb12b19d57c34928895e0faa8067f64c@AcuMS.aculab.com>
References: <0000000000008ec53005da294fe9@google.com>
 <CACT4Y+YXzBGuj4mn2fnBWw4szbb4MsAvNScbyNXi1S21MXm8ig@mail.gmail.com>
 <CACT4Y+a1AvU4ZA3BXPpQMQ15A2T0CT_mrNTXv0NttJ0B06fH=w@mail.gmail.com>
In-Reply-To: <CACT4Y+a1AvU4ZA3BXPpQMQ15A2T0CT_mrNTXv0NttJ0B06fH=w@mail.gmail.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 1
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRG1pdHJ5IFZ5dWtvdg0KPiBTZW50OiAxNCBNYXJjaCAyMDIyIDA5OjA5DQo+IA0KPiBP
biBNb24sIDE0IE1hciAyMDIyIGF0IDA5OjIyLCBEbWl0cnkgVnl1a292IDxkdnl1a292QGdvb2ds
ZS5jb20+IHdyb3RlOg0KPiA+DQo+ID4gT24gTW9uLCAxNCBNYXIgMjAyMiBhdCAwOToxNywgc3l6
Ym90DQo+ID4gPHN5emJvdCswNjAwOTg2ZDg4ZTJkNGQ3ZWJiOEBzeXprYWxsZXIuYXBwc3BvdG1h
aWwuY29tPiB3cm90ZToNCj4gPiA+DQo+ID4gPiBIZWxsbywNCj4gPiA+DQo+ID4gPiBzeXpib3Qg
Zm91bmQgdGhlIGZvbGxvd2luZyBpc3N1ZSBvbjoNCj4gPiA+DQo+ID4gPiBIRUFEIGNvbW1pdDog
ICAgMDk2NmQzODU4MzBkIHJpc2N2OiBGaXggYXVpcGMramFsciByZWxvY2F0aW9uIHJhbmdlIGNo
ZWNrcw0KPiA+ID4gZ2l0IHRyZWU6ICAgICAgIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20v
bGludXgva2VybmVsL2dpdC9yaXNjdi9saW51eC5naXQgZml4ZXMNCj4gPiA+IGNvbnNvbGUgb3V0
cHV0OiBodHRwczovL3N5emthbGxlci5hcHBzcG90LmNvbS94L2xvZy50eHQ/eD0xN2ZlODBjNTcw
MDAwMA0KPiA+ID4ga2VybmVsIGNvbmZpZzogIGh0dHBzOi8vc3l6a2FsbGVyLmFwcHNwb3QuY29t
L3gvLmNvbmZpZz94PTYyOTVkNjc1OTEwNjQ5MjENCj4gPiA+IGRhc2hib2FyZCBsaW5rOiBodHRw
czovL3N5emthbGxlci5hcHBzcG90LmNvbS9idWc/ZXh0aWQ9MDYwMDk4NmQ4OGUyZDRkN2ViYjgN
Cj4gPiA+IGNvbXBpbGVyOiAgICAgICByaXNjdjY0LWxpbnV4LWdudS1nY2MgKERlYmlhbiAxMC4y
LjEtNikgMTAuMi4xIDIwMjEwMTEwLCBHTlUgbGQgKEdOVSBCaW51dGlscyBmb3INCj4gRGViaWFu
KSAyLjM1LjINCj4gPiA+IHVzZXJzcGFjZSBhcmNoOiByaXNjdjY0DQo+ID4NCj4gPiArbGludXgt
cmlzY3YNCj4gPg0KPiA+IFJpc2N2IG5lZWRzIHRvIGluY3JlYXNlIHN0YWNrIHNpemUgdW5kZXIg
S0FTQU4uDQo+ID4gSSB3aWxsIHNlbmQgYSBwYXRjaC4NCg0KV2l0aCB2bWFsbG9jKCllZCBzdGFj
a3MgaXMgaXQgcG9zc2libGUgdG8gYWxsb2NhdGUgYW4gZXh0cmEgcGFnZQ0Kb2YgS1ZBIHRoYXQg
aXNuJ3QgYmFja2VkIGJ5IG1lbW9yeSBhcyBhICdndWFyZCBwYWdlJyBzbyB0aGF0DQpzdGFjayBv
dmVyZmxvdyBmYXVsdHMgaW1tZWRpYXRlbHk/DQoNClByb2JhYmx5IHdvcnRoIGVuZm9yY2luZyBm
b3IgS0FTQU4gYnVpbGRzIHdoZXJlIHRoZSBjb21waWxlcnMNCmhhdmUgYSBuYXN0eSBoYWJpdCBv
ZiB1c2luZyBsb3QgbW9yZSBzdGFjayBzcGFjZSB0aGF0IG1pZ2h0DQpiZSBleHBlY3RlZC4NCg0K
CURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBN
b3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAx
Mzk3Mzg2IChXYWxlcykNCg==

