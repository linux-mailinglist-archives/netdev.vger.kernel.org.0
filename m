Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4FB13752A
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 18:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728520AbgAJRrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 12:47:33 -0500
Received: from mga09.intel.com ([134.134.136.24]:10812 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728032AbgAJRrd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 12:47:33 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jan 2020 09:47:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,417,1571727600"; 
   d="scan'208";a="224260249"
Received: from unknown (HELO [134.134.177.84]) ([134.134.177.84])
  by orsmga003.jf.intel.com with ESMTP; 10 Jan 2020 09:47:31 -0800
Subject: Re: [PATCH 1/2] devlink: correct misspelling of snapshot
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, valex@mellanox.com
References: <20200109190821.1335579-1-jacob.e.keller@intel.com>
 <20200110093636.GK2235@nanopsycho.orion>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <4eeb5bca-19bd-509f-ed9c-e8891f6022fc@intel.com>
Date:   Fri, 10 Jan 2020 09:47:31 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200110093636.GK2235@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/10/2020 1:36 AM, Jiri Pirko wrote:
> Thu, Jan 09, 2020 at 08:08:20PM CET, jacob.e.keller@intel.com wrote:
>> The function to obtain a unique snapshot id was mistakenly typo'd as
>> devlink_region_shapshot_id_get. Fix this typo by renaming the function
>> and all of its users.
>>
>> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> 
> If you want to send this as a patchset, please provide a cover letter.
> 
> This patch looks fine to me.
> 
> Acked-by: Jiri Pirko <jiri@mellanox.com>
> 

I don't really care about it being merged as a series, I just searched
for the shapshot typo and tried to fix it everywhere.

It doesn't seem worth the effort to resend with a cover letter..

Thanks,
Jake
