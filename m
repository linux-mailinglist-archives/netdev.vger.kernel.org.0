Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D297B323AFB
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 12:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233279AbhBXLDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 06:03:16 -0500
Received: from smtp11.skoda.cz ([185.50.127.88]:54239 "EHLO smtp11.skoda.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231978AbhBXLDG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 06:03:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; d=skoda.cz; s=plzenjune2020; c=relaxed/simple;
        q=dns/txt; i=@skoda.cz; t=1614164540; x=1614769340;
        h=From:Sender:Reply-To:Subject:Date:Message-ID:To:CC:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=bQ5gsu1SIJlYx9FTDWEJvCl2K57rPtGVx6SrPaOUTog=;
        b=pO6lsgLHqnvw3bXr6uKuxVj2LHTlaw18cgI09sWxPrFIuZxv0hAdtLBCH2JmGdF8
        DAgOFaQSzUIXFoweTJS4KJfCJDMk7c8FTa12txs1egDiO3bPQ9AZD6G8WSI6Xumx
        tFofVJYds3F9OEnTTRxthNIVYTntAv+dU9PVrEZ8T/A=;
X-AuditID: 0a2aa12e-537c170000016b84-3f-6036323b61a5
Received: from srv-exch-01.skoda.cz (srv-exch-01.skoda.cz [10.42.11.91])
        (using TLS with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by smtp11.skoda.cz (Mail Gateway) with SMTP id 4F.84.27524.B3236306; Wed, 24 Feb 2021 12:02:19 +0100 (CET)
Received: from srv-exch-02.skoda.cz (10.42.11.92) by srv-exch-01.skoda.cz
 (10.42.11.91) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 24 Feb
 2021 12:02:19 +0100
Received: from srv-exch-02.skoda.cz ([fe80::a9b8:e60e:44d3:758d]) by
 srv-exch-02.skoda.cz ([fe80::a9b8:e60e:44d3:758d%3]) with mapi id
 15.01.2176.002; Wed, 24 Feb 2021 12:02:19 +0100
From:   =?utf-8?B?VmluxaEgS2FyZWw=?= <karel.vins@skoda.cz>
To:     'Eyal Birger' <eyal.birger@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [External] Re: High (200+) XFRM interface count performance
 problem (throughput)
Thread-Topic: [External] Re: High (200+) XFRM interface count performance
 problem (throughput)
Thread-Index: AdcJ50F1lPQSKBMETcCSnfXvuoqLXgAlXe+AAAexynA=
Date:   Wed, 24 Feb 2021 11:02:19 +0000
Message-ID: <8bb5f16f9ec9451d929c0cf6d52d9cb2@skoda.cz>
References: <63259d1978cb4a80889ccec40528ee80@skoda.cz>
 <CAHsH6GtF_HwevJ8gMRtkGbo+mtTb7a_1DdSODv5Ek5K=CUftKg@mail.gmail.com>
In-Reply-To: <CAHsH6GtF_HwevJ8gMRtkGbo+mtTb7a_1DdSODv5Ek5K=CUftKg@mail.gmail.com>
Accept-Language: cs-CZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.42.12.26]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA3VUfUwbdRjm1xZ6fPzGcYzyUoFJk0XBjY+ufOjmoo0a1G3xg5jFTWmBg1b6
        gb0WBxqzLWx8zMw556QdkwpU5jIjMqIbMAfIN2TEmSkbg8ysswMzNCCTzci86xcHif9c3nue
        e37v8z733hFC6l6olNAazLTJoNbJgkJEIUmhuzZulmeoUuccmVnDz2T12yVPCbLP2ybF2fOt
        8S8JXg/ZUkDrtKW0KWWrKkQzNDSKSioi9wy6mkR7US9Vg4IJIBVQdWtBXINCCIpsFMC+/usi
        z40Lwez0fQH3FEW2Izj40ytcHURmwUjbx2KuXksmwoURp5CrhWQ6/DZyR8TVkWQuNJ5q8z6j
        goGRVoGnfgJm91sRV4vI9dDa0B1YgwgCk5nw/ZTY0+p9+OJWVRBXB5Mvw/ELt901IuOgs3oe
        eVpFwzVnvcAzAAlNnWNCTx0F0zeXAj31OphraRFyxwtZm1+3p3ikCXDs0K/uVpiMgCGrU3QE
        SWy8U23LChtPYeMp7Eh0GoUzenNJWloyU2wsUCfnl7ci9zv5PPkcunigqAcJCNSDKhEhkEXh
        3SkZKmpNnrGgTKNmNLkmi45mZGuxIJWFsR/Os+iKZVL8AYdG+lED/Q6jo83se5fF4/tvyVVU
        tJ9jLEyJNl9rtDC5FpOO1TY06nN5WsaSp9cyjNZo6EFACNmWZ5fS2ZYF6rJy2mT0GOlBDxEi
        WTS+6FKoKLJIbaaLabqENvnY42wgMsCKNNZWhIkuovcUanVmH88K82+wZ5J8xj1JHKb7WELC
        J3jDJGC5iW0o5dOr5onDKCAgYOUJ/JEERHAP2o+IMHawy1zEmClR6xltkddaJH6OyzLMh7pt
        xeBMDqR8IM9SHFbp2XwlPmqVnRiPHWqZ9lkZRl8h4sj0yQYh0d33GXvtd197TzoahJTIYDTQ
        0mj8BteW5MQai8Gfn1SC3z29SUWF8wjOpzQW461sfFE8fNmq9GHMbGZVMTx2pVtW7+qWr9Qv
        G55BDnY/2YBucrGFsb+V5dQoXME5DfWC7tAAd3BYhBfjZRaLFTqujZdZFRlgR8ylN/26ZQNy
        B2K/6QkxHF5aDIRxuysIauavimHxyjCGmfofMdRVToSzRGUEzA71RUBt/4EoOGt3AZz58xMp
        DLY4YuFe/VgcnKk7FA+1V06sg0H7UgLYnPvWw1DvX4mwVLuQBNdm7m6AyxMnUqHCekkOp778
        NB2sg81KaK3uVYKz44YSrItHn4X6sa7n4Rtn5Tb457ve7TA1+u92uD3VtmOG2y8Bu18yjZzb
        L7PazN+vAa2c2y8v6t2vLdxHSvnAFfv1u9a9X17q//bLT/vSku5FhxJ1USEbf/4wc0duc/uj
        XYvpvyTMV/4w8EJO9gbb4HSZsi+NMIrOp2ccHuh81bUr5e1tBzOvKx+xFGVljD9e/Hfht3NX
        35vcXSjZZM2p6BrfqXnQrF9TXUCOBtRl/2E/l72o7Og6+uLAa4rhyaqcY3cem7tb01++sPNB
        qenJpo+ejgkvVchEjEadliQ0Mer/ALNpB7aMBgAA
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRXlhbCwgdGhhbmsgeW91IGZvciByZXNwb25zZS4gSSBmb3VuZCB0aGF0IGNvbW1pdCB3aXRo
IHlvdXIgY29tbWVudCBkdXJpbmcgdGhlIG5pZ2h0LiBJIHdpbGwgdGVzdCBpdC4NCkRvIHlvdSB0
aGluayB0aGF0IHRoZXJlIGlzIGEgY2hhbmNlIHRvIGJhY2twb3J0IHRoaXMgdG8gNS40IGFzIGl0
IGlzIExUUyBrZXJuZWw/DQoNClJlZ2FyZHMsDQoNCkthcmVsDQoNCi0tLS0tT3JpZ2luYWwgTWVz
c2FnZS0tLS0tDQpGcm9tOiBFeWFsIEJpcmdlciA8ZXlhbC5iaXJnZXJAZ21haWwuY29tPiANClNl
bnQ6IFdlZG5lc2RheSwgRmVicnVhcnkgMjQsIDIwMjEgOToxNSBBTQ0KVG86IFZpbsWhIEthcmVs
IDxrYXJlbC52aW5zQHNrb2RhLmN6Pg0KQ2M6IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNClN1Ympl
Y3Q6IFtFeHRlcm5hbF0gUmU6IEhpZ2ggKDIwMCspIFhGUk0gaW50ZXJmYWNlIGNvdW50IHBlcmZv
cm1hbmNlIHByb2JsZW0gKHRocm91Z2hwdXQpDQoNCi4NCg0KSGkgVmluxaEsDQoNCk9uIFR1ZSwg
RmViIDIzLCAyMDIxIGF0IDk6NTIgUE0gVmluxaEgS2FyZWwgPGthcmVsLnZpbnNAc2tvZGEuY3o+
IHdyb3RlOg0KPg0KPiBIZWxsbywNCj4NCj4gSSB3b3VsZCBsaWtlIHRvIGFzayB5b3UgZm9yIGhl
bHAgb3IgYWR2aXNlLg0KPg0KPiBJJ20gdGVzdGluZyBzZXR1cCB3aXRoIGhpZ2hlciBudW1iZXIg
b2YgWEZSTSBpbnRlcmZhY2VzIGFuZCBJJ20gZmFjaW5nIHRocm91Z2hwdXQgZGVncmFkYXRpb24g
d2l0aCBhIGdyb3dpbmcgbnVtYmVyIG9mIGNyZWF0ZWQgWEZSTSBpbnRlcmZhY2VzIC0gbm90IGNv
bmN1cnJlbnQgdHVubmVscyBlc3RhYmxpc2hlZCBidXQgb25seSBYRlJNIGludGVyZmFjZXMgY3Jl
YXRlZCAtIGV2ZW4gaW4gRE9XTiBzdGF0ZS4NCj4gSXNzdWUgaXMgb25seSB1bmlkaXJlY3Rpb25h
bCAtIGZyb20gImNsaWVudCIgdG8gInZwbiBodWIiLiBUaHJvdWdocHV0IGZvciB0cmFmZmljIGZy
b20gaHViIHRvIGNsaWVudCBpcyBub3QgYWZmZWN0ZWQuDQo+DQo+IFhGUk0gaW50ZXJmYWNlIGNy
ZWF0ZWQgd2l0aDoNCj4gZm9yIGkgaW4gezEuLjUwMH07IGRvIGxpbmsgYWRkIGlwc2VjJGkgdHlw
ZSB4ZnJtIGRldiBlbnMyMjQgaWZfaWQgJGkgIA0KPiA7IGRvbmUNCj4NCj4gSSdtIHRlc3Rpbmcg
d2l0aCBpcGVyZjMgd2l0aCAxIGNsaWVudCBjb25uZWN0ZWQgLSBmcm9tIGNsaWVudCB0byBodWI6
DQo+IDIgaW50ZXJmYWNlcyAtIDEuMzYgR2Jwcw0KPiAxMDAgaW50ZXJmYWNlcyAtIDEuMzUgR2Jw
cw0KPiAyMDAgaW50ZXJmYWNlcyAtIDEuMTkgR2Jwcw0KPiAzMDAgaW50ZXJmYWNlcyAtIDAuOTgg
R2Jwcw0KPiA1MDAgaW50ZXJmYWNlcyAtIDAuNzEgR2Jwcw0KPg0KPiBUaHJvdWdocHV0IGZyb20g
aHViIHRvIGNsaWVudCBpcyBhcm91bmQgMS40IEdicHMgaW4gYWxsIGNhc2VzLg0KPg0KPiAxIENQ
VSBjb3JlIGlzIDEwMCUNCj4NCj4gTGludXggdi1odWIgNS40LjAtNjUtZ2VuZXJpYyAjNzMtVWJ1
bnR1IFNNUCBNb24gSmFuIDE4IDE3OjI1OjE3IFVUQyANCj4gMjAyMSB4ODZfNjQgeDg2XzY0IHg4
Nl82NCBHTlUvTGludXgNCg0KQ2FuIHlvdSBwbGVhc2UgdHJ5IHdpdGggYSBoaWdoZXIga2VybmVs
IHZlcnNpb24gKD49IDUuOSk/DQpXZSd2ZSBkb25lIHNvbWUgd29yayB0byBpbXByb3ZlIHhmcm0g
aW50ZXJmYWNlIHNjYWxpbmcgc3BlY2lmaWNhbGx5IGU5OGU0NDU2MmJhMiAoInhmcm0gaW50ZXJm
YWNlOiBzdG9yZSB4ZnJtaSBjb250ZXh0cyBpbiBhIGhhc2ggYnkgaWZfaWQiKS4NCg0KVGhhbmtz
LA0KRXlhbC4NCg==
