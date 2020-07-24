Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 139E422C29F
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 11:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbgGXJ4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 05:56:48 -0400
Received: from mail-eopbgr150075.outbound.protection.outlook.com ([40.107.15.75]:49988
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726618AbgGXJ4s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jul 2020 05:56:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZyWRaotLMa9Q2uHvP+B9fgu86CDG/ge84xsSmwN9Vl4bvnY2PiH97TqqintKO4bmu3l5oH86MtbTvXjSnUk6/MSPaEztaOHre4lyUs4qW8On0LwodkwwJ2D/Wzh9HpxX6at3MP67Vl7OXU9mO/ZGCMivRbaxKc1axQkZe7pCQcqgKQFetOVrzMxV7kT1vGCh2MIs830fEhi+HNWDoiew8onxXL8+ITjbDRMx+VbmTHNcMd0b4KuwzbPnCVmHs6jSF7NcAgsddQ+SG2lBfXTftZtwekFJg62Z05hog7h6tFI20JmAx9E3wbaDFn4fgC0bDZaqLBKgWVLOm6Ujrgv7ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=44HahzCLcKSzL5UcQjUfGvva2Uqj7wO191N8EaBIM0c=;
 b=Zav43AqAnaNX8kjHLk/jvuhXoQjzEXCReBQyfc+sYveNEX7OcEz+tRNqLO0ex4e6snoZ+/twudoUvowykwV2QLeB95H0/BxcPx45UmYmQN58zkDzQsNd01Szz1nkRSfpGxas0Qhkk5IgwN/xq8pnrfG7NsdqAo6U2otYtb5JE6K++7b5cM+diEcxVW4srLGlg+HWyMKVm3fSV+lDZCKInnxF5yeX1EL+6PUXdJahlonht39i6Mvf4WBSJ8IHiXJsa3bB+gEy8wFCjma/NOLuba1mpxPgWlsBP51/9mpRKBY34DwvtRfUQ2p7ZTucdEpnZpS2qbwm7DpTpgpMP7L2Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=44HahzCLcKSzL5UcQjUfGvva2Uqj7wO191N8EaBIM0c=;
 b=nVi5dSLEAq1i2eHTQwPYGJP+eQqgoDUypFN8vSoy4idun4+u6hY7EmGyAXzsMRtUYsTTD8bYnWR1rQyr4t+xrwZeAv2eaQ2Mq8qu6kHt3DsBhib15a7E6P60Fkwf3Jvxid89f4gOyCFZTxkLwi0fsvI4y6dlOR+Fe4skAZNT3Fo=
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM0PR04MB4321.eurprd04.prod.outlook.com (2603:10a6:208:67::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Fri, 24 Jul
 2020 09:56:45 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::c80:f72:a951:3420]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::c80:f72:a951:3420%5]) with mapi id 15.20.3216.026; Fri, 24 Jul 2020
 09:56:45 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
CC:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Walle <michael@walle.cc>
Subject: RE: linux-next: manual merge of the net-next tree with the net tree
Thread-Topic: linux-next: manual merge of the net-next tree with the net tree
Thread-Index: AQHWYWF4DqCdJt9420+ypwJcvKWzsakWdCfg
Date:   Fri, 24 Jul 2020 09:56:45 +0000
Message-ID: <AM0PR04MB6754526BAB0AA640A2EB571496770@AM0PR04MB6754.eurprd04.prod.outlook.com>
References: <20200724122339.7abaf0e9@canb.auug.org.au>
In-Reply-To: <20200724122339.7abaf0e9@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: canb.auug.org.au; dkim=none (message not signed)
 header.d=none;canb.auug.org.au; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [82.76.66.138]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 17093999-6596-4a8c-ac64-08d82fb7e002
