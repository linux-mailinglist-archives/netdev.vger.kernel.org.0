Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0155F13223E
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 10:27:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbgAGJ1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 04:27:43 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:59518 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726327AbgAGJ1m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 04:27:42 -0500
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 4279140650;
        Tue,  7 Jan 2020 09:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1578389262; bh=oDwmH8jVjY2atKEOM8IHDNlOZYWAQMga7KJjpnmaQ+A=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=CQMe5hUiL4xXScqYMlrJ8K4r4gy1egJ4y/Xtu9AIjuos8Wq37kIU7N40pzO0tsOp4
         1qEMAMjcrwiMJGe/eYAslCo6qD3z4P6ifR7wGKvhfA3DDASxAhxhfJWEYVEDZ76uGL
         zfOyR/uxD56dk+0ifTymc8bE5vwUoaLJzLqHnv+ozpCnF3VTnEV8lML/2C4aVxZYdi
         kb2ZA3JEXmO3NvEwQRktN6dYHScazbUw9l6kfvMuu/XwbGxKOpTBA25aIxJlYJ7vLX
         7mUSAvtzKo0oPlxPEB831Y6x0rEuETqhbPckghqiIDtMj92D3QVuz2eaBDR5L6aBCy
         sUTltdVXW+QYA==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id EF1F2A006A;
        Tue,  7 Jan 2020 09:27:41 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 7 Jan 2020 01:27:36 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Tue, 7 Jan 2020 01:27:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AEN2Wayt6R5r9DT3Hyhh/wXASn4/lb97qKwZ0tofgsgnS2+7iUldwpcTFMwcZ6d8uSxXdul0c6Q38UaRECUeja3sEwXmKZX4KPNx3iBzjm8sS+iHMp+Mr+OPvgQ7YyNzG5RoldsjO/qQqMnTCl+7RKqgoklFRG857RkKBfZ18U8ZTvsWrlsbOt0mJzxIpP/Q0mfZSwdTFtOZnq8e1TuxjQiitevbAZ2CvHBTM5WtXomRo8bMZFvImPAqy2yWouyovOH1EUUrH+4wNaI/Bv3cpXjcIHFVdkb6MdhIofHTSuoTi6VDE7Ksmiekt2H0pjyFxbWBeDk/FbHaiWTstcMcow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oDwmH8jVjY2atKEOM8IHDNlOZYWAQMga7KJjpnmaQ+A=;
 b=TgxnkIAh2w7vCk1T+7LglE5mDiwymkxQAH1BF0stdmghYnciCmqe0xaz6ArmXdVFjHh23l9h0zfxG6OB5ISvmOaoGvmgHGXYPNFPmJz0K8+WwCrKeSDaEFY01kFaiPR52k0qKT4DAc2hD28327kV8H3/05/1X1L5H0CgPwq3HZ0ysc4yqFHVV7qhfhAY290gl016HDcrIoIrnWiapBptRoXx12pli4Uh2sSt+ngBTl0ieRnkqKFbmxhZOZoVY64mq1g7MO+ZVNZmR46EHLtJMj+4hnBgt+QKDFgpsZWTxtfR5TcFFeIl1ypl95dfr4bWtgVk5+n97boP+mpx2gA27g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oDwmH8jVjY2atKEOM8IHDNlOZYWAQMga7KJjpnmaQ+A=;
 b=kfbRau6Q/qtr5r8jZEWx+pzIg174kjASS2i7W+qChTaxyInYv7MMa/kCS6qL9ykrQe2mSQHdGlJ6Hs2nReDqzIAf4m0GsZyoo+tFN+CyCG14YYKNWXp8jmoAxarhKCIMzyafNBT1AqBp1MPcRZXPTi6jfmBVVfBaVDoHlpLClcQ=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3235.namprd12.prod.outlook.com (20.179.67.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.15; Tue, 7 Jan 2020 09:27:34 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c62:b247:6963:9da2]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c62:b247:6963:9da2%6]) with mapi id 15.20.2602.015; Tue, 7 Jan 2020
 09:27:34 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Murali Karicheri <m-karicheri2@ti.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Joao Pinto <Joao.Pinto@synopsys.com>,
        David Ahern <dsahern@gmail.com>
