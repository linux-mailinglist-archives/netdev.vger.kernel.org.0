Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DADDB48D74C
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 13:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234414AbiAMMQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 07:16:16 -0500
Received: from mail-bn8nam11on2049.outbound.protection.outlook.com ([40.107.236.49]:22848
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230310AbiAMMQP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 07:16:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dVvYnRLAyc/3ut2lhYaapr1yqQV7WiuaSG2OTxEOHWGSrq9SINuDb/yr0B9cgAKBh4Ryl21inWxEDLQa8E782PHR9V9d47Uowc6e5k2Try5z5ytlxTx5Txj5T/1JXl3u8wNR6nFBUNMFQmgbaEWUt/iysUeKObPtoIXmbcMPCUnKD/VKIJwACmzdvG7R2sYfr/vLwiWlf71oWS6EFXUKcZIHdfiZKTTR3ABPACuZB9UF9khGWgFCnu/dO58Ir2+1j4BlcW6Imm6ELdPBdTkEB/4MMvlTIKSiDBJ9GxYhxR5zHGgaInU1LcZiChfo7AS47KWYve9RiaMSki7yIQ/I6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JFCfdEyoCkhanvQpcH9mHXafF46Os5R1ZjAHOXGMGoU=;
 b=jWRs7Un6gPg9cx6c4Yv8hzZ+AJ+prPP4YTdT4/pNFLNlefGvuhQKnr3HWLneaOs76pk9G9WHDhSHlCYMPIKmSEhJXPSb0uGh7bhwCvEcY46s35U1keJfbR78COgf1cD3f5//3Z+vtj+TBhcZqyxHHI1VMMBtpsyD8bPjMSqSr4DtjYY6/k8AweBwp+PkiXQ4jT5jLCPUS/6u0W5fsHJqBRRI4tvVHRBAZ+0L+mTZ7eis9vMvMOstuBisXHkCBfLIUCJA/8hyKafmCJP/9mV5JLqPU/YUR5hUFNlegx5f/auu5tijQYMRPuwGJkpU3fkgjTpYTtSdLd6lhF119n8+fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JFCfdEyoCkhanvQpcH9mHXafF46Os5R1ZjAHOXGMGoU=;
 b=CAn6ilUHAFF0cfuU7NzQV8agfGuJg5ugfxs/RXz057Eb3VzNYwiw2I/zOsEegQLef/1zdiKtaQvbXn2iw8LZqRvzbkdRjCp5el/olyVTcqESQX1QzmMUAFR3Nthae1MmOME5hoV+NyoqMyBsirba6qZ4FzRCZeU6a7CNwQEJigc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by MN2PR11MB4664.namprd11.prod.outlook.com (2603:10b6:208:26e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Thu, 13 Jan
 2022 12:16:13 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4%5]) with mapi id 15.20.4888.011; Thu, 13 Jan 2022
 12:16:13 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 02/31] staging: wfx: fix HIF API license
Date:   Thu, 13 Jan 2022 13:16:07 +0100
Message-ID: <2049544.RTtvoyPrBD@pc-42>
Organization: Silicon Labs
In-Reply-To: <877db3ua68.fsf@kernel.org>
References: <20220113085524.1110708-1-Jerome.Pouiller@silabs.com> <20220113085524.1110708-3-Jerome.Pouiller@silabs.com> <877db3ua68.fsf@kernel.org>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-ClientProxiedBy: SN6PR16CA0047.namprd16.prod.outlook.com
 (2603:10b6:805:ca::24) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e6e690f-b695-409e-4e4c-08d9d68e7d87
