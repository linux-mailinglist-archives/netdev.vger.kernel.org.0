Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0F412D5ABD
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 13:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730429AbgLJMmS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 07:42:18 -0500
Received: from mail-eopbgr10084.outbound.protection.outlook.com ([40.107.1.84]:51630
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726627AbgLJMmS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Dec 2020 07:42:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BgYJAs8M0R9I4AeWQhX3qXli6DTf2YzNEdbIXnt320xAx6okhgbgjOC+FqaapgdWV+3eIRyTgBewNONuh+4Ji9TH7fi5n0qRkEySCZMtKIT82oSt+BIO+hjg8oI0UeFJYQSCccAcQFbnIf+IayXu7Kfm9qVDPOixyZJcpkpETAUbTyb9hpXco2qhRId2fPyxlllWIMdzqZWkE+PORFqcAtUu6NyJI7usoc3FXRgf/HjwP7oRYynPMjKQJ8e6653LURSVcHvAE8ke04fIQsGwLmqdTRW2RaaOEVvr725noUGiY5y8zaT8vKn5jvx8SZpgLBiV52Sm0Ez4+e0OeOtHdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ue0L9VaofB+cB2aTw/+J8AifybhrEU09XUfNf72Sos4=;
 b=dPmqIknfI1fzWgpBonI03RxRBfQZhBr3VlWfHq527MsLjYo0u6BeHv53+vW/zdfFOa2XCdlO2VVWog84XNpoYCztjiufKu2yucLdythGn3iegG3yO8/Uz3yxZHQrxf5IEjLELGaQGtLGUToF3hQAzJbtwVvABXPU+Qm3zMwXU/l9RNeFxZcRnORvwSKK56X7WKA+hNfsEd43ZW/h7QwlL3/Qc0RyXnVSUcoXjheDUzkFfoNhhbQXDJeGn5b2oc0D8lyQXV17M1xILpmGfzxZVK5MmiP1gxyJOGpNk/T+EJHdPxi4iHONmZJTP0H7h4U7SWII59ZGN38LbLLR3Q2PqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=siemens.onmicrosoft.com; s=selector1-siemens-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ue0L9VaofB+cB2aTw/+J8AifybhrEU09XUfNf72Sos4=;
 b=l7dcy41LIIf06xkXvIjpPygS3bfR4EMHL8c06/se546pfJeGr/w0htmLz8HWhaCqiNV/THrghGPVTpwYe/b5aa/NzmXzZ9dMoBIEIYamhIhPEUi0d451XcWtV4VtsQmekyfVc/n/kx3kyUynARUGzCOkA+VZ6Jj0Yn43V9JpDQI=
Received: from VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:803:7c::28)
 by VI1PR1001MB1184.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:800:71::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Thu, 10 Dec
 2020 12:41:32 +0000
Received: from VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::c4f9:99d0:c75:bc2f]) by VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::c4f9:99d0:c75:bc2f%7]) with mapi id 15.20.3654.013; Thu, 10 Dec 2020
 12:41:32 +0000
From:   "Geva, Erez" <erez.geva.ext@siemens.com>
To:     kernel test robot <lkp@intel.com>,
        "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>
CC:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Arnd Bergmann <arnd@arndb.de>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "Sudler, Simon" <simon.sudler@siemens.com>,
        "Meisinger, Andreas" <andreas.meisinger@siemens.com>,
        "jan.kiszka@siemens.com" <jan.kiszka@siemens.com>,
        "henning.schild@siemens.com" <henning.schild@siemens.com>
Subject: Re: [PATCH 1/3] Add TX sending hardware timestamp.
Thread-Topic: [PATCH 1/3] Add TX sending hardware timestamp.
Thread-Index: AQHWzjjS+JtwwiLyJkKEw3ObDmZ1g6nvp7+AgACdOQA=
Date:   Thu, 10 Dec 2020 12:41:32 +0000
Message-ID: <VI1PR10MB244664932EF569D492539DB8ABCB0@VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM>
References: <20201209143707.13503-2-erez.geva.ext@siemens.com>
 <202012101050.lTUKkbvy-lkp@intel.com>
