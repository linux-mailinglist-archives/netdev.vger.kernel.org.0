Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5992028C6C3
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 03:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbgJMBbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 21:31:38 -0400
Received: from mga12.intel.com ([192.55.52.136]:29193 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728093AbgJMBbh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 21:31:37 -0400
IronPort-SDR: IBjkxJdRtG0HuIWJFdXWomaNDZT8CwHWIIodjOPGJxwLxY5SVkxiv5PgWL1hIYjZDlAk1D77p/
 wxQfLG9x1KSw==
X-IronPort-AV: E=McAfee;i="6000,8403,9772"; a="145147789"
X-IronPort-AV: E=Sophos;i="5.77,369,1596524400"; 
   d="scan'208";a="145147789"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 18:31:35 -0700
IronPort-SDR: 8nverdQOerGDbZhsc1/oEWJGEfLJUjNpq/i4L3ZAYsgubzJc4pxXNrG/QJbXuOrwt1r48p2ymn
 sWGwO5uAlxHA==
X-IronPort-AV: E=Sophos;i="5.77,369,1596524400"; 
   d="scan'208";a="530189997"
Received: from krlocke-mobl.amr.corp.intel.com (HELO [10.209.8.93]) ([10.209.8.93])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 18:31:33 -0700
Subject: Re: [PATCH v2 2/6] ASoC: SOF: Introduce descriptors for SOF client
To:     Randy Dunlap <rdunlap@infradead.org>,
        Dave Ertman <david.m.ertman@intel.com>,
        alsa-devel@alsa-project.org
Cc:     tiwai@suse.de, broonie@kernel.org, linux-rdma@vger.kernel.org,
        jgg@nvidia.com, dledford@redhat.com, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        ranjani.sridharan@linux.intel.com, fred.oh@linux.intel.com,
        parav@mellanox.com, shiraz.saleem@intel.com,
        dan.j.williams@intel.com, kiran.patil@intel.com
References: <20201005182446.977325-1-david.m.ertman@intel.com>
 <20201005182446.977325-3-david.m.ertman@intel.com>
 <076a0c53-0738-270e-845f-0ac968a4ea78@infradead.org>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Message-ID: <d9f062ee-a5f0-b41c-c8f6-b81b374754fa@linux.intel.com>
Date:   Mon, 12 Oct 2020 20:31:32 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <076a0c53-0738-270e-845f-0ac968a4ea78@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>> +config SND_SOC_SOF_CLIENT
>> +	tristate
>> +	select ANCILLARY_BUS
>> +	help
>> +	  This option is not user-selectable but automagically handled by
>> +	  'select' statements at a higher level
>> +
>> +config SND_SOC_SOF_CLIENT_SUPPORT
>> +	bool "SOF enable clients"
> 
> Tell users what "SOF" means.

This option can only be reached if the user already selected the 
topic-level option. From there on the SOF acronym is used. Is this not 
enough?

config SND_SOC_SOF_TOPLEVEL
	bool "Sound Open Firmware Support"
	help
	  This adds support for Sound Open Firmware (SOF). SOF is a free and
	  generic open source audio DSP firmware for multiple devices.
	  Say Y if you have such a device that is supported by SOF.

> 
>> +	depends on SND_SOC_SOF
>> +	help
>> +	  This adds support for ancillary client devices to separate out the debug
>> +	  functionality for IPC tests, probes etc. into separate devices. This
>> +	  option would also allow adding client devices based on DSP FW
> 
> spell out firmware

agree on this one.

> 
>> +	  capabilities and ACPI/OF device information.
>> +	  Say Y if you want to enable clients with SOF.
>> +	  If unsure select "N".
>> +
> 
> 
