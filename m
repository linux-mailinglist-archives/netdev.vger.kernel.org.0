Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9E0285DAC
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 12:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728310AbgJGK5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 06:57:01 -0400
Received: from mail-eopbgr10070.outbound.protection.outlook.com ([40.107.1.70]:38852
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727935AbgJGK47 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 06:56:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SWjQDhny5O44kGeVICaXH4Q6Tf0ufHXLhyIndReosNTIRO7rvnxLQ/gi4fciFqANWxTagV0BWUaPABc4PcW9EpNxRdwHOnYEq6HnFKSNk266S3JAEui2toT9lkp0YeHHi/zN7CLxrIMKe79waN1Tz/9iPgMuPcDv/7xSIPNoHH2Jl9NyBqEfuRWuKAfsAW87lGh7B20ZWvi1l7CaSd2kkQ54wHGnE3yayw1EP6Vt1itOUY6srshW4a9s6UljPRbyCo3XjFV/X0JG1ymYgRXqd3Z4/UqKwtsb+Q0+bgV9ZNIcCde59Y52zscopNLso2Z4pptj3iENBMqUiQJ5bd2NeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IEx2SPxRAL8VDoFeaOu6afthnjJtGegvu6ippad4TXg=;
 b=hyFyv+A0FBR4Q1xnbbAdUp8FZUFNlhb9MQmtc3KwNinJz+o9y+ftAioMjNdXdacvtF79EWWnlvNvcedk56EUHd7YyffN28f5YqK0R+2S0BtQeT4nCbczpFYDy0+FDnvNkXYcKOyubtupmE0QjjXmzQjFWtsEyl3ixoo24ZTdy5h7+A8VqJ4CsmMSjj8812b/aYFIlI7tAvsIxvq1f/R4f/L+8i9iFNKKvvPkRAGrXFxeLqmp4dHNuDMxIUxYTnVupWW3qcvlwO3Td+aMgbYcbqi0XW624z2qM7OENr9N5NTzKrCd0b9O755oS31cPzzqqFuvBtPOarZ4bk45pmRe0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IEx2SPxRAL8VDoFeaOu6afthnjJtGegvu6ippad4TXg=;
 b=A9HBvWVpozSoxFV/iD/0rsYgSzrc7C/mff7HCrKP0Xqpr8dPdPahOUNTE/KFQBJuZS90a07hWUKVstN3SnCqlCBHyHPBQ/PD3e1+AI9G9eTAgV+oJ5XLVn0rkJroXZnBIfKcLKmfyj2THCl4WXHJ7at2IEopjxcmPRXFFYEW4ao=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR0402MB3472.eurprd04.prod.outlook.com
 (2603:10a6:803:a::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.22; Wed, 7 Oct
 2020 10:56:56 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::3c18:4bf1:4da0:a3bf]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::3c18:4bf1:4da0:a3bf%3]) with mapi id 15.20.3433.044; Wed, 7 Oct 2020
 10:56:56 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next v2 2/4] enetc: Clean up serdes configuration
Thread-Topic: [PATCH net-next v2 2/4] enetc: Clean up serdes configuration
Thread-Index: AQHWnI8IR1h5dyQ/NECS9YMXrwduoqmL+AWA
Date:   Wed, 7 Oct 2020 10:56:55 +0000
Message-ID: <20201007105655.okxp7m3is6tvur47@skbuf>
References: <20201007094823.6960-1-claudiu.manoil@nxp.com>
 <20201007094823.6960-3-claudiu.manoil@nxp.com>
In-Reply-To: <20201007094823.6960-3-claudiu.manoil@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.229.171]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1c349482-c3aa-4ab6-7b64-08d86aafb4fb
x-ms-traffictypediagnostic: VI1PR0402MB3472:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3472FF1F77C2896DD0C1A0A1E00A0@VI1PR0402MB3472.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1002;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EzAVIKu67D/J/ylIsN4FTzZY8SGdOZAUXCKbMbGyycIlYOVtmIPlSyjFe7WKyAGqwFPAZpmYheOc1Bt62GDBhZqQwEZqno0uPZ2FpjGoSfxgx9+DZsg15k39ibTrBlDt3Zz79AtdwX/FT2l6HnAYUzEE4/dMI2SHSz0RC0jhozVzDfywvsT7gHACPnvrJ9OfzC+mmqNrg/8WN2eAboY2toGr9ED65Lr05O8PoleoIluu8IAqjeHauJkCLdyRioaliDZeerkTdukwdb0SJmRSyqu2k8heypDFj/lkUJKWgCiQsrtcXepEzwUk7ObF2Nm/rDuXv4GeUSrZYjZPS2vh6Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(39860400002)(366004)(396003)(136003)(346002)(376002)(8936002)(8676002)(186003)(64756008)(5660300002)(26005)(66946007)(66556008)(71200400001)(91956017)(76116006)(66446008)(66476007)(33716001)(44832011)(6506007)(316002)(4744005)(9686003)(6512007)(478600001)(6636002)(2906002)(86362001)(1076003)(6486002)(54906003)(4326008)(6862004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: tuLnDQF8jC/HX/EA+qszkM/AWk7qoiBhkMt2m0y6RtFfDAVVIaw6nbpsRey6TrvdYvcBYzRsFXD7/9+seye4B2l5/q2zGa69tC944nMhPkKpf7+sAPSxspb7DwZRiKWXzGq+j9av5H0RDg3Be7uzAyveUcE0IafsDkx7bDpDZ1Bub5nXpgU2xnKR7e1vX+w7aCb+nH3JF5a7flP0XxakhpQftV7F+z/yLee2HQ0q20t/1sQyf//s3a/N0CLZaqX6MApIQlJDUqOTpZFIONwhO1nFvWJlWN/IHQOUb0xlP1rsYqjtveMQVV8kaWYJzti8Dfdz67MMESpQReCojHMhwj+o5nGQm0VdNfjc+uEP5NgDg2SqOFjfymvfGXAslktM8alp8RsSDLOMo7nGnguPs04/EgmlNIYg9XagEoj10LMq8nDPV+ZSFsmiWLeBwIUDXg/X6G4iAdEM4H+efydDRKeARDhJxQ0Qzqrek4rpAU8wNhnepbQ4uytFVySjNEeQKdw9qZTZvLRYz2zy9e1ftSTd2bgONDr9bc+ZUA5zRlGgCg74sSpw4Tl3QT1FrcqLTyYoQ7zW+uJEap/HsFliKldiTDk8UFEFpAR2opxtFxLWFLprXeZVlRAJd304W6PmIcmFmj5NqfsI8bHP4lkSIg==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F8C27379CF119D4ABEDB97DAABA27B06@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c349482-c3aa-4ab6-7b64-08d86aafb4fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2020 10:56:55.9996
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yiKOrJGa9dphnLf61+mpwqKJVlpeVamj+++f+umWxYH2mdI2cI28b/CmkuDeITZyirm27k6TIaumBPV9ipmIjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3472
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 07, 2020 at 12:48:21PM +0300, Claudiu Manoil wrote:
> Decouple internal mdio bus creation from serdes
> configuration, as a prerequisite to offloading
> serdes configuration to a different module.
> Group together mdio bus creation routines, cleanup.
>=20
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>

Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
