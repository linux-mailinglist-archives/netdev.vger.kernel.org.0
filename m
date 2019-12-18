Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF310124250
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 09:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbfLRI7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 03:59:31 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:33488 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725828AbfLRI7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 03:59:30 -0500
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 0C53BC0D6A;
        Wed, 18 Dec 2019 08:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1576659569; bh=Wg68L3GmWSmz35BwclTthU+bYBbHnd3AfeLWBJThot0=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=KZ5HH7qoxq13zyIcNpyGvlOx+YauOJwC0xPsyVIxN/5iyRKYWzqRbtIsXJmXzyEJq
         M9axgctV/e42BMYMb6MT/NMN6cMS7v86azpkwJnboT8Spzp56TnC4GDG5xoDcPWTzh
         jbCZ/tTQB8Q7Df4tmLwyX8oeL9AlH7oxs6Pv1twa9+LzW2qmkyu+v22Kmb+Q+WPfe4
         CM2MOGkjZ41vEzvYevRmBcl2fcKzSxskkou/gZ7ns2f+dqe3Vd4zzK6vCZEtzSUIr2
         NX8UPajDWmV7lXt6xtVlP1qda33Et9Xm3lWBoR441u+NuyRjCYzwGx2aU0R5ic+Laz
         LUp1AIgY9cHlg==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 7C28BA008A;
        Wed, 18 Dec 2019 08:59:28 +0000 (UTC)
Received: from us01hybrid1.internal.synopsys.com (10.200.27.51) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 18 Dec 2019 00:59:20 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.200.27.51) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Wed, 18 Dec 2019 00:59:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LtD4ffoOV46R7ZSJyS5P3tgvtQrs/8njNVPioHh5COsMSC82CPb9TgSo/Ck7hWUxVm1HjMw2MEYTzy/Lz1/9SNYWkJFPazyYX+5FwnDM7nMrqiNBSUZbLDCPBo5F2KMQAQpEIzfeHVjfmAMFu2cmJ5O1bRZ84Eg5GsRHO2XypSXSPKi+9atpOIZk+3jT9H8MqDdffA2HWbcONOq2nkjG8VkiogvxbYbAid8eRotCcVPcfOXU35OGwswKsmwVgzUL8IQASAVMiF1ArwIcO2WPGdGQq+tiNx0z4kzFX8bOju8QEhqEQaN5KHULLvMHum+V7Sdj04by30SoEK8Kg3Eu4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wg68L3GmWSmz35BwclTthU+bYBbHnd3AfeLWBJThot0=;
 b=Rk/7djVBHJ3nDuA3vom4dDxFDOfPz7EoEqRGUqDbiERqB4iL0ox7d22G04BRAYJcx5MPdRQweNiIADAVE+bfDeCjAGnIaiqNk24B+hBNvewetsyq+7/qlQ3kVEWfJJ/roWMEqX2hFTkK92ygfXxKyH+GrZ457/adY/PsjQ9RmnY3SzwbfwIOBIQ8w/Yw+FH4OAzmDkfgRNcAWovNUbww8jhBAeYTtKCaZ3gG3k0YJtBPrC/l2lVZNWxkyDtLvHiVEXmdq3HZVTteWnK0RiG70RoGLT3sVqoN5YtcwJg47POM/qlitqRKGqSQB4SRdMwGqkYyo163GYjJc/bSkra7Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wg68L3GmWSmz35BwclTthU+bYBbHnd3AfeLWBJThot0=;
 b=Pv3sypQYOSDSrKnC3Qmk2lljU7BlkXDTE0GXTUH3ky0P1xYDN8LkHK0qT/mEYGwo3IRt9G/G23kBJdRDPPoPMT28ZBDQR4yP2M925EQ5PhPUrAyARImDhfxaCL2LWVkrEguFpxciiYR93eSckZ9Owg1MycVS7oTQB39fshHDwgw=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3218.namprd12.prod.outlook.com (20.179.66.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.14; Wed, 18 Dec 2019 08:59:18 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::3d20:3a36:3b64:4510]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::3d20:3a36:3b64:4510%7]) with mapi id 15.20.2559.012; Wed, 18 Dec 2019
 08:59:18 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Andre Guedes <andre.guedes@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        David Ahern <dsahern@gmail.com>
Subject: RE: [PATCH iproute2-next] taprio: Add support for the SetAndHold and
 SetAndRelease commands
Thread-Topic: [PATCH iproute2-next] taprio: Add support for the SetAndHold and
 SetAndRelease commands
Thread-Index: AQHVtOPaDcyycxk/7Eqs7zmpoaCgzqe+10MAgADBSZA=
Date:   Wed, 18 Dec 2019 08:59:17 +0000
Message-ID: <BN8PR12MB32662A1E9BEE7C9243AA5671D3530@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <060ba6e2de48763aec25df3ed87b64f86022f8b1.1576591746.git.Jose.Abreu@synopsys.com>
 <157661793667.26178.2900020767109305347@aguedesl-mac01.jf.intel.com>
