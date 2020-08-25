Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 789CA2513DB
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 10:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726737AbgHYIL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 04:11:26 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:53746 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgHYILX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 04:11:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1598343082; x=1629879082;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+ujhAbWq2r/l6ARqSc2r4fxlS8/Nv/7L/W3+rZcFBQw=;
  b=zgsaKjlCimY/5Gzidqh8b/T4/G1tqAtjtQnYpakHC6jLirJhUF9VDce+
   U4nMhCGQFznwsrztJF46pZvFtQGcptsLUOWkylTDIcMKJq1v744sSCaSV
   p8F+IqJPGpzxfTmoiK5s8Emjm1ZBEc+yx0609tTpsEe+3WqJVJSTxMhbp
   uCdsGS+PoS6IIeqaPAOGxdLUwAe8BDiYUjf4Cu9CSLASbDVKJtkTdUsUb
   dWynWT5ZKFsh+7FmOB0dUiCXvMB/Fs8YvDLbKejBQLH4Ieuf0OK5aVLuU
   yDAOWlo/jQQm2w9wOqA9mgpLPl1mlFgUpd0ZBpBioqpWCphPKvJBUpudF
   A==;
IronPort-SDR: F2fU+aFRXryN1JMvO1kgFcCHyUTrr/sB1yE9BROQdI1ATQosTdQrVT0tN7ZwC9UXKxymnuRQHl
 b9FX1uNgM+Eq216uXd9ozSruHHoUsX1eueFQ0KNJU0L5dt/QoPmwg83W/MCtCpOWXyNKN+KvrX
 eQpc64J+fXCKNAZ3XtGJVTmPdSGVTGk27nf7pKISYxVXBFWTiexhk3SOSeCys+Saa60lgCIt+W
 2PRe6Dv37Z2v7Dy4N46jzNLl/H4+RZ+w+FZ5DJegi87xaqP+c7x3xbVjlKtDI1IqD8A63n4iYV
 vnk=
X-IronPort-AV: E=Sophos;i="5.76,351,1592895600"; 
   d="scan'208";a="24140744"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Aug 2020 01:11:21 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 25 Aug 2020 01:10:40 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Tue, 25 Aug 2020 01:11:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fiL2X7jxGtfToJZk3SAOYjrhhTYh46vJeZTSyPS4fANZGSKBe+j5S+D11b1rE1ZV8tnw3ciN9idaey2iCpKxWQgLFwtJMS3aEnato2L3pnmBtF/gupKtskZ86d9PcYWO3eUBO/7ChUoZfsHz/MOYyX+b6M5PVh9WV4+OV0ryh/ifKylcOMXtl7K+o+JOXpg6lU0XgtoJEZqf3WNbN0Q+6wlWUd4PDYuHEZLnWLpfzZYqrs5eSdjoQT/Jfc0dKo2N6swKV3IM1pNNQ5Quo8SzthLNQzDBTQE2dt0Tajn1LHOV09uZ9h9Eo+4VMRQCG+QSKYFI+iOJyQUBwfe8be+PjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ujhAbWq2r/l6ARqSc2r4fxlS8/Nv/7L/W3+rZcFBQw=;
 b=F9elg5R36TkTRXtACQmQR0HftqOaPsCa033i1qFeQvTcjXfAeSXaNO9IhtYX1c75rxVmvECGb9kRXSjHOF5YX5x0ObCQW05SQtWQvggkGWnmj+Y3Wt+SNdJZE5dEbYVVd8+jacUwOF2IqXGIoBzFnUB60uMglEQQNN9RMgH9cnr7LIWcD6Vwjk+0eP8dax/dz2o6MqKICgRAI/p2M8pgA+WyIqCMQilj2tiNV0O8/hIttRZPzsH23uaBw9ama1C1ZTDObJCoqJk/SuhOfPo0Z48jVUdOkdYb86q1CpBkd29VAcVPucVBtna5Sq9f9jBQcobk1Qz5VidHFTjCc2ey7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ujhAbWq2r/l6ARqSc2r4fxlS8/Nv/7L/W3+rZcFBQw=;
 b=Q2BecvabrSWpe4eucaHOI0+rvrHXKLJbwr6spAz9ZPHMZNe8PZ9AXJx8/+i9ELvVDnUxw2yFSlAyWYrgCiGQgY+rYGoSMVRu6Rb3uyNPz6+rz1dvfkYxmFOWzF5oTqDjZnejgs2Cpoip/NU3d2ylPte/UbBZbIV44BtUNp4R75U=
