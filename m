Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D54282B43B6
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 13:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730120AbgKPM1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 07:27:08 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.184]:45284 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730115AbgKPM1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 07:27:07 -0500
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.137])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 7AFC82004F;
        Mon, 16 Nov 2020 12:27:06 +0000 (UTC)
Received: from us4-mdac16-60.at1.mdlocal (unknown [10.110.50.153])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 79670600A1;
        Mon, 16 Nov 2020 12:27:06 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.8])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 1CE6F220070;
        Mon, 16 Nov 2020 12:27:06 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id D0A4F4C0062;
        Mon, 16 Nov 2020 12:27:05 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 16 Nov
 2020 12:26:58 +0000
Subject: Re: [PATCH net-next 1/3] sfc: extend bitfield macros to 19 fields
To:     Alexander Duyck <alexander.duyck@gmail.com>
CC:     Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>
References: <eda2de73-edf2-8b92-edb9-099ebda09ebc@solarflare.com>
 <5ce9986a-4c5c-9ffd-e83d-e6782ff370ba@solarflare.com>
 <CAKgT0UciV2rSiNBHQOhqHkrx=XBLzOTdHmKXZ6fTxdt1D3c0Gg@mail.gmail.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <72c7dac3-9744-0006-b859-50b4e3ccf5bf@solarflare.com>
Date:   Mon, 16 Nov 2020 12:26:54 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CAKgT0UciV2rSiNBHQOhqHkrx=XBLzOTdHmKXZ6fTxdt1D3c0Gg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25792.003
X-TM-AS-Result: No-7.228800-8.000000-10
X-TMASE-MatchedRID: QfHZjzml1E/mLzc6AOD8DfHkpkyUphL9WDtrCb/B2hD7C4CfTnA36opb
        wG9fIuIT8zQZkhLHa0OngCw2pwtq0oG/yDOSYBKbdPM8veyrICYbAqzdFRyxuDVbYUlecnP2U/+
        NAjGtZkh4FTWzKCjc1RlMp4O5kTedGWYDzz6TOfMsisyWO3dp2xQEj9RZgbsWI0YrtQLsSUzSxr
        uiAnvW8VYNd7soMdXfH5z9qcm95LqBANQIBoQOqf7kh4czHCCaBnIRIVcCWN9KDy5+nmfdPoulA
        O4+bW29585VzGMOFzABi3kqJOK62QtuKBGekqUpm+MB6kaZ2g4L8VlvIUtkKaIxa+XNL9wDVHsq
        aBvNaxbrSt4RnseIp4BhS7bunkF/pAyrR8EInKFtUQd1hHptfyEq+kH4DxzD9iJ7CXJ9OFaHzGT
        HoCwyHhlNKSp2rPkW5wiX7RWZGYs2CWDRVNNHuzflzkGcoK72
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--7.228800-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25792.003
X-MDID: 1605529626-JxhvmnyEq_-s
X-PPE-DISP: 1605529626;JxhvmnyEq_-s
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/11/2020 19:06, Alexander Duyck wrote:
> On Thu, Nov 12, 2020 at 7:23 AM Edward Cree <ecree@solarflare.com> wrote:
>> @@ -348,7 +352,11 @@ typedef union efx_oword {
>>  #endif
>>
>>  /* Populate an octword field with various numbers of arguments */
>> -#define EFX_POPULATE_OWORD_17 EFX_POPULATE_OWORD
>> +#define EFX_POPULATE_OWORD_19 EFX_POPULATE_OWORD
>> +#define EFX_POPULATE_OWORD_18(oword, ...) \
>> +       EFX_POPULATE_OWORD_19(oword, EFX_DUMMY_FIELD, 0, __VA_ARGS__)
>> +#define EFX_POPULATE_OWORD_17(oword, ...) \
>> +       EFX_POPULATE_OWORD_18(oword, EFX_DUMMY_FIELD, 0, __VA_ARGS__)
>>  #define EFX_POPULATE_OWORD_16(oword, ...) \
>>         EFX_POPULATE_OWORD_17(oword, EFX_DUMMY_FIELD, 0, __VA_ARGS__)
>>  #define EFX_POPULATE_OWORD_15(oword, ...) \
> Are all these macros really needed? It seems like this is adding a
> bunch of noise in order to add support for a few additional fields.
> Wouldn't it be possible to just define the ones that are actually
> needed and add multiple dummy values to fill in the gaps instead of
> defining every macro between zero and 19? For example this patch set
> adds an option for setting 18 fields, but from what I can tell it is
> never used.
I guess the reasoningoriginally was that it's easier to read and
 v-lint if it's just n repetitions of the same pattern.  Whereas if
 there were jumps, it'd be more likely for a typo to slip through
 unnoticed and subtly corrupt all the values.
But tbh I don't know, it's been like that since the driver was added
 twelve years ago (8ceee660aacb) when it had all from 0 to 10.  All
 we've done since then is extend that pattern.

-ed
