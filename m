Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 097C822FB91
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 23:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbgG0VmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 17:42:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:54991 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726110AbgG0VmQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 17:42:16 -0400
IronPort-SDR: MkEQAqG30THxATV9XEHKvfJJ5upKbtiJUa/fbyAyuDNkqsQW9CW0dyaiuYwycCyufQbcp3+Heh
 RIhWjwylJuBA==
X-IronPort-AV: E=McAfee;i="6000,8403,9695"; a="148982361"
X-IronPort-AV: E=Sophos;i="5.75,403,1589266800"; 
   d="scan'208";a="148982361"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 14:42:15 -0700
IronPort-SDR: vF4ey2Qd/NyQHrAdZ0oDVxMtV20SGvdhWb5jp7xDOPyJRyThs+aoufIeiM2hmgIRTfF+ocJkJC
 KsXWVD6qg+vg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,404,1589266800"; 
   d="scan'208";a="303612020"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.56.18]) ([10.212.56.18])
  by orsmga002.jf.intel.com with ESMTP; 27 Jul 2020 14:42:15 -0700
Subject: Re: Broken link partner advertised reporting in ethtool
To:     Andrew Lunn <andrew@lunn.ch>, Michal Kubecek <mkubecek@suse.cz>
Cc:     Jamie Gloudon <jamie.gloudon@gmx.fr>, netdev@vger.kernel.org
References: <20200727154715.GA1901@gmx.fr>
 <871802ee-3b9a-87fb-4a16-db570828ef2d@intel.com>
 <20200727200912.GA1884@gmx.fr>
 <20200727204227.s2gv3hqszmpk7l7r@lion.mk-sys.cz>
 <20200727210141.GA1705504@lunn.ch>
 <20200727210843.kgcwrd6bpg65lyvj@lion.mk-sys.cz>
 <20200727212550.GC1705504@lunn.ch>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <51cb929e-ad40-3c76-8d6a-771038a70c94@intel.com>
Date:   Mon, 27 Jul 2020 14:42:14 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0.1
MIME-Version: 1.0
In-Reply-To: <20200727212550.GC1705504@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/27/2020 2:25 PM, Andrew Lunn wrote:
> On Mon, Jul 27, 2020 at 11:08:43PM +0200, Michal Kubecek wrote:
>> On Mon, Jul 27, 2020 at 11:01:41PM +0200, Andrew Lunn wrote:
>>>>   - the exact command you ran (including arguments)
>>>>   - expected output (or at least the relevant part)
>>>>   - actual output (or at least the relevant part)
>>>>   - output with dump of netlink messages, you can get it by enabling
>>>>     debugging flags, e.g. "ethtool --debug 0x12 eth0"
>>>  
>>> Hi Michal
>>>
>>> See if this helps.
>>>
>>> This is a Marvel Ethernet switch port using an Marvell PHY.
>>
>> Thank you. I think I can see the problem. Can you try the patch below?
> 
> Hi Michal
> 
> This is better.
> 

I have a proposed patch, about to send it.

Thanks,
Jake
