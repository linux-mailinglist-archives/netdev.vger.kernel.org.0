Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10D3B1548A4
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 16:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727567AbgBFP4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 10:56:05 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:59505 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727473AbgBFP4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 10:56:05 -0500
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  Codrin.Ciubotariu@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Codrin.Ciubotariu@microchip.com";
  x-sender="Codrin.Ciubotariu@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Codrin.Ciubotariu@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa6.microchip.iphmx.com; spf=Pass smtp.mailfrom=Codrin.Ciubotariu@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: 6h9h5IANTjBVIdngWIoWTVGYg1NFI5+Q9NqvJgVL8sPWkt5UndEtHfOTUumDgn99mOG8Vay4Ju
 vhZjYapIY+LmkyEuorXLTrm0ACXemGttjoEPmfWCZs5arn/7nKfEO1dhGL5oNURPPrC66MCPty
 cTVseixOVTXc36Nl1lWujB4lQAvhUUfnni0f65g1G+JgVqS9+WrD6/gncFIbSkvmRYpafFUcnt
 KlISFjowr5jp82d/axKi4F2CaHkXMqXk9VdBaggpy6IqjqulQTedgGMRGVe2lVWz/RswqDHZTc
 lPo=
X-IronPort-AV: E=Sophos;i="5.70,410,1574146800"; 
   d="scan'208";a="1534780"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Feb 2020 08:55:53 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 6 Feb 2020 08:55:49 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Thu, 6 Feb 2020 08:55:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ErAmMJGMRSrRqfVTmK0tWNk/aJoMSOKCE5Ryaht226EEYFGjJloFZ2eCC/OCxhjseb7Yoq5YY7BTP3dAco8YHpSY5nmjlpgYz1yXhNGpX+/pMREwLlpClzunMddzxQG9TqULlqRN50U47aWGqGQ9CmcqIsHb721PJbKdHs3DpLX6aHKxOvG8Q3sBi6ZG2jFDFNO3qmsxApVU+JFDNxvhOcWuf2zTqoL3tqMBcZBZnvdHs9bp6UdySup+RSZ4jrixUsMu9djBqP55gA+VI39WoKYJAX2pD9tP8sLLCMKaGrvq0bOC+E02YN+mUtj/HVFSqtCEWeFb0Oy+C/v88J58Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9b3j16FE7TEHCGse2+44knl5d6uKGsJOjiVyH70cmzY=;
 b=BERftpYtqkd/XU70lXlJs5bAvMStIYkQfz+7DsErpCWEMje4anjCe1jBBJr8KAxv6BXQ1jgK1lriZcWPG0JXjxMLNXScFW6sI0SWHv7jIWc+ayEhd0PGefK6XKyXSEdDjuu3JqdB/kZnIXLXQt4P6KuOEKvI58diRWaoS9nHyAiDeP9h2ZA6mH2fOOnRUIJKfz25QQsIW5fUQH+oON+VRxx68l8nhittxCwQqVgo/X5UUtlO+TXI1xUYg0dCL3h1GiVl9vj38hQmDdaeL6tUTKnCaz0yG81KkVnupWRSBTP5iL9OBGEJiVsp3AnyCEEdUKUcvuG9axauRGzd5JhLwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9b3j16FE7TEHCGse2+44knl5d6uKGsJOjiVyH70cmzY=;
 b=rqeN+hsclA7CUh4VMpmCU1rAwY1zb8/dngkYFxi84J8S0JWcnGJiqyk8/IRNCJR/FPi+x2hFwDU6oBO0bNslF0Xgh2xji2l1SvOktEsIdpFIp42p0mF9FbMi3Y0knkJGpwgZjYtgNjHZmOi+3xY6EoFvfEDRDfbcYcAacSctYoo=
