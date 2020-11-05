Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF0F2A8746
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 20:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732033AbgKETcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 14:32:43 -0500
Received: from mga05.intel.com ([192.55.52.43]:36334 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726996AbgKETcn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 14:32:43 -0500
IronPort-SDR: EI809Ta3QPLihzHLwPuVX4GkOcI+Zf48bjGh14JcfJXJJbWf11ograuLHc0yvkHOitDG80cAzK
 WAcPHjxndaag==
X-IronPort-AV: E=McAfee;i="6000,8403,9796"; a="254153466"
X-IronPort-AV: E=Sophos;i="5.77,454,1596524400"; 
   d="scan'208";a="254153466"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2020 11:32:42 -0800
IronPort-SDR: X+y1wice22ze5u8UH/r7/Lhh3EMQSy98/maUv2UJizrrh8Ql/VDQInL/x1alfiquMX9XlC00Zs
 a0fb1L7MzXxA==
X-IronPort-AV: E=Sophos;i="5.77,454,1596524400"; 
   d="scan'208";a="471774404"
Received: from umedepal-mobl2.amr.corp.intel.com (HELO [10.254.6.114]) ([10.254.6.114])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2020 11:32:41 -0800
Subject: Re: [PATCH v3 01/10] Add auxiliary bus support
To:     "Ertman, David M" <david.m.ertman@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Cc:     "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Takashi Iwai <tiwai@suse.de>, Mark Brown <broonie@kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Doug Ledford <dledford@redhat.com>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Fred Oh <fred.oh@linux.intel.com>,
        Parav Pandit <parav@mellanox.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Patil, Kiran" <kiran.patil@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>
References: <20201023003338.1285642-1-david.m.ertman@intel.com>
 <20201023003338.1285642-2-david.m.ertman@intel.com>
 <CAPcyv4i9s=CsO5VJOhPnS77K=bD0LTQ8TUAbhLd+0OmyU8YQ3g@mail.gmail.com>
 <DM6PR11MB284191BAA817540E52E4E2C4DDEE0@DM6PR11MB2841.namprd11.prod.outlook.com>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Message-ID: <f37a2b37-2fda-948d-1b8f-617395d43a08@linux.intel.com>
Date:   Thu, 5 Nov 2020 13:32:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <DM6PR11MB284191BAA817540E52E4E2C4DDEE0@DM6PR11MB2841.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>>> +module_init(auxiliary_bus_init);
>>> +module_exit(auxiliary_bus_exit);
>>> +
>>> +MODULE_LICENSE("GPL");
>>
>> Per above SPDX is v2 only, so...
>>
>> MODULE_LICENSE("GPL v2");
>>
> 
> added v2.

"GPL v2" is the same as "GPL" here, it does not have any additional meaning.

https://www.kernel.org/doc/html/latest/process/license-rules.html

“GPL”	Module is licensed under GPL version 2. This does not express any 
distinction between GPL-2.0-only or GPL-2.0-or-later. The exact license 
information can only be determined via the license information in the 
corresponding source files.

“GPL v2”	Same as “GPL”. It exists for historic reasons.

