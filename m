Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F14310FBBF
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 11:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbfLCK37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 05:29:59 -0500
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:53790 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725954AbfLCK36 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 05:29:58 -0500
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 2AE49C038E;
        Tue,  3 Dec 2019 10:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1575368998; bh=GQvvwXfp6Wu3YxCV4uDd/otutEowcrPuxOlIahBofpA=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=bhPIgMrESaDz3XoVKF2w94Az05FE3YOjCCAFK24JOvn5FgWTw/jcmcPNHUkmH6hXm
         xw9OG+labIHGZW/c6ye9sBqWLyqtXEkMMiVVXhpLTr+V74Q++kzzMZdjJAeiKNYkyj
         RtWO3wDCjPtxvnKvHBBVWhBjV0n6f8Gq0ccnSQBbj5O2HXm2izpgd81efbotiN3Qcg
         QI0BhUbmihVsPkD5dsZkrIOGawEIceJ3V/euk1SLvEMcl9yGyVppStKfYukMXBmZuV
         9Cg1j/v1DXcAPXvrPVMFvoBQCoUL083Os/9C6AjZKdF79SNRmXqodcooE3O/SbCULs
         K5eMP0zAoy6iA==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 7C5CEA007E;
        Tue,  3 Dec 2019 10:29:57 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 3 Dec 2019 02:29:57 -0800
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Tue, 3 Dec 2019 02:29:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LT8dlv5QlRtC4hdkhLOXKbeYl97WaVOySN+ttRluf56i5RhVndaCUKkaCboA+JjEtmjXydndb8uVcoQ2caSro9pBUVSFiuHbJ2veXZMCH25cd+t68JwaTmiIPI6iIWvn6MWkrQUYr16nZR0zrwuGWI12zbCjh+lR3VQZ21KnD3LzzShfd2zLaH2T96gRAT4GKFe2EPO4NLskEzUyS+CuARW2kd1x0qeiSKms3/sXOd2DK2DqDc5TI800Bz/TP7KjHoTGx+aESTXwTAeAEyrlNnvVp4nfx63ZNHrQl8qbj27OH/oyoxLe80JSOv3Wi7eklPPz6QAO/93xei3BbNscqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GQvvwXfp6Wu3YxCV4uDd/otutEowcrPuxOlIahBofpA=;
 b=Kzs9G7YYCzrbM9SMklcryjfUWltIB1x1E/kFTH2OR5RxnDLrUXX5X0H1X2JOcwlbJ6McIhiDZix5kygMT695VrMXx99BtphqLQVpb9LzaN3HddrDns29F0kug0QYA7rkDyEhNddIJ6WZfiWRJ9akMv2tuT+B0a458iGuPrMDL9Aw8HkL1CiyNlqr0Rk/GxGUXNEpXAhQWEbCHjmij68M6PwjdcaqxsDoyexac8Hu02mDo2yD2uSzOTZq68OZ1xJrjc3HeHlELMe8X9nTdEFKsSZYn/+OQTnhOeMQ6kbAzXz2t0yNbdv9N2JrN9RaG9qyTDz6RsWYBInIP2s8/Kt+pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GQvvwXfp6Wu3YxCV4uDd/otutEowcrPuxOlIahBofpA=;
 b=ITrEtDtIUgJG7ax3u1JuZDafk9UHPuaqt4MkLQhB2X+VMEJp40Qti+ET3J7Yj8duoa65DzlpFRYroXyayPjwmu3Zn+KGNdybR/psjAuqRpq6MiFxnIZS2QHwCeqp2e6brw9qaMEyPCYIRBf+9vYCEgMZZlERvwoxvNi9wHO4768=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3267.namprd12.prod.outlook.com (20.179.65.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.18; Tue, 3 Dec 2019 10:29:55 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::3d20:3a36:3b64:4510]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::3d20:3a36:3b64:4510%7]) with mapi id 15.20.2516.003; Tue, 3 Dec 2019
 10:29:55 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Jesus Sanchez-Palencia <jesus.sanchez-palencia@intel.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Po Liu <po.liu@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Subject: RE: tperf: An initial TSN Performance Utility
Thread-Topic: tperf: An initial TSN Performance Utility
Thread-Index: AdWpvq0AbHwx928HRWCrJZjwLL/EqwAA0WEAAABsyUA=
Date:   Tue, 3 Dec 2019 10:29:54 +0000
Message-ID: <BN8PR12MB32665269FD80546B81708A93D3420@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <BN8PR12MB3266E99E5C289CB6B77A5C58D3420@BN8PR12MB3266.namprd12.prod.outlook.com>
 <CA+h21hpTLOtjobFjGt5dzJ+nZvLjAMfCO+_-3OCCAaSE1yMSfQ@mail.gmail.com>
