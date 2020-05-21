Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A97D21DC553
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 04:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728028AbgEUCkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 22:40:18 -0400
Received: from mail-eopbgr60078.outbound.protection.outlook.com ([40.107.6.78]:26695
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727798AbgEUCkR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 22:40:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cor7TJGlh+RIAzNHaW0fgP/WU1LWOHTsARG9HYlfZ2ZmVp5SnSw3oihSXdAL3PFgCUZFBE09wo0UL5zNQhaL1ij7T0JThjzl6se4S+EKgNbMvU4xv11pkkZ8Y+gEyEX2FW+1NMtenW+2iW/z+w5pjo4lmE5Ls/JOHGTK+0uonve9zml7nZyK9+arD7DdCccOllFHl7UDtb/YwSymhi1ogOZUcTPRXYfvKzZ/PG9dQKvfCw6hppXxT5cyyLLduBtjD1U31e6KE54+UTBtlAlZnz2xr7L+uBHUlJOa48NmGP6P/RMNFxOeewgZagWTosxIoBPSoSRT6bdYst6/tqwz1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gj+Fwb2GWfu+UCbHJxvcu/+exX/DQABxS0KbrxLeRbg=;
 b=Pa9hv2SVpiYslk/xagB2WIsZarasYtxz9wWrdBLRAME2s3tWmdrODXEJISVU22RZHRXL/I+DJCk8EE73xVS29Btp7hunxXEKJoUo7f+3b/Inq4RCKgqV2rUzKmMMAQXVfBp0GPv7nuZHzskL6M9WnFufQvaeQlHyH/CdqJapDcu2p84PzzH/l4O/TSJ0z31Nm1+65caPN2EruUgiS+DwH3gC5q2IE7S3p8h8XAYI8OxFgZy1y9rq868LTLnJREOAzwl8QX6nMGe7/Yx0IS3fkr9kpzhPYsnPR6DgorG//wDmneOv+8gmdtwmEj+ZGKSoi19Drgf5NIayuJChde1E7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gj+Fwb2GWfu+UCbHJxvcu/+exX/DQABxS0KbrxLeRbg=;
 b=U0O8L11/ksEW308H6Yi6nTBA6pse/0IvHMzmhZN5OEaYbcS3RGaoEbgLf/YBtB9Ae86bUyZ6EH+iQcmn/fuwoqPrPPEBCboksbh931NVjX3UEJ4T9ZdCo2rxVPeHzDqJrYBgdJY19nO9y6tqzRVJmfDfYdNJ9sMWjgrhIqjnUJ0=
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM6PR0402MB3461.eurprd04.prod.outlook.com
 (2603:10a6:209:3::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.33; Thu, 21 May
 2020 02:40:14 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1%7]) with mapi id 15.20.3000.034; Thu, 21 May 2020
 02:40:14 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "martin.fuzzey@flowbird.group" <martin.fuzzey@flowbird.group>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH net 1/4] net: ethernet: fec: move GPR register
 offset and bit into DT
Thread-Topic: [EXT] Re: [PATCH net 1/4] net: ethernet: fec: move GPR register
 offset and bit into DT
Thread-Index: AQHWLoHPjdUrXObnOkaNyQWAWrHig6ixMaOAgACjaQA=
Date:   Thu, 21 May 2020 02:40:13 +0000
Message-ID: <AM6PR0402MB3607AA1B7C7832A852CFF02FFFB70@AM6PR0402MB3607.eurprd04.prod.outlook.com>
References: <1589963516-26703-1-git-send-email-fugang.duan@nxp.com>
        <1589963516-26703-2-git-send-email-fugang.duan@nxp.com>
 <20200520095430.05cffcee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200520095430.05cffcee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 243f5cd7-2b1a-4431-c64d-08d7fd304a2a
