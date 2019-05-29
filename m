Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07F0E2E5BF
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 22:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbfE2UIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 16:08:39 -0400
Received: from mail-eopbgr00042.outbound.protection.outlook.com ([40.107.0.42]:30080
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726043AbfE2UIj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 16:08:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4JgRZjU8Ps9r7+4OMwo+B4EODc6GsZRLAUh+mxlZ4ao=;
 b=UJSKIXmd4bOUf34Sx+NmdYMpThN1omXb6nNfqkVvOu0oHMmx30vj87W3WXIRjX9h63ha3FeOmkgEQMWfCDAqK04AngtDdMInt7BwEZDv4jjupwTJS2/mdXmiOmntGIAwpGyZV3/G3uzB/OkJZeYOAJSNbDmS572gJz3yYc+s3qo=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB2720.eurprd04.prod.outlook.com (10.175.22.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Wed, 29 May 2019 20:08:32 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::f494:9fa1:ebae:6053]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::f494:9fa1:ebae:6053%8]) with mapi id 15.20.1922.019; Wed, 29 May 2019
 20:08:32 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "maxime.chevallier@bootlin.com" <maxime.chevallier@bootlin.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "lkp@01.org" <lkp@01.org>,
        kernel test robot <rong.a.chen@intel.com>
Subject: Re: [net] 9dd6d07682: kernel_BUG_at_drivers/net/phy/mdio_bus.c
Thread-Topic: [net] 9dd6d07682: kernel_BUG_at_drivers/net/phy/mdio_bus.c
Thread-Index: AQHVFcc5FibsdqTDwUCcSBiYTt7FMA==
Date:   Wed, 29 May 2019 20:08:32 +0000
Message-ID: <VI1PR0402MB28000F3C6A070321299AA57EE01F0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
References: <1558992127-26008-11-git-send-email-ioana.ciornei@nxp.com>
 <20190529023557.GA22325@shao2-debian>
 <VI1PR0402MB2800068E2D6880BE1930DE53E01F0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
 <20190529162527.kuunt5gxif6wvhoo@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [86.121.27.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 93ba9cdc-db83-4575-0687-08d6e4716cb2
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB2720;
x-ms-traffictypediagnostic: VI1PR0402MB2720:
x-microsoft-antispam-prvs: <VI1PR0402MB27203AE41FDA7433B7C02A9CE01F0@VI1PR0402MB2720.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0052308DC6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(396003)(136003)(39860400002)(366004)(346002)(51234002)(43544003)(189003)(199004)(476003)(52536014)(446003)(5660300002)(81166006)(102836004)(54906003)(486006)(6506007)(64756008)(5024004)(66556008)(66446008)(53936002)(73956011)(316002)(8936002)(6916009)(186003)(44832011)(26005)(14444005)(66946007)(66476007)(55016002)(6246003)(6436002)(74316002)(4326008)(7736002)(76176011)(68736007)(8676002)(81156014)(6116002)(53546011)(9686003)(229853002)(2906002)(76116006)(7696005)(305945005)(33656002)(478600001)(99286004)(14454004)(25786009)(71200400001)(86362001)(3846002)(71190400001)(7416002)(66066001)(256004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2720;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Nw2lN1S2gVltLNwlxLgsId3cJtsuxzomRuFXBkFCrEgoi2QrT+XQWXMkdvhdfcQvyAH7TPgrGHyacaVDgeYCAz+hJ7+EQalPAkynQ77pYWBPYkBpIZofwumLny1yD4RED7aKDKNB8z0S64zEX4B0iHiiq28fImFAcvKsN3uZ2XFKPY+YXso/BTr3ySuyyc+nuLtqxY8I2v8Uw0dWYDio/FByTxvlVEvY2nYrqrtmYvxrNxQMFgdja4WrST0VMz6x9//ia+r1xe1oUsfAVKLINTwMIdd5ds51u0rvyAvO5nN8Q91FZ/J7nqC7gO/AaWqvI7P+L7J+WCojbDS31fMN8anzD4LnEATkmgi6+Ju3yZAMj/1tJnB7TCGQl41AD6GSXqIQ4d926f9pAZ65cHDnx/sIdPGcF/2Arf2aFgXxgZI=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93ba9cdc-db83-4575-0687-08d6e4716cb2
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2019 20:08:32.4456
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ioana.ciornei@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2720
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/29/19 7:25 PM, Russell King - ARM Linux admin wrote:=0A=
> On Wed, May 29, 2019 at 04:11:57PM +0000, Ioana Ciornei wrote:=0A=
>>> Subject: [net] 9dd6d07682: kernel_BUG_at_drivers/net/phy/mdio_bus.c=0A=
>>>=0A=
>>> FYI, we noticed the following commit (built with gcc-6):=0A=
>>>=0A=
>>> commit: 9dd6d07682b10a55d1f49d495b85f7b945ff75ca ("[PATCH 10/11] net:=
=0A=
>>> dsa: Use PHYLINK for the CPU/DSA ports")=0A=
>>> url:=0A=
>>>=0A=
>>>=0A=
>>> in testcase: boot=0A=
>>>=0A=
>>> on test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2=
 -m=0A=
>>> 2G=0A=
>>>=0A=
>>> caused below changes (please refer to attached dmesg/kmsg for entire=0A=
>>> log/backtrace):=0A=
>>>=0A=
>>>=0A=
>>> +------------------------------------------+------------+------------+=
=0A=
>>> |                                          | 3a2573f868 | 9dd6d07682 |=
=0A=
>>> +------------------------------------------+------------+------------+=
=0A=
>>> | boot_successes                           | 4          | 0          |=
=0A=
>>> | boot_failures                            | 0          | 6          |=
=0A=
>>> | kernel_BUG_at_drivers/net/phy/mdio_bus.c | 0          | 6          |=
=0A=
>>> | invalid_opcode:#[##]                     | 0          | 6          |=
=0A=
>>> | EIP:mdiobus_free                         | 0          | 6          |=
=0A=
>>> | Kernel_panic-not_syncing:Fatal_exception | 0          | 6          |=
=0A=
>>> +------------------------------------------+------------+------------+=
=0A=
>>>=0A=
>>>=0A=
>>> If you fix the issue, kindly add following tag=0A=
>>> Reported-by: kernel test robot <rong.a.chen@intel.com>=0A=
>>>=0A=
>>>=0A=
>>> [   39.031781] kernel BUG at drivers/net/phy/mdio_bus.c:503!=0A=
>>> [   39.049792] invalid opcode: 0000 [#1] PREEMPT=0A=
>>> [   39.058345] CPU: 0 PID: 152 Comm: kworker/0:2 Tainted: G            =
    T 5.2.0-=0A=
>>> rc1-00321-g9dd6d07 #1=0A=
>>> [   39.076106] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), B=
IOS=0A=
>>> 1.10.2-1 04/01/2014=0A=
>>> [   39.091893] Workqueue: events deferred_probe_work_func=0A=
>>> [   39.101903] EIP: mdiobus_free+0x21/0x39=0A=
>>> [   39.109323] Code: 18 5f ed ff 5b 5e 5f 5d c3 55 89 e5 52 89 45 fc 8b=
 45 fc 8b=0A=
>>> 90 9c 00 00 00 83 fa 01 75 07 e8 9b fa 99 ff eb 1b 83 fa 03 74 02 <0f> =
0b c7 80 9c=0A=
>>> 00 00 00 04 00 00 00 05 a0 00 00 00 e8 94 58 ed ff=0A=
>>> [   39.144715] EAX: eff3e008 EBX: eff3a020 ECX: c23a9de9 EDX: 00000002=
=0A=
>>> [   39.156773] ESI: f0403560 EDI: efffbe24 EBP: efffbdf8 ESP: efffbdf4=
=0A=
>>> [   39.168825] DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068 EFLAGS: 000=
10297=0A=
>>> [   39.182048] CR0: 80050033 CR2: 00000000 CR3: 02781000 CR4: 000006b0=
=0A=
>>> [   39.194136] Call Trace:=0A=
>>> [   39.198932]  _devm_mdiobus_free+0xd/0x10=0A=
>>> [   39.206573]  release_nodes+0x194/0x1ad=0A=
>>> [   39.213804]  devres_release_all+0x37/0x3d=0A=
>>> [   39.221709]  really_probe+0x2b4/0x3a3=0A=
>>> [   39.228808]  driver_probe_device+0x110/0x14b=0A=
>>> [   39.237206]  __device_attach_driver+0x9d/0xa5=0A=
>>> [   39.245622]  bus_for_each_drv+0x65/0x77=0A=
>>> [   39.253081]  __device_attach+0x8f/0x104=0A=
>>> [   39.260507]  ? driver_allows_async_probing+0x26/0x26=0A=
>>> [   39.270161]  device_initial_probe+0x14/0x16=0A=
>>> [   39.278223]  bus_probe_device+0x22/0x64=0A=
>>> [   39.285645]  deferred_probe_work_func+0x7b/0xa1=0A=
>>> [   39.294428]  process_one_work+0x1bc/0x2eb=0A=
>>> [   39.302332]  ? process_one_work+0x164/0x2eb=0A=
>>> [   39.310539]  process_scheduled_works+0x1e/0x24=0A=
>>> [   39.319218]  worker_thread+0x1cb/0x268=0A=
>>> [   39.326604]  kthread+0xeb/0xf0=0A=
>>> [   39.332607]  ? process_scheduled_works+0x24/0x24=0A=
>>> [   39.341641]  ? __kthread_create_on_node+0x128/0x128=0A=
>>> [   39.350985]  ret_from_fork+0x1e/0x28=0A=
>>> [   39.369743] ---[ end trace 2d9c21baf7b99d11 ]---=0A=
>>>=0A=
>>=0A=
>> Hi,=0A=
>>=0A=
>> Just to give more context onto what's the path that reaches the BUG_ON, =
here is the last part of the dmesg before the crash:=0A=
>>=0A=
>> [   38.772573] dsa-loop fixed-0:1f: DSA mockup driver: 0x1f=0A=
>> [   38.790366] libphy: dsa slave smi: probed=0A=
>> [   38.799285] dsa-loop fixed-0:1f lan1 (uninitialized): PHY [dsa-0.0:00=
] driver [Generic PHY]=0A=
>> [   38.815725] dsa-loop fixed-0:1f lan1 (uninitialized): phy: setting su=
pported 00,00000000,000062c8 advertising 00,00000000,000062c8=0A=
>> [   38.856337] dsa-loop fixed-0:1f lan2 (uninitialized): PHY [dsa-0.0:01=
] driver [Generic PHY]=0A=
>> [   38.872670] dsa-loop fixed-0:1f lan2 (uninitialized): phy: setting su=
pported 00,00000000,000062c8 advertising 00,00000000,000062c8=0A=
>> [   38.903821] dsa-loop fixed-0:1f lan3 (uninitialized): PHY [dsa-0.0:02=
] driver [Generic PHY]=0A=
>> [   38.920337] dsa-loop fixed-0:1f lan3 (uninitialized): phy: setting su=
pported 00,00000000,000062c8 advertising 00,00000000,000062c8=0A=
>> [   38.952873] dsa-loop fixed-0:1f lan4 (uninitialized): PHY [dsa-0.0:03=
] driver [Generic PHY]=0A=
>> [   38.969462] dsa-loop fixed-0:1f lan4 (uninitialized): phy: setting su=
pported 00,00000000,000062c8 advertising 00,00000000,000062c8=0A=
>> [   39.002349] could not attach to PHY: -19=0A=
>> [   39.010359] dsa-loop fixed-0:1f: failed to setup link for port 0.5=0A=
>>=0A=
>> The dsa-loop mockup driver is trying to register a switch using informat=
ion based on the dsa_chip_data structure rather than on DTS.=0A=
>> This, of course, leads to PHYLINK being unable to successfully call phyl=
ink_of_phy_connect() on a NULL device_node.=0A=
> =0A=
> Right, phylink_of_phy_connect() is not supposed to be called with a NULL=
=0A=
> device node, but if it is, it fails gracefull=0A=
 >=0A=
>> Rewinding the stack, we see that dsa_tree_setup() fails and that calling=
 dsa_tree_remove_switch() should take care of removing/unregistering any re=
sources previously allocated.=0A=
>> This does not happen.=0A=
>>=0A=
>> Of special interest here is unregistering the MDIO bus which was registe=
red in dsa_switch_setup().=0A=
>> The mdiobus_unregister() is never called because it is conditioned by dt=
s->setup being true, which is set only after _all_ setup steps were perform=
ed successfully.=0A=
>> This leads the code to the part where it tries to free an MDIO bus which=
 was not unregistered properly, which is exactly this BUG_ON.=0A=
>>=0A=
>> The immediate fix for this is to use PHYLINK on the CPU port only when t=
he device_node associated is not NULL.=0A=
>> As a separate patch from this series, I will also try to fix the initial=
 bug.=0A=
> =0A=
> Yep, it sounds like a short-coming of the error handling, which should=0A=
> be the first priority to fix; avoiding PHYLINK on the CPU port when=0A=
> the device_node is NULL seems to me like papering over a bug.=0A=
I will add a patch that fixes the error path. I agree that this is =0A=
important.=0A=
=0A=
However, this will not fix dsa-loop (or any other driver that doesn't =0A=
probe on OF bindings) since the phylink_of_phy_connect() will still fail =
=0A=
on the CPU port. From what I see in dsa_port_setup_phy_of(), the error =0A=
was ignored previously:=0A=
=0A=
    phydev =3D dsa_port_get_phy_device(dp);=0A=
    if (!phydev)=0A=
          return 0;=0A=
=0A=
I don't see how this method is sane either.=0A=
=0A=
--=0A=
Ioana=0A=
=0A=
> =0A=
> However, should mention that I have been carrying a patch for some time=
=0A=
> for ZII boards to disable the error path for "no PHY" in=0A=
> dsa_slave_phy_setup() - iow, when phylink_of_phy_connect() returns=0A=
> -ENODEV and dsa_slave_phy_connect() also errors out.  That was the only=
=0A=
> way I could get the SFF modules to work there.=0A=
> =0A=
=0A=
