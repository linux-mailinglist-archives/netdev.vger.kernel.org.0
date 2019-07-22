Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F28A8701A1
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 15:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729877AbfGVNsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 09:48:16 -0400
Received: from mail-eopbgr00061.outbound.protection.outlook.com ([40.107.0.61]:22454
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727805AbfGVNsP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jul 2019 09:48:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KeSbYSJul9r2fXsJYxHOx2Y8CX0KfDov2P7DPO6F6Eg=;
 b=7cfIpgVtBjN7AyCrCjKLHejB/e9EFKkvDdN59FIzvXBpSNBmQRY9IpoPley7ASSTjUiofItu9YQ33Ru9qz1MF2PzDhjbyK7zxtmsQ7Na740yGW8rvl6aLYF1FakV5QRBeeRndX/LukrOeZkPyPMS86xv7XGuw6/Q9pe3/ZWm9Rk=
Received: from VE1PR08CA0010.eurprd08.prod.outlook.com (2603:10a6:803:104::23)
 by AM0PR08MB4947.eurprd08.prod.outlook.com (2603:10a6:208:158::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2094.16; Mon, 22 Jul
 2019 13:48:07 +0000
Received: from DB5EUR03FT054.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e0a::201) by VE1PR08CA0010.outlook.office365.com
 (2603:10a6:803:104::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2094.12 via Frontend
 Transport; Mon, 22 Jul 2019 13:48:07 +0000
Authentication-Results: spf=temperror (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=temperror action=none
 header.from=arm.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of arm.com: DNS Timeout)
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT054.mail.protection.outlook.com (10.152.20.248) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2052.18 via Frontend Transport; Mon, 22 Jul 2019 13:48:06 +0000
Received: ("Tessian outbound cb57de15885d:v24"); Mon, 22 Jul 2019 13:48:05 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 8a87eab828ea6364
X-CR-MTA-TID: 64aa7808
Received: from fdba64b71de8.1 (cr-mta-lb-1.cr-mta-net [104.47.13.51])
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id BB1B8B51-976D-4802-86E4-5145A95F06A6.1;
        Mon, 22 Jul 2019 13:48:00 +0000
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04lp2051.outbound.protection.outlook.com [104.47.13.51])
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id fdba64b71de8.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384);
    Mon, 22 Jul 2019 13:48:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ng1OoFiOMWHWpWg7xD8r1PbS27j9K9TA/mMiWxxxAFYyzhX9JE5ub9/vUvPHwf3ufUzY4hCET52qsLtLd8BjknaVbQgFJSTPPN6HMAQB8EjU1PRXw/McyGFEwclD/EzlqV0IPV8pv66s7j15nSmG1VXKKY/xYZDin59o61Q/5fhqu7CsoOzYHKdj0yh2vtHRg1mq8/xCpHOMThvcDxRaIT5jmqQ/i4pMvDBDNNHYLJtdvqb2iUWlhNVEFXeVyhJsYQxmrYRH4xMu+LqU63sHaD0Kw6ZTFX0w+wsmm6eZrNfc/Y+efcvS7RHpWkOGX4/ultH9CVcw1+HHaWhgBPjvGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KeSbYSJul9r2fXsJYxHOx2Y8CX0KfDov2P7DPO6F6Eg=;
 b=eA0Pyucw1zcVvy6FckOWkF5PVxmWW7y5YlCwBlQdeWFrB1o0JeZy8q5oYE7TDUCTAWhkQrsna3alaP9cdQaWhTrO6XTOEg9WgLaiSjsu4aT/Xo9ksyk3L8fEIpKRtxyabrvm9z/NlF56PPso94OdJtuDVS2lntj/+3eZavupJB+4/bkeJpA87ZVh9W+d6KewLqVbwAJCSxgRbpK5VO4uKSzWIaMZsBxnfFMAaSzq8wu8Euj1upa/0lx5cbpamqSdPYFbNZ9tp1WvY0kJhLuhkFhpWu9P5KfGAgnYi1OocFgHR4FX4khq8nutCYI+VmSP1NrTvtwtqm6tOvg20M4ekQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=arm.com;dmarc=pass action=none header.from=arm.com;dkim=pass
 header.d=arm.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KeSbYSJul9r2fXsJYxHOx2Y8CX0KfDov2P7DPO6F6Eg=;
 b=7cfIpgVtBjN7AyCrCjKLHejB/e9EFKkvDdN59FIzvXBpSNBmQRY9IpoPley7ASSTjUiofItu9YQ33Ru9qz1MF2PzDhjbyK7zxtmsQ7Na740yGW8rvl6aLYF1FakV5QRBeeRndX/LukrOeZkPyPMS86xv7XGuw6/Q9pe3/ZWm9Rk=
