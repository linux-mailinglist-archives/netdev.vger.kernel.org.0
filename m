Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6110F2DADEF
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 14:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbgLONYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 08:24:07 -0500
Received: from mga11.intel.com ([192.55.52.93]:26023 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727053AbgLONX6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 08:23:58 -0500
IronPort-SDR: D1TB2IlYX2ukQomyo9Fp+4yToc+A++0HKSVI3mTguG234eCaSgXyr8OfGdT35qpJVIwcZ9NOdX
 G3qe+hMHpy3g==
X-IronPort-AV: E=McAfee;i="6000,8403,9835"; a="171364553"
X-IronPort-AV: E=Sophos;i="5.78,421,1599548400"; 
   d="scan'208";a="171364553"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2020 05:23:10 -0800
IronPort-SDR: jYmIOmy2/eGcHbaXjy4lRHBnOB0tckkaipLHd0Uhi2AxjwWMckjQHd0e2mkTAObhyfwBpOvCJb
 mIkGOifN5KUg==
X-IronPort-AV: E=Sophos;i="5.78,421,1599548400"; 
   d="scan'208";a="411927717"
Received: from sneftin-mobl.ger.corp.intel.com (HELO [10.214.238.87]) ([10.214.238.87])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2020 05:23:04 -0800
Subject: Re: Fw: [External] Re: [PATCH v4 0/4] Improve s0ix flows for systems
 i219LM
To:     Mark Pearson <markpearson@lenovo.com>,
        Mario Limonciello <mario.limonciello@dell.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        David Miller <davem@davemloft.net>,
        Aaron Ma <aaron.ma@canonical.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Stefan Assmann <sassmann@redhat.com>,
        "darcari@redhat.com" <darcari@redhat.com>,
        "Yijun.Shen@dell.com" <Yijun.Shen@dell.com>,
        "Perry.Yuan@dell.com" <Perry.Yuan@dell.com>,
        "anthony.wong@canonical.com" <anthony.wong@canonical.com>,
        "Ruinskiy, Dima" <dima.ruinskiy@intel.com>,
        "Efrati, Nir" <nir.efrati@intel.com>,
        "Lifshits, Vitaly" <vitaly.lifshits@intel.com>,
        "Neftin, Sasha" <sasha.neftin@intel.com>
References: <20201214153450.874339-1-mario.limonciello@dell.com>
 <80862f70-18a4-4f96-1b96-e2fad7cc2b35@redhat.com>
 <PS2PR03MB37505A15D3C9B7505D679D7BBDC70@PS2PR03MB3750.apcprd03.prod.outlook.com>
 <ae436f90-45b8-ba70-be57-d17641c4f79d@lenovo.com>
From:   "Neftin, Sasha" <sasha.neftin@intel.com>
Message-ID: <18c1c152-9298-a4c5-c4ed-92c9fd91ea8a@intel.com>
Date:   Tue, 15 Dec 2020 15:23:01 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <ae436f90-45b8-ba70-be57-d17641c4f79d@lenovo.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/14/2020 20:40, Mark Pearson wrote:
> Thanks Hans
> 
> On 14/12/2020 13:31, Mark Pearson wrote:
>>
>>
>> ------------------------------------------------------------------------
>> *From:* Hans de Goede <hdegoede@redhat.com>
>> *Sent:* December 14, 2020 13:24
>> *To:* Mario Limonciello <mario.limonciello@dell.com>; Jeff Kirsher
>> <jeffrey.t.kirsher@intel.com>; Tony Nguyen <anthony.l.nguyen@intel.com>;
>> intel-wired-lan@lists.osuosl.org <intel-wired-lan@lists.osuosl.org>;
>> David Miller <davem@davemloft.net>; Aaron Ma <aaron.ma@canonical.com>;
>> Mark Pearson <mpearson@lenovo.com>
>> *Cc:* linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>;
>> Netdev <netdev@vger.kernel.org>; Alexander Duyck
>> <alexander.duyck@gmail.com>; Jakub Kicinski <kuba@kernel.org>; Sasha
>> Netfin <sasha.neftin@intel.com>; Aaron Brown <aaron.f.brown@intel.com>;
>> Stefan Assmann <sassmann@redhat.com>; darcari@redhat.com
>> <darcari@redhat.com>; Yijun.Shen@dell.com <Yijun.Shen@dell.com>;
>> Perry.Yuan@dell.com <Perry.Yuan@dell.com>; anthony.wong@canonical.com
>> <anthony.wong@canonical.com>
>> *Subject:* [External] Re: [PATCH v4 0/4] Improve s0ix flows for systems
>> i219LM
>>   
>> Hi All,
>>
> <snip>
>>
>> ###
>>
>> I've added Mark Pearson from Lenovo to the Cc so that Lenovo
>> can investigate this issue further.
>>
>> Mark, this thread is about an issue with enabling S0ix support for
>> e1000e (i219lm) controllers. This was enabled in the kernel a
>> while ago, but then got disabled again on vPro / AMT enabled
>> systems because on some systems (Lenovo X1C7 and now also X1C8)
>> this lead to suspend/resume issues.
>>
>> When AMT is active then there is a handover handshake for the
>> OS to get access to the ethernet controller from the ME. The
>> Intel folks have checked and the Windows driver is using a timeout
>> of 1 second for this handshake, yet on Lenovo systems this is
>> taking 2 seconds. This likely has something to do with the
>> ME firmware on these Lenovo models, can you get the firmware
>> team at Lenovo to investigate this further ?
> Absolutely - I'll ask them to look into this again.
> 
we need to explain why on Windows systems required 1s and on Linux 
systems up to 2.5s - otherwise it is not reliable approach - you will 
encounter others buggy system.
(ME not POR on the Linux systems - is only one possible answer)
> We did try to make progress with this previously - but it got a bit
> stuck and hence the need for these patches....but I believe things may
> have changed a bit so it's worth trying again
> 
> Mark
> 
Sasha
