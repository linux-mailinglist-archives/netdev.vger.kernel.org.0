Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FEE747C38
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 10:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727520AbfFQIZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 04:25:48 -0400
Received: from mail-eopbgr60057.outbound.protection.outlook.com ([40.107.6.57]:30537
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725791AbfFQIZr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 04:25:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ou5vlwPYdRxPM6Cc5u3lx/hIStNFSdsL70iR5zveAuk=;
 b=ZHHIsb/yMlxCUrirzXegVo0vNtuau/+Bx7P9FWi87pZcKCo0+CGre6psA3DxpcxvMYkkSzU8QR3bTxHm3h8xa1vivi6o4H6OYiTnpra+2GN0GN53hSkHpXQ6nKsz2Tk3ecqSpso2JvuCeRrgiTJNMVtMY54j9mFSkV+ago+9qSY=
Received: from DBBPR05MB6283.eurprd05.prod.outlook.com (20.179.40.84) by
 DBBPR05MB6315.eurprd05.prod.outlook.com (20.179.40.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Mon, 17 Jun 2019 08:25:41 +0000
Received: from DBBPR05MB6283.eurprd05.prod.outlook.com
 ([fe80::50a0:251f:78ce:22c6]) by DBBPR05MB6283.eurprd05.prod.outlook.com
 ([fe80::50a0:251f:78ce:22c6%6]) with mapi id 15.20.1987.014; Mon, 17 Jun 2019
 08:25:41 +0000
From:   Tariq Toukan <tariqt@mellanox.com>
To:     Florian Westphal <fw@strlen.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Eric Dumazet <edumazet@google.com>,
        Ran Rozenstein <ranro@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>
Subject: Re: [PATCH net-next v3 7/7] net: ipv4: provide __rcu annotation for
 ifa_list
Thread-Topic: [PATCH net-next v3 7/7] net: ipv4: provide __rcu annotation for
 ifa_list
Thread-Index: AQHVF83Lr33HKjKwkUC3VoNAQ9XCp6afnOAA
Date:   Mon, 17 Jun 2019 08:25:41 +0000
Message-ID: <04a5f0ab-00b7-7ba9-2842-915479abe6be@mellanox.com>
References: <20190531162709.9895-1-fw@strlen.de>
 <20190531162709.9895-8-fw@strlen.de>
In-Reply-To: <20190531162709.9895-8-fw@strlen.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR05CA0021.eurprd05.prod.outlook.com
 (2603:10a6:20b:2e::34) To DBBPR05MB6283.eurprd05.prod.outlook.com
 (2603:10a6:10:c1::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tariqt@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dc592d28-9434-4d45-9f08-08d6f2fd6297
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DBBPR05MB6315;
x-ms-traffictypediagnostic: DBBPR05MB6315:
x-microsoft-antispam-prvs: <DBBPR05MB6315E44B870E954FDCC1128AAEEB0@DBBPR05MB6315.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1850;
x-forefront-prvs: 0071BFA85B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(366004)(39860400002)(136003)(346002)(376002)(199004)(189003)(66446008)(66556008)(14454004)(73956011)(64756008)(186003)(68736007)(4326008)(107886003)(305945005)(6246003)(7736002)(26005)(5660300002)(8676002)(66476007)(66946007)(66066001)(81156014)(86362001)(31696002)(53936002)(81166006)(8936002)(476003)(54906003)(45080400002)(102836004)(478600001)(110136005)(486006)(14444005)(256004)(71190400001)(446003)(11346002)(99286004)(76176011)(316002)(52116002)(25786009)(6512007)(229853002)(2501003)(386003)(6506007)(53546011)(3846002)(6116002)(2616005)(31686004)(6436002)(71200400001)(6486002)(36756003)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:DBBPR05MB6315;H:DBBPR05MB6283.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: hbT5Md4SP2gLJbKy0Z8ZSa/yB0+eU6TurBCs96NARQVWMOxklqPh9zTpf0RtXivpWUcK1ioCGQJ2glwOcTQbcXnRjrHxGwQhazPsnNXGRw2cZGz9wUzS8sgXf1ADzp6Dm/ERykVXn4hdn9n7EvX7906QdeTZIraFWTFEipnmkB23I/U1xTRgrmIqMf45yZfWv/nIhKJ9gPHCPh1T4SOklilS8oec3wvih8ed1RQdiMDqjm/OR9eOCIKmgW7SQdzwvDn1taS/lbGVch2idOydLJTv8kh9JYoQNoieNH5BJpnsdCoj4AUY+EJqcyU1g4XIxdqthB64S1zmLIiRopbxDiz/SsDW4o9Hgqx7d4+yJiAV5gEYM2k+Rom3F6MhxyjLt85My9HQK7AoYF/j1hQCy94LGZM8NighlIHgnwqHIIg=
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <7791C280FFBF8C438634CF556C153502@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc592d28-9434-4d45-9f08-08d6f2fd6297
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2019 08:25:41.7563
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tariqt@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR05MB6315
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/31/2019 7:27 PM, Florian Westphal wrote:
> ifa_list is protected by rcu, yet code doesn't reflect this.
>=20
> Add the __rcu annotations and fix up all places that are now reported by
> sparse.
>=20
> I've done this in the same commit to not add intermediate patches that
> result in new warnings.
>=20
> Reported-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Hi Florian,

Our verification team bisected a degradation [1], seems to be in this patch=
.
I see you already posted one fix for it [2], but it does not solve.
Any idea?

Regards,
Tariq


[2] d3e6e285fff3 net: ipv4: fix rcu lockdep splat due to wrong annotation

[1]

[2019-06-11 22:38:19] mlx5_core 0000:00:08.1 ens8f1: Link up
[2019-06-11 22:38:19] 8021q: adding VLAN 0 to HW filter on device ens8f1
[2019-06-11 22:38:47] watchdog: BUG: soft lockup - CPU#4 stuck for 22s!=20
[ifconfig:32042]
[2019-06-11 22:38:47] Modules linked in: rdma_ucm rdma_cm iw_cm ib_ipoib=20
ib_cm ib_umad mlx5_ib mlx5_core mlxfw mlx4_ib ib_uverbs ib_core mlx4_en=20
ptp pps_core mlx4_core 8021q garp stp mrp llc mst_pciconf(OE) nfsv3=20
nfs_acl nfs lockd grace fscache netconsole cfg80211 rfkill sunrpc=20
snd_hda_codec_generic ledtrig_audio snd_hda_intel snd_hda_codec=20
snd_hda_core cirrus drm_kms_helper snd_hwdep snd_seq crc32_pclmul=20
snd_seq_device ghash_clmulni_intel drm snd_pcm snd_timer snd syscopyarea=20
sysfillrect soundcore sysimgblt i2c_piix4 pcspkr fb_sys_fops i2c_core=20
sch_fq_codel ip_tables ata_generic pata_acpi virtio_net crc32c_intel=20
net_failover serio_raw failover ata_piix floppy [last unloaded: mlx4_core]
[2019-06-11 22:38:47] CPU: 4 PID: 32042 Comm: ifconfig Tainted: G=20
    OE     5.2.0-rc4-for-upstream-perf-2019-06-11_15-08-06-31 #1
[2019-06-11 22:38:47] Hardware name: QEMU Standard PC (i440FX + PIIX,=20
1996), BIOS 1.10.2-1ubuntu1 04/01/2014
[2019-06-11 22:38:47] RIP: 0010:__inet_del_ifa+0xa5/0x300
[2019-06-11 22:38:47] Code: 5e 10 45 31 d2 eb 13 0f b6 43 44 41 38 46 44=20
4c 0f 46 cb 4c 8d 5b 10 49 89 da 49 8b 1b 48 85 db 0f 84 98 00 00 00 f6=20
43 48 01 <74> db 41 8b 46 38 3b 43 38 75 de 8b 53 34 41 33 56 34 85 c2 75 d=
3
[2019-06-11 22:38:47] RSP: 0018:ffffc90002cafc28 EFLAGS: 00000246=20
ORIG_RAX: ffffffffffffff13
[2019-06-11 22:38:47] RAX: 0000000000000000 RBX: ffff888291eb9880 RCX:=20
0000000000000000
[2019-06-11 22:38:47] RDX: 0000000000000000 RSI: 0000000000000001 RDI:=20
ffff88835c39a000
[2019-06-11 22:38:47] RBP: 0000000000000000 R08: 0000000000000000 R09:=20
ffff888291eb9880
[2019-06-11 22:38:47] R10: ffff888291eb9880 R11: ffff888291eb9890 R12:=20
0000000000000000
[2019-06-11 22:38:47] R13: ffff88835c39a010 R14: ffff88827bb7c680 R15:=20
0000000000000001
[2019-06-11 22:38:47] FS:  00007fd1c0d82740(0000)=20
GS:ffff88835f700000(0000) knlGS:0000000000000000
[2019-06-11 22:38:47] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[2019-06-11 22:38:47] CR2: 00007f9781165160 CR3: 0000000276a52000 CR4:=20
00000000000006e0
[2019-06-11 22:38:47] DR0: 0000000000000000 DR1: 0000000000000000 DR2:=20
0000000000000000
[2019-06-11 22:38:47] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:=20
0000000000000400
[2019-06-11 22:38:47] Call Trace:
[2019-06-11 22:38:47]  devinet_ioctl+0x1fa/0x720
[2019-06-11 22:38:47]  inet_ioctl+0x93/0x150
[2019-06-11 22:38:47]  ? page_add_file_rmap+0x15/0x180
[2019-06-11 22:38:47]  ? alloc_set_pte+0x12c/0x580
[2019-06-11 22:38:47]  sock_do_ioctl+0x3d/0x130
[2019-06-11 22:38:47]  ? filemap_map_pages+0xf2/0x3b0
[2019-06-11 22:38:47]  sock_ioctl+0x1e5/0x390
[2019-06-11 22:38:47]  ? __handle_mm_fault+0xae4/0xe80
[2019-06-11 22:38:47]  do_vfs_ioctl+0xa6/0x600
[2019-06-11 22:38:47]  ksys_ioctl+0x60/0x90
[2019-06-11 22:38:47]  __x64_sys_ioctl+0x16/0x20
[2019-06-11 22:38:47]  do_syscall_64+0x48/0x130
[2019-06-11 22:38:47]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[2019-06-11 22:38:47] RIP: 0033:0x7fd1c0899dc7
[2019-06-11 22:38:47] Code: b3 66 90 48 8b 05 d9 00 2d 00 64 c7 00 26 00=20
00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00=20
00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d a9 00 2d 00 f7 d8 64 89 01 4=
8
[2019-06-11 22:38:47] RSP: 002b:00007fff995c4758 EFLAGS: 00000246=20
ORIG_RAX: 0000000000000010
[2019-06-11 22:38:47] RAX: ffffffffffffffda RBX: 0000000000000002 RCX:=20
00007fd1c0899dc7
[2019-06-11 22:38:47] RDX: 00007fff995c47c0 RSI: 0000000000008916 RDI:=20
000000000000000c
[2019-06-11 22:38:47] RBP: 00007fff995c5be7 R08: 00007fff995c48fd R09:=20
0000000000000000
[2019-06-11 22:38:47] R10: 00007fd1c091e880 R11: 0000000000000246 R12:=20
0000000000000005
[2019-06-11 22:38:47] R13: 00007fff995c4aa8 R14: 0000000000000000 R15:=20
0000000000000000
