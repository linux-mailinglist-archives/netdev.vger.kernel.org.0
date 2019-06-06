Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91F9A36D37
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 09:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726223AbfFFHTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 03:19:53 -0400
Received: from mail-eopbgr10071.outbound.protection.outlook.com ([40.107.1.71]:12697
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725782AbfFFHTx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 03:19:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vUQlciXIc1afvb4bVmPh3YSRcdmSVin80H3Yq0I0jIo=;
 b=FN4Gl67mz36adugk2y3zkEt6J4by4Ye+XGSdQ/XDT3ktplbrG3mswZHCfDS5CWFUh1DqGjjd1xreHx85txNc3HMxg67acXTSVDOBEw9z4q5amsReP0Ut2hzgYyOzl++uUQlH0lol282UFdg4KoPOaSHdCW5jNaHU9lnZ7l3UZHE=
Received: from HE1PR05CA0284.eurprd05.prod.outlook.com (2603:10a6:7:93::15) by
 DB6PR0502MB3015.eurprd05.prod.outlook.com (2603:10a6:4:99::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Thu, 6 Jun 2019 07:19:45 +0000
Received: from DB5EUR03FT060.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e0a::205) by HE1PR05CA0284.outlook.office365.com
 (2603:10a6:7:93::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1965.12 via Frontend
 Transport; Thu, 6 Jun 2019 07:19:45 +0000
Authentication-Results: spf=pass (sender IP is 193.47.165.134)
 smtp.mailfrom=mellanox.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none
 header.from=mellanox.com;
Received-SPF: Pass (protection.outlook.com: domain of mellanox.com designates
 193.47.165.134 as permitted sender) receiver=protection.outlook.com;
 client-ip=193.47.165.134; helo=mtlcas13.mtl.com;
Received: from mtlcas13.mtl.com (193.47.165.134) by
 DB5EUR03FT060.mail.protection.outlook.com (10.152.21.231) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1965.12 via Frontend Transport; Thu, 6 Jun 2019 07:19:45 +0000
Received: from MTLCAS13.mtl.com (10.0.8.78) by mtlcas13.mtl.com (10.0.8.78)
 with Microsoft SMTP Server (TLS) id 15.0.1178.4; Thu, 6 Jun 2019 10:19:44
 +0300
Received: from MTLCAS01.mtl.com (10.0.8.71) by MTLCAS13.mtl.com (10.0.8.78)
 with Microsoft SMTP Server (TLS) id 15.0.1178.4 via Frontend Transport; Thu,
 6 Jun 2019 10:19:44 +0300
Received: from [172.16.0.41] (172.16.0.41) by MTLCAS01.mtl.com (10.0.8.71)
 with Microsoft SMTP Server (TLS) id 14.3.301.0; Thu, 6 Jun 2019 10:19:42
 +0300
Subject: Re: [pull request][for-next 0/9] Generic DIM lib for netdev and RDMA
To:     Leon Romanovsky <leon@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Tal Gilboa <talgi@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20190605232348.6452-1-saeedm@mellanox.com>
 <20190606071427.GU5261@mtr-leonro.mtl.com>
From:   Max Gurtovoy <maxg@mellanox.com>
Message-ID: <898e0df0-b73c-c6d7-9cbe-084163643236@mellanox.com>
Date:   Thu, 6 Jun 2019 10:19:41 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190606071427.GU5261@mtr-leonro.mtl.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.16.0.41]
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:193.47.165.134;IPV:NLI;CTRY:IL;EFV:NLI;SFV:NSPM;SFS:(10009020)(376002)(346002)(39860400002)(396003)(136003)(2980300002)(199004)(189003)(110136005)(54906003)(305945005)(65826007)(106002)(7736002)(486006)(76176011)(6636002)(8676002)(81156014)(81166006)(65956001)(47776003)(316002)(65806001)(356004)(11346002)(58126008)(126002)(2616005)(14444005)(67846002)(77096007)(4326008)(3846002)(31686004)(6116002)(478600001)(64126003)(53546011)(230700001)(86362001)(23676004)(229853002)(16576012)(70586007)(476003)(2486003)(336012)(446003)(70206006)(5660300002)(2906002)(8936002)(36756003)(186003)(50466002)(31696002)(26005)(6246003)(16526019)(41533002)(3940600001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0502MB3015;H:mtlcas13.mtl.com;FPR:;SPF:Pass;LANG:en;PTR:mail13.mellanox.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5357bdf3-ff37-42a7-80ea-08d6ea4f5a16
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328)(7193020);SRVR:DB6PR0502MB3015;
X-MS-TrafficTypeDiagnostic: DB6PR0502MB3015:
X-Microsoft-Antispam-PRVS: <DB6PR0502MB30150BBD3CBDB139B4B2207FB6170@DB6PR0502MB3015.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 00603B7EEF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: ZqkEjMz8oXVNtMRmYOzhSibFNFy/xncy31aSCKLO0+iaoXEtgnP68oJhd09U1XilVWTamFBUpiJjUpPfHeeCAxHNQPlbFiRNyM+Obn80LR4GhvB6A4bDLPN6/OCq52E+Fiz/PnS3h3QWJVmpAVWieMn2QUgVZAO32lN31MzUy1xXmAWCSIuwoDBuD73NSfV5J3Qn39un6u1aWWZ7IcQntmLTrFKuC0xxXOZC7MrDMsOFV92K/N2GY+C2J3IgMX18U/4rQGeQkf8DRN1ghX4Gfc4AiAABjfa4VJFb0JVMPDW8ijyv3GGoYFHwPXptC7UEsE46ibdOq4Fs4Ml7bgikHSVlqQYo36U98iKtFSZCPfdHXwVfLQ08004wMX3i71tgrRdNxI/n8cXiuxNg3csNHCsY6b3EWy1e2oWcgMl+6hs=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2019 07:19:45.2112
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5357bdf3-ff37-42a7-80ea-08d6ea4f5a16
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=a652971c-7d2e-4d9b-a6a4-d149256f461b;Ip=[193.47.165.134];Helo=[mtlcas13.mtl.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0502MB3015
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 6/6/2019 10:14 AM, Leon Romanovsky wrote:
> On Wed, Jun 05, 2019 at 11:24:31PM +0000, Saeed Mahameed wrote:
>> Hi Dave, Doug & Jason
>>
>> This series improves DIM - Dynamically-tuned Interrupt
>> Moderation- to be generic for netdev and RDMA use-cases.
>>
>>  From Tal and Yamin:
>> The first 7 patches provide the necessary refactoring to current net_dim
>> library which affect some net drivers who are using the API.
>>
>> The last 2 patches provide the RDMA implementation for DIM.
>>
>> For more information please see tag log below.
>>
>> Once we are all happy with the series, please pull to net-next and
>> rdma-next trees.
>>
>> Thanks,
>> Saeed.
>>
>> ---
>> The following changes since commit cd6c84d8f0cdc911df435bb075ba22ce3c605b07:
>>
>>    Linux 5.2-rc2 (2019-05-26 16:49:19 -0700)
>>
>> are available in the Git repository at:
>>
>>    git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/dim-updates-2019-06-05
>>
>> for you to fetch changes up to 1ec9974e75e7a58bff1ab17c4fcda17b180ed3bb:
>>
>>    RDMA/core: Provide RDMA DIM support for ULPs (2019-06-05 16:09:02 -0700)
>>
>> ----------------------------------------------------------------
>> dim-updates-2019-06-05
>>
>> From: Tal Gilboa
>>
>> Implement net DIM over a generic DIM library
>>
>> net_dim.h lib exposes an implementation of the DIM algorithm for
>> dynamically-tuned interrupt moderation for networking interfaces.
>>
>> We want a similar functionality for other protocols, which might need to
>> optimize interrupts differently. Main motivation here is DIM for NVMf
>> storage protocol.
>>
>> Current DIM implementation prioritizes reducing interrupt overhead over
>> latency. Also, in order to reduce DIM's own overhead, the algorithm might
>> take some time to identify it needs to change profiles. While this is
>> acceptable for networking, it might not work well on other scenarios.
>>
>> Here I propose a new structure to DIM. The idea is to allow a slightly
>> modified functionality without the risk of breaking Net DIM behavior for
>> netdev. I verified there are no degradations in current DIM behavior with
>> the modified solution.
>>
>> Solution:
>> - Common logic is declared in include/linux/dim.h and implemented in
>>    lib/dim/dim.c
>> - Net DIM (existing) logic is declared in include/linux/net_dim.h and
>>    implemented in lib/dim/net_dim.c, which uses the common logic from dim.h
>> - Any new DIM logic will be declared in "/include/linux/new_dim.h" and
>>     implemented in "lib/dim/new_dim.c".
>> - This new implementation will expose modified versions of profiles,
>>    dim_step() and dim_decision().
>>
>> Pros for this solution are:
>> - Zero impact on existing net_dim implementation and usage
>> - Relatively more code reuse (compared to two separate solutions)
>> - Increased extensibility
>>
>> ----------------------------------------------------------------
>> Tal Gilboa (6):
>>        linux/dim: Move logic to dim.h
>>        linux/dim: Remove "net" prefix from internal DIM members
>>        linux/dim: Rename externally exposed macros
>>        linux/dim: Rename net_dim_sample() to net_dim_update_sample()
>>        linux/dim: Rename externally used net_dim members
>>        linux/dim: Move implementation to .c files
>>
>> Yamin Friedman (3):
>>        linux/dim: Add completions count to dim_sample
>>        linux/dim: Implement rdma_dim
>>        RDMA/core: Provide RDMA DIM support for ULPs
> Saeed,
>
> No, for the RDMA patches.
> We need to see usage of those APIs before merging.

I've asked Yamin to prepare patches for NVMeoF initiator and target for 
review, so I guess he has it on his plate (this is how he tested it..).

It might cause conflict with NVMe/blk branch maintained by Sagi, 
Christoph and Jens.

So we need a plan here.


>
> Thanks
