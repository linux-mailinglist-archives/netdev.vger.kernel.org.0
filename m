Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8A7EF1733
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 14:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbfKFNeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 08:34:03 -0500
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:39936 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726673AbfKFNeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 08:34:02 -0500
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 55949C0E5B;
        Wed,  6 Nov 2019 13:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1573047242; bh=M5SrBaBf6d/nnv/X1qihvp0yS1o/70WIt2VtLCY6HSA=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=aMM+khj16tqEQg2y0VjktgAwxkU1RXb34nOvBrTGppQybtdAC6S9NSah9FUTFVXzO
         HWR/LSyb801iBq1IJPLnAxy6yKL8YZG70NnC8see4TIKM9rDGLg1ZsrEhvrc0gh14+
         ygwwtllZp7lCsH6E3NRHaVEIvKgFwIQiNlrQwgsaatUB/d0IlvgNwCYA11wCU6iRrS
         GavzcywWpwSzzYWq5v6ityb+sT9dJ1YTUTH+hgUf0NZVAVTzaJIzdCjgfpsVs79bdy
         FOUw60NkldgzGbJj4S+qdHxtBH3kS1QVLWg0+PciFt02hYs0pFr6XhxMSn0C9/exIY
         yUzQcsXQLgHIA==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 0156BA0085;
        Wed,  6 Nov 2019 13:33:56 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 6 Nov 2019 05:33:11 -0800
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Wed, 6 Nov 2019 05:33:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UR2Z6qKHKcD8gOdJQLXMBPGESWvRvu/7zcZkGAonA33Y7wJylJmDdmbbEbU0bYCMKm74OqLRwDaAYjuV7hw/V8nI6Qh92+x8vpKoiycLYT5rvROJ3+KAQIvPi11jGkN2w0lVNNjxyD953c7UXo7hBB8vxIX4VHSO8vML7vlhYyl4+b7bout8DCtFLzWKzISEusCpaBKcKzzKr7PWSB3Jtq6VWNpjFq1w95zjHXkxwL49xWZ+jsA+UISi5aH15gGoJvv64JmI7uEEcHAiNWpSexE/X0ElpPRmjo9AkdT7PUV7adRzQ1JHNL1qJePAKre5rjoxHeCm1DoUFX4abChMQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M5SrBaBf6d/nnv/X1qihvp0yS1o/70WIt2VtLCY6HSA=;
 b=I71t4d5WAU1jXImxQtIa9YgiPTQ2oARi1lGJDiCYO7h6rEgXXkgwB7E1SHtloEhQqnrEfAwc5ZruDveD3n7/RpOYgmyuyGS17jptfCYGB15dQ6SoUjEN+qYdFxtv6ATR4RYJ6kN7t+LZ62bgrbUtr7tBSMTNMinmp6X7tFneNGp8gU+kpFeHKwbC+HJoFK+2eVSviMbxmtn5i7c383tS8oNEBGtUHqlHdDenvsxWb+5TJRhNW7+hOqiqtHM38W8kXzSbkNEn9r1msPnsN/rJWNxMpdnXw79ibrTyZYJHgAaobCXrPkkSZLit2bvKxJ8zOizPquD24UhalqkkkhrzNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M5SrBaBf6d/nnv/X1qihvp0yS1o/70WIt2VtLCY6HSA=;
 b=M0QdMkqUBdq4LX7JglmUhnDy0ND/822dMlDOzplTFBUUlpT52c+4PouG0dic6KFyruXLgiYWrHoH9eHAhTUjQ/gvHmsSRaHye5yPyj4l89bOy8LCwwp2k2/9AIUpnfQhyN2JzZ/HUoKJV9cttXEuMJ8IJuXS/zkXdAh++2slRyM=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3426.namprd12.prod.outlook.com (20.178.212.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.22; Wed, 6 Nov 2019 13:33:05 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::f060:9d3a:d971:e9a8]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::f060:9d3a:d971:e9a8%5]) with mapi id 15.20.2430.020; Wed, 6 Nov 2019
 13:33:05 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Josh Hunt <johunt@akamai.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>
Subject: RE: USO / UFO status ?
Thread-Topic: USO / UFO status ?
Thread-Index: AdWPLBeus8XJlFS/Sue5aUntLc/tSwALvOGAAANGMQAAGxmwMAEF6g7QACWcOHA=
Date:   Wed, 6 Nov 2019 13:33:05 +0000
Message-ID: <BN8PR12MB326692330C58F90DDB9916A0D3790@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <BN8PR12MB326699DDA44E0EABB5C422E4D3600@BN8PR12MB3266.namprd12.prod.outlook.com>
 <CA+FuTSdVsTgcpB9=CEb=O369qUR58d-zEz5vmv+9nR+-DJFM6Q@mail.gmail.com>
 <99c9e80e-7e97-8490-fb43-b159fe6e8d7b@akamai.com>
 <BN8PR12MB3266E16EB6BAD0A3A1938426D3630@BN8PR12MB3266.namprd12.prod.outlook.com>
 <BN8PR12MB326627EECB503FD44760CF05D37E0@BN8PR12MB3266.namprd12.prod.outlook.com>
