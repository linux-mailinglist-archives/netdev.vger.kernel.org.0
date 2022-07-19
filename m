Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1504157A1B5
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 16:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239188AbiGSOfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 10:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239193AbiGSOen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 10:34:43 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2089.outbound.protection.outlook.com [40.107.243.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1BE864EB;
        Tue, 19 Jul 2022 07:26:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KXMRT7TCh4xsE8S8HipXxrXZpQQfoFpejIUBZS4+7KgzC3EsHA2DHXWTGbw8ft9HETIPYh1kT67Mp2rawkdQKs81K0NDacqXFzpqFq0XJIGeBXHkQJq41+Xq1umLYYVeI/XScIu86PxegVPk/cc4S7GOECpgc5dca59HsvDZCuBQYWR1/L0DJRW+qZfSccsVD48ceEFIw1BG88UOknodgE0aD27vpvNvls9TC7tp7ejfYii14f1YEAo5dZtRr/xg0fF3TEvW9pVUQPW4VWANMt+EjraZQfGn0gBN333ChwGsbAu12ZqtxeuqOsMAHDf5Mk/aTigu+Vbl3Opnj1XRkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=doythWpDpqccwky73FyTRDCLB54pmj06Wmne+NobIiE=;
 b=TjtNbpNmhSboabUNH5o98z9PNqLV65HFubJtuJJetVZkDQKvOIMX+AsElZQhcIrLNQY127YwGq19jKdSF80annWoqerDFMNcwBiAWc5V+Kpf6AUAcidXPRQQz3LA1g49AqWA/xKf+04EPYwG1giyLjdocIveFNahawtv3Bu9xmzn3rhUbsUJ8yGd72K7ardBSZNUYaagn+KC+I8V4sg+2AXwuvX33e8ThzHlXbCKV8bIUEQPezYBNm7MeGsAeLTpfqaQn1YCnIJwGhq3Bl0A2OmeOp7irCdprNhIoIMYg7BerAqgS/BP1YFvPf11U8g63hPr4WA7CoaZVEFrAft60g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=doythWpDpqccwky73FyTRDCLB54pmj06Wmne+NobIiE=;
 b=F+LLqlyO3e9a2gwFI5kb240Q2DzjM1xTYvoRPrmhaH2bTqArei2IKEIG6iN316eJyC0O0iUeCsslKlwn8jnt8teAeTHCsgSHYfFmUlwwKJEatO3TeVZ7yobhgDxUQpOxHPL7uD4Q6tO0IZjDi4EopMN3brLNl4FOZ4GwkjkHOn0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CO6PR12MB5427.namprd12.prod.outlook.com (2603:10b6:5:358::13)
 by SJ1PR12MB6121.namprd12.prod.outlook.com (2603:10b6:a03:45c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Tue, 19 Jul
 2022 14:26:18 +0000
Received: from CO6PR12MB5427.namprd12.prod.outlook.com
 ([fe80::6999:13c9:d124:418a]) by CO6PR12MB5427.namprd12.prod.outlook.com
 ([fe80::6999:13c9:d124:418a%8]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 14:26:18 +0000
Message-ID: <2407dbc8-33e3-dff8-3543-a5277558aeed@amd.com>
Date:   Tue, 19 Jul 2022 10:26:14 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] docs: driver-api: firmware: add driver firmware
 guidelines. (v2)
Content-Language: en-US
To:     Dave Airlie <airlied@gmail.com>, torvalds@linux-foundation.org,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        gregkh@linuxfoundation.org, Daniel Vetter <daniel@ffwll.ch>,
        mcgrof@kernel.org
Cc:     alsa-devel@alsa-project.org, netdev@vger.kernel.org,
        dri-devel@lists.sf.net, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Dave Airlie <airlied@redhat.com>, linux-media@vger.kernel.org
References: <20220719065357.2705918-1-airlied@gmail.com>
From:   Harry Wentland <harry.wentland@amd.com>
In-Reply-To: <20220719065357.2705918-1-airlied@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT1PR01CA0053.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2e::22) To CO6PR12MB5427.namprd12.prod.outlook.com
 (2603:10b6:5:358::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 412b171a-30ed-4e1b-25a5-08da6992a4e9
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6121:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ujpVV19EC0LOEI1E6ML8PiEPAa28PX8SWu4bmbbaqN9FhYqdc3p1hXwfi+r3Colj0nbdlEcY2CHc3ebOSas9RJXGYa7cLoxwwzBNY4KhoNh1jnb+IZ4QO8cZN7+ydyKxbx7HShXwLRx0tbx3N807myxu7u36vT9XZ/ju8Db0ekUYovbBfK2IkL4p9jkXjxgd4eU38SMrDxPAj1Zg7x9GRqs+gcP9vUwbL4rrauFoPLTxjj+FJQQ8Q2+Igfarm46I8JrjGUxpD+dFp+dH+9kMDogM01bXKrNi/Ie1A0NoNJLyfflRhHU1cKuZeUay+SfYRro8+ic4PyUMv7vYaJvQG465EwTz+0JqNdBFcxwCGnOk/8CenctkeIHnZC9NwNrvfwb9bxJtwkIGK92WjwuLYtnN5evkVg59JPWWm5kKWCsvtvIQSwWq+3Zelc5XJNOP5sR1szakQaLRJGooF8DWeF7zVixy9TDRR9H+aCXR5MrU/nYQHZHgVwVnPF32mx6ZtvMghbFcwpT1sm0fMX67jP16TdoDjsO2CwzPDorNHQ+2EUjlrkUBmhIEbYiVxz7kP/8bmF1E24sWSRwlEfR1Bn9yQ0yvglQag3zN5wfj9NK3xAxI550UsHSD2bdnIN09Ek9dyfpfdQeWytvH1auJgXfsHzdjCBcpa9VqDKlEQbEfuL25tC+HwL1IsrALjytARBleXHvw71DruvQ1j6fMXI/0Zpw77m1KE/qeZ8rycXWY6a5/FWSSCtbnGtMgDzEjyAgt6x28PUlYsRhg+wiP9O76esA/VimKaXYddOmKt29wjTMDsHbdt0Rw2DmLFlf/4E17HYeVLoD1XoO/6TDSlA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5427.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(396003)(376002)(346002)(136003)(83380400001)(6512007)(54906003)(26005)(6506007)(53546011)(2616005)(186003)(38100700002)(7416002)(31686004)(66946007)(5660300002)(44832011)(8936002)(2906002)(6666004)(110136005)(66476007)(8676002)(6486002)(36756003)(478600001)(41300700001)(31696002)(66556008)(316002)(86362001)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cWJMZTRCcUdMc1l0aFB5L04rU0hJRDlMTEdTZThEbHhEWERkTXM1SjFyaE5U?=
 =?utf-8?B?eTBiakhUd25WakNHNFd2UEpPS3lKQUhIeHpwa0RrTFcvWFdUWTRLTTBrdnRX?=
 =?utf-8?B?MzBFdE0xSGFVWmlQSm1XV3lZMHdOb2N1NTV6QjRBYzc3ZHpDN2xqVVRidlNr?=
 =?utf-8?B?bi9iUUV6THBYams2em9nak9VSnh3ZTFpelg5Rm1iYXpJSkJuZElXYW9BTVdz?=
 =?utf-8?B?bzRIYmhBZXNsZ1VWWGpSZ1hzNlhyWkI3VlFlSk5zUXUzdWdjaHYxbk9EUWlW?=
 =?utf-8?B?eGs0ZWZtdFFLb01BTTRrekZ5ckoxek9hN2t3M2N4SGczdFdkUTVnRHd4RFNI?=
 =?utf-8?B?SkVkRmVkckpFZVU1Mm8wSDdBMnJIaWovOFM4OUdqdU05cEhJQkZnRVdUeEVJ?=
 =?utf-8?B?SlZDTGJUWi9mU010YlQ0aC8raEd0d3pmcmQ5b2NVd0dUaml3bjdTM0pJV0lK?=
 =?utf-8?B?bDh4VzdkbmNxQ25iMjZuVFBHVllKN1RKM0tJbEwzbVBhZ2d5MlBJU2loWnB5?=
 =?utf-8?B?YVAybnBOVEtkeW03S3Z0NnVZWWo2R1VtempkT1dVYmV5RE9kdEViRXVPT29T?=
 =?utf-8?B?dWZnakFiMzBoU08xSW0xU3cyaFp4bVcvRDlWUlc2SE55c3JXN0xhR243a2p2?=
 =?utf-8?B?K2NyNzZXQlNVbGhUbTBmcUlQQTNndlBmbWhBNkQ1ZkJxWXE1UTQ2OTFJVnRX?=
 =?utf-8?B?YVc5dk1IL0pYcmhnekJYOUROaXRORVNjcGlnaUxISHcrNy9heU5DeW1ERjRL?=
 =?utf-8?B?K240eVhZQXdncU51SU01bHFPMnExU0s5WWUyNVNkcE1QNGQ1QStLcCtBSy9F?=
 =?utf-8?B?VGZsZE5tbm9pY3o3bzZTZ0F0OHdYaVZ5UXV5TGJXT3BLdjA0bWcyQzdyTVVy?=
 =?utf-8?B?d0hzSm8weVIwcFg4YmRVYi9RWDVmWnp1akg4Ukx1Ukp4cGRxVkxkZk5oR1p4?=
 =?utf-8?B?Q25qS1BvNjFFNzhCM0hQWVZGV2NRcVVkc1EwcDAxTGhXVmI1RExSRHNYVFE3?=
 =?utf-8?B?Tlg2VTVvNEtqSysyOXNFTWJ2bmxDWW9tWjArTnk0QUdqbU02TDk5QytzclV0?=
 =?utf-8?B?alM1cUVrMjE1aC9acGliS3hlbHRBaSs3cnhlSGZkMldMbGllNFc1eFNMNk5X?=
 =?utf-8?B?cTZJMDRVU0RhTUNwaUZHRS84aUpOVWxZVE82QnNzNWdnV0xWSVVBSEp1WWlu?=
 =?utf-8?B?YVhUVWFYMVNOaGh6VVVQQ1FlNVcvdTdKV2ZmbTFXNHhYN29DR21qVWVkMWNW?=
 =?utf-8?B?WmpYU1U4WnBTb2FITW1nRDk1ZkM2aFZsNlc0N3hHYnJXbkVVbHlJdjdmb0dh?=
 =?utf-8?B?SVNhNDQ5RWd5ZkpQNTM1cXdGNnZMMVJCbFBrNklOelpIVkMrMUk2WkR6WnBs?=
 =?utf-8?B?emtnY013MXZBc3djUlYrTE1kLzZkRkVqcWJ1OFQwdUpLajc3RmVzbzZmSHU4?=
 =?utf-8?B?akp5YWE3VFI5YU1paGNWOE5OZjhzaGovVzNHajFNQnZNOFIvSzVGSS9RSGRZ?=
 =?utf-8?B?KzJwWXZVWkZFdG8zczNLRUx3c0V0anZQa2RFS2Jyc0NOeVQ1MFJxT0JYa1JU?=
 =?utf-8?B?NDZnSWdVQjNYWDdYOVYzWCtKUzdzSzljZmhkOTBSZmdQRmVDSDh2cklQWEFq?=
 =?utf-8?B?TFlQdkN4ck1adDZDYTVsME1tMjhjS3N2S1d1dTNlOHN0SzNzMldVSjY1QSt0?=
 =?utf-8?B?Q2tsRzFtRmwwOHVKTkErenQrQXJKRTNNcXNGZUxZMXhRRzllMldteVZqQ1Nm?=
 =?utf-8?B?TzBXTEFYTGVLTmc2MTQzY1QzdHFWSlpsZmJTTlcvM1VGaURONzFHTE9RMDBm?=
 =?utf-8?B?azBEU2kyOVN0d0xGeUJLSjhDbzZ2VTNZR0ttS2JjWnJnMkY5eVJ0aC9Kdit1?=
 =?utf-8?B?TmNVMDdhaFVrNmlwRkJrSDBUbmV5YUdIYitRNDVtYkhzaEUxRzNrUWZnUmtt?=
 =?utf-8?B?cG41MmZBSFh2ZzdhZGVRS09XYUVaYzdFMFlhUmhRa25XWGJqeEJVQ0VjdC9Y?=
 =?utf-8?B?ak5pWWlvdmZUUW5KL0tFUnluTzB5WmJ2VFVUZE1zdmFmSThyUVkzMUlpWGxv?=
 =?utf-8?B?WjhRSXRiV0hnQUpaR2dJRE1aSW1oTlhKTUNrQWx2MVppL1FZdjVBMkxsWmJ0?=
 =?utf-8?Q?WogeUeenzSHV5z8Fc4Z2AADEc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 412b171a-30ed-4e1b-25a5-08da6992a4e9
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5427.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 14:26:18.1418
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +iRpqHqrJTuKsSPx2/oVkyIZxay3Sb64mHtzHsOv0Hbs4HMmk1xHG0Z32wGVKbZ/o4KUAAde3PSC4KaQEDh/dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6121
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-07-19 02:53, Dave Airlie wrote:
> From: Dave Airlie <airlied@redhat.com>
> 
> A recent snafu where Intel ignored upstream feedback on a firmware
> change, led to a late rc6 fix being required. In order to avoid this
> in the future we should document some expectations around
> linux-firmware.
> 
> I was originally going to write this for drm, but it seems quite generic
> advice.
> 
> v2: rewritten with suggestions from Thorsten Leemhuis.
> 
> Acked-by: Luis Chamberlain <mcgrof@kernel.org>
> Acked-by: Rodrigo Vivi <rodrigo.vivi@intel.com>

Acked-by: Harry Wentland <harry.wentland@amd.com>

Harry

> Signed-off-by: Dave Airlie <airlied@redhat.com>
> ---
>  Documentation/driver-api/firmware/core.rst    |  1 +
>  .../firmware/firmware-usage-guidelines.rst    | 34 +++++++++++++++++++
>  2 files changed, 35 insertions(+)
>  create mode 100644 Documentation/driver-api/firmware/firmware-usage-guidelines.rst
> 
> diff --git a/Documentation/driver-api/firmware/core.rst b/Documentation/driver-api/firmware/core.rst
> index 1d1688cbc078..803cd574bbd7 100644
> --- a/Documentation/driver-api/firmware/core.rst
> +++ b/Documentation/driver-api/firmware/core.rst
> @@ -13,4 +13,5 @@ documents these features.
>     direct-fs-lookup
>     fallback-mechanisms
>     lookup-order
> +   firmware-usage-guidelines
>  
> diff --git a/Documentation/driver-api/firmware/firmware-usage-guidelines.rst b/Documentation/driver-api/firmware/firmware-usage-guidelines.rst
> new file mode 100644
> index 000000000000..34d2412e78c6
> --- /dev/null
> +++ b/Documentation/driver-api/firmware/firmware-usage-guidelines.rst
> @@ -0,0 +1,34 @@
> +===================
> +Firmware Guidelines
> +===================
> +
> +Drivers that use firmware from linux-firmware should attempt to follow
> +the rules in this guide.
> +
> +* Firmware should be versioned with at least a major/minor version. It
> +  is suggested that the firmware files in linux-firmware be named with
> +  some device specific name, and just the major version. The
> +  major/minor/patch versions should be stored in a header in the
> +  firmware file for the driver to detect any non-ABI fixes/issues. The
> +  firmware files in linux-firmware should be overwritten with the newest
> +  compatible major version. Newer major version firmware should remain
> +  compatible with all kernels that load that major number.
> +
> +* Users should *not* have to install newer firmware to use existing
> +  hardware when they install a newer kernel.  If the hardware isn't
> +  enabled by default or under development, this can be ignored, until
> +  the first kernel release that enables that hardware.  This means no
> +  major version bumps without the kernel retaining backwards
> +  compatibility for the older major versions.  Minor version bumps
> +  should not introduce new features that newer kernels depend on
> +  non-optionally.
> +
> +* If a security fix needs lockstep firmware and kernel fixes in order to
> +  be successful, then all supported major versions in the linux-firmware
> +  repo should be updated with the security fix, and the kernel patches
> +  should detect if the firmware is new enough to declare if the security
> +  issue is fixed.  All communications around security fixes should point
> +  at both the firmware and kernel fixes. If a security fix requires
> +  deprecating old major versions, then this should only be done as a
> +  last option, and be stated clearly in all communications.
> +

