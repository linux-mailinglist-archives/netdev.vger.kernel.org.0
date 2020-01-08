Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0887134B56
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 20:14:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727761AbgAHTOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 14:14:39 -0500
Received: from mga04.intel.com ([192.55.52.120]:45236 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726363AbgAHTOi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jan 2020 14:14:38 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jan 2020 11:14:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,411,1571727600"; 
   d="scan'208";a="211639519"
Received: from jekeller-mobl.amr.corp.intel.com (HELO [134.134.177.84]) ([134.134.177.84])
  by orsmga007.jf.intel.com with ESMTP; 08 Jan 2020 11:14:38 -0800
Subject: Re: FW: [question] About triggering a region snapshot through the
 devlink cmd
To:     Alex Vesker <valex@mellanox.com>
Cc:     davem@davemloft.net, Jiri Pirko <jiri@mellanox.com>,
        linuxarm@huawei.com, linyunsheng@huawei.com,
        netdev@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>
References: <02874ECE860811409154E81DA85FBB58B26FA36F@fmsmsx101.amr.corp.intel.com>
 <HE1PR0502MB3771BD83B728249E6C21967AC33E0@HE1PR0502MB3771.eurprd05.prod.outlook.com>
 <HE1PR0502MB3771D512C2D23F551EB922F4C33E0@HE1PR0502MB3771.eurprd05.prod.outlook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <18867ab8-6200-20c6-6ce0-8c123609622f@intel.com>
Date:   Wed, 8 Jan 2020 11:14:38 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <HE1PR0502MB3771D512C2D23F551EB922F4C33E0@HE1PR0502MB3771.eurprd05.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/8/2020 4:15 AM, Alex Vesker wrote:
> I am a biased here but, devlink trigger can be useful... I am not aware
> of other alternatives,
> devlink health has it`s benefits but it is not devlink region. If you
> will decide to implement I can
> review the design, if Jiri is ok with the idea.
> 

Sure. I am not quite sure how long it will be till patches are on the
list, as I'm currently in the process of implementing devlink support
for one of the Intel drivers, and would be using that driver as an example.

Actually, come to think of it, I may just implement the region trigger
and use netdevsim as the example. That should enable those patches to
hit the list sooner than the patches for implementing devlink for the
ice driver.

I will Cc you for review when I send those patches.

Thanks,
Jake
