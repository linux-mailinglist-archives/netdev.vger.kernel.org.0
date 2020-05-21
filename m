Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA8BE1DD9ED
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 00:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730597AbgEUWKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 18:10:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:1935 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728701AbgEUWJ7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 18:09:59 -0400
IronPort-SDR: VlfM6Tp8BxvQMYrJvkbZF4mtA3bxHs6TuUeLr6JzSxizipPa/UMjOimlj8sVn/DqSO6UT9EjW7
 vRGuBACuADgQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 15:09:59 -0700
IronPort-SDR: 6q5jw9foDBhl9m/skTxWC9jtle8s5rzxSVihR0YJKEffyLxEs14Kcb+A1tssDf6ZM0pIjZqR+o
 /OFAAxtgib7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,419,1583222400"; 
   d="scan'208";a="440639023"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.213.183.94]) ([10.213.183.94])
  by orsmga005.jf.intel.com with ESMTP; 21 May 2020 15:09:57 -0700
Subject: Re: devlink interface for asynchronous event/messages from firmware?
To:     Jakub Kicinski <kuba@kernel.org>, Ido Schimmel <idosch@idosch.org>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        petrm@mellanox.com, amitc@mellanox.com
References: <fea3e7bc-db75-ce15-1330-d80483267ee2@intel.com>
 <20200520171655.08412ba5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <b0435043-269b-9694-b43e-f6740d1862c9@intel.com>
 <20200521205213.GA1093714@splinter>
 <239b02dc-7a02-dcc3-a67c-85947f92f374@intel.com>
 <20200521145113.21f772bf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <0d96e75a-64ee-b7be-786c-7015f65625a3@intel.com>
Date:   Thu, 21 May 2020 15:09:57 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200521145113.21f772bf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/21/2020 2:51 PM, Jakub Kicinski wrote:
> On Thu, 21 May 2020 13:59:32 -0700 Jacob Keller wrote:
>>>> So the ice firmware can optionally send diagnostic debug messages via
>>>> its control queue. The current solutions we've used internally
>>>> essentially hex-dump the binary contents to the kernel log, and then
>>>> these get scraped and converted into a useful format for human consumption.
>>>>
>>>> I'm not 100% of the format, but I know it's based on a decoding file
>>>> that is specific to a given firmware image, and thus attempting to tie
>>>> this into the driver is problematic.  
>>>
>>> You explained how it works, but not why it's needed :)  
>>
>> Well, the reason we want it is to be able to read the debug/diagnostics
>> data in order to debug issues that might be related to firmware or
>> software mis-use of firmware interfaces.
>>
>> By having it be a separate interface rather than trying to scrape from
>> the kernel message buffer, it becomes something we can have as a
>> possibility for debugging in the field.
> 
> For pure debug/tracing perhaps trace_devlink_hwerr() is the right fit?
> 
> Right Ido?
> 

Hm, yes that might be more suitable for this purpose. I'll take a look
at it!

Thanks,
Jake