Received: from AM4PR0802MB2371.eurprd08.prod.outlook.com (10.172.217.23) by
 AM4PR0802MB2291.eurprd08.prod.outlook.com (10.172.217.150) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Mon, 22 Jul 2019 13:47:58 +0000
Received: from AM4PR0802MB2371.eurprd08.prod.outlook.com
 ([fe80::5d45:7f25:b478:3e8b]) by AM4PR0802MB2371.eurprd08.prod.outlook.com
 ([fe80::5d45:7f25:b478:3e8b%3]) with mapi id 15.20.2094.013; Mon, 22 Jul 2019
 13:47:58 +0000
From:   Szabolcs Nagy <Szabolcs.Nagy@arm.com>
To:     Florian Weimer <fweimer@redhat.com>
CC:     nd <nd@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        GNU C Library <libc-alpha@sourceware.org>,
        Sergei Trofimovich <slyfox@gentoo.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        linux-man <linux-man@vger.kernel.org>
Subject: Re: [PATCH glibc] Linux: Include <linux/sockios.h> in <bits/socket.h>
 under __USE_MISC
Thread-Topic: [PATCH glibc] Linux: Include <linux/sockios.h> in
 <bits/socket.h> under __USE_MISC
Thread-Index: AQHVQID/UfNITT/bfE6+ZU8LnWDrF6bWge0AgAAjSICAAAEHCYAAAOSA
Date:   Mon, 22 Jul 2019 13:47:58 +0000
Message-ID: <086e5147-5bc7-2817-f295-357cb9a071ae@arm.com>
References: <87ftmys3un.fsf@oldenburg2.str.redhat.com>
 <CAK8P3a0hC4wvjwCi4=DCET3C4qARMY6c58ffjwG3b1ZPM6kr-A@mail.gmail.com>
 <2431941f-3aac-d31f-e6f5-8ed2ed7b2e5c@arm.com>
 <87lfwqqj3s.fsf@oldenburg2.str.redhat.com>
