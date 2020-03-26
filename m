Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38A3D194ABE
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 22:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727393AbgCZVht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 17:37:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:53781 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726067AbgCZVht (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 17:37:49 -0400
IronPort-SDR: kyJc70Rro1qZYLyJHvErWetftl9ipn910WgCHeH98PY3/2ArDE5HxT26KNVqjnVirhe7Elu7vg
 aGb4ToGHwg2g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2020 14:37:49 -0700
IronPort-SDR: 59W2Lrxa2jVKedmaY1szt9nCrBb7mGbqZdZULPqadmWava5Oq9ukgtA2q4po0YxyTTXyifqhst
 3OH/hc01rxAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,309,1580803200"; 
   d="scan'208";a="358288814"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.254.179.43]) ([10.254.179.43])
  by fmsmga001.fm.intel.com with ESMTP; 26 Mar 2020 14:37:48 -0700
Subject: Re: [PATCH net-next v3 06/11] devlink: extract snapshot id allocation
 to helper function
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
References: <20200326183718.2384349-1-jacob.e.keller@intel.com>
 <20200326183718.2384349-7-jacob.e.keller@intel.com>
 <20200326211526.GD11304@nanopsycho.orion>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <b9c54aa9-0050-4d4f-cbb3-78ce540dcc81@intel.com>
Date:   Thu, 26 Mar 2020 14:37:47 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200326211526.GD11304@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/26/2020 2:15 PM, Jiri Pirko wrote:
> Thu, Mar 26, 2020 at 07:37:13PM CET, jacob.e.keller@intel.com wrote:
>> A future change is going to implement a new devlink command to request
>> a snapshot on demand. As part of this, the logic for handling the
>> snapshot ids will be refactored. To simplify the snapshot id allocation
>> function, move it to a separate function prefixed by `__`. This helper
>> function will assume the lock is held.
>>
>> While no other callers will exist, it simplifies refactoring the logic
>> because there is no need to complicate the function with gotos to handle
>> unlocking on failure.
>>
>> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> 
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> 
> For the 3rd time. I'm not sure why you don't took this :/
> 

Missed it while going over all the emails to take in review.
