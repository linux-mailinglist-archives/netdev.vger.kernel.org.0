Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D49E477A6E
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 17:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387856AbfG0P5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 11:57:08 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:42530 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728963AbfG0P5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 11:57:07 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id A600AC209A;
        Sat, 27 Jul 2019 15:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1564243026; bh=ssZifKqQmMnTel218LYjgT+EXxzqJ1ni3sEc6Ba8tGE=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=W6uE5o0/cztmrKprVvXNDgIbMKVgkLexGbsKDcTqBwA5alVpPWAEvGwXL8j9aPAaU
         r37Ah0RPIW0ftQA/3uNYwDWjtdqYUFifQxRrwX30ErWPwEsUWnl+jCPSE8cL+3lMDI
         pNEmCWbUA1peadIddX4vyBF8a6dYaK5c10HTjvthY0woKXSW+WIBK74y1jUs0mKMFm
         /qdmGmlOj0h7CIfqwfXa3QqS11Ze77PqzHf0BkD7cP2z8DOyUlY3GPzg3iWYPztze6
         5pmyXGPDnVljTfCBTiOyHr4T8sfKLILCWR+6gbO7Ccz6WIGDsBsoO12Gx3iWWimMsu
         evFlz6KvSd8Wg==
Received: from US01WEHTC2.internal.synopsys.com (us01wehtc2.internal.synopsys.com [10.12.239.237])
        (using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id C2CC3A00DB;
        Sat, 27 Jul 2019 15:56:57 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC2.internal.synopsys.com (10.12.239.237) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Sat, 27 Jul 2019 08:56:39 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Sat, 27 Jul 2019 08:56:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EJemhkHyFQSWwMGuNA+hWF1FsVi+jyRGT/9Scjyv6fWK1eZlvPVir9dvqCXvN/VZcXsPoNmO+Bh35u5wLjFTiFDZfweVxFGVLTO5hAFbeivktsC9TEg/L8wprHCL5WVug7pqZmXcC01ewg/538uBQ5Dghg2Mr5t3gRtPVbNmGcUPNvcyRDc/xOs4M7nZdrcMLMxsTdHH66X1pBzl19hOduhSGyL2NnHo63gezDZpHYSGFTHnlj7MtReP3mBvBPna288pB99vXUR87NFYrO1C5OzVqCIVOj6PF6UlW2z79oRnpTkv8483cfm6wtCtcMu88koPJ6fJHUGQYToB+EfTxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ssZifKqQmMnTel218LYjgT+EXxzqJ1ni3sEc6Ba8tGE=;
 b=NQPNYoh4Gui/YD84+AH8V98uh/QGi1jL08ykRXNduyswfKjChkJdjLs4HC6xugBYsv869UsOCQV3/4QwmYq4CA1Kt+PZ84e00Dl2BRr/ylJ9MoaFePVkx6Ju270iMec4LJkTfbC9tJaxhcrw9jpdKpGRf3lGtkEpyu2VNHR0wdNhpeSoI0XssVwfudQEzP96wjBEbIyhosxfPaWsWJO6ngUNFhKQyWywcSD7TEQKjNMETchr2hvXBOGgz/DnDLqxjoz2SdwFOGB7ebNkSAiCuKlmFy+rPOK8djLwu4TLlFO45cubT0uQe8xSCZvLJxpE+DGPL5wfwRPDNikzcqE11w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=synopsys.com;dmarc=pass action=none
 header.from=synopsys.com;dkim=pass header.d=synopsys.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector1-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ssZifKqQmMnTel218LYjgT+EXxzqJ1ni3sEc6Ba8tGE=;
 b=FAJrAd40/o2MlON4mpaa8/RsNY5bsi/23ny4vYjncV/4ETwj2yk74tPgpVlsifzQpGVgiSBuih6AhtlyYFA3CLOAWxHIeNn0GU7f/fYlf4YCQbbPYCISBjZVi9p76QqttE56f6ghXIZ6Rlh6yOfu+vhCZZ8H8QpvE7t3WuhWtm4=
Received: from BYAPR12MB3269.namprd12.prod.outlook.com (20.179.93.146) by
 BYAPR12MB3495.namprd12.prod.outlook.com (20.178.196.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.17; Sat, 27 Jul 2019 15:56:36 +0000
Received: from BYAPR12MB3269.namprd12.prod.outlook.com
 ([fe80::f5b8:ac6e:ea68:cb1c]) by BYAPR12MB3269.namprd12.prod.outlook.com
 ([fe80::f5b8:ac6e:ea68:cb1c%4]) with mapi id 15.20.2094.013; Sat, 27 Jul 2019
 15:56:36 +0000
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
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: RE: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
Thread-Topic: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
Thread-Index: AQHVMYtq2Zx4WVoG/U2kL8GCK0bP/abbdEOAgAAAgcCAABHmgIAADDMggAGB8wCAAa8dIA==
Date:   Sat, 27 Jul 2019 15:56:36 +0000
Message-ID: <BYAPR12MB326922CDCB1D4B3D4A780CFDD3C30@BYAPR12MB3269.namprd12.prod.outlook.com>
References: <cover.1562149883.git.joabreu@synopsys.com>
 <1b254bb7fc6044c5e6e2fdd9e00088d1d13a808b.1562149883.git.joabreu@synopsys.com>
 <7a79be5d-7ba2-c457-36d3-1ccef6572181@nvidia.com>
 <BYAPR12MB3269927AB1F67D46E150ED6BD3C10@BYAPR12MB3269.namprd12.prod.outlook.com>
 <9e695f33-fd9f-a910-0891-2b63bd75e082@nvidia.com>
 <BYAPR12MB3269B4A401E4DA10A07515C7D3C10@BYAPR12MB3269.namprd12.prod.outlook.com>
 <1e2ea942-28fe-15b9-f675-8d6585f9a33f@nvidia.com>
In-Reply-To: <1e2ea942-28fe-15b9-f675-8d6585f9a33f@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [198.182.37.200]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 950e8987-6b7c-4466-76df-08d712ab015b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR12MB3495;
x-ms-traffictypediagnostic: BYAPR12MB3495:
x-microsoft-antispam-prvs: <BYAPR12MB3495C71F998CB731400F1667D3C30@BYAPR12MB3495.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 01110342A5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(39850400004)(366004)(136003)(376002)(396003)(189003)(199004)(52314003)(256004)(2906002)(7696005)(53936002)(7416002)(76116006)(2501003)(55016002)(66446008)(71200400001)(66476007)(66556008)(229853002)(9686003)(6116002)(68736007)(64756008)(7736002)(66946007)(305945005)(14444005)(11346002)(76176011)(8936002)(71190400001)(6506007)(33656002)(486006)(66066001)(26005)(110136005)(186003)(2201001)(4326008)(14454004)(25786009)(6436002)(52536014)(476003)(54906003)(99286004)(316002)(86362001)(74316002)(53546011)(446003)(3846002)(8676002)(5660300002)(6246003)(102836004)(81166006)(81156014)(478600001)(440614002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR12MB3495;H:BYAPR12MB3269.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: fP01Bl5096/YJoQVT9jikcJAFEBdc/FPfKlsw2kChroRX3ZwJvmiHVAiIrkb64sPYxkXiTqNsfAZi4raG9DlxEPtXw1U4NldUrQ4XHxQ9k0dC9IREc1ZCepnYpWxh8P1vkANrPLfJwo1hLSeO/lcIWmshPXJLSTEdi/S3hNpTz61UcG3QSkOPBGj5Lwab48wGmTm2w17vKV+bYdew2ogLCHdKkd6svXpAk+0XJcq69zxfI/MRwklfH2fPaCvr8kygkUFjtvrLr4dFrcNuFmM57D/DTV72C6UDh2MwDcR1N8G89pP2/5rj+shQ6/zekV1F2I5VedXgBvPY6lbA2JY7OZg/HWs6/DXKfUcAaW+KZJeYULPjpuYlUpazqZrd2SZJG7P1QkQDEczwvVZbMPxQTZy6Ug2U9N6OMbwtiW0ru4=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 950e8987-6b7c-4466-76df-08d712ab015b
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jul 2019 15:56:36.6514
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: joabreu@synopsys.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3495
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSm9uIEh1bnRlciA8am9uYXRoYW5oQG52aWRpYS5jb20+DQpEYXRlOiBKdWwvMjYvMjAx
OSwgMTU6MTE6MDAgKFVUQyswMDowMCkNCg0KPiANCj4gT24gMjUvMDcvMjAxOSAxNjoxMiwgSm9z
ZSBBYnJldSB3cm90ZToNCj4gPiBGcm9tOiBKb24gSHVudGVyIDxqb25hdGhhbmhAbnZpZGlhLmNv
bT4NCj4gPiBEYXRlOiBKdWwvMjUvMjAxOSwgMTU6MjU6NTkgKFVUQyswMDowMCkNCj4gPiANCj4g
Pj4NCj4gPj4gT24gMjUvMDcvMjAxOSAxNDoyNiwgSm9zZSBBYnJldSB3cm90ZToNCj4gPj4NCj4g
Pj4gLi4uDQo+ID4+DQo+ID4+PiBXZWxsLCBJIHdhc24ndCBleHBlY3RpbmcgdGhhdCA6Lw0KPiA+
Pj4NCj4gPj4+IFBlciBkb2N1bWVudGF0aW9uIG9mIGJhcnJpZXJzIEkgdGhpbmsgd2Ugc2hvdWxk
IHNldCBkZXNjcmlwdG9yIGZpZWxkcyANCj4gPj4+IGFuZCB0aGVuIGJhcnJpZXIgYW5kIGZpbmFs
bHkgb3duZXJzaGlwIHRvIEhXIHNvIHRoYXQgcmVtYWluaW5nIGZpZWxkcyANCj4gPj4+IGFyZSBj
b2hlcmVudCBiZWZvcmUgb3duZXIgaXMgc2V0Lg0KPiA+Pj4NCj4gPj4+IEFueXdheSwgY2FuIHlv
dSBhbHNvIGFkZCBhIGRtYV9ybWIoKSBhZnRlciB0aGUgY2FsbCB0byANCj4gPj4+IHN0bW1hY19y
eF9zdGF0dXMoKSA/DQo+ID4+DQo+ID4+IFllcy4gSSByZW1vdmVkIHRoZSBkZWJ1ZyBwcmludCBh
ZGRlZCB0aGUgYmFycmllciwgYnV0IHRoYXQgZGlkIG5vdCBoZWxwLg0KPiA+IA0KPiA+IFNvLCBJ
IHdhcyBmaW5hbGx5IGFibGUgdG8gc2V0dXAgTkZTIHVzaW5nIHlvdXIgcmVwbGljYXRlZCBzZXR1
cCBhbmQgSSANCj4gPiBjYW4ndCBzZWUgdGhlIGlzc3VlIDooDQo+ID4gDQo+ID4gVGhlIG9ubHkg
ZGlmZmVyZW5jZSBJIGhhdmUgZnJvbSB5b3VycyBpcyB0aGF0IEknbSB1c2luZyBUQ1AgaW4gTkZT
IA0KPiA+IHdoaWxzdCB5b3UgKEkgYmVsaWV2ZSBmcm9tIHRoZSBsb2dzKSwgdXNlIFVEUC4NCj4g
DQo+IFNvIEkgdHJpZWQgVENQIGJ5IHNldHRpbmcgdGhlIGtlcm5lbCBib290IHBhcmFtcyB0byAn
bmZzdmVycz0zJyBhbmQNCj4gJ3Byb3RvPXRjcCcgYW5kIHRoaXMgZG9lcyBhcHBlYXIgdG8gYmUg
bW9yZSBzdGFibGUsIGJ1dCBub3QgMTAwJSBzdGFibGUuDQo+IEl0IHN0aWxsIGFwcGVhcnMgdG8g
ZmFpbCBpbiB0aGUgc2FtZSBwbGFjZSBhYm91dCA1MCUgb2YgdGhlIHRpbWUuDQo+IA0KPiA+IFlv
dSBkbyBoYXZlIGZsb3cgY29udHJvbCBhY3RpdmUgcmlnaHQgPyBBbmQgeW91ciBIVyBGSUZPIHNp
emUgaXMgPj0gNGsgPw0KPiANCj4gSG93IGNhbiBJIHZlcmlmeSBpZiBmbG93IGNvbnRyb2wgaXMg
YWN0aXZlPw0KDQpZb3UgY2FuIGNoZWNrIGl0IGJ5IGR1bXBpbmcgcmVnaXN0ZXIgTVRMX1J4UV9P
cGVyYXRpb25fTW9kZSAoMHhkMzApLg0KDQpDYW4geW91IGFsc28gYWRkIElPTU1VIGRlYnVnIGlu
IGZpbGUgImRyaXZlcnMvaW9tbXUvaW9tbXUuYyIgPw0KDQotLS0NClRoYW5rcywNCkpvc2UgTWln
dWVsIEFicmV1DQo=
