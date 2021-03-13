Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3FD8339BBA
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 05:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233081AbhCMEiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 23:38:16 -0500
Received: from mail-bn8nam12on2136.outbound.protection.outlook.com ([40.107.237.136]:33441
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229968AbhCMEh5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 23:37:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=df2hHE4hqLUkxH9BTbdXUefRsST/zct8RifgyKyD0HLXrySPYSR1+iMwO6s0fe88pXX1cC+Cn0eo+zOWCF3QMM6CExjF7y5ciG6G3aDaDQWWorkxyCc029Uv4qkrxo4UO35Ct15Qk0eBUr4VdpOOxkyk7V7hh01OFdlAXBpbaylCyWbIDfEFmxpK4LG3cnjnMj4RWudxHc/YDnO945lbvIT7gN915vc3wF64Fy0AHdmwA1A9WsLJ143YWujsdNptOrz2Pmw/U5zXBzdpHQ2pI0lPzi0CwYY+tM30gIs4gdu2xCoqdN7ie7bfFBnVsLA96MjL+MKCE+tgrOtGIVZuZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K0AWXnAREIjMpsLi9rYBx1E/zzb/cSOA83OQXNfpAjk=;
 b=MjKiqlMmpu+rMsB1o/UeH2O8LRvuYujQhYW70UFBy4WmxjTBDhi1CoFn400i8eqfhD2garqApOg03ng9GuDRz0LaDgv2nRPbxl/WZNUBrS9K7jmINMF1it6yNFTK6yGjWYxjq32g9VQwu7m92NTgKSfRM0oIuaoZoUpP5XACM9rXBMuddKcPM1qedRaiKcFQ7aiF4/DFcCvt97Pd3br5yIpQEqHltX617ORD0so3WF8Afx7xHO9Ye63FFnqIO5gDTkQS5nQXmZ8YsAC4nZTSVUk/UYgw467cZXnfUIWxbHybvWb1Qfzot5avZ0OQpX2sUZgrjkeMJJ4UiOtTV+KERA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K0AWXnAREIjMpsLi9rYBx1E/zzb/cSOA83OQXNfpAjk=;
 b=iRfXQxyhA485A8vQfRFFCJdq60lDqhA+a2zqOMtgiwdPX713ZHD8zx6HH3aJtHKgv88AVq+ui/cjvYVim718KGhS05Z7IZTG7dRxUmtQvWrjJB+uULZeKeFkGbHXczIMsS+0qwdQlZVlnFKpAdM9dyd+IrkzAznKABkTVoGIMIo=
Received: from MW2PR2101MB1787.namprd21.prod.outlook.com (2603:10b6:302:8::15)
 by MW2PR2101MB1788.namprd21.prod.outlook.com (2603:10b6:302:b::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.13; Sat, 13 Mar
 2021 04:37:54 +0000
Received: from MW2PR2101MB1787.namprd21.prod.outlook.com
 ([fe80::c9f1:a5ea:6bd9:f0de]) by MW2PR2101MB1787.namprd21.prod.outlook.com
 ([fe80::c9f1:a5ea:6bd9:f0de%6]) with mapi id 15.20.3933.011; Sat, 13 Mar 2021
 04:37:54 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Haiyang Zhang <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shachar Raindel <shacharr@microsoft.com>
Subject: RE: [PATCH net-next] hv_netvsc: Add a comment clarifying batching
 logic
Thread-Topic: [PATCH net-next] hv_netvsc: Add a comment clarifying batching
 logic
Thread-Index: AQHXF51M9JIEsP+J9kCivpgEZd0J/KqBVeoQ
Date:   Sat, 13 Mar 2021 04:37:54 +0000
Message-ID: <MW2PR2101MB1787E637DE8305957D87D0C9BF6E9@MW2PR2101MB1787.namprd21.prod.outlook.com>
References: <1615592727-11140-1-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1615592727-11140-1-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=c850cfb0-f776-4007-94bd-6b8f8ad960ed;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-03-13T04:37:27Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: microsoft.com; dkim=none (message not signed)
 header.d=none;microsoft.com; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [76.104.247.152]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 982041cd-5001-4ebc-58e5-08d8e5d9c4c8
x-ms-traffictypediagnostic: MW2PR2101MB1788:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MW2PR2101MB1788DB930EAA4F8C9CA15FD9BF6E9@MW2PR2101MB1788.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JNeSuY1N12rEuV2wzGPKfFoNPeW19uTCsVgW9/Yo/jqmhZQUo/rV9yIcSq9wPlt0PErlXF+4e+9hoEJ6388wpPuVWzFsjqbRW2kv7zgIgOEc/XDvJ/pgtvnpArsD+Itvnmi3hV+aGhIXsQ7KSUM/BO1SmTPqWnK0Ci5vMPAMEqLjexHKdw40t1wGVW2rfKPuS8Vm1oXqosmdvFDU3Puk5ApEJPtEHJJLP64EwOV4CR7cPS3s8e8u5v25j70jQZKANFoxQujJtUy3BRyiKoMOgFAm0VpknxW4excDYgSLi++iUg5u7rbTxwfGi2h5y867dLY0xEF/CBgUhUmIdLWUwutlLhmkLhCH35xO2nxnigQX+d8ifTf8B0dIYlmUZ73qMnNwm54RRvJ1vHb1rIv72jvtRzk/s1an9nD8nKjPLcHBMD8fdVjhSLWIlDXt3aZr0bQdOy7tmEoLnzmA1jPmqAvAD7pThNpSB68LbL2OOgM317r1+b5viSGckgqbI/svG/jVIkCjgmxqxfjgk7/mzbcu8ZecEzWn++joHRpIpuNOK3zjq/OcPYDuYPeE5zkY
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB1787.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(376002)(39860400002)(346002)(136003)(66946007)(76116006)(10290500003)(6506007)(8990500004)(66476007)(53546011)(4326008)(2906002)(66556008)(52536014)(7696005)(110136005)(66446008)(186003)(5660300002)(107886003)(55016002)(9686003)(26005)(316002)(64756008)(4744005)(8936002)(8676002)(54906003)(71200400001)(478600001)(86362001)(82960400001)(82950400001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?3+OtSbh7+jrquB+6ElYIBE6oSUCAoHdlXadQit7/7NDW/8OXbqtZJIVE0CIX?=
 =?us-ascii?Q?M8AsOVjehrzFbrTFAXa2Y/CFRWwJmW91ue6uAyAaionTR2LRFhzwOC3Hh3f2?=
 =?us-ascii?Q?RCxomWGNwG1wK16ayIaXZAVBg80QGhsbqfucDNaIOd24ystEIcd7R6idll39?=
 =?us-ascii?Q?TVHlCliD03pbt8nMZZETECgcQhO46Jeg++X4Czouhr7//VJqzKgSYF5C7wF8?=
 =?us-ascii?Q?3buZ/aFsbJdZYXiFZns+Fki8D8gNBHLzmje6JRtTyJknnxMaqq1J5/EatMR6?=
 =?us-ascii?Q?iG2tTkkCcLVAy44OI6pwQbiNxiYfN99yk2EFRjAhI9xL6fFWXW/wUxu5ljSF?=
 =?us-ascii?Q?bpfv2BtcEq9VhvOsMUdlnaSkt7JjTITc5/nr4i04wUD7nUTQajKF+7SULH4h?=
 =?us-ascii?Q?V7+uylI+nj6Lt5Vl8Ssr9is0bAbl4mI488w4tY87J3EwfKBqcJsufTVsY1oY?=
 =?us-ascii?Q?1rmCwGJja16qqblZRXO13/GgzZ7JHsnpE12nb842qnabVclrah+w9JobGRU2?=
 =?us-ascii?Q?h+4FyFEH5qSGj655/XH3p1Y0CXiImqySMjrDJy4KJnzebDJNSneAv7M2IaA1?=
 =?us-ascii?Q?lSbsjzpNXzTahGWzesmddoJTxmZ4OqFCLJkCpDmiSI5k06RHtrRC0NDxo2xH?=
 =?us-ascii?Q?vrnN0qd+Q7dVAUr/cQuJWD4SR7r6ZBvm5jxdYOf8TtySSr5aEwkItl58IXXA?=
 =?us-ascii?Q?ptQHYQ2opWM485z77rKcczr9xLcRaRw4R3uz0Y71AYmflrQ9bvjFOP1MPXIA?=
 =?us-ascii?Q?B1zRgKr+g42FfKA7tSyVOnw1TILGoGI8cAbbxl0/Y9T7mFdU3LENmFipN6Ux?=
 =?us-ascii?Q?QH4a79u1KTqeKe78lHaffkMSZzKFU2+UwfLNPZ7Lj1TSKqNXqQkiD6MWkmM5?=
 =?us-ascii?Q?kGthpled7wnI/854D6mDKCmptPwRe185RQxq+3ATi8bbjK7k7M9cQT1YAKDh?=
 =?us-ascii?Q?0RCXVI8zAjoGc53vJNOIQHme7zqsIqhbFa7eEnmdi4HxvtKzvWyb/3qu8otu?=
 =?us-ascii?Q?Ljj3WqDx+z1L2lyslHKPhr/OxrOnr/Mr3ED7TJ9KzKEToZZo/QcAWIZWh8KI?=
 =?us-ascii?Q?IdEuCPDI65/SqMvaXQMBgKIM7B2Z67ukdLLEAGEkUrHgT9EmdZlSHdNwa833?=
 =?us-ascii?Q?JRQKrBVVeUjqnc8CTwktEbFTk1uLhZzvehkDjaUfLQV/FWTX5o/JkBA1SZQo?=
 =?us-ascii?Q?6YyD1vvLorUsfYwSfjIJH5TTU5Tt0kabU4Vg8BovMuOGYUtBV8ayPycf/hca?=
 =?us-ascii?Q?w9wq7UZRnIWn2IVVVuuWNRXSGu/VnKTIOgvqnAx/I6kfGN8ADIKJTEB3ugBQ?=
 =?us-ascii?Q?TFuD5Xn4LsaV3dYJrqkQ3DPK?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB1787.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 982041cd-5001-4ebc-58e5-08d8e5d9c4c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2021 04:37:54.3784
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jMf27XgLwveJUk5C5QeFbj7sN/kl/HC2N/PACcBXn+4TAKBgij2I8Vw5CSEtAr+2uekI9wEpdoP9BFYFYOaksQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB1788
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: LKML haiyangz <lkmlhyz@microsoft.com> On Behalf Of Haiyang Zhang
> Sent: Friday, March 12, 2021 3:45 PM
> To: linux-hyperv@vger.kernel.org; netdev@vger.kernel.org
> Cc: Haiyang Zhang <haiyangz@microsoft.com>; KY Srinivasan
> <kys@microsoft.com>; Stephen Hemminger <sthemmin@microsoft.com>;
> olaf@aepfle.de; vkuznets <vkuznets@redhat.com>; davem@davemloft.net;
> linux-kernel@vger.kernel.org; Shachar Raindel <shacharr@microsoft.com>
> Subject: [PATCH net-next] hv_netvsc: Add a comment clarifying batching lo=
gic
>=20
> From: Shachar Raindel <shacharr@microsoft.com>
>=20
> The batching logic in netvsc_send is non-trivial, due to
> a combination of the Linux API and the underlying hypervisor
> interface. Add a comment explaining why the code is written this
> way.
>=20
> Signed-off-by: Shachar Raindel <shacharr@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---

Reviewed-by: Dexuan Cui <decui@microsoft.com>
