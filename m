Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 074B128D484
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 21:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728482AbgJMTgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 15:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbgJMTgG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 15:36:06 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2E6AC0613D0;
        Tue, 13 Oct 2020 12:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=/8br067d++YamcdmBjUCKygjOJnP8nv1KaYqcimhMro=; b=lmdvQOQx7pe0L2+mTdplGXQkDb
        3GUORaiFM95XhvSXSfEfS5dbmdOHpcLsE/27lckEJ7d618moCNCZ1OrcD78mkFIEOPo6KcWM+Shlo
        qd/ubudvq2AYY1ppmgDaAn2bct9+030ApeGwQEWxPJEMhYNZSR/mdYz1fzpJTrLw4zsBQqDausc1Y
        0XVXJInQU2RUGkvPdG8LQ4SeHVvD/THsekq7Q93G+nlpy3d4ANoiKRWtmLCsDi2swPtpRYEIerf5u
        UBlUZh/6Sfu55qqQjI8518BsV6U8jgAez+rD1ykcaOGpp6/1UUah7+lbO4zgGzo4XZwUsHZJ+Y1bN
        YhO7zBCQ==;
Received: from [2601:1c0:6280:3f0::507c]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kSQ5K-00077m-1U; Tue, 13 Oct 2020 19:35:47 +0000
Subject: Re: [PATCH v2 2/6] ASoC: SOF: Introduce descriptors for SOF client
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        alsa-devel@alsa-project.org
Cc:     parav@mellanox.com, tiwai@suse.de, netdev@vger.kernel.org,
        ranjani.sridharan@linux.intel.com, fred.oh@linux.intel.com,
        linux-rdma@vger.kernel.org, dledford@redhat.com,
        broonie@kernel.org, jgg@nvidia.com, gregkh@linuxfoundation.org,
        kuba@kernel.org, dan.j.williams@intel.com, shiraz.saleem@intel.com,
        davem@davemloft.net, kiran.patil@intel.com
References: <20201005182446.977325-1-david.m.ertman@intel.com>
 <20201005182446.977325-3-david.m.ertman@intel.com>
 <076a0c53-0738-270e-845f-0ac968a4ea78@infradead.org>
 <d9f062ee-a5f0-b41c-c8f6-b81b374754fa@linux.intel.com>
 <9ef98f33-a0d3-579d-26e0-6046dd593eef@infradead.org>
 <5b447b78-626d-2680-8a48-53493e2084a2@infradead.org>
 <7192373a-0347-2d2d-74fc-6544f738b195@linux.intel.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <b07f6cbc-8e48-a4aa-bfcb-8a938fa00a38@infradead.org>
Date:   Tue, 13 Oct 2020 12:35:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <7192373a-0347-2d2d-74fc-6544f738b195@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/13/20 8:08 AM, Pierre-Louis Bossart wrote:
> 
>>>>>> +config SND_SOC_SOF_CLIENT
>>>>>> +    tristate
>>>>>> +    select ANCILLARY_BUS
>>>>>> +    help
>>>>>> +      This option is not user-selectable but automagically handled by
>>>>>> +      'select' statements at a higher level
>>>>>> +
>>>>>> +config SND_SOC_SOF_CLIENT_SUPPORT
>>>>>> +    bool "SOF enable clients"
>>>>>
>>>>> Tell users what "SOF" means.
>>>>
>>>> This option can only be reached if the user already selected the topic-level option. From there on the SOF acronym is used. Is this not enough?
>>>
>>> Yes, that's enough. I didn't see it. Sorry about that.
>>
>> Huh. I still don't see that Kconfig option.
>> Which patch is it in?
>>
>> I only saw patches 1,2,3 on LKML.
> 
> The Sound Open Firmware (SOF) driver is upstream since 2019, see https://elixir.bootlin.com/linux/latest/source/sound/soc/sof/Kconfig
> 
> What was shared in these patches is just an evolution to make the driver more modular to handle of 'subfunctions' with the auxiliary bus.
> 
> we'd love to hear your feedback if you think the help text can be improved. Thanks!
> 

OK, I looked at the SOF Kconfig files. They are mostly OK except for
missing '.' at the end of lots of sentences and a few other typos.

Do you want patches?

-- 
~Randy

