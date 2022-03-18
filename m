Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8DDE4DD411
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 06:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232445AbiCRFHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 01:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232419AbiCRFHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 01:07:12 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7616B2B448E;
        Thu, 17 Mar 2022 22:05:48 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id 7C7075FD0A;
        Fri, 18 Mar 2022 08:05:45 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1647579945;
        bh=ypzBk57mUg4ndyuovUUf+dGMir3EpF/+c3SKTe+7je4=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=HmxVNsHGR65Yzy9vwCzXuPLnw2oINEHx21F/PsB6+2w5c7cplc9tDY6bRn+ytNDMz
         QVPlp4XtqVr93Sobhmq0uFNV8/X4csdOzgC3KzOVB0tFmQvQwLmKTWWZgS7AvGJWZs
         fGfDsdDVTHGkpAbT+xmG1W94oDIOtXfLdmdefa5DTj6ViBteAfBx8eeflvI9ShIyXv
         mbOvIcafQskthbN9dsrGsF5EMvxsPPYsp/Vv5EzuY8pTxsB4Phs4DkFGGlMeNSgVCs
         /uAWI6szdDq6Yubmai7dMYrggEE8iMCCO8w/dQBdVp/NQcqtZIp0G2OCHfNwkiGeTX
         a5OATyDO+P4FA==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Fri, 18 Mar 2022 08:05:43 +0300 (MSK)
From:   Krasnov Arseniy Vladimirovich <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Krasnov Arseniy <oxffffaa@gmail.com>,
        Rokosov Dmitry Dmitrievich <DDRokosov@sberdevices.ru>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v4 0/2] af_vsock: add two new tests for
 SOCK_SEQPACKET
Thread-Topic: [PATCH net-next v4 0/2] af_vsock: add two new tests for
 SOCK_SEQPACKET
Thread-Index: AQHYOdkn7YTNsId4DUmR+TugFQYSWKzEZZCA
Date:   Fri, 18 Mar 2022 05:05:26 +0000
Message-ID: <bd2c956c-6cad-0873-d304-e441bfb0036f@sberdevices.ru>
References: <97d6d8c6-f7b2-1b03-a3d9-f312c33134ec@sberdevices.ru>
In-Reply-To: <97d6d8c6-f7b2-1b03-a3d9-f312c33134ec@sberdevices.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <0918E87B6C8B07468E1473095A2EB444@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/03/18 00:40:00 #18999185
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTcuMDMuMjAyMiAxMToyOSwgS3Jhc25vdiBBcnNlbml5IFZsYWRpbWlyb3ZpY2ggd3JvdGU6
DQoNCkdyZWF0ISBUaGFuayBZb3UgZm9yIHJldmlld2luZyB0aGlzIHBhdGNoc2V0IQ0KDQo+IFRo
aXMgYWRkcyB0d28gdGVzdHM6IGZvciByZWNlaXZlIHRpbWVvdXQgYW5kIHJlYWRpbmcgdG8gaW52
YWxpZA0KPiBidWZmZXIgcHJvdmlkZWQgYnkgdXNlci4gSSBmb3Jnb3QgdG8gcHV0IGJvdGggcGF0
Y2hlcyB0byBtYWluDQo+IHBhdGNoc2V0Lg0KPiANCj4gQXJzZW5peSBLcmFzbm92KDIpOg0KPiAN
Cj4gYWZfdnNvY2s6IFNPQ0tfU0VRUEFDS0VUIHJlY2VpdmUgdGltZW91dCB0ZXN0DQo+IGFmX3Zz
b2NrOiBTT0NLX1NFUVBBQ0tFVCBicm9rZW4gYnVmZmVyIHRlc3QNCj4gDQo+IHRvb2xzL3Rlc3Rp
bmcvdnNvY2svdnNvY2tfdGVzdC5jIHwgMjE1ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKw0KPiAxIGZpbGUgY2hhbmdlZCwgMjE1IGluc2VydGlvbnMoKykNCj4gDQo+IHYx
IC0+IHYyOg0KPiAgc2VlIGV2ZXJ5IHBhdGNoIGFmdGVyICctLS0nIGxpbmUuDQo+IA0KPiB2MiAt
PiB2MzoNCj4gIHNlZSBldmVyeSBwYXRjaCBhZnRlciAnLS0tJyBsaW5lLg0KPiANCj4gdjMgLT4g
djQ6DQo+ICBzZWUgZXZlcnkgcGF0Y2ggYWZ0ZXIgJy0tLScgbGluZS4NCj4gDQoNCg==
