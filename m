Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C271A463A9F
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 16:53:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240711AbhK3P43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 10:56:29 -0500
Received: from mail1.bemta31.messagelabs.com ([67.219.246.114]:31434 "EHLO
        mail1.bemta31.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240188AbhK3P4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 10:56:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lenovo.com;
        s=Selector; t=1638287582; i=@lenovo.com;
        bh=CekQchNTwF6mfOiROg+MDDjlUpZvHef15O7iGgCWumk=;
        h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
         In-Reply-To:Content-Type:Content-Transfer-Encoding;
        b=swlPmDAgQUykqRRvadS75VtJG2b0hs5kyF1wf/xDJRQdD/dT7lsIZOLF5vr4VtPjg
         jUTjCyiC9HTULyBU5VeH4RpQzd6HdPPgDT0lS5gWhScdYWu7qLXAkxctMDCK7tOz8m
         ZFZPWExTqUioets5D9M3hqxkAOBQCtF1RScxWY0vxm0oJxD9A3/s9DZ74Jzb7l35Kv
         BWDmBtYzPTZzSKsT/gNr551/kK/kU5zsPuOCCTru5n7DyM/DGbGTd6QFW2M0VmrKHp
         9RElU3zfT3xMyw5NnPeurRkHEh7ffX2wBCC9ouAKdtRM4ljsDbuVvjuKQAodo4hS55
         XBzgmMumaSyOA==
Received: from [100.114.1.131] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-6.bemta.az-a.us-east-1.aws.ess.symcld.net id DA/27-00528-ED846A16; Tue, 30 Nov 2021 15:53:02 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA1WTa0xbZRjHec+Ngi07FBgvnSAp0SCzHRUkh5j
  hNiX0g8Qaszg2EznIgTa2pekpCEa03rK1MGHFL+u6cS1uBbLIYGwD3NgmAwYWx4AA4gWrctkl
  XIKwBvS0h0388uT3vP/neZ//k7yvABVXBUoETLGJMepprZQIxtR7JDrZtLKRTnTcTaAqvr2MU
  qMdGNU5vIZQDvcXGLVWtopS/0x6ceqq9xRBbZY1EtTwxa9wauSKg6B6a3ZSnetVgJrr9oJ9Iq
  XdfJxQtp2bQJT1XXOIstVlIZT9nxcql1tjVMRhXKPPKSjOxtWViw2oYTCkeHbxM9wMyoVWECw
  ApBOFJ5y9gE/qcGitr8asIIhLjiFw8VaaTxCTZxB4sfcMwic3EHh7oxnxVUHyFoBlrgxesADY
  2b5G8EklAlctp3A+8QDo/NS2pcwA+NP6SqCvX0TuhefW7uA+xshnof3uPMafh8L+kx4/R5Bvw
  yHXFOrjMJKBp9ub/IySkXDSU+03FU5+DWDLH1f9e6CkG4H3xlcBP84FoHf0LPC1EORu2Nb2iP
  BxEDf65lIHxl/1PPyywxvI8zOw477DP0JMxsFHFW6UXzUWDrVcwXnOhuWbMwTPUXBsYjiQ52j
  4/ZAD4zkTnu/v3apJgIsPXVs1Wnhp0wx4fg5+N/IzWgnk9m1b27dtZ99mz77NXg3AXCA1x6jJ
  V5t0tEYrUyQmyhSKZFmyLOUlOf2hjJYXsjKGZk0yhZz+gJUzLCtnS3TvaXPlesbUCrh3mGvE9
  l8CDeXr8usgSoBII0RUSiMtDskpyC1R06z6XWOhlmGvg6cFAikUZb3CaaFGJp8pztNoudf8WI
  YCoTRc5MjgZBFroHWsJp+XBkC6oHLudB0qsJbXcnF2tJ6L/T0NXLTd7OxAxZi+QM9IIkW3fc2
  kr1ldqH9y9eO/cgdES8JEICAgQCw0MEadxvR/fR5ECoA0TBTNfSmxUKM3PXEwz5lDOHP3nfU+
  cyb6P0liRpJ+kOjcXUF9SVPvpA2WZJ6oeD30wMCOvrRpc/83qp2ZA40V7//VHZCh/3M0e+mp5
  I/35teyXW9eW0BByZ6imWwUvdd3KH5XU87IsdKiI6K3nKro1/5W7WJXEoQb7o9iDhqSZiwRGw
  2/9b3R2x5z9sfD8fvgg75Jc4TnWsvRrKMPYhmmZiV9RLhMpS6Mr8YtHF8+Mpf/u4UICSDGB7N
  Km9ubG7sv7C59lXyhqSfW1n3h/C8HPC+i1UTeYtWYofayZ2I2WDV4qE6WgsdbcU3erzeS66Ji
  eiaminTBrTbDkkWR0eM+eVA3llj5su0TWETHpXoi92ts4aZ073TkemDCwx1dUoxV04oE1MjS/
  wIsDhVupgQAAA==
X-Env-Sender: markpearson@lenovo.com
X-Msg-Ref: server-13.tower-706.messagelabs.com!1638287579!9110!1
X-Originating-IP: [104.47.26.109]
X-SYMC-ESS-Client-Auth: mailfrom-relay-check=pass
X-StarScan-Received: 
X-StarScan-Version: 9.81.7; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 727 invoked from network); 30 Nov 2021 15:53:01 -0000
Received: from mail-sgaapc01lp2109.outbound.protection.outlook.com (HELO APC01-SG2-obe.outbound.protection.outlook.com) (104.47.26.109)
  by server-13.tower-706.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 30 Nov 2021 15:53:01 -0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ea+pAjlizwhWddD+mpSHUsbQwRFcRZlBHRPtCRmJXIAlt9VdDK1xvTXZUPJpdmsS8kZJgKunPqdcOQj6+wy5iCaWG2veWPs3CO7Q0JBYBCgYd/0+woSHVEdxDi2vouQBlx4BMrgrQnttAg8goNSZEB5YnaPbtV0vS318TfFu5sX4zOXxA/JrrkHkJ9DudBBtsf1molH9wBm0EjehxBkaXLTafPJi8I6ClX/F/vI7O3JcxBOsz2ur4p1two0ST3buBXY1FiQDMWveT5WC8bTHNVbGjenx+y+7tzhUMmcdqIDVad2jMKizokIKDVf3sGwR3+DFh++OCfy7JX9303o7Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CekQchNTwF6mfOiROg+MDDjlUpZvHef15O7iGgCWumk=;
 b=OWrnOLhLkHhqgSz/UjuaOzsDs+PGksT2tJ9qUXSYhp0vOfkf/9ZwKH2FpZKGw3NayGoQOz4QImOAAe1AKfHp6P5U8FYuhe3Yb9Wu+h8MCMH7Dy4HcGMmyeBs/2TK0ZJPdXdZO3BSeObGNq7JOlVkRqw3KLKGId/w1E9buVBZUfz9iweZyW4OY2sh4nUYxRDHoD0IKwRiivPxE5eRoEcsXrx1BeFOcy/eg5oh82tz+QI4o/52NcQHXXnztzvIPcpn37IXqoS9rDTgMRZBI1/QmmCSj2iWmIw2d/xvboskjQFYHPeZ+WOiiGP0tcs1yuRepKlmVgheo6gh/CbyY7YK4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 104.232.225.6) smtp.rcpttodomain=intel.com smtp.mailfrom=lenovo.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=lenovo.com;
 dkim=none (message not signed); arc=none
