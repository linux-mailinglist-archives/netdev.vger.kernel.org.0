Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E78906E5B5
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 14:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728477AbfGSM3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 08:29:09 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:51688 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727891AbfGSM3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 08:29:08 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id B9264C1208;
        Fri, 19 Jul 2019 12:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1563539348; bh=2tjdX8YxO1dvyYBsouxijv79HEVSf5GeaMMtHdO/qIs=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=XCYv3EDNXZHKaP2NqSE9Qk0kL1ZZec1hpRjwls9DvIgIQ9rlalTl7O/IMa0Qzkqfp
         x0RQWvyf4e1GHp1oKpXNySETbaS3THx59ZElmjNxPzlYSCy/IPGhEAecXSdc1zNyW7
         xfhYZlpLLzd/B4tkUyrmc17O+su1wFnCgaY2qILhG5Wkg7xOqx80HeNb4W54q2dF42
         q2pZqQ3SldNpnaVH4YQ28epRaQaxEc7w7m/I8nKxlYS3dxdvmlLi8R+VkgfjIQB2xH
         yUugwyYGsUSMMoNgiKMgeaWSNjrgFU95rRNNSJ2qEvi3yfgliJFnGTEyhlLBgSYEbp
         lp768CL2Tp3cw==
Received: from US01WEHTC2.internal.synopsys.com (us01wehtc2.internal.synopsys.com [10.12.239.237])
        (using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 18A50A009A;
        Fri, 19 Jul 2019 12:28:53 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC2.internal.synopsys.com (10.12.239.237) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Fri, 19 Jul 2019 05:28:31 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Fri, 19 Jul 2019 05:28:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jB4Zlls9LqIVZXG85Yh1kD7x4wPo7Z31U7AF6ZBMnEFsMfWqmEHAXaXIRjG/iqYAAhA8H6DT3TLkhPS2gdjqQhdegovU4VYZ6zpvX/2yvKRG3ZOmUpchh+3OyzJ6PRwlrIkD40H/7snkza03xDGegh8txTLzHBfhpGB7Ga8CO5C/W0M4PAMjScVL4gG7a7k1eVx8Ow8EWsnOOM2ADWbREqADZyYtHW3n/0/R0HTUaq37kPf6aVVnsI6UzQqNuI3bZIShSUdNuxTL8F5QynZl/npAFLNN2fpSD0dGqaJ6NYnQhJlvDxJgZk/dOQwWzD8d8C8nfHjWdMeOBIxUjENLog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iTP8uKxSf0+iKzNIScncMOFLuNGxUZMEicalnqjBX8w=;
 b=RfdcJiskNUzLFymsADH7Gk6yoJpzAu6dSkhGufKd8RkZfT5xXOWGBsO4Xmr/UHqUmKLJtJpetf2eKJH6Wg6S59eE1tXSXYkV0Lu1y2LbLLctmS2/G6UjuuTm389YkYPLiKwUMKoiFi9IwEk89Okb1QTdjxO/PIrJkumAYAoXHyHfN9bygcfsDqmXFX0NBNNnUOb/SckhaQBHDNGmZR5/s7pge5P3Yez1SCMXRj/rAtPWQfXT9lRmDf/DAkGT7w3fMyivJzzJeT+Jw9sCiBN5iQKud0hFXTM3mvU3IhNvMYS2ZKwpRghzi8w8w7hgrbdACGMLNGmsFb0swi5ceKLidQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=synopsys.com;dmarc=pass action=none
 header.from=synopsys.com;dkim=pass header.d=synopsys.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector1-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iTP8uKxSf0+iKzNIScncMOFLuNGxUZMEicalnqjBX8w=;
 b=mUvR7bQBZA7fj2NDJJVYdAeP8Sjc3hmOBl3001dTOGN92V/tfRFCw9UqknKUYt/fHb6h0fZI2wWMJNGYgiN1S1aGOQBQNdajPQcjuoJHNd3OEWnsMWHNf4OXF3Cdm68/fkqKRpRoH7w/8Z8GIhcmCp1gNZw+vVZVLcpTWXGAPD4=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.66.159) by
 BN8PR12MB2948.namprd12.prod.outlook.com (20.179.67.78) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Fri, 19 Jul 2019 12:28:26 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::61ef:5598:59e0:fc9d]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::61ef:5598:59e0:fc9d%5]) with mapi id 15.20.2073.012; Fri, 19 Jul 2019
 12:28:26 +0000
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
Thread-Index: AQHVMYtq2Zx4WVoG/U2kL8GCK0bP/abPQEOAgADTx+CAABvLAIABeX5ggAAOFICAAAG4AIAAAXQAgAAaB/CAACJUcA==
Date:   Fri, 19 Jul 2019 12:28:26 +0000
Message-ID: <BN8PR12MB32669EDE5784FDBEA90D022FD3CB0@BN8PR12MB3266.namprd12.prod.outlook.com>
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
In-Reply-To: <BN8PR12MB3266FD9CF18691EDEF05A4B8D3CB0@BN8PR12MB3266.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 18c9efb5-7d6b-4ba3-93f1-08d70c449957
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(49563074)(7193020);SRVR:BN8PR12MB2948;
x-ms-traffictypediagnostic: BN8PR12MB2948:
x-microsoft-antispam-prvs: <BN8PR12MB2948B818EEA33E2ED43AD990D3CB0@BN8PR12MB2948.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 01039C93E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(39860400002)(376002)(346002)(366004)(396003)(199004)(189003)(6436002)(55016002)(478600001)(7736002)(9686003)(305945005)(6246003)(71200400001)(74316002)(5660300002)(71190400001)(2906002)(8676002)(7416002)(229853002)(86362001)(53936002)(25786009)(2201001)(2940100002)(54906003)(66946007)(26005)(256004)(81156014)(8936002)(99286004)(81166006)(76116006)(66446008)(102836004)(5024004)(99936001)(66556008)(66616009)(4744005)(186003)(316002)(110136005)(68736007)(4326008)(52536014)(66476007)(64756008)(7696005)(66066001)(2501003)(6506007)(3846002)(6116002)(76176011)(446003)(11346002)(14454004)(33656002)(476003)(486006);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB2948;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: EJN1KjdOWiGBiTacTHGl4ipmnERKa+pANWEza13gunSmXAPu/NEGS5pyEkJ83yVeKHCkjXRtGYn54ZErkQ4PpfphPZdSXlT3eqJf0P816wziOwDjgqFWSdhWgPKILWzBCvBACxwKggmiK5vIxEyx8yexMgXGvYhRmMaa5sLMitXHw32lBTsdo6HGDCw0JO9+iiUS5nnX0c9dzkReU6vAT+NRQs6j6LCfXY2ZQSid9Tl4sxP5wJq9oNLkauya6L1PGklfarR1/wBYmIfZzdI4ULNe4M1ZNJ5QJ+W3MSJNOHLUNyReNVZHOL8rks1NydcYrxOqpo1UGktExlvUpdQqRK37MO/U8WGdtatVGNFeabBvXiHB/kH2PDsmLBpwuvkMnm9b3XlcsLIuQ/exORVUmhJ30La1/z1OAW322XYY6GE=
Content-Type: multipart/mixed;
        boundary="_002_BN8PR12MB32669EDE5784FDBEA90D022FD3CB0BN8PR12MB3266namp_"
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 18c9efb5-7d6b-4ba3-93f1-08d70c449957
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2019 12:28:26.5847
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

