Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A13E01638C
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 14:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbfEGMOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 08:14:55 -0400
Received: from mail-eopbgr30049.outbound.protection.outlook.com ([40.107.3.49]:11073
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726276AbfEGMOz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 08:14:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+2iVld42hbF7+tIVJxDvQSMVMYZbqDx4EQwGMQtxtrA=;
 b=BnIvsJZD1hsLhzaQPHXGvLQYlkP+CBQDM9iRW5LabBO9S99LI9TH1CyFFerm+J13rGE8YmpnXd2r9V8XyKeEvmQL7dTZRG5FXub2SqNagShnKhKXm1UwvJcQJtdtjfrK9b0S6CP1JJep5d8ZZgiNuDNX0X6Z4DYv7UyON2mGw+M=
Received: from AM0PR04MB6434.eurprd04.prod.outlook.com (20.179.252.215) by
 AM0PR04MB4689.eurprd04.prod.outlook.com (20.176.214.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.14; Tue, 7 May 2019 12:14:50 +0000
Received: from AM0PR04MB6434.eurprd04.prod.outlook.com
 ([fe80::19be:75a:9fe:7cec]) by AM0PR04MB6434.eurprd04.prod.outlook.com
 ([fe80::19be:75a:9fe:7cec%7]) with mapi id 15.20.1856.012; Tue, 7 May 2019
 12:14:50 +0000
From:   Leonard Crestez <leonard.crestez@nxp.com>
To:     =?Windows-1252?Q?Petr_=8Atetiar?= <ynezz@true.cz>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     Matthias Brugger <matthias.bgg@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH net-next v2 0/4] of_get_mac_address ERR_PTR fixes
Thread-Topic: [PATCH net-next v2 0/4] of_get_mac_address ERR_PTR fixes
Thread-Index: AQHVBFI0RuJU2cpMvEWgdGL840mRHg==
Date:   Tue, 7 May 2019 12:14:50 +0000
Message-ID: <AM0PR04MB6434E06E7C43A2C95EB81F42EE310@AM0PR04MB6434.eurprd04.prod.outlook.com>
References: <1557177887-30446-1-git-send-email-ynezz@true.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonard.crestez@nxp.com; 
x-originating-ip: [89.37.124.34]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cd066af7-f27a-4e62-3648-08d6d2e59aaf
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM0PR04MB4689;
x-ms-traffictypediagnostic: AM0PR04MB4689:
x-microsoft-antispam-prvs: <AM0PR04MB4689F6460F9132925426F4B0EE310@AM0PR04MB4689.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0030839EEE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(376002)(39860400002)(396003)(366004)(346002)(199004)(189003)(74316002)(7416002)(66066001)(99286004)(5660300002)(14454004)(66574012)(9686003)(91956017)(7736002)(305945005)(256004)(71190400001)(478600001)(6506007)(186003)(6116002)(3846002)(53546011)(6246003)(86362001)(53936002)(68736007)(2501003)(486006)(66476007)(66556008)(64756008)(66446008)(76116006)(66946007)(14444005)(446003)(73956011)(7696005)(102836004)(26005)(33656002)(55016002)(316002)(8676002)(81166006)(4326008)(8936002)(81156014)(476003)(71200400001)(2906002)(110136005)(52536014)(25786009)(54906003)(76176011)(229853002)(44832011)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB4689;H:AM0PR04MB6434.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: AhRPnDqmD6ntyYASANAaACNjKL+k8eWc81cF/HVFoM6nZPDgZZBx3DUtUCebbSWW5bZzF47Yx3YrFF6hpZGcrtyCK2ej7hAXXzxiMiy4JRkaPRJlZx4aAO2Oyskc+wFcpw13YeyKrAXJ/InJ08cLN2zh32KXD7KY10Q4HHrSnYf1AjvV7T1U6NyspoxVr6/r/AT8mFkTSTO9KDXdUSWvsC62g3VEYACvV75qjiLKRGDrXq3JbzAjFMxK2LgbDjyZLnU6AgXEuaOxkj5z6GT6FUXZ6YxkEEzG/FBpX2KUHp/Ikmw3C9b6vaNDDmsiMiRWqJDBwIv70tAhz85M9a5GBT2/gvKmpFik6R+3CHS1uweSybtZKI2+kV1eFl4czAeUx4nd5DMWO//02Bv7iVt1VwOfkWIGzCW4PkkistZsev4=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd066af7-f27a-4e62-3648-08d6d2e59aaf
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2019 12:14:50.3172
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4689
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07.05.2019 00:25, Petr =8Atetiar wrote:=0A=
> Hi,=0A=
> =0A=
> this patch series is an attempt to fix the mess, I've somehow managed to=
=0A=
> introduce.=0A=
> =0A=
> First patch in this series is defacto v5 of the previous 05/10 patch in t=
he=0A=
> series, but since the v4 of this 05/10 patch wasn't picked up by the=0A=
> patchwork for some unknown reason, this patch wasn't applied with the oth=
er=0A=
> 9 patches in the series, so I'm resending it as a separate patch of this=
=0A=
> fixup series again.=0A=
> =0A=
> Second patch is a result of this rebase against net-next tree, where I wa=
s=0A=
> checking again all current users of of_get_mac_address and found out, tha=
t=0A=
> there's new one in DSA, so I've converted this user to the new ERR_PTR=0A=
> encoded error value as well.=0A=
> =0A=
> Third patch which was sent as v5 wasn't considered for merge, but I still=
=0A=
> think, that we need to check for possible NULL value, thus current IS_ERR=
=0A=
> check isn't sufficient and we need to use IS_ERR_OR_NULL instead.=0A=
> =0A=
> Fourth patch fixes warning reported by kbuild test robot.=0A=
> =0A=
> Cheers,=0A=
> =0A=
> Petr=0A=
> =0A=
> Petr =8Atetiar (4):=0A=
>    net: ethernet: support of_get_mac_address new ERR_PTR error=0A=
>    net: dsa: support of_get_mac_address new ERR_PTR error=0A=
>    staging: octeon-ethernet: Fix of_get_mac_address ERR_PTR check=0A=
>    net: usb: smsc: fix warning reported by kbuild test robot=0A=
=0A=
>   drivers/net/ethernet/freescale/fec_main.c             | 2 +-=0A=
=0A=
This fixes netboot on imx (probably all of them).=0A=
=0A=
Tested-by: Leonard Crestez <leonard.crestez@nxp.com>=0A=
=0A=
But shouldn't "support of_get_mac_address new ERR_PTR error" somehow be =0A=
reordered so that it's done before allowing non-null errors from =0A=
of_get_mac_address?=0A=
=0A=
Otherwise it will break bisect for many people.=0A=
=0A=
--=0A=
Regards,=0A=
Leonard=0A=
