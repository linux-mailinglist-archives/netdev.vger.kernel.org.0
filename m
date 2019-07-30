Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F07F7A3BA
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 11:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729205AbfG3JNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 05:13:08 -0400
Received: from mail-eopbgr140049.outbound.protection.outlook.com ([40.107.14.49]:20292
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727530AbfG3JNI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jul 2019 05:13:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cxFh2lBYbavH9aJKXnovUJCzw3ecrQg9mr6wAGMr4lMN7EJtS/LYYdlx1qabu0zrNK96/Eg9LY8uztI5SpblKtUVDAubM2naS5+xj6dfTx6SxOZ4YWRjaUoOcoBpmHDUbMn/yyQ3DkB2bGRZx3uC2b/J80KTsIq7jQypqz6dpK2FXQuckT0gObPZMMY+HMdp8Yi5vmHEt4wpy8u9eC4Xe1OGlngLev02CekBDIJpmO9g1Y9d1mh4wIoYHJoiDPR2RNW5sHzyVa+EayUgF4KJdPpd9sRewREgF5UCIMmLA+pleAvBlQS4uJwx/3AjMbq9IHdSOe6J5aKqejHuSA/BAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M0GlVnt90wISIKXv5FDYMIt95kWdCvIJr/IOJc1KQls=;
 b=eLxOgRgX/cGlcZ2OjhNmSzRFVvaJb1djmUXLOqTBTPh5DuSvSIf6AFs65TvHgVIJE3k+lDaidmxhB5lRd8Jok0eKqX0QUlaM0R6OMk+8ziKAysmHHpg7bj9TjC1GBJ1Bho3MJeWqgAEPvRTyDnc/Gr9vVIQRgDOgndlmEDWLp1NHWoH8GPtd4i+JYh3pvBYR/rg85/fMX31Du8HZdFFN/BXX8r60TdPNUBH1TprfaS8se5gtLpdV8xa/7oQ7kFdTXGAMqXR7Nh32nfTLFSzcTg5bbXwHadWn4WcuMtbm6W9cZMMQx4/UI7hD2JE7fRbVs+cUOBJopWu0AhrpieyIXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M0GlVnt90wISIKXv5FDYMIt95kWdCvIJr/IOJc1KQls=;
 b=rotoeVTc0G2KxIyAPrn9YqmYwEmnXfa4igaKeFmvxO96IpzjV6CJr8c8cKgS1v4ouXFFVwf1Lg4zb75vtPQ78Cq/JVcibI6Ga8eGZlxZ9hwQOZkvcvGnbETMhOxLljMGRjDwjDD/F96gQZzBs/V8J6bh3zZ2xgOVyX/W72a1Etw=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB2750.eurprd04.prod.outlook.com (10.175.23.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.13; Tue, 30 Jul 2019 09:13:02 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::a186:c119:606e:bdc4]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::a186:c119:606e:bdc4%4]) with mapi id 15.20.2115.005; Tue, 30 Jul 2019
 09:13:02 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>
Subject: Re: [PATCH 0/5] staging: fsl-dpaa2/ethsw: add the .ndo_fdb_dump
 callback
Thread-Topic: [PATCH 0/5] staging: fsl-dpaa2/ethsw: add the .ndo_fdb_dump
 callback
Thread-Index: AQHVRihjfsknlOPS30mjM+S1Pbz/Qw==
Date:   Tue, 30 Jul 2019 09:13:01 +0000
Message-ID: <VI1PR0402MB28000AEB0C3AE6E45AC2AAC8E0DC0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
References: <1564416712-16946-1-git-send-email-ioana.ciornei@nxp.com>
 <20190729163506.GJ4110@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [86.126.26.85]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 15b0c382-ac18-418c-32ab-08d714ce1f7a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB2750;
