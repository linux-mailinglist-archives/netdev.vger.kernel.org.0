Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8B436827D
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 16:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236397AbhDVOdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 10:33:44 -0400
Received: from mail-dm6nam12on2133.outbound.protection.outlook.com ([40.107.243.133]:37281
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236283AbhDVOdo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 10:33:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ImcYzMTNwPsSoxOJlUIaqxNh77HK57RLnDbN4Q1QiHAI3tgRSSrzVkhdMhtEJn2gESZ36OsTjoB2W2CXDHR/SlamtEZQvFzRwPDuO8vnrEcDwCoodzCH85HijcSiDHfiGPmhPmYSQJ2ipHdItDFYXELXeGKUuasY501O1b3qNs48hHhwKDcWTqD3ALxUuZprPjEkGjSZ6cmv+ziroLhizHE3gMsblNMVyCikWNF48NLIUagvPxiQZPEwRy631D4ffavgi79GDjgSQ8zP/i9XKqY4/HLVy+NjN4mczzeUZBVzoz+EkcmqrmpcIDAG1B29fcqSu51muP7zzs7bjNbFBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vmo5c/eTDJMu557Ng+gmshdbVaofkXOi3LdHhEteFdE=;
 b=cwdx/+S3JreRSkq+rNZGj67pRz3V9ege7IiQSmVv6S/Zux/u+9LQ+cy/kHj+JSJnCrEsw/R0yNoE0BE39Tr25U2KWpWqPUlIFMZMVWuZ5HRcUOArXJK2f840HutjrUL8H5EAntytvfvlV6ny4w0IynSTov6wT4bcskilj5G8j4KYS71eWEAhJev/7ZSIL4MN90ZkupJ+JqafluBrA2XP3RB3Tbo3SbLBGEc75F7vMwu7kgKfuwb/sgaHiBNKtwnNNb81FOr02TPRqs7Y2tKS+z0H1zJsv/0tdDwYQlFnFs3cekOK4ef42x92poseS/E1fO9C/WIcx3e37dDsxFEvqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=rmd-engineering.com; dmarc=pass action=none
 header.from=rmd-engineering.com; dkim=pass header.d=rmd-engineering.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=rmdengineering.onmicrosoft.com; s=selector2-rmdengineering-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vmo5c/eTDJMu557Ng+gmshdbVaofkXOi3LdHhEteFdE=;
 b=jBx+fd34OA1rGrFxyat5/btDq+OL1gsGTvU0IPkO34FhBxS2cLzuc7HKYFb54OXbnf3GW2Zy93J16CHGkHpaLd7YpLKwyeK0M2ZRaqZ9baGPOnEZ2lgY9sQzEKZRvPdgYJCYezAuI85py+VI89tO58rs2cyED8ElurhbP0Ji5iw=
Received: from DM6PR02MB5913.namprd02.prod.outlook.com (2603:10b6:5:157::16)
 by DM6PR02MB6860.namprd02.prod.outlook.com (2603:10b6:5:21a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Thu, 22 Apr
 2021 14:33:07 +0000
Received: from DM6PR02MB5913.namprd02.prod.outlook.com
 ([fe80::bdc9:c21f:5aa2:da65]) by DM6PR02MB5913.namprd02.prod.outlook.com
 ([fe80::bdc9:c21f:5aa2:da65%5]) with mapi id 15.20.4042.024; Thu, 22 Apr 2021
 14:33:06 +0000
From:   Chad Woitas <CWoitas@rmd-engineering.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "shemminger@osdl.org" <shemminger@osdl.org>
Subject: XFRM Compilation
Thread-Topic: XFRM Compilation
Thread-Index: AQHXNi0QqhG8L5S010+2zw9v6+sCkw==
Date:   Thu, 22 Apr 2021 14:33:06 +0000
Message-ID: <DM6PR02MB5913FBB71ABD0C78F238FAA8EE489@DM6PR02MB5913.namprd02.prod.outlook.com>
Accept-Language: en-CA, en-US
Content-Language: en-CA
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=rmd-engineering.com;
x-originating-ip: [204.83.243.211]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ae388a0b-9b59-45d8-aec4-08d9059b8b94
x-ms-traffictypediagnostic: DM6PR02MB6860:
x-microsoft-antispam-prvs: <DM6PR02MB6860668ED71E111FBC4D4446EE469@DM6PR02MB6860.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hHk3JZXHoG7yEftsV6Q2b6rkDrRysmXALJ8pl99HYrQhy5M3aVjcl3/xRbpYDcTk8z4DwnWjuaXeu881Bpa2NH4r9qegpUtVJun3oNa4H9ADGp2bLWhcpyf4ct2OAV12dmlznGfM5zlheSnLLbYHkLh/+DejYaFsGTE1nfW9ZTy/hJ2UzqIfmZRPosgMewWE36BMCUpUaic6cZXj1t3sOxWGUWJSCX2w/051uBWXNu950JX6Bwm6WJBAoIlQ3H3rgn9Fpa9ooIc5qQL/gblpOsad3b3B2eln0tMxt9piO1dRmphT04hIWQh9/4yms48xjXlxPIci0GgwLAhMYro/2W7s51V4L4PyOKVWrWIOdzq48gh4lXQg7u6pz/kBgQHueFchwn1+JHtnDNHc7PqFnFHky5ymPGnzoZ3kvDG8UKzto6sVVvqLPt4fY7OEq6yyxsWt0C9h32Uwc4ib33zdS1m+fUedXhltAmvtYkf2q1E/y9z+UhxGftQuyBjfeDlL7h9Va2U51uoCuFTVO1WJk/Eaka/Gqm6O+xnV1Pe/8qC7XPr9525+XWBGugz95Gbpe+FbHcNmINWt6Nc5ztQVwmRof/Sx02EY2sGeIsWUTVg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR02MB5913.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(33656002)(2906002)(71200400001)(110136005)(76116006)(86362001)(8936002)(316002)(7696005)(6506007)(52536014)(478600001)(66446008)(8676002)(66946007)(38100700002)(122000001)(55016002)(64756008)(5660300002)(26005)(9686003)(7116003)(186003)(66476007)(66556008)(3480700007)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?Windows-1252?Q?KDukaQ0FIOUEg0w7BvgWAXnoWmyR5JO0REXGwmi/kbhBHJc18T+RAHge?=
 =?Windows-1252?Q?oy6qG810bBNtqlRIxJ5ttPlgklzOKa3EjRnNOi5CJLmh+bLd+SiDO+S4?=
 =?Windows-1252?Q?B/vWIvdzmtTb9510PPZi4wKo9VP0gs7Q/GGHm/Vc3kB+hbIYKqLxUh9P?=
 =?Windows-1252?Q?Z8X7nvYgw20R+bZa9b/smROm4lkYxEcgKeFhEIhz+uzl0Ai36lBFKURq?=
 =?Windows-1252?Q?ijDXych7D/4JQ0JcoG6RQguANUJ68K7DUYVmXPK8jd4jJLVmBbPcZ7hb?=
 =?Windows-1252?Q?iL0MOKMwssBI6pwiE7QoRE940r04h+4RRA6CuFY7ziG9YCdiK3yMZBPs?=
 =?Windows-1252?Q?WFnqhPIHlbeaKdyDQZjGgZuacbHKC+jn4tM6wDMnEKi2lNd5ueH6D6+t?=
 =?Windows-1252?Q?fBuz7RhlIiNHbIwM5R8BYazr5EiDbBwsgnbNPnnVQKhtfQMmESowSrIp?=
 =?Windows-1252?Q?U8YnpWtFYZhqCSd2t29C2K1LizUoFZDRKnPt/9MsDB6z20fqqwtIxr8q?=
 =?Windows-1252?Q?sJI80XtneC7dZAzHQRNqk6tgIdo3wMVBMHHgmNpK3sw650ROQ/HcPC07?=
 =?Windows-1252?Q?xHQ58rUsM54E7wJalqvsqQvBTVQZAew5aKHQe+CiBXnYsB6UJonsxW8C?=
 =?Windows-1252?Q?JHviakpTxHpqNCM37h9ExG7TS0U6nMnNw7nENivDfAGNQA7o3KCgN4us?=
 =?Windows-1252?Q?uScohnc9M+mSCKkzcd5xDOL/tXoZC5Xd60vakumRh472Ng9CP5yJHmeM?=
 =?Windows-1252?Q?zd1vqXOnhT6w/0Ph8dcF+Wn2lMh1Tb9fXQZewW/cMPTeQdx3F0zGa276?=
 =?Windows-1252?Q?u29lCud4Zy26ZpDChKnk9l+LiAgGe+AwQ/ea9lI9eP4tUDnexubFeIw9?=
 =?Windows-1252?Q?qf20uhbGCWnhnuHPf9u2fmAG1h21rJaQ0FIdC05MwglS/6SJIgIi+Spq?=
 =?Windows-1252?Q?X+D7Ah44STNPVxkVV6fVfnH/wByLLOy6ewmh8Cmx2+5D70AkwtBVNEh3?=
 =?Windows-1252?Q?Q2MNM/FDGp1CKnTI0NH+NYQpLIB+roYAsf5r3ni4my6cN1ZorDMXBxYN?=
 =?Windows-1252?Q?xYq6xB4Q/Em858YkPbKeFFLvWxNFDnj/11UInu8G+f1AkyR/1/+VuZbt?=
 =?Windows-1252?Q?3yxoKumvaeZT6b4HkuOhRXZoBG3qJR9GWBYYqbCDnpwX3VLHwXiEqSxI?=
 =?Windows-1252?Q?Fsmv3rpEHRKerfgy3562xxplyWdf8LGh2eqptI/8Zo1kLEmVL5CPQJf5?=
 =?Windows-1252?Q?KfakdkeJt1LLOb+S1ww7xHsA1vvx4LiWsDQBwWUVsgXmPnabFDBAXKYA?=
 =?Windows-1252?Q?gxWfns+6Ry4LbedDrBXgRW282W1vF0TbdHerdjVol1+6EUYNa8pSAVIM?=
 =?Windows-1252?Q?aJ6FVeEYbxFz3tZcogodVPBpXvBrln5URrg=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: rmd-engineering.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR02MB5913.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae388a0b-9b59-45d8-aec4-08d9059b8b94
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2021 14:33:06.7004
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 93b4f94b-385d-43ed-9197-54f5c1338bb1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +chFLS3wOu4ANMgiS1Lr3g6edQUNn2sO0FDuSXUWXVysS1LB6Oa9ILrUKgBpmwyjd3yTtngXYj4cqebbV7eS2wv5VG2fSSf25BlOMDAz0mI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB6860
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,=0A=
=0A=
=A0I'm an automation developer using a pre-emptive kernel for robotics type=
 applications. I believe I've found an issue with XFRM but as I have never =
dug into the kernel passed "hope it compiles". I wanted to make a comment h=
ere, in case it helps.=0A=
=0A=
This was the same result on 5.4.109, 5.4.109-rt56-rc1, 5.10.25,=A05.10.25-r=
t35, 5.10.27,=A05.10.27-rt36, 5.10.30-rt37.=0A=
=0A=
After running make -j12:=0A=
=0A=
In file included from ./include/linux/mmzone.h:16,=0A=
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0from ./include/linux/gfp.h:6,=0A=
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0from ./include/linux/mm.h:10,=0A=
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0from ./include/linux/bvec.h:14,=0A=
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0from ./include/linux/skbuff.h:17,=0A=
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0from ./include/net/xfrm.h:9,=0A=
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0from net/xfrm/xfrm_state.c:18:=0A=
net/xfrm/xfrm_state.c: In function =91xfrm_state_init=92:=0A=
./include/linux/seqlock.h:178:36: error: initialization of =91seqcount_spin=
lock_t *=92 {aka =91struct seqcount_spinlock *=92} from incompatible pointe=
r type =91seqcount_t *=92 {aka =91struct seqcount *=92} [-Werror=3Dincompat=
ible-pointer-types]=0A=
=A0 178 | =A0 seqcount_##lockname##_t *____s =3D (s); =A0 \=0A=
=A0 =A0 =A0 | =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0^=0A=
./include/linux/seqlock.h:184:42: note: in expansion of macro =91seqcount_L=
OCKNAME_init=92=0A=
=A0 184 | #define seqcount_spinlock_init(s, lock) =A0seqcount_LOCKNAME_init=
(s, lock, spinlock)=0A=
=A0 =A0 =A0 | =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0^~~~~~~~~~~~~~~~~~~~~~=0A=
net/xfrm/xfrm_state.c:2666:2: note: in expansion of macro =91seqcount_spinl=
ock_init=92=0A=
=A02666 | =A0seqcount_spinlock_init(&net->xfrm.xfrm_state_hash_generation,=
=0A=
=A0 =A0 =A0 | =A0^~~~~~~~~~~~~~~~~~~~~~=0A=
=A0 CC [M] =A0drivers/net/ethernet/realtek/r8169_main.o=0A=
=A0 CC [M] =A0drivers/media/usb/gspca/dtcs033.o=0A=
=A0 CC [M] =A0drivers/gpu/drm/drm_blend.o=0A=
=A0 CC [M] =A0drivers/net/ipvlan/ipvlan_main.o=0A=
=A0 CC [M] =A0drivers/net/ethernet/qualcomm/emac/emac-sgmii-fsm9900.o=0A=
=A0 CC [M] =A0net/ipv6/netfilter/nf_flow_table_ipv6.o=0A=
=A0 CC [M] =A0drivers/media/usb/gspca/etoms.o=0A=
=A0 CC [M] =A0drivers/net/ethernet/qlogic/qed/qed_mcp.o=0A=
=A0 CC [M] =A0drivers/net/ethernet/qualcomm/emac/emac-sgmii-qdf2432.o=0A=
=A0 CC [M] =A0net/ipv6/netfilter/ip6t_ah.o=0A=
=A0 CC [M] =A0drivers/gpu/drm/drm_encoder.o=0A=
cc1: some warnings being treated as errors=0A=
make[2]: *** [scripts/Makefile.build:279: net/xfrm/xfrm_state.o] Error 1=0A=
make[1]: *** [scripts/Makefile.build:496: net/xfrm] Error 2=0A=
make[1]: *** Waiting for unfinished jobs..=0A=
 =0A=
=0A=
For now I've disabled the strict warning in the make file, line (947), and =
it works for me. =0A=
=0A=
# enforce correct pointer usage=0A=
KBUILD_CFLAGS   +=3D $(call cc-option) # -Werror=3Dincompatible-pointer-typ=
es)=0A=
=0A=
Thanks,=0A=
Chad=
