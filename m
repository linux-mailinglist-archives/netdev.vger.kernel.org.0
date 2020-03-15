Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 991BC185AD4
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 08:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727301AbgCOHCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 03:02:07 -0400
Received: from mail-dm6nam12on2137.outbound.protection.outlook.com ([40.107.243.137]:43585
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726963AbgCOHCG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Mar 2020 03:02:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PKdXWzeaFGyUHPYLK5OuEzcEZz/+2N/423b0/PfYA0bzKEFiLf9aKOt6xmxVxRAks17AgCZZFbJatsGd/VCk0JcmtPvteQg7HjqoL33CKa4sLQ+FLO/qqvTWi6GvQw0uqRCtY4nGRZWP6QyOoRl4/V0UtJSgoqJU7S29q7h8QFcThheQmDCsh41z/y/s5LX6qtt+hZ7V7PjuLbFKMP2gvqXAPLciAyVTQHxwz59n65uzAJgeaRPwyMXUFkBBC53OUJuvkL9q+LqHvkLsg+Pcj7/Stc4dW8K8aXEfIPpPaOL73lyGEkdXYbASD+C+vWI6guNoyHyKM4xoQpi+imq0Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h9WoTsGQOec+Ymlu/AP6xL9/hB7Cu6aVaHRhlCsVpeY=;
 b=CojuebvTEB2LIf9n1CavzSLYXVvwUnJFpY/lJerzfnh7gAoXJNPO5ShLDGl0GWDEcIxIPGqbTSo/vl+42E9U0qfQ5j6jfYn004Bsvkt8NiY6PVq5pO49/r79iAicMx62hWrx2SRc3CoJC//UiWFFFTlQPMlYIgaEzHXlKeRhgW2ZfhzhAEUaHoa7CQRs4VBwaY1eY0ppJvOB0xRmyomuChBPki3tsBrpDgmWA9rtTaM+KlpRH14jj4ztFOcs53EK/PfutGT6akxJ5bbFzVkp4X3pObO0EcNR5bDqv0CCCITJJY5MrEK0MTnzzdIlj5Q0Kx8FwNvR6NCCp0tT5egyKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cypress.com; dmarc=pass action=none header.from=cypress.com;
 dkim=pass header.d=cypress.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h9WoTsGQOec+Ymlu/AP6xL9/hB7Cu6aVaHRhlCsVpeY=;
 b=Qja87oXSNOyhU72xzIqujEfPmwS3o0MvCL7mXjQAruvQ3yKyxsaXvbEPhvJRe/d6YLRVY6cBUpCDAdEJCkYnN7rg19qLqllHAe8FcaWIuANqi0fNESXBQOvWE4qdGysZGLD8p7CcEJyaH0sKeCbXAcFFlIuK0ka/qesNdWOb14Y=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
Received: from DM6PR06MB4906.namprd06.prod.outlook.com (2603:10b6:5:56::11) by
 DM6PR06MB5851.namprd06.prod.outlook.com (2603:10b6:5:1a8::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.16; Sun, 15 Mar 2020 07:02:01 +0000
Received: from DM6PR06MB4906.namprd06.prod.outlook.com
 ([fe80::a964:a78d:ec3:c4c]) by DM6PR06MB4906.namprd06.prod.outlook.com
 ([fe80::a964:a78d:ec3:c4c%3]) with mapi id 15.20.2814.021; Sun, 15 Mar 2020
 07:02:01 +0000
Reply-To: chi-hsien.lin@cypress.com
Subject: Re: [PATCH v2 0/9] brcmfmac: add support for BCM4359 SDIO chipset
To:     Soeren Moch <smoch@web.de>,
        =?UTF-8?Q?Heiko_St=c3=bcbner?= <heiko@sntech.de>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rockchip@lists.infradead.org" 
        <linux-rockchip@lists.infradead.org>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
References: <20191211235253.2539-1-smoch@web.de>
 <1daadfe0-5964-db9b-818c-6e4c75ac6a69@web.de>
 <22526722-1ae8-a018-0e24-81d7ad7512dd@web.de> <2685733.IzV8dBlDb2@diego>
 <d7b05a6c-dfba-c8e0-b5fb-f6f7f5a6c1b7@cypress.com>
 <09d6c2d7-b632-3dd1-2c9d-736ccc18d4a9@web.de>
From:   Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Message-ID: <e3431452-7cfc-7e2c-c93f-977cfd21b46b@cypress.com>
Date:   Sun, 15 Mar 2020 15:01:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
In-Reply-To: <09d6c2d7-b632-3dd1-2c9d-736ccc18d4a9@web.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR05CA0081.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::22) To DM6PR06MB4906.namprd06.prod.outlook.com
 (2603:10b6:5:56::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.9.112.143] (61.222.14.99) by BYAPR05CA0081.namprd05.prod.outlook.com (2603:10b6:a03:e0::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.6 via Frontend Transport; Sun, 15 Mar 2020 07:01:58 +0000
X-Originating-IP: [61.222.14.99]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9d08e458-f59e-4e50-c23c-08d7c8aec260
X-MS-TrafficTypeDiagnostic: DM6PR06MB5851:|DM6PR06MB5851:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR06MB5851D973DC5247CC432D686DBBF80@DM6PR06MB5851.namprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0343AC1D30
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(376002)(366004)(396003)(39860400002)(346002)(136003)(199004)(31696002)(5660300002)(2906002)(16526019)(186003)(8676002)(31686004)(4326008)(3450700001)(26005)(8936002)(316002)(110136005)(54906003)(16576012)(52116002)(53546011)(6666004)(66946007)(956004)(66476007)(66556008)(6486002)(81166006)(81156014)(2616005)(478600001)(66574012)(86362001)(36756003)(55004002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR06MB5851;H:DM6PR06MB4906.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mCfff8y7jfQKGeZP0oci5L2UiEHgpOIpqdXBEJfm0vqlNm/q3GGe3TRn6pNDuLbuc9GQc2n47lOZy42j3wiGWGxbks5gs88Dl41EthKu7NzLQH5l6jFS95KsfFOaSiPW3Wso0upb57NcfRyzxhS0QgCQNMGq5AYhw39wB38zo6RpXykIwL0rSegnWH/SXfvjlJXe3IvOIasBJUW6H3sl01drex2Qccuh1t/YUWYNR/0n4lTD/Ky3XDeHLbGbOmcOxhxN3bR7qK+5oXFeIzKwy3ew0etze+jZkxgbJx/L4fM/z+ktXiSKHqPueQqcesZpJ20knlR50VXzt9iGjJp5nDZOGrUml9z9CO4qr2jGPz4fT7M0DDxaBgNc5VCWJcfuKFCAmS9NdONhXTozXyR0WqqmGwj/zi8j0tQI8V3Xue0spxv/zNWIc/ImgW6PVFzaDCN4M0H77fxVc+ZbYSO8FO8LZvjX8YeD0R4JpET+iKjswGZ8V0NcC3UjpIsSqTdy
X-MS-Exchange-AntiSpam-MessageData: zxJscTJRqI00ZCqV5mCnYGsfqIuJoF8zIcrNnhpbrliJlVKEsKBW1TCM1xMXhzsrZ03uF6GZgqgm08lZxlas/ZTfuCeU6aM/0vq/YyXWVQDu9ergaBgLMQxjNwg7f7fRqjk2TaJAkS9pQgrTvyI7ng==
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d08e458-f59e-4e50-c23c-08d7c8aec260
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2020 07:02:01.4935
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lUkHtJk4BAzOBYzhBGFgpkPXmCKV5jiU50qesO9WMKw98jg9m1ZqX2ur2vVkz9x3Uk1A2QSCW3o0nRrEmNTZ1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR06MB5851
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 03/13/2020 9:17, Soeren Moch wrote:
> 
> On 13.03.20 12:03, Chi-Hsien Lin wrote:
>> On 12/16/2019 7:43, Heiko Stübner wrote:
>>> Hi Soeren,
>>>
>>> Am Sonntag, 15. Dezember 2019, 22:24:10 CET schrieb Soeren Moch:
>>>> On 12.12.19 11:59, Soeren Moch wrote:
>>>>> On 12.12.19 10:42, Kalle Valo wrote:
>>>>>> Soeren Moch <smoch@web.de> writes:
>>>>>>
>>>>>>> Add support for the BCM4359 chipset with SDIO interface and RSDB
>>>>>>> support
>>>>>>> to the brcmfmac wireless network driver in patches 1-7.
>>>>>>>
>>>>>>> Enhance devicetree of the RockPro64 arm64/rockchip board to use an
>>>>>>> AP6359SA based wifi/bt combo module with this chipset in patches
>>>>>>> 8-9.
>>>>>>>
>>>>>>>
>>>>>>> Chung-Hsien Hsu (1):
>>>>>>>     brcmfmac: set F2 blocksize and watermark for 4359
>>>>>>>
>>>>>>> Soeren Moch (5):
>>>>>>>     brcmfmac: fix rambase for 4359/9
>>>>>>>     brcmfmac: make errors when setting roaming parameters non-fatal
>>>>>>>     brcmfmac: add support for BCM4359 SDIO chipset
>>>>>>>     arm64: dts: rockchip: RockPro64: enable wifi module at sdio0
>>>>>>>     arm64: dts: rockchip: RockPro64: hook up bluetooth at uart0
>>>>>>>
>>>>>>> Wright Feng (3):
>>>>>>>     brcmfmac: reset two D11 cores if chip has two D11 cores
>>>>>>>     brcmfmac: add RSDB condition when setting interface combinations
>>>>>>>     brcmfmac: not set mbss in vif if firmware does not support MBSS
>>>>>>>
>>>>>>>    .../boot/dts/rockchip/rk3399-rockpro64.dts    | 50 +++++++++++---
>>>>>>>    .../broadcom/brcm80211/brcmfmac/bcmsdh.c      |  8 ++-
>>>>>>>    .../broadcom/brcm80211/brcmfmac/cfg80211.c    | 68
>>>>>>> +++++++++++++++----
>>>>>>>    .../broadcom/brcm80211/brcmfmac/chip.c        | 54 ++++++++++++++-
>>>>>>>    .../broadcom/brcm80211/brcmfmac/chip.h        |  1 +
>>>>>>>    .../broadcom/brcm80211/brcmfmac/pcie.c        |  2 +-
>>>>>>>    .../broadcom/brcm80211/brcmfmac/sdio.c        | 17 +++++
>>>>>>>    include/linux/mmc/sdio_ids.h                  |  2 +
>>>>>>>    8 files changed, 176 insertions(+), 26 deletions(-)
>>>>>> Just to make sure we are on the same page, I will apply patches
>>>>>> 1-7 to
>>>>>> wireless-drivers-next and patches 8-9 go to some other tree? And
>>>>>> there
>>>>>> are no dependencies between the brcmfmac patches and dts patches?
>>>>>>
>>>>> Yes, this also is my understanding. I'm glad if you are fine with
>>>>> patches 1-7.
>>>>> Heiko will pick up patches 8-9 later for linux-rockchip independently.
>>>>> And if we need another round of review for patches 8-9, I think we
>>>>> don't
>>>>> need to bother linux-wireless with this.
>>>>
>>>> Heiko,
>>>>
>>>> is this OK for you when patches 1-7 are merged now in wireless-drivers,
>>>> and then I send a v3 for patches 8-9 only for you to merge in
>>>> linux-rockchip later? Or do you prefer a full v3 for the whole series
>>>> with only this pending clock name update in patch 9?
>>>
>>> Nope, merging 1-7 from this v2 and then getting a v3 with only the dts
>>> stuff is perfectly fine :-)
>>
>> Soeren,
>>
>> I suppose patch 1-7 from this serious are all good for merging. Is
>> that right? If so, could you please create a rebased V3?
> Chi-hsien,
> 
> Thanks for asking, but these patches are already merged in
> torvalds/v5.6-rc1 as commits
> 1b8d2e0a9e42..2635853ce4ab
> 
> So everything already fine with this.

Ahh... You're right. They're all good. Thanks a lot!!

> 
> Thanks,
> Soeren
> 
>>
>>
>> Regards,
>> Chi-hsien Lin
>>
>>>
>>> Heiko
>>>
>>>
>>> .
>>>
> 