In-Reply-To: <157661793667.26178.2900020767109305347@aguedesl-mac01.jf.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 71ce46f8-82c9-486d-2bf1-08d7839890cf
x-ms-traffictypediagnostic: BN8PR12MB3218:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB3218C8CEA702DA58CC3E86F7D3530@BN8PR12MB3218.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1148;
x-forefront-prvs: 0255DF69B9
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(39860400002)(366004)(396003)(346002)(136003)(199004)(189003)(478600001)(26005)(81156014)(81166006)(86362001)(316002)(6506007)(33656002)(55016002)(52536014)(54906003)(64756008)(66446008)(4744005)(66946007)(110136005)(9686003)(66556008)(66476007)(5660300002)(7696005)(76116006)(8676002)(4326008)(186003)(8936002)(2906002)(71200400001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3218;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PrtS0ACh8Mv/QeuKVtIdVczRSenrY8VMGYjJGED+SeuTj4D71X5yntLrh7CWVUtNdrUH6pgE2hlrrv/kmScSVf0DnmYZQE9EKlTpKH//Glvey2oTdfOExGbhOl7/DCugr9Af2JnmT/Q2Sc8eCCsnCmhUsF9xHxBnzG2TNU0CNDy7zXyvS+A4pAgiyw0Vu/ccM3eEEA1TjY2LQ/Q/2L+T4f0JinqCWcJVwnEnMvWoadPHTIoxrmKroBdQ7CES9wKhA8LReuYZdfXWSeRkImdDWP+rFsfOfk+37e0tDhl65tGekp1wB7l3jGkT5+kFATZP+HDAOWR/Rfnl6LnF09JNmEvum8YNtDatyJRzAibdsyq4vE0Q0sR9d5wWYGVALNovQinW/4OvPMCFbvFM6CyFfJTYfQ1a+qbXvCcEveMNfAI94PGNos+1ZXzFLRz322T7
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 71ce46f8-82c9-486d-2bf1-08d7839890cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2019 08:59:17.9940
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XOLAZrDkw1q49XHtFApYgZZlJfs4koSQ2/xHwgHyU3L/PgSstsauhIkUCh0wK6Moug4Y6p+vqv/5avZ10sXIHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3218
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQW5kcmUgR3VlZGVzIDxhbmRyZS5ndWVkZXNAbGludXguaW50ZWwuY29tPg0KRGF0ZTog
RGVjLzE3LzIwMTksIDIxOjI1OjM2IChVVEMrMDA6MDApDQoNCj4gRnJvbSB0aGUgY29tbWl0IG1l
c3NhZ2UsIEkgaGFkIHRoZSBpbXByZXNzaW9uIHRoYXQgSE9MRCBhbmQgUkVMRUFTRSBjb21tYW5k
cw0KPiBhcmUgc3VwcG9ydGVkIGJ5IFFvUyBhbmQgWEdNQUMzLiBIb3dldmVyLCBpbiAnW1BBVENI
IG5ldC1uZXh0IHYyIDcvN10gbmV0Og0KPiBzdG1tYWM6IEludGVncmF0ZSBFU1Qgd2l0aCBUQVBS
SU8gc2NoZWR1bGVyIEFQSScgSSBzZWU6DQo+IA0KPiArICAgICAgICAgICAgICAgaWYgKHFvcHQt
PmVudHJpZXNbaV0uY29tbWFuZCAhPSBUQ19UQVBSSU9fQ01EX1NFVF9HQVRFUykNCj4gKyAgICAg
ICAgICAgICAgICAgICAgICAgcmV0dXJuIC1FT1BOT1RTVVBQOw0KPiANCj4gQW0gSSBtaXNzaW5n
IHNvbWV0aGluZyBvciB0aGVzZSBjb21tYW5kcyBhcmUgaW5kZWVkIG5vdCBzdXBwb3J0ZWQgYnkg
U3lub3BzeXMNCj4gSVBzPw0KDQpJdHMgYWxyZWFkeSBzdXBwb3J0ZWQgaW50ZXJuYWxseSBidXQg
SSBqdXN0IGRpZG4ndCBhZGQgaXQgaW4gdGhlIHNlcmllcy4gDQpJJ2xsIHByb2JhYmx5IHNlbnQg
dGhlIEVTVCBhbmQgRlAgc3VwcG9ydCBpbiBhIGRpZmZlcmVudCBzZXJpZXMgdG9kYXkuDQoNCj4g
QW55aG93LCB0aGlzIHBhdGNoIG1ha2VzIHNlbnNlIHRvIG1lLg0KDQpUaGFua3MhDQoNCi0tLQ0K
VGhhbmtzLA0KSm9zZSBNaWd1ZWwgQWJyZXUNCg==
