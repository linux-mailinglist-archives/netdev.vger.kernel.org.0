Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E37E15B0F1
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 20:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728988AbgBLT1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 14:27:30 -0500
Received: from mail-vi1eur05on2053.outbound.protection.outlook.com ([40.107.21.53]:6093
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727361AbgBLT1a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Feb 2020 14:27:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EVxBfGFqjaIcBt8ibzdiuKdamBWA/9sakrX0K9dxMck66KdRxTQVqGJWOdf6m6DyMvSDapgGrEODfex+6Cjf5oqbw1oZKod0kjX5EeIz5yqvooXJk8cZdLxvDnJTVoMGfBH3JKDSmK9SUGYUBKGIDps4lrfs7iywopWpOCxdOn6wCXx8GnqGZlrDap3c/XuS+XIp9SQEeqK0nB0eMDg8eIml5nXTigNrWGjNHpqdaL/VOOd0YjuOyampZGqT2CiDG4Hnu49g4dsNUk+9x/pV8NGGZ2n6Gl/KwPPIRXbMA1+4p4DReuj8sTAiGe5VPnavB6uxoddR8B7bjC/7OU0t9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5dDA5KYmnYfflMEegg7QEnXjyvvqpctmDsL5Mdz+pLQ=;
 b=e8jfo5P/e9ZZjslQ/a0NMnvgtDFatb+bI9noo04sF9dYcXpeIuSzpd3Ocm97ruAXlqFaG9L1WPxbpPKPW9fvZveXQegxDFTCklzmyJXwvPu8Cfn1smh0HRkQWYdyU/O9uZiZ1QatQX70XJVcBu5dF6CEhbig1QZvKqBY1/8G0Osvs0WHAnhZOdYPe625nkrKrq7onjsvrxUHNStL1wU/pzULmwuVywGNuM14pHQG2/o0T2z81ASlizzQj4lfVx+nPQ5kpbYY3rYDys4HxNqJoDWEVGVTfkXn6/MWrN9JLmFH/uD5RKxl3gsTp5m0mAPloTMt/UAluwKVD+S8X0kXXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5dDA5KYmnYfflMEegg7QEnXjyvvqpctmDsL5Mdz+pLQ=;
 b=AfGUIvHITJLf7feoY6im+bbdhpthulMszM+sCTuPjkdd4gd0Qshxx07XzT2xjGbWbq9GOiBc9VfWM1GFsQXyDMbkR4I3iEtpIPB7X7dpDcQwnYNKOJVDYpqxYJGKifwKz4RSPm1kVWUpxu54zVy7lNmkBsid45NrSO9RNzThpbs=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6767.eurprd05.prod.outlook.com (10.186.160.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.22; Wed, 12 Feb 2020 19:27:26 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2707.030; Wed, 12 Feb 2020
 19:27:26 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "davem@davemloft.net" <davem@davemloft.net>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [pull request][net-next V3 00/13] Mellanox, mlx5 updates
 2020-01-24
Thread-Topic: [pull request][net-next V3 00/13] Mellanox, mlx5 updates
 2020-01-24
Thread-Index: AQHV4SuUZbQoaccCvUWFDYDbDhBaaqgWu6QAgAE27AA=
Date:   Wed, 12 Feb 2020 19:27:26 +0000
Message-ID: <fcabf5b8e31a7742be8bdb64da4e2d1d1d28040d.camel@mellanox.com>
References: <20200211223254.101641-1-saeedm@mellanox.com>
         <20200211.165434.1858453173885281372.davem@davemloft.net>
In-Reply-To: <20200211.165434.1858453173885281372.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.3 (3.34.3-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 18deb657-418a-45b7-feb2-08d7aff19804
x-ms-traffictypediagnostic: VI1PR05MB6767:
x-microsoft-antispam-prvs: <VI1PR05MB67670615019D038719544DD3BE1B0@VI1PR05MB6767.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 0311124FA9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(39860400002)(376002)(346002)(136003)(199004)(189003)(91956017)(76116006)(66946007)(26005)(6916009)(4326008)(66446008)(66476007)(64756008)(66556008)(8676002)(8936002)(81166006)(81156014)(54906003)(478600001)(316002)(36756003)(6486002)(2906002)(86362001)(6506007)(6512007)(186003)(5660300002)(558084003)(2616005)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6767;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JiLPMaHub249/EJJI+Gh0lXU6Ki5+j6ptKDTmbONjVNFaKq69WKi7ct1qJMt5mWbHJJt/+ok6XzU3s1pQz1mLk8TkHjaKMXtrIwewczu+0yWLu0xtszfzOZ3HUGvxeZ+ZiiyWSiEs3qmu1JsRLydbokAvwIWoOlW7GuwXXMP2k9JCT+y+jV+bi1+0QOdQVgfSk1Q2lyIYsz7vE4q3XeH/ONud4Uw7NuTIGz+iLRVtPPDsKbkfg/UnRv1v2LlfyGdttf4AhVogrWhwDON4+DVozm9IuSsR80+E+nlk8gdBZulZ0F2ZpyCTpY9Imzia8f5KeS2F5mcm6enLbl+Lzon2Ga6oBGoO92YetewJ+/31bwkRt11VbX8BpbAqzP6esgQxmy6GgA6+gvzjZVp9QnsSEukawbais3pX2TrRfJpuGSScxpMcrEPb1hzflNNM84m
x-ms-exchange-antispam-messagedata: ZLW8lFwW8uxzXVu3Rz6khwdNyFRM02vo1jfoS2Yr1tZU5MvkaaPViw98RLbikxNl/4v+qAt7XNguiz0ani+I5h5GNQJXOFHve56L/fTJR/g1Clpyz4Hnk1K6wnmmsSrn/4tC1LuHEy3ZfqDz7Fvfzw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <537E005389017046A1B24E9271B63E1C@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18deb657-418a-45b7-feb2-08d7aff19804
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Feb 2020 19:27:26.7238
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ThpEK8BCQao4s9Fni6Y3wf3pznZYBheewovrN+h3uAQ127NSrFaC4TSWioWQ0y/rhm8B2SO2PFgn3/Qvh7CQsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6767
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTAyLTExIGF0IDE2OjU0IC0wODAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+
IERlZmVycmVkIHVudGlsIG5ldC1uZXh0IG9wZW5zIGJhY2sgdXAsIHJlc3VibWl0IHRoaXMgdGhl
bi4NCj4gDQoNCk9oaCBzaG9vdCAhIGFuZCBpIHdvbmRlcmVkIHdoeSBuZXQtbmV4dCBpcyBzdGls
bCBxdWlldCBhbmQgcmMxIGlzIG5vdA0KbWVyZ2VkIHlldCAhIEkgaGFkIGVub3VnaCBjbHVlcyBu
b3QgdG8gc3VibWl0IGFuZCB5ZXQgSSBkaWQuLg0KTXkgYmFkLCB3aWxsIGRvIGJldHRlciBuZXh0
IHRpbWUuDQoNClRoYW5rcyENCg0K
