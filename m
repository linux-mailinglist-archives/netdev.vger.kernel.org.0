Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE70D28D504
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 21:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729209AbgJMT5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 15:57:46 -0400
Received: from mga12.intel.com ([192.55.52.136]:64648 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728094AbgJMT5q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Oct 2020 15:57:46 -0400
IronPort-SDR: 0j9C6qPJBqdgbSSAkPUOZPSi1IMO2Vj40o2cze5+43l9N/Q0PME166yDS1NAL42TpHy3K5/mJx
 ovU8xKavhNyg==
X-IronPort-AV: E=McAfee;i="6000,8403,9773"; a="145292200"
X-IronPort-AV: E=Sophos;i="5.77,371,1596524400"; 
   d="scan'208";a="145292200"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2020 12:57:45 -0700
IronPort-SDR: d0IlcAIZDMxhhDk4Vn2AdgtgrpwB9JQaofY6SZeFhcib7oole0qgEOyzyHL1s4NdDdNZIlJH9b
 0FpHvLq3v3CQ==
X-IronPort-AV: E=Sophos;i="5.77,371,1596524400"; 
   d="scan'208";a="390428718"
Received: from maryannn-mobl.amr.corp.intel.com (HELO [10.209.70.94]) ([10.209.70.94])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2020 12:57:43 -0700
Subject: Re: [PATCH v2 2/6] ASoC: SOF: Introduce descriptors for SOF client
To:     Randy Dunlap <rdunlap@infradead.org>,
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
 <b07f6cbc-8e48-a4aa-bfcb-8a938fa00a38@infradead.org>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Message-ID: <91f0e062-5878-562c-c055-5dc597d4841f@linux.intel.com>
Date:   Tue, 13 Oct 2020 14:57:07 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <b07f6cbc-8e48-a4aa-bfcb-8a938fa00a38@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>>>>>>> +config SND_SOC_SOF_CLIENT_SUPPORT
>>>>>>> +    bool "SOF enable clients"
>>>>>>
>>>>>> Tell users what "SOF" means.
>>>>>
>>>>> This option can only be reached if the user already selected the topic-level option. From there on the SOF acronym is used. Is this not enough?
>>>>
>>>> Yes, that's enough. I didn't see it. Sorry about that.
>>>
>>> Huh. I still don't see that Kconfig option.
>>> Which patch is it in?
>>>
>>> I only saw patches 1,2,3 on LKML.
>>
>> The Sound Open Firmware (SOF) driver is upstream since 2019, see https://elixir.bootlin.com/linux/latest/source/sound/soc/sof/Kconfig
>>
>> What was shared in these patches is just an evolution to make the driver more modular to handle of 'subfunctions' with the auxiliary bus.
>>
>> we'd love to hear your feedback if you think the help text can be improved. Thanks!
>>
> 
> OK, I looked at the SOF Kconfig files. They are mostly OK except for
> missing '.' at the end of lots of sentences and a few other typos.
> 
> Do you want patches?

Sure! Thanks in advance.