In-Reply-To: <87lfwqqj3s.fsf@oldenburg2.str.redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
x-originating-ip: [217.140.106.55]
x-clientproxiedby: LO2P265CA0411.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a0::15) To AM4PR0802MB2371.eurprd08.prod.outlook.com
 (2603:10a6:200:5d::23)
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Szabolcs.Nagy@arm.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: 7ddf18bd-399a-4127-29b3-08d70eab3972
X-MS-Office365-Filtering-HT: Tenant
X-Microsoft-Antispam-Untrusted: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0802MB2291;
X-MS-TrafficTypeDiagnostic: AM4PR0802MB2291:|AM0PR08MB4947:
X-Microsoft-Antispam-PRVS: <AM0PR08MB4947B50E3E6436402285C3ACEDC40@AM0PR08MB4947.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
x-ms-oob-tlc-oobclassifiers: OLM:8882;OLM:8882;
x-forefront-prvs: 01068D0A20
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(136003)(366004)(346002)(39860400002)(199004)(189003)(186003)(6246003)(86362001)(476003)(26005)(53936002)(2616005)(11346002)(446003)(76176011)(2906002)(6116002)(3846002)(256004)(52116002)(81166006)(81156014)(44832011)(386003)(486006)(65826007)(53546011)(478600001)(6506007)(102836004)(25786009)(14454004)(6916009)(229853002)(31696002)(36756003)(6512007)(58126008)(316002)(54906003)(71200400001)(8936002)(71190400001)(66066001)(65956001)(31686004)(65806001)(68736007)(4744005)(99286004)(64126003)(305945005)(7736002)(66946007)(66476007)(66556008)(8676002)(66446008)(64756008)(6436002)(6486002)(5660300002)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0802MB2291;H:AM4PR0802MB2371.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info-Original: Ro7UVNfpBJWZg2B6afFPh4h69Cy2WlWD/nNuMw0mzhIhSkmaXP8AohlemhN26KQTbaeJpNHy7vRLT5VmVAZD9xRPI1D/Iv9Oh+3irLumR2OSXvdZXAB++RC9FXbKmV2qV9IjRfFi+qcjssfMWJrI15VOmvKO+7WfXwvgpbpK8jpT0q5tKQRfm81lvOrmLD2iQHt6/3OLyJPhdKOGNFJYO7oOfjRSvCUsySjKmMzyPLVVOAf4BBHBi7L5bTydC5orq/IofQ4P6NYIbqLcj/YzSmV/e/vxHUQktidXsi3OYtTfCOXe6FlLR7twvSMrfGZdmSCCvp8Xt9WBSFCLfhObkDBdHsxd1Ge5LrnHLzytkL0l8OQn/ePGnsi18FL1d51pJgZPcKrzNBtTqYfj7uaARL1HO3/sUTBZjKLgSlBuG1Q=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3904A8F089A50B41BE225C167D471886@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0802MB2291
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Szabolcs.Nagy@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT054.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(376002)(346002)(39860400002)(2980300002)(199004)(189003)(6862004)(63350400001)(450100002)(47776003)(478600001)(63370400001)(186003)(8936002)(6246003)(26826003)(65956001)(66066001)(65806001)(4326008)(86362001)(26005)(81166006)(81156014)(11346002)(31696002)(8676002)(99286004)(6512007)(70206006)(102836004)(36756003)(486006)(14454004)(70586007)(446003)(50466002)(65826007)(6506007)(31686004)(53546011)(58126008)(356004)(2486003)(64126003)(23676004)(3846002)(386003)(76130400001)(2616005)(436003)(54906003)(316002)(126002)(476003)(7736002)(25786009)(305945005)(6486002)(336012)(76176011)(22756006)(5660300002)(229853002)(6116002)(4744005)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR08MB4947;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:TempError;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;A:1;MX:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 5fe834e8-8a56-4880-2320-08d70eab34b1
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(710020)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:AM0PR08MB4947;
NoDisclaimer: True
X-Forefront-PRVS: 01068D0A20
X-Microsoft-Antispam-Message-Info: hgSF+j2XHOWjUVCKkd/wAn6WdFMFxfMP3lu3tp9GR+7BrwBtq7oSb4WKfmgl3u7UIS9P6xhM6iSAuLmXAY7pVLKaFk4aBFa9r5shhLlhGhO/6mNyWuqrP44lmRMxssQLFGegrYDMh7YtCPZXeO/hqghUGRu6TNbLHKL4Vqw5uHexePVUfckX8sKfnXGkbl4s8YfciNU3Rb+HrhxH0htufqOCMCuaNhaMVCM9xNb6KWaGkiBuaopXOMc1o/oO/ECdrOIJ4SN+UmpAS3zbhZaGEyU+8nNJ/VFuPvXzFyRw3+lpLjYv2qAuQ/Zr3PZYAiBZHRqqyuSn0GMpcJjYZ6dVJAdd9JKRTyeP8b+ffGbr9jgms2NuQLSBBtni6FLJsrpKnqoEiVnLzFcoSJg5ZZfLK9mOHVRWWHuCEeJNUDz9XfY=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2019 13:48:06.1062
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ddf18bd-399a-4127-29b3-08d70eab3972
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB4947
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjIvMDcvMjAxOSAxNDo0NCwgRmxvcmlhbiBXZWltZXIgd3JvdGU6DQo+ICogU3phYm9sY3Mg
TmFneToNCj4gDQo+PiAobm90ZTogaW4gbXVzbCB0aGVzZSBpb2N0bCBtYWNyb3MgYXJlIGluIHN5
cy9pb2N0bC5oDQo+PiB3aGljaCBpcyBub3QgYSBwb3NpeCBoZWFkZXIgc28gbmFtZXNwYWNlIHJ1
bGVzIGFyZQ0KPj4gbGVzcyBzdHJpY3QgdGhhbiBmb3Igc3lzL3NvY2tldC5oIGFuZCB1c2VycyB0
ZW5kIHRvDQo+PiBpbmNsdWRlIGl0IGZvciBpb2N0bCgpKQ0KPiANCj4gPHN5cy9pb2N0bC5oPiBj
YW4gYmUgY29uZnVzaW5nIGJlY2F1c2Ugc29tZSBvZiB0aGUgY29uc3RhbnRzIG1heSBkZXBlbmQN
Cj4gb24gdHlwZXMgdGhhdCBhcmVuJ3QgZGVjbGFyZWQgYnkgaW5jbHVkaW5nIHRoZSBoZWFkZXIu
ICBUaGlzIG1ha2VzIHRoZWlyDQo+IG1hY3JvcyB1bnVzYWJsZS4gIERlZmluaW5nIGlvY3RsIGNv
bnN0YW50cyBpbiBoZWFkZXJzIHdoaWNoIGFsc28gcHJvdmlkZQ0KPiB0aGUgbWF0Y2hpbmcgdHlw
ZXMgYXZvaWRzIHRoYXQgcHJvYmxlbSBhdCBsZWFzdCwgYWxzbyBpdCBjYW4gaW50cm9kdWNlDQo+
IG5hbWVzcGFjZSBpc3N1ZXMuDQoNCnllYWgsIHRoZSB3YXkgd2UgZGVhbCB3aXRoIHRoYXQgaXMg
d2UgaGFyZCBjb2RlIHRoZSBudW1iZXJzDQpzaW5jZSB0aGUgc2l6ZSBvZiBzdHJ1Y3QgaXMgYWJp
LCB0aGV5IGNhbm5vdCBjaGFuZ2UuDQo=
