Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9AEC2F0D96
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 09:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727739AbhAKIEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 03:04:40 -0500
Received: from mail-eopbgr60051.outbound.protection.outlook.com ([40.107.6.51]:13285
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727721AbhAKIEk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 03:04:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NGsqkHbmXN3ur8z11OZ/7XLzSgrZKKlT6RoneKq9KIb5ZAMJQni8X6BNFTd+k20o4YG76qB9GnG1wOrVQPhslxDv86KtldFTdDE0H1QOENSoAxXTD6dvS4unvacnIzr2xlrTeYhIdcT1N/oiYA7EioakbUebXW7PKdyXT7Rm5iZKwODS02IMzZLq3e/QuLU99IOJhI9UJ5Chrr1Ky8+hbxva69AAmQ3yQRh04SDb+KYHndbkD++ZS2/wKGtt9/q8doo3D62IMr1ItM5hZGgsOe6RVYH585yqO4a55Cy0otv23KLugVdW9PSoRIK2RrSwMJjVx4qotJk3sCWQUscWhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b/dIjOXbB+wAnOS7QHpTk7URQQ1KXUkltaDmasGfjpk=;
 b=dGW2gnpZba1PDS7HzSHtGFTFPerJXL3merpjQNyFEjinouOyJAt029DuQC+8UkO7ylclsQsLSh20JO7F3SL/ZXv/QsuCCBWlyY24wves2l5at0lot5ru4Oz78zyF0a2XRioxBy5I5UGP8f09u/W354bnrLdo+P9n0KknjuRHdbM0qsqpjCSNo30VI/9JIzB7lYdbPgUOWUx4Fb2Ak2WnZYNw/HDrKKKq4sFeWXZL8YlwvRDcfvpX33QA02bFJ9A6+ZWLgpsaGjj57dbGRo32T8w6wjdj8L8fp0VQof9vRcuGu/N1mHMQwyuxjGiXgJttZTUmTL1XmFSqlQGhsoex9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b/dIjOXbB+wAnOS7QHpTk7URQQ1KXUkltaDmasGfjpk=;
 b=OB1s/j/Cf/uzTd7ak2wcuMEJqssN48QFwlGL8zPK7mtzQSpJUOjvrBUokilXDK6Y4nR9j2H2z7N6AidZFhmZMoEX6vnl9Np+9Za/PaZ02PDjf2T0CEv74Rlo5GSp55gmuTKWZB8w+2U+u75Xpixq+jTMHAOWtywZce2J+e3OY8M=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oss.nxp.com;
Received: from VI1PR0401MB2671.eurprd04.prod.outlook.com
 (2603:10a6:800:55::10) by VI1PR0402MB3503.eurprd04.prod.outlook.com
 (2603:10a6:803:d::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.11; Mon, 11 Jan
 2021 08:03:50 +0000
Received: from VI1PR0401MB2671.eurprd04.prod.outlook.com
 ([fe80::dd31:2096:170b:c947]) by VI1PR0401MB2671.eurprd04.prod.outlook.com
 ([fe80::dd31:2096:170b:c947%5]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 08:03:50 +0000
Message-ID: <d4e99e92fe0a926fc351e007bdf9daff18e4165f.camel@oss.nxp.com>
Subject: Re: [PATCH net] dt-bindings: net: dwmac: fix queue priority
 documentation
From:   Sebastien Laveze <sebastien.laveze@oss.nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Date:   Mon, 11 Jan 2021 09:03:46 +0100
In-Reply-To: <20210109191648.25aa6150@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210105154747.1158827-1-sebastien.laveze@oss.nxp.com>
         <20210109191648.25aa6150@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [84.102.252.120]
X-ClientProxiedBy: MRXP264CA0013.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:15::25) To VI1PR0401MB2671.eurprd04.prod.outlook.com
 (2603:10a6:800:55::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from SOPLPUATS06 (84.102.252.120) by MRXP264CA0013.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:15::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.12 via Frontend Transport; Mon, 11 Jan 2021 08:03:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 94b06777-efc7-4e9f-ff8e-08d8b6076e5d
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3503:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB350310A77B9C433D9D528F9DCDAB0@VI1PR0402MB3503.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ft43REA4ayEvxnIZSDRoaoT8NZ0yJUgkeiDRZa8C8tv50pKu9jK2z2WsvqjBmPTZDeWs3Be/qh2H0Tb0W+bA734O4j2whdpQJQHkDEcw3l+dWidZmcb4hAUeNjymqjpS7LzC1U5IOat2GE+S3gFA+dEn0qyNORUf18kFJ3m5jY+y4XBBtnxSqSGx5yqH2OmvrDEt65N1pPodfwCMgjt3KxP3Yhw0JmOpBXCcB0od78URAFXN1PuWRlxTtVfrgUq6Q0luVO+I9eL2QoOrNFbEksta/qT4uMP+30DLTwzmFhqbAUl52oanyPLQLc8zA2mcWIWz3sjb6zDUyP6bo14DXmN8DjmgJ+Kf4A3i41d3iqdMmGz96eiSFvWZekpILBdJ0kfjO4FASL/kIUvYn5emFQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0401MB2671.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(39860400002)(396003)(376002)(52116002)(26005)(186003)(6496006)(16526019)(6916009)(66946007)(6486002)(316002)(558084003)(8936002)(86362001)(4326008)(478600001)(66556008)(66476007)(5660300002)(44832011)(2906002)(54906003)(956004)(2616005)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ckE2enlQL1dsMGVTS0picEdwdWxYODgwTGdhUUpuVWpIUGJpVnQ5RmNyd1NR?=
 =?utf-8?B?RDZiNXM4dnFDU1hIUjJ5MTFsNm9kbXI3WGZxUmwvU2JrcHY2U2hIUHRRelNs?=
 =?utf-8?B?TUF4eENnWFc5SFIrUitVNDNPRllTZmx6TWNqb01wUS9KREM0Nm85NmxmWlJz?=
 =?utf-8?B?ZFo4cG1HS2JGVEJXckJpSmswb0xYWTNGSWwvSENWR1VpcktSNEZicThCMnhN?=
 =?utf-8?B?SUZmOUxXcWN5c3J0a0JoRW9MZkVCNzFGd2VVL2I0ZnRqT2FlS05LU0lWbCtL?=
 =?utf-8?B?c3hndkoyOU9LTEZUcUpQcjRZTGxhRnJFZk9GYTBHdVpBd09LVjJxeHRFSmhV?=
 =?utf-8?B?U2oyL1UzemVrVmJ0YzlQQUdDQUhKQmVCbUtaSDZYMTZoZ1k4VG4wM2RZZWNa?=
 =?utf-8?B?bm41cWlhZmdjTktvVlFYS2o0Y3J4ZW94QlYxY2VNd1A3MkNkQi9yQjV3Rm93?=
 =?utf-8?B?MWg1TXd2SU1aaytZbDNHVWU1Njg5dVZUZkhVUUdRZDNnQVlpUnBvZFpPdkM3?=
 =?utf-8?B?M2loVDJkdDlzWlY2RGtwWXBGalFNcHNlejVucmJiT3lPYm9wSGU2QzBmaWZk?=
 =?utf-8?B?QlVvMVBScExpRHZoQUI3V2tOd3dTNkljY2lySU5xbnNnRC95d01sYnc2RXRM?=
 =?utf-8?B?cUw0NU9Ldm9RQjBkaThTZzJOQURCYXBJc1FxSnh5QkFhcWx2L09mTmhoQTha?=
 =?utf-8?B?ZVNGcGhVK1M3MWRidkxRRkhxdXIxeEtRRzBtTUpzZjcxNmFaL1dYZG1ZR21L?=
 =?utf-8?B?T0RzZWFBQkRCQWJHYkIxQmd6Y2hmWmIwaFVSVFBjK2xUSkl5VEQ1bVR3b0Fz?=
 =?utf-8?B?QjJWL3hCd3dndW5BUnRGYW1NWWdsa2NmM05mdEQzd1lWMlhNK1EyUll6bEky?=
 =?utf-8?B?Ym16VlNaQzFSUFVjazRkQUk5Wk8yQS95blNCLzlVMkVQaFQyaUtYMjlPVWtk?=
 =?utf-8?B?MkdvakNyWEdmY1IwOHJ3SGJReWtrM3hIOEFQck9heEVPZDhGeDdaZEN5d085?=
 =?utf-8?B?VFdRVkk4RkFieUE1cDBJNUhtNEQ1djNLSmJlNVVDSkp1bGJsaDFsVG43Tm53?=
 =?utf-8?B?VmpYK05LS2N5R0FkeFNaR3Rad2h2dkZVNWZYaXExRE9iVDh5N3RzQlh2aW51?=
 =?utf-8?B?QWV3dk1rd0IveEN0UnpKZkYzUXJleGIzWTU0NFIrSm1HS295THdkT1FWWkYr?=
 =?utf-8?B?em5wVEFvSTZrSVprZjBqdDFpMlhiQWdWaE02aXJLZW04QWpQOWVFcnF2Z0Fp?=
 =?utf-8?B?b0xwZWxwNGt6MTFwajdqa2g3L09sNkhockhreThManU0N1pzdnNsRjhDSXYv?=
 =?utf-8?Q?RuDzvz4Ero4x49maLTPQeyScMrmPeB0ujd?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0401MB2671.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2021 08:03:50.4406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 94b06777-efc7-4e9f-ff8e-08d8b6076e5d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sZoeSHAoxCXoxkyGd3bXDN5ryaxXnUYti5ePzS6h7huYj2TTjRcq1z50bvJf/QUlwW5t5ulwZVYTMOBvS/OaLkh4xYD254ppATl23jNsCsA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3503
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2021-01-09 at 19:16 -0800, Jakub Kicinski wrote:
> Hi Sebastien, looks like this no longer applies to net could you
> rebase?
Hi Jakub,
Sure, no problem.