--_002_BN8PR12MB32669EDE5784FDBEA90D022FD3CB0BN8PR12MB3266namp_
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

RnJvbTogSm9zZSBBYnJldSA8am9hYnJldUBzeW5vcHN5cy5jb20+DQpEYXRlOiBKdWwvMTkvMjAx
OSwgMTE6MjU6NDEgKFVUQyswMDowMCkNCg0KPiBUaGFua3MuIENhbiB5b3UgYWRkIGF0dGFjaGVk
IHBhdGNoIGFuZCBjaGVjayBpZiBXQVJOIGlzIHRyaWdnZXJlZCA/IA0KDQpCVFcsIGFsc28gYWRk
IHRoZSBhdHRhY2hlZCBvbmUgaW4gdGhpcyBtYWlsLiBUaGUgV0FSTiB3aWxsIHByb2JhYmx5IA0K
bmV2ZXIgZ2V0IHRyaWdnZXJlZCB3aXRob3V0IGl0Lg0KDQpDYW4geW91IGFsc28gcHJpbnQgImJ1
Zi0+YWRkciIgYWZ0ZXIgdGhlIFdBUk5fT04gPw0KDQotLS0NClRoYW5rcywNCkpvc2UgTWlndWVs
IEFicmV1DQo=

--_002_BN8PR12MB32669EDE5784FDBEA90D022FD3CB0BN8PR12MB3266namp_
Content-Type: application/octet-stream;
	name="0001-net-stmmac-Use-kcalloc-instead-of-kmalloc_array.patch"
