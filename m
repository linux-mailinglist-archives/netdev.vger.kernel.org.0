Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 593236E5C0
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 14:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728401AbfGSMce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 08:32:34 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:51798 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727552AbfGSMcd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 08:32:33 -0400
Received: from mailhost.synopsys.com (dc8-mailhost1.synopsys.com [10.13.135.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 3BBBBC1209;
        Fri, 19 Jul 2019 12:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1563539553; bh=7sVAAiGZ/s55lSrCYYpAvry70xJ3xySac7phzM1rsAs=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=R65QxYLYPItpY9kwjif5BUnzmJBK5oVtFmtaeRC2JHkaO1xPBE2uIe1w/po/l0zHX
         IFuOaa34qFlB6APFRPU6TVrbY6Rjjj6+G8Fv/vKXniJs/H/vjFtnuMoOIu6ecUoFLw
         q4k+Dbn8FKwdZnHYr269LsdZe1br6jn9Gcxv8/+WwuWQs9Cfq6EhaBCRc6tsYOMzI+
         OZGsHy42S0Je1IvIk0DgYB+kx/yJDx4qDuMVrmy+triniDdkubZ9Noy/UhFbTGZUHy
         5YUhre3DP6RAQgl5A9+u6YYmZ2zNG+btzpUjYOnmFq8RWNyQYfcfhRHVopSbcxyFei
         Tj/NPZPXUo1wg==
Received: from US01WEHTC2.internal.synopsys.com (us01wehtc2.internal.synopsys.com [10.12.239.237])
        (using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 5AEF7A023C;
        Fri, 19 Jul 2019 12:32:32 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC2.internal.synopsys.com (10.12.239.237) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Fri, 19 Jul 2019 05:32:29 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Fri, 19 Jul 2019 05:32:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lmejooTNVGpkM7f4g2X/mfH8GCBKJCK4luAw7KLz9IWJdpAvcKr/mS3bMy+TAR6gtpxt1TGBf1j1aFxKaPlf1LDInYKXmdzGmtq8/vHNX6vIooDQw/z4W/29yyXHSJmhME3ka8NzlXAcrGzj15d9+Kp4AHyWmw95EwyzjUNz1x9ymfKnIbEJzvhnkHKI3eg2tBZWrBTIl066hRdD3ACplNEnt/YKFhrd79MjfpqiO+6BuX0+0ixWNX/5Xc1TAEPzJBzUiayupgfDSfyW+Dq9zBGETOHhqzB8HflZXOZ5UyzwQgfzJGk0MbWZaxcAGaPKTam/DFI+4rQlQSajBNL66A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7sVAAiGZ/s55lSrCYYpAvry70xJ3xySac7phzM1rsAs=;
 b=Z/6BXQnXz232ofYAjeyek5bXoQmEgEoVEHGhzYrd7m9C35QdHD5Eq4Cp7G3itWXTg1XWWTWAotXhyWairJdPTupvJJDJ5wX6WIag4GaAVwhSqyAAZCdzBYWztI0Rscn0xfepTpjrCGcWHbHFf0aheVlr8hq8r69qbv+1yw1mTIZ2ZWFDjWrxh2OzQYGBYlGbBlB/Oz96A3BkBGloaPP3KSHY6w7B2x4a9rdR9//6HY4uYDUQA383plXu3tyL0q63TzyV6oSxuLOhplMpLCFAlETZF7Tmp+eCHFxJmKFuTxKtUi2E8smfZ67Cb1ZgdARFAR58r+zfRojnEWetpyWXsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=synopsys.com;dmarc=pass action=none
 header.from=synopsys.com;dkim=pass header.d=synopsys.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector1-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7sVAAiGZ/s55lSrCYYpAvry70xJ3xySac7phzM1rsAs=;
 b=j0i9fkRSQMBK1n2CbJlbL8P6kUXOw8FDqz2kRHnq43PI3ZO8Bl7S0PGo5ynJPFXI5aXDzGAaYMWScvlAvWn8mvERRxi7OWlZJlxCKc8cVCpK6yYLPBqdE4r+GQ3TTooNHzoZv/uSofipjIlZOo8lUAmLsTEK43nMibLQPRD9lOQ=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.66.159) by
 BN8PR12MB2948.namprd12.prod.outlook.com (20.179.67.78) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Fri, 19 Jul 2019 12:32:27 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::61ef:5598:59e0:fc9d]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::61ef:5598:59e0:fc9d%5]) with mapi id 15.20.2073.012; Fri, 19 Jul 2019
 12:32:27 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Jon Hunter <jonathanh@nvidia.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
