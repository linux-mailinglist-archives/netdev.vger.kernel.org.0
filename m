Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C88D40D3CA
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 09:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234809AbhIPHbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 03:31:03 -0400
Received: from mail-dm3nam07on2119.outbound.protection.outlook.com ([40.107.95.119]:34811
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232254AbhIPHbA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 03:31:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RjUJEzP/1cOhbg+6IU3RJmy0oPafK7pJJiV5f5q0akB6fV+ZyB7lyxTBqcXj9WvilnKdivAPdw6ajBzuS6HKLBbVUJFWMrZBNEcjKTuAyhRW0fU7UjhY/pzdpJXXVONyzl5HIYuIgD0WCibsxjg+vXyonC+F/48EkFDf7HhUqg5IuY5xLJm5mWEFBhPcnh+bNEepJ6xsNcvkpP91nV79EYKq5Qin3UIGkDJuIl13BBYS6Z0kVJR8DMlxp9xOTZ9ALdqpWOtWNvSCqftD10tEMrKKkQs6j9SKdRHK3N+OOoguYAb8hXDdbOpuTG7jY1We/fHCyBXV8u8OpVehsXxA/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=rTjJNr1kh3rDTyc0MjML28LSHn0Ot1cDIL4AsPAYdmM=;
 b=Avcl1OXiJqtuleU/ETXQ7OqXMjF0F7DyDVkmvqiIZ2sSec+W2s5f5pDwnQMxvgFKf/snPIF91y05mc2isf7hZ77Mgqm3OOS2DdDwpEwxE2D+1GaEtK36Fmxeje7mNL6wm+eCJlyA8irrixBxn1DxX/ForA5FRFLztYr9u0jSgFzp7aPSKkH8GqFEMbuZhdKllH3P2OMJNrPdy8tYSn/BIY1WyYt/xiwnluTPCiwKEXSBtiQFidTdWh51nKU/SfpYpc8oja3qF+rU7H8D4c70ENBSBSSm6ViW4Ldy/wzNqt2SX231QOvvRDR027li+5dpnGV4EEaxdWOTdIrBYMnu/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rTjJNr1kh3rDTyc0MjML28LSHn0Ot1cDIL4AsPAYdmM=;
 b=cAeq0VZqXCncHXkAed2+wpt4hM1owlQN8ipteaaNt8a6iW7E9VnDVZ7QQoR8aiNg9+rvbwhydl7lHs3xPOgs0JaPAE1c1r3JFR4wxHzZL82BtrnJPcM+M3TWJSiEaFcTGqHABktA+HkwuryqJyVCdai2E/VgUbdRw8Vqwqh50R4=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5380.namprd13.prod.outlook.com (2603:10b6:510:fe::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.5; Thu, 16 Sep
 2021 07:29:38 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90%7]) with mapi id 15.20.4523.014; Thu, 16 Sep 2021
 07:29:37 +0000
Date:   Thu, 16 Sep 2021 09:29:30 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, kuba@kernel.org,
        andrii@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH bpf-next] bpf: Document BPF licensing.