x-ms-traffictypediagnostic: AM6PR0402MB3461:
x-microsoft-antispam-prvs: <AM6PR0402MB3461416843145B0A302ED63EFFB70@AM6PR0402MB3461.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:231;
x-forefront-prvs: 041032FF37
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aomlL25xqms1dou8EcKj2JH4KtcES4+lQpqOQAqKvbwyJbOxDfgPMNNWqZN/ZuEnXgVDOJdH9fgK23jWnlp1l9pMJIV9/4y2nr+AioBgZJxU2iQMmzl9SAEuE4Qt89f6xJPcTz8kcFCfW2M3hdqEZwjBJSCp+SCM57k5zDIYYWfIBZYpxB/fMDhm1GpCvyiADNsra6eOswIqJz1HNX9OrW3uD8frs+ud7klr27UFpdHdAR55oYeroLa649VZkY17gt64HBiVn+cM3If01zELx+r08FMDsfpjyIGy7bCLV56O++gpNj16MYRrVrPeseHs4Bl6SXxmvXxtruC28CRPeZyegdC9ntFYVpJ9WKegJr/DMv/giT2pwGudDetazaUkrxgmDJfpPqg3Jk6SHb26z4LoyZ05+yJ4sgQaEZ4REihNhIqMJ+NlFEIlCN9fu+Vp
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(366004)(39860400002)(136003)(396003)(54906003)(76116006)(52536014)(66446008)(66946007)(33656002)(6506007)(66476007)(26005)(64756008)(66556008)(316002)(186003)(71200400001)(478600001)(2906002)(7696005)(4326008)(9686003)(6916009)(5660300002)(55016002)(8936002)(8676002)(4744005)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: N1J4U63ZYDrxoLEsZfUjDV41r4Uk93SGdoTtubZySUwNn4tf+/zx3/zd0MwLKfzNOzJFHf0cWp6HjJSIoOxo6Ko6qi3fB0lcT604jq+rczPud2N37ZFYBSkuCAIi39BHSFmcDWfmM8Pc1dE6IVcoNen/fgCKFkX83y9Pf0KNdQy6mpY4lDXZKGTxYnUrOS7nkb+pJVHd+MaWlnHr78qgCJgX99TCvQ4phyms7w7HtHPDZxxQ5cgYnkJeGn8REawaM/dRlYQMhVIyoBOBK3vseoV1eHOxFSJ4Ed+JzPVwot19H6bL2wLCJ6FjtkqNSVL2kIsle/pcZcR3PMsdZB2hZAMXCuzNo8Vl1IxJ+Y9w5ELn+w4aR7wKgqkkvJsTBjjMx8So+cYigj/axgW/fOdVeiBoVrAeaFtUt0xKQnzcbMQlrGVmRSFU09Wvl6mHKAj9JymveOe+wcz0LDiCJs9sPrEc+9bQ63mXz6aFY4EJXuf2QB4BYlwaqYv7GakldpH2
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 243f5cd7-2b1a-4431-c64d-08d7fd304a2a
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 May 2020 02:40:14.0149
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yHgItj8I4KTYTYCxYC+4IHrdhFN0v478Vf97MPrbbZ5Qa+9NWTB8oEZYgQPBCsBaTdz1Z1E5Z2VMFJRpDELk0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3461
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org> Sent: Thursday, May 21, 2020 12:54 A=
M
> On Wed, 20 May 2020 16:31:53 +0800 fugang.duan@nxp.com wrote:
> > From: Fugang Duan <fugang.duan@nxp.com>
> >
> > The commit da722186f654(net: fec: set GPR bit on suspend by DT
> > configuration) set the GPR reigster offset and bit in driver for wake
> > on lan feature.
> >
> > But it introduces two issues here:
> > - one SOC has two instances, they have different bit
> > - different SOCs may have different offset and bit
> >
> > So to support wake-on-lan feature on other i.MX platforms, it should
> > configure the GPR reigster offset and bit from DT.
> >
> > Fixes: da722186f654(net: fec: set GPR bit on suspend by DT
> > configuration)
> > Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
>=20
> Fixes tag: Fixes: da722186f654(net: fec: set GPR bit on suspend by DT
> configuration) Has these problem(s):
>         - missing space between the SHA1 and the subject

Thanks, I will update it v2.