Received: from PS2PR02CA0025.apcprd02.prod.outlook.com (2603:1096:300:59::13)
 by TY2PR03MB4318.apcprd03.prod.outlook.com (2603:1096:404:f3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.9; Tue, 30 Nov
 2021 15:52:58 +0000
Received: from PSAAPC01FT052.eop-APC01.prod.protection.outlook.com
 (2603:1096:300:59:cafe::f9) by PS2PR02CA0025.outlook.office365.com
 (2603:1096:300:59::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.21 via Frontend
 Transport; Tue, 30 Nov 2021 15:52:58 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is
 104.232.225.6) smtp.mailfrom=lenovo.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=lenovo.com;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 lenovo.com discourages use of 104.232.225.6 as permitted sender)
Received: from mail.lenovo.com (104.232.225.6) by
 PSAAPC01FT052.mail.protection.outlook.com (10.13.38.166) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4734.20 via Frontend Transport; Tue, 30 Nov 2021 15:52:57 +0000
Received: from reswpmail01.lenovo.com (10.62.32.20) by mail.lenovo.com
 (10.62.123.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2308.20; Tue, 30 Nov
 2021 10:52:22 -0500
Received: from [10.38.55.222] (10.38.55.222) by reswpmail01.lenovo.com
 (10.62.32.20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2308.20; Tue, 30 Nov
 2021 10:52:21 -0500
Message-ID: <3fad0b95-fe97-8c4a-3ca9-3ed2a9fa2134@lenovo.com>
Date:   Tue, 30 Nov 2021 10:52:20 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [External] Re: [PATCH 3/3] Revert "e1000e: Add handshake with the
 CSME to support S0ix"
Content-Language: en-US
To:     Sasha Neftin <sasha.neftin@intel.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>
CC:     <acelan.kao@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        "Ruinskiy, Dima" <dima.ruinskiy@intel.com>,
        "Lifshits, Vitaly" <vitaly.lifshits@intel.com>,
        "Avivi, Amir" <amir.avivi@intel.com>
References: <20211122161927.874291-1-kai.heng.feng@canonical.com>
 <20211122161927.874291-3-kai.heng.feng@canonical.com>
 <0ba36a30-95d3-a5f4-93c2-443cf2259756@intel.com>
From:   Mark Pearson <markpearson@lenovo.com>
In-Reply-To: <0ba36a30-95d3-a5f4-93c2-443cf2259756@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.38.55.222]
X-ClientProxiedBy: reswpmail04.lenovo.com (10.62.32.23) To
 reswpmail01.lenovo.com (10.62.32.20)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6dc23f45-fb2e-4535-73d5-08d9b4197acd
X-MS-TrafficTypeDiagnostic: TY2PR03MB4318:
X-Microsoft-Antispam-PRVS: <TY2PR03MB431864B97EA44188BED647B4C5679@TY2PR03MB4318.apcprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eEdhNE44czhoWTdCbHBNOEF2VzdOZzBkU3FqbVRyRStDMnBlSnVFeGwvd0V3?=
 =?utf-8?B?NUdtaklpbStIMUQ3YnVQdldYSVdYM21pdjZwMjVqTnRZYkxMOFpQdFhFaEpG?=
 =?utf-8?B?VzFYbzJXTW9COWNLUE9LYmlaWU9EanFHVm1jazgzWmtidFRTUTJkSlNpTlRz?=
 =?utf-8?B?M205SitFL1FPZW8vSHdtdTczNm9WYkdQMXJrb2E3RVpDWHVVdjVvWnByU2hK?=
 =?utf-8?B?R3hqc0U2VnRlTG9ETVJJbjdzL29LT0JWWlJuOHcxYVJhL3NXRit6dEIrSk5I?=
 =?utf-8?B?eUhvTnpMRkJFRDlMNjlKNzh4b3hLcDZBTnhITGMzdjhhbmxyeWpuNlRVdnFu?=
 =?utf-8?B?aW5kZHlITDNDaE1nMmlQSGJycS8rd1g1THFnU25KT29SQjNwQXZvallPaTdy?=
 =?utf-8?B?WmEycVlZWWE0U0R0c2ZQVWw4djZKMVl6cDNLZWtDTmpqNHVsTEU0d3BYOXlx?=
 =?utf-8?B?M0hQcnF4TWlwS1lNeHcxTERTbnRWRnhZYzVJTFNEN0RTb3ZvWFRlNVJXT05S?=
 =?utf-8?B?S0Y0VDZFdmtuZUw2V1g2NEJXQnJGZXNrU1hyMGYvSVdiTjRsTmhWMlZ1L1FH?=
 =?utf-8?B?MFhmUzhleTc5T0QyVHQ2eVJwVnBkTFVUMFdicDFqRnhFUVVtK3h0NDJzcFp4?=
 =?utf-8?B?NVJ4Q1JnMXhhSHV4VnY4SkxPb3h2T2psZVVGRGNnbHl3bzliRzJvTGtQVC9n?=
 =?utf-8?B?S3dldllGbndNeFNPci9uNiswWEVxUldsbnlmRDhwME1kUkhUMHNMQkwwK1M1?=
 =?utf-8?B?Rk9MaCtWMDVuSTVidXV0akNBOVZ6ck14WWM5OWIwRThMbHYxUStudk5tUW9M?=
 =?utf-8?B?YXlvYmlVU2laUnZhNEZXOFpTRVo5M1ByT1JjVU84a2l6OWpKUy9CeThnWXIv?=
 =?utf-8?B?NU56ZHdHS0hxcHdqdFQ0UFp6TFFnL202S0x2YkM2bmNMYTNvQStPUDNKcllP?=
 =?utf-8?B?ZmI2aUs2SG0xTHlzbVZFY1Q5V1RhRmZsNStvcktxcjlZdUE2b3hldkpQNTd0?=
 =?utf-8?B?UXBkdEIyMUFpeElqWDFQWU9RNFdEcUlMWXdlTFJ3Y3VxSXZCeXBvNVpsWGk0?=
 =?utf-8?B?M1JoS0lSUERaa1cxU0s4WHg5dEtMbTRSRkJlTDFweWxCSmNVMkMxZEZlekRk?=
 =?utf-8?B?aGdiSjR0cEZnTG4vUE5BTjF6eFk5TCtHN0dCc3hXdHdKMU9SeWNmOW9FQ0k3?=
 =?utf-8?B?R3pkZElGZVdMRERiWmJQcVVYekFMVHRHdTRnTzR0ZHBWTmxOako0M21WaHUx?=
 =?utf-8?B?VGRkNG9UUXdXVUROTFJ4cElMaW96OW9UekZiZXIxb0YzSW05STZZcG9PSnA5?=
 =?utf-8?B?bWQxakl2RS9EUGR0emovWW9aekJkaE0rcitJUTZXUnhnQ0E0QUdFKyt4cGJ5?=
 =?utf-8?B?ZWZKOGt6NEV5d0E9PQ==?=
X-Forefront-Antispam-Report: CIP:104.232.225.6;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.lenovo.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(31696002)(86362001)(5660300002)(82960400001)(31686004)(966005)(70586007)(2616005)(40460700001)(47076005)(70206006)(110136005)(36756003)(186003)(356005)(336012)(426003)(26005)(82310400004)(4001150100001)(36860700001)(53546011)(316002)(36906005)(8936002)(7416002)(4326008)(8676002)(81166007)(16576012)(54906003)(2906002)(16526019)(508600001)(83380400001)(3940600001)(32563001)(36900700001)(43740500002);DIR:OUT;SFP:1102;
X-OriginatorOrg: lenovo.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2021 15:52:57.2645
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dc23f45-fb2e-4535-73d5-08d9b4197acd
X-MS-Exchange-CrossTenant-Id: 5c7d0b28-bdf8-410c-aa93-4df372b16203
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5c7d0b28-bdf8-410c-aa93-4df372b16203;Ip=[104.232.225.6];Helo=[mail.lenovo.com]
X-MS-Exchange-CrossTenant-AuthSource: PSAAPC01FT052.eop-APC01.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR03MB4318
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sasha

On 2021-11-28 08:23, Sasha Neftin wrote:
> On 11/22/2021 18:19, Kai-Heng Feng wrote:
>> This reverts commit 3e55d231716ea361b1520b801c6778c4c48de102.
>>
>> Bugzilla:
>> https://bugzilla.kernel.org/show_bug.cgi?id=214821>>>
>> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
>> ---
<snip>
>>
> Hello Kai-Heng,
> I believe it is the wrong approach. Reverting this patch will put
> corporate systems in an unpredictable state. SW will perform s0ix flow
> independent to CSME. (The CSME firmware will continue run
> independently.) LAN controller could be in an unknown state.
> Please, afford us to continue to debug the problem (it is could be
> incredible complexity)
> 
> You always can skip the s0ix flow on problematic corporate systems by
> using privilege flag: ethtool --set-priv-flags enp0s31f6 s0ix-enabled off
> 
> Also, there is no impact on consumer systems.
> Sasha

I know we've discussed this offline, and your team are working on the
correct fix but I wanted to check based on your comments above that "it
was complex". I thought, and maybe misunderstood, that it was going to
be relatively simple to disable the change for older CPUs - which is the
biggest problem caused by the patch.

Right now it's breaking networking for folk who happen to have a vPro
Tigerlake (and I believe even potentially Cometlake or older) system. I
think the impact of that could potentially be quite severe.

I understand not wanting to revert the change for the ADL platforms I
believe this is targeting and to fix this instead - but your comment
made me nervous that Linux users on older Intel based platforms are in
for a long and painful wait - it is likely a lot of users....

Can you or Dima confirm the fix for older platforms will be available
soon? I appreciate the ADL platform might take a bit more work and time
to get right.

Thanks
Mark
