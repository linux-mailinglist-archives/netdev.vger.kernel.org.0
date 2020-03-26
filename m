Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C21119467E
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 19:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727907AbgCZS3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 14:29:03 -0400
Received: from mga12.intel.com ([192.55.52.136]:21966 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727354AbgCZS3D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 14:29:03 -0400
IronPort-SDR: 3FhGOQyVE4U/78NQpwAUlCqTq4qjBOT9V1SMO8AFsqdxGxKaXlGES7xw5beTXZNJ+zZzhmFiWA
 d7Nwm/bWrKSQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2020 11:29:03 -0700
IronPort-SDR: ETSg+odwDwUDyruq8v7oEbG5CIaOQwk0pb3ZmQp9CRvAdOdRxSoGmUKiCEyQ1bPu9QOTv8UXKH
 sUvBLMSmlUhA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,309,1580803200"; 
   d="scan'208";a="282596166"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.254.179.43]) ([10.254.179.43])
  by fmsmga002.fm.intel.com with ESMTP; 26 Mar 2020 11:29:03 -0700
Subject: Re: [net-next v2 00/11] implement DEVLINK_CMD_REGION_NEW
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jiri@resnulli.us
References: <20200326035157.2211090-1-jacob.e.keller@intel.com>
 <20200326.112734.1600378423635066696.davem@davemloft.net>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <f2301ba7-1c08-513b-e993-cff05091ddb4@intel.com>
Date:   Thu, 26 Mar 2020 11:29:02 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200326.112734.1600378423635066696.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/26/2020 11:27 AM, David Miller wrote:
> From: Jacob Keller <jacob.e.keller@intel.com>
> Date: Wed, 25 Mar 2020 20:51:46 -0700
> 
>> This is a second revision of the previous series to implement the
>> DEVLINK_CMD_REGION_NEW. The series can be viewed on lore.kernel.org at
>>
>> https://lore.kernel.org/netdev/20200324223445.2077900-1-jacob.e.keller@intel.com/
>>
>> This version includes the suggested cleanups from Jakub and Jiri on the
>> list, including the following changes, broken out by the v1 patch title.
>  ...
> 
> Based upon the review so far I'm expecting one more respin of this.
> 

Yep, I'm about to send a v3.
