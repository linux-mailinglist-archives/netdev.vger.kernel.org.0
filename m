Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 290D922C8DB
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 17:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgGXPRg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 11:17:36 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:46152 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726170AbgGXPRg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 11:17:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1595603855; x=1627139855;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/J1SSuU7BCYMQq3r9XG9hfF57pqcWqjSuvRnvUmRXcQ=;
  b=TgxcRQydGoUvJMmd3Ns/uT5KFciBtpeIu1MOTgV4gtO/l3ABRvsY2ow3
   /Yw+9mYwhwpgs0vapfnnMzY0GEjzJAqRyJWvAybqMnuePqz1IMPQcNhbq
   nsYWMKRD2yMpxKVsgSmWo2F7mzdMCy4b5rroKV391ay9OEYqfdNThm61T
   WD5cSkbIvkY0fLqZNdS6aCN9qZy4naSWDOiMMDOquuhfoOW1ftASROZx3
   igwDyn0AUlGpUzOUkebkh7xy1P+nWL4M9+DpEUzwvxfWop5UiUrFPqDrG
   esRrcGHvsnyTgCfhlhWawOJYoplF452dUJ5/wV/eYPyPmwDgqTwyxdTAa
   Q==;
IronPort-SDR: lQFneja+0tZw2IcAL5FbhEuIpZOALiIHASmhxMtsPuZZr4dMAOCcgBfGFesiuQYP6ADWY00WgC
 nizwgdNAVyAqYv+AZxcG8MCvQCFAlDB+oGs94jD/8A7eCtIQJ789SBbqEKieRGH7Tg6f4iPLuS
 lZe9Xq8krZH0a9Mw7/6zGHSeyBBTJYg6DAeLyl8Z6l5LyHacgGb4QQJNkcH7YQVGhfDYeulChb
 TuKPqq+VCH3DsLSa7GomBIw/+XY7lrHuqy66Y5FctssgvNKCwoqd+kaTOEt/D1EtGt7Ysb6oWz
 lDg=
X-IronPort-AV: E=Sophos;i="5.75,391,1589266800"; 
   d="scan'208";a="85266625"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Jul 2020 08:17:32 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 24 Jul 2020 08:17:32 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Fri, 24 Jul 2020 08:16:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XjJsHSGewZUlZPt0WgXhwjcvSO+47qLh5pw9Q9HIwgoMY3V89fAoCsHiklW2qgJTWMkXdgilp65uCBWymM6FmSin//BlOVsJopz2gX7v4ZOLLGf7BKFJRsY/Jg4OhIudELFI4jaMCYz0WgmZ2CZDeWbmGCTcbRvOf3pHj0rXyRUU8giE2TX+UIj+Hnbv8IF6zYi7K4J3H/lDjaSnbwY5ciBHDV5mswNMvYIyuaxDQsK3JyUp8cTa0bBsJss1Mx/O52hVuHWV5aLqZSnVq9RdO57VhA2yDBkpeX0o8tj/F5dhBa+C5gfpxVsD1AKhhdLQDzezqUARHgMawm4h8Pv05A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/J1SSuU7BCYMQq3r9XG9hfF57pqcWqjSuvRnvUmRXcQ=;
 b=QpPjwVca+IMK2PzAXgwY0sqvr7Tr6X7TxOLfvG64WrXEzp6SM8Bp/hla/PlqicQCm2x+15PHWqx9bpnKsL89E4Ele/Sv7YidKrxSA+9LbY6T7xabS/PjNpWNOzYFs90M9vv6T++ISUAsDLZg3gpQKyepum/QJJbK6KnMyoTH/jsC3kZCwvxA5NWre/MJ2ecEVsR6Q/McWPfOsGF961p+Zmwhoe706z9n2bNTLrfDPxrPQYhEDImJCJCGvFQ2czEeEvqZp1skAmOhtI1t1dqTYMcOk+59hjom8oWlpbUbwPFlQMKvptDEK2tmrxEr7B1+0j0brsxLUeSYKB3MdvD2Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/J1SSuU7BCYMQq3r9XG9hfF57pqcWqjSuvRnvUmRXcQ=;
 b=XxWSKGejs/PvUBR8gaZ/9Fcj3/yr36bm4muc0hgG+sQKEN2MUPYe5zBq1gUxtkiYQjn8Y87W1ARhlG7Y+wm7Zw6NBMtMGDpAFrkUEGyLDm8rO4wnJjso1NUz+yDEJxN2sW1TbiNzWS/eVxfjoetUmhXOUkFT3kFBjtEV5mYT5Fw=