In-Reply-To: <BN8PR12MB326627EECB503FD44760CF05D37E0@BN8PR12MB3266.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cd814e40-c091-4f91-f501-08d762bddad5
x-ms-traffictypediagnostic: BN8PR12MB3426:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB34264B968393E89E2B42E134D3790@BN8PR12MB3426.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:386;
x-forefront-prvs: 02135EB356
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(346002)(376002)(366004)(396003)(189003)(199004)(11346002)(446003)(486006)(5660300002)(476003)(25786009)(52536014)(8936002)(8676002)(256004)(81166006)(81156014)(2906002)(71200400001)(71190400001)(6116002)(3846002)(33656002)(4326008)(110136005)(54906003)(229853002)(102836004)(316002)(14454004)(6436002)(66066001)(7696005)(76176011)(9686003)(99286004)(55016002)(6246003)(6506007)(107886003)(478600001)(66946007)(76116006)(186003)(66446008)(7736002)(305945005)(64756008)(74316002)(26005)(86362001)(66476007)(66556008);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3426;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZkIYbx+XQ8hwtYywhUQ18pi1dEhVlRcfljPmi1zehZ72lZhf61uYtOz/rcWfevf47DPyCX7XNVWHzaMHGFUJ30iSZC/XMTI9RT4JGQ7pToJEP7U2dRZakiJtBMNTxu912t23F951mgU/h0NOOVGC1EeDWfzVJqZjOqMRM547hgSZcFxnR5dh4oChBoUKpNbBIyZ8wUp8Jc6riPOziM4dDrlrO70UAA7Mc6aXhDrcbTxO/bO+m97/8Gnb3oUe1hMu5LaFdeizuKBjzc/atM0/8fjQrRa4xodeR/K9+OIG3p+ELunhWKKyEbQP7hHt6F2TA/7qVqYCOOM+WKKu2hmoeIhXpiv64FiBwBla6E0bUFltA6OSHQRxiYA/UgcJag3lNLies2k616B6oo5Gcv51SNPocku07jRdqFlihxM3fdbjktB3f3Q00KwtZoOi56SE
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: cd814e40-c091-4f91-f501-08d762bddad5
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2019 13:33:05.4781
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8jdrBsLDkMBL5FV07MtYK4ImPjyExVWthXcLl46HXHgW7sbsopF1Z0wDPynncQRCbeDCuy/xjLQ3UUioEtdw3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3426
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSm9zZSBBYnJldSA8am9hYnJldUBzeW5vcHN5cy5jb20+DQpEYXRlOiBOb3YvMDUvMjAx
OSwgMTU6MjQ6NTQgKFVUQyswMDowMCkNCg0KPiBGcm9tOiBKb3NlIEFicmV1IDxqb2FicmV1QHN5
bm9wc3lzLmNvbT4NCj4gRGF0ZTogT2N0LzMxLzIwMTksIDEwOjIwOjM3IChVVEMrMDA6MDApDQo+
IA0KPiA+IFdlbGwsIEknbSBtb3JlIGludGVyZXN0ZWQgaW4gaW1wbGVtZW50aW5nIGl0IGluIHN0
bW1hYy4gSSBoYXZlIHNvbWUgSFcgDQo+ID4gdGhhdCBzdXBwb3J0cyBVU08gYW5kIFVGTy4NCj4g
DQo+IEhpIEpvc2gsDQo+IA0KPiBVc2luZyB5b3VyIHNjcmlwdCB0aGVzZSBhcmUgdGhlIHJlc3Vs
dHMgSSBnZXQ6DQoNCkFuZCBub3csIHdpdGggZnVsbCBiZW5jaG1hcms6DQoNClVEUCBHU08gT246
DQokcGt0X3NpemUJa0IvcyhzYXIpCU1CL3MJQ2FsbHMvcyBNc2cvcyBDUFUJTUIyQ1BVDQo9PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09DQox
NDcyCQkxMTQ3ODYuMzUJMTA4CTc3NjgwCTc3NjgwCTQyLjYzCTIuNTMNCjI5NDQJCTEwODA1NS4x
MQkxMDMJMzcwNzUJMzcwNzUJMjMuMwk0LjQyDQo1ODg4CQkxMTE4MjAuMjUJMTA4CTE5MzA5CTE5
MzA5CTEwLjY4CTEwLjExDQoxMTc3NgkJMTEzODMyLjA4CTExMAk5ODY0CTk4NjQJNi4xCTE4LjAz
DQoyMzU1MgkJMTE0MzMwLjczCTExMQk0OTYyCTQ5NjIJMy4wNQkzNi4zOQ0KNDcxMDQJCTExNDc1
My42MAkxMTEJMjQ5MwkyNDkzCTIuMzEJNDguMDUNCjYxODI0CQkxMTQ1NTguMzEJMTExCTE4OTYJ
MTg5NgkxLjY4CTY2LjA3DQoNClVEUCBHU08gT2ZmOg0KJHBrdF9zaXplCWtCL3Moc2FyKQlNQi9z
CUNhbGxzL3MgTXNnL3MgQ1BVCU1CMkNQVQ0KPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ0KMTQ3MgkJMTE0NDE1LjAxCTEwOAk3NzM4Ngk3
NzM4Ngk0MC4yMQkyLjY4DQoyOTQ0CQkxMTUyMzAuMzcJMTA4CTM4OTY0CTM4OTY0CTIzLjg0CTQu
NTMNCjU4ODgJCTEwOTc2NS4zMQkxMDMJMTg1NzkJMTg1NzkJMTYuMTQJNi4zOA0KMTE3NzYJCTEx
MDg3OC4wOQkxMDQJOTM2OQk5MzY5CTguNjQJMTIuMDMNCjIzNTUyCQkxMDkxOTQuNzcJMTAzCTQ2
MTMJNDYxMwk0CTI1Ljc1DQo0NzEwNAkJMTA4NTk3LjEzCTEwMgkyMjk0CTIyOTQJMi4xMQk0OC4z
NA0KNjE4MjQJCTEwOTE0MS41NAkxMDMJMTc1NgkxNzU2CTEuNTMJNjcuMzINCg0KLS0tDQpUaGFu
a3MsDQpKb3NlIE1pZ3VlbCBBYnJldQ0K
