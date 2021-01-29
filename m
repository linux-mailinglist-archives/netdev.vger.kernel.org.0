Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74D10308BE5
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 18:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232311AbhA2RrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 12:47:05 -0500
Received: from mail-vi1eur05on2127.outbound.protection.outlook.com ([40.107.21.127]:62689
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231307AbhA2RpB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 12:45:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G5/MvyYxE9Uv5664p2yUq5NPlsyjzmR0t4Q8T6I3uj0m0qr79kpgCcmPB2pFT1pAXN6tCC9xqYWMspvGKLKT4n4qlPwCcmKmMageYEP5I1vjyggGw63ZihAq98kZq8y0MaFm09EUeWbNgMU1kkSSqcqPYyKzxUnmOv4F3+4i76YgHKUPQe/2tuYMEzdhudfwE25gpq7uE6vWR9nCwEB5pTF03Lp35LOnXXbKSdrthv4mm3C3QgUm06T1MZDBfIhIgWH2pVt/Ng7evxNyutfyVBMzxocWObzyzzOgmp2XZA++UERqJpfzJn63l6ThEuLsC/AG2do8sn10bLII26qg1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LGYeRnaLAmNmPRPAbWQc2dE4fQhcpdEQ8BP99Q3KKzU=;
 b=MFpJefrv4HnCwG5BLTj0bTuVm1pcoV+fCTQZ0OsqNA4KSfcD2sfVIdLeNl3uZ7AfL46ctFUduXO/yE+mw6FL44MROBU1SHSbt4vvPJjtXPG8Q/S0lg237Gmoi9KACPnQJOG4IFtFu7The6O3o5IzsqFZaUy9hylRA7muwXW4ekm1aHszfds1Q2CwEmQqz60SwfRYctOdyJDv8l28oe0iB3kD/Kt8SI0nRe35ONVjjej+U1B2cT+EDq+1G2ntFjynlobdP9T+/W29AKsj5XUQGwBcL5P9kKc2Y6DxFZ/uvUng8i+Kg/8o6hZP7uec7TnR8eXGzcPMtLBiEn9BvBqKfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=criteo.com; dmarc=pass action=none header.from=criteo.com;
 dkim=pass header.d=criteo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=criteo.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LGYeRnaLAmNmPRPAbWQc2dE4fQhcpdEQ8BP99Q3KKzU=;
 b=A1fx4prEn//lahWTlDiTu9rbEROzXb6NN63gVUaIkKtbFGfonG+k+ps8N4Ouw0P4z7QKS8xqTsUn9JhKzle/4rl/o6AYUhMO1aIxNGpRWn/vcXcyfvjsju0By0s0mcfHY+PDgo4aGZ/BVKD3/jOiCi0DPumHfR5Q+HDYCgp61eU=
Received: from DB8PR04MB6460.eurprd04.prod.outlook.com (2603:10a6:10:10f::27)
 by DB7PR04MB4553.eurprd04.prod.outlook.com (2603:10a6:5:34::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Fri, 29 Jan
 2021 17:44:12 +0000
Received: from DB8PR04MB6460.eurprd04.prod.outlook.com
 ([fe80::54c3:1438:a735:fbd9]) by DB8PR04MB6460.eurprd04.prod.outlook.com
 ([fe80::54c3:1438:a735:fbd9%7]) with mapi id 15.20.3805.020; Fri, 29 Jan 2021
 17:44:12 +0000
From:   Pierre Cheynier <p.cheynier@criteo.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kuba@kernel.org" <kuba@kernel.org>
Subject: [5.10] i40e/udp_tunnel: RTNL: assertion failed at
 net/ipv4/udp_tunnel_nic.c 
Thread-Topic: [5.10] i40e/udp_tunnel: RTNL: assertion failed at
 net/ipv4/udp_tunnel_nic.c 
Thread-Index: AQHW9mMY04hDD4/GNkeljus5vphnqw==
Date:   Fri, 29 Jan 2021 17:44:12 +0000
Message-ID: <DB8PR04MB6460F61AE67E17CC9189D067EAB99@DB8PR04MB6460.eurprd04.prod.outlook.com>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=criteo.com;
x-originating-ip: [2a02:8428:563:1201:b7f7:f94:eaf8:6572]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e862bfe9-c616-4718-1fde-08d8c47d7d3d
x-ms-traffictypediagnostic: DB7PR04MB4553:
x-microsoft-antispam-prvs: <DB7PR04MB4553A0EE3A35CF653716747AEAB99@DB7PR04MB4553.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4cUlrECHtk88EP3enPpNQBmyeaQI4JsQz66mysihjJkq3lAp+Wrv6xgZco0KKDKLfAbxAR827QCPtVjqVgSJ355y4xqNP1LgWN/PNXft0K3NFxoshLuIMLDWkFSNov1trX3mZKfAZNt89s51xSzcu4yPdyAC495ArVkmDzAypy+ltLou6v+kVChbxAkgcpdBx/NSGWVM8eyj5ycTWUMuc0+D+whxfyqv7LIYrBJStv/v0ruuwiRcn1WANVPbPRuTMTbgkcn78KD6PD9EL0uuoLG1z3GBvrhuNrd4dwteskfIUGN3mr5JrqCm3ZsSAx4BC3viqG6iQDc4G+3/01VO4cozSdjG4bajgBR6ywQJlV36ZwM6UePHa0nh9Os9JKA46ad+d0HAzoY49dXjwmnfFejdHSO663U4/gQYBbDdM4IOaWcqyWmErTQO/ke2FEFAqn6dqNOfVd9BxN5QYkCI95eRh8tla6fCSoILlxqOc45ZP48A6QEPDVQg+/5ZGU/Ndl2ZaEwg/U/jEixyx1W2TQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6460.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(39850400004)(366004)(376002)(136003)(8936002)(45080400002)(8676002)(33656002)(316002)(52536014)(7696005)(478600001)(4326008)(55016002)(6506007)(186003)(76116006)(83380400001)(66556008)(9686003)(66476007)(66446008)(4743002)(86362001)(64756008)(71200400001)(91956017)(6916009)(66946007)(5660300002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?c4wUSApWwh2GAuYcfNOLJi7cRBZRKDCak64FYvoHFn7LyEnxgBDB+X/CLH?=
 =?iso-8859-1?Q?zFXIyTWiU9KRMr7yIn2y71rT5SRx3M+idMO0B27ssG0L2u26ICF6WlFkWi?=
 =?iso-8859-1?Q?ei0xM4DBiMRjk5snSnePV8mokvYGMabV52ZkDuv1w/YdvsZAgLQCDA6osR?=
 =?iso-8859-1?Q?7wtIdSsuBkzuzJpWYryW/VkmpVsSOSCcJq+kazsDvlGll1dQfMI1OtbfuT?=
 =?iso-8859-1?Q?95fxY/cIe+UURzf7MBUN8o7tvQNxpi6OVfXpuXsFbUroI5dftd1MTnvuHo?=
 =?iso-8859-1?Q?tYU/8WefJ7e6YZgJS0PsPTGxy9X+/K/DnWKHLFiu86H4lO1JN2A5mmS6Sv?=
 =?iso-8859-1?Q?pVSfCg2Sd9UVrvEK8VLwKSXUo/iMx0Rry7RDcbBpNlFSCZ6k5PgZmXUahI?=
 =?iso-8859-1?Q?oyK8D42g5Wk8HH4VBZNPJo3LYMLS8C6YAP8r2y0NxVlnahMxHK50lRB7Uu?=
 =?iso-8859-1?Q?v651P525OG8+smMq9soCeiCX2GfbbsqHpM5eaRKbkI++LgggPtI0sVBfTV?=
 =?iso-8859-1?Q?oiuNbBdcfetULmSN8opx0U8/x4roXMde40aO1P6csCQTYdii1p9WGWkp4o?=
 =?iso-8859-1?Q?etGFcMMHwiY6VXx7fAVMWe+YiVOniTxluVGUNlalOCdv3ZRQVNGYJgreEn?=
 =?iso-8859-1?Q?VCdc79ylv9EirKZ3KywI636XcZU6arhsDwgcU+95NuqC/NAo0eYWLEmy2/?=
 =?iso-8859-1?Q?42QhsyYUJJOl83AHO4fDZAIXjyCEZPNGouUdJ7hVVn4vzvdovIFKUYq5ao?=
 =?iso-8859-1?Q?eMYRnrSOJLr4mcWNTCe0JeW7cP62IrdusaHGWGrTYnYbv5auywe1XhQUes?=
 =?iso-8859-1?Q?JQ/YOrApcTzrnYnJPKMFpLTQJW5BC37XyyTBXu2v/2RzdW6l341kY7LpP9?=
 =?iso-8859-1?Q?QgrghYBj6+FoDWZ2EzyRZxDDXEAdspuS8lOM76elVxdZuab20m91ZF7d2V?=
 =?iso-8859-1?Q?+wNVe9cUpmYN/1+Yr8kyHvZLHgOGFHPkTLslD42KMC+iR8TYhLD9BNoRrs?=
 =?iso-8859-1?Q?JOmgIhRaBHdqXtoL4htFbseEzpjupD55DctkN9Sja4V+e06J2KGhnhNVQy?=
 =?iso-8859-1?Q?OL7a3VQ6ZR//F7uXH0wObvDNRSsN2FGO4Kit1yQfakL66F3wM75bViathz?=
 =?iso-8859-1?Q?VDfla6o32msJ0iwrbUUAnvSDoaOV5xbviDY5Mh7nl2KepdBMsl?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: criteo.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6460.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e862bfe9-c616-4718-1fde-08d8c47d7d3d
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2021 17:44:12.2440
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 2a35d8fd-574d-48e3-927c-8c398e225a01
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: REiiDOzWvIORg3x2w4dCVJYgGrPxyTMwOPQxn4ObmvvWlWHos3aJU7IX1bu2qbprxtPPb0/YktCIyFYpl7rxnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4553
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear list,=0A=
=0A=
I noticed this assertion error recently after upgrading to 5.10.x (latest t=
rial being 5.10.11).=0A=
Coming indirectly with my usage of the vxlan module, the assertion output w=
ill probably give you the information required to guess my hardware context=
 (i40e).=0A=
=0A=
[    8.842462] ------------[ cut here ]------------=0A=
[    8.847081] RTNL: assertion failed at net/ipv4/udp_tunnel_nic.c (557)=0A=
[    8.853541] WARNING: CPU: 0 PID: 15 at net/ipv4/udp_tunnel_nic.c:557 __u=
dp_tunnel_nic_reset_ntf+0xde/0xf0 [udp_tunnel]=0A=
[    8.864226] Modules linked in: vxlan ip6_udp_tunnel udp_tunnel sg mlx4_e=
n mlx4_core ipvlan i40e(+) ptp pps_core ahci(+) libahci libata ipmi_si ipmi=
_devintf ipmi_msghandler ip_vs_mh ip_vs nf_conntrack nf_defrag_ipv6 nf_defr=
ag_ipv4 libcrc32c crc32c_intel=0A=
[    8.886539] CPU: 0 PID: 15 Comm: kworker/0:1 Not tainted 5.10.11-1.el7.x=
86_64 #1=0A=
[    8.893927] Hardware name: Quanta Cloud Technology Inc. QuantaPlex T42S-=
2U(LBG-2)/T42S-2U MB (Lewisburg-2), BIOS 3A14.Q301 05/03/2019=0A=
[    8.905919] Workqueue: events work_for_cpu_fn=0A=
[    8.910283] RIP: 0010:__udp_tunnel_nic_reset_ntf+0xde/0xf0 [udp_tunnel]=
=0A=
[    8.916896] Code: ef 20 00 00 00 0f 85 5f ff ff ff ba 2d 02 00 00 48 c7 =
c6 32 23 19 c0 48 c7 c7 10 2e 19 c0 c6 05 cf 20 00 00 01 e8 6f f9 74 c3 <0f=
> 0b e9 39 ff ff ff 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00=0A=
[    8.935641] RSP: 0018:ffff9afc86447b68 EFLAGS: 00010286=0A=
[    8.940868] RAX: 0000000000000000 RBX: ffff8ea4435a6768 RCX: 00000000000=
00000=0A=
[    8.948000] RDX: ffff8ea41fe27a20 RSI: ffff8ea41fe17c40 RDI: ffff8ea41fe=
17c40=0A=
[    8.955133] RBP: ffff8e9cc85ef000 R08: ffff8ea41fe17c40 R09: ffff9afc864=
47980=0A=
[    8.962265] R10: 0000000000000001 R11: 0000000000000001 R12: 00000000000=
00000=0A=
[    8.969399] R13: 0000000000000000 R14: ffff8ea4435a6008 R15: ffff8ea4453=
20000=0A=
[    8.976533] FS:  0000000000000000(0000) GS:ffff8ea41fe00000(0000) knlGS:=
0000000000000000=0A=
[    8.984617] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033=0A=
[    8.990365] CR2: 00007f3d32b26160 CR3: 000000038d60a001 CR4: 00000000007=
706f0=0A=
[    8.997498] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000=0A=
[    9.004639] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400=0A=
[    9.011785] PKRU: 55555554=0A=
[    9.014499] Call Trace:=0A=
[    9.016968]  i40e_setup_pf_switch+0x3e8/0x5e0 [i40e]=0A=
[    9.021949]  i40e_probe.part.0.cold+0x87a/0x11f2 [i40e]=0A=
[    9.027175]  ? kmem_cache_alloc+0x39e/0x3f0=0A=
[    9.031361]  ? irq_get_irq_data+0xa/0x20=0A=
[    9.035286]  ? mp_check_pin_attr+0x13/0xc0=0A=
[    9.039399]  ? irq_get_irq_data+0xa/0x20=0A=
[    9.043329]  ? mp_map_pin_to_irq+0xd2/0x2f0=0A=
[    9.047514]  ? acpi_register_gsi_ioapic+0x90/0x170=0A=
[    9.052309]  ? pci_conf1_read+0xa4/0x100=0A=
[    9.056235]  ? pci_bus_read_config_word+0x49/0x70=0A=
[    9.060938]  ? do_pci_enable_device+0xd0/0x100=0A=
[    9.065385]  local_pci_probe+0x42/0x80=0A=
[    9.069140]  ? __schedule+0x32f/0x7e0=0A=
[    9.072803]  work_for_cpu_fn+0x16/0x20=0A=
[    9.076556]  process_one_work+0x1b0/0x350=0A=
[    9.080568]  worker_thread+0x1dc/0x3a0=0A=
[    9.084322]  ? process_one_work+0x350/0x350=0A=
[    9.088510]  kthread+0xfe/0x140=0A=
[    9.088513]  ? kthread_park+0x90/0x90=0A=
[    9.088516]  ret_from_fork+0x1f/0x30=0A=
[    9.088522] ---[ end trace daa573e87ec91564 ]---=0A=
=0A=
Cheers,=0A=
-- =0A=
Pierre Cheynier=