Received: from BY5PR11MB4497.namprd11.prod.outlook.com (52.132.255.220) by
 BY5PR11MB4372.namprd11.prod.outlook.com (52.132.252.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.32; Thu, 6 Feb 2020 15:55:47 +0000
Received: from BY5PR11MB4497.namprd11.prod.outlook.com
 ([fe80::6189:c32:b55b:b3fd]) by BY5PR11MB4497.namprd11.prod.outlook.com
 ([fe80::6189:c32:b55b:b3fd%5]) with mapi id 15.20.2686.034; Thu, 6 Feb 2020
 15:55:47 +0000
From:   <Codrin.Ciubotariu@microchip.com>
To:     <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <Woojung.Huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <vivien.didelot@gmail.com>, <f.fainelli@gmail.com>,
        <davem@davemloft.net>, <razvan.stefanescu@microchip.com>
Subject: Re: [PATCH] net: dsa: microchip: enable module autoprobe
Thread-Topic: [PATCH] net: dsa: microchip: enable module autoprobe
Thread-Index: AQHV3P9syVNYOkbVUU+ZQ5V6GAUdX6gOS+8AgAAF2oA=
Date:   Thu, 6 Feb 2020 15:55:47 +0000
Message-ID: <96093569-21ea-ea3a-6bfe-ed9903944b69@microchip.com>
References: <20200206150837.12009-1-codrin.ciubotariu@microchip.com>
 <20200206153448.GA30090@lunn.ch>
In-Reply-To: <20200206153448.GA30090@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [94.177.32.156]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 490c2bc3-8df7-465b-e2f4-08d7ab1d081c
x-ms-traffictypediagnostic: BY5PR11MB4372:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR11MB437282DED2D5B5D7DECC8241E71D0@BY5PR11MB4372.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0305463112
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(376002)(366004)(346002)(39860400002)(396003)(189003)(199004)(86362001)(478600001)(6916009)(31696002)(186003)(6506007)(53546011)(26005)(54906003)(31686004)(316002)(2616005)(71200400001)(36756003)(76116006)(66946007)(5660300002)(66476007)(66556008)(64756008)(66446008)(8936002)(4326008)(81156014)(6486002)(107886003)(2906002)(81166006)(8676002)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:BY5PR11MB4372;H:BY5PR11MB4497.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: g8Ypd1rBsgJIYiGOupVCAPiwOx8lAp7My0P1w8CvNAF5LLUckJsh6eG3J3pFLCW2fliVMJ/zdcdKNgPAS08JmvHHeOay1YXYhwab1UtOKospzhg71P5pge2U7Vlf72+J7tUQ8Fi5ZZrTcnzNZzQDpcJMLM32CXpYKI6erDeCXRAS1xvX4Qy8XWlJFqpkqSgDJuTF7bidddrvG+mnW/T8S6Z6jkb5gCL+vCU28FdaMqLIo/Dx+2BgO9Z/m6YwfYfXFzNk4Vt/A808Ojfit4JVCwsw8VVKtWb6QoMQkMn6yt+QaLXTlymS5cgUwAcvzeCFtNrUzwM+0tDDM/Lk9O2zdZJ0/1IVnGg0MIEnynytd0wjT+5ou1U6elYmar57PTS0LSFqnMzwYJNgr4TkJldwx6jv2kFZwkOmq26BelR/BbUW0q7J6+BLSHF17UPn+0wm
x-ms-exchange-antispam-messagedata: tnfe94RlYeHZifwc8IY/nj0PSBAc1E3A68FBHm4zMeRK28LDRxH/0Cj3kJWYnORdH0MVM0+azXBNhqe7reFHXwjUDg35eX6GgsLVIhMzOzONx2aCSTZuNMPzbyStZTuKiNt9kIv6tNlM4JeEVO3qDw==
Content-Type: text/plain; charset="utf-8"
Content-ID: <B70AA61A150F914788230A16A2F8AA19@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 490c2bc3-8df7-465b-e2f4-08d7ab1d081c
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2020 15:55:47.3747
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W72nfH4TKkqNNzpjwbGBUh82rMRNiNbSMPzQeYUgjHwvNYW2gE2gVPQM9cO71XmJX0vax09FjP9wgsHImhyJrwQcqwESz0hLepu65ZLuK0I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4372
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDYuMDIuMjAyMCAxNzozNCwgQW5kcmV3IEx1bm4gd3JvdGU6DQo+IEVYVEVSTkFMIEVNQUlM
OiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtub3cg
dGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gT24gVGh1LCBGZWIgMDYsIDIwMjAgYXQgMDU6MDg6
MzdQTSArMDIwMCwgQ29kcmluIENpdWJvdGFyaXUgd3JvdGU6DQo+PiBGcm9tOiBSYXp2YW4gU3Rl
ZmFuZXNjdSA8cmF6dmFuLnN0ZWZhbmVzY3VAbWljcm9jaGlwLmNvbT4NCj4+DQo+PiBUaGlzIG1h
dGNoZXMgL3N5cy9kZXZpY2VzLy4uLi9zcGkxLjAvbW9kYWxpYXMgY29udGVudC4NCj4+DQo+PiBT
aWduZWQtb2ZmLWJ5OiBSYXp2YW4gU3RlZmFuZXNjdSA8cmF6dmFuLnN0ZWZhbmVzY3VAbWljcm9j
aGlwLmNvbT4NCj4+IFNpZ25lZC1vZmYtYnk6IENvZHJpbiBDaXVib3Rhcml1IDxjb2RyaW4uY2l1
Ym90YXJpdUBtaWNyb2NoaXAuY29tPg0KPj4gLS0tDQo+PiAgIGRyaXZlcnMvbmV0L2RzYS9taWNy
b2NoaXAva3N6OTQ3N19zcGkuYyB8IDEgKw0KPj4gICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRp
b24oKykNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3o5
NDc3X3NwaS5jIGIvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3o5NDc3X3NwaS5jDQo+PiBp
bmRleCBjNWY2NDk1OWExODQuLjI0OGI2OWM3NGI0NSAxMDA2NDQNCj4+IC0tLSBhL2RyaXZlcnMv
bmV0L2RzYS9taWNyb2NoaXAva3N6OTQ3N19zcGkuYw0KPj4gKysrIGIvZHJpdmVycy9uZXQvZHNh
L21pY3JvY2hpcC9rc3o5NDc3X3NwaS5jDQo+PiBAQCAtMTAxLDYgKzEwMSw3IEBAIHN0YXRpYyBz
dHJ1Y3Qgc3BpX2RyaXZlciBrc3o5NDc3X3NwaV9kcml2ZXIgPSB7DQo+Pg0KPj4gICBtb2R1bGVf
c3BpX2RyaXZlcihrc3o5NDc3X3NwaV9kcml2ZXIpOw0KPj4NCj4+ICtNT0RVTEVfQUxJQVMoInNw
aTprc3o4NTYzIik7DQo+IA0KPiBJcyB0aGlzIHN1ZmZpY2llbnQgZm9yIGFsbCB0aGUgZGlmZmVy
ZW50IHZhcmlhbnRzIHRoaXMgZHJpdmVyDQo+IHN1cHBvcnRzPw0KDQpQcm9iYWJseSBub3QuIEFs
bCB0aGUgYXZhaWxhYmxlIHZhcmlhbnRzIHNlZW0gdG8gYmUgdGhvc2UgZnJvbSB0aGUgDQpjb21w
YXRpYmxlIGxpc3QuIEkgY2FuIG1ha2UgYWxpYXNlcyBmb3IgYWxsIG9mIHRoZW0sIGlmIGl0J3Mg
b2sgZm9yIA0KZXZlcnlvbmUuDQoNCkJlc3QgcmVnYXJkcywNCkNvZHJpbg0K