x-ms-traffictypediagnostic: AM0PR04MB4321:
x-microsoft-antispam-prvs: <AM0PR04MB4321B5D2DC6E51FBCD37B85796770@AM0PR04MB4321.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PNXFed0IGy2Qwy0RkWcBdaiR0CJMs3eK7bzMBrlSj1QYzGS3NKYyNU2bqyMYI5t1Kjn/LhiimErL+v/ZYgWH9BRFGpWBkVpNwfHpSLLi2aD3F8YAnihr5IC5crpwcvJc+qqFaOXAkdBnpNzj9BlKSOg0BzyFk6mSdELwK23crXbvKJt4PqNTyuBMN7LMFdD7cRULwzX8RIa9IxEq4a+IsZ9m85bFwuBS+ZXHSEw5YSkn0pA7rfMFI50Uvp/DrcqlEAmQSVcz4ky04vNwpJD6toWTO7WDdh84fI5OqoIBypXGBihZ7akktQYFBbhwNig1wtsv817cQK5YjV+Hg/e13w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(376002)(39860400002)(346002)(136003)(8936002)(316002)(83380400001)(186003)(55016002)(71200400001)(64756008)(478600001)(66946007)(8676002)(52536014)(66556008)(66476007)(66446008)(54906003)(4326008)(76116006)(110136005)(44832011)(6506007)(5660300002)(2906002)(26005)(7696005)(9686003)(86362001)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: kBOcu1yvYqFsdPOaZGRx9TcOGRsmzKnZWVSkarL8nREPgPRyUPdNNdxOs64JlWY3KOmRAuOIgSYVTTLWK4SFn06rb5oPCW19oFNAuMA6jX9gaQ1DWDSt1l54RmRL9oU8z0ui8HdN0fv+sMTE77DnKiO977/X4EiBLpKTD5aPEzGJlRGp79F90lsEORhTixS2Nm1Eoue40sP3ob7CeJS1ilFS9u9eV66d7yhG7ks8h55Cjcv2GcEg5wRyyROkqz2EywarhaA3QBijG2UQPY6L6eMHIqAH8u65mcXLLgDrZBZljx6hxx3e2VZVizgSS0SfOVJBDOz3n3BRtnRbBOSv6vlKaFVV9czjEY4J7E8udbd2rXwCYtQ1nymS1eahlDRjZuih/o/2FJL+KCHa7EJ/cqzutLx/HCRwj+ksaPSbCdwLfX//E0114ZirQbEr9uGbBG76/mtn3l1c7WaV5Xg9ZgHz6QUcj0rSmQY2bPyVDK8=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6754.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17093999-6596-4a8c-ac64-08d82fb7e002
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2020 09:56:45.5797
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t7Y5GjyPxhC/kWRs7Qt/cEqGEDR5sdLm9tUEwv0+CXcRBAo88tc8LNicuGGzfi6L1CvWINCReWqLdHWh1M2LWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4321
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Stephen Rothwell <sfr@canb.auug.org.au>
>Sent: Friday, July 24, 2020 5:24 AM
[...]
>Subject: linux-next: manual merge of the net-next tree with the net tree
>
>Hi all,
>
>Today's linux-next merge of the net-next tree got a conflict in:
>
>  drivers/net/ethernet/freescale/enetc/enetc_pf.c
>
>between commit:
>
>  26cb7085c898 ("enetc: Remove the mdio bus on PF probe bailout")
>
>from the net tree and commits:
>
>  07095c025ac2 ("net: enetc: Use DT protocol information to set up the por=
ts")
>  c6dd6488acd1 ("enetc: Remove the imdio bus on PF probe bailout")
>
>from the net-next tree.
>
>I fixed it up (see below) and can carry the fix as necessary. This
>is now fixed as far as linux-next is concerned, but any non trivial
>conflicts should be mentioned to your upstream maintainer when your tree
>is submitted for merging.  You may also want to consider cooperating
>with the maintainer of the conflicting tree to minimise any particularly
>complex conflicts.
>

It's unfortunate, but I think the conflict was unavoidable at this stage.
The net-next commit 07095c025ac2 uncovers an older bug making it worse
by modifying code around it, introducing a regression for a use case that w=
orked
before. That prompted the 'net' tree fix 26cb7085c898, which inevitably got=
 into conflict
with 'net-next'.  The conflict is simple AFAIC, it's about one line, one fu=
nction call on the
bailout path.

If you're asking me, you can go on with the resolution you consider to be t=
he safest.
Then I can send a follow up patch after 'net-next' gets merged into 'net',
to make the necessary corrections if needed.
Fyi,
The bailout path after merging the patches should be as below, the tricky l=
ine
being marked as "=3D=3D>":

err_reg_netdev:
	enetc_teardown_serdes(priv);
	enetc_free_msix(priv);
err_alloc_msix:
[...]
err_alloc_netdev:
=3D=3D>	enetc_mdio_remove(pf);
	enetc_of_put_phy(pf);
err_map_pf_space:
[...]

Thanks.
Claudiu
