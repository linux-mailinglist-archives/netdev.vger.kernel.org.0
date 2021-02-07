Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0060312262
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 09:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbhBGIF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 03:05:26 -0500
Received: from mga09.intel.com ([134.134.136.24]:15635 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229445AbhBGIFY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Feb 2021 03:05:24 -0500
IronPort-SDR: Tj7NMYLAm+NYm/XLcPVWF66V1/RUVACZK62yrCdZMVKxcrN5L+EprEaC2sEqx+0t55QFHmqLed
 k78sYPD4lqTg==
X-IronPort-AV: E=McAfee;i="6000,8403,9887"; a="181738074"
X-IronPort-AV: E=Sophos;i="5.81,159,1610438400"; 
   d="scan'208";a="181738074"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2021 00:04:43 -0800
IronPort-SDR: oQLtF+DULm/Xn7UJ/5BPDZ10bHvpTDeTUrnAz5Ajfpnj5VSi9CMq4xx4MrU9L2TIoTBsGGwuyo
 pSwexmgD0L0g==
X-IronPort-AV: E=Sophos;i="5.81,159,1610438400"; 
   d="scan'208";a="394634633"
Received: from shao2-debian.sh.intel.com (HELO [10.239.13.11]) ([10.239.13.11])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2021 00:04:41 -0800
Subject: Re: [kbuild-all] Re: [PATCH net-next 1/7] netdevsim: Add support for
 add and delete of a PCI PF port
To:     Parav Pandit <parav@nvidia.com>, kernel test robot <lkp@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Cc:     "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>
References: <20210206125551.8616-2-parav@nvidia.com>
 <202102062248.3PibXnkM-lkp@intel.com>
 <BY5PR12MB432220A4F010C281CD28FA65DCB09@BY5PR12MB4322.namprd12.prod.outlook.com>
From:   Rong Chen <rong.a.chen@intel.com>
Message-ID: <816a06d4-8c46-26f9-3999-0eb7684b782c@intel.com>
Date:   Sun, 7 Feb 2021 16:04:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <BY5PR12MB432220A4F010C281CD28FA65DCB09@BY5PR12MB4322.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/7/21 3:59 PM, Parav Pandit wrote:
>
>> From: kernel test robot <lkp@intel.com>
>> Sent: Saturday, February 6, 2021 8:05 PM
>>
>> Hi Parav,
>>
>> Thank you for the patch! Perhaps something to improve:
>>
>> [auto build test WARNING on net-next/master]
>>
>> url:    https://github.com/0day-ci/linux/commits/Parav-Pandit/netdevsim-
>> port-add-delete-support/20210206-210153
>> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
>> 6626a0266566c5aea16178c5e6cd7fc4db3f2f56
> This commit tag doesn't contain the devlink patches required upto commit 142d93d12dc1.
> Can you please update the 0day-ci to move to at least commit 142d93d12dc1?

Thanks for the feedback, we'll take a look.

Best Regards,
Rong Chen

>
>>     drivers/net/netdevsim/port_function.c:269:6: warning: variable 'err' set
>> but not used [-Wunused-but-set-variable]
>>       269 |  int err = 0;
>>           |      ^~~
> Sending v2 to fix this warning.
> _______________________________________________
> kbuild-all mailing list -- kbuild-all@lists.01.org
> To unsubscribe send an email to kbuild-all-leave@lists.01.org

