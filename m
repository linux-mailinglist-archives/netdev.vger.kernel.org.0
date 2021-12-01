Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C519A4655FA
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 20:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244622AbhLATEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 14:04:25 -0500
Received: from mail1.bemta35.messagelabs.com ([67.219.250.112]:7425 "EHLO
        mail1.bemta35.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243512AbhLATEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 14:04:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lenovo.com;
        s=Selector; t=1638385262; i=@lenovo.com;
        bh=hM6R7m8qzLTyn33oOBPN9cVkBnLzSiuN6IRnHokLh4g=;
        h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
         In-Reply-To:Content-Type:Content-Transfer-Encoding;
        b=DdX9Y8fAP0bnHFBdN+4oDNlPJCizmRsjMK2Xctg+4euhjwDoykDyI9iBP8QLKwB+Q
         4F4LBdMdnzQJPty2sOH4xZ5qj4jA4VSWMzRfS9Gw3ok9K/49SBRjF7CxAaYt4SNxJG
         lAAVP3XZUVPu89VHuKjie6Acfv+8Yd7DpHFQNeSo/pmqqys4VEf2ysD/Qi6D+l/ms5
         6gOyVR1brnmi/YFpx7q4LIWbORxDCDIbGGeGAkR4i517mfJ54BMNBy3foLtbizBUD0
         7BKeN5w0zuMML22lPRSnxaRrlqZgkBSAJofUpD76YBqU/iFbwCwMf+Jvk+6y6YAzj7
         GF3BfPs30PkRA==
Received: from [100.114.97.245] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-4.bemta.az-a.us-west-2.aws.ess.symcld.net id BB/28-04418-D66C7A16; Wed, 01 Dec 2021 19:01:01 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprELsWRWlGSWpSXmKPExsWSoS9VoJt7bHm
  iwasmbov+jTuZLa5uZ7HYfeEHk8Wc8y0sFj+6vzFb/L/1m9Vi/+/ZbBb/upexWVzY1sdqcXnX
  HDaLYwvELHb/nMxo8XLvb0YHXo9ZDb1sHltW3mTyWLznJZPHplWdbB4nm0s9Pm+SC2CLYs3MS
  8qvSGDNOLfiB2vBbsmKbUuvMDUwvhPpYuTiYBRYyiyx48kZVghnEavE0gkLmSCcr4wSK7fuYu
  xi5OQQEpjNJPHmRh6EfYBJYsvRIJAiCYGzjBJbZm5mhkjkSxzctpUZJCEk0M8k8alzCjuE85h
  RYt73OSwQzkNGiUP/d7CCtPAK2ErMmXgXqIWDg0VAReLsJ2aIsKDEyZlPWEBsUYFwibOrboPF
  hQVSJeZuXQ1mMwuIS9x6Mh/sVhGBA4wSt04+YgNxmAUWMUlM2nuVDe6OZRt2gbWwCWhLbNnyi
  w3E5gTafPLVHKhRmhKt23+zQ9jyEtvfzoF6SFniV/95MFtCQEHi/NoHTBB2gkTPv0dsELakxL
  WbF9ghbFmJo2dB3uQAsn0l7j6JgAhrSWx91scIYedILFqzhxWiRF3i/nr/CYx6s5D8PAvJb7O
  QHDcLyXELGFlWMdokFWWmZ5TkJmbm6BoaGOgaGppAaDMzvcQq3US90mLd8tTiEl0jvcTyYr3U
  4mK94src5JwUvbzUkk2MwGSYUpSybAdjc/9PvUOMkhxMSqK8l5ctTxTiS8pPqcxILM6ILyrNS
  S0+xCjDwaEkwRt9ECgnWJSanlqRlpkDTMwwaQkOHiUR3n9HgNK8xQWJucWZ6RCpU4yuHBNezl
  3EzNHVsxBIvri6GEiePLgESE46sns7sxBLXn5eqpQ4b98eoGYBkOaM0jy40bCscolRVkqYl5G
  BgUGIpyC1KDezBFX+FaM4B6OSMK/PUaApPJl5JXAXvAI6jgnouMOzwI4rSURISTUwTXpydXnk
  OaNuzTsLY6qalLqPO5Uc4Dy3em1Pw6sJC6eWX02vrl52yujKpsnFAay7osQ/9x5fEuXhPLU0b
  2KZ0/f1Wvd3e7wNmbM68v7cyE/z/tiZ1QmtOPBh+45dfEfdcqb+fhO199LsbQf7lY6vnec4wV
  5WiHNuz6mbB3eed3l5933jjHkT3Db2vlkwMdBa2fGodaRWap+PplrmEY8Hm+4Gb7PUcs9hnbv
  ljvsKd1fWhhsXXC/Y98gpPQxqaF5ztsMq2v34LNHk6cZ8OeFehrc2JHM8utZ97n+rTeD3vole
  Fnea5DiUv6hd+ObTaF7Ytk9s88aUO3P8YvdZ5qWWO+V2vJwUckNn6cz2QPbNh5VYijMSDbWYi
  4oTAbH9COGlBAAA
X-Env-Sender: markpearson@lenovo.com
X-Msg-Ref: server-5.tower-655.messagelabs.com!1638385259!4400!1
X-Originating-IP: [104.47.26.112]
X-SYMC-ESS-Client-Auth: mailfrom-relay-check=pass
X-StarScan-Received: 
X-StarScan-Version: 9.81.7; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 14954 invoked from network); 1 Dec 2021 19:01:00 -0000
Received: from mail-sgaapc01lp2112.outbound.protection.outlook.com (HELO APC01-SG2-obe.outbound.protection.outlook.com) (104.47.26.112)
  by server-5.tower-655.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 1 Dec 2021 19:01:00 -0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dEbjrdnWis3WyyA6b3hEu1S3XC+cjJSx9xcWjeVQY1TbYF+7ozL/Bb8e1ZeQ/4c7febrpYgabSWKlut8e71V8ej/8lkv+dmXUgTSq8JJQRANZpNk74D7UnFFEshN6/oB93/71A1oNhFI0Cdcs9FIRwRK14iAJaEUV4NmE+ZTeeFHNo56WGQSPTvStr/YrabnL1ete0p21PTmP58JJe11Bz2wMIuPoB/Q/D7vp07hzcr8OKV8ta0g8pCZ8YHlR5Xi9x4nLvpqyvuUkOZCe+Y4NA9DXo4BQwPnccn8n4v/jEltuvquxrXGiOsPAEwzeDBEFRx7mLmQuBwoqzs13DOKDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hM6R7m8qzLTyn33oOBPN9cVkBnLzSiuN6IRnHokLh4g=;
 b=hviNHMDovjvjcbaBvt0O1vwHR29X3GYXJPH4s/b2EapB44zcKLvSfOxFNNYGCnqc3bqHGT4bz10vg3BlHHXzNC/EiiUzKbWTJzTDJr8smr9gMvSLizMjsjeW8hinHlkiMVAVsomYLar5c2hIrWg1p4Lup5GqAU9HHyq3lq8kQzgY1c92VGZIbyInewGVNDwWtKJC5F6NfCE+PkpPNQmAyKEzYAuKZCGst49OFbW2v4/DCmDEpWYAC7HBbQlKPFcwztYLE1rdMHv2zUhZL5AsLO4CTi53HDnNkwqN4iVTIBMyOAcsHt9vKyMOVkvaCNsfK6VSMbs+WJsfxN4Bz8sm5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 104.232.225.6) smtp.rcpttodomain=intel.com smtp.mailfrom=lenovo.com;
 dmarc=temperror action=none header.from=lenovo.com; dkim=none (message not
 signed); arc=none
