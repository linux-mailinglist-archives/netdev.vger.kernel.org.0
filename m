Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22ECC325387
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 17:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232723AbhBYQ3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 11:29:21 -0500
Received: from smtp11.skoda.cz ([185.50.127.88]:13803 "EHLO smtp11.skoda.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229561AbhBYQ3M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 11:29:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; d=skoda.cz; s=plzenjune2020; c=relaxed/simple;
        q=dns/txt; i=@skoda.cz; t=1614270509; x=1614875309;
        h=From:Sender:Reply-To:Subject:Date:Message-ID:To:CC:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=TAcd2USECeqWYk5BuiLJ9zQpBgX7lQ+ZNDN+oBShUcQ=;
        b=VIlKfJOks6rOfwvKoKN6KXw3N4lH3yLvGDDxjUUgo5/pFqnnzILXAn/LH++KC0PJ
        nDxkPoHEjE+jKGXWeiKyTtGoTdYHpqJqArhcgt/ORbc4T1E14efFwGhCYVvn6qCc
        vBAz6vDwtJtB5uluZQ9rMWuINYzTcpRyfdt8J4jUkAo=;
X-AuditID: 0a2aa12e-543c270000016b84-e9-6037d02dd034
Received: from srv-exch-03.skoda.cz (srv-exch-03.skoda.cz [10.42.11.93])
        (using TLS with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by smtp11.skoda.cz (Mail Gateway) with SMTP id 53.AA.27524.D20D7306; Thu, 25 Feb 2021 17:28:29 +0100 (CET)
Received: from srv-exch-02.skoda.cz (10.42.11.92) by srv-exch-03.skoda.cz
 (10.42.11.93) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 25 Feb
 2021 17:28:28 +0100
Received: from srv-exch-02.skoda.cz ([fe80::a9b8:e60e:44d3:758d]) by
 srv-exch-02.skoda.cz ([fe80::a9b8:e60e:44d3:758d%3]) with mapi id
 15.01.2176.002; Thu, 25 Feb 2021 17:28:28 +0100
From:   =?utf-8?B?VmluxaEgS2FyZWw=?= <karel.vins@skoda.cz>
To:     'Eyal Birger' <eyal.birger@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [External] Re: High (200+) XFRM interface count performance
 problem (throughput)
Thread-Topic: [External] Re: High (200+) XFRM interface count performance
 problem (throughput)
Thread-Index: AdcJ50F1lPQSKBMETcCSnfXvuoqLXgAlXe+AAAexynAAPaX5oA==
Date:   Thu, 25 Feb 2021 16:28:28 +0000
Message-ID: <978dc613e5374ae19e13a5d920079c07@skoda.cz>
References: <63259d1978cb4a80889ccec40528ee80@skoda.cz>
 <CAHsH6GtF_HwevJ8gMRtkGbo+mtTb7a_1DdSODv5Ek5K=CUftKg@mail.gmail.com>
 <8bb5f16f9ec9451d929c0cf6d52d9cb2@skoda.cz>
In-Reply-To: <8bb5f16f9ec9451d929c0cf6d52d9cb2@skoda.cz>
Accept-Language: cs-CZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.42.12.26]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA3VUbUxbVRjm3Ba4fJxxKaO8VMpGk/2gcQxwfMTosqAzW0wU/YEfmbZlXGlH
        aUlvqxs/FOcQBzKX6RQKSMeHIqICwzgQozQMCp0wCBgFF8fWSYaiY7gFRmw897aFC4l/bt4+
        z3nO+5znvKe0RLYWoaANJitrMemMqpBwabg64qXdu69kaVMHlkOyRx/PHnLI91MHe+1XQw8u
        dyfmUi+GP1LAGg2vspY9+7Th+oZqDyrpizu2dvG2tAz9Ka9EYTQwe6HxrTsUX8uYZgrausyV
        KJzU8wjarkwj348+BI2TX0v4VSFMNrh73g/l6+1MMnzn9gi4hMmA392LUr6OYTTQ3NbjX6OF
        YXc35atzoN29KuBSZhcMtHwZzNeYyYKTnmrK16wDwU/1bwtEGGnWv3RfECBGCf2nlpGvWRzM
        eBop3xEYaOkfl/jqWLh1wxvsq3fAnc5OgtNkfTJ81bfHJ02CD6rmQn19o2Gk1iM9g+R20a72
        DYVdpLCLFA4kbUdRXLG1JC0thSsyF+hSjpR2I+FWzqdcRN+XFzoRRSMnqkA0pYrFS09mamXb
        8s0Fx/U6Tq+x2Iwsp9qOl8aytDK8DufbjEUqBQ7m0Zh11MS+xhlZK7l5VSJ+Q0M2ilvnOBtX
        YjhiMNs4jc1iJNqm5mKNSMvZ8osNHGcwm5wIaAlpecGbQVoW6I6Xshazz4gTPUBLVXF4iiV7
        M4U6K1vEsiWsJcB+SAJRAV7kbUVb2EL22CsGozXAE+HfXYRhxIxwEiW+XEcIuZgQHSYJp1v2
        amUKMb3lPEqMgoKCNu8gPhJFhznRCURHkoOt/chnyZXoijlDod9aDJbypiMDqGArHifxoCwA
        iiwp8Yl8koE8QG2xE++zI9ugA1ZG0ReIPnOroUlCD1z6mHyHhO9gQ2uTRCY1mU2sIg4/z7dl
        eLHeZlrPTyHHiQ5CRIkI3qciAf9GETxWhG9YVezE21IJGy9iN7sl+snezM36DcMLqJXMJwno
        rBAQ+WPZSE3mCyjCDwqhAZ4Trt+PiTJLwM/p+DZ+ZktkgFvjx15e120YSG9F5E2X09D1bpUE
        TntXguFnx3wIVC7/Egor06MYFhonMNRXzEYRoiIa/hq5FA01Q+WxcMExD9Bx+5wCXJ2tCbDa
        OK6EjvqqRKiZrtsBLoc3CeyeN3fBoH0kGUYG/0mGml9b1OCtuauGmYV7D8LkbF0qnKwdS4e2
        zz7KgJbhoYeh1vVpDnSfGswBz7fXcqB25ewBaBz/4dACP18Uma+pw5n8fFl1VvF8mfn3GBlA
        /fMlPFJZANw0X0c1wnz5qf+br3U6kJaiDO3TcszhnpLWYZflPf07s8vVrPv63P3Ez2v/uI7O
        U3n7NXTFY9Le1x2uTw6Y2eJnVVe9lv5ufWneRPrSIbp9xvBUeplqRfWo2mV7oUuZ9fTR3Ic4
        442YmGXDzW9upj/j3Jmr1k8ZnXji7uI9zzm3feT0VNvqE4NtDZevzfw7mYcyVVJOr0tTSyyc
        7j99mn+vjgYAAA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRXlhbCwNCndpdGgga2VybmVsIDUuMTAgaXQgd29yayB2ZXJ5IHdlbGwuIFRlc3RlZCB3aXRo
IDEwIDAwMCBpbnRlcmZhY2VzLiBUaGFuayB5b3Ugb25jZSBtb3JlLg0KDQpSZWdhcmRzLCBLYXJl
bA0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogVmluxaEgS2FyZWwgPGthcmVs
LnZpbnNAc2tvZGEuY3o+IA0KU2VudDogV2VkbmVzZGF5LCBGZWJydWFyeSAyNCwgMjAyMSAxMjow
MiBQTQ0KVG86ICdFeWFsIEJpcmdlcicgPGV5YWwuYmlyZ2VyQGdtYWlsLmNvbT4NCkNjOiBuZXRk
ZXZAdmdlci5rZXJuZWwub3JnDQpTdWJqZWN0OiBbRXh0ZXJuYWxdIFJFOiBbRXh0ZXJuYWxdIFJl
OiBIaWdoICgyMDArKSBYRlJNIGludGVyZmFjZSBjb3VudCBwZXJmb3JtYW5jZSBwcm9ibGVtICh0
aHJvdWdocHV0KQ0KDQouDQoNCkhpIEV5YWwsIHRoYW5rIHlvdSBmb3IgcmVzcG9uc2UuIEkgZm91
bmQgdGhhdCBjb21taXQgd2l0aCB5b3VyIGNvbW1lbnQgZHVyaW5nIHRoZSBuaWdodC4gSSB3aWxs
IHRlc3QgaXQuDQpEbyB5b3UgdGhpbmsgdGhhdCB0aGVyZSBpcyBhIGNoYW5jZSB0byBiYWNrcG9y
dCB0aGlzIHRvIDUuNCBhcyBpdCBpcyBMVFMga2VybmVsPw0KDQpSZWdhcmRzLA0KDQpLYXJlbA0K
DQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogRXlhbCBCaXJnZXIgPGV5YWwuYmly
Z2VyQGdtYWlsLmNvbT4NClNlbnQ6IFdlZG5lc2RheSwgRmVicnVhcnkgMjQsIDIwMjEgOToxNSBB
TQ0KVG86IFZpbsWhIEthcmVsIDxrYXJlbC52aW5zQHNrb2RhLmN6Pg0KQ2M6IG5ldGRldkB2Z2Vy
Lmtlcm5lbC5vcmcNClN1YmplY3Q6IFtFeHRlcm5hbF0gUmU6IEhpZ2ggKDIwMCspIFhGUk0gaW50
ZXJmYWNlIGNvdW50IHBlcmZvcm1hbmNlIHByb2JsZW0gKHRocm91Z2hwdXQpDQoNCi4NCg0KSGkg
VmluxaEsDQoNCk9uIFR1ZSwgRmViIDIzLCAyMDIxIGF0IDk6NTIgUE0gVmluxaEgS2FyZWwgPGth
cmVsLnZpbnNAc2tvZGEuY3o+IHdyb3RlOg0KPg0KPiBIZWxsbywNCj4NCj4gSSB3b3VsZCBsaWtl
IHRvIGFzayB5b3UgZm9yIGhlbHAgb3IgYWR2aXNlLg0KPg0KPiBJJ20gdGVzdGluZyBzZXR1cCB3
aXRoIGhpZ2hlciBudW1iZXIgb2YgWEZSTSBpbnRlcmZhY2VzIGFuZCBJJ20gZmFjaW5nIHRocm91
Z2hwdXQgZGVncmFkYXRpb24gd2l0aCBhIGdyb3dpbmcgbnVtYmVyIG9mIGNyZWF0ZWQgWEZSTSBp
bnRlcmZhY2VzIC0gbm90IGNvbmN1cnJlbnQgdHVubmVscyBlc3RhYmxpc2hlZCBidXQgb25seSBY
RlJNIGludGVyZmFjZXMgY3JlYXRlZCAtIGV2ZW4gaW4gRE9XTiBzdGF0ZS4NCj4gSXNzdWUgaXMg
b25seSB1bmlkaXJlY3Rpb25hbCAtIGZyb20gImNsaWVudCIgdG8gInZwbiBodWIiLiBUaHJvdWdo
cHV0IGZvciB0cmFmZmljIGZyb20gaHViIHRvIGNsaWVudCBpcyBub3QgYWZmZWN0ZWQuDQo+DQo+
IFhGUk0gaW50ZXJmYWNlIGNyZWF0ZWQgd2l0aDoNCj4gZm9yIGkgaW4gezEuLjUwMH07IGRvIGxp
bmsgYWRkIGlwc2VjJGkgdHlwZSB4ZnJtIGRldiBlbnMyMjQgaWZfaWQgJGkgOyANCj4gZG9uZQ0K
Pg0KPiBJJ20gdGVzdGluZyB3aXRoIGlwZXJmMyB3aXRoIDEgY2xpZW50IGNvbm5lY3RlZCAtIGZy
b20gY2xpZW50IHRvIGh1YjoNCj4gMiBpbnRlcmZhY2VzIC0gMS4zNiBHYnBzDQo+IDEwMCBpbnRl
cmZhY2VzIC0gMS4zNSBHYnBzDQo+IDIwMCBpbnRlcmZhY2VzIC0gMS4xOSBHYnBzDQo+IDMwMCBp
bnRlcmZhY2VzIC0gMC45OCBHYnBzDQo+IDUwMCBpbnRlcmZhY2VzIC0gMC43MSBHYnBzDQo+DQo+
IFRocm91Z2hwdXQgZnJvbSBodWIgdG8gY2xpZW50IGlzIGFyb3VuZCAxLjQgR2JwcyBpbiBhbGwg
Y2FzZXMuDQo+DQo+IDEgQ1BVIGNvcmUgaXMgMTAwJQ0KPg0KPiBMaW51eCB2LWh1YiA1LjQuMC02
NS1nZW5lcmljICM3My1VYnVudHUgU01QIE1vbiBKYW4gMTggMTc6MjU6MTcgVVRDDQo+IDIwMjEg
eDg2XzY0IHg4Nl82NCB4ODZfNjQgR05VL0xpbnV4DQoNCkNhbiB5b3UgcGxlYXNlIHRyeSB3aXRo
IGEgaGlnaGVyIGtlcm5lbCB2ZXJzaW9uICg+PSA1LjkpPw0KV2UndmUgZG9uZSBzb21lIHdvcmsg
dG8gaW1wcm92ZSB4ZnJtIGludGVyZmFjZSBzY2FsaW5nIHNwZWNpZmljYWxseSBlOThlNDQ1NjJi
YTIgKCJ4ZnJtIGludGVyZmFjZTogc3RvcmUgeGZybWkgY29udGV4dHMgaW4gYSBoYXNoIGJ5IGlm
X2lkIikuDQoNClRoYW5rcywNCkV5YWwuDQo=
