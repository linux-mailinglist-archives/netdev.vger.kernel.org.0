Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 596F0270909
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 00:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbgIRWxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 18:53:53 -0400
Received: from mga14.intel.com ([192.55.52.115]:60472 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725874AbgIRWxw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 18:53:52 -0400
IronPort-SDR: 2roBrgoAsxqkvToXXB6O5E5TWl2/Xv9NgRoX5EJHn2mhH2+ae6CY8VoAA9zLHLCBv4hr48j0gz
 RnCV0rafdUsg==
X-IronPort-AV: E=McAfee;i="6000,8403,9748"; a="159360479"
X-IronPort-AV: E=Sophos;i="5.77,276,1596524400"; 
   d="scan'208";a="159360479"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2020 15:53:44 -0700
IronPort-SDR: ETdYVeLfaMX1rodpemrrZvkhDHlCcNFZ0yeCvAMzHKdPtPr6CbcnLk80DxtTnbsu9NZu0pShM7
 /9ObVf/Ya9OQ==
X-IronPort-AV: E=Sophos;i="5.77,276,1596524400"; 
   d="scan'208";a="484412021"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.209.100.226]) ([10.209.100.226])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2020 15:53:42 -0700
Subject: Re: [PATCH net-next v2 3/8] devlink: Prepare code to fill multiple
 port function attributes
To:     Parav Pandit <parav@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Jiri Pirko <jiri@nvidia.com>
References: <20200917081731.8363-8-parav@nvidia.com>
 <20200917172020.26484-1-parav@nvidia.com>
 <20200917172020.26484-4-parav@nvidia.com>
 <0dc57740-48fb-d77f-dcdf-2607ef2dc545@intel.com>
 <BY5PR12MB4322D4FA0B0ED9E8537C72B3DC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <7b8cdb46-cb5a-445d-68d2-307a469747d8@intel.com>
Date:   Fri, 18 Sep 2020 15:53:39 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <BY5PR12MB4322D4FA0B0ED9E8537C72B3DC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/17/2020 8:35 PM, Parav Pandit wrote:
> Hi Jacob,
> 
>> From: Jacob Keller <jacob.e.keller@intel.com>
>> Sent: Friday, September 18, 2020 12:29 AM
>>
>>
>> We lost this comment in the move it looks like. I think it's still useful to keep for
>> clarity of why we're converting -EOPNOTSUPP in the return.
> You are right. It is a useful comment.
> However, it is already covered in include/net/devlink.h in the standard comment of the callback function.
> For new driver implementation, looking there will be more useful.
> So I guess its ok to drop from here.
> 

Yea if it's still in the header I don't think it's too important to keep
here.

Thanks!
-Jake
