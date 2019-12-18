Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94EC6125709
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 23:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbfLRWiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 17:38:23 -0500
Received: from us03-smtprelay2.synopsys.com ([149.117.87.133]:39558 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726512AbfLRWiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 17:38:23 -0500
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id C4D96C008D;
        Wed, 18 Dec 2019 22:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1576708702; bh=rhcARhaq9PtHOKpDYqJnbyuiB8xGFhbVuzgrbNENRAg=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=GrL+prKtrOR3SSp7ayAAnEqfaTV8k+rPZ87buH67EuZK6daFbJfxw1E2dD7osU1Wy
         QtN0scLZFagz6lr+R+XAY+2U6cF1Q6NCc862wbHST5gVIzATxB5ACE8TWuWIjBal9U
         lho7+fVWoYAq5r8FKLMJfKuRaEjPVBAU9BksJyM7Rh/uxMts4+4O8cmdBmWT+Lvuyu
         ydxSdSPuMywo8uVdNHAlQEaG/+MKBAcGkqXbw4QfHqFdENHUzk/UeAlFUcPgPkhKxs
         b1WJxKw2e3lutNzHKtzRlSs8BMw4TV7ys1+b+gGfyRhT9FHyGbT2vW9wa46FXD2hl+
         wrfELYcuRbhrg==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 31BE0A007F;
        Wed, 18 Dec 2019 22:38:19 +0000 (UTC)
Received: from us01hybrid1.internal.synopsys.com (10.200.27.51) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 18 Dec 2019 14:38:18 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.200.27.51) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Wed, 18 Dec 2019 14:38:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WeTWDHEygYet0/FEoUOATjCxCwWnZ/M+TfpzrWh/5zpyKG7uC5foR9g5+J4jBuMNJ/VYnThw7gMY+NVPkPeudVK12QQ/6ic1qoonBPGFn6ysjJZHkibpSPH3d0rKqWBDrblQKnycODYIY39r+W6vrxZ56d58JekIMl8npG65Dq0ZnnOLE7226jbEu4fbDR56Q8yw0dADvLZR62x+YZAOgShhyfU+nWIBMq8B7xS8lc6G9MPDLTYTgQ3SNGj5kD/P/aWq8gcFN0JRNPTR7DQo7mgcEO6AbB7LJh+tpNaoA8Li+N+RMwDoZvO3DJCn+5e3+m/EBlvCSXSfdBxNhnCRzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sj2zKfKb7AAxlhU5wQKBPgBgqHKnwERs1JwyQ+oofeY=;
 b=XNzSR2kHtD+oxqKu/EjhW9UFWoXpNGaj9HyP7xB9e8jShP04nLZjp1ZvHOvQbdJeUU7CTBwMRShLbGXvaNA4p8Ue6UIk22qRDAXPpsV0Vazl+zfu/sPaF8Ou/457AIELLS25Xk8We4SHZpTtFs9IPT0dMD2otpKOSbcDZb/QobcyEg271C8Jw2qHTIkKvO0r6lqV5FWCzOr3AtjvXXOrsD1OxOzB6Fud/gsBm6Vkx19DB+SGsHN2yFlgW+EJhzKPTfzQPe93zakCrwzGnpFag/xBFlhJYBI6/s3OjeJegvv6JC9YcisLg8mr7196Dw7jnxSDGTgllY98F+blxWwGYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sj2zKfKb7AAxlhU5wQKBPgBgqHKnwERs1JwyQ+oofeY=;
 b=ILmIPpiNinwjQ+W7OFnDL8JJMvy4yfWVAHzxor2psp9GQWvEeXrT9fPHR/MCVBVyW278J9E7Ciy6MGXDp8yDmoCbW6NUxP44c/qGY/qZUMiHC/FGlaFkxelsV9oMS35i6s401jLPK/tdHHggueA0F9S2DZ4fOs07zIPnppiVI6Y=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3540.namprd12.prod.outlook.com (20.179.67.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Wed, 18 Dec 2019 22:38:16 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::3d20:3a36:3b64:4510]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::3d20:3a36:3b64:4510%7]) with mapi id 15.20.2559.012; Wed, 18 Dec 2019
 22:38:16 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