CC:     Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: RE: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
Thread-Topic: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
Thread-Index: AQHVMYtq2Zx4WVoG/U2kL8GCK0bP/abPQEOAgADTx+CAABvLAIABeX5ggAAOFICAAAG4AIAAAXQAgAAaB/CAACO4AIAAAIsA
Date:   Fri, 19 Jul 2019 12:32:27 +0000
Message-ID: <BN8PR12MB3266E1FAC5B7874EFA69DD7BD3CB0@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <cover.1562149883.git.joabreu@synopsys.com>
 <1b254bb7fc6044c5e6e2fdd9e00088d1d13a808b.1562149883.git.joabreu@synopsys.com>
 <29dcc161-f7c8-026e-c3cc-5adb04df128c@nvidia.com>
 <BN8PR12MB32661E919A8DEBC7095BAA12D3C80@BN8PR12MB3266.namprd12.prod.outlook.com>
 <6a6bac84-1d29-2740-1636-d3adb26b6bcc@nvidia.com>
 <BN8PR12MB3266960A104A7CDBB4E59192D3CB0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <bc9ab3c5-b1b9-26d4-7b73-01474328eafa@nvidia.com>
 <BN8PR12MB3266989D15E017A789E14282D3CB0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <4db855e4-1d59-d30b-154c-e7a2aa1c9047@nvidia.com>
 <BN8PR12MB3266FD9CF18691EDEF05A4B8D3CB0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <64e37224-6661-ddb0-4394-83a16e1ccb61@nvidia.com>
In-Reply-To: <64e37224-6661-ddb0-4394-83a16e1ccb61@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: de294b17-a456-4d1b-ae46-08d70c4528c9
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN8PR12MB2948;
x-ms-traffictypediagnostic: BN8PR12MB2948:
x-microsoft-antispam-prvs: <BN8PR12MB29485A2B3FA14A33DD31893BD3CB0@BN8PR12MB2948.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:466;
x-forefront-prvs: 01039C93E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(346002)(376002)(39860400002)(136003)(199004)(189003)(66556008)(66446008)(102836004)(4744005)(4326008)(68736007)(52536014)(64756008)(66476007)(186003)(110136005)(316002)(256004)(26005)(66946007)(54906003)(2201001)(81156014)(81166006)(99286004)(76116006)(8936002)(14454004)(76176011)(11346002)(446003)(476003)(486006)(33656002)(2501003)(7696005)(66066001)(6506007)(3846002)(6116002)(71200400001)(74316002)(478600001)(6436002)(55016002)(305945005)(9686003)(6246003)(7736002)(229853002)(25786009)(86362001)(53936002)(71190400001)(5660300002)(8676002)(7416002)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB2948;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: IQnE3AzJhV70P5CnW73oOjYCbpmRcbf0hRVRHyC+yOacxuJoZUQff1My+FF59e/tXILzeHbo4qAeeUTNKV3IYY/y1kjEGecF0CvZJapQOoClsSDT2LARTenntApbi7cXcv1TD4y8O+ohYBOmO9Q1uT9rPa2c2kOgeg/yXYV2A8LVnWSUYujX9WyPaHmlQI5QgBSy/me5Eqniywuf2aSXBlTZRfsV+LVsGgkQYJ0iO3mh4jLtV9wSptIeb6vNNdRUjQ38zQrqDRfqa8uD32wr9aA/LJOZIf6eLkxsbc2v/NbJ68JIlNA1zkNHTtQqduBEJyE1ieDlyPJGfuO9kY8KOnEU6WNDOhT8Y2heJtF0P2Dh3jdaNTFYJUfzz1kw+MuwbHF4LSPWJfcA9SXfujAbeeqyzvkHd3IgRgtBZN31K+M=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: de294b17-a456-4d1b-ae46-08d70c4528c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2019 12:32:27.1567
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: joabreu@synopsys.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB2948
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSm9uIEh1bnRlciA8am9uYXRoYW5oQG52aWRpYS5jb20+DQpEYXRlOiBKdWwvMTkvMjAx
OSwgMTM6MzA6MTAgKFVUQyswMDowMCkNCg0KPiBJIGJvb3RlZCB0aGUgYm9hcmQgd2l0aG91dCB1
c2luZyBORlMgYW5kIHRoZW4gc3RhcnRlZCB1c2VkIGRoY2xpZW50IHRvDQo+IGJyaW5nIHVwIHRo
ZSBuZXR3b3JrIGludGVyZmFjZSBhbmQgaXQgYXBwZWFycyB0byBiZSB3b3JraW5nIGZpbmUuIEkg
Y2FuDQo+IGV2ZW4gbW91bnQgdGhlIE5GUyBzaGFyZSBmaW5lLiBTbyBpdCBkb2VzIGFwcGVhciB0
byBiZSBwYXJ0aWN1bGFyIHRvDQo+IHVzaW5nIE5GUyB0byBtb3VudCB0aGUgcm9vdGZzLg0KDQpE
YW1uLiBDYW4geW91IHNlbmQgbWUgeW91ciAuY29uZmlnID8NCg0KLS0tDQpUaGFua3MsDQpKb3Nl
IE1pZ3VlbCBBYnJldQ0K