Content-Description: 0001-net-stmmac-Use-kcalloc-instead-of-kmalloc_array.patch
Content-Disposition: attachment;
	filename="0001-net-stmmac-Use-kcalloc-instead-of-kmalloc_array.patch";
	size=2245; creation-date="Fri, 19 Jul 2019 12:28:17 GMT";
	modification-date="Fri, 19 Jul 2019 12:27:30 GMT"
Content-Transfer-Encoding: base64

RnJvbSBlYmExMjg4NTYxNDdkNmRkZWNjODE0OGFhZWVlNDE4NjQwNjljOWI1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8ZWJhMTI4ODU2MTQ3ZDZkZGVjYzgxNDhhYWVlZTQx
ODY0MDY5YzliNS4xNTYzNTM5MjUwLmdpdC5qb2FicmV1QHN5bm9wc3lzLmNvbT4KRnJvbTogSm9z
ZSBBYnJldSA8am9hYnJldUBzeW5vcHN5cy5jb20+CkRhdGU6IEZyaSwgMTkgSnVsIDIwMTkgMTM6
NTg6NTUgKzAyMDAKU3ViamVjdDogW1BBVENIIG5ldF0gbmV0OiBzdG1tYWM6IFVzZSBrY2FsbG9j
KCkgaW5zdGVhZCBvZiBrbWFsbG9jX2FycmF5KCkKCldlIG5lZWQgdGhlIG1lbW9yeSB0byBiZSB6
ZXJvZWQgdXBvbiBhbGxvY2F0aW9uIHNvIHVzZSBrY2FsbG9jKCkKaW5zdGVhZC4KClNpZ25lZC1v
ZmYtYnk6IEpvc2UgQWJyZXUgPGpvYWJyZXVAc3lub3BzeXMuY29tPgoKLS0tCkNjOiBHaXVzZXBw
ZSBDYXZhbGxhcm8gPHBlcHBlLmNhdmFsbGFyb0BzdC5jb20+CkNjOiBBbGV4YW5kcmUgVG9yZ3Vl
IDxhbGV4YW5kcmUudG9yZ3VlQHN0LmNvbT4KQ2M6IEpvc2UgQWJyZXUgPGpvYWJyZXVAc3lub3Bz
eXMuY29tPgpDYzogIkRhdmlkIFMuIE1pbGxlciIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+CkNjOiBN
YXhpbWUgQ29xdWVsaW4gPG1jb3F1ZWxpbi5zdG0zMkBnbWFpbC5jb20+CkNjOiBuZXRkZXZAdmdl
ci5rZXJuZWwub3JnCkNjOiBsaW51eC1zdG0zMkBzdC1tZC1tYWlsbWFuLnN0b3JtcmVwbHkuY29t
CkNjOiBsaW51eC1hcm0ta2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmcKQ2M6IGxpbnV4LWtlcm5l
bEB2Z2VyLmtlcm5lbC5vcmcKLS0tCiBkcml2ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1h
Yy9zdG1tYWNfbWFpbi5jIHwgMTcgKysrKysrKystLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCA4
IGluc2VydGlvbnMoKyksIDkgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvc3RtbWFjX21haW4uYyBiL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L3N0bWljcm8vc3RtbWFjL3N0bW1hY19tYWluLmMKaW5kZXggZWFjNjkyMDMwMWU5Li44ZTU1
YWJlMTA5OWEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFj
L3N0bW1hY19tYWluLmMKKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMv
c3RtbWFjX21haW4uYwpAQCAtMTU1NSw5ICsxNTU1LDggQEAgc3RhdGljIGludCBhbGxvY19kbWFf
cnhfZGVzY19yZXNvdXJjZXMoc3RydWN0IHN0bW1hY19wcml2ICpwcml2KQogCQkJZ290byBlcnJf
ZG1hOwogCQl9CiAKLQkJcnhfcS0+YnVmX3Bvb2wgPSBrbWFsbG9jX2FycmF5KERNQV9SWF9TSVpF
LAotCQkJCQkgICAgICAgc2l6ZW9mKCpyeF9xLT5idWZfcG9vbCksCi0JCQkJCSAgICAgICBHRlBf
S0VSTkVMKTsKKwkJcnhfcS0+YnVmX3Bvb2wgPSBrY2FsbG9jKERNQV9SWF9TSVpFLCBzaXplb2Yo
KnJ4X3EtPmJ1Zl9wb29sKSwKKwkJCQkJIEdGUF9LRVJORUwpOwogCQlpZiAoIXJ4X3EtPmJ1Zl9w
b29sKQogCQkJZ290byBlcnJfZG1hOwogCkBAIC0xNjA4LDE1ICsxNjA3LDE1IEBAIHN0YXRpYyBp
bnQgYWxsb2NfZG1hX3R4X2Rlc2NfcmVzb3VyY2VzKHN0cnVjdCBzdG1tYWNfcHJpdiAqcHJpdikK
IAkJdHhfcS0+cXVldWVfaW5kZXggPSBxdWV1ZTsKIAkJdHhfcS0+cHJpdl9kYXRhID0gcHJpdjsK
IAotCQl0eF9xLT50eF9za2J1ZmZfZG1hID0ga21hbGxvY19hcnJheShETUFfVFhfU0laRSwKLQkJ
CQkJCSAgICBzaXplb2YoKnR4X3EtPnR4X3NrYnVmZl9kbWEpLAotCQkJCQkJICAgIEdGUF9LRVJO
RUwpOworCQl0eF9xLT50eF9za2J1ZmZfZG1hID0ga2NhbGxvYyhETUFfVFhfU0laRSwKKwkJCQkJ
ICAgICAgc2l6ZW9mKCp0eF9xLT50eF9za2J1ZmZfZG1hKSwKKwkJCQkJICAgICAgR0ZQX0tFUk5F
TCk7CiAJCWlmICghdHhfcS0+dHhfc2tidWZmX2RtYSkKIAkJCWdvdG8gZXJyX2RtYTsKIAotCQl0
eF9xLT50eF9za2J1ZmYgPSBrbWFsbG9jX2FycmF5KERNQV9UWF9TSVpFLAotCQkJCQkJc2l6ZW9m
KHN0cnVjdCBza19idWZmICopLAotCQkJCQkJR0ZQX0tFUk5FTCk7CisJCXR4X3EtPnR4X3NrYnVm
ZiA9IGtjYWxsb2MoRE1BX1RYX1NJWkUsCisJCQkJCSAgc2l6ZW9mKHN0cnVjdCBza19idWZmICop
LAorCQkJCQkgIEdGUF9LRVJORUwpOwogCQlpZiAoIXR4X3EtPnR4X3NrYnVmZikKIAkJCWdvdG8g
ZXJyX2RtYTsKIAotLSAKMi43LjQKCg==

--_002_BN8PR12MB32669EDE5784FDBEA90D022FD3CB0BN8PR12MB3266namp_--