In-Reply-To: <202012101050.lTUKkbvy-lkp@intel.com>
Accept-Language: en-GB, en-DE, he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_Enabled=true;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_SetDate=2020-12-10T12:41:28Z;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_Method=Standard;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_Name=restricted-default;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_SiteId=38ae3bcd-9579-4fd4-adda-b42e1495d55a;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_ActionId=36be2cc0-ccad-4f02-9e4c-38a075a14bdc;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_ContentBits=0
document_confidentiality: Restricted
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=siemens.com;
x-originating-ip: [165.225.26.246]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6b9f8b81-e587-4c26-63f7-08d89d08ec9a
x-ms-traffictypediagnostic: VI1PR1001MB1184:
x-ld-processed: 38ae3bcd-9579-4fd4-adda-b42e1495d55a,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR1001MB11842B28BA14B3653C78C14BABCB0@VI1PR1001MB1184.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Jh6mTUlDDPDO/Wu5qjJwL1KNyBwm/kiAPae21Skkh0dvI89N/4uqCFpV7IOcQmtF8m821n3Lb2YrHG6TSY7MRi33kbM80/vNdY8Z+M105C5Pghi5A8bUFHWw5YDxP1otigHz0McaOYwG3PcHguPFsa3s9hBLN855oZN+9pIGLPEZQ7/mLuX5KrglOwROT/NTzU9jYgIj8dM3MxOppfCirSO9iSVq150wyRmGIifW3YjkH0ssmi8FYUfnDlYyZZK1TyCcJEftDwH9mo2hnUpEpQP4Co0gBfD9dCiPbTpuxGkqGhZC+166WdQMmxeMYp/9mpu1kWsW48EJmLYZjbMr6dYwj//Rdd9KxmJj3zLqyh9GmqtnL6oQRjiyfFPAOsoWuVSqqZl9k0uis1wKCRNZ3w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(366004)(39860400002)(396003)(376002)(86362001)(7696005)(8676002)(316002)(4326008)(966005)(9686003)(71200400001)(66446008)(110136005)(76116006)(54906003)(55016002)(52536014)(83380400001)(7416002)(107886003)(8936002)(66946007)(33656002)(64756008)(66556008)(55236004)(53546011)(186003)(6506007)(66476007)(26005)(478600001)(5660300002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?VH6wREcpsF2hNCZcL/qAzxfyuUOQR+VmmhAW8uuBiWfOm8gbuo46ihlf679a?=
 =?us-ascii?Q?BY3qFeF+9BVyVhoT2IZ6uXKkYyoXwRD+wwVo2RWvKmBYt6bz6dHw85fr2j3n?=
 =?us-ascii?Q?r0DFJ3GY8BSkevcWg/J0c9WqHpw3G7cG83tYuQ/MXULmvo+aSaT1NhMK6FcQ?=
 =?us-ascii?Q?KfSLJYNg4K1yaxVm+QdV1XQNL+Ju7oB4l4Y8MpOikmbZv3oH6L5J4O8PvPib?=
 =?us-ascii?Q?lBLTjdk/9GUw6MOpkOrzT79tPt/gFufCkL/tyzq90ktKloHcaas10j5aLcxd?=
 =?us-ascii?Q?+amdkB7EoUbm6gEzqPNmpsK5Z4F5gSVk1RLctZtTiTuQWl2VDA09J3bftkS2?=
 =?us-ascii?Q?eq1TrDRIS20anKL0r3aOpF28lZGUgnOY3+4rrUL8I4GvS62Kdd5S6P/zgMdQ?=
 =?us-ascii?Q?k/53XN2CirMqoKtK4UctL/YU7MQjapWB40ouM+Vgy1+Tk1L8BgO2ENwHESLV?=
 =?us-ascii?Q?1LzT3csmxDCVU3Q79lLBSLLyi9ByIxR243ZD21VtvEfkwzqaTOzPBM/p4m4m?=
 =?us-ascii?Q?lXB9waBRTDiUh9T1JFKE7QPJbwOasM+Ur2qkkFND3FFLK/JpJg1TlrRMdvLB?=
 =?us-ascii?Q?h3c0TuqJEDOj3tyrWK/3sDSsR4mq6fsR3UmXoD87yrgbQf5bAvGYLTmgOhLW?=
 =?us-ascii?Q?BZs6lf/+P260Uoax0zYes8mMn5YFXIbAqlzTGadaeq7kY8Rhietz628coagb?=
 =?us-ascii?Q?MFrHzYSP/p7kmm6WGLbMROZzercDASuquHixBXyhsyEzxGuFgAUPE5ReXT7X?=
 =?us-ascii?Q?VQCUpdHvnSVJoJURJVggObSJlc72HJs8xbFdSsnrXO4AQOFILIaSoygybTdF?=
 =?us-ascii?Q?2B0uNEXo9U2ZT9QvUKzyEiJ5zXTWRmIgPXHr0f0qXHbKTscECk7aS4rmmaX9?=
 =?us-ascii?Q?NmdfNrIn+VX66kFFZ7q5xUuduUPh9hV+6ZY1D7TNwYVyM2OrBkWeAE/i4I9X?=
 =?us-ascii?Q?HaQeDyIBDRgoBrI8MFrJzM33UCFHyrwe+GXrW3WI0ps=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6D4AB493AEBD924FB0CFB7E02EAF8799@EURPRD10.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b9f8b81-e587-4c26-63f7-08d89d08ec9a
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2020 12:41:32.7015
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sRzkujigBFpC6VPCL9dYmx8/PIL38BicDBe0DaFwlntT5VycUsYEB7yQ16mPbtpeAmr4paKxr6oeimLF06jiR7sHsRZ0Qh33vie6tlqkEbE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR1001MB1184
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/12/2020 04:11, kernel test robot wrote:
> Hi Erez,
>=20
> Thank you for the patch! Yet something to improve:
>=20
Thanks for the robot,
as we rarely use clang for kernel. It is very helpful.

