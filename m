Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB10229791
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 13:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731884AbgGVLim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 07:38:42 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:20546 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbgGVLil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 07:38:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1595417920; x=1626953920;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=g8VPA+XPYOT0OIir5Y5qGh8SXdrjPCRWAUXiBcOUMJ4=;
  b=IsXCKgVy+khNNfZlFfp8dhiDkT7z61p5STMlo4Kl9D0OMvB/KBiZp+NY
   t048S41ChoMUyv0VpQGGkE11JAaWSz5OPoSzXRDCJo+xTbtHHt9j5RXaB
   +5JYUs8mmdnwuirF5cnaw9KZHYq9dQcLNmX0Ts9w0gyDJ6svUldZcRIKh
   qs2NDjkQlWICOtj+aZZ+EXJU1B0UROGuktw3q8XTFoCrgvH8uZvVI8CMx
   5aOHXDVJnkvPpehTgJ/BPeb94+qEjfAPhvQZuINfFQ8vsW7tIlzzAPjMV
   b1PU6o9VgGTJMV2C2CHoqE72va7pySlkdukbUQrJoLdt9pdTdPOiihsIz
   Q==;
IronPort-SDR: IM/e2zjH4q8eOJt0Hipj4PAIIvR9hqxWP4iHXA7qqYtsAQOpc+xEfuYFfNq27TuYteXlTD+EGb
 FAHNsimc79BtvHifxDrCZu6SAlSOtHKiuFJfQkPhbz1g1+lVEZpPW1DqeQP/xv6xZPuTQdABMN
 2ofUXf3J26B6O0XI0yfld8TnwDv5Xn5fgTiH8RQmDBtilqA3Ok94IFlqmaEulyjyn8ahxe5eaw
 F7Ow/YSb1WiQ+BtfZwPNRQggI1IadcycTYEtNklbeH+mFjDnZjStQQyj7n0+gzZZhE7eU11v7s
 0B4=
X-IronPort-AV: E=Sophos;i="5.75,381,1589266800"; 
   d="scan'208";a="20141114"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Jul 2020 04:38:39 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 22 Jul 2020 04:38:39 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Wed, 22 Jul 2020 04:38:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G9mNk6oPlEBqs0ruy8QqKSRse13LFUFM28IdOiwGNvd2hFVviwlvzAOtbGziqd87jv1E/uvz4re1mk7yo44tTiPaQwZlWjFEzSkmKek76W8qKIHH4+gYe0aJnHpg1kmp6x4+OcDEcteXjnwkti/kGkv+f8HRfmhwbWRDK6bTLEXPafThPCCidJA8tNuOxYx+3xnodeXlH9LVCPNv8+W6nql6iq81Tcp6kxicd8rMBbouM8L/jVjxWSU+kJX5zLdvCzI2Lab1GvIu1kLrYGMBulv98vVYZxmo0+xT4FFKhZTR/1HWNZCYftZFydA/WyrQpJPZN/jHrDmo31be1oyxLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g8VPA+XPYOT0OIir5Y5qGh8SXdrjPCRWAUXiBcOUMJ4=;
 b=NXjwKeC0DFW+UEyQiQGx9yjGfWEpgi4wAR8innSK190Yn8VQcrqrB84dfDqRlMx9AJll/utm60JwkbKufIh2GOlhQ3XGkoZIylascoImGYhokHF8du/JczJNCx6CCihedz1Y342PiNGnR3pylZeaKOGfR6OVAnr+ZfqEJBkaSMLBk8kf4RQM5wzvxhT+4cH/JoirD7Vzt2n3CeRs6uOQL2TgHBnGFIuIL2uuxP6AFwt/i3h5qE0JV/TMqxJOO+pmvP6ej6xHt7lVUkwUjYWv2AGZ/SIS0dTU4ErgYENyB4vqZAS0Vpm+7Mmfvw7+Hx/Zi/E8SJSGh5U3CiwJW8W0AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g8VPA+XPYOT0OIir5Y5qGh8SXdrjPCRWAUXiBcOUMJ4=;
 b=DXCUBuqtQ7QocrdIsQ4zLiU3W/rJ+ynfuYBJ59gA9vX/AAUGUu4dOvRM574k0zyrSSorzB7PPAre05ZPs2ZDxesGYtjsxM8ztjaMxgaRbusvyk/qYHnHYz6F9iBnpc7oZQ7edsLQujKUEJYXT7Rup0YlXn4R2fBDItV6SpU+6gA=
