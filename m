Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48B5772DB3
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 13:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727514AbfGXLep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 07:34:45 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:60430 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727083AbfGXLep (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 07:34:45 -0400
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 3DEB4C0C24;
        Wed, 24 Jul 2019 11:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1563968084; bh=W2MXqvrO6iDlCAN/UEJX0xsEcjKjgQxZC+iRMsZ/Kn4=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=SF8ym/OrMgZJYRMlB1VkWmAefOgeL0gsWMlgnbpJBqjWjow0hMnstTwBJoT6DkKqc
         d0q74abRzAAbBgD5fnuikqEHROE8m6gA6NXeRCdSEZO1A8SflWRxAmnFTm+hwzOXBH
         GlfZ6NWmF2xpbkoacHxxkMH0mdzN6UfZVHMvtt//sleKY74eVuh/Fb/1ouzB3cljxz
         l6WHsvwF3hBZyrugFymp00ad7PtiE7me1i/Fdxrt0KoFAl6eh3kcbBk4vxzTcGFSMx
         fDfhEYPvW3GAuwyR6WDVDceL4tlYISybdVCh3DY/I6Vnr7RxoibFp5XA5JNn1O/9QN
         PIzmDXqRPMWzg==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id CE79DA006B;
        Wed, 24 Jul 2019 11:34:33 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 24 Jul 2019 04:34:28 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Wed, 24 Jul 2019 04:34:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D/p/HXeKnn0WDMdXN8x+jseBImFXcqgl4zzH0ENtyZ/aWQdcWwDMjIzJ/N0tW/eNAWoc7Wx6RxJXP3fA5FaReXUQ326R9TcJ8Z1XAoAcEyltcPDoeNGoiGrfw77Y3sdGiM/L0wUEXdCP2m1DBf3NTsg/qkkCRzLG2hEEYxHK+5Zq+vW1QoGUgCvu3YQGEy4/3qooKKvt0+HWhMK/ramj+xrFKCJP2bDsQp7mi27I98o+z3wdenae/LZwG9nMTqa+QzbugBZHPwQ6F2CIMxbsUBiuMP11IrLqalEIZ6hthbeWE7Xu5pZqCYcjgPRwuEie6/0f1XRwrz2UxPVigWNaAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W2MXqvrO6iDlCAN/UEJX0xsEcjKjgQxZC+iRMsZ/Kn4=;
 b=d3coYi05x80GUcgUjWfjOwRxQ0L1GLCuK1tLcBXcgWaF8XYROdTKUgZBC0/jDPs6rkRIDnWL3U44CDU8asi80jclJtroSaG1VDmo1m4Hv0AIN3SylVFSLq9CMiAFySD37FYaLF1KCIueNZ+SpRHXVqZwI8OZO1srHM5G9FKSpZoI8V8Gq3n0LH9o0Q+k9yJI9WJ75rt9t3jH0k6ftt6QxR3G9yB8cYA6uUlzlMMBzWjBN77NrTHhS/eLa+R3Dvtp1cmBRSzf7zaIc+C9bKH/Jyj0Ws1SIAghZmomjsplPVI/s9LkhHFP2FEfvQUZWCmSU2/eduOPamXTCFDvXojHYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=synopsys.com;dmarc=pass action=none
 header.from=synopsys.com;dkim=pass header.d=synopsys.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector1-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W2MXqvrO6iDlCAN/UEJX0xsEcjKjgQxZC+iRMsZ/Kn4=;
 b=YazhVwslzDD7+fDgd9gV+aaIBhY91B4izveFsVqUSIJg/ubjdw/tGtD5qhgqL6EmHpW4l5K08MerNWI0obUYa3LvOdWzl7pl8DwFVHeDKxyudAbvVxo8+eA61SXqsyW8g2oi4SQFp5FyUFJ5qWmpXlx5gfofydeFBQWgF6sNW8c=
Received: from BYAPR12MB3269.namprd12.prod.outlook.com (20.179.93.146) by
 BYAPR12MB2981.namprd12.prod.outlook.com (20.178.53.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Wed, 24 Jul 2019 11:34:26 +0000
Received: from BYAPR12MB3269.namprd12.prod.outlook.com
 ([fe80::f5b8:ac6e:ea68:cb1c]) by BYAPR12MB3269.namprd12.prod.outlook.com
 ([fe80::f5b8:ac6e:ea68:cb1c%4]) with mapi id 15.20.2094.013; Wed, 24 Jul 2019
 11:34:26 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Jon Hunter <jonathanh@nvidia.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
CC:     David Miller <davem@davemloft.net>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "lists@bofh.nu" <lists@bofh.nu>,
        "Joao.Pinto@synopsys.com" <Joao.Pinto@synopsys.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "maxime.ripard@bootlin.com" <maxime.ripard@bootlin.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "wens@csie.org" <wens@csie.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
Thread-Topic: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
Thread-Index: AQHVMYtq2Zx4WVoG/U2kL8GCK0bP/abPQEOAgADTx+CABnZ9AIAADuYAgAAFQOCAAAnIAIAABLTAgAFMy7CAAB4gAIAAAO7wgAAG6gCAABvPAIAAcGAAgADrmoCAAA0XIIAAA1AAgAAAhFCAABUsgIAABPNg
Date:   Wed, 24 Jul 2019 11:34:26 +0000
Message-ID: <BYAPR12MB32696F0A2BFDF69F31C4311CD3C60@BYAPR12MB3269.namprd12.prod.outlook.com>
References: <BYAPR12MB32692AF2BA127C5DA5B74804D3C70@BYAPR12MB3269.namprd12.prod.outlook.com>
 <6c769226-bdd9-6fe0-b96b-5a0d800fed24@arm.com>
 <8756d681-e167-fe4a-c6f0-47ae2dcbb100@nvidia.com>
 <20190723.115112.1824255524103179323.davem@davemloft.net>
 <20190724085427.GA10736@apalos>
 <BYAPR12MB3269AA9955844E317B62A239D3C60@BYAPR12MB3269.namprd12.prod.outlook.com>
 <20190724095310.GA12991@apalos>
 <BYAPR12MB3269C5766F553438ECFF2C9BD3C60@BYAPR12MB3269.namprd12.prod.outlook.com>
 <33de62bf-2f8a-bf00-9260-418b12bed24c@nvidia.com>
In-Reply-To: <33de62bf-2f8a-bf00-9260-418b12bed24c@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ac25b55d-2661-4e17-666a-08d7102ae208
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:BYAPR12MB2981;
x-ms-traffictypediagnostic: BYAPR12MB2981:
x-microsoft-antispam-prvs: <BYAPR12MB298134CEB1F689F0A70EEF97D3C60@BYAPR12MB2981.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0108A997B2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(136003)(396003)(346002)(366004)(39860400002)(189003)(199004)(20864003)(66946007)(76116006)(81166006)(66556008)(81156014)(8676002)(52536014)(5660300002)(14454004)(66446008)(4326008)(64756008)(3846002)(53936002)(9686003)(68736007)(8936002)(55016002)(6246003)(71190400001)(66476007)(186003)(229853002)(2906002)(478600001)(476003)(305945005)(71200400001)(7736002)(110136005)(316002)(54906003)(74316002)(102836004)(19627235002)(256004)(86362001)(6436002)(53546011)(66066001)(6116002)(11346002)(486006)(25786009)(33656002)(99286004)(6506007)(76176011)(7696005)(26005)(446003)(7416002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR12MB2981;H:BYAPR12MB3269.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: KmsRYGvimlHNzDBlH1Axage4DPz/EjcfncS/o397fyLDR39CYCp0fizzHxf+wmdauKFUdsBOf0bFDnFlF4FM8nCriCXGZUTrZHLyB0bdHpeYFLuBaRInalJNsYS/02yxrw8JveCmTlRJeg6GAHaVRx9tbJm5hDSLWXA1lzlmmmI1nnFHX1rNI5OnWkGQzNUkkpKKxXkqyOqzPHAEYOSTDvLaCsV0CldboptDdbD24FvYDrQaahA4nJBBfvDvEBEF9vL9tfbtifaZS7vdHe2wKneMRXHqL/DDRp7eaiD9KBP/h7iGP5RFePbYjflJDYIpgm811xhaR/Qk3ZF3MhjtX9ilgAv2LxLaM8OfRCplcoV1V7+uED1oVC1XlFHVR3IJVhDB7VLtYpQ4Wh83VwEFhXoAOIK8HSN05uM+wK2w72A=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ac25b55d-2661-4e17-666a-08d7102ae208
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2019 11:34:26.2457
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: joabreu@synopsys.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2981
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSm9uIEh1bnRlciA8am9uYXRoYW5oQG52aWRpYS5jb20+DQpEYXRlOiBKdWwvMjQvMjAx
OSwgMTI6MTA6NDcgKFVUQyswMDowMCkNCg0KPiANCj4gT24gMjQvMDcvMjAxOSAxMTowNCwgSm9z
ZSBBYnJldSB3cm90ZToNCj4gDQo+IC4uLg0KPiANCj4gPiBKb24sIEkgd2FzIGFibGUgdG8gcmVw
bGljYXRlIChhdCBzb21lIGxldmVsKSB5b3VyIHNldHVwOg0KPiA+IA0KPiA+ICMgZG1lc2cgfCBn
cmVwIC1pIGFybS1zbW11DQo+ID4gWyAgICAxLjMzNzMyMl0gYXJtLXNtbXUgNzAwNDAwMDAuaW9t
bXU6IHByb2JpbmcgaGFyZHdhcmUgDQo+ID4gY29uZmlndXJhdGlvbi4uLg0KPiA+IFsgICAgMS4z
MzczMzBdIGFybS1zbW11IDcwMDQwMDAwLmlvbW11OiBTTU1VdjIgd2l0aDoNCj4gPiBbICAgIDEu
MzM3MzM4XSBhcm0tc21tdSA3MDA0MDAwMC5pb21tdTogICAgICAgICBzdGFnZSAxIHRyYW5zbGF0
aW9uDQo+ID4gWyAgICAxLjMzNzM0Nl0gYXJtLXNtbXUgNzAwNDAwMDAuaW9tbXU6ICAgICAgICAg
c3RhZ2UgMiB0cmFuc2xhdGlvbg0KPiA+IFsgICAgMS4zMzczNTRdIGFybS1zbW11IDcwMDQwMDAw
LmlvbW11OiAgICAgICAgIG5lc3RlZCB0cmFuc2xhdGlvbg0KPiA+IFsgICAgMS4zMzczNjNdIGFy
bS1zbW11IDcwMDQwMDAwLmlvbW11OiAgICAgICAgIHN0cmVhbSBtYXRjaGluZyB3aXRoIDEyOCAN
Cj4gPiByZWdpc3RlciBncm91cHMNCj4gPiBbICAgIDEuMzM3Mzc0XSBhcm0tc21tdSA3MDA0MDAw
MC5pb21tdTogICAgICAgICAxIGNvbnRleHQgYmFua3MgKDAgDQo+ID4gc3RhZ2UtMiBvbmx5KQ0K
PiA+IFsgICAgMS4zMzczODNdIGFybS1zbW11IDcwMDQwMDAwLmlvbW11OiAgICAgICAgIFN1cHBv
cnRlZCBwYWdlIHNpemVzOiANCj4gPiAweDYxMzExMDAwDQo+ID4gWyAgICAxLjMzNzM5M10gYXJt
LXNtbXUgNzAwNDAwMDAuaW9tbXU6ICAgICAgICAgU3RhZ2UtMTogNDgtYml0IFZBIC0+IA0KPiA+
IDQ4LWJpdCBJUEENCj4gPiBbICAgIDEuMzM3NDAyXSBhcm0tc21tdSA3MDA0MDAwMC5pb21tdTog
ICAgICAgICBTdGFnZS0yOiA0OC1iaXQgSVBBIC0+IA0KPiA+IDQ4LWJpdCBQQQ0KPiA+IA0KPiA+
ICMgZG1lc2cgfCBncmVwIC1pIHN0bW1hYw0KPiA+IFsgICAgMS4zNDQxMDZdIHN0bW1hY2V0aCA3
MDAwMDAwMC5ldGhlcm5ldDogQWRkaW5nIHRvIGlvbW11IGdyb3VwIDANCj4gPiBbICAgIDEuMzQ0
MjMzXSBzdG1tYWNldGggNzAwMDAwMDAuZXRoZXJuZXQ6IG5vIHJlc2V0IGNvbnRyb2wgZm91bmQN
Cj4gPiBbICAgIDEuMzQ4Mjc2XSBzdG1tYWNldGggNzAwMDAwMDAuZXRoZXJuZXQ6IFVzZXIgSUQ6
IDB4MTAsIFN5bm9wc3lzIElEOiANCj4gPiAweDUxDQo+ID4gWyAgICAxLjM0ODI4NV0gc3RtbWFj
ZXRoIDcwMDAwMDAwLmV0aGVybmV0OiAgICAgRFdNQUM0LzUNCj4gPiBbICAgIDEuMzQ4MjkzXSBz
dG1tYWNldGggNzAwMDAwMDAuZXRoZXJuZXQ6IERNQSBIVyBjYXBhYmlsaXR5IHJlZ2lzdGVyIA0K
PiA+IHN1cHBvcnRlZA0KPiA+IFsgICAgMS4zNDgzMDJdIHN0bW1hY2V0aCA3MDAwMDAwMC5ldGhl
cm5ldDogUlggQ2hlY2tzdW0gT2ZmbG9hZCBFbmdpbmUgDQo+ID4gc3VwcG9ydGVkDQo+ID4gWyAg
ICAxLjM0ODMxMV0gc3RtbWFjZXRoIDcwMDAwMDAwLmV0aGVybmV0OiBUWCBDaGVja3N1bSBpbnNl
cnRpb24gDQo+ID4gc3VwcG9ydGVkDQo+ID4gWyAgICAxLjM0ODMyMF0gc3RtbWFjZXRoIDcwMDAw
MDAwLmV0aGVybmV0OiBUU08gc3VwcG9ydGVkDQo+ID4gWyAgICAxLjM0ODMyOF0gc3RtbWFjZXRo
IDcwMDAwMDAwLmV0aGVybmV0OiBFbmFibGUgUlggTWl0aWdhdGlvbiB2aWEgSFcgDQo+ID4gV2F0
Y2hkb2cgVGltZXINCj4gPiBbICAgIDEuMzQ4MzM3XSBzdG1tYWNldGggNzAwMDAwMDAuZXRoZXJu
ZXQ6IFRTTyBmZWF0dXJlIGVuYWJsZWQNCj4gPiBbICAgIDEuMzQ4NDA5XSBsaWJwaHk6IHN0bW1h
YzogcHJvYmVkDQo+ID4gWyA0MTU5LjE0MDk5MF0gc3RtbWFjZXRoIDcwMDAwMDAwLmV0aGVybmV0
IGV0aDA6IFBIWSBbc3RtbWFjLTA6MDFdIA0KPiA+IGRyaXZlciBbR2VuZXJpYyBQSFldDQo+ID4g
WyA0MTU5LjE0MTAwNV0gc3RtbWFjZXRoIDcwMDAwMDAwLmV0aGVybmV0IGV0aDA6IHBoeTogc2V0
dGluZyBzdXBwb3J0ZWQgDQo+ID4gMDAsMDAwMDAwMDAsMDAwMDYyZmYgYWR2ZXJ0aXNpbmcgMDAs
MDAwMDAwMDAsMDAwMDYyZmYNCj4gPiBbIDQxNTkuMTQyMzU5XSBzdG1tYWNldGggNzAwMDAwMDAu
ZXRoZXJuZXQgZXRoMDogTm8gU2FmZXR5IEZlYXR1cmVzIA0KPiA+IHN1cHBvcnQgZm91bmQNCj4g
PiBbIDQxNTkuMTQyMzY5XSBzdG1tYWNldGggNzAwMDAwMDAuZXRoZXJuZXQgZXRoMDogSUVFRSAx
NTg4LTIwMDggQWR2YW5jZWQgDQo+ID4gVGltZXN0YW1wIHN1cHBvcnRlZA0KPiA+IFsgNDE1OS4x
NDI0MjldIHN0bW1hY2V0aCA3MDAwMDAwMC5ldGhlcm5ldCBldGgwOiByZWdpc3RlcmVkIFBUUCBj
bG9jaw0KPiA+IFsgNDE1OS4xNDI0MzldIHN0bW1hY2V0aCA3MDAwMDAwMC5ldGhlcm5ldCBldGgw
OiBjb25maWd1cmluZyBmb3IgDQo+ID4gcGh5L2dtaWkgbGluayBtb2RlDQo+ID4gWyA0MTU5LjE0
MjQ1Ml0gc3RtbWFjZXRoIDcwMDAwMDAwLmV0aGVybmV0IGV0aDA6IHBoeWxpbmtfbWFjX2NvbmZp
ZzogDQo+ID4gbW9kZT1waHkvZ21paS9Vbmtub3duL1Vua25vd24gYWR2PTAwLDAwMDAwMDAwLDAw
MDA2MmZmIHBhdXNlPTEwIGxpbms9MCANCj4gPiBhbj0xDQo+ID4gWyA0MTU5LjE0MjQ2Nl0gc3Rt
bWFjZXRoIDcwMDAwMDAwLmV0aGVybmV0IGV0aDA6IHBoeSBsaW5rIHVwIA0KPiA+IGdtaWkvMUdi
cHMvRnVsbA0KPiA+IFsgNDE1OS4xNDI0NzVdIHN0bW1hY2V0aCA3MDAwMDAwMC5ldGhlcm5ldCBl
dGgwOiBwaHlsaW5rX21hY19jb25maWc6IA0KPiA+IG1vZGU9cGh5L2dtaWkvMUdicHMvRnVsbCBh
ZHY9MDAsMDAwMDAwMDAsMDAwMDAwMDAgcGF1c2U9MGYgbGluaz0xIGFuPTANCj4gPiBbIDQxNTku
MTQyNDgxXSBzdG1tYWNldGggNzAwMDAwMDAuZXRoZXJuZXQgZXRoMDogTGluayBpcyBVcCAtIDFH
YnBzL0Z1bGwgDQo+ID4gLSBmbG93IGNvbnRyb2wgcngvdHgNCj4gPiANCj4gPiBUaGUgb25seSBt
aXNzaW5nIHBvaW50IGlzIHRoZSBORlMgYm9vdCB0aGF0IEkgY2FuJ3QgcmVwbGljYXRlIHdpdGgg
dGhpcyANCj4gPiBzZXR1cC4gQnV0IEkgZGlkIHNvbWUgc2FuaXR5IGNoZWNrczoNCj4gPiANCj4g
PiBSZW1vdGUgRW5wb2ludDoNCj4gPiAjIGRkIGlmPS9kZXYvdXJhbmRvbSBvZj1vdXRwdXQuZGF0
IGJzPTEyOE0gY291bnQ9MQ0KPiA+ICMgbmMgLWMgMTkyLjE2OC4wLjIgMTIzNCA8IG91dHB1dC5k
YXQNCj4gPiAjIG1kNXN1bSBvdXRwdXQuZGF0IA0KPiA+IGZkZTllMDgxODI4MTgzNmU0ZmMwZWRm
ZWRlMmI4NzYyICBvdXRwdXQuZGF0DQo+ID4gDQo+ID4gRFVUOg0KPiA+ICMgbmMgLWwgLWMgLXAg
MTIzNCA+IG91dHB1dC5kYXQNCj4gPiAjIG1kNXN1bSBvdXRwdXQuZGF0IA0KPiA+IGZkZTllMDgx
ODI4MTgzNmU0ZmMwZWRmZWRlMmI4NzYyICBvdXRwdXQuZGF0DQo+IA0KPiBPbiBteSBzZXR1cCwg
aWYgSSBkbyBub3QgdXNlIE5GUyB0byBtb3VudCB0aGUgcm9vdGZzLCBidXQgdGhlbiBtYW51YWxs
eQ0KPiBtb3VudCB0aGUgTkZTIHNoYXJlIGFmdGVyIGJvb3RpbmcsIEkgZG8gbm90IHNlZSBhbnkg
cHJvYmxlbXMgcmVhZGluZyBvcg0KPiB3cml0aW5nIHRvIGZpbGVzIG9uIHRoZSBzaGFyZS4gU28g
SSBhbSBub3Qgc3VyZSBpZiBpdCBpcyBzb21lIHNvcnQgb2YNCj4gcmFjZSB0aGF0IGlzIG9jY3Vy
cmluZyB3aGVuIG1vdW50aW5nIHRoZSBORlMgc2hhcmUgb24gYm9vdC4gSXQgaXMgMTAwJQ0KPiBy
ZXByb2R1Y2libGUgd2hlbiB1c2luZyBORlMgZm9yIHRoZSByb290IGZpbGUtc3lzdGVtLg0KDQpJ
IGRvbid0IHVuZGVyc3RhbmQgaG93IGNhbiB0aGVyZSBiZSBjb3JydXB0aW9uIHRoZW4gdW5sZXNz
IHRoZSBJUCBBWEkgDQpwYXJhbWV0ZXJzIGFyZSBtaXNjb25maWd1cmVkIHdoaWNoIGNhbiBsZWFk
IHRvIHNwb3JhZGljIHVuZGVmaW5lZCANCmJlaGF2aW9yLg0KDQpUaGVzZSBwcmludHMgZnJvbSB5
b3VyIGxvZ3M6DQpbICAgMTQuNTc5MzkyXSBSdW4gL2luaXQgYXMgaW5pdCBwcm9jZXNzDQovaW5p
dDogbGluZSA1ODogY2htb2Q6IGNvbW1hbmQgbm90IGZvdW5kDQpbIDEwOjIyOjQ2IF0gTDRULUlO
SVRSRCBCdWlsZCBEQVRFOiBNb24gSnVsIDIyIDEwOjIyOjQ2IFVUQyAyMDE5DQpbIDEwOjIyOjQ2
IF0gUm9vdCBkZXZpY2UgZm91bmQ6IG5mcw0KWyAxMDoyMjo0NiBdIEV0aGVybmV0IGludGVyZmFj
ZXM6IGV0aDANClsgMTA6MjI6NDYgXSBJUCBBZGRyZXNzOiAxMC4yMS4xNDAuNDENCg0KV2hlcmUg
YXJlIHRoZXkgY29taW5nIGZyb20gPyBEbyB5b3UgaGF2ZSBhbnkgZXh0cmEgaW5pdCBzY3JpcHQg
Pw0KDQotLS0NClRoYW5rcywNCkpvc2UgTWlndWVsIEFicmV1DQo=