Message-ID: <20210916072929.GA7929@corigine.com>
References: <20210916032104.35822-1-alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210916032104.35822-1-alexei.starovoitov@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: AM3PR07CA0083.eurprd07.prod.outlook.com
 (2603:10a6:207:6::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from corigine.com (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM3PR07CA0083.eurprd07.prod.outlook.com (2603:10a6:207:6::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.8 via Frontend Transport; Thu, 16 Sep 2021 07:29:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 46c6ac3f-6e05-4775-aa4f-08d978e3bd05
X-MS-TrafficTypeDiagnostic: PH0PR13MB5380:
X-Microsoft-Antispam-PRVS: <PH0PR13MB5380E010FB0EBADDDE7EF87AE8DC9@PH0PR13MB5380.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:626;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iafOlxZL3nVB5VERXupdhPxnzkU9RRCNptAgKIWShvi/8jZOWjd7APNtQhr6I2UaltYk+P0UiPeIrnLZPDDH/0nbzVjYcX9Hzqh2olo/neU67Vmr5xahO2E6AbTUf0nVJBJUmvxGdYC5ur/LW9pt9MMYKSYC99aoE2SpQi0UZPgNLEwCc9+8dYitqg8F9cWxwauFT9XynpU//mFru3YE4hQYCJpjlb5JutQ7ifly7IOS7teapWWm2LkzxvCKqc1dgsZ/j+IpptrJNfiRl7SB/z4FIWRb0mcU9zxQNLr0TIAI+6uvhP2R+bLPwEIenvK8MGqbNyMkXZ/qzrDt+Vbk0IuGLTOeQ3VTEj8xw721/qyhoW6AqUNVBxKKvXSWxCGnthjK7vd2W4atsXNOCLfh65y0nawOHE2yWqkWp905tq75KTCqGOcuqwevW52Fe0+eu0X6LsOdHkrB4NiTHMrxy7oDFnjjUg5iAf2eVbRlUnTpP7R/57BBFvjSJXPRdmzajR4w7vPACC9VPKpMQu7LOMH1phb3C/AtNNoImdDlkEKfO8CTYhLh3Vpf8lI2U+/Dfx2BGMp8XB7zIOpyf1ET9I/rLJKhmzVzzNcj55ub81hAUWFiS8uhVgPQ3Igd7CUSPfPzhWxkBq0+W+fR8/RYYg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(136003)(346002)(39830400003)(366004)(45080400002)(4326008)(6916009)(8936002)(2616005)(66556008)(7696005)(52116002)(66946007)(316002)(38100700002)(8676002)(6666004)(33656002)(8886007)(86362001)(2906002)(508600001)(55016002)(36756003)(1076003)(186003)(44832011)(66476007)(5660300002)(4744005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ckhJZjF5YzIxWHpGWEZ2enBTMTI1MVJlN3hFcHhEUStiRmZ6c0tFVVVOdmZQ?=
 =?utf-8?B?UmIzd2xKdEJzbE5NbE5xQ09TUy84UlVqOUtnS0Exdis4WWtWN1MrNnZqQTRq?=
 =?utf-8?B?cjZKWjkrdC9UaUdrS0daakZIMkY5OUtJUTVnRjlPaDAvT1VoSmpBM3o0a09L?=
 =?utf-8?B?a1VOZEJkeVVkc3JDRzB6blRaQU03QVRZVG5FYkF0VnVLQlNvQStmTHlvUnJB?=
 =?utf-8?B?dGQ1UFBWY05MZmVyazk4a09qc2Q1SGpuQm1DVi8xczZuT0JSU1A3R0pVR2E5?=
 =?utf-8?B?Z2U2a3VkRXBZZXo0OWJDcEE2ci9XbitDM1hueEppZFhRWnZxWWpUb0Zpcks5?=
 =?utf-8?B?T1ZZTFVmc0lpeXMrRjhsbG1Lb3RCaThDaXoxSGlMUHVJNlBreTcyRXgvTU1W?=
 =?utf-8?B?SzJ1MkFQcFFrQTlxSjArdk02NE5Vdll5K1hYaVdjMXRKWUM0cWZWSFUzckxa?=
 =?utf-8?B?V05NSCtOOW5uam9DVVNaY0Z1dDBuK2RSQ25TZHlYK29LMzZFMHNkZ3VYV1lI?=
 =?utf-8?B?ekZZQS9Tck1TbWdSWHh2aDFLWHhuUDJsVUlENlF5cnVYMEpxWFpTZ094ZVVB?=
 =?utf-8?B?MDFuRW04K0lDdTdlcGcwWldiTFg5cjltNVhyRnN4R0N0Unl5ZGV0MFVGTlRa?=
 =?utf-8?B?Um9FM3BUWHVwMjVnTXdoRjRvaWVuT1ovNjlHeHpYNTRhYWhHRlU4aE1JbWtj?=
 =?utf-8?B?Y1NnMUNscnZPZk51NFc4WVJpTWp1UFpsWjJOcSs2N09WczlFTUNhQ21McEtH?=
 =?utf-8?B?akVHM1g2cHp3UUJJNzRWRndBNk5welUxTWtSZDFFT3JCbGFLQnNEQjQ3UTA5?=
 =?utf-8?B?eCtYMDg5eEo4YlBpRGpMcUhOZU12K1BlYUw2MU0xUUhVS0NORThpeGlzaU5x?=
 =?utf-8?B?VDNhb2dGQzVGT1Q4MG5DYmVSbVhxYU5qb3NkSlZWRk5PVWpTY0lTK0t0eFhl?=
 =?utf-8?B?R1ZZYWtJbkZVVzMzSWZVYXl5UTlaTzIzYjBVSWp0Sy9VMG9tSmg2ZVVjcUhu?=
 =?utf-8?B?eTJhZWhjTTFiTlpSSUc3TndjeStiVmNvSldmdmF1K1hsdFliZE1Pa1VYVDJU?=
 =?utf-8?B?aG5iRHIxQUpyT1IrRE9xQlVpdVo0Z3JtMDd0VW1nOENEYkdBZXVWQzVPSk8r?=
 =?utf-8?B?UEtWejJJSTJtb1hob0VxNS9rTkRreUxiZHB4OWJiejg3d2R1aFlBYVVjaDJB?=
 =?utf-8?B?TUxiTkNaem4yeHoyUGdYUjBnbHZCZWNEbFo2dTBIZXF0Q0Z1Zjg2Qk1QbllY?=
 =?utf-8?B?MXgxYzhWb1dML25NYkRIMG1aSjdjWVJpdmtVZmRkWnpRMmtGd3h3bVpkM0Fx?=
 =?utf-8?B?VkFBMHhCQVlMZHJSajhaM0p3eU85N2QvT2Q0VmlWM21UVGtjK2tVZ0k5ZEFE?=
 =?utf-8?B?dXFNYkFraU5JdEpacE5wKzRZa3B5ZEcrUngveDY3OXljcWVxK3UzSjg0bC9C?=
 =?utf-8?B?QVQrMUlrTS9VM2NsQlpkOWJJeFFCVG1UckZZdWFpNC9kekk2czRLQ2tCUGRY?=
 =?utf-8?B?OGpVUWxWYXRvNEp3bERmd29vcnRNM0h3VTlUdTRhOC9vbyszZUVsTUhMMlV3?=
 =?utf-8?B?Yk5hbjFpeE4wdzJZSGEvZ0lPZ1hheFlRWlJveDBMRXVTQUdybFlZN2xXekhr?=
 =?utf-8?B?OTlXOE9WNnlQSWhHUUV4dHNwWGJLN3VVaFF0eE9ERk1oekIwVWJsRFd0a094?=
 =?utf-8?B?Z2p3NHVZazdGckxDYWFjRHNLWHl6TjJjK3RSdHZjS2R2SWRnQWhVVGhTNk1H?=
 =?utf-8?B?akJJdXRYTDNXSFJKL0dyWFFEck9XdDZiazBJbG5tcStRZDJNSnFMU0hjMTlv?=
 =?utf-8?B?dHRCU2lMS1NSak92eHhjV242aU1iVTYzVjFaMUNudVRRVFd1L2tieTF5ZjU1?=
 =?utf-8?Q?7pPyAu94MXOEq?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46c6ac3f-6e05-4775-aa4f-08d978e3bd05
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 07:29:37.4995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RC2xPkkOooGMKJRmgFDeDJTVrzyfG6p37Lx4FsmCdleMtUBmJelUngqu973msjFokO0X4qalAQKndmxm8BjP/eo5T1R1ibujlk06yhfc4go=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5380
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 15, 2021 at 08:21:04PM -0700, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> Document and clarify BPF licensing.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
> Acked-by: Daniel Borkmann <daniel@iogearbox.net>
> Acked-by: Joe Stringer <joe@cilium.io>
> Acked-by: Lorenz Bauer <lmb@cloudflare.com>
> Acked-by: Dave Thaler <dthaler@microsoft.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
