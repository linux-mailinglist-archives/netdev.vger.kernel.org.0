Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22522184584
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 12:04:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbgCMLEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 07:04:31 -0400
Received: from mail-bn8nam12on2115.outbound.protection.outlook.com ([40.107.237.115]:25793
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726387AbgCMLEa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 07:04:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fLTbJC8MhC6oEGWFL5+j+iteNbC1bqX8Z26N0mybcC6x5dkFxWr/Mstt4moMo6Q7Ta8HT2PSPIWamxE0B4dPmBTpy4jBkMDZR9KEd1+ZL72B3LD+pG/7e1ATX6Rqxhv5HrLgsYH6ontkuO3tcxDLRw1PA94Rs/wGpVoOd0Imi/zcrR3HVBn9RGwtywxDaBXMDvZOaWp6gym9Hgijw+xpTTBOxdUEBk5f+soZKm4Lteii9OWrYlZrfjhyFXD8o5iP6Pz2cdDkSMR4Jvsrz+aMUSA3J7nMc9hGKQ94cc/xZb3ceca0PcRqOeAmp0tswoiRqrgCJ/ePNN95FVr1DFAlWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Od+NrTrql0tkVgx2dHy7tXk6otgJpPhWVCxqjf5FEQ=;
 b=O+dd6lwo+615A2lVNdnkGAj64erhm6kvh0r32G3WE8R4fh2l4zc422vO27kS+2az81kfb4wRmIC9YO+zMk8eHXwjtmj769UgV6duSjVj2EjAGgm4StWJpBb/ET18JCaRt/iaAkbRFSa4XCiDPVGSBBLTd3I5DVzqotL2bSzxZeiuM6F6US8XgrTY0Kqpwft3RXcCkaIcQN/carqhbnC0hr3iAyqehkJCmSmqA8gy2frgNt9AtFBcvMZbkyhuxAKuWfwzPSTOfQc72hAJfNKXAnZs9T59aZpsLi6fodOpLdChNrmtDccrSi60J6EGtqGPhltdewqzi491vV+V3P3D6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cypress.com; dmarc=pass action=none header.from=cypress.com;
 dkim=pass header.d=cypress.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Od+NrTrql0tkVgx2dHy7tXk6otgJpPhWVCxqjf5FEQ=;
 b=IwGNtYvFiKskGeYIScsNEvv4JP0IpRVCH13kV4/dNS0fO2guZeErcfuDlDDCR3D2ab40Xa6LhPJ3zwDc/pUGqPatQr3Jlva6hOX37CO6jDVTKv+XKQYZRoUIcGTvxEhJXlmhlq52B/Ei6U/mtiXPbfoQ0CtMHuIR1Abe48TNFt8=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
Received: from BYAPR06MB4901.namprd06.prod.outlook.com (2603:10b6:a03:7a::30)
 by BYAPR06MB5352.namprd06.prod.outlook.com (2603:10b6:a03:ab::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17; Fri, 13 Mar
 2020 11:03:50 +0000
Received: from BYAPR06MB4901.namprd06.prod.outlook.com
 ([fe80::3cc3:7b1a:bd7b:a0a9]) by BYAPR06MB4901.namprd06.prod.outlook.com
 ([fe80::3cc3:7b1a:bd7b:a0a9%5]) with mapi id 15.20.2793.021; Fri, 13 Mar 2020
 11:03:50 +0000
Reply-To: chi-hsien.lin@cypress.com
Subject: Re: [PATCH v2 0/9] brcmfmac: add support for BCM4359 SDIO chipset
To:     =?UTF-8?Q?Heiko_St=c3=bcbner?= <heiko@sntech.de>,
        Soeren Moch <smoch@web.de>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org, brcm80211-dev-list@cypress.com,
        linux-arm-kernel@lists.infradead.org
References: <20191211235253.2539-1-smoch@web.de>
 <1daadfe0-5964-db9b-818c-6e4c75ac6a69@web.de>
 <22526722-1ae8-a018-0e24-81d7ad7512dd@web.de> <2685733.IzV8dBlDb2@diego>
From:   Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Message-ID: <d7b05a6c-dfba-c8e0-b5fb-f6f7f5a6c1b7@cypress.com>
Date:   Fri, 13 Mar 2020 19:03:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
In-Reply-To: <2685733.IzV8dBlDb2@diego>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR21CA0007.namprd21.prod.outlook.com
 (2603:10b6:a03:114::17) To BYAPR06MB4901.namprd06.prod.outlook.com
 (2603:10b6:a03:7a::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.9.112.143] (61.222.14.99) by BYAPR21CA0007.namprd21.prod.outlook.com (2603:10b6:a03:114::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.6 via Frontend Transport; Fri, 13 Mar 2020 11:03:48 +0000
X-Originating-IP: [61.222.14.99]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 62396984-5167-4363-aa3b-08d7c73e35ed
X-MS-TrafficTypeDiagnostic: BYAPR06MB5352:|BYAPR06MB5352:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR06MB5352298F01774CF10B92EBCFBBFA0@BYAPR06MB5352.namprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 034119E4F6
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(136003)(366004)(376002)(39860400002)(346002)(396003)(199004)(5660300002)(86362001)(956004)(81166006)(52116002)(6666004)(31696002)(81156014)(8676002)(53546011)(2616005)(186003)(66574012)(26005)(16526019)(8936002)(3450700001)(36756003)(31686004)(2906002)(4326008)(478600001)(6486002)(66556008)(316002)(66476007)(66946007)(110136005)(16576012)(55004002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR06MB5352;H:BYAPR06MB4901.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eGiO0gzk4t7r6kvIeuU4WEULq2+RBBElmtOciU4hDrWj8PnVoXBrUJJIK4kBYuKuhj30ryX0OwqGnCq8SXCqDE1SDXI6B+TXb+JWSc8o9sJF3MVORyQs9n3S0bPvwXmn+Cc1yq0Es2FCIgS6QFCiVktB9Szsy6P2TLLbFXX/8OOr49CsUdHic7AXA3/yYQtKpliVlqKdZDnIeiaJtuOkJJTzdFU6Rqr23KGwwYQD1m/xmDT5+kE0YtGMMNW2PPLUD9o19FKtlq8T1qBsEIxkojn+N/FS9EVVA6KLApdTd0jJadcu5mBDmVO2RKiAgF9eGcFx8y8RzWLznX9cMlQ6seBZF/9dl0AESX1ewBUjCKO+ga1/Yi9Pb5c9khKZeOlZbj9cOFoyA9rIblK9AVP2+pniSOkqfz1+ibV8gQaZEnBuccFVjgwpXtSeNRCbZ+My2HX8kygrlyLFJzprsGYB2HOkI2IDmyaNbnPPGQNJd5qsAxnU617moKYTvKXnG6LI
X-MS-Exchange-AntiSpam-MessageData: jS/uIX4ame7sv/RcBvFv51Mbk/N9GufyJlubKi2gXzfNz4brHfHmA3jJufFNe+XRh0H+uQ4J52Pr/e0DAv/z/a9xo8GHiwzOqc+cUS1Z46h5zd7OZt6AZomHDlPj6WL9j9P+pjvfJ6h8HSK7GQ94rQ==
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62396984-5167-4363-aa3b-08d7c73e35ed
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2020 11:03:50.7359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 538WHKl5SCZhcVyaaHXJ5euGqVJ8NU7PshdF/NjhCFR/ZjGw9Wml+kpWwJT3JN+uPWSeZYGJMQ0XiPiqFpL58w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR06MB5352
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/16/2019 7:43, Heiko Stübner wrote:
> Hi Soeren,
> 
> Am Sonntag, 15. Dezember 2019, 22:24:10 CET schrieb Soeren Moch:
>> On 12.12.19 11:59, Soeren Moch wrote:
>>> On 12.12.19 10:42, Kalle Valo wrote:
>>>> Soeren Moch <smoch@web.de> writes:
>>>>
>>>>> Add support for the BCM4359 chipset with SDIO interface and RSDB support
>>>>> to the brcmfmac wireless network driver in patches 1-7.
>>>>>
>>>>> Enhance devicetree of the RockPro64 arm64/rockchip board to use an
>>>>> AP6359SA based wifi/bt combo module with this chipset in patches 8-9.
>>>>>
>>>>>
>>>>> Chung-Hsien Hsu (1):
>>>>>    brcmfmac: set F2 blocksize and watermark for 4359
>>>>>
>>>>> Soeren Moch (5):
>>>>>    brcmfmac: fix rambase for 4359/9
>>>>>    brcmfmac: make errors when setting roaming parameters non-fatal
>>>>>    brcmfmac: add support for BCM4359 SDIO chipset
>>>>>    arm64: dts: rockchip: RockPro64: enable wifi module at sdio0
>>>>>    arm64: dts: rockchip: RockPro64: hook up bluetooth at uart0
>>>>>
>>>>> Wright Feng (3):
>>>>>    brcmfmac: reset two D11 cores if chip has two D11 cores
>>>>>    brcmfmac: add RSDB condition when setting interface combinations
>>>>>    brcmfmac: not set mbss in vif if firmware does not support MBSS
>>>>>
>>>>>   .../boot/dts/rockchip/rk3399-rockpro64.dts    | 50 +++++++++++---
>>>>>   .../broadcom/brcm80211/brcmfmac/bcmsdh.c      |  8 ++-
>>>>>   .../broadcom/brcm80211/brcmfmac/cfg80211.c    | 68 +++++++++++++++----
>>>>>   .../broadcom/brcm80211/brcmfmac/chip.c        | 54 ++++++++++++++-
>>>>>   .../broadcom/brcm80211/brcmfmac/chip.h        |  1 +
>>>>>   .../broadcom/brcm80211/brcmfmac/pcie.c        |  2 +-
>>>>>   .../broadcom/brcm80211/brcmfmac/sdio.c        | 17 +++++
>>>>>   include/linux/mmc/sdio_ids.h                  |  2 +
>>>>>   8 files changed, 176 insertions(+), 26 deletions(-)
>>>> Just to make sure we are on the same page, I will apply patches 1-7 to
>>>> wireless-drivers-next and patches 8-9 go to some other tree? And there
>>>> are no dependencies between the brcmfmac patches and dts patches?
>>>>
>>> Yes, this also is my understanding. I'm glad if you are fine with
>>> patches 1-7.
>>> Heiko will pick up patches 8-9 later for linux-rockchip independently.
>>> And if we need another round of review for patches 8-9, I think we don't
>>> need to bother linux-wireless with this.
>>
>> Heiko,
>>
>> is this OK for you when patches 1-7 are merged now in wireless-drivers,
>> and then I send a v3 for patches 8-9 only for you to merge in
>> linux-rockchip later? Or do you prefer a full v3 for the whole series
>> with only this pending clock name update in patch 9?
> 
> Nope, merging 1-7 from this v2 and then getting a v3 with only the dts
> stuff is perfectly fine :-)

Soeren,

I suppose patch 1-7 from this serious are all good for merging. Is that 
right? If so, could you please create a rebased V3?


Regards,
Chi-hsien Lin

> 
> Heiko
> 
> 
> .
> 
