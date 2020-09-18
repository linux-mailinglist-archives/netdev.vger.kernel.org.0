Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F046027090F
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 01:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbgIRXHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 19:07:34 -0400
Received: from mga14.intel.com ([192.55.52.115]:61468 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726119AbgIRXHe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 19:07:34 -0400
IronPort-SDR: GQnVTufT/RiVJwA/dwIqov12CvmQznhmyqu00u1ltBpVZeX3vZA5wWu/GuXwnJ89Ue/x+bfp10
 gYm8wJ2mchFg==
X-IronPort-AV: E=McAfee;i="6000,8403,9748"; a="159361656"
X-IronPort-AV: E=Sophos;i="5.77,276,1596524400"; 
   d="scan'208";a="159361656"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2020 16:07:33 -0700
IronPort-SDR: +Jj++1dXzcHL8EufSsd1S5V17zq0dozd2eJcbymOpQKbx83SZU+Mt0wI6xeUD5Uv5FBtaXKghy
 acQ9rgiO/91Q==
X-IronPort-AV: E=Sophos;i="5.77,276,1596524400"; 
   d="scan'208";a="484417788"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.209.100.226]) ([10.209.100.226])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2020 16:07:32 -0700
Subject: Re: [net-next v6 0/5] devlink flash update overwrite mask
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, kuba@kernel.org,
        corbet@lwn.net, michael.chan@broadcom.com, luobin9@huawei.com,
        saeedm@mellanox.com, leon@kernel.org, idosch@mellanox.com,
        danieller@mellanox.com
References: <20200918004529.533989-1-jacob.e.keller@intel.com>
 <20200918.140457.1532137508491847343.davem@davemloft.net>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <be430c1c-b01b-ad04-b800-5f93d670194a@intel.com>
Date:   Fri, 18 Sep 2020 16:07:32 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200918.140457.1532137508491847343.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/18/2020 2:04 PM, David Miller wrote:
> From: Jacob Keller <jacob.e.keller@intel.com>
> Date: Thu, 17 Sep 2020 17:45:24 -0700
> 
>> This series introduces support for a new attribute to the flash update
>> command: DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK.
>>
>> This attribute is a bitfield which allows userspace to specify what set of
>> subfields to overwrite when performing a flash update for a device.
>>
>> The intention is to support the ability to control the behavior of
>> overwriting the configuration and identifying fields in the Intel ice device
>> flash update process. This is necessary  as the firmware layout for the ice
>> device includes some settings and configuration within the same flash
>> section as the main firmware binary.
>  ...
> 
> There are a lot of rejects due to some recent mlxsw changes, could you
> please respin?
> 
> Thank you.
> 

Yep.

Thanks,
Jake