Received: from SN6PR11MB3504.namprd11.prod.outlook.com (2603:10b6:805:d0::17)
 by SA0PR11MB4576.namprd11.prod.outlook.com (2603:10b6:806:97::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20; Wed, 22 Jul
 2020 11:38:38 +0000
Received: from SN6PR11MB3504.namprd11.prod.outlook.com
 ([fe80::851c:67fc:a034:9ea0]) by SN6PR11MB3504.namprd11.prod.outlook.com
 ([fe80::851c:67fc:a034:9ea0%4]) with mapi id 15.20.3216.022; Wed, 22 Jul 2020
 11:38:38 +0000
From:   <Codrin.Ciubotariu@microchip.com>
To:     <Claudiu.Beznea@microchip.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <Nicolas.Ferre@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <robh+dt@kernel.org>, <alexandre.belloni@bootlin.com>,
        <Ludovic.Desroches@microchip.com>
Subject: Re: [PATCH net-next v2 0/7] Add an MDIO sub-node under MACB
Thread-Topic: [PATCH net-next v2 0/7] Add an MDIO sub-node under MACB
Thread-Index: AQHWX4JuelDTpdq80UW3XJv+RJlkGakTZ76AgAASg4A=
Date:   Wed, 22 Jul 2020 11:38:37 +0000
Message-ID: <7cab13f6-ac54-8f5c-c1bf-35e6c3b5d9db@microchip.com>
References: <20200721171316.1427582-1-codrin.ciubotariu@microchip.com>
 <0ec99957-57e9-b384-425a-ccf0e877f1a1@microchip.com>
In-Reply-To: <0ec99957-57e9-b384-425a-ccf0e877f1a1@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
authentication-results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none
 header.from=microchip.com;
x-originating-ip: [84.232.220.208]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 587e9d88-0f44-4de0-5a06-08d82e33c678
x-ms-traffictypediagnostic: SA0PR11MB4576:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA0PR11MB457676C5061460EDB05D30B1E7790@SA0PR11MB4576.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: f8dh3381WDPQYN3VWnVSXFpcZ3C4z67fM9wbJJuPt7SaWzmSk1mhht5cCkNBUF/myHVeG98vAVS52v1cWJ0lugpsCr9cNVtgWtC203hHy4h2Xmg1wRlS2/tuuQnfMiPmlD/EDZF0p1Rg3JwDC6PvOgPc7dfkGgOc1cXx98ae/eerI2ZWJ/2/w68tazWSFc9bLz/FRB4lxVFZNj4igUDN0K+ShhPT0DoWbX+qucxB7UlkvMEofYrmRWJh1JfNMlXoDjsmD/iktySR/yCdcLWTzyu6dhSZ6Wt0ojGaF2PrbbfTQueOC9kqFggJ4fHh7lCeFyG70hgQq2bblatgAtv6JGoaE9+OKTFAegRbJU4eAUsbhLMN/KKYfTNKHxQ/rzMy
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3504.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(366004)(39860400002)(376002)(346002)(136003)(107886003)(26005)(54906003)(31696002)(316002)(110136005)(2616005)(71200400001)(8936002)(7416002)(86362001)(2906002)(5660300002)(4326008)(66446008)(6486002)(66556008)(478600001)(36756003)(6512007)(8676002)(186003)(31686004)(76116006)(91956017)(66946007)(66476007)(6506007)(53546011)(83380400001)(64756008)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: WGfC8VP5m4kkJ6D2L4ADnLQA2mRFa4fX8kUR926ZDHiqqxuxvrnlmBEPPL+DAl7uZunSjEJqLf+Nml1iuzYCV42UQqzDFWTTdmZtS3QW6O0ns9PyS2xNpLRkBZOQgx5Nh/MPh0OmzgBOQaNsAxC8f25z6SK+ZS5UPQ+2C787Vybhf5cwE6p7C0pZ9/38vbwTtn0jKlRbzesAlOYQ2Yp4joiy68CfoTcLYNpRRBF8c0g6+CSbEoHPn+WfzFCb4ztjbCAHBVv+Zsx8HkLi39f7P3hNly28A9Wv3HnoZcwc8aj9SWRs+8qeTeFTQIhCBSOuaRrYALY7LXq6C8zb9aKQ4iKIdduuE2O/AdF6txTu75N6coKXVgaTsO1DrAAE7z1lT783gqOnrMSHEUwkZJ7C6ydWhMhxAmA8kSFrZThRGYm50RadTVQInTEjlZJf4KLWQwfeZi3/7OP2hvwedpK65u01NWZdtODuMd5oMdDM4Hstjkp7WjN0dT7ou+4qTcht
Content-Type: text/plain; charset="utf-8"
Content-ID: <DFF4CE7E9D165546B35B8F05A7460C4C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3504.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 587e9d88-0f44-4de0-5a06-08d82e33c678
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2020 11:38:37.9112
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ux/7vJU7D3l5aq18LGNbJxbySTOqKr3rhwgzJJBGMji+Rhsn9DpJ2RmjMy4AALmkoD8j2hRxVTNQztiDb0KP4n0cJsNEivRREEcIANlmVJM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4576
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjIuMDcuMjAyMCAxMzozMiwgQ2xhdWRpdSBCZXpuZWEgLSBNMTgwNjMgd3JvdGU6DQo+IA0K
PiANCj4gT24gMjEuMDcuMjAyMCAyMDoxMywgQ29kcmluIENpdWJvdGFyaXUgd3JvdGU6DQo+PiBB
ZGRpbmcgdGhlIFBIWSBub2RlcyBkaXJlY3RseSB1bmRlciB0aGUgRXRoZXJuZXQgbm9kZSBiZWNh
bWUgZGVwcmVjYXRlZCwNCj4+IHNvIHRoZSBhaW0gb2YgdGhpcyBwYXRjaCBzZXJpZXMgaXMgdG8g
bWFrZSBNQUNCIHVzZSBhbiBNRElPIG5vZGUgYXMNCj4+IGNvbnRhaW5lciBmb3IgTURJTyBkZXZp
Y2VzLg0KPj4gVGhpcyBwYXRjaCBzZXJpZXMgc3RhcnRzIHdpdGggYSBzbWFsbCBwYXRjaCB0byB1
c2UgdGhlIGRldmljZS1tYW5hZ2VkDQo+PiBkZXZtX21kaW9idXNfYWxsb2MoKS4gSW4gdGhlIG5l
eHQgdHdvIHBhdGNoZXMgd2UgdXBkYXRlIHRoZSBiaW5kaW5ncyBhbmQNCj4+IGFkYXB0IG1hY2Ig
ZHJpdmVyIHRvIHBhcnNlIHRoZSBkZXZpY2UtdHJlZSBQSFkgbm9kZXMgZnJvbSB1bmRlciBhbiBN
RElPDQo+PiBub2RlLiBUaGUgbGFzdCBwYXRjaGVzIGFkZCB0aGUgTURJTyBub2RlIGluIHRoZSBk
ZXZpY2UtdHJlZXMgb2Ygc2FtYTVkMiwNCj4+IHNhbWE1ZDMsIHNhbWFkNCBhbmQgc2FtOXg2MCBi
b2FyZHMuDQo+Pg0KPiANCj4gVGVzdGVkIHRoaXMgc2VyaWVzIG9uIHNhbWE1ZDJfeHBsYWluZWQg
aW4gdGhlIGZvbGxvd2luZyBzY2VuYXJpb3M6DQo+IA0KPiAxLyBQSFkgYmluZGluZ3MgZnJvbSBw
YXRjaCA0Lzc6DQo+IG1kaW8gew0KPiAJI2FkZHJlc3MtY2VsbHMgPSA8MT47DQo+IAkjc2l6ZS1j
ZWxscyA9IDwwPjsNCj4gCWV0aGVybmV0LXBoeUAxIHsNCj4gCQlyZWcgPSA8MHgxPjsNCj4gCQlp
bnRlcnJ1cHQtcGFyZW50ID0gPCZwaW9BPjsNCj4gCQlpbnRlcnJ1cHRzID0gPFBJTl9QQzkgSVJR
X1RZUEVfTEVWRUxfTE9XPjsNCj4gfTsNCj4gDQo+IDIvIFBIWSBiaW5kaW5ncyBiZWZvcmUgdGhp
cyBzZXJpZXM6DQo+IGV0aGVybmV0LXBoeUAxIHsNCj4gCXJlZyA9IDwweDE+Ow0KPiAJaW50ZXJy
dXB0LXBhcmVudCA9IDwmcGlvQT47DQo+IAlpbnRlcnJ1cHRzID0gPFBJTl9QQzkgSVJRX1RZUEVf
TEVWRUxfTE9XPjsNCj4gfTsNCj4gDQo+IDMvIE5vIFBIWSBiaW5kaW5ncyBhdCBhbGwuDQo+IA0K
PiBBbGwgMyBjYXNlcyB3ZW50IE9LLg0KPiANCj4gWW91IGNhbiBhZGQ6DQo+IFRlc3RlZC1ieTog
Q2xhdWRpdSBCZXpuZWEgPGNsYXVkaXUuYmV6bmVhQG1pY3JvY2hpcC5jb20+DQo+IEFja2VkLWJ5
OiBDbGF1ZGl1IEJlem5lYSA8Y2xhdWRpdS5iZXpuZWFAbWljcm9jaGlwLmNvbT4NCg0KVGhhbmsg
eW91IHZlcnkgbXVjaCBDbGF1ZGl1IQ0KVGhlcmUgaXMgc3RpbGwgb25lIG1vcmUgY2FzZSBpbiBt
eSBtaW5kLiBtYWNiIGNvdWxkIGJlIGEgZml4ZWQtbGluayB3aXRoIA0KYW4gTURJTyBEU0Egc3dp
dGNoLiBXaGlsZSB0aGUgbWFjYiB3b3VsZCBoYXZlIGEgZml4ZWQgY29ubmVjdGlvbiB3aXRoIGEg
DQpwb3J0IGZyb20gdGhlIERTQSBzd2l0Y2gsIHRoZSBzd2l0Y2ggY291bGQgYmUgY29uZmlndXJl
ZCB1c2luZyBtYWNiJ3MgDQpNRElPLiBUaGUgZHQgd291bGQgYmUgc29tZXRoaW5nIGxpa2U6DQoN
Cm1hY2Igew0KCWZpeGVkLWxpbmsgew0KCQkuLi4NCgl9Ow0KCW1kaW8gew0KCQlzd2l0Y2hAMCB7
DQoJCQkuLi4NCgkJfTsNCgl9Ow0KfTsNCg0KVG8gc3VwcG9ydCB0aGlzLCBpbiBwYXRjaCAzLzcg
SSBzaG91bGQgZmlyc3QgY2hlY2sgZm9yIHRoZSBtZGlvIG5vZGUgdG8gDQpyZXR1cm4gb2ZfbWRp
b2J1c19yZWdpc3RlcigpIGFuZCB0aGVuIGNoZWNrIGlmIGl0J3MgYSBmaXhlZC1saW5rIHRvIA0K
cmV0dXJuIHNpbXBsZSBtZGlvYnVzX3JlZ2lzdGVyKCkuIEkgd2lsbCBhZGRyZXNzIHRoaXMgaW4g
djMuLi4NCg0KVGhhbmtzIGFuZCBiZXN0IHJlZ2FyZHMsDQpDb2RyaW4NCg0KPiANCj4gVGhhbmsg
eW91LA0KPiBDbGF1ZGl1IEJlem5lYQ0KPiANCj4+IENoYW5nZXMgaW4gdjI6DQo+PiAgIC0gcmVu
YW1lZCBwYXRjaCAyLzcgZnJvbSAibWFjYjogYmluZGluZ3MgZG9jOiB1c2UgYW4gTURJTyBub2Rl
IGFzIGENCj4+ICAgICBjb250YWluZXIgZm9yIFBIWSBub2RlcyIgdG8gImR0LWJpbmRpbmdzOiBu
ZXQ6IG1hY2I6IHVzZSBhbiBNRElPDQo+PiAgICAgbm9kZSBhcyBhIGNvbnRhaW5lciBmb3IgUEhZ
IG5vZGVzIg0KPj4gICAtIGFkZGVkIGJhY2sgYSBuZXdsaW5lIHJlbW92ZWQgYnkgbWlzdGFrZSBp
biBwYXRjaCAzLzcNCj4+DQo+PiBDb2RyaW4gQ2l1Ym90YXJpdSAoNyk6DQo+PiAgICBuZXQ6IG1h
Y2I6IHVzZSBkZXZpY2UtbWFuYWdlZCBkZXZtX21kaW9idXNfYWxsb2MoKQ0KPj4gICAgZHQtYmlu
ZGluZ3M6IG5ldDogbWFjYjogdXNlIGFuIE1ESU8gbm9kZSBhcyBhIGNvbnRhaW5lciBmb3IgUEhZ
IG5vZGVzDQo+PiAgICBuZXQ6IG1hY2I6IHBhcnNlIFBIWSBub2RlcyBmb3VuZCB1bmRlciBhbiBN
RElPIG5vZGUNCj4+ICAgIEFSTTogZHRzOiBhdDkxOiBzYW1hNWQyOiBhZGQgYW4gbWRpbyBzdWIt
bm9kZSB0byBtYWNiDQo+PiAgICBBUk06IGR0czogYXQ5MTogc2FtYTVkMzogYWRkIGFuIG1kaW8g
c3ViLW5vZGUgdG8gbWFjYg0KPj4gICAgQVJNOiBkdHM6IGF0OTE6IHNhbWE1ZDQ6IGFkZCBhbiBt
ZGlvIHN1Yi1ub2RlIHRvIG1hY2INCj4+ICAgIEFSTTogZHRzOiBhdDkxOiBzYW05eDYwOiBhZGQg
YW4gbWRpbyBzdWItbm9kZSB0byBtYWNiDQo+Pg0KPj4gICBEb2N1bWVudGF0aW9uL2RldmljZXRy
ZWUvYmluZGluZ3MvbmV0L21hY2IudHh0IHwgMTUgKysrKysrKysrKysrLS0tDQo+PiAgIGFyY2gv
YXJtL2Jvb3QvZHRzL2F0OTEtc2FtOXg2MGVrLmR0cyAgICAgICAgICAgfCAgOCArKysrKystLQ0K
Pj4gICBhcmNoL2FybS9ib290L2R0cy9hdDkxLXNhbWE1ZDI3X3NvbTEuZHRzaSAgICAgIHwgMTYg
KysrKysrKysrKy0tLS0tLQ0KPj4gICBhcmNoL2FybS9ib290L2R0cy9hdDkxLXNhbWE1ZDI3X3ds
c29tMS5kdHNpICAgIHwgMTcgKysrKysrKysrKy0tLS0tLS0NCj4+ICAgYXJjaC9hcm0vYm9vdC9k
dHMvYXQ5MS1zYW1hNWQyX3B0Y19lay5kdHMgICAgICB8IDEzICsrKysrKysrLS0tLS0NCj4+ICAg
YXJjaC9hcm0vYm9vdC9kdHMvYXQ5MS1zYW1hNWQyX3hwbGFpbmVkLmR0cyAgICB8IDEyICsrKysr
KysrLS0tLQ0KPj4gICBhcmNoL2FybS9ib290L2R0cy9hdDkxLXNhbWE1ZDNfeHBsYWluZWQuZHRz
ICAgIHwgMTYgKysrKysrKysrKysrLS0tLQ0KPj4gICBhcmNoL2FybS9ib290L2R0cy9hdDkxLXNh
bWE1ZDRfeHBsYWluZWQuZHRzICAgIHwgMTIgKysrKysrKystLS0tDQo+PiAgIGRyaXZlcnMvbmV0
L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMgICAgICAgfCAxOCArKysrKysrKysrKystLS0t
LS0NCj4+ICAgOSBmaWxlcyBjaGFuZ2VkLCA4NiBpbnNlcnRpb25zKCspLCA0MSBkZWxldGlvbnMo
LSkNCg0K
