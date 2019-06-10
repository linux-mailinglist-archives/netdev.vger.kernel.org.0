Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E88453AECB
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 07:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387702AbfFJF4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 01:56:21 -0400
Received: from mailgate1.rohmeurope.com ([178.15.145.194]:44810 "EHLO
        mailgate1.rohmeurope.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387667AbfFJF4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 01:56:21 -0400
X-AuditID: c0a8fbf4-501ff700000014c1-1b-5cfdf1036b4b
Received: from smtp.reu.rohmeu.com (will-cas001.reu.rohmeu.com [192.168.251.177])
        by mailgate1.rohmeurope.com (Symantec Messaging Gateway) with SMTP id D7.94.05313.301FDFC5; Mon, 10 Jun 2019 07:56:19 +0200 (CEST)
Received: from WILL-MAIL001.REu.RohmEu.com ([fe80::2915:304f:d22c:c6ba]) by
 WILL-CAS001.REu.RohmEu.com ([fe80::d57e:33d0:7a5d:f0a6%16]) with mapi id
 14.03.0439.000; Mon, 10 Jun 2019 07:56:03 +0200
From:   "Vaittinen, Matti" <Matti.Vaittinen@fi.rohmeurope.com>
To:     "kafai@fb.com" <kafai@fb.com>,
        "sbrivio@redhat.com" <sbrivio@redhat.com>
CC:     "dsahern@gmail.com" <dsahern@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "weiwan@google.com" <weiwan@google.com>,
        "jishi@redhat.com" <jishi@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>
Subject: Re: [PATCH net 1/2] ipv6: Dump route exceptions too in
 rt6_dump_route()
Thread-Topic: [PATCH net 1/2] ipv6: Dump route exceptions too in
 rt6_dump_route()
Thread-Index: AQHVHgswpipEvDfcJECeLHdfOM2Y1KaURM2A
Date:   Mon, 10 Jun 2019 05:56:03 +0000
Message-ID: <876287da6e45876a9874782a00eea0b6cb8a9aa0.camel@fi.rohmeurope.com>
References: <cover.1559851514.git.sbrivio@redhat.com>
         <085ce9fbe0206be0d1d090b36e656aa89cef3d98.1559851514.git.sbrivio@redhat.com>
         <fbe7cbf3-c298-48d5-ad1b-78690d4203b5@gmail.com>
         <20190606231834.72182c33@redhat.com>
         <05041be2-e658-8766-ba77-ee01cdfe62bb@gmail.com>
         <20190608054003.5uwggebuawjtetyg@kafai-mbp.dhcp.thefacebook.com>
         <20190608075911.2622aecf@redhat.com>
         <20190608071920.rio4ldr4fhjm2ztv@kafai-mbp.dhcp.thefacebook.com>
         <20190608170206.4fa108f5@redhat.com>
In-Reply-To: <20190608170206.4fa108f5@redhat.com>
Accept-Language: en-US, de-DE
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [213.255.186.46]
Content-Type: text/plain; charset="utf-8"
Content-ID: <521AFCF5FB39554192FD260F920AE3EB@de.rohmeurope.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUgUURSGvTvjzPgxdl1Nr1ZCGxkK7WoELSglFLSGRin9EUPHHJ2l/bCZ
        3crqh2JhWpSRES2JZlqalrkWpmjk5lr5Rym0DbWyjyXL1FAyLa0ZJz/+3Dlz3vc9zx3mUJiy
        jAil9CYLy5sYg4rwxp/U/G7cjP2YS4362azRXu85jWsfto/i2s9dH0jtfP9ZUvtl4hPQdlUE
        aV1D7wntQFWBIo7SPah9o9BdKhgjdS22IVJXYbfqxh/3EbpJe9g+IsUnNoOxHE3WZ5s029N9
        uPnXUyDH7n98bNJN5oFfsBhQFIJb0ezTI8XAm1LCfoAq+n6R8stzgNo63IRkImAsKn4j9r2o
        QJiAXr7qxSUPBi8okN01vuAJgEnoXUuM7ElGz4bqPOV6C/pWf3khi8ON6Hz1mEKqabgXuTtv
        A5n1HUP3nG4gCV4wGk1PNiyYAFyHivLkAAaDkd09vTAUQYiq2nowuV6NRj7O/++rUPvMMC7d
        B4MRqKFVI5dxqOVimDxlPSo9N0zKV/BHL659wktAkG0FwLYcti2HbSvCthXhCuB5ByAjozdk
        MxY2Ws2zVjVv5ozi45DZaAfyr516BP464h0AUkDlS8+45lKVnsxRIdfoACGUQrWatqyaTVX6
        ZZgzczlG4NJ4q4EVHABRmCqQ/u78k6qkM5ncEyxvXpTWULgqmA6nxRiUyIdZNoflF9W1FKVC
        dNSEyPHn2Wz2eJbeYFmWFZSXNNw7NFBgTZksz1gtXJq0KmmCuCuS5Cty2VExTgs5jFHsytFu
        EE2VjJRVYlRTWbV4dkqnEjeZTWxoMM1JPCgFOKtpCfcVBItfHUCHj4uqr7jzS9O+iiCFCGpw
        zkogC7MsheYB8lh/Qt/Yq4hww1UnccrDFTM7mFWcuOV+t77FrSZ+hiB14pXewlpnQr29dE9S
        /s6mM9vCNPFVDE9y6puuDY1sx3BEev4RYtegY9x895z5QPnZorpbwkn9jV0TOed3NN+s2ZTS
        Fjm432t3q1/ltOFtnKZwjuA8Jg5WJQ6Yc8sDVbjAMdGRGC8w/wA625bLsAMAAA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRGVlIEhvIFBlZXBzIQ0KDQpXb3cgU3RlZmFubywgeW91IHNlZW0gdG8gYmUgcXVpdGUgYSBk
ZXRlY3RpdmUgOikgSG93IG9uIGVhcnRoIGRpZCB5b3UNCm1hdGNoIG15IG5ldyBlbWFpbCB0byB0
aGlzIHNvbGUgbmV0ZGV2IGludHJ1c2lvbiBkb25lIGJhY2sgYXQgdGhlIDIwMTENCiUpIEltcHJl
c3NpdmUhDQoNCk9uIFNhdCwgMjAxOS0wNi0wOCBhdCAxNzowMiArMDIwMCwgU3RlZmFubyBCcml2
aW8gd3JvdGU6DQoNCj4gDQo+IC0gcmV0cnkgYWRkaW5nIE5MTV9GX01BVENIIChmb3IgbmV0LW5l
eHQgYW5kIGlwcm91dGUtbmV4dCkgYWNjb3JkaW5nDQo+ICAgdG8gUkZDIDM1NDkuIFRoaW5ncyBj
aGFuZ2VkIGEgYml0IGZyb20gMjAxMTogd2Ugbm93IGhhdmUNCj4gICBOTE1fRl9EVU1QX0ZJTFRF
UkVELCBpcHJvdXRlMiBhbHJlYWR5IHVzZXMgaXQgKGlwIG5laWdoKSBhbmQgd2UNCj4gICB3b3Vs
ZG4ndCBuZWVkIHRvIG1ha2UgaXByb3V0ZTIgbW9yZSBjb21wbGljYXRlZCBieSBoYW5kbGluZyBv
bGQvbmV3DQo+ICAga2VybmVsIGNhc2VzLiBTbyBJIHRoaW5rIHRoaXMgd291bGQgYmUgcmVhc29u
YWJsZSBub3cuDQo+IA0KSSBhbSBwcmV0dHkgc3VyZSB0aGUgaXByb3V0ZSB3b3VsZCBub3QgaGF2
ZSBiZWNvbWUgbW9yZSBjb21wbGljYXRlZA0KYmFjayBpbiAyMDExIGV2ZW4gaWYgd2UgZGlkIHB1
c2ggdGhpcyBjaGFuZ2UgYmFjayB0aGVuLiBpcHJvdXRlMiBjb3VsZA0KaGF2ZSBjaG9zZW4gdG8g
c3RpY2sgd2l0aCBvd24gdXNlcnNwYWNlIGZpbHRlcmluZyAtIHN1cHBvcnRpbmcgdGhlDQpOTE1f
Rl9NQVRDSCBmbGFnIGJhY2sgdGhlbiB3b3VsZCBub3QgaGF2ZSBicm9rZW4gdGhhdC4gQW5kIGlm
IHdlIGRpZCBpdA0KYmFjayB0aGVuIC0gdGhlcmUgbm93IHByb2JhYmx5IHdhcyBzb21lIG90aGVy
IHRvb2xzIHV0aWxpemluZyB0aGUNCmtlcm5lbCBmaWx0ZXJpbmcgLSBhbmQgdG9kYXkgdGhlIGlw
cm91dGUyIGNvdWxkIHByZXR0eSBzYWZlbHkgZHJvcCB0aGUNCnVzZXItc3BhY2Ugcm91dGUgZmls
dGVyaW5nIGNvZGUgYW5kIHRyYW5zaXRpb24gdG8gZG8gZmlsdGVyaW5nIGFscmVhZHkNCmluIGtl
cm5lbC4gV2VsbCwgdGhhdCdzIGEgYml0IGxhdGUgdG8gc2F5IHRvZGF5IDopDQoNCkJ1dCB5ZXMs
IHRoaXMgdW5maW5pc2hlZCB0aGluZyBoYXMgaW5kZWVkIGhhdW50ZWQgbWUgZHVyaW5nIHNvbWUg
YmxhY2sNCm5pZ2h0cyA9KSBJIHdvdWxkIGJlIGRlbGlnaHRlZCB0byBzZWUgdGhlIHByb3BlciBO
TE1fRl9NQVRDSCBzdXBwb3J0IGluDQprZXJuZWwuDQoNCldoYXQgc3RvcHBlZCBtZSBiYWNrIGlu
IHRoZSAyMDExIHdhcyBhY3R1YWxseSBEYXZlJ3MgY29tbWVudCB0aGF0IGV2ZW4NCmlmIGhlIGNv
dWxkIGNvbnNpZGVyIGFwcGx5aW5nIHRoaXMgY2hhbmdlIGhlIHdvdWxkIHJlcXVpcmUgaXQgZm9y
IElQdjQNCnRvby4gQW5kIHRoYXQgbWFrZXMgcGVyZmVjdCBzZW5zZS4gSXQgd2FzIGp1c3QgdG9v
IG11Y2ggZm9yIG1lIGJhY2sNCnRoZW4uIEkgZ3Vlc3MgdGhpcyBoYXMgbm90IGNoYW5nZWQgLSBJ
UHY2IGFuZCBJUHY0IHNob3VsZCBzdGlsbCBoYW5kbGUNCnRoZXNlIGZsYWdzIGluIGEgc2FtZSB3
YXkuDQoNCkJyLA0KCU1hdHRpIFZhaXR0aW5lbg0K
