Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85A4E6A62E8
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 23:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbjB1Wzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 17:55:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjB1Wzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 17:55:43 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E94A936FDD
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 14:55:38 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-260-VraOLvLhMQKDyz9L5f4zYg-1; Tue, 28 Feb 2023 22:55:35 +0000
X-MC-Unique: VraOLvLhMQKDyz9L5f4zYg-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.47; Tue, 28 Feb
 2023 22:55:27 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.047; Tue, 28 Feb 2023 22:55:26 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     David Laight <David.Laight@ACULAB.COM>,
        'Russell King' <linux@armlinux.org.uk>,
        Arnd Bergmann <arnd@kernel.org>
CC:     Dominik Brodowski <linux@dominikbrodowski.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        "Ian Abbott" <abbotti@mev.co.uk>, Jakub Kicinski <kuba@kernel.org>,
        Kevin Cernekee <cernekee@gmail.com>,
        Lukas Wunner <lukas@wunner.de>,
        Manuel Lauss <manuel.lauss@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        "Olof Johansson" <olof@lixom.net>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        "YOKOTA Hiroshi" <yokota@netlab.is.tsukuba.ac.jp>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [RFC 0/6] pcmcia: separate 16-bit support from cardbus
Thread-Topic: [RFC 0/6] pcmcia: separate 16-bit support from cardbus
Thread-Index: AQHZSuhWwIxyEez/qUesuC2XWPglYq7k9JKQgAAEaJA=
Date:   Tue, 28 Feb 2023 22:55:26 +0000
Message-ID: <e03e2ef805b94ee2a81a6ecb3adab6c3@AcuMS.aculab.com>
References: <20230227133457.431729-1-arnd@kernel.org>
 <Y/0PbJzvrzpvLbcW@shell.armlinux.org.uk>
 <b75b24146c114e948bb2d325a8d27fda@AcuMS.aculab.com>
In-Reply-To: <b75b24146c114e948bb2d325a8d27fda@AcuMS.aculab.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGF2aWQgTGFpZ2h0DQo+IFNlbnQ6IDI4IEZlYnJ1YXJ5IDIwMjMgMjI6NDUNCi4uLg0K
PiBPciwgbW9yZSBzcGVjaWZpY2FsbHksIGFyZSBhbnkgcGVvcGxlIHVzaW5nIDE2LWJpdCBQQ01D
SUEgY2FyZHMNCj4gaW4gY2FyZGJ1cy1jYXBhYmxlIHNvY2tldHMgd2l0aCBhIGN1cnJlbnQga2Vy
bmVsLg0KPiBUaGV5IG1pZ2h0IGJlIHVzaW5nIHVudXN1YWwgY2FyZHMgdGhhdCBhcmVuJ3QgYXZh
aWxhYmxlIGFzDQo+IGNhcmRidXMgLSBwZXJoYXBzIDU2ayBtb2RlbXMgKGRvZXMgYW55b25lIHN0
aWxsIHVzZSB0aG9zZT8pLg0KDQpPciwgd2hhdCBJIG5vdyByZW1lbWJlciB3ZSB3ZXJlIGRvaW5n
Og0KQ29weWluZyBpbWFnZXMgdG8gbGluZWFyIHBjbWNpYSBzcmFtIGNhcmRzIHRvIGFjY2VzcyBm
cm9tDQphbiBlbWJlZGRlZCBzeXN0ZW0gdGhhdCBvbmx5IHN1cHBvcnRlZCBwY21jaWEuDQooV2hp
Y2ggbWVhbnMgdGhlIHNwYXJjIHN5c3RlbXMgc3VwcG9ydGVkIGJvdGggY2FyZGJ1cyBhbmQgcGNt
Y2lhLikNCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxl
eSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0
aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

