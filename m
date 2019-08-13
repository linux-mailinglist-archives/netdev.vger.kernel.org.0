Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBD778B0A0
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 09:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727573AbfHMHV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 03:21:59 -0400
Received: from mail-eopbgr140075.outbound.protection.outlook.com ([40.107.14.75]:5509
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726986AbfHMHV6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 03:21:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l1qzWpA1n4qpR19AXaaACR1j7603wglFHcG7rHMuYl3kE6J0h5Qc68w07BybPOntATuz3XsT3lXp1RsdDiVcsXivckJe0U32GV6KttBl21HC7E7NCxHpaFzOZeU5yFqAUooiSBWtT5348F4dvCus5pXwnNFPpHnA54wrATC00uNA54X1i7aH4YCWXf673sSMg0Ssc6JpwDWlY0TYOvmvTjbk8mnNAjIVe6qj6ZPn+HkAJNWcLfDb8PUYUFvAjUUF/g1jopU7/HNF+0YanMDTUKNCq0zlVjyjLKISsUpyJyecjzgcmVpilvlmC1i4pUn8C4BYu0hbZhUAaIVE08eS3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gdYXwghOsK8ghEucKmacT7kmEkVEbpvHJ33BkF2fRzQ=;
 b=fXn+5jn6LiwJGJ2ISUkSVa1j5bfHtZ/leY2nFvg5XW1/lAXN2PnEf6LK95RmlCCtad+qPAnWaDA5gYFg8qf62Ricfox7ZJQcCnRlErxKfke0h0ny9rPJIx8GDz5kAzHfkRDejiKKUAZ1FvqQvv6S4hiSSxT3RPvSvhpmbFgYyT9yFY/6ztIYbgIgdCr6GUGtfq4qAtxt68YBUZLM6qmjDa71TbOysJ8BKJ/eJulfL5LtEHVx0Kp+v5cVmrhoXo0oRzLO47V8r3hCmORUm03Yje6tToo75ZM8euLJD5T2lzLBO3cPECMCrOwTUleBRlR+bog9yEV1ob0EI7dZCt1YgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gdYXwghOsK8ghEucKmacT7kmEkVEbpvHJ33BkF2fRzQ=;
 b=GnfDEVz8Hv+pTDStVWiPf95sp2opfGXtOnkzN3TY+kUDEaZpJJd0seI7Vn3DNCbLuoj9CX5B4WvTicHHP0bh0k3wKkVLNvcLvFUQJty3aWhss5RRcC3ejea1n+FQe0I83txPkjkhFWBFmWt3LuiDIp4JgO00xY0XuIERxQAj/z4=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB3933.eurprd04.prod.outlook.com (52.134.17.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Tue, 13 Aug 2019 07:21:41 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::85d1:9f00:3d4c:1860]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::85d1:9f00:3d4c:1860%7]) with mapi id 15.20.2157.022; Tue, 13 Aug 2019
 07:21:41 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>
Subject: Re: [PATCH] dpaa2-ethsw: move the DPAA2 Ethernet Switch driver out of
 staging
Thread-Topic: [PATCH] dpaa2-ethsw: move the DPAA2 Ethernet Switch driver out
 of staging
