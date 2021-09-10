Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5C7E40702C
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 19:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbhIJREk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 13:04:40 -0400
Received: from mail-bn8nam12on2052.outbound.protection.outlook.com ([40.107.237.52]:47456
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231154AbhIJREj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Sep 2021 13:04:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EA3bQYM4ywtFahryXuZwPJQJ+6dEwLy78K+W1fVfVIoagX2p0O61Nx0FY7oyLNe+A69biAfnNCFprkKx3CWlmlDYIbVEpD42EW5qQqCjmhdNDWlzXCeJE+0zw7FLb7hQcwEr/BH3Q1BJGlBkaHxNkmjLeaATi+cXO7q9Y3TGwTF9ENAtqYQO73Duh7Zr/OLEWQyMS2tDfWG/zVHTYsqGn/jVBAwKIYL2YDxyhvwd240SSeS3c1sCtqcKjCftGSmYGOBdIbHXz85neiDHXWuHtUmpS6FvMC+hB9oAH8B3aYzoIDkaS7QJc608GdoTFCC678fFZMmw02UiRGSJMTLk+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Qi4ljE1T+Q7qOsoXIFHPEdVJHZqPJT4AchhEKwhJw5w=;
 b=kbS6tg6u6tUv+R2wE3maqZDZX/j7Mi7ncONMO64me/PEKScNVUG5u4Jf4zVCVJXDXDwt8+Vw95jtbmnTUKmRvC2OWWynoA7+9r0GelAaxHzjTtnbRbQrg1F0AkY1kzQ/pAqD4sJGdTpjnBR0WcwY9CcufB2GH7AryKYQpWKjiTs2TzmEpvMMXZ6/iLwLC70LNT4ebIVB8RMRwwhuYwCK3zXac1VWDIUPvVVwGKGDQK1sm/eroUGn5iFdMV/Xzom+5icDh7k9gwFxSUr6+TDA7Wmjn85uRaLxpjMdOp0/zJ6/k88TIj0hjXy7xVJJ+xHCH1U1uiAOCHVPo5p5bGpDPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qi4ljE1T+Q7qOsoXIFHPEdVJHZqPJT4AchhEKwhJw5w=;
 b=PI7A/ZHZwNLJb2agfNqi3li6PPfLuBitkrzpWZjbPVAH/LDkXFFqxLoBBAiURLfIiQyKsC348bSXWXKtjYyxR7Q422+Gu0Gq897W3WmQQm9i2zrwJYpZcKYKRzYMY/UU6+/rP6XrsNVOHoKyMeiAXv3ODpI/qb2rG4uyVTr3prU=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA0PR11MB4734.namprd11.prod.outlook.com (2603:10b6:806:99::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.15; Fri, 10 Sep
 2021 17:03:26 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Fri, 10 Sep 2021
 17:03:26 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     Kari Argillander <kari.argillander@gmail.com>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 13/31] staging: wfx: update with API 3.8
Date:   Fri, 10 Sep 2021 19:03:21 +0200
Message-ID: <1877189.TBeQGNYS2h@pc-42>
Organization: Silicon Labs
In-Reply-To: <20210910164326.ivhlbnaq6526wcso@kari-VirtualBox>
References: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com> <20210910160504.1794332-14-Jerome.Pouiller@silabs.com> <20210910164326.ivhlbnaq6526wcso@kari-VirtualBox>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-ClientProxiedBy: SA9PR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:806:20::14) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.localnet (2a01:e34:ecb5:66a0:9876:e1d7:65be:d294) by SA9PR03CA0009.namprd03.prod.outlook.com (2603:10b6:806:20::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16 via Frontend Transport; Fri, 10 Sep 2021 17:03:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 552218db-10d8-4306-10c6-08d9747ce798
X-MS-TrafficTypeDiagnostic: SA0PR11MB4734:
X-Microsoft-Antispam-PRVS: <SA0PR11MB47340D497F57ACAB4B683D2293D69@SA0PR11MB4734.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JbzppeVj0/gybMTYBKH1RTNqskkeVdQZa5rA05MQdY0haUY98bbKCHRmBzGi6y8wFheuin/upN8DeFIL08s0C7Sl/AaGA8X7B3O7IF6G1ydO/P1OUYzEz3aW/6RaPNBXcc5ohlQwg6JO4zG98aApWqtkX8fIrwqIhsuYTG5bLUF+fEK+v4x7rXdvBWXmx7bDaQRxilvQPsdovdOtfWiavmkZKwXONEMQTtrLHuIFs1RX8j5mkuB/VwFPlGFdq534YzY9txvQVIJJBuE5enS8MMNi65uX1w2gSuCQ/kYZCU7VhZIn4nvmUHJzL+7jHRPeRXDcRt0NMjPWSu6ch5vtLe7rpkWIRjtGDOsdqcqGbXVJxswuLC377ZnhQAK7WjD3Q/xLe60/4t/OKMwodzBti5tZUP2ofBiYf9XkyoNl77d2iv0Ht38pl6aPdUuTflmsGvHi9GG6PYVYx1kC/+KT6GG5r8cATq8zqhSYxx2pqfFDDe9wllX3DoygSCcuZr/68G2veYD2HT4I7n3eeQyigyI3/dkON6/NkFuwxcpUZ1/qhI2d1gA20DcpkhfBXgve+MSRnoesngQaxoByN60lmpadTaP+UfHt0WF86ouVU0/cjPd21oOPHSNBmY/cDt8gdDGd+W/5Nmdrqe9WgwI0aA9uCRVEBcWsYx5ryWPTokA+BdWvKjYfL/wnaVPq3IBBjSTGVKBfHETnrTZZUhntsjHxfeJBHxWKHcxsDeGnYoYp1N27IShn/n5I18GamyDpq66/7CfZV9nPOmvfFSkO/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(376002)(136003)(396003)(39850400004)(316002)(6512007)(54906003)(38100700002)(8936002)(6916009)(66556008)(66946007)(6666004)(478600001)(5660300002)(66476007)(6506007)(2906002)(966005)(4744005)(33716001)(52116002)(36916002)(9686003)(4326008)(6486002)(8676002)(86362001)(186003)(39026012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?AeAYX1vvr89pyAPIO79idsPoKzlpKAhzJ/nEH5yEsJtYM35dpe3UdmgFX/?=
 =?iso-8859-1?Q?aKHnLbvcgwvISwxehj5lH2GptvZJq/mw/xDPULba1Jwafu2H9JxTTmGheG?=
 =?iso-8859-1?Q?10CyrIXzagmUQJCFOHVlBfXYrlAk7jOJIcZj55F9O70XyP4nh/r9Zn6qmr?=
 =?iso-8859-1?Q?8LcVDhA4+6nqsdfHc6K7lLaB3//0frci/LwkJ6tn4a6lX+W/sAerRHcFvk?=
 =?iso-8859-1?Q?Je6qvSCF7v4XhQcSwTQje3y79D+dXN/YJwTRBFO/YWoBuxyuA18vVRliJ9?=
 =?iso-8859-1?Q?E/1FKobfXAkFjHWULlHIN3uQ0mE4oQR2wJNofud2aCOWnOVj0BfXvfVSAl?=
 =?iso-8859-1?Q?yLX8UnCCESrUWcP40E3Gm/4BgVeImhAmYR/bZE1t78NeZBID8YkFIt8x4w?=
 =?iso-8859-1?Q?8oqs1VKTt/A70cTL+vRlrmWlk0Hdf5qVTbV35TRXvAi/iDSVDKuS7/k/Ya?=
 =?iso-8859-1?Q?HeR24ayPcF1SSjebLazSNyOYYbVGTid79fpZvjzF7tTE8YoJz9Ekf3gjLS?=
 =?iso-8859-1?Q?bvhLU72kNvhXbZSoZFQ+KA2rZRKLMKNilHy6Oz3h9MlYMZqB7AoQq/hCmd?=
 =?iso-8859-1?Q?qXNWBlzyAl0kAUzG6iA4X8cuK6hSJQL11NDLsvZjHJyOtmzQrqQxWoa+UW?=
 =?iso-8859-1?Q?CSzqKqTrhTLiG6g6evwyktXVLKQ2BR1lIK2Q3GYh8XnSoIs8XMvJ9t7n89?=
 =?iso-8859-1?Q?zbD0Y8ocHY4fFE/ym1rJHWOtA3BI3CLbVYLuB/Z+TKrCCw6hSrrY9ytlN+?=
 =?iso-8859-1?Q?XXS9vUP9+Y+wDn0rjFMrOIQKq9IWSnzcDfC35ySmZHNI1h5aYYoUXRumyT?=
 =?iso-8859-1?Q?3PtMJjoH3siHlKfcHdRNJhB1BRwZTU2pU9Gn/krfbxIObpltnDVcr3koIQ?=
 =?iso-8859-1?Q?n/LKCcH8uEs9P6keRxr4U9NR6S0pXm7h/IYbS4Qzxl/+32R/8bVSOuV++J?=
 =?iso-8859-1?Q?k+dfpAg5hBDoG7iTPpW3SY+fMXVroKBgDahTx1UEiD8jFDRCZEPTfD2pjh?=
 =?iso-8859-1?Q?sUTTTwS4ubefaqF6uVQRNLXhrLOc8kXNcGPsKxVP6xdYtBez+tX9TQrk0O?=
 =?iso-8859-1?Q?A9PKkP0224/CAiVCZg+oF5Y+rITEQDE27RkFxwUP4iNZw/HIGGj88NzfP0?=
 =?iso-8859-1?Q?myD53DLjfOUgstq52/xYQ+xFftXXF64s3G0IUqIySUXSdlbxjAXzEGw5Ra?=
 =?iso-8859-1?Q?q2QRuWyC57bY5yKaYts+5XexdCBFBzCx2kK1UUbwQhfNNt9VMFL3xVb7+h?=
 =?iso-8859-1?Q?VL940RdFuWDMDwlBtM90OYLDSzQEKIcWFv+gqHKQZ1MBBM7ESunoVaRBB/?=
 =?iso-8859-1?Q?nYWTrEnt7MRwSOgt8FwZR3FwD1GL3QqE79rPFsfkAk3hHeCduAS7N5h7Eh?=
 =?iso-8859-1?Q?82DvbpNTqkOJPVSbqQN3X/q4u7UhHRpjQ6qTwuaHHbmWEhEr4eXnF3xATr?=
 =?iso-8859-1?Q?FLY7dCepQ5w6NhDn?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 552218db-10d8-4306-10c6-08d9747ce798
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2021 17:03:26.0984
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u5RQurcTgXqyfUnXbZ4emtBG4mwQ3Q5uOiMAe83aQ3UmLIlIfXo2YyHfGaWVOCsIB4xeBJYnhiX5U+r9aj/cVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4734
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday 10 September 2021 18:43:26 CEST Kari Argillander wrote:
>=20
> On Fri, Sep 10, 2021 at 06:04:46PM +0200, Jerome Pouiller wrote:
> > From: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> >
> > API 3.8 introduces new statistic counters. These changes are backward
> > compatible.
>=20
> It will be obvious to some what API 3.8 is. But at least me can rise my
> hand and admit that I do not. Probably wfx api but ig there is any
> public info but it here. If there is not just say Wfx api 3.8.

Indeed. In add, it seems it is not documented in the release note of
the firmware[1] :(. I am going to improve that.

[1] https://github.com/SiliconLabs/wfx-firmware/blob/master/CHANGES.md

--=20
J=E9r=F4me Pouiller