In-Reply-To: <CA+h21hpTLOtjobFjGt5dzJ+nZvLjAMfCO+_-3OCCAaSE1yMSfQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 66de4aaf-8cd5-45ed-d9fd-08d777dbbd1a
x-ms-traffictypediagnostic: BN8PR12MB3267:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB3267ECB05F80896DA17452A7D3420@BN8PR12MB3267.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 02408926C4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(199004)(189003)(71200400001)(71190400001)(102836004)(52536014)(6916009)(14454004)(8676002)(11346002)(8936002)(305945005)(81166006)(7736002)(81156014)(3846002)(256004)(6116002)(25786009)(498600001)(2906002)(74316002)(186003)(26005)(229853002)(76116006)(66476007)(54906003)(86362001)(6436002)(1411001)(66946007)(66556008)(33656002)(6246003)(66446008)(64756008)(9686003)(6506007)(55016002)(99286004)(5660300002)(76176011)(4326008)(7696005)(4744005)(446003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3267;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TIKn9rFGoEx1LIXhoOiquKrXlJ6IqEp6QsNeHoRmJvX/jpt3skmp/xV1TXn6yKC+cXIeJLSUeYtg9UOf9Zk+WvHlxiX83s3DG2TPyAXzM6bJSdVb/qGjbW2HsR/0M57ZFN20YYf6z5jQu9TTEKFVyd3vvBMpYl+4ZGcdmVwqVb83BkactyVXcXsQ4lABo71jZe01zIeHbV4lBdo2vbHvk2vD5tNe32H0oR16gMsJpNpmSXjsWPJSK3siDU7OUO52RfGhg3qr4bcflbNC5PEtx4QXhMjk5Bfiy2vtCpVhtMUzzL1PebxNjlLEJS2Zvp/fKaMmeo/YtNn1cbK+IEwCufvpn25HX5jug5cKQdieoPz4EpLSdmQGippKJrrT9Fqtii0mHk4qcT8ypKRQUgt0pm8aIUoBbYbhQlUarI49Gv6SmHlJ2UH5Tqh/ht1hD4DF
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 66de4aaf-8cd5-45ed-d9fd-08d777dbbd1a
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2019 10:29:54.8182
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Dsk4Olr3Mu4gd9QscG+s1Nmw1Gt/C0mnnT807rXjYba2BQy0KetO2yuFhC00LAwUvYJkiErgYIaFtwzNSLXHlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3267
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogVmxhZGltaXIgT2x0ZWFuIDxvbHRlYW52QGdtYWlsLmNvbT4NCkRhdGU6IERlYy8wMy8y
MDE5LCAxMDoxMDo1NCAoVVRDKzAwOjAwKQ0KDQo+IFNvdW5kcyBuaWNlLCBJJ20gaW50ZXJlc3Rl
ZCBpbiBnaXZpbmcgdGhpcyBhIHRyeSBvbiB0aGUgTFMxMDI4QSBFTkVUQy4NCj4gDQo+IERvIHlv
dSBoYXZlIGFueSBtb3JlIHRvb2xpbmcgYXJvdW5kIHRwZXJmPyBEb2VzIHRoZSB0YWxrZXIgYWR2
ZXJ0aXNlDQo+IHRoZSBzdHJlYW0gaW4gc3VjaCBhIHdheSB0aGF0IGEgc3dpdGNoIGNvdWxkIHJl
c2VydmUgYmFuZHdpZHRoIHRvbz8NCg0KTm8sIGJ1dCB0aGF0IHdvdWxkIGJlIGEgZ3JlYXQgYWRk
aXRpb24gISBVbmZvcnR1bmF0ZWx5LCBmb3Igbm93IHlvdSBuZWVkIA0KdG8gdXNlIHZsYW4gdXRp
bGl0eSBhbG9uZyB3aXRoIHRjIHRvIGNvbmZpZ3VyZSBldmVyeXRoaW5nLiBNeSBrbm93bGVkZ2Ug
DQpvZiB0YyBpcyBub25lIHNvIEkgZG9uJ3Qga25vdyB3aGF0J3MgbmVjZXNzYXJ5IHRvIGp1c3Qg
dXNlIHRwZXJmIHRvIA0KY29uZmlndXJlIGV2ZXJ5dGhpbmcgLi4uDQoNCj4gRG8geW91IHBsYW4g
dG8gYWRkIHRoaXMgdG8gdGhlIGtlcm5lbCB0cmVlIChlLmcuDQo+IHRvb2xzL3Rlc3Rpbmcvc2Vs
ZnRlc3RzL3RzbiBvciBzdWNoKSBvciBob3cgZG8geW91IHdhbnQgdG8gbWFpbnRhaW4NCj4gdGhp
cyBsb25nLXRlcm0/DQoNCldlIHdpbGwgZm9sbG93IHRoZSBwYXRoIHRoYXQgY29tbXVuaXR5IHRo
aW5rcyBpdCBzdWl0cyBiZXR0ZXIgLi4uIA0KIA0KPiBJJ3ZlIGFkZGVkIG1vcmUgcGVvcGxlIGZy
b20gTlhQIHdobyBtYXkgYWxzbyBiZSBpbnRlcmVzdGVkLg0KDQpUaGFua3MgVmxhZGltaXIuDQoN
Ci0tLQ0KVGhhbmtzLA0KSm9zZSBNaWd1ZWwgQWJyZXUNCg==