Received: from BY5PR11MB3927.namprd11.prod.outlook.com (2603:10b6:a03:186::21)
 by BYAPR11MB2792.namprd11.prod.outlook.com (2603:10b6:a02:c3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20; Fri, 24 Jul
 2020 15:17:26 +0000
Received: from BY5PR11MB3927.namprd11.prod.outlook.com
 ([fe80::5993:d0ac:9849:d311]) by BY5PR11MB3927.namprd11.prod.outlook.com
 ([fe80::5993:d0ac:9849:d311%7]) with mapi id 15.20.3216.026; Fri, 24 Jul 2020
 15:17:26 +0000
From:   <Andre.Edich@microchip.com>
To:     <andrew@lunn.ch>
CC:     <Parthiban.Veerasooran@microchip.com>, <netdev@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <steve.glendinning@shawell.net>
Subject: Re: [PATCH net-next v2 3/6] smsc95xx: add PAL support to use external
 PHY drivers
Thread-Topic: [PATCH net-next v2 3/6] smsc95xx: add PAL support to use
 external PHY drivers
Thread-Index: AQHWYOhG3giq6Ks6W0SJmy0yNtRqD6kVwpAAgAEWsAA=
Date:   Fri, 24 Jul 2020 15:17:26 +0000
Message-ID: <c2cb789ac1beebc5c337e97c05e462202d19abcf.camel@microchip.com>
References: <20200723115507.26194-1-andre.edich@microchip.com>
         <20200723115507.26194-4-andre.edich@microchip.com>
         <20200723223956.GL1553578@lunn.ch>
In-Reply-To: <20200723223956.GL1553578@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.3 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [93.202.177.91]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7d0e3974-b256-4260-9900-08d82fe4ac95
x-ms-traffictypediagnostic: BYAPR11MB2792:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB2792C9BDD48EAEDD273E1D34EC770@BYAPR11MB2792.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h1OPgerv6XJB9g39BwDfVypNp1FALppRw/aneUaNgjAEUXZ57hlhFeWM3lsxw3kbb0heVFTurDveKSYKpkJhfeNI5Zx1KbkyOH8074K4wGJ27BN4FA9bTUJadDlwjvi65x99JdzZaGJeImVmI1x/fAzXK30EhhOA5CvGrIoyEW9FpfOZLcipVUk/Me7onR13G+gtbqEqoRv+8xISMfXlnmLHGay2IeaQjJ0ijebLHp6PXUOua/4MTkYxxkhqt7U2cz/DJrwmcMpMDiWapNhM3jFSBDR1K7T/LImvDWUnBjLA3U0S5b6j4lUplrTu4yACgxt1h404QTuB9zwkpzF49g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB3927.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(136003)(39860400002)(376002)(366004)(346002)(5660300002)(6916009)(2616005)(26005)(316002)(8676002)(4326008)(6506007)(186003)(66446008)(6512007)(66556008)(86362001)(66946007)(64756008)(66476007)(2906002)(91956017)(8936002)(54906003)(6486002)(76116006)(71200400001)(36756003)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: +n3hB/PCONeI0j3sEDu91RAbXZWrXvtMN1503Bqc/JODMnpQU6KjAoQEXZIEsXQd0uCT7bTAJ4Rl50bbRCgrOidLDFXSo/ILmMX9UUcuc41e1X/QaCFMJq1nrtsHlXGtVXHF8PiYXluqJO417LjLVRF5jcSz0OW5kLDYRAUC/4UOpyEyphuTgqugQgbuxiMPxo4WPTgNkE44Vw0sKYtVmriw5o0Ch/APxN+ZsCFveHLNKA3AUovWZ5XUvusopbPjZEj5JCD+v9WOOnVFaXguq45cP9KEgSi4nJ8zj2SlCdGlojcGhFR/qb1tvTU/XEU1PeVk2io4YlqpaV9Tfb+lxdyNV5Z8wNaEc43xNZihZRbCS4uVZOefbNg7WbakNY6TrPZODOHVvF4mNNHRL3BLUcdisgZ6YWfbGGGSpcJLKylPDPvNytdnM8Jw5NQH5X284O7OdCF7W4+H5TdaGN8chYyWhMNoXYL8orsx+OpkGYI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <950E34E54783A846A58C2E3295DE422C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB3927.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d0e3974-b256-4260-9900-08d82fe4ac95
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2020 15:17:26.4181
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eXcoIGQx+vAEeIbrx5p4UI9b4/dhRV+QGHdni7gLVex8or7+ss0puEOpJav77jrN3dIled3pLs7m0yysJLJ5SlAJyjVabZyq8jcuSVlkOPs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2792
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTA3LTI0IGF0IDAwOjM5ICswMjAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
RVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVu
bGVzcyB5b3UNCj4ga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPiBPbiBUaHUsIEp1bCAy
MywgMjAyMCBhdCAwMTo1NTowNFBNICswMjAwLCBBbmRyZSBFZGljaCB3cm90ZToNCj4gPiBHZW5l
cmFsbHksIGVhY2ggUEhZIGhhcyB0aGVpciBvd24gY29uZmlndXJhdGlvbiBhbmQgaXQgY2FuIGJl
IGRvbmUNCj4gPiB0aHJvdWdoIGFuIGV4dGVybmFsIFBIWSBkcml2ZXIuICBUaGUgc21zYzk1eHgg
ZHJpdmVyIHVzZXMgb25seSB0aGUNCj4gPiBoYXJkLWNvZGVkIGludGVybmFsIFBIWSBjb25maWd1
cmF0aW9uLg0KPiA+IA0KPiA+IFRoaXMgcGF0Y2ggYWRkcyBQQUwgKFBIWSBBYnN0cmFjdGlvbiBM
YXllcikgc3VwcG9ydCB0byBwcm9iZQ0KPiA+IGV4dGVybmFsDQo+ID4gUEhZIGRyaXZlcnMgZm9y
IGNvbmZpZ3VyaW5nIGV4dGVybmFsIFBIWXMuDQo+IA0KPiBIaSBBbmRyZQ0KPiANCj4gV2UgY2Fs
bCBpdCBwaHlsaWIsIG5vdCBQQUwuDQoNCkhpIEFuZHJldywNCg0KdGhhbmsgeW91IGZvciB0aGUg
ZmVlZGJhY2suIEluIHRoZSBuZXh0IHZlcnNpb24sIEkgd2lsbCBjb3JyZWN0IHRoZXNlDQp3b3Jk
aW5ncyBhcyB3ZWxsLg0KDQo+IA0KPiA+ICBzdGF0aWMgaW50IF9fbXVzdF9jaGVjayBzbXNjOTV4
eF93YWl0X2VlcHJvbShzdHJ1Y3QgdXNibmV0ICpkZXYpDQo+ID4gIHsNCj4gPiAgICAgICB1bnNp
Z25lZCBsb25nIHN0YXJ0X3RpbWUgPSBqaWZmaWVzOw0KPiA+IEBAIC01NTksMTUgKzU4MCwyMCBA
QCBzdGF0aWMgaW50IHNtc2M5NXh4X2xpbmtfcmVzZXQoc3RydWN0IHVzYm5ldA0KPiA+ICpkZXYp
DQo+ID4gICAgICAgdTE2IGxjbGFkdiwgcm10YWR2Ow0KPiA+ICAgICAgIGludCByZXQ7DQo+ID4g
DQo+ID4gLSAgICAgLyogY2xlYXIgaW50ZXJydXB0IHN0YXR1cyAqLw0KPiA+IC0gICAgIHJldCA9
IHNtc2M5NXh4X21kaW9fcmVhZChkZXYtPm5ldCwgbWlpLT5waHlfaWQsIFBIWV9JTlRfU1JDKTsN
Cj4gPiAtICAgICBpZiAocmV0IDwgMCkNCj4gPiAtICAgICAgICAgICAgIHJldHVybiByZXQ7DQo+
ID4gLQ0KPiA+ICAgICAgIHJldCA9IHNtc2M5NXh4X3dyaXRlX3JlZyhkZXYsIElOVF9TVFMsIElO
VF9TVFNfQ0xFQVJfQUxMXyk7DQo+ID4gICAgICAgaWYgKHJldCA8IDApDQo+ID4gICAgICAgICAg
ICAgICByZXR1cm4gcmV0Ow0KPiA+IA0KPiA+ICsgICAgIGlmIChwZGF0YS0+aW50ZXJuYWxfcGh5
KSB7DQo+ID4gKyAgICAgICAgICAgICAvKiBjbGVhciBpbnRlcnJ1cHQgc3RhdHVzICovDQo+ID4g
KyAgICAgICAgICAgICByZXQgPSBzbXNjOTV4eF9tZGlvX3JlYWQoZGV2LT5uZXQsIG1paS0+cGh5
X2lkLA0KPiA+IFBIWV9JTlRfU1JDKTsNCj4gPiArICAgICAgICAgICAgIGlmIChyZXQgPCAwKQ0K
PiA+ICsgICAgICAgICAgICAgICAgICAgICByZXR1cm4gcmV0Ow0KPiA+ICsNCj4gPiArICAgICAg
ICAgICAgIHNtc2M5NXh4X21kaW9fd3JpdGUoZGV2LT5uZXQsIG1paS0+cGh5X2lkLA0KPiA+IFBI
WV9JTlRfTUFTSywNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgUEhZX0lO
VF9NQVNLX0RFRkFVTFRfKTsNCj4gPiArICAgICB9DQo+IA0KPiBUaGUgUEhZIGRyaXZlciBzaG91
bGQgZG8gdGhpcywgbm90IHRoZSBNQUMgZHJpdmVyLg0KPiANCj4gV2hpY2ggUEhZIGRyaXZlciBp
cyB1c2VkIGZvciB0aGUgaW50ZXJuYWwgUEhZPyBJbiB0aGVvcnksIHlvdSBzaG91bGQNCj4gbm90
IG5lZWQgdG8ga25vdyBpZiBpdCBpcyBpbnRlcm5hbCBvciBleHRlcm5hbCwgaXQgaXMganVzdCBh
IFBIWS4gDQoNClllcyBzdXJlLCB5b3UgYXJlIHJpZ2h0LiAgSSBzZWUgdGhlIGRyaXZlcnMvbmV0
L3BoeS9zbXNjLmMgdGhhdCBpcw0KcHJvYmVkIGZvciB0aGUgaW50ZXJuYWwgUEhZIG9mIHRoZSBE
VVQncyBFdGhlcm5ldCBjb250cm9sbGVyLg0KDQo+IA0KPiBUaGF0DQo+IG1pZ2h0IG1lYW4geW91
IG5lZWQgdG8gbW92ZSBzb21lIGNvZGUgZnJvbSB0aGlzIGRyaXZlciBpbnRvIHRoZSBQSFkNCj4g
ZHJpdmVyLCBpZiBpdCBpcyBjdXJyZW50bHkgbWlzc2luZyBpbiB0aGUgUEhZIGRyaXZlci4NCg0K
Q29ycmVjdCwgdGhlIFBIWSBkcml2ZXIgZG9lcyBpbnRlcnJ1cHQgc2V0dXAgYWN0aXZpdGllcywg
c28gdGhhdCB0aGV5DQpjYW4gYmUgcmVtb3ZlZCBmcm9tIHRoZSBzbXNjOTV4eC4NCiANCj4gDQo+
ID4gKw0KPiA+ICAgICAgIG1paV9jaGVja19tZWRpYShtaWksIDEsIDEpOw0KPiA+ICAgICAgIG1p
aV9ldGh0b29sX2dzZXQoJmRldi0+bWlpLCAmZWNtZCk7DQo+ID4gICAgICAgbGNsYWR2ID0gc21z
Yzk1eHhfbWRpb19yZWFkKGRldi0+bmV0LCBtaWktPnBoeV9pZCwNCj4gPiBNSUlfQURWRVJUSVNF
KTsNCj4gPiBAQCAtODUxLDEwICs4NzcsMTAgQEAgc3RhdGljIGludCBzbXNjOTV4eF9nZXRfbGlu
a19rc2V0dGluZ3Moc3RydWN0DQo+ID4gbmV0X2RldmljZSAqbmV0LA0KPiA+ICAgICAgIGludCBy
ZXR2YWw7DQo+ID4gDQo+ID4gICAgICAgcmV0dmFsID0gdXNibmV0X2dldF9saW5rX2tzZXR0aW5n
cyhuZXQsIGNtZCk7DQo+ID4gLQ0KPiA+IC0gICAgIGNtZC0+YmFzZS5ldGhfdHBfbWRpeCA9IHBk
YXRhLT5tZGl4X2N0cmw7DQo+ID4gLSAgICAgY21kLT5iYXNlLmV0aF90cF9tZGl4X2N0cmwgPSBw
ZGF0YS0+bWRpeF9jdHJsOw0KPiA+IC0NCj4gPiArICAgICBpZiAocGRhdGEtPmludGVybmFsX3Bo
eSkgew0KPiA+ICsgICAgICAgICAgICAgY21kLT5iYXNlLmV0aF90cF9tZGl4ID0gcGRhdGEtPm1k
aXhfY3RybDsNCj4gPiArICAgICAgICAgICAgIGNtZC0+YmFzZS5ldGhfdHBfbWRpeF9jdHJsID0g
cGRhdGEtPm1kaXhfY3RybDsNCj4gPiArICAgICB9DQo+IA0KPiBBZ2FpbiwgdGhleSBQSFkgZHJp
dmVyIHNob3VsZCB0YWtlIGNhcmUgb2YgdGhpcy4gWW91IG5lZWQgdG8gc2V0DQo+IHBoeWRldi0+
bWRpeF9jdHJsIGJlZm9yZSBzdGFydGluZyB0aGUgUEhZLiBUaGUgUEhZIGRyaXZlciBzaG91bGQg
c2V0DQo+IHBoZGV2LT5tZGl4IHRvIHRoZSBjdXJyZW50IHN0YXR1cy4NCg0KVGhlIFNNU0MgUGh5
IGRyaXZlciBkb2VzIG5vdCBoYXZlIGFueSBNRElYIHNldHVwIGNvZGUsIGJ1dCBJIHRoaW5rIEkn
dmUNCmdvdCB0aGUgaWRlYSBub3cuDQoNCj4gDQo+ID4gK3N0YXRpYyB2b2lkIHNtc2M5NXh4X2hh
bmRsZV9saW5rX2NoYW5nZShzdHJ1Y3QgbmV0X2RldmljZSAqbmV0KQ0KPiA+ICt7DQo+ID4gKyAg
ICAgcGh5X3ByaW50X3N0YXR1cyhuZXQtPnBoeWRldik7DQo+IA0KPiBTbyB0aGUgTUFDIGRvZXMg
bm90IGNhcmUgYWJvdXQgdGhlIHNwZWVkPyBUaGUgcGF1c2UgY29uZmlndXJhdGlvbj8NCj4gRHVw
bGV4Pw0KDQpOb3csIEknbSB3b25kZXJpbmcgaG93IHRob3NlICJjYXJlIGFib3V0IHNwZWVkIiwg
InBhdXNlIiwgYW5kICJkdXBsZXgiDQp3b3JrIGluIHRoZSBjdXJyZW50IHNtc2M5NXh4LiAgSSBn
dWVzcywgd2UgZGlkIG5vdCB0b3VjaCBhbnkgb2YgdGhvc2UNCmFjdGl2aXRpZXMgd2l0aCBvdXIg
cGF0Y2hlcy4NCg0KVGhhbmtzIGEgbG90Lg0KQW5kcmUNCg0KPiANCj4gICAgICAgICBBbmRyZXcN
Cg==