CC:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: RE: linux-next: build failure after merge of the net-next tree
Thread-Topic: linux-next: build failure after merge of the net-next tree
Thread-Index: AQHVtfMckJGbhj9DeECqpvEANajkfqfAe4tA
Date:   Wed, 18 Dec 2019 22:38:16 +0000
Message-ID: <BN8PR12MB3266A7474D06616B7770AAEBD3530@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20191219093218.1c1d06f2@canb.auug.org.au>
In-Reply-To: <20191219093218.1c1d06f2@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [198.182.37.200]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c10890ee-8c7f-4a0a-a865-08d7840af97d
x-ms-traffictypediagnostic: BN8PR12MB3540:
x-microsoft-antispam-prvs: <BN8PR12MB3540B0A3F52F70680FEBB120D3530@BN8PR12MB3540.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1284;
x-forefront-prvs: 0255DF69B9
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(346002)(39860400002)(136003)(376002)(396003)(53754006)(189003)(199004)(478600001)(110136005)(71200400001)(9686003)(8676002)(6506007)(54906003)(66556008)(5660300002)(86362001)(4744005)(64756008)(26005)(2906002)(7696005)(33656002)(186003)(4326008)(81166006)(81156014)(76116006)(66446008)(66946007)(66476007)(8936002)(55016002)(52536014)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3540;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xV38m5uk7dw3vM7XkeW7SMJn4wDipFTAbrXy91AmPaRFKLMe8zVfYi/1odmoCNfZARIl6esUmkaT5pnHag2maS/NfQqfM5wsHp2g4s3kB2knnPVxlbKu9ZTt2Ma48aRuaAMNpr1O8qxNz4vifrZlz2BbEQeedlmGgeQEr4UkW5DthZQrQ0C9jNiIiQ+VoEkUCS2GevZtSc9KE0loRlrNPRwMKVb5Iy0Ux8lOrsJws3/ubBZOfXQX8iu6zUmhEUVbNQOav418t2Edk9dWxFAX8bwr3Qk+4fNRLvXDt2/P1plIClAnVOGxZpi6EU1SG02fBkRVpFEMty3lY69U9EdBnqe8wg7xKfgF9jfoe4Pxkc0gaspWHWu2ypot1EhYJxQlUz+TSanSA6Ao79CBLxrc0mFXHf/wkoSWrAxGTWnyN/tug1osk1rCdYkrgkmjwIoptPQyiu/Nv8hvcOflUEgOtgsl59+VM/bhbJqE/QcsZYuWV2P8Gw3B8q95F61SQa56
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c10890ee-8c7f-4a0a-a865-08d7840af97d
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2019 22:38:16.5576
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Myuy1lOTltx4dWQWTIkM/K17KMSYCLG1rn4jh2Ng/pwrHaC7EFjX+n6BX885BwETmpJIRPQy54x5lx7jTzV4Ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3540
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Dec/18/2019, 22:32:18 (UTC+00:00)

> Hi all,
>=20
> After merging the net-next tree, today's linux-next build (arm
> multi_v7_defconfig) failed like this:
>=20
> arm-linux-gnueabi-ld: drivers/net/ethernet/stmicro/stmmac/stmmac_tc.o: in=
 function `tc_setup_taprio':
> stmmac_tc.c:(.text+0x4e8): undefined reference to `__aeabi_uldivmod'
> arm-linux-gnueabi-ld: stmmac_tc.c:(.text+0x508): undefined reference to `=
__aeabi_uldivmod'
>=20
> Caused by commit
>=20
>   b60189e0392f ("net: stmmac: Integrate EST with TAPRIO scheduler API")
>=20
> I have used the net-nest tree from next-20191218 for today.
> --=20
> Cheers,
> Stephen Rothwell

Hi Stephen,

I'll try to fix it still today. Sorry for the mess.

---
Thanks,
Jose Miguel Abreu