> [auto build test ERROR on b65054597872ce3aefbc6a666385eabdf9e288da]
>=20
> url:    https://github.com/0day-ci/linux/commits/Erez-Geva/Add-sending-TX=
-hardware-timestamp-for-TC-ETF-Qdisc/20201210-000521
I can not find this commit

> base:    b65054597872ce3aefbc6a666385eabdf9e288da
> config: mips-randconfig-r026-20201209 (attached as .config)
> compiler: clang version 12.0.0 (https://github.com/llvm/llvm-project 1968=
804ac726e7674d5de22bc2204b45857da344)
However the clang in=20
https://download.01.org/0day-ci/cross-package/clang-latest/clang.tar.xz  is=
 version 11

> reproduce (this is a W=3D1 build):
>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sb=
in/make.cross -O ~/bin/make.cross
Your make cross script tries to download the clang every time.
Please separate the download (which is ~400 MB and 2 GB after open) from th=
e compilation.

Please use "wget" follow your own instructions in this email.

>          chmod +x ~/bin/make.cross
>          # install mips cross compiling tool for clang build
>          # apt-get install binutils-mips-linux-gnu
>          # https://github.com/0day-ci/linux/commit/8a8f634bc74db16dc551cf=
cf3b63c1183f98eaac
>          git remote add linux-review https://github.com/0day-ci/linux
>          git fetch --no-tags linux-review Erez-Geva/Add-sending-TX-hardwa=
re-timestamp-for-TC-ETF-Qdisc/20201210-000521
This branch is absent

