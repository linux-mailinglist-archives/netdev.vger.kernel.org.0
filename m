Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59D52A2930
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 23:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbfH2Vtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 17:49:39 -0400
Received: from mail-eopbgr780107.outbound.protection.outlook.com ([40.107.78.107]:16050
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726894AbfH2Vti (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 17:49:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UW54eF8ngznCQ98FYSCTUcVRhAekE3YKE0lLMpd9uElyXyG8Mo4xslvHloyR6krXhxjlBdkt40vGB0IrmzSapfInrtIF2lisKPjWnCn70uTNpFMsd5FLBkhgJL/9fbyLzRjgjwwo9vNDyT/FOENBx97xLso4Dx6y9GCcg2f++1eXYlK5nh+W/j5GBJv8IT5xq0uJZjGoXQBEQSZxlxmxjK6tal5DWeIZQE0ZGLmY5Y58HvjTNlNStR5GRlzVTeU1TA4Vq/0RGpdkpLsQKBEgv43UHMxKuoW8wko1bT+K5gVzLgNLrg5ypa9sVp++NHdV2s4YZgYMsgfNhVLW7K/1JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zV9PUC1dnM0wLWpdExAAu+3G7MdDcy+b5BhkYxWtOCQ=;
 b=mMSMctQQGgf3Xvu8h1YJqi/HdXNdIssyv2kLztGjxkrCMn8gI6cOeK0SAhjvPcXW9mwJqf2dqHsv7YLBsG/YvUS/+aMENisutuiTtT29qPfUaXAjDbvSVoPpDlGqJk7eWn6HoC7Wv7E+GFlyk45azRTUSnfC4+WY2FtL7K6kZT6sev6NugEnLudYq9pxTfBJvtjTTTW2WXq4On7EjFjcJD5WKTBPxBE6koR02BrQR9mC3gHdtpuP7qOcefiWk81bhIDyqQ5UTPwYxwGfHI/U9Nv8uYeo53OAqACZ0NbvxCHuvDBz19o27et2lPvQ533i9J0i53J2oMhSrbZcSZpV5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zV9PUC1dnM0wLWpdExAAu+3G7MdDcy+b5BhkYxWtOCQ=;
 b=cz1WtPMCfX8J7/RltII/jChFr+rkrmCev/simGqfNvp5YBBXyrcOEMny+ASEgT35w1hodKxbOp5IuhPzJb1/Zf1bmTEVKVz7+MIkL1O9csaFljo9HBiyI2ox2cdWLNdpWNsL3+rNnT+qvqeKSlNl+lrXGJKlPryPwBxrpK1nSl4=
Received: from DM6PR21MB1337.namprd21.prod.outlook.com (20.179.53.80) by
 DM6PR21MB1243.namprd21.prod.outlook.com (20.179.50.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.3; Thu, 29 Aug 2019 21:48:56 +0000
Received: from DM6PR21MB1337.namprd21.prod.outlook.com
 ([fe80::28a1:fa7:2ff:108b]) by DM6PR21MB1337.namprd21.prod.outlook.com
 ([fe80::28a1:fa7:2ff:108b%5]) with mapi id 15.20.2220.000; Thu, 29 Aug 2019
 21:48:56 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>
Subject: RE: linux-next: Tree for Aug 29 (mlx5)
Thread-Topic: linux-next: Tree for Aug 29 (mlx5)
Thread-Index: AQHVXqOWWrDg6HQUkEyJ2ZhpB0y05acSijuAgAAa0ICAAAHvgA==
Date:   Thu, 29 Aug 2019 21:48:56 +0000
Message-ID: <DM6PR21MB13379A89D3A57DCFD6E0D419CAA20@DM6PR21MB1337.namprd21.prod.outlook.com>
References: <20190829210845.41a9e193@canb.auug.org.au>
         <3cbf3e88-53b5-0eb3-9863-c4031b9aed9f@infradead.org>
         <52bcddef-fcf2-8de5-d15a-9e7ee2d5b14d@infradead.org>
 <c92d20e27268f515e0d4c8a28f92c0da041c2acc.camel@mellanox.com>
In-Reply-To: <c92d20e27268f515e0d4c8a28f92c0da041c2acc.camel@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=haiyangz@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-08-29T21:48:54.8270196Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=07cb2864-f906-4fc2-9c01-dd186871da66;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=haiyangz@microsoft.com; 
x-originating-ip: [2001:4898:80e8:1:210d:4c73:691f:4cc4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ff5197fe-70e5-4892-c6f6-08d72ccab12f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR21MB1243;
x-ms-traffictypediagnostic: DM6PR21MB1243:
x-microsoft-antispam-prvs: <DM6PR21MB12433D27AEEB88773A7656B3CAA20@DM6PR21MB1243.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0144B30E41
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(376002)(346002)(366004)(136003)(39860400002)(52314003)(13464003)(53754006)(199004)(189003)(64756008)(256004)(53546011)(22452003)(10290500003)(11346002)(66556008)(4326008)(86362001)(25786009)(76116006)(5660300002)(52536014)(9686003)(10090500001)(102836004)(110136005)(6246003)(54906003)(71190400001)(53936002)(316002)(8990500004)(2501003)(476003)(6436002)(76176011)(8936002)(14454004)(8676002)(7696005)(229853002)(2906002)(66476007)(66946007)(55016002)(99286004)(66446008)(486006)(71200400001)(186003)(74316002)(46003)(7736002)(6506007)(305945005)(2201001)(81156014)(446003)(478600001)(6116002)(33656002)(81166006);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1243;H:DM6PR21MB1337.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: eV0/CoJZwYZI9RkrM5fCwbo7Zwc8ZIo78438xytNiih4MinkWjN3CAnbw/NDYQLYoci7VIqq3LU7pRpO1OrmSNFBgUJbDogVu4SQfxh7maVF04SWmC/TADf88K+/LA1ajBq1qrpMmOlmhqda59hYBSbDFfHLv/uqYXudTevfsP4oLDA0Y/9UUXCwWiKLCFUl2NTpt8Z6/sJqHOx2omezuEAau74Y5ONX0QlK0OhTInHR8oLWOjZQ1XRkJNDXcgiOs6XihxaSuKEIV0JHsA+4tdqHTG8K8LXPgJOsGsOGYGeba+mofVhbCIIPHB2JUhgLJEhSAvOLAqa/8fIDFRXDyj9K7ms/vpi2hT1dTjwtRQf42Le5M4YKr4kmNdJGBR4zu98Pe7n/Mcj9Tpza9zLloklhKlAMZaRXesabno5Vc6Y=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff5197fe-70e5-4892-c6f6-08d72ccab12f
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2019 21:48:56.2923
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wj6j8AmAJAUoYgWnvD0T0S6ghiZNfXQ50wZJnu7FdIYZ03cAVq8ow0gmLjcKZRGaEL63CWlTITH44+xB61K3yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1243
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU2FlZWQgTWFoYW1lZWQg
PHNhZWVkbUBtZWxsYW5veC5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCBBdWd1c3QgMjksIDIwMTkg
MjozMiBQTQ0KPiBUbzogc2ZyQGNhbmIuYXV1Zy5vcmcuYXU7IEVyYW4gQmVuIEVsaXNoYSA8ZXJh
bmJlQG1lbGxhbm94LmNvbT47IGxpbnV4LQ0KPiBuZXh0QHZnZXIua2VybmVsLm9yZzsgcmR1bmxh
cEBpbmZyYWRlYWQub3JnOyBIYWl5YW5nIFpoYW5nDQo+IDxoYWl5YW5nekBtaWNyb3NvZnQuY29t
Pg0KPiBDYzogbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgbmV0ZGV2QHZnZXIua2VybmVs
Lm9yZzsgTGVvbg0KPiBSb21hbm92c2t5IDxsZW9ucm9AbWVsbGFub3guY29tPg0KPiBTdWJqZWN0
OiBSZTogbGludXgtbmV4dDogVHJlZSBmb3IgQXVnIDI5IChtbHg1KQ0KPiANCj4gT24gVGh1LCAy
MDE5LTA4LTI5IGF0IDEyOjU1IC0wNzAwLCBSYW5keSBEdW5sYXAgd3JvdGU6DQo+ID4gT24gOC8y
OS8xOSAxMjo1NCBQTSwgUmFuZHkgRHVubGFwIHdyb3RlOg0KPiA+ID4gT24gOC8yOS8xOSA0OjA4
IEFNLCBTdGVwaGVuIFJvdGh3ZWxsIHdyb3RlOg0KPiA+ID4gPiBIaSBhbGwsDQo+ID4gPiA+DQo+
ID4gPiA+IENoYW5nZXMgc2luY2UgMjAxOTA4Mjg6DQo+ID4gPiA+DQo+ID4gPg0KPiA+ID4gb24g
eDg2XzY0Og0KPiA+ID4gd2hlbiBDT05GSUdfUENJX0hZUEVSVj1tDQo+ID4NCj4gPiBhbmQgQ09O
RklHX1BDSV9IWVBFUlZfSU5URVJGQUNFPW0NCj4gPg0KPiANCj4gSGFpeWFuZyBhbmQgRXJhbiwg
SSB0aGluayBDT05GSUdfUENJX0hZUEVSVl9JTlRFUkZBQ0Ugd2FzIG5ldmVyDQo+IHN1cHBvc2Vk
IHRvIGJlIGEgbW9kdWxlID8gaXQgc3VwcG9zZWQgdG8gcHJvdmlkZSBhbiBhbHdheXMgYXZhaWxh
YmxlDQo+IGludGVyZmFjZSB0byBkcml2ZXJzIC4uDQo+IA0KPiBBbnl3YXksIG1heWJlIHdlIG5l
ZWQgdG8gaW1wbHkgQ09ORklHX1BDSV9IWVBFUlZfSU5URVJGQUNFIGluIG1seDUuDQoNClRoZSBz
eW1ib2xpYyBkZXBlbmRlbmN5IGJ5IGRyaXZlciBtbHg1ZSwgIGF1dG9tYXRpY2FsbHkgdHJpZ2dl
cnMgbG9hZGluZyBvZg0KcGNpX2h5cGVydl9pbnRlcmZhY2UgbW9kdWxlLiBBbmQgdGhpcyBtb2R1
bGUgY2FuIGJlIGxvYWRlZCBpbiBhbnkgcGxhdGZvcm1zLg0KDQpDdXJyZW50bHksIG1seDVlIGRy
aXZlciBoYXMgI2lmIElTX0VOQUJMRUQoQ09ORklHX1BDSV9IWVBFUlZfSU5URVJGQUNFKQ0KYXJv
dW5kIHRoZSBjb2RlIHVzaW5nIHRoZSBpbnRlcmZhY2UuDQoNCkkgYWdyZWUgLS0NCkFkZGluZyAi
c2VsZWN0IFBDSV9IWVBFUlZfSU5URVJGQUNFIiBmb3IgbWx4NWUgd2lsbCBjbGVhbiB1cCB0aGVz
ZSAjaWYncy4NCg0KVGhhbmtzLA0KLSBIYWl5YW5nDQo=