Received: from PSXP216CA0051.KORP216.PROD.OUTLOOK.COM (2603:1096:300:6::13) by
 PUZPR03MB5991.apcprd03.prod.outlook.com (2603:1096:301:b6::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4734.17; Wed, 1 Dec 2021 19:00:58 +0000
Received: from PSAAPC01FT068.eop-APC01.prod.protection.outlook.com
 (2603:1096:300:6:cafe::fd) by PSXP216CA0051.outlook.office365.com
 (2603:1096:300:6::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.24 via Frontend
 Transport; Wed, 1 Dec 2021 19:00:58 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is
 104.232.225.6) smtp.mailfrom=lenovo.com; dkim=none (message not signed)
 header.d=none;dmarc=temperror action=none header.from=lenovo.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of lenovo.com: DNS Timeout)
Received: from mail.lenovo.com (104.232.225.6) by
 PSAAPC01FT068.mail.protection.outlook.com (10.13.38.174) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.13 via Frontend Transport; Wed, 1 Dec 2021 19:00:56 +0000
Received: from reswpmail01.lenovo.com (10.62.32.20) by mail.lenovo.com
 (10.62.123.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2308.20; Wed, 1 Dec
 2021 14:00:55 -0500
Received: from [10.38.97.141] (10.38.97.141) by reswpmail01.lenovo.com
 (10.62.32.20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2308.20; Wed, 1 Dec
 2021 14:00:53 -0500
Message-ID: <809af77d-493a-cba4-a1fe-def12dabe602@lenovo.com>
Date:   Wed, 1 Dec 2021 14:00:40 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [External] Re: [PATCH 3/3] Revert "e1000e: Add handshake with the
 CSME to support S0ix"
Content-Language: en-US
To:     "Ruinskiy, Dima" <dima.ruinskiy@intel.com>,
        Sasha Neftin <sasha.neftin@intel.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>
CC:     <acelan.kao@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        "Lifshits, Vitaly" <vitaly.lifshits@intel.com>,
        "Avivi, Amir" <amir.avivi@intel.com>
References: <20211122161927.874291-1-kai.heng.feng@canonical.com>
 <20211122161927.874291-3-kai.heng.feng@canonical.com>
 <0ba36a30-95d3-a5f4-93c2-443cf2259756@intel.com>
 <3fad0b95-fe97-8c4a-3ca9-3ed2a9fa2134@lenovo.com>
 <aa685a4f-c270-7b6e-1ede-24570d30dd98@intel.com>
From:   Mark Pearson <markpearson@lenovo.com>
In-Reply-To: <aa685a4f-c270-7b6e-1ede-24570d30dd98@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.38.97.141]
X-ClientProxiedBy: reswpmail04.lenovo.com (10.62.32.23) To
 reswpmail01.lenovo.com (10.62.32.20)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 23a4d1dc-4f79-48f8-f702-08d9b4fce855
X-MS-TrafficTypeDiagnostic: PUZPR03MB5991:
X-Microsoft-Antispam-PRVS: <PUZPR03MB5991F3EF9C9DC46B4A65BDD5C5689@PUZPR03MB5991.apcprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?anNBeWdVWFlQNE8xMW9FeVpubjZManBFb0NlWWJNZEdTKzlpOHh2RVgwMVM3?=
 =?utf-8?B?UklIK0lFVWJqM01nUDdzMWhEc1RVenBWd1VKM3NnbnE4aCtkOUFWNG1ldGZB?=
 =?utf-8?B?MEV2ZDBWS0lyM0E5UWlrUVB6S1Ireis1QldKQjMxNXcwWkRISVpLTC9LZmUv?=
 =?utf-8?B?RVdHNm9RREdJSmpoVlBYQ0tTUXNDNjZZd2ZsdVFiL096R0lGcU55WVlROFp4?=
 =?utf-8?B?RWZGRE1jMEc0Vnl4UjdQOHFHTmZFQXREWWJJUHpkRFIyTEQ0M0FWVlVIMWJy?=
 =?utf-8?B?NU1hSVprUHZGZUw1UWk0Wm8xQ21IUzk2bHl3TUFIbVZ4QlJRZDlPNnpSZ3ND?=
 =?utf-8?B?Y3N2SDBvaWw3bm9yMFlJaFVoNVAvakwzM0hUQnNDd1ZrY1czWTV6NGdBcGJ3?=
 =?utf-8?B?VUNYeXZjRnpORmdNUFlWMU84ZFd2TnVzYTNEUnM0WDZRN3c1azhaMi85aWFp?=
 =?utf-8?B?MGZ5L1R1dTlKejJJN0dXSXBhVTQ0a1BYQmJxcE5EL3p2OHd4UGpJZHVXRUZE?=
 =?utf-8?B?VjJCdVRadC9RbDVQNHpOQUdXM0F4b3NsSDF3L2JEZkdqQ3VnT1lFOVlhTGNP?=
 =?utf-8?B?MVRTUzNFSjEzUnA5Z3ZGQ1AwYndmUGFNVzhQNGlwSi9zYmJSaFFvUGVFZzFK?=
 =?utf-8?B?TEY3SHFNMVlnSVFUc0owTHNlTzVCQWp4YzBxZmtKQXB0Nk9PYkNRcnFHOXhW?=
 =?utf-8?B?Zk1Wd1Y4N3ZpdlhlWDRDQkFtUjd5QmhwSUtsMUZuUHFYTlpua0I3dWIrTDNS?=
 =?utf-8?B?SjBtd3BJeFltUlhQc0xzUmJtY3d1L25IRmRrQXFlMzQ1THhVZDFxbkpEV082?=
 =?utf-8?B?SkMrZFhNMUkzdWE5czNqU1ptVnh6QnhiSm9KaWVxeDkrRE9rVnFpYXFqMU5V?=
 =?utf-8?B?YndQWmJsWDJTeUlLQ2hNZzNsNzNGQnh1aXU2eUZoa2NZTGcxWDRXYjJPNlgv?=
 =?utf-8?B?M1llSjBLbThuNjVjKzNlNzFNS3kzVVRkc1VVekwwT2RzM3ZOY3ZQRWRVaGFr?=
 =?utf-8?B?V3JHMDRkZjZhQ2ZyUjV0ZXhBaytudVBoY0V1TXZwNGVLU3QvLytOL1UzWXQ1?=
 =?utf-8?B?dUhCcDg0dlNwNldTVWVycUQreStMVzVMNjFrMzRrTmNSU3dBRkpBVzNpWU5k?=
 =?utf-8?B?OHB6eWpDMHR1QUVFaWxoRE1zeU1DQk1HZDdGT2QxalhyNDJoMjkxdUZFY0Qw?=
 =?utf-8?B?Q1NXeFNEMGhnZHhMZlR6bEZWSlMxLzNUdWhnakMrQjZ5Z1V6dEVKN2ZFcXZr?=
 =?utf-8?B?amcvZjdxUzR0cFhRR0xLcFFwSmJxdjJhYUtnRWM0aFFSekU5QXRuOVVITTg0?=
 =?utf-8?B?d1VuNHN6dUNremw0Z2FEOW04OFRjaVpwWEcxcjV3TkJYeURDei9Xd1dxbHUx?=
 =?utf-8?B?bHRJeU5HWkI2Rnc9PQ==?=
X-Forefront-Antispam-Report: CIP:104.232.225.6;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.lenovo.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(70206006)(81166007)(53546011)(82310400004)(186003)(31696002)(356005)(83380400001)(16526019)(7416002)(8676002)(8936002)(316002)(4326008)(40460700001)(63350400001)(26005)(70586007)(36906005)(2906002)(54906003)(508600001)(2616005)(966005)(6666004)(36756003)(82960400001)(47076005)(110136005)(5660300002)(16576012)(336012)(36860700001)(63370400001)(86362001)(4001150100001)(426003)(31686004)(32563001)(3940600001)(43740500002)(36900700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: lenovo.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2021 19:00:56.7811
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 23a4d1dc-4f79-48f8-f702-08d9b4fce855
X-MS-Exchange-CrossTenant-Id: 5c7d0b28-bdf8-410c-aa93-4df372b16203
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5c7d0b28-bdf8-410c-aa93-4df372b16203;Ip=[104.232.225.6];Helo=[mail.lenovo.com]
X-MS-Exchange-CrossTenant-AuthSource: PSAAPC01FT068.eop-APC01.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR03MB5991
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-12-01 11:38, Ruinskiy, Dima wrote:
> On 30/11/2021 17:52, Mark Pearson wrote:
>> Hi Sasha
>>
>> On 2021-11-28 08:23, Sasha Neftin wrote:
>>> On 11/22/2021 18:19, Kai-Heng Feng wrote:
>>>> This reverts commit 3e55d231716ea361b1520b801c6778c4c48de102.
>>>>
>>>> Bugzilla:
>>>> https://bugzilla.kernel.org/show_bug.cgi?id=214821>>>>>
>>>> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
>>>> ---
>> <snip>
>>>>
>>> Hello Kai-Heng,
>>> I believe it is the wrong approach. Reverting this patch will put
>>> corporate systems in an unpredictable state. SW will perform s0ix flow
>>> independent to CSME. (The CSME firmware will continue run
>>> independently.) LAN controller could be in an unknown state.
>>> Please, afford us to continue to debug the problem (it is could be
>>> incredible complexity)
>>>
>>> You always can skip the s0ix flow on problematic corporate systems by
>>> using privilege flag: ethtool --set-priv-flags enp0s31f6 s0ix-enabled
>>> off
>>>
>>> Also, there is no impact on consumer systems.
>>> Sasha
>>
>> I know we've discussed this offline, and your team are working on the
>> correct fix but I wanted to check based on your comments above that "it
>> was complex". I thought, and maybe misunderstood, that it was going to
>> be relatively simple to disable the change for older CPUs - which is the
>> biggest problem caused by the patch.
>>
>> Right now it's breaking networking for folk who happen to have a vPro
>> Tigerlake (and I believe even potentially Cometlake or older) system. I
>> think the impact of that could potentially be quite severe.
>>
>> I understand not wanting to revert the change for the ADL platforms I
>> believe this is targeting and to fix this instead - but your comment
>> made me nervous that Linux users on older Intel based platforms are in
>> for a long and painful wait - it is likely a lot of users....
>>
>> Can you or Dima confirm the fix for older platforms will be available
>> soon? I appreciate the ADL platform might take a bit more work and time
>> to get right.
>>
>> Thanks
>> Mark
>>
> Hi Mark,
> 
> What we currently see is that the issue manifests itself similarly on
> ADL and TGL platforms. Thus, the fix will likely be the same for both.
> 
> If we cannot find a proper fix soon, we will provide a workaround (for
> example by temporary disabling the feature on vPro platforms until we do
> have a fix).
> 
> This can be done without reverting the patch series, and I don't see
> much value in selectively disabling it for CML/TGL while leaving it on
> for ADL, unless our ongoing debug shows otherwise.
> 
Got it - thanks Dima.

As a note - the obvious advantage of selectively disabling for CML/TGL
is there is a ton of those platforms out there in users hands, whereas
the ADL platforms won't be landing for a few more months (at least in
our case). I'm OK if the fixes take a touch longer with ADL (though
we'll want them soon so they have time to make it upstream and down into
the distro's) - but there's going to be a lot of unhappy Intel users as
soon as they start picking up the updates (that are landing in some
distro's) and finding that networking is broken. I'd expect TGL/CML to
be a priority...

Keep us posted when the fix is ready please.

Mark
