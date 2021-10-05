Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47A89422DC0
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 18:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236552AbhJEQUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 12:20:51 -0400
Received: from mail-eopbgr60062.outbound.protection.outlook.com ([40.107.6.62]:13966
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235876AbhJEQUs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 12:20:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kUmQLGpSwAqljMOxi6JiN12IzBOFtUHHMz8poLcHDH2vNimcS2VhmDZHfBOK6+Kl2Ag9QupSBQQ6qSc2UJqUFh/zWvqWEFv7pDv7bdHPkvKMk8FmIn8j9Ahd6UPNhqUePFPabfSADvyEcIZG0HDmgaHl7xY8Sj6MI2Um8/PDUL+nXab1+G4yM5HwuMTzVGjzh0Mv8W3Bjt9CqkbN2KJw4Z2nrPpIJPAACly4qUzCinu4VO/Lz1CMrw5c4DIJ5Mf/M/3mAlL4XSpA5HxrkC0uUs5e+QFUc1WwaBxh5oXugH5X114wpfH3wzMjc1IVq1QcQfhEJsRi85p8wHIcac4xyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MRwDSHzRo7ndWl4MRAIQLLixzdtin/au8zo2AcURjHw=;
 b=E8948AjrpXPXradoqnXT/D01JhNABKW9p79zRjHJHRPYrueqogPdNpwSmMh5XmtYmumd1kQYTVhuSAJ2ChwFcMKJm+2uZV3Ii/vYq47Im24rtQJuJPzISsDuzbeaFd5k45l0bMJ2O2aSnB2/eX78PDerdc5Yp85bqNmuMGZTU0g2yW6YfJ3bJ7CQboYI6YL0IXEEKnqjBHCO2oaH/l6nkiVM4HhYypPczDbcP1DA0bKukHsPHtrTmixej5+HHlz2E5KQh04ruLVjPUhpAIkx7k7eUnpPrdvln+aBacU/gEzC/jx0DPvn0aJGSHQuNbS1ADKUncJ77G4eObUsLilWpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MRwDSHzRo7ndWl4MRAIQLLixzdtin/au8zo2AcURjHw=;
 b=yArfUinmfV7aChsGou1d+kcrsvUS4r/FU8trEhtrk3BiyYmpugwFdguqewrIWMgALAXoEhj1JJO5rDl22Hfz7TIHFd/jeFRaZ5xTv2Vog5Y9YfuWotKsgZ2DqTzTE89HGUiliHg8BDXwzhD3T1MO3glAob47H14jUzyz70Isdgs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB7PR03MB3659.eurprd03.prod.outlook.com (2603:10a6:5:4::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4566.13; Tue, 5 Oct 2021 16:18:56 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 16:18:55 +0000
Subject: Re: [RFC net-next PATCH 01/16] dt-bindings: net: Add pcs property
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org
References: <20211004191527.1610759-1-sean.anderson@seco.com>
 <20211004191527.1610759-2-sean.anderson@seco.com>
 <YVwdWIJiV1nkJ4A3@shell.armlinux.org.uk>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <f4a3b38e-db3c-0cca-96ff-1d11e95f4b84@seco.com>
Date:   Tue, 5 Oct 2021 12:18:51 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YVwdWIJiV1nkJ4A3@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0009.namprd13.prod.outlook.com
 (2603:10b6:208:256::14) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from [172.27.1.65] (50.195.82.171) by BL1PR13CA0009.namprd13.prod.outlook.com (2603:10b6:208:256::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.7 via Frontend Transport; Tue, 5 Oct 2021 16:18:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0ba6e36e-1e67-4cfd-7aaa-08d9881bd413
X-MS-TrafficTypeDiagnostic: DB7PR03MB3659:
X-Microsoft-Antispam-PRVS: <DB7PR03MB365964CE41D27BB4255A59F596AF9@DB7PR03MB3659.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KS8m7eeDyBNkY2BeHQsa/Zdv9Gtr5CGdZAuubW9y5Yga5bbVrmTdydI8JJ77oZVl2bwN8moOAOPZdfwv/ZhvcfnfzcV4X1azxVpcw/0ATTF2P8VmNGDUNdlBgT6eeYFxK8WB5p+lEk1/hv++ndr+iMtIs2K/DO0Rc2Maq5dyqU8fgEWfUOHb+JawFKzbnZUs5CMayvyu0LS0byeRiivsxTGEaxN5v9LilY7RG5sTGZPca5tB6/njeSubPSEqkkf47wzYx/XVoyg9uPTZiWkoWOwdF/w2RW05DgLBT/Rz5CJoJ6kuRZRBUtdw78G1TU6Nw/3lcH+71CB3117O1J370utLtFcp8Pn0CQjIaWoelQ4uV7EAgGwoOVrXupYT6lSX1EaNp5bKaKcCoiO0vX60i9QzEgJionopjxKbfiJDsVq1ehVCzxGOWrcG6mGWbVM97/lNe2XKLwq0nBvGZ2JYLkycMuUVZnKkku8gSMupcgul7ojOOtKFEbpy5zH5lqPx8qjUoJiuB8q0e8xUkhpvH8hbAxzk1HcPZ+MGQuhWfpX7E5y6aQxWA4jS/wS7Omdy0sHeNfItUY+FHA1CGahDQFj6knpK1p/r/eS6aOPtoCymge74uK+w9BBNfES8UgR7foXLcaSUz6Qr5HHD0KuNDPqGzFsGfjPaNPzbsGK70//w6hRnFFbgWb7Egct31W2R1bhYNJ69zNqgEwujDs+qoPcEBMVuwvkKqAWUhhDdmPD6eg501MLo8zUlNEGajzXUCP/Ejm7pp8YxeX4btnVdwQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6486002)(956004)(44832011)(6916009)(2616005)(4326008)(26005)(31696002)(53546011)(36756003)(186003)(2906002)(66946007)(6666004)(508600001)(86362001)(52116002)(5660300002)(54906003)(8936002)(8676002)(38100700002)(4744005)(31686004)(16576012)(316002)(38350700002)(66476007)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K000ajZYTXl2cG8zVFNLYjRtY2VaemlCNjJHSTZ0Mm9FdEpaeXJEYlpyRzhw?=
 =?utf-8?B?ajBHWDZReTRPMDJQNCtlUGpLSUtManlIVnZ5bW5qWVNUM3ViR2dsMXBYSWo0?=
 =?utf-8?B?RVdHb3c5VFZGRzg2dWU5bnQ4RzZ3WHJQUjMvV3BxK2ZmVXg0Qk83WmRkTU9C?=
 =?utf-8?B?S1NnODRWME81VEJlQ2xCZWZLS2JjeGMwUitETjBaOHYrNGQwU1BBYmZDaWdw?=
 =?utf-8?B?QUV4NmxMajExbnVNNWJHUC85eUtLRFRnZllmZFRKRFFidkFOOXAvQlhzd3Yv?=
 =?utf-8?B?UE9GUnBKWHhzbTdiaEd0T0U0UkNQQmpnV0p5TWsxWnpyUlFzdUJjbEpOVzZD?=
 =?utf-8?B?ZjU2Mjg4OGg3cVNPbzFWQ3h2SUVHYlB6UGdOSnJZOXI0cjNWOG1TY1ZPNEZj?=
 =?utf-8?B?Z0piQ1dzcXBhNlZDMktON21lMlZicmtpV3dnQ3hkS3N3TXV4bHJ1ZHFCSDZB?=
 =?utf-8?B?dUorM1BTR0FDNW5MYWRndmlLZ1NnSU83K3NyZ3dHeWlmczFDdU5GQzZ4ZVk5?=
 =?utf-8?B?OU1BZkZOZFR1L2UzVk5ZODhkRTY1bTR3Vi9TbGx3RS9VMDlBS3pZL0x3S1hN?=
 =?utf-8?B?SVhwQy9MZlpTOWNGbW5qeVoxaXhvRmlUenZ4REZYclJGMmkvdDFWTGdHTFhM?=
 =?utf-8?B?eTJQUWxJSy9ramJNbzI1UU5SckpIUnM4UGkwWHNXbHNRZFlFN3laRWpFRWlM?=
 =?utf-8?B?eVNram1VMkhBY2dGZmtvL3NhQ0dqU2F0UTVWSWIzL1FwekNhdzU3V1NkcW5P?=
 =?utf-8?B?SjcyUkhaanM3ODc5Y0Rqb2VhQmdzK2cwZEsxM1Y0WXZBY24wbC9NTngxQ3ZN?=
 =?utf-8?B?cXgwYWlCTXh2aDlCTWdnOWpubGQwVElxYmhuNjVRZEgxd1pQclJlVmpaOXh4?=
 =?utf-8?B?N0RselA3ZEtsYSt3YWhESGtQUnU4SHdTeTZsMEZyYjFWaVY0U2tnblpmSEo0?=
 =?utf-8?B?SnVnYW1SbUk4bWIyQ1U1UVhrb3NZUDhFaWNaYWJ1bjh1QzRBRUpDak9XaWxG?=
 =?utf-8?B?NVJVUmZzTDAwRnhCZnVjQ0syK3hvamRrbFByRWxFYWl6UWo2UUhsRGlvZVBt?=
 =?utf-8?B?dUM3Ly9CZDNlS0JoN0dONWt6anRvTjViWUc3SEE5OWhnVk0ybHlvWDZQcEpS?=
 =?utf-8?B?S0N2N0lxZ1Rna2w5NzVrQ3ZMZC9odnExbUppZFZ3NDYxcE1pVDhKL1k4TlpP?=
 =?utf-8?B?WmtrdTdndzVkZ082Y09qUG0wY3VqQ3dnS3hUWmhOY1A4dkJnNWJDZWN0TnQ0?=
 =?utf-8?B?VVpiQzcrM3pIQVo4SU04eHhDUXFGUytNZEIxLzdSL0ZuckI5Z3lZRXI3cHpC?=
 =?utf-8?B?eWcxRVVJMXROcEJZRDhVNlV0WGNRUTZJS2Fqa3NzTHhEU3M3WmRxRTJ1MmE2?=
 =?utf-8?B?aUNRaHY4VmQ1Q3BxM1Z4WUU2dEhnMlNhZzlGd3Z1YkYxbjNoakU4aW02c25U?=
 =?utf-8?B?aHh0MWpPSTBoWDREUWt3STN3THN4U0R6N2RCaGdNaVNWUzk3MnJIcmZUaTJI?=
 =?utf-8?B?a0h0elk5dUhDM0RWV1owT1VwcHpVQytWUVdyS3hoeUZYaG5pTVIyMjhCb0pW?=
 =?utf-8?B?Ty84RGJsMTFmLzNnZHUvTERkUmRBcVI1VkZHdUxaVG83WCs4VkpvRnl2eWtu?=
 =?utf-8?B?V1hnakpJSngxK2xieGZpZlAvM21pOFdTYjhmL2wzdmdqVE9EWllEUDNlT3Js?=
 =?utf-8?B?UUpTWWwrZytiM1hRMHNyd01uZjgyNitISnRuSmhSNFcvdzNLVnpFeVQyV3RB?=
 =?utf-8?Q?JqF0u2Cut3xlGh1KjySph0fgdMczvAyO8lKFink?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ba6e36e-1e67-4cfd-7aaa-08d9881bd413
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 16:18:55.7952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /hv36u9sJqQ8tka4NPoQHox7K2S0Gp46gvpfmmJNmNUyrBYMU5Y9OTXt4ADot0QjI9Rxgy1S9xe4PrGdNZOEAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB3659
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/5/21 5:39 AM, Russell King (Oracle) wrote:
> On Mon, Oct 04, 2021 at 03:15:12PM -0400, Sean Anderson wrote:
>> Add a property for associating PCS devices with ethernet controllers.
>> Because PCS has no generic analogue like PHY, I have left off the
>> -handle suffix.
> 
> For PHYs, we used to have phy and phy-device as property names, but the
> modern name is "phy-handle". I think we should do the same here, so I
> would suggest using "pcs-handle".
> 
> We actually already have LX2160A platforms using "pcs-handle", (see
> Documentation/devicetree/bindings/net/fsl,qoriq-mc-dpmac.yaml) so we're
> in danger of ending up with multiple property names describing the same
> thing.
> 

Either way is fine by me.

--Sean