X-MS-TrafficTypeDiagnostic: MN2PR11MB4664:EE_
X-Microsoft-Antispam-PRVS: <MN2PR11MB46649EE03AD92884E7F60DA093539@MN2PR11MB4664.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y7BA7L6T+MGlwhTwn5kU0j2gAVdgH8YcKPV6wROFPIbAERjwRqWt1cZx4y8SvjxvPbKi7CmZunoMXxdkmezdIH6/RaUmbxSQWC6oizN31Y5GpRT7s+Ds1XLGKRkulOG7X/Zl/eJNhR9/m95LWt76SPJ2P3E372VIDhh9ghKER9R3gWqlChC6N+293ytZhqmC+YvMG4KiNKba9yS6mv79UQrD9GmiQfaAey5AOENFyGs+WDVFMAR89hQQd20d1t3MQK1nkXqyoOFFJDDM1wNJCZGjIfdjnF88FsjoQ+LxMTkP+VQnn2s/Fm5w2xghWzRRgGbAIFV0okozhd5T9ZhVkdEGM7jRL6nVz+3Wk134rAAOFVqqkWTKjy/gf7lh8LrlFAVtj77/TIBL16SmuOu5msY/dktYwjpnXGjrYkbMZg6RjOBS60LUjPebiwqGrVCbSd9v50xkX8bexRpL8peRTdulPcG4I2zXKY0CRe/2Wfu9aE3AHLviHEqvMOfePQ2igmZwiTI6TfOIgbRkJyp5JYVsc61reqYaP/ecq01GBg8EqDVrh5DcWvs+MMGwUCLilzAijsjGiL6NoFIqJCC1fBfYdbIkvSODUBTjag3J4WiZV76TmVrF30av5X08qVxq6wFlssWXG036wYWyigXJtQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(54906003)(6512007)(38100700002)(5660300002)(36916002)(83380400001)(8676002)(9686003)(33716001)(508600001)(186003)(52116002)(6666004)(6916009)(6506007)(66946007)(316002)(86362001)(8936002)(2906002)(4326008)(6486002)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?rKoJGfoGn9B9AJnqAj3VNiD3MOO/CibFRE80v8Dh3+/q7V+Wu6SAoMJELm?=
 =?iso-8859-1?Q?JBioyZn7J5pkeaEYZ+8BPfJfbMUJ55HLhdElyNWq1Z/BtBlBtbRUz+rjOu?=
 =?iso-8859-1?Q?q5H3UvJQiRlbvqkv01wqcogEi21L1fc1Uz72j7/WJXwEbfciZJFRWC60QN?=
 =?iso-8859-1?Q?H4UTFRRKrMsKg81hlYrs9bg2Zwa3WeFB2oP+Q2i/E02aqMl60zcw8x4H5w?=
 =?iso-8859-1?Q?BQzaOHYZIQU1PA96kcSFCXuQ1ELOUcPo3Gwl2LNqU5ycZGA3muWSniXhbI?=
 =?iso-8859-1?Q?g64ag7rT2BCEj2e2A/BFyXk6nBiyqN44GAfcTlwSmq2wWJ63VLK2107c2m?=
 =?iso-8859-1?Q?wwf2/SRVV9EA1s5/7MxcUqnUBrAyX4PFoQEyfOWUbR4FB1fhu01iwarNqI?=
 =?iso-8859-1?Q?o3iHyIR08Y36lb/NG30wgLnwvVYw/eGWp9V2HEJVCosG9UbL6VDs5aRV3J?=
 =?iso-8859-1?Q?c73O1OdZ5PeaAhJW0SpBGV2BfuwsIHnviIhs5tqbK40vKBDpaB2e27Nfbs?=
 =?iso-8859-1?Q?FUNQ9Kx7oqPE2mQfYUyPB2njHGISlwISMnT+Es81oOsuVoZeyygPgmV9vo?=
 =?iso-8859-1?Q?Yh5fimsolredOyHk0KmhRPGlBfkMLX77HIbqTKU/ku/Yc1VJb4FR4+cgj5?=
 =?iso-8859-1?Q?/MJMIU10+R2YHZXzbXA1OXFb8BXcxEY0NuZsRSdBe/NGVnSpS3G/BeYoTl?=
 =?iso-8859-1?Q?0VScYNzTNE9ssShPGOJ6zVfFJtTOLWUQPJWG8FUfkZMHdwv3Cimmv7NQG5?=
 =?iso-8859-1?Q?o7+LX6AmLomZGkQt65sOd4R9cCfeGHeKQBAXqOXt2AJH52JpnGOvUvHd9E?=
 =?iso-8859-1?Q?mMbypu3JNTz/W9cIZYtYfHM9ggXQIIgeEi2TM75DSmwHoSvPbyF+xwbAHL?=
 =?iso-8859-1?Q?p/1V85C2mMJNIPftOTdZp3w7ec4KslAV5J1TfYAWvoAkpapAekNPZeSEH7?=
 =?iso-8859-1?Q?bIrqx9gXX1JUUNcpJ2wgJgxizv08fX+97U/MhUmU382gNcfVI+ZQoHXhG7?=
 =?iso-8859-1?Q?4RfUuo3uzYGKKconxOIY6kP4Rfl7vwxiGqQnDClwBuy6FIvlfX24MW/ZGJ?=
 =?iso-8859-1?Q?C+zVEgRVAnFa64BUr8bX9CAelX2Ub3pzt8pI03n6jBjd2JRm6eNUKUBhKd?=
 =?iso-8859-1?Q?SyaCUJeC1qRMk5FxWNY6dUG2/5+/2faKWTkWhCoTJ6mkEzce6hyHPBYJYQ?=
 =?iso-8859-1?Q?2JKoWjZELlhTFPILTfll46S5M/ihbRJrIt6u5cZXRauk0MVN/dMmtjMJT4?=
 =?iso-8859-1?Q?b+c8uM8xBZuo4/wxEIdHo9GmmWPsCdl1jyT22sIt/9dUQjU75slwml9JrW?=
 =?iso-8859-1?Q?lbuaI2k0lSheBYqTxEH4tuAezEtkocTn/oRkRYm5hLzaetoz02fg3tVMM8?=
 =?iso-8859-1?Q?NiC4xzdPkqmFriST+eNzBdqdtyQG+b+ctB72rG9lCREWpjEyu63Q6+9K8a?=
 =?iso-8859-1?Q?tds2ofjAxXcjHadIWqT6Isigf0Fd42Hgj0WOkGDDC0SXsx1VStAEPy2X/Q?=
 =?iso-8859-1?Q?0w5EMHCxCkktHlPChxugLq7yiQOw2uF+4xlokcIcXPT2qHBGuoAEdr19Qz?=
 =?iso-8859-1?Q?MI22DjX8q6h8KwqsB5GoRglTb2l+Me7NNZRgL+B0v5JG1yKFb2HS5GSj+v?=
 =?iso-8859-1?Q?siSbEJ4GEVnFBvdSbRmzYGgNk/dh9aMij/BpPR049jVvI95Sxrv/HQtaVP?=
 =?iso-8859-1?Q?/03Oee1iz4vhtdKGkP4BntWYAlDPBn/C1G88QFe+shEaWHe6ixmtFUdgH0?=
 =?iso-8859-1?Q?3T7MQWShX1pSwdB5PD14HHxp8=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e6e690f-b695-409e-4e4c-08d9d68e7d87
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2022 12:16:13.2167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nFYFHuXD56feoWsr3/mazwT2c3eDOtI67vdI33x/5cbqoaTxlAoal/+AtpYORB5lsjdWXKmBQlQrzFvawVSdOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4664
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday 13 January 2022 12:50:23 CET Kalle Valo wrote:
> Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:
>=20
> > From: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> >
> > Apache-2.0 is not allowed in the kernel.
> >
> > Signed-off-by: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> > ---
> >  drivers/staging/wfx/hif_api_cmd.h     | 2 +-
> >  drivers/staging/wfx/hif_api_general.h | 2 +-
> >  drivers/staging/wfx/hif_api_mib.h     | 2 +-
> >  3 files changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/staging/wfx/hif_api_cmd.h b/drivers/staging/wfx/hi=
f_api_cmd.h
> > index b0aa13b23a51..b1829d01a5d9 100644
> > --- a/drivers/staging/wfx/hif_api_cmd.h
> > +++ b/drivers/staging/wfx/hif_api_cmd.h
> > @@ -1,4 +1,4 @@
> > -/* SPDX-License-Identifier: Apache-2.0 */
> > +/* SPDX-License-Identifier: GPL-2.0-only or Apache-2.0 */
>=20
> Is the Apache-2.0 license really mandatory? LICENSES/dual/Apache-2.0 is
> not really supportive.

[usual "I am not a lawyer" preamble]

hmm... I don't think it is really mandatory. However, I would more
confident if we could keep the original license also (I think the idea
behind is to not prevent someone to reuse this header in any other
project).


--=20
J=E9r=F4me Pouiller


