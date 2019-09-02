Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15305A546D
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 12:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731142AbfIBKv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 06:51:28 -0400
Received: from mail-eopbgr1410135.outbound.protection.outlook.com ([40.107.141.135]:50166
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727951AbfIBKv1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Sep 2019 06:51:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SWlGiI96Ps4UYXwqQC3IHXSm5gaa8Vc1iU3sVQf5GPLVJTQehKY4rF1prhlM1PSguKnvO5XI5IYYG0cDjz1lv7ymVJKRgUWTEq2QtzDjXIoeAMckmj2i7G1YLSKfGogecl5+JDd9TTI/NUh8AguDnOfMslHiW+4bVeZJOLC7PmmqRrD/89M8QziUhvqTXw0S2faMwbBH3GRU0T3SF6b4jSrq4zwAJGceMTr18GAZewGOnVm3K41l52+b8jfK8Gvah0A+hTzcbcGxFbRyn5Y/wsnyxOTfAWa/0BYYxdIXiwBEyhWnU0BGjEhbB4gmxaUyBwOLrrRpy+ywwzLLwCIPOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LfWDLB/Poh9MOe2Tww7XmUykhm8u/8f4mprV6ZVDIJs=;
 b=eTj35fPOKhvfF+V9ZWNfObZi3X2USIQesVJy+HljBIm03PoLhxrjKW/kTz7IC8tXdu2a/Gtn725JCl2svkC8XoRPIzShsskobx0hkw41+wFs7BNwfz5DcA0AD8pcGMNUoerCC279T3CxW8ZtOlVN3P3/DhfXtgYQOqGdZ4/pbL8d+K03SPkNAC84CVDWhb4SXQDbWPBNx07li+MkerCRB3cU24ZlQbH72NtwOdpa7PCkUweiti6y0aCglfZ2O6Wo5F4G+LERM7r4OLnDxRRWp33233TSiC4kWQfEBubhYfjvNpvSvakS4E91smVUhN1XQJFFSQTuPNoY6dVDYfty4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LfWDLB/Poh9MOe2Tww7XmUykhm8u/8f4mprV6ZVDIJs=;
 b=W9JbIWFUc6G1GTXamI0oH4CxviFgfVHCp/Khh5KCUiCUMyzildqYAU7J3CtK3BvSuRvY3CwEFaX8+DbTq1HpsHzJWR0N7TA5HlSCxL+eaqJFAI3X7ypV2TWdVSty0s2ga1foPnyBVwsoSJrEPu9kXhZDLZdbmndHjdLVJWREmPY=
Received: from TYAPR01MB4544.jpnprd01.prod.outlook.com (20.179.175.203) by
 TYAPR01MB3792.jpnprd01.prod.outlook.com (20.178.136.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.19; Mon, 2 Sep 2019 10:51:25 +0000
Received: from TYAPR01MB4544.jpnprd01.prod.outlook.com
 ([fe80::6564:f61f:f179:facf]) by TYAPR01MB4544.jpnprd01.prod.outlook.com
 ([fe80::6564:f61f:f179:facf%5]) with mapi id 15.20.2220.022; Mon, 2 Sep 2019
 10:51:25 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Simon Horman <horms+renesas@verge.net.au>,
        David Miller <davem@davemloft.net>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC:     Magnus Damm <magnus.damm@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [net-next 3/3] ravb: TROCR register is only present on R-Car Gen3
Thread-Topic: [net-next 3/3] ravb: TROCR register is only present on R-Car
 Gen3
Thread-Index: AQHVYWVYoKfaVr0T/kCNVccYTTsccacYNXBg
Date:   Mon, 2 Sep 2019 10:51:25 +0000
Message-ID: <TYAPR01MB45444FCB6B49AC2EAD8CEA72D8BE0@TYAPR01MB4544.jpnprd01.prod.outlook.com>
References: <20190902080603.5636-1-horms+renesas@verge.net.au>
 <20190902080603.5636-4-horms+renesas@verge.net.au>
In-Reply-To: <20190902080603.5636-4-horms+renesas@verge.net.au>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yoshihiro.shimoda.uh@renesas.com; 
x-originating-ip: [150.249.235.54]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: feea5a25-0f26-479e-0ee1-08d72f938062
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:TYAPR01MB3792;
x-ms-traffictypediagnostic: TYAPR01MB3792:
x-microsoft-antispam-prvs: <TYAPR01MB37920BAFCEB96864D856CAADD8BE0@TYAPR01MB3792.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01480965DA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(396003)(376002)(366004)(39860400002)(346002)(189003)(199004)(446003)(2906002)(486006)(11346002)(476003)(256004)(66946007)(316002)(7696005)(71200400001)(86362001)(66476007)(76176011)(33656002)(66446008)(64756008)(76116006)(26005)(102836004)(99286004)(7736002)(6116002)(186003)(3846002)(6506007)(81166006)(4744005)(25786009)(6246003)(8676002)(52536014)(8936002)(305945005)(5660300002)(9686003)(55016002)(4326008)(66066001)(71190400001)(53936002)(110136005)(54906003)(229853002)(6436002)(74316002)(478600001)(81156014)(66556008)(14454004);DIR:OUT;SFP:1102;SCL:1;SRVR:TYAPR01MB3792;H:TYAPR01MB4544.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: WXnoFSdSh5vpaNCOC5TMt22oM8xR4IOrc1kzAOjvZTmE3cpPnNjSZAeoHSEpiPR/nDkoCQlnIB9Z15jltJt5lC/ts2TDxegQAjH6MBG4RLYg3BkKYTFnFaboxQqvKMS6NIscjRG0AFhhj/1kbS3v+QZVkDqJGaA4DlBEIV8vdotUbnGrUPleKUHP6lDA6d4B9msJmgpweI//bBVrG1+TkDo3JWbLp8k1ZRPPS6PC+1DC5o0GKALeyJEZYcZ1DYgRSs1FLnEaf2OHx3FwoHl78mJpb8M3X8mjuY0YRhkdvF4b81id0SlzJCell/xgJ76lbbIKZrHBEBIujOByZ4nN1wN8D5tqVaFDbdteD6n+70H70AJBkpJ5DtukYIxpc/wIMIGwjo6cf0D+B3Iv/ZLeRBPtlbFPbibs660KbThe3k8=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: feea5a25-0f26-479e-0ee1-08d72f938062
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2019 10:51:25.5703
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QExlj3yJIxSnqw7WdBe1OxejLi88nUuz6iNaA9IHBLA4iJtRuyOnZgexIznTXE07Rh17DkESe+Wg5LpBSU90iLK0zaJCTwPLO19Z0EyJ0YoPbwQ7hu7UVGdUCdBCdOFI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB3792
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Simon-san,

> From: Simon Horman, Sent: Monday, September 2, 2019 5:06 PM
>=20
> Only use the TROCR register on R-Car Gen3.
> It is not present on other SoCs.
>=20
> Offsets used for the undocumented registers are also considered reserved
> and should not be written to.
>=20
> After some internal investigation with Renesas it remains unclear why thi=
s
> driver accesses these fields on R-Car Gen2 but regardless of what the
> historical reasons are the current code is considered incorrect.
>=20
> Signed-off-by: Simon Horman <horms+renesas@verge.net.au>

Thank you for the patch!

Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

Best regards,
Yoshihiro Shimoda

