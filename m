Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4927640704F
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 19:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbhIJRNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 13:13:49 -0400
Received: from mail-dm6nam10on2077.outbound.protection.outlook.com ([40.107.93.77]:36769
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229682AbhIJRNr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Sep 2021 13:13:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fu+F3L9Z2kTDlk/zOECfMt1nuPLzZglIrlF5FFRNp8zMGwqqeIChI13kLZ5NOUozKtY43Gjs9N95qiQ72dNNIa0ENBGzIASoSyToLTSrZZ3woUJoD8oHH1USJImqlQ8GcI8IZDrXIozg7yr01Y5CM4CcTaNmvPM9Sc/hQd25DwfujHRT8Qhcq7WPM5wb85jL//pbEc+ulGC+7X5ieXjJRcZ3kFZeVn6H68DaV337CDOAqCCapFBTuiLnhYgp6n21XojmyZ263FvIOX+/ICdTRXsCWgsdxnkbEMxDu6/9F0FOMKoj0zoAZPx3IC5qKIFwyCGTsE37nvbRhLi5/xNSTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=IUwq7SZ5OqcrSpOICjPbBeidxnvdR5Gc6AR2Bq2c1CQ=;
 b=CWJfswp+S9LOh0xujMlNCUu8wVfJL7UCa+zQDe+B/VaXRo/D46JxqbfZzyfi5HKO5TWrby8dVsND1R76jGOOEXXoEmoi+gG0lgvB3ANt6McQIGJHQfUV2/4YKRjTiaTbB8oo1vhOrG+weJHxeHnUYwpYn/VnhqpmAoYC0wNN1l/igNKrvL+JsjzFb3qO52gSQFklgR9XxOv/NVZL2AG4+aoj9bhOBV92ybXj2by6nU6i4CpHdECFgXUTOJp/iZqzn30dl8k0N/6xQlEOhxiUhqqMBygR7LzeCnZH/RWHap+gKn3ttFLjvFsmIo6JTGPe11KrOUAPL4KvFTgHJwYIcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IUwq7SZ5OqcrSpOICjPbBeidxnvdR5Gc6AR2Bq2c1CQ=;
 b=PJuTI2pDTPmLyIo2HmoMnmCQLU1ZqnZvRBkKcP0tk3E/Y68vGUDK37ZDJmwL+gn1avQ4BXQ7uLqOn7cgMNSFkq5XL1Hi8WfQbqDb2bueGfH2cCqkIkBV/yZMa2uISLDL6Y+vge2D0zk/LVSLLGuM8EJFfO6c0fN3z1doF1tpz6A=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA0PR11MB4688.namprd11.prod.outlook.com (2603:10b6:806:72::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Fri, 10 Sep
 2021 17:12:34 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Fri, 10 Sep 2021
 17:12:34 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     Kari Argillander <kari.argillander@gmail.com>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 31/31] staging: wfx: indent functions arguments
Date:   Fri, 10 Sep 2021 19:12:28 +0200
Message-ID: <2462401.Ex1rHSgKji@pc-42>
Organization: Silicon Labs
In-Reply-To: <20210910165743.jm7ssqak7gouyl5j@kari-VirtualBox>
References: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com> <20210910160504.1794332-32-Jerome.Pouiller@silabs.com> <20210910165743.jm7ssqak7gouyl5j@kari-VirtualBox>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-ClientProxiedBy: SN4PR0801CA0014.namprd08.prod.outlook.com
 (2603:10b6:803:29::24) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.localnet (2a01:e34:ecb5:66a0:9876:e1d7:65be:d294) by SN4PR0801CA0014.namprd08.prod.outlook.com (2603:10b6:803:29::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Fri, 10 Sep 2021 17:12:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bdfee728-6c30-4c9b-cd83-08d9747e2e47
X-MS-TrafficTypeDiagnostic: SA0PR11MB4688:
X-Microsoft-Antispam-PRVS: <SA0PR11MB4688E86E7BD76D835F6CF5A793D69@SA0PR11MB4688.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Etk8Di0VczGRxtFbwpf8CPXNyCxj0HRGSwPjBJROpz6pyJzOCzIVOjsF0g9xo43xKjdKkZl7Piy3q9hAv3HNPIrVrP2PcnOPcfJ5OcSbyMKm6qlJYDrKd6GafewOZ32EqylSK7yFUlGvZfcbLw40imPx9cF133xp3RyIxww0iu/RiKA4K1Qdff61Q+kfew0VtIK76cwiDLBdFksXgVTkja6UgVy2FiBD+WRg0kMtm2UFf5yY/lHGDJB4ZFjGjsmMmzvCJVtUFzQNDsfnyzeWl/VCB9WxBxi/TQsyGvnm/e0ta9GTKvJOF2RFBAEk51tjEeEj4Tg0TnxQFS7OtfpOeDwbc79qt4AWRDyXSTMU6q/Qy1iS08Y7tJXnqaJxXZn1ACO58O5GjJtiTHAA8AQE8hIVY6X1l6tZr264X1wEIRIHaAmvFmATRTNwsvb04/bMkEKgKalJ+BG1Chl7zA77/uRc+veBbYD5mGDXUuSbllR8fj8+xHf+VybevIsg4tE6EHXUvcNEpS0/BLKtN/cVm8NSFElgt8FcMpBv5WYN5H1BKpQllvo1GPPEGBt9Bd+fEYA3YHfaLF3qmIKqBNS7s2NSAllRRXxATIENikaqpN7AwQi8Jwd6TrIQpNl4FCvdeoplD/PCOGcxfHKgaB+Ff19GbU4FujYIxk77ixJarQCTbdjLO+WNHBh8jpFe6BJ/eAG9SlKErWoE4NIhnx/ToQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(136003)(396003)(376002)(39850400004)(186003)(4326008)(8676002)(86362001)(66556008)(66476007)(6506007)(66946007)(4744005)(6486002)(54906003)(6512007)(9686003)(52116002)(6666004)(8936002)(316002)(478600001)(33716001)(5660300002)(6916009)(38100700002)(2906002)(36916002)(39026012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?yRz7KCL7KvTEosRiDF35njsJQdrNI/XlQMs7OMr+6bE1RZXmAcDfvTfw+2?=
 =?iso-8859-1?Q?mt4PiIcsyZyD8DEP58jdNJ/F5x4iO+yL6Lm5G0yiSICeCcs7QBU4UxJS0s?=
 =?iso-8859-1?Q?J+Lcn6Fi8xhGaeovsjZrFbAsw1exH0DM7tE96c7JmSEFfS27SeWUMcxkUV?=
 =?iso-8859-1?Q?NrAEDmW/2X7dtakwKTOFYX8ztUW+ZSodOjaYsIzwRADBF8NZe4wKf9EFwI?=
 =?iso-8859-1?Q?aROKVn16s8c2KdyPk+aRjGqmrTFGno1YBQzyHUk7veZpckqM3zpeKGp9Bx?=
 =?iso-8859-1?Q?2cCixU/wJguDBcv+/VL7uLj7W4npPyI2N3Q9rI75S1ifWpEW8PKaUI5Kzp?=
 =?iso-8859-1?Q?Z0avbSyU4P3/TZzNtkjv06KvutPA39V+MZ1Uxh3t6nron7IZH0xJCnVb2h?=
 =?iso-8859-1?Q?ymdzX2x+YkWMuJdn8jJ9RfFXkXIVaWbNIEgsmkfo7W8UUVNI84Tvfrugkk?=
 =?iso-8859-1?Q?s/4IJpa6wInA6R4ogg9Wo+gSb3UWhxkCe4bbIK0LCuaOXnsQKdPW2JZGrO?=
 =?iso-8859-1?Q?fVvpq9N5KXcKGSNPleGeXdU1xQGnajflCx55gCbFzAjN+29qe1tMSJhnwQ?=
 =?iso-8859-1?Q?5gvU6PgrNEiSlka4qOIgSBLWuL39Qpm/fXv2bqckiN8r6VR1LUwoH9T3v1?=
 =?iso-8859-1?Q?XBqdZEHykP9twJnAHAkacEbFMhkRjJwgS4snzv+LlExUAmHUIkotGrXNUO?=
 =?iso-8859-1?Q?Vhk+bC4Kub50G2gXwDuSjwYggFJ4GZi6ALjbB8XdivEYKF/RKdx9q8cyoA?=
 =?iso-8859-1?Q?uEMD+MJYortjZTGAqLcIBr1D3wgGYnpV3g6E5H1UdUU0Uy+Fwc1w2YXbeS?=
 =?iso-8859-1?Q?ENjOsDko9mdUImtoTq/kTV3nbPg7rT/xFxWMgrm7etTVXHY8CeGEBm0MC2?=
 =?iso-8859-1?Q?sDLrM4UGF+mYTucLVFvk3aIIq4DfkBZB7XMOMiogX/M8sSxUH9Du/YZpZ2?=
 =?iso-8859-1?Q?f9gjwyhR2UWa2mc+/Yhj7AKuytyN+bbcQstc6XfqyetFRn4kpNsmK5GHhV?=
 =?iso-8859-1?Q?kHedj6v9YFtrDys7z/gfep4vcwB2Mnl/T1YbuCVb7CuRKZ4bc1Bm2nO8Rk?=
 =?iso-8859-1?Q?gCeDNSSuPVTjD7ERa8nM7s4qMd95v+96DxJpb4xxgIfQMRd2CPvx7McqED?=
 =?iso-8859-1?Q?xb7Yom9/2Pbxk9W9axX5n4usCN4ehkuV5UnO5sxyNMtUrZeidlisJt413U?=
 =?iso-8859-1?Q?6aHb1dWf+MiidjzpiJr0pcybfF0KlxFBkNY8qLK7p+Bc2jWDsKAmo2h/dw?=
 =?iso-8859-1?Q?DOUYhim7r/KnJp2S44LwWVGHr7WpP63fEwOCKwHeSLciwteRs+Kdwd0q8A?=
 =?iso-8859-1?Q?JCxfc+q9cF64ikiucXwRpo7ypatZdJ/k1DiW8ZcPGTIO7lhmrAJZ05nVVs?=
 =?iso-8859-1?Q?YavZtARTHqzxdWRFc+7ENRcpzs0TDqx99bSTvqO6wM94HAl7/9lXVv6ZxK?=
 =?iso-8859-1?Q?bCQ9fBbQJyq/K7EM?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdfee728-6c30-4c9b-cd83-08d9747e2e47
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2021 17:12:34.2333
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UZ0mPV4203B/1tp+9dDGiCA6A4YpmAhQk/je/MxCE76fVY+9O9TDlCIFPGLDJxPQesv77juSf6tsW2XAZDZmrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4688
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday 10 September 2021 18:57:43 CEST Kari Argillander wrote:
>=20
> On Fri, Sep 10, 2021 at 06:05:04PM +0200, Jerome Pouiller wrote:
> > From: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> >
> > Function arguments must be aligned with left parenthesis. Apply that
> > rule.
>=20
> To my eyes something still go wrong with this patch. Might be my email
> fault, but every other patch looks ok. Now these are too left.

I don't try anymore to check alignments with my email viewer. The
original patch is as I expect (and I take care to send my patch with
base64 to avoid pitfalls with MS Exchange). So, I think the is correct.

> Also it should alight with first argument not left parenthesis?

Absolutely.


--=20
J=E9r=F4me Pouiller


