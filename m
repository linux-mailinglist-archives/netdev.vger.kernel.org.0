Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7E78195F61
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 20:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbgC0T4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 15:56:51 -0400
Received: from mga05.intel.com ([192.55.52.43]:64144 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726959AbgC0T4u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 15:56:50 -0400
IronPort-SDR: 8XIA5ezIjQjMF3cFbd4HGKzFCc2duFf9eXQxyylyRDoNS2OIJWuSwIAc+2EYsINDLAiNX/kG2x
 265o2FBnD5aQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2020 12:56:50 -0700
IronPort-SDR: /76o6ya0XdXqzddAmr/eEnlH0vaAzESl/ZGbjSGQ/aMk76XMlQs2q41P+NzXGqr0Zy63s71j7B
 fh8hPtBKPznQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,313,1580803200"; 
   d="scan'208";a="266314226"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.167.177]) ([10.212.167.177])
  by orsmga002.jf.intel.com with ESMTP; 27 Mar 2020 12:56:49 -0700
Subject: Re: [PATCH net-next v3 11/11] ice: add a devlink region for dumping
 NVM contents
To:     David Miller <davem@davemloft.net>
Cc:     jiri@resnulli.us, netdev@vger.kernel.org, kuba@kernel.org
References: <20200326183718.2384349-12-jacob.e.keller@intel.com>
 <20200326211908.GG11304@nanopsycho.orion>
 <83be9fef-c15e-c32b-7d0f-70c563318fb9@intel.com>
 <20200326.193726.945892559006461550.davem@davemloft.net>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <1b71c5aa-5e55-e058-a883-4398c86d93e4@intel.com>
Date:   Fri, 27 Mar 2020 12:56:49 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200326.193726.945892559006461550.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/26/2020 7:37 PM, David Miller wrote:
> From: Jacob Keller <jacob.e.keller@intel.com>
> Date: Thu, 26 Mar 2020 15:35:15 -0700
> 
>> I'm happy to send a v4 with this fix in, or to send a separate follow-up
>> patch which cleans up all of the devlink documents to avoid this.
>>
>> Dave, which would you prefer?
> 
> I'm going to apply this series as-is, so please do a follow-up.
> 
> Thanks.
> 

Will do.

Regards,
Jake
