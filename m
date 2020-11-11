Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBD8E2AF4C3
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 16:33:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgKKPdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 10:33:24 -0500
Received: from mail-vi1eur05on2069.outbound.protection.outlook.com ([40.107.21.69]:52832
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726136AbgKKPdX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 10:33:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U/51454bBLIs+3vwLBPAi93+Qn61uBQDjB8cj9z5wmbw2YjVliZIHFApgxPkwzWJSofyC3owGRuuNWBRP1dsdrDC6SYGLkb4O70m3u8NUhnXmJC5VT8XAmG5s4iJyCBYK0UmIVo/Y6Ezozoy5eNQw3R2IHCiPnClWkJTd+BTBP+J1rlsbE3lPtRMdjow72xhkex25sPNnAvhZWmVew4mSRpQGlmH4iprZAh0m/SZ5mIvfaqgq229Av1lnEGndKHL8y8aSC0SDjqOWv+lOGVbAPfD1j1OJa5k5vVD+7DMwG4U9nStNbhWvaTEghlUKedXwrbfMbWqdPCLaRwdazBIRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4veWlL4XxOcV5v9rFylLAUOhW82NBYvUWmgT33/JNlQ=;
 b=Rn8vOI8MICnoxT7MuPkkDrXgerOfEz10ZBnV9fnzdFKCGg/2uqiG4Ubz+jO9ogwmrMOAtSMbRdCpYPKpNW8/CaNsTDhFPmUCilKPODzC2q92ATGuPJGvW8Nft/KkktVNXttnQnXxIIc1FRBUk6iDokrsdzi7G4CB/ZjjfCno0dYns9P59BD/AiO44BfM8eMuAGwfPvxZZQXIzaZtDJ6V8hKSPo93ici1NQK4n/FI+CqSxak/nUuCce/xGZ5Rq24fuvFsJmjEHeNjuaie7j6v/b6F9lOBNMjuEb+/Rk6cNeyNdY0XunJu2nwgOf9GTkaUgNPhweaqLB5cE+HXqLpEww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4veWlL4XxOcV5v9rFylLAUOhW82NBYvUWmgT33/JNlQ=;
 b=Id75R8qRr/jQsX6rcEs/NER7US9m+qdNgskRdT1VCRlgpGkvK4uDrLWKqA3chg+KUjo8I03oelsrvCqqw8iW44Wu7Tam6Fd3RwmE5WEhiNefAOINXUzCINvwNqqxhf2y15AjAvblbtaeUYPDGHvksEtmrw/oGxYJYN+W88n9XDA=
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com (2603:10a6:209:3f::17)
 by AM6PR04MB4519.eurprd04.prod.outlook.com (2603:10a6:20b:18::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Wed, 11 Nov
 2020 15:33:20 +0000
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::7824:9405:cb7:4f71]) by AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::7824:9405:cb7:4f71%4]) with mapi id 15.20.3499.032; Wed, 11 Nov 2020
 15:33:20 +0000
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     Shawn Guo <shawnguo@kernel.org>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
CC:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Camelia Alexandra Groza (OSS)" <camelia.groza@oss.nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Leo Li <leoyang.li@nxp.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH] arm64: dts: fsl: DPAA FMan DMA operations are coherent
Thread-Topic: [PATCH] arm64: dts: fsl: DPAA FMan DMA operations are coherent
Thread-Index: AQHWmxXjMrUGgPncOk2cha5EuEXPF6mv6Y6AgBNfpdA=
Date:   Wed, 11 Nov 2020 15:33:19 +0000
Message-ID: <AM6PR04MB3976F19056A613AC92118A2FECE80@AM6PR04MB3976.eurprd04.prod.outlook.com>
References: <1601901999-28280-1-git-send-email-madalin.bucur@oss.nxp.com>
 <20201030073956.GH28755@dragon>