>          git checkout 8a8f634bc74db16dc551cfcf3b63c1183f98eaac
This commit as well

>          # save the attached .config to linux build tree
>          COMPILER_INSTALL_PATH=3D$HOME/0day COMPILER=3Dclang make.cross A=
RCH=3Dmips
>=20
I use Debian 10.7.
I usually compile with GCC. I have not see any errors.

When I use clang 11 from download.01.org I get a crash right away.
Please add a proper instructions how to use clang on Debian or provide=20
a Docker container with updated clang for testing.

> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>=20
> All errors (new ones prefixed by >>):
>=20
>>> net/core/sock.c:2383:7: error: use of undeclared identifier 'SCM_HW_TXT=
IME'; did you mean 'SOCK_HW_TXTIME'?
>             case SCM_HW_TXTIME:
>                  ^~~~~~~~~~~~~
>                  SOCK_HW_TXTIME
>     include/net/sock.h:862:2: note: 'SOCK_HW_TXTIME' declared here
>             SOCK_HW_TXTIME,
>             ^
>     1 error generated.
>=20
> vim +2383 net/core/sock.c
>=20
>    2351=09
>    2352	int __sock_cmsg_send(struct sock *sk, struct msghdr *msg, struct =
cmsghdr *cmsg,
>    2353			     struct sockcm_cookie *sockc)
>    2354	{
>    2355		u32 tsflags;
>    2356=09
>    2357		switch (cmsg->cmsg_type) {
>    2358		case SO_MARK:
>    2359			if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
>    2360				return -EPERM;
>    2361			if (cmsg->cmsg_len !=3D CMSG_LEN(sizeof(u32)))
>    2362				return -EINVAL;
>    2363			sockc->mark =3D *(u32 *)CMSG_DATA(cmsg);
>    2364			break;
>    2365		case SO_TIMESTAMPING_OLD:
>    2366			if (cmsg->cmsg_len !=3D CMSG_LEN(sizeof(u32)))
>    2367				return -EINVAL;
>    2368=09
>    2369			tsflags =3D *(u32 *)CMSG_DATA(cmsg);
>    2370			if (tsflags & ~SOF_TIMESTAMPING_TX_RECORD_MASK)
>    2371				return -EINVAL;
>    2372=09
>    2373			sockc->tsflags &=3D ~SOF_TIMESTAMPING_TX_RECORD_MASK;
>    2374			sockc->tsflags |=3D tsflags;
>    2375			break;
>    2376		case SCM_TXTIME:
>    2377			if (!sock_flag(sk, SOCK_TXTIME))
>    2378				return -EINVAL;
>    2379			if (cmsg->cmsg_len !=3D CMSG_LEN(sizeof(u64)))
>    2380				return -EINVAL;
>    2381			sockc->transmit_time =3D get_unaligned((u64 *)CMSG_DATA(cmsg));
>    2382			break;
>> 2383		case SCM_HW_TXTIME:
>    2384			if (!sock_flag(sk, SOCK_HW_TXTIME))
>    2385				return -EINVAL;
>    2386			if (cmsg->cmsg_len !=3D CMSG_LEN(sizeof(u64)))
>    2387				return -EINVAL;
>    2388			sockc->transmit_hw_time =3D get_unaligned((u64 *)CMSG_DATA(cmsg=
));
>    2389			break;
>    2390		/* SCM_RIGHTS and SCM_CREDENTIALS are semantically in SOL_UNIX. =
*/
>    2391		case SCM_RIGHTS:
>    2392		case SCM_CREDENTIALS:
>    2393			break;
>    2394		default:
>    2395			return -EINVAL;
>    2396		}
>    2397		return 0;
>    2398	}
>    2399	EXPORT_SYMBOL(__sock_cmsg_send);
>    2400=09
>=20
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
>=20

Please improve the robot, so we can comply and properly support clang compi=
lation.

Thanks
   Erez