x-ms-traffictypediagnostic: VI1PR0402MB2750:
x-microsoft-antispam-prvs: <VI1PR0402MB275061512A01C0F4403506F4E0DC0@VI1PR0402MB2750.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0114FF88F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(39860400002)(376002)(366004)(346002)(396003)(136003)(199004)(189003)(66446008)(66556008)(6436002)(446003)(8676002)(68736007)(6916009)(14444005)(26005)(3846002)(186003)(476003)(86362001)(25786009)(305945005)(229853002)(6246003)(81156014)(81166006)(53936002)(256004)(486006)(4326008)(44832011)(8936002)(6116002)(71190400001)(76176011)(76116006)(71200400001)(7696005)(9686003)(66946007)(74316002)(99286004)(33656002)(14454004)(55016002)(54906003)(102836004)(66066001)(6506007)(5660300002)(2906002)(316002)(478600001)(53546011)(66476007)(64756008)(52536014)(7736002)(142923001)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2750;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: NJ6RZzFBV3oOQD/24bR/lWsmJAy73HfFgY8+3lgqKRS0JnuSyHFoyQoy3X/lodD7Ryqcp6zX+Q2s1Hu1vQgy9MnrvoRGugdCYNsQ0RLxaQs4ZiDuLdNIc4DGjKb/XxLMyw7Eba3cx4pWLf4FfwQXpFb69hFFlMCq7bD/dSq+RbqR9QuIWMcEdk0Y1dTjCZx9+R3JAHSOQxd0y5u/Pj7PVIAztpmvT66Px4I1u2ZwfV7QIae2mjkEzUIYfXQSC464mOwa4BZXYVlFSwziYmObfVpy2iRAve8ChRtD66Kma4fmih6w9DwHgCY4QpXzGDjp8xm/cIqzEVoP3UQCEOs4vXNXiaBcawf/me2J4rcmkFnKijfRHNb6IHtlbFSbeCQs2qoeXGTlcd6GMR94GMpPxyFmLYWL9eFu+vnRtPNTB1A=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15b0c382-ac18-418c-32ab-08d714ce1f7a
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2019 09:13:01.8343
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ioana.ciornei@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2750
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/29/19 7:35 PM, Andrew Lunn wrote:=0A=
> On Mon, Jul 29, 2019 at 07:11:47PM +0300, Ioana Ciornei wrote:=0A=
>> This patch set adds some features and small fixes in the=0A=
>> FDB table manipulation area.=0A=
>>=0A=
>> First of all, we implement the .ndo_fdb_dump netdev callback so that all=
=0A=
>> offloaded FDB entries, either static or learnt, are available to the use=
r.=0A=
>> This is necessary because the DPAA2 switch does not emit interrupts when=
 a=0A=
>> new FDB is learnt or deleted, thus we are not able to keep the software=
=0A=
>> bridge state and the HW in sync by calling the switchdev notifiers.=0A=
>>=0A=
>> The patch set also adds the .ndo_fdb_[add|del] callbacks in order to=0A=
>> facilitate adding FDB entries not associated with any master device.=0A=
>>=0A=
>> One interesting thing that I observed is that when adding an FDB entry=
=0A=
>> associated with a bridge (ie using the 'master' keywork appended to the=
=0A=
>> bridge command) and then dumping the FDB entries, there will be duplicat=
es=0A=
>> of the same entry: one listed by the bridge device and one by the=0A=
>> driver's .ndo_fdb_dump).=0A=
>> It raises the question whether this is the expected behavior or not.=0A=
> =0A=
> DSA devices are the same, they don't provide an interrupt when a new=0A=
> entry is added by the hardware. So we can have two entries, or just=0A=
> the SW bridge entry, or just the HW entry, depending on ageing.=0A=
>=0A=
=0A=
This also happens when dealing with static entries (not just dynamic =0A=
ones that can be affected by ageing). All in all, the basic actions of =0A=
adding/deleting entries and then dumping them works. It was just a =0A=
question about switchdev's architecture.=0A=
=0A=
=0A=
>> Another concern is regarding the correct/desired machanism for drivers t=
o=0A=
>> signal errors back to switchdev on adding or deleting an FDB entry.=0A=
>> In the switchdev documentation, there is a TODO in the place of this top=
ic.=0A=
> =0A=
> It used to be a two state prepare/commit transaction, but that was=0A=
> changed a while back.=0A=
> =0A=
> Maybe the DSA core code can give you ideas?=0A=
>=0A=
=0A=
I looked in the DSA core before sending these patches out and it's doing =
=0A=
the exact same thing as ethsw - even though it notifies switchdev if the =
=0A=
entry could be offloaded (ie no error) all entries will still be present =
=0A=
in the 'bridge fdb' output. In the SWITCHDEV_FDB_DEL_TO_DEVICE case, it =0A=
seems that it just closes the netdev without any further action.=0A=
=0A=
On the other hand, the mlxsw_spectrum also calls the notifiers when an =0A=
offloaded entry is deleted (on SWITCHDEV_FDB_DEL_TO_DEVICE). This seems =0A=
like a reasonable thing to do, maybe in another patch set.=0A=
=0A=
Ioana C=0A=
=0A=
