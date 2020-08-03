Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E28623AAE8
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 18:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbgHCQv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 12:51:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:50810 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726489AbgHCQv0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 12:51:26 -0400
IronPort-SDR: 4lFB9fjOQp2detyJiVTogbZ0QG4tYNiVsHgiMeQfpJzT+PltBVOon3JJB2iU+dPettDtbnNEFx
 U3sF5N5W8iLg==
X-IronPort-AV: E=McAfee;i="6000,8403,9702"; a="170245691"
X-IronPort-AV: E=Sophos;i="5.75,430,1589266800"; 
   d="scan'208";a="170245691"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2020 09:51:25 -0700
IronPort-SDR: 4y0kdBbtKEO16CMXPS84WUoCPTbFdxCSwdBGej9/lu5em/luRQ4RN/yMVkjoInW2iZhtYZXNdX
 bv4IQVmLM6tw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,430,1589266800"; 
   d="scan'208";a="366446222"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.196.183]) ([10.212.196.183])
  by orsmga001.jf.intel.com with ESMTP; 03 Aug 2020 09:51:25 -0700
Subject: Re: [net-next v2 0/5] devlink flash update overwrite mask
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Bin Luo <luobin9@huawei.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Danielle Ratson <danieller@mellanox.com>
References: <20200801002159.3300425-1-jacob.e.keller@intel.com>
 <20200803152800.GC2290@nanopsycho>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <1947fb54-fc37-9448-b3f6-bd8f6f64bea6@intel.com>
Date:   Mon, 3 Aug 2020 09:51:24 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0.1
MIME-Version: 1.0
In-Reply-To: <20200803152800.GC2290@nanopsycho>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/3/2020 8:28 AM, Jiri Pirko wrote:

> 
> I'm missing examples in the cover letter. It is much easier to
> understand the nature of the patchset with examples. Could you please
> repost with them?
> 
> Thanks!
> 


I'm not sure what you're asking for here. If by example of the command
line interface in devlink, there are some in the tests for netdevsim
which I could copy to the cover letter I guess?