In-Reply-To: <20201030073956.GH28755@dragon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [82.76.227.31]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: bef2c272-1afa-4467-202b-08d886571e39
x-ms-traffictypediagnostic: AM6PR04MB4519:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR04MB4519E7FCC523D9284424C76AECE80@AM6PR04MB4519.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SE1YtHEfW9EEDnN5TJg6a2F2sMSjTjFxatFakojqn7ZALgXm3ugdzAHdT8Xm26JEVP4O2wnTqWE4G6IyKwRC6JTdgJjGGXx9Px07cSV1bT6CTCB0xyaKDrLsn8C8WuP800FB2QryPfmRY4ph2cx0sdE6rXblTRXb9CzKHmLuc2K3qhVlPSdfGCLgJPD5WHAMbjEc0deyQdjWVNohCHpVXDto/UJqKcRlRzw5ycldXQCD1hIkLSGlcIxpzM6Vq9TgZlD5/Dq3RvXlKLlF78z0/G7w7lioTlKCZ7RWGE5X0watPkLoeCZXuBxbfGSEXhDdQ9x18IqeIj7tLKmD4jFXxw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB3976.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(136003)(396003)(366004)(7696005)(6506007)(53546011)(83380400001)(5660300002)(316002)(110136005)(54906003)(8676002)(4744005)(8936002)(26005)(71200400001)(44832011)(86362001)(33656002)(55016002)(66556008)(2906002)(66446008)(64756008)(478600001)(52536014)(66476007)(66946007)(76116006)(4326008)(9686003)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: uz0VenoHuWQIkmMCdahx8KDvT5sjV1ASgZp0YaviJHIzYuJj9RMIrAPplG5L7fp2uEVmg+R1jC9qBqlGiLmQvd4dsCYtj1lUM/pBR8MbGd2cE4Zc9lU1ZGebHz/xlcKVazxULpDF3Fi3Tlm/QXwd+1dwEwesCAKrFZ5UzrfC7TFGGukZVpfynHwc9KidP4KIFt/T75Jqqbm4vs3Ofdeyszn3ZBBWZIlWNtHGRaCp3sJgs/wPs2TwMFXdjqQ6AHYQV7cWp1D5CF+gR1QpLyMuBVKJs8qJWlB8u5MWrZqVfp2DfMPwqEPn6mkDnO/Z6LkhH3cPSMLL3jZMyQcK6udpBZytvdya0edh7gyiOBDSa55Q8rro6gexWIayR224+3LUh2tQZkx5IqkyEbYlyK4iXHZTIbdSNkdKUYHkAVL8HQDtHT3t5v9uuK3TTCQVG71OTGrgbC/V2t2SFhaiPwqzIo6dAcuomeyhY1Ql3x0kOt7fYGE5ATFxyodoXjY3nEoqZ3SVkRaD1X9Q7M0ryvT5TKM5J0tR0sVcaCf8bDSsJcsn6CaNkPRpTamRZbxVw9Amyky5hsSQeK5K0QUjhb4tllyu4Jrhl0pxlnkFV+2F5sG7AEIFHJm77dNPjX4hMWmuBsmcflc3y/O7TWZTtUo+pQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB3976.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bef2c272-1afa-4467-202b-08d886571e39
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2020 15:33:19.9682
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5gSmbzWMjo2HFtH01Z0JyPw++yyjHaK40Tqiu6fBOeH1jMh7vEwzwnxBISFcePTiS7yn2tnA88pS+KgAO3K+HA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4519
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: linux-arm-kernel <linux-arm-kernel-bounces@lists.infradead.org> On
> Behalf Of Shawn Guo
> To: Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>
> Subject: Re: [PATCH] arm64: dts: fsl: DPAA FMan DMA operations are
> coherent
>=20
> On Mon, Oct 05, 2020 at 03:46:39PM +0300, Madalin Bucur wrote:
> > Although the DPAA 1 FMan operations are coherent, the device tree
> > node for the FMan does not indicate that, resulting in a needless
> > loss of performance. Adding the missing dma-coherent property.
> >
> > Fixes: 1ffbecdd8321 ("arm64: dts: add DPAA FMan nodes")
> >
> > Signed-off-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
> > Tested-by: Camelia Groza <camelia.groza@oss.nxp.com>
>=20
> Applied, thanks.

Hi, Shawn,

will this fix for the device trees be picked up in the stable trees as well=
?
Do I need to do something about it?

Thanks
Madalin

PS: will this make it into v5.10 or v5.11?
