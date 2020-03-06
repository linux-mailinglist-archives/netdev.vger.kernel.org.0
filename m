Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BDEE17B32D
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 01:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbgCFAzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 19:55:23 -0500
Received: from mga06.intel.com ([134.134.136.31]:15940 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726128AbgCFAzX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 19:55:23 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Mar 2020 16:55:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,520,1574150400"; 
   d="scan'208";a="413722639"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [134.134.177.106]) ([134.134.177.106])
  by orsmga005.jf.intel.com with ESMTP; 05 Mar 2020 16:55:21 -0800
Subject: Re: [PATCH net-next iproute2 1/2] Update devlink kernel header
To:     David Ahern <dsahern@gmail.com>, Parav Pandit <parav@mellanox.com>,
        netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@kernel.org, jiri@mellanox.com
References: <20200304040626.26320-1-parav@mellanox.com>
 <20200304040626.26320-2-parav@mellanox.com>
 <bfef88f7-c888-04b0-7d7d-dc1bb184d168@intel.com>
 <3281568c-72d3-2c02-adc3-4e3008cdf4ec@gmail.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <1517e035-8be1-d66b-92cb-727abdc36cd7@intel.com>
Date:   Thu, 5 Mar 2020 16:55:21 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <3281568c-72d3-2c02-adc3-4e3008cdf4ec@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/5/2020 4:43 PM, David Ahern wrote:
> On 3/5/20 5:42 PM, Jacob Keller wrote:
>> This hunk doesn't seem relevant to the patch and isn't mentioned in the
>> subject or description.
> 
> it was a sync of the header file. I drop those changes and do full uapi
> sync for iproute2 and then apply patches.
> 

Makes sense. Thanks for the explanation.