Received: from DM6PR11MB3420.namprd11.prod.outlook.com (2603:10b6:5:69::31) by
 DM5PR11MB2010.namprd11.prod.outlook.com (2603:10b6:3:12::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3305.26; Tue, 25 Aug 2020 08:11:20 +0000
Received: from DM6PR11MB3420.namprd11.prod.outlook.com
 ([fe80::cc1b:9fb4:c35f:554]) by DM6PR11MB3420.namprd11.prod.outlook.com
 ([fe80::cc1b:9fb4:c35f:554%4]) with mapi id 15.20.3305.031; Tue, 25 Aug 2020
 08:11:20 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <dinghao.liu@zju.edu.cn>, <kjlu@umn.edu>
CC:     <Ajay.Kathat@microchip.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <Eugen.Hristev@microchip.com>, <gregkh@linuxfoundation.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [v2] wilc1000: Fix memleak in wilc_sdio_probe
Thread-Topic: [PATCH] [v2] wilc1000: Fix memleak in wilc_sdio_probe
Thread-Index: AQHWerdP54A31dTbqk2IjULmfQT51w==
Date:   Tue, 25 Aug 2020 08:11:19 +0000
Message-ID: <f6d0e5d9-b749-31d1-68f5-3166666e042c@microchip.com>
References: <20200820054819.23365-1-dinghao.liu@zju.edu.cn>
In-Reply-To: <20200820054819.23365-1-dinghao.liu@zju.edu.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
authentication-results: zju.edu.cn; dkim=none (message not signed)
 header.d=none;zju.edu.cn; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [82.137.16.129]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 73d2b93d-ee0a-4538-e8a3-08d848ce72d7
x-ms-traffictypediagnostic: DM5PR11MB2010:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR11MB20109B30FB5741D573D3A91887570@DM5PR11MB2010.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aUdgjoHKACohR6yQrJvjaHvu0nf6QNQhdMLDlYA2DL6b4e5MBs1580tH1Orm5o9KXr+Nz/tbqZPhAjiWd05N/J+lZKkc8ATh6AlOXGAp4ImgvClN0UAJSyz1JWRaMFuDcmh2QKzQVKrRtkV79rd+DnzV9nebs1EhGVhlOuB5xHe9yZE9jtTjPVViLGqjmOzlD6N5e3+Z3SBhU8oNFKGuyGyOifWei4Qn8j9udtBN89IkPo85V1afovs5DZA8lkyjd5ynMH/lxACSERTFUdb3XIbGdB5NIdMfZe3XfJELhZcfGtY57ztVJqEj+WBKXUDUk9l+OtjxLYflv4r4mKuLowyQizVC9ShY22s9QGCwSenGB349JNhrAveCZo5hJpWg
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3420.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(346002)(376002)(366004)(39860400002)(86362001)(8676002)(2906002)(8936002)(2616005)(110136005)(478600001)(31696002)(4326008)(36756003)(26005)(66946007)(71200400001)(66476007)(91956017)(66556008)(64756008)(66446008)(83380400001)(53546011)(186003)(6506007)(31686004)(54906003)(5660300002)(316002)(6512007)(76116006)(6486002)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: zYA3UIE9CqUp653wBG0E8w0sCBoyMDYFN4QQKcU4Pj0gfxTpckbasJS2h6eKeAXUzK7+Q6C5w+3X718AlcFtlmFiY76iF8SQKIg2F5Q1IDtuYZCQEMzi6e2xwlWaQDNK8jeGDfTnZ4Yfw+pMActcSk1tiCXeqObA6dAxnH4cpkDkDyZ5p+VKMLc07I8PSP4f+jpwSrNkhzF1fwBTBPLlj3pIC/95ps3hTnrmNBEDhrg7mZs7Xgqw4ZVY/wnANr5+337DB467HzDrn2bHtoRK+AelTN7dSHsIcrc5Gt/6KMqr/qFwHAMyinwxkeeEuTiFg0YIKhXqb/n74Mv3eLVcZQklq1dcoyAHBjcRqmOQIklrtK2viIMy/amCDaCqLOBPR2mM/8d+oFqXogoGYhKPKnMb+Uucct0cm8AeTf1YhrGQuaA1TJYIk1QC02PtAREtHrorudmSXLk5fBAEDqxOnDF03CV2KsbBZcJNdTK3rwQZsQCoKJ8Ffo3JUuWrUodi7/6VK70AxttdrEcIo2ZEHQ5bWy6r0pA9hWYUfUNC8WvK4hQZEJ/TzH45Nnc6+w2DX6329lQwHSgkT+yOLBEYrpIPMQOz0FP8rubI9DMF9af7SpjyJ6NhChl/E3NSRCtA5B1uwXQpDgNMJg5CAxJzeA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <8A0612EFED124F42AF803971FD3AAD2C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3420.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73d2b93d-ee0a-4538-e8a3-08d848ce72d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Aug 2020 08:11:19.8191
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H6biMatS/S7V7onAMCfKeENWjTkodbwVpUQ/N3azeVaVMf6CCLJFACo1YznPPx5IFc0foVsObJklN2wfzRBMaiUrq3s3NLFzay1N9HP+bA4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB2010
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDIwLjA4LjIwMjAgMDg6NDgsIERpbmdoYW8gTGl1IHdyb3RlOg0KPiBFWFRFUk5BTCBF
TUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlvdSBr
bm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gDQo+IFdoZW4gZGV2bV9jbGtfZ2V0KCkgcmV0dXJu
cyAtRVBST0JFX0RFRkVSLCBzZGlvX3ByaXYNCj4gc2hvdWxkIGJlIGZyZWVkIGp1c3QgbGlrZSB3
aGVuIHdpbGNfY2ZnODAyMTFfaW5pdCgpDQo+IGZhaWxzLg0KPiANCj4gRml4ZXM6IDg2OTJiMDQ3
ZTg2Y2YgKCJzdGFnaW5nOiB3aWxjMTAwMDogbG9vayBmb3IgcnRjX2NsayBjbG9jayIpDQo+IFNp
Z25lZC1vZmYtYnk6IERpbmdoYW8gTGl1IDxkaW5naGFvLmxpdUB6anUuZWR1LmNuPg0KPiAtLS0N
Cj4gDQo+IENoYW5nZWxvZzoNCj4gDQo+IHYyOiAtIFJlbW92ZSAnc3RhZ2luZycgcHJlZml4IGlu
IHN1YmplY3QuDQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQvd2lyZWxlc3MvbWljcm9jaGlwL3dpbGMx
MDAwL3NkaW8uYyB8IDUgKysrLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyks
IDIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3Mv
bWljcm9jaGlwL3dpbGMxMDAwL3NkaW8uYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21pY3JvY2hp
cC93aWxjMTAwMC9zZGlvLmMNCj4gaW5kZXggM2VjZTdiMGIwMzkyLi4zNTFmZjkwOWFiMWMgMTAw
NjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21pY3JvY2hpcC93aWxjMTAwMC9zZGlv
LmMNCj4gKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWljcm9jaGlwL3dpbGMxMDAwL3NkaW8u
Yw0KPiBAQCAtMTQ5LDkgKzE0OSwxMCBAQCBzdGF0aWMgaW50IHdpbGNfc2Rpb19wcm9iZShzdHJ1
Y3Qgc2Rpb19mdW5jICpmdW5jLA0KPiAgICAgICAgIHdpbGMtPmRldiA9ICZmdW5jLT5kZXY7DQo+
IA0KPiAgICAgICAgIHdpbGMtPnJ0Y19jbGsgPSBkZXZtX2Nsa19nZXQoJmZ1bmMtPmNhcmQtPmRl
diwgInJ0YyIpOw0KPiAtICAgICAgIGlmIChQVFJfRVJSX09SX1pFUk8od2lsYy0+cnRjX2Nsaykg
PT0gLUVQUk9CRV9ERUZFUikNCj4gKyAgICAgICBpZiAoUFRSX0VSUl9PUl9aRVJPKHdpbGMtPnJ0
Y19jbGspID09IC1FUFJPQkVfREVGRVIpIHsNCj4gKyAgICAgICAgICAgICAgIGtmcmVlKHNkaW9f
cHJpdik7DQoNClRoZSBwcm9wZXIgd2F5IHRvIGZyZWUgcmVzb3VyY2VzIGhlcmUgd291bGQgYmUg
dG8gY2FsbA0Kd2lsY19uZXRkZXZfY2xlYW51cCgpIHdoaWNoIHdpbGwgZnJlZSBhbGwgb2JqZWN0
cyBhbGxvY2F0ZWQgYnkNCndpbGNfY2ZnODAyMTFfaW5pdCgpIGFuZCB3aWxsIGFsc28gZnJlZSBz
ZGlvX3ByaXYuIEkgcGVyc29uYWxseSB3b3VsZCBnbw0KZnVydGhlciBhbmQgcmVtb3ZlIHRoZSBr
ZnJlZSh3aWxjLT5idXNfZGF0YSkgZnJvbSB3aWxjX25ldGRldl9jbGVhbnVwKCkgYW5kDQprZWVw
IGl0IGluIHRoZSB3aWxjX3NkaW9fcHJvYmUoKSwgd2lsY19zcGlfcHJvYmUoKSB3aGVyZSBpdCB3
YXMgYWN0dWFsbHkNCmFsbG9jYXRlZC4NCg0KPiAgICAgICAgICAgICAgICAgcmV0dXJuIC1FUFJP
QkVfREVGRVI7DQo+IC0gICAgICAgZWxzZSBpZiAoIUlTX0VSUih3aWxjLT5ydGNfY2xrKSkNCj4g
KyAgICAgICB9IGVsc2UgaWYgKCFJU19FUlIod2lsYy0+cnRjX2NsaykpDQo+ICAgICAgICAgICAg
ICAgICBjbGtfcHJlcGFyZV9lbmFibGUod2lsYy0+cnRjX2Nsayk7DQo+IA0KPiAgICAgICAgIGRl
dl9pbmZvKCZmdW5jLT5kZXYsICJEcml2ZXIgSW5pdGlhbGl6aW5nIHN1Y2Nlc3NcbiIpOw0KPiAt
LQ0KPiAyLjE3LjENCj4g