Thread-Index: AQHVTsse6Qsm2zNpN0akGPBvGQTj7Q==
Date:   Tue, 13 Aug 2019 07:21:41 +0000
Message-ID: <VI1PR0402MB28005DB52A30278BA8CC16D0E0D20@VI1PR0402MB2800.eurprd04.prod.outlook.com>
References: <1565366213-20063-1-git-send-email-ioana.ciornei@nxp.com>
 <20190809190459.GW27917@lunn.ch>
 <VI1PR0402MB2800FF2E5C4DE24B25E7D843E0D10@VI1PR0402MB2800.eurprd04.prod.outlook.com>
 <20190812135746.GL14290@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [188.25.91.80]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5248ee45-1ea3-453e-56d7-08d71fbee352
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3933;
x-ms-traffictypediagnostic: VI1PR0402MB3933:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB393370F56100FABDD49BEA47E0D20@VI1PR0402MB3933.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01283822F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(366004)(396003)(136003)(346002)(189003)(199004)(6246003)(66066001)(86362001)(52536014)(478600001)(4326008)(8676002)(446003)(53546011)(26005)(6116002)(6506007)(3846002)(81156014)(8936002)(76176011)(81166006)(53936002)(476003)(186003)(102836004)(25786009)(2906002)(44832011)(486006)(7696005)(66556008)(76116006)(33656002)(7736002)(66446008)(99286004)(74316002)(64756008)(66476007)(305945005)(71200400001)(55016002)(6916009)(256004)(66946007)(9686003)(71190400001)(14454004)(229853002)(6436002)(54906003)(5660300002)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3933;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: E9Mu9o1XtPOmxvfdriVD4dyPf8O6lQfYngNzsjAbBnREhxfM4AJ8m/ywOGcDKDuImRmmRBsKExF3QjutvMzWPrlQQXPbJ+a4vqv0dTMbE9H3DZehzZL+eZ7ZY6SZsYomVX2xoCnp3OZKsA7S24P+YEjOeJv/vfBM4ojtESZFs/ZqSS6Ra3NKx6PButR9FUojInW77rA0UAz8PyP8vxiyQUsPxlh3za2w092o0R+VC8ipsXsmXKIEcsxpwf9aSLCurd9wcKxs5KYS3OO7qYEoPheSvgNOVH25+1aQFBUvh4Fykew7EdQXcVKB23RmP1InV3piTMN0RwR1Sh+C3C5bE7bpGn3mWaeH5rV7yrfIEFkMcRiEvCWjzIgjhCXU4Lg1n8OgL5WODybAKl39exHNmnSdIqopkCY80D3OFUNLXLs=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5248ee45-1ea3-453e-56d7-08d71fbee352
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2019 07:21:41.2676
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0r3lIv1gjmca4qx3QTc4KtWyjFs7MIaqYB1qadbXZN7ml7QcUc6InmfObTy/TKIYWXEDeZ3fQr6+QAV4IRC7DA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3933
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/12/19 4:57 PM, Andrew Lunn wrote:=0A=
>> In the DPAA2 architecture MACs are not the only entities that can be=0A=
>> connected to a switch port.=0A=
>> Below is an exemple of a 4 port DPAA2 switch which is configured to=0A=
>> interconnect 2 DPNIs (network interfaces) and 2 DPMACs.=0A=
>>=0A=
>>=0A=
>>    [ethA]     [ethB]     [ethC]     [ethD]     [ethE]     [ethF]=0A=
>>       :          :          :          :          :          :=0A=
>>       :          :          :          :          :          :=0A=
>> [eth drv]  [eth drv]  [                ethsw drv              ]=0A=
>>       :          :          :          :          :          :        ke=
rnel=0A=
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
>>       :          :          :          :          :          :=0A=
>> hardware=0A=
>>    [DPNI]      [DPNI]     [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D DPSW =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D]=0A=
>>       |          |          |          |          |          |=0A=
>>       |           ----------           |       [DPMAC]    [DPMAC]=0A=
>>        -------------------------------            |          |=0A=
>>                                                   |          |=0A=
>>                                                 [PHY]      [PHY]=0A=
>>=0A=
>> You can see it as a hardware-accelerated software bridge where=0A=
>> forwarding rules are managed from the host software partition.=0A=
> =0A=
> Hi Ioana=0A=
=0A=
Hi Andrew,=0A=
=0A=
> =0A=
> What are the use cases for this?=0A=
> =0A=
> Configuration is rather unintuitive. To bridge etha and ethb you need=0A=
> to=0A=
> =0A=
> ip link add name br0 type bridge=0A=
> ip link set ethc master br0=0A=
> ip link set ethd master br0=0A=
> =0A=
> And once you make ethc and ethd actually send/receive frames, etha and=0A=
> ethc become equivalent.=0A=
> =0A=
> If this was a PCI device, i could imagine passing etha into a VM as a=0A=
> PCI VF. But i don't think it is PCI?=0A=
=0A=
Indeed it's not PCI but we can pass etha to a VM. That's the main use =0A=
case of having DPNIs connected to a switch object.=0A=
=0A=
Our direct assignment solution for DPAA2 is not upstream yet (the case =0A=
with many of our drivers :) ) but the main idea is exposing to the VM a =0A=
fsl-mc bus on which it can find any DPAA2 objects needed to configure a =0A=
network interface (using firmware calls).=0A=
=0A=
=0A=
> =0A=
> I'm not sure moving etha into a different name space makes much sense=0A=
> either. My guess would be, a veth pair with one end connected to the=0A=
> software bridge would be more efficient than DMAing the packet out and=0A=
> then back in again. >=0A=
>       Thanks=0A=
> 	Andrew=0A=
>=0A=
=0A=
=0A=
That's really an interesting test to be made since we can make a veth =0A=
pair from DPAA2 objects just connecting two DPNIs back to back. I'll =0A=
make some performance tests and compare against the software veth.=0A=
=0A=
=0A=
Thanks,=0A=
Ioana=0A=
=0A=
=0A=
