Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B16F22651D6
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 23:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbgIJVDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 17:03:20 -0400
Received: from mga17.intel.com ([192.55.52.151]:36422 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726821AbgIJVDE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 17:03:04 -0400
IronPort-SDR: k6lfsi4pVFEut+kfQeniAKUETrw81D3so5FgwPyJa10CCuy+LghoRbV6q7Lf08HMT7tNoM09Ov
 NOX+A/bZ0cgw==
X-IronPort-AV: E=McAfee;i="6000,8403,9740"; a="138659697"
X-IronPort-AV: E=Sophos;i="5.76,413,1592895600"; 
   d="scan'208";a="138659697"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 14:03:04 -0700
IronPort-SDR: 0tSsQDonsIVV8W1ssffCANVjTQURURAVp+gYzqfye94FhjzSKKRpCe0NlLCNxlT92EofyOJ8+A
 OPfPPgBwqhCw==
X-IronPort-AV: E=Sophos;i="5.76,413,1592895600"; 
   d="scan'208";a="505969191"
Received: from pojenhsi-mobl1.amr.corp.intel.com (HELO [10.252.128.198]) ([10.252.128.198])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 14:03:03 -0700
Subject: Re: [net-next v4 0/5] devlink flash update overwrite mask
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, kuba@kernel.org,
        corbet@lwn.net, michael.chan@broadcom.com, luobin9@huawei.com,
        saeedm@mellanox.com, leon@kernel.org, idosch@mellanox.com,
        danieller@mellanox.com
References: <20200909222653.32994-1-jacob.e.keller@intel.com>
 <20200910.131355.396733870871815643.davem@davemloft.net>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <5cfbe096-a422-4f7b-0829-01e609b68982@intel.com>
Date:   Thu, 10 Sep 2020 14:03:02 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <20200910.131355.396733870871815643.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/10/2020 1:13 PM, David Miller wrote:
> From: Jacob Keller <jacob.e.keller@intel.com>
> Date: Wed,  9 Sep 2020 15:26:48 -0700
> 
>> This series introduces support for a new attribute to the flash update
>> command: DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK.
> 
> I think you really need to get rid of BIT() usage in the UAPI
> header as Jakub mentioned.
> 

Yep. I'll send a v5 with that and the 3 minor nits fixed up.

Thanks!

-Jake
