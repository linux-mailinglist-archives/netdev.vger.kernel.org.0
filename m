Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9FF2EEA93
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 01:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729684AbhAHAwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 19:52:22 -0500
Received: from mga03.intel.com ([134.134.136.65]:29145 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727695AbhAHAwV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 19:52:21 -0500
IronPort-SDR: mTFixJGiuUIJrruQKbpQ8uxvlerOsK0FWRwvT9Y/oQYX81vJhPL1XcOyBPUhvHiuU5ZWRLfAl+
 2KSNPgGfbEOg==
X-IronPort-AV: E=McAfee;i="6000,8403,9857"; a="177619858"
X-IronPort-AV: E=Sophos;i="5.79,330,1602572400"; 
   d="scan'208";a="177619858"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2021 16:51:40 -0800
IronPort-SDR: tT3u3vw48Msccji5GBwP1LuGc5GcfVfkkRKxhxl8/xzfRxf1C5gr5iElFBe0QMd0o9tb1ikYuO
 PPCtyLGPBQAQ==
X-IronPort-AV: E=Sophos;i="5.79,330,1602572400"; 
   d="scan'208";a="379924893"
Received: from shao2-debian.sh.intel.com (HELO [10.239.13.117]) ([10.239.13.117])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2021 16:51:37 -0800
Subject: Re: [PATCH v3 net-next 08/12] net: make dev_get_stats return void
To:     Vladimir Oltean <olteanv@gmail.com>,
        kernel test robot <lkp@intel.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kbuild-all@lists.01.org,
        clang-built-linux@googlegroups.com, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>
References: <20210107094951.1772183-9-olteanv@gmail.com>
 <202101072035.p3B0IIfz-lkp@intel.com> <20210107131558.lcmuhqymqvtos2d6@skbuf>
From:   Rong Chen <rong.a.chen@intel.com>
Message-ID: <771f44df-5da8-9e85-7854-bf69d3d335ba@intel.com>
Date:   Fri, 8 Jan 2021 08:50:46 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20210107131558.lcmuhqymqvtos2d6@skbuf>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/7/21 9:15 PM, Vladimir Oltean wrote:
> On Thu, Jan 07, 2021 at 09:01:03PM +0800, kernel test robot wrote:
>> Hi Vladimir,
>>
>> I love your patch! Yet something to improve:
> These are not scheduled to run on RFC series, are they?
> This report came within 3 hours of me posting an identical version to
> the RFC series from two days ago:
> https://patchwork.kernel.org/project/netdevbpf/patch/20210105185902.3922928-9-olteanv@gmail.com/
>

Hi Vladimir,

The issue was found with a rand config which was generated in Jan 7,
the bot didn't notice the issue in the RFC series:

url:https://github.com/0day-ci/linux/commits/Vladimir-Oltean/Make-ndo_get_stats64-sleepable/20210107-175746
base:https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git  3db1a3fa98808aa90f95ec3e0fa2fc7abf28f5c9
config: x86_64-randconfig-a005-20210107 (attached as .config)

Best Regards,
Rong Chen

