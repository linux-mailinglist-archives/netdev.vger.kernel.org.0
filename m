Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D88192610EF
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 13:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729726AbgIHLsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 07:48:17 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:46899 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730128AbgIHLju (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 07:39:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1599565189; x=1631101189;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=F+j0JCQ1GOVdffMe15XLwWeslfZg0hQxxi1+nRfhBWA=;
  b=Uu8U1vN2aiZ9U6xUDsslhIanSUG2YoGzxD1V36m6HqK5UatUCVs42V/K
   iT5dJ/OxM67dceCsGUngssNgeygGopbssKHzVws6W4oMaIWwn3VG2MJx6
   3pY9gRnQGguCPNGX2RrJnjbq126x2GOYDF0Jiv2og86nxRRN39tPwpoB1
   spxBQok4vFWlCJ1wjfi8D4DkcqHJAuQX+j/VERg4ErXDND9IxFaN8mGfB
   fIIWM7ZdWwt5ZrHL+1pzfKfopKCy1rye+kjJM47TxvFEJ1i334FHv2NHV
   qM4GaWqtWIWEBod5vDvxSoWyhswuQNqcT1nuMs9/ZHJXQgXU8cZAZzbFT
   A==;
IronPort-SDR: UJwLxQvuqzI6LGuw+ZcNKEC8YY1cbiWNN1jw9hkfPBc15ECt57fXIKNF87X+91CTWoeakQp5Y/
 RkBY/39EGW9iU/VBjbvfE17VrReQ7tgOjNnmC41ElliW39jSfmKdW/eLhaBwhK6idhdfOTizZb
 txxCGTlnKakYI5A9+OXP+TrSrj3PtV6QmP8kjBnY5GhbDIm4uAli/m+WH/hvEfV4Dzf00Ip7vW
 QfKKx+xwVTvS2Fa2cnoLaAvS8UeGmGvAjcIcs7Ly8VkSRz9c7FEb+k/A5PDTZ32TvR7T2j/Fl5
 xMI=
X-IronPort-AV: E=Sophos;i="5.76,405,1592895600"; 
   d="scan'208";a="94807242"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Sep 2020 04:35:10 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 8 Sep 2020 04:34:51 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 8 Sep 2020 04:34:37 -0700
Date:   Tue, 8 Sep 2020 13:35:09 +0200
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Henrik Bjoernlund - M31679 <Henrik.Bjoernlund@microchip.com>
CC:     Nikolay Aleksandrov <nikolay@nvidia.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        Horatiu Vultur - M31836 <Horatiu.Vultur@microchip.com>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        UNGLinuxDriver <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH RFC 0/7] net: bridge: cfm: Add support for Connectivity
 Fault Management(CFM)
Message-ID: <20200908113509.hvuknvmr54no2cy4@lx-anielsen.microsemi.net>
References: <20200904091527.669109-1-henrik.bjoernlund@microchip.com>
 <20200904154406.4fe55b9d@hermes.lan>
 <20200906182129.274fimjyo7l52puj@soft-dev3.localdomain>
 <b36a32dbf3b4b315fc4cbfdf06084b75a7c58729.camel@nvidia.com>
 <BY5PR11MB3928DF9AC75B8AEC2FBD2256ED290@BY5PR11MB3928.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <BY5PR11MB3928DF9AC75B8AEC2FBD2256ED290@BY5PR11MB3928.namprd11.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 08.09.2020 11:04, Henrik Bjoernlund - M31679 wrote:
>>On Sun, 2020-09-06 at 20:21 +0200, Horatiu Vultur wrote:
>>> The 09/04/2020 15:44, Stephen Hemminger wrote:
>>> > On Fri, 4 Sep 2020 09:15:20 +0000 Henrik Bjoernlund
>>> > <henrik.bjoernlund@microchip.com> wrote:
>>Hi, I also had the same initial thought - this really doesn't seem to
>>affect the bridge in any way, it's only collecting and transmitting
>>information. I get that you'd like to use the bridge as a passthrough
>>device to switchdev to program your hw, could you share what would be
>>offloaded more specifically ?
>Yes.
>
>The HW will offload the periodic sending of CCM frames, and the
>reception.
>
>If CCM frames are not received as expected, it will raise an interrupt.
>
>This means that all the functionality provided in this series will be
>offloaded to HW.
>
>The offloading is very important on our HW where we have a small CPU,
>serving many ports, with a high frequency of CFM frames.
>
>The HW also support Link-Trace and Loop-back, which we may come back to
>later.
>
>>All you do - snooping and blocking these packets can easily be done
>>from user- space with the help of ebtables, but since we need to have
>>a software implementation/fallback of anything being offloaded via
>>switchdev we might need this after all, I'd just prefer to push as
>>much as possible to user-space.
In addition to Henriks comment, it is worth mentioning that we are
trying to push as much of the functionallity to user-space (learnings
from the MRP discussions).

This is why there are currently no in-kernel users of the CCM-lose
singnal. When a CCM-defect is happening the network typically needs to
be re-configured. This we are trying to keep in user-space.

>>I plan to review the individual patches tomorrow.
Thanks.

/Allan
