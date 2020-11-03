Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E154B2A37B1
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 01:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbgKCAZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 19:25:09 -0500
Received: from mga17.intel.com ([192.55.52.151]:32167 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725940AbgKCAZI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 19:25:08 -0500
IronPort-SDR: fksL/kJrKMtwA5KKrEcNfCWeNKIxBWndXMct05r3tYMmTRmdq4QuW92xuL4IVUMq5Y0Ra9vjD2
 1UOQLWztjh0g==
X-IronPort-AV: E=McAfee;i="6000,8403,9793"; a="148830433"
X-IronPort-AV: E=Sophos;i="5.77,446,1596524400"; 
   d="scan'208";a="148830433"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2020 16:25:08 -0800
IronPort-SDR: N2crK+f4x89X2qScEdC1gVaCW8ZW4o3XW3OVcUPCZzDjzpSprZiJc2zcA1Ptp+oQyIKfqPyWj0
 PkA/yXXb4Zqw==
X-IronPort-AV: E=Sophos;i="5.77,446,1596524400"; 
   d="scan'208";a="538226605"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.254.181.231]) ([10.254.181.231])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2020 16:25:07 -0800
Subject: Re: [net-next 14/15] ice: join format strings to same line as
 ice_debug
To:     Saeed Mahameed <saeed@kernel.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>
References: <20201102222338.1442081-1-anthony.l.nguyen@intel.com>
 <20201102222338.1442081-15-anthony.l.nguyen@intel.com>
 <be6ac7df8079164d8e9cb42e381799629a4479fb.camel@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <65aceb04-c39d-facf-efaa-aa28ed480cae@intel.com>
Date:   Mon, 2 Nov 2020 16:25:04 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <be6ac7df8079164d8e9cb42e381799629a4479fb.camel@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/2/2020 3:07 PM, Saeed Mahameed wrote:
> On Mon, 2020-11-02 at 14:23 -0800, Tony Nguyen wrote:
>> From: Jacob Keller <jacob.e.keller@intel.com>
>>
>> When printing messages with ice_debug, align the printed string to
>> the
>> origin line of the message in order to ease debugging and tracking
>> messages back to their source.
>>
> 
> Just out of curiosity, you are only re-aligning the code and not the
> printed messages themselves. How would this help ? did you mean help
> with tracking the sources when doing grep like operations on the source
> code ? 
> 

The primary motivation is that the line number of the string now matches
the line number of the debug function statement, so there is better
alignment when using these line numbers with the dynamic debug messaging
system.

It's also a style thing, that came up on the list for some patches I
wrote for the ice flash update.. it was suggested to just keep the
message on the same line as the function. I felt that it was better to
go ahead and fix all of these files, so that future code is more likely
to use the preferred style rather than follow the pattern of older code.

Thanks,
Jake