Subject: RE: [PATCH iproute2-next] taprio: Add support for the SetAndHold and
 SetAndRelease commands
Thread-Topic: [PATCH iproute2-next] taprio: Add support for the SetAndHold and
 SetAndRelease commands
Thread-Index: AQHVtOPaDcyycxk/7Eqs7zmpoaCgzqfAhW2AgAAAN3CAGRmjAIAD3NaQ
Date:   Tue, 7 Jan 2020 09:27:34 +0000
Message-ID: <BN8PR12MB3266149B178B38583E35D18AD33F0@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <060ba6e2de48763aec25df3ed87b64f86022f8b1.1576591746.git.Jose.Abreu@synopsys.com>
 <874kxxck0m.fsf@linux.intel.com>
 <BN8PR12MB3266C894D60449BD86E7CE69D3530@BN8PR12MB3266.namprd12.prod.outlook.com>
 <a911e7b4-bb62-8dfb-43cb-ee6ff78c9415@ti.com>
In-Reply-To: <a911e7b4-bb62-8dfb-43cb-ee6ff78c9415@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 032a30ee-c42f-4141-dcc9-08d79353d40e
x-ms-traffictypediagnostic: BN8PR12MB3235:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB3235F4977A256B4B4CD57F7DD33F0@BN8PR12MB3235.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-forefront-prvs: 027578BB13
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(136003)(39860400002)(376002)(346002)(189003)(199004)(55016002)(4326008)(2906002)(52536014)(66556008)(9686003)(86362001)(33656002)(316002)(5660300002)(71200400001)(54906003)(110136005)(186003)(8936002)(64756008)(66446008)(81166006)(966005)(81156014)(8676002)(6506007)(478600001)(76116006)(7696005)(66946007)(26005)(66476007);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3235;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: d13bgT3QFcqd1eJBeSdjvji+3KgLsbjAqTS9JucoE2t0WzV1TXY2dbEO7m8aOO+EtJwo6qFFMS6+x9/Op7GaUwjAqkMxBR8J8AP+ICWsKUy5Iwl3nBXG0fqZMC9LCJ9wG4KJyBpoEM9qiBvNCcQMaJpW3+nav0W35QkyWiCIfWudnkAZS/ESdUvRx4pA9mbLWpK7QHDEcSw5f+q1aA9LEBqg5gDZEZjut52naq1m2jyhyC9D9G9eLvJ74VnNsQJAL7YV3LoEIN/la9mrrGTyUz3xoyWxJBqFPTive13DCsXirkJJ5dQHYQl6GJ2Y8Lm+wEdwuePTtHojp344e/4osB9tb8Zn4xichNdiOBI5OeGClDPM5qrAE3fEFnlqWMyeWorcHtLfe7tREfH6XC63dfEhsSMErh7bCDSecQfr8ujVw5GUog9A60XQR0SR28Y9A1ihQi5TPtVKmxp+0KwHzwfZQcipIwQh/gRmVMUhBWbrPa0yUDKQiiwhvQ5rHilpK/lpp9m/7HcnnpzC9I3y2Q==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 032a30ee-c42f-4141-dcc9-08d79353d40e
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2020 09:27:34.4857
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VJc0a8yHX7rTwmyDP1J8D9mcw/rslZQ6Br0x+CjOaw3NLpLJ+UUW88NJdyvFilolIsBKP7J7vwqROuRFV5vzRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3235
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogTXVyYWxpIEthcmljaGVyaSA8bS1rYXJpY2hlcmkyQHRpLmNvbT4NCkRhdGU6IEphbi8w
My8yMDIwLCAyMjoyNDoxNCANCihVVEMrMDA6MDApDQoNCj4gU28geW91IGhhdmUgb25lIHNjaGVk
IGVudHJ5IHRoYXQgc3BlY2lmeSBTZXRBbmRIb2xkIGZvciBhbGwgcmVtYWluaW5nDQo+IHF1ZXVl
cy4gU28gdGhpcyBtZWFucywgcXVldWUgMCB3aWxsIG5ldmVyIGdldCBzZW50LiBJIGd1ZXNzIHlv
dSBhbHNvDQo+IHN1cHBvcnQgU2V0QW5kUmVsZWFzZSBzbyB0aGF0IGEgbWl4IG9mIFNldEFuZEhv
bGQgZm9sbG93ZWQgYnkgDQo+IFNldEFuZFJlbGVhc2UgY2FuIGJlIHNlbnQgdG8gZW5hYmxlIHNl
bmRpbmcgZnJvbSBRdWV1ZSAwLiBJcyB0aGF0DQo+IGNvcnJlY3Q/DQo+IA0KPiBTb21ldGhpbmcg
bGlrZQ0KPiAgICAgICAgICAgICAgICBzY2hlZC1lbnRyeSBIIDAyIDMwMDAwMCBcIDw9PT0gMzAw
IHVzZWMgdHggZnJvbSBRMQ0KPiAgICAgICAgICAgICAgICBzY2hlZC1lbnRyeSBSIDAxIDIwMDAw
MCAgIDw9PT0gMzAwIHVzZWMgdHggZnJvbSBRMA0KPiANCj4gSnVzdCB0cnlpbmcgdG8gdW5kZXJz
dGFuZCBob3cgdGhpcyBpcyBiZWluZyB1c2VkIGZvciByZWFsIHdvcmxkDQo+IGFwcGxpY2F0aW9u
Lg0KDQpUaGlzIGlzIHRoZSBjb21tYW5kIEkgdXNlOg0KDQojIHRjIHFkaXNjIGFkZCBkZXYgJGlu
dGYgaGFuZGxlIDEwMDogcGFyZW50IHJvb3QgdGFwcmlvIFwNCgludW1fdGMgNCBcDQoJbWFwIDAg
MSAyIDMgMyAzIDMgMyAzIDMgMyAzIDMgMyAzIDMgXA0KCWJhc2UtdGltZSAkYmFzZSBcDQoJY3lj
bGUtdGltZSAxMDAwMDAwIFwNCglzY2hlZC1lbnRyeSBSIDAwIDEwMDAwMCBcDQoJc2NoZWQtZW50
cnkgSCAwMiAyMDAwMDAgXA0KCXNjaGVkLWVudHJ5IEggMDQgMzAwMDAwIFwNCglzY2hlZC1lbnRy
eSBIIDA4IDQwMDAwMCBcDQoJZmxhZ3MgMHgyDQojIHNsZWVwIDINCiMgaXBlcmYzIC1jIDxpcD4g
LXUgLWIgMCAtdCAxNSAmDQojIHNsZWVwIDUNCiMgZWNobyAiUXVldWUgMzogRXhwZWN0ZWQ9NDAl
LCBRdWV1ZSAwIHdpbGwgbm93IGJlIHByZWVtcHRlZCINCiMgdHBlcmYgLWkgPGV0aFg+IC1wIDMN
Cg0KVGhpcyB3aWxsIGJhc2ljYWxseSBwcmVlbXB0IFF1ZXVlIDAgYW5kIGZsb29kIFF1ZXVlIDMg
d2l0aCBleHByZXNzIA0KdHJhZmZpYy4NCg0KWW91IGNhbiBmaW5kIHRwZXJmIHV0aWxpdHkgaGVy
ZTogaHR0cHM6Ly9naXRodWIuY29tL2pvYWJyZXUvdHBlcmYNCg0KLS0tDQpUaGFua3MsDQpKb3Nl
IE1pZ3VlbCBBYnJldQ0K
