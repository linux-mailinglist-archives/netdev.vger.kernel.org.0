Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87C08BB494
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 14:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394551AbfIWM5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 08:57:45 -0400
Received: from mail-eopbgr50078.outbound.protection.outlook.com ([40.107.5.78]:31750
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2394080AbfIWM5o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Sep 2019 08:57:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AZqffRmbozv4ModMDCVi7d0LvKbaV7Wgz3q0YJTWwoutPVKRL5OS8qzLLiGctKl5ilIf3DvtjrwaZLZDwjtDj/j2BlxLngHZu1OEGEmgppp2txNM4Zc7GQk3EQ7RamFs8NoU8rUWpwbNSYnNXoG+kl9YhiYOTyCAt16bByUu+ne1cCmh67QbZ2iNjPcaM/9gE25nMzUYfiz8pHtwHAXb9+Tji4sOlByVDDhgQLvg/lGHlda0xmIAZY6LhEPFUMDwizsCAldw4MNCH6o0Y/j/1PFyykbNcgUxNh0JuDnQ8BvD1tdN1kwell2xsnHC70qB7TkJMtGIPffxlNvYEj595g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Yd6zugMcbrcZESMCy+bQJahhscfBkUtdqMKDtGP3JM=;
 b=G2jK80zKgRCQxsu+lu5qNfXjhVvFex+UnkcWNq6u1MfbOPqRJOkmRzLhmnYuzEChfDdOmmu8XTgEurfFqLoVm4oS7G+JiWTu0Sr8VIsAuwCA/ulxE5mW35UZq7oP5ONcNtKvLojFf4/vazr5BBZRNH+xQvI3zwUEAYT+sEITsP9aNXcVmdkKGS8PwHEp0XYAReoVdeg9A7CfHjs3ICB3w+LFbyPDm5BhTuYetjKIvKlL7B4mUy57/ut1J60/oYXSNgqvByBymoM4uvJEHIKzZtMw+z103QnLY5NVxzRXbBnYsaYEzsqla5HYG4eTsnlzXsmsow2hddJwbGzmE9dLOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Yd6zugMcbrcZESMCy+bQJahhscfBkUtdqMKDtGP3JM=;
 b=CeDGnWXggS3ScfWTnWme4908BzOSSn2y3RqlAjAU4FV5vNulSnZr/GNhiC4SsbzEZy6aWR//oYn7V3uYoOAo0H9M6hgmJiLmqLPL4ERUQvERmHet2QWrpN2inIvVMagDVaPfHyfSg1QkqN42i0iihHTSq/n+5oxw4D+XmkMs6nE=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2212.eurprd05.prod.outlook.com (10.168.37.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.25; Mon, 23 Sep 2019 12:57:41 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::dd87:8e2c:f7ed:e29b]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::dd87:8e2c:f7ed:e29b%9]) with mapi id 15.20.2284.023; Mon, 23 Sep 2019
 12:57:41 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "zhongjiang@huawei.com" <zhongjiang@huawei.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net/mlx5: Remove unneeded variable in mlx5_unload_one
Thread-Topic: [PATCH] net/mlx5: Remove unneeded variable in mlx5_unload_one
Thread-Index: AQHVaYvRsuIrAOzWrkqFyb9MhUmdeactGrYAgAwvIoA=
Date:   Mon, 23 Sep 2019 12:57:41 +0000
Message-ID: <e5e341e9d89cd8d278e651ce2ee6a5a84636813a.camel@mellanox.com>
References: <1568307542-43797-1-git-send-email-zhongjiang@huawei.com>
         <20190915.195346.491621328476847786.davem@davemloft.net>
In-Reply-To: <20190915.195346.491621328476847786.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [89.138.141.98]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5fad7fbd-77e0-4e4b-5ced-08d740259e6b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2212;
x-ms-traffictypediagnostic: AM4PR0501MB2212:
x-microsoft-antispam-prvs: <AM4PR0501MB2212BFFD26FB8AF3F7AA73FFBE850@AM4PR0501MB2212.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1468;
x-forefront-prvs: 0169092318
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(396003)(376002)(39860400002)(366004)(199004)(189003)(76176011)(110136005)(4326008)(14454004)(476003)(305945005)(256004)(91956017)(66556008)(66476007)(66446008)(64756008)(66946007)(76116006)(102836004)(2501003)(86362001)(478600001)(4744005)(8936002)(25786009)(229853002)(6246003)(486006)(2616005)(99286004)(6436002)(3846002)(6506007)(36756003)(8676002)(81156014)(81166006)(71200400001)(7736002)(118296001)(66066001)(316002)(26005)(11346002)(6116002)(186003)(446003)(5660300002)(58126008)(71190400001)(2906002)(6486002)(6512007)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2212;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: um1+aWPoR8ZWztp7zBMZYHzhRPV0Fi2DB7Pt0rQv+QZVnIN3LDUawgfBr+VEZvC++73n7csXwiKsluQ5oe5xHkrZBoJWByCRQkuFbcLiPFa8Q4Cghod7arCih6NhBgwtDQnDKxkVfxabIFenf+56LzWR7ydNC6YcAMNQ2nrPmxWAlkMelBnsXEWG/5F1YcZInjbKLYKqQALKNFolJ9sJPY8Nfexc7R9dYuJ1OO4Orh07R3Rma5LanEaBRYJuUqDN9m239rPBbnBwAJvJKdyak4YweYtJjd5d4xcOJhwpmi8XMSBxFqjKkNjU9BOd6m1SP0CxsL1xaanQ+PFWmVdF6gCCkPqh8h0Pv1Jb46o748LWT0jkn1NAiZmKfdiusuwfL+BIDrO5pTeu0PmPAebGp3p+LHVLttz6AfclwVHz9+M=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <405074789A0FDA4CBD7C529F6BB9DF68@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fad7fbd-77e0-4e4b-5ced-08d740259e6b
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2019 12:57:41.1108
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bUsE+yXQNHY8Jx68IflG6As+mfcgeH+yheU3UFRF4LsWaGfJKTB67d+l6/DSxp7/cMUn/2kFVMaStzX9ZR1aRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2212
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU3VuLCAyMDE5LTA5LTE1IGF0IDE5OjUzICswMTAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+
IEZyb206IHpob25nIGppYW5nIDx6aG9uZ2ppYW5nQGh1YXdlaS5jb20+DQo+IERhdGU6IEZyaSwg
MTMgU2VwIDIwMTkgMDA6NTk6MDIgKzA4MDANCj4gDQo+ID4gbWx4NV91bmxvYWRfb25lIGRvIG5v
dCBuZWVkIGxvY2FsIHZhcmlhYmxlIHRvIHN0b3JlIGRpZmZlcmVudA0KPiB2YWx1ZSwNCj4gPiBI
ZW5jZSBqdXN0IHJlbW92ZSBpdC4NCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiB6aG9uZyBqaWFu
ZyA8emhvbmdqaWFuZ0BodWF3ZWkuY29tPg0KPiANCj4gU2FlZWQsIGp1c3QgdGFrZSB0aGlzIGRp
cmVjdGx5IHZpYSBvbmUgb2YgeW91ciB0cmVlcy4NCj4gDQoNCkFwcGxpZWQgdG8gbmV0LW5leHQt
bWx4NS4NCg0KVGhhbmtzLA0KU2FlZWQuDQoNCg==
