Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F02E9FB482
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 17:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728235AbfKMQBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 11:01:44 -0500
Received: from mail-eopbgr10045.outbound.protection.outlook.com ([40.107.1.45]:44421
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726190AbfKMQBn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 11:01:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q3mJJOhmK7VsHFV7nSlVmBoLjNciZJvZQmQ0qtagPl1GEHxf98uNpbsTKwLvTft1qGbmH/j7ZQJagQsyTE0hhebmUD3Yb+txTRvlran2nL/Egsn7Vw5/c2gdqCHgl3NpCb5OhgPkFzxYYdLpfm/o4azmAZl7O+sqn9ALTmvuLVqDaQvgUhiXWy2d6U6v66fiGtdJrgicOj38AtPG3zRTNfjczMzU7tEvy2KnRlrCwWftq2wlSt/LUt/BR5WEEFf2gzGQk6qsGG4vKScw7dpwVHNomlzZOXN3ttx4NDfzVpJTXEHsAbr/fDDPOytl11c2o2Pg530/Ka+rx8BCejqEsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g6tlt7eTPMGF1n7M/DQiQUvWZxprxu3WgTTfsmW6gjE=;
 b=eL/HDZ7YJZC3GXQny0Fna8UxcgNhDNhMkL9Mh6r2ngbz4FlytfGbuC4f5NyzLSPT8hWqlW1xL6NVE5T+WOkkRnDz9yhTCRfnM3KsOe+owjX/YSI7TSW15SSt4PDlj35wtoGr90h7Dyd1Ou5kbSkrVy9DxIuMlEgo7iZyjsMAwQ+32amMkN5aEUGG4V7k3oE7xDcE2/G6usgBq9mMOZIu1bDwsHfJ/+5ietaySq85MYTxIby5or0mklY9kREuKzLiYlz8DF/8kMjmpoNnWDjaO55B3lu7k6eIVf9JVOtER17PmSlE5tNM01aiAaZWHh5bnGWTKlO/9IifJjyweLRnDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g6tlt7eTPMGF1n7M/DQiQUvWZxprxu3WgTTfsmW6gjE=;
 b=Uo1a4jR+hxbXKD5qTpNidUpkdoneYpyVZCYcR7onB3kKfieTI3tF8ziMtHCWJzE/o9U1n3Z3YiYYciEyFy16K39/0KvI5ECE0SQCniN8K+6qvII2IM3y0UItNFD3Jyuo+yk2L2YAanym8HtUY5IdS14+YTwxc3jfqAT+6y4EEq0=
Received: from VI1PR04MB4880.eurprd04.prod.outlook.com (20.177.49.153) by
 VI1PR04MB4333.eurprd04.prod.outlook.com (52.134.122.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Wed, 13 Nov 2019 16:01:39 +0000
Received: from VI1PR04MB4880.eurprd04.prod.outlook.com
 ([fe80::9470:d3aa:b0e0:9a9b]) by VI1PR04MB4880.eurprd04.prod.outlook.com
 ([fe80::9470:d3aa:b0e0:9a9b%6]) with mapi id 15.20.2430.028; Wed, 13 Nov 2019
 16:01:39 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     "HEMANT RAMDASI (hramdasi)" <hramdasi@cisco.com>,
        "Daniel Walker (danielwa)" <danielwa@cisco.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Sathish Jarugumalli -X (sjarugum - ARICENT TECHNOLOGIES HOLDINGS
        LIMITED at Cisco)" <sjarugum@cisco.com>
Subject: RE: [PATCH net] gianfar: Don't force RGMII mode after reset, use
 defaults
Thread-Topic: [PATCH net] gianfar: Don't force RGMII mode after reset, use
 defaults
Thread-Index: AQHVmWkzb/KVHeRA/ECvEdv93vqv/qeHvtCAgAACaQCAAAFWgIAAB7IAgAFH0xCAABZzAIAAGbCg
Date:   Wed, 13 Nov 2019 16:01:39 +0000
Message-ID: <VI1PR04MB48805B8F4AE80B3E72D14E7B96760@VI1PR04MB4880.eurprd04.prod.outlook.com>
References: <1573570511-32651-1-git-send-email-claudiu.manoil@nxp.com>
 <20191112164707.GQ18744@zorba>
 <E84DB6A8-AB7F-428C-8A90-46A7A982D4BF@cisco.com>
 <VI1PR04MB4880787A714A9E49A436AD2496770@VI1PR04MB4880.eurprd04.prod.outlook.com>
 <873EB68B-47CB-44D6-80BD-48DD3F65683B@cisco.com>
 <VI1PR04MB4880A48175A5FE0F08AB7B2196760@VI1PR04MB4880.eurprd04.prod.outlook.com>
 <79AEA72F-38A7-447C-812E-4CA31BFC4B55@cisco.com>
In-Reply-To: <79AEA72F-38A7-447C-812E-4CA31BFC4B55@cisco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=claudiu.manoil@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2d634c67-df70-48fc-4d67-08d76852c4b7
x-ms-traffictypediagnostic: VI1PR04MB4333:
x-microsoft-antispam-prvs: <VI1PR04MB4333E9B5732D544373B3A05496760@VI1PR04MB4333.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0220D4B98D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(396003)(136003)(376002)(39860400002)(189003)(199004)(13464003)(3846002)(33656002)(316002)(81156014)(25786009)(81166006)(8676002)(229853002)(6436002)(6116002)(71200400001)(71190400001)(110136005)(54906003)(99286004)(2906002)(9686003)(6246003)(8936002)(14444005)(256004)(305945005)(74316002)(7736002)(55016002)(4326008)(4744005)(11346002)(446003)(44832011)(476003)(102836004)(52536014)(186003)(26005)(6506007)(7696005)(5660300002)(76176011)(66946007)(66476007)(66556008)(64756008)(66066001)(66446008)(14454004)(478600001)(486006)(86362001)(76116006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4333;H:VI1PR04MB4880.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VRHAjGUSnAuv/q6DdKtLDZqCRfVQvph7UVoT4UjPxljn01iB9akMVBR6TA+W4sEeQqXyQ3u6r4CxaH5mdzpb2LPjTxUppJ0Z12MuJFFVE9/lzMM2NOhxF3qcHxVMoJtVGMnh8S0BZeJkMmLTlaKteovYIuqf9W9e9l3292EHi5ZWTfXu0bTJfxNtZBR1JZ+is7g4IG8pi4vobAbtF4980/VxT4/xR8H7IvH/nIq2Ygh+jzaM4ARjzZHxJapeHwcDgN29yLP+TA7ge3ZpuEoFF4aoakZEirBm7HlBiZ2JbKui3aKHtIB1WQnkgHEolfesWZo7iIHwBbhXPLJDC6NJyBPnDV2HrDGp13uENLWZJRYX0UwwJhBNSbRZ8c8AnEmL9b7HWjG5H/+PNdaksSBZ+c2KhH69WWLe4CoJ0p3K6/dNrTnhjbVdVhD/oZXOGElJ
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d634c67-df70-48fc-4d67-08d76852c4b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2019 16:01:39.1709
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3YkDOEQ5DScoCe7rVmUyXT5f5MCOx3PFMdd4ALkwNpPSpOfSU3nqtXLSXYD6086OC+9SgeVt2765/dEjGllZYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4333
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+RnJvbTogSEVNQU5UIFJBTURBU0kgKGhyYW1k
YXNpKSA8aHJhbWRhc2lAY2lzY28uY29tPg0KWy4uXQ0KPg0KPj4+IFRoaXMgYml0IG11c3QgYmUg
c2V0IHdoZW4gaW4gaGFsZi1kdXBsZXggbW9kZSAoTUFDQ0ZHMltGdWxsX0R1cGxleF0gaXMgY2xl
YXJlZCkuDQo+Pg0KPj4gU2hvdWxkIHRoZSBiaXQgYmUgY2xlYXIgd2hlbiBpbiBmdWxsIGR1cGxl
eCBvciBpdCBkb2VzIG5vdCBtYXR0ZXI/DQo+Pg0KPg0KPj4gRnJvbSBteSB0ZXN0cywgaW4gZnVs
bCBkdXBsZXggbW9kZSBzbWFsbCBmcmFtZXMgd29uJ3QgZ2V0IHBhZGRlZCBpZiB0aGlzIGJpdCBp
cyBkaXNhYmxlZCwNCj4+IGFuZCB3aWxsIGJlIGNvdW50ZWQgYXMgdW5kZXJzaXplIGZyYW1lcyBh
bmQgZHJvcHBlZC4gU28gdGhpcyBiaXQgbmVlZHMgdG8gYmUgc2V0DQo+PiBpbiBmdWxsIGR1cGxl
eCBtb2RlIHRvIGdldCBwYWNrZXRzIHNtYWxsZXIgdGhhbiA2NEIgcGFzdCB0aGUgTUFDICh3L28g
c29mdHdhcmUgcGFkZGluZykuDQo+DQo+VGhpcyBpcyBsaXR0bGUgc3RyYW5nZSBhcyB3ZSBkbyBu
b3Qgc2VlIHRoaXMgcHJvYmxlbSBvbiBhbGwgcGt0IHR5cGUsIGljbXAgcGFzc2VzDQo+d2VsbCBh
bmQgd2Ugb2JzZXJ2ZWQgaXNzdWUgd2l0aCB0ZnRwIGFjay4NCg0KSSB0ZXN0ZWQgb24gYSAxR2Jp
dCAoZnVsbCBkdXBsZXgpIGxpbmssIGFuZCBBUlAgYW5kIHNtYWxsIElDTVAgaXB2NCBwYWNrZXRz
IHdlcmUgbm90IHBhc3NpbmcNCndpdGggdGhlIFBBRF9DUkMgYml0IGRpc2FibGVkLg0K
