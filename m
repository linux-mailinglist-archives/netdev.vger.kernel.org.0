Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 409F48C369
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 23:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbfHMVPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 17:15:35 -0400
Received: from mga04.intel.com ([192.55.52.120]:64080 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726188AbfHMVPf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 17:15:35 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Aug 2019 14:15:34 -0700
X-IronPort-AV: E=Sophos;i="5.64,382,1559545200"; 
   d="scan'208";a="167178710"
Received: from tsduncan-ubuntu.jf.intel.com (HELO [10.7.169.130]) ([10.7.169.130])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/AES256-SHA; 13 Aug 2019 14:15:34 -0700
Subject: Re: [PATCH net-next] net/ncsi: allow to customize BMC MAC Address
 offset
To:     Ben Wei <benwei@fb.com>, Tao Ren <taoren@fb.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S.Miller" <davem@davemloft.net>,
        William Kennington <wak@google.com>
References: <20190807002118.164360-1-taoren@fb.com>
 <20190807112518.644a21a2@cakuba.netronome.com>
 <20190807184143.GE26047@lunn.ch>
 <806a76a8-229a-7f24-33c7-2cf2094f3436@fb.com>
 <20190808133209.GB32706@lunn.ch>
 <77762b10-b8e7-b8a4-3fc0-e901707a1d54@fb.com>
 <20190808211629.GQ27917@lunn.ch>
 <ac22bbe0-36ca-b4b9-7ea7-7b1741c2070d@fb.com>
 <20190808230312.GS27917@lunn.ch>
 <f1519844-4e21-a9a4-1a69-60c37bd07f75@fb.com>
 <10079A1AC4244A41BC7939A794B72C238FCE0E03@fmsmsx104.amr.corp.intel.com>
 <bc9da695-3fd3-6643-8e06-562cc08fbc62@linux.intel.com>
 <dc0382c9-7995-edf5-ee1c-508b0f759c3d@linux.intel.com>
 <faa1b3c9-9ba3-0fff-e1d4-f6dddb60c52c@fb.com>
 <CH2PR15MB3686B3A20A231FC111C42F40A3D20@CH2PR15MB3686.namprd15.prod.outlook.com>
From:   Terry Duncan <terry.s.duncan@linux.intel.com>
Message-ID: <39309d92-742b-ca5f-dea5-b93ad003119d@linux.intel.com>
Date:   Tue, 13 Aug 2019 14:15:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CH2PR15MB3686B3A20A231FC111C42F40A3D20@CH2PR15MB3686.namprd15.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/13/19 12:52 PM, Ben Wei wrote:
>> On 8/13/19 9:31 AM, Terry Duncan wrote:
>>> Tao, in your new patch will it be possible to disable the setting of the BMC MAC?  I would like to be able to send NCSI_OEM_GET_MAC perhaps with netlink (TBD) to get the system address without it affecting the BMC address.
>>>
>>> I was about to send patches to add support for the Intel adapters when I saw this thread.
>>> Thanks,
>>> Terry
>>
> Hi Terry,
> Do you plan to monitor and configure NIC through use space programs via netlink?  I'm curious if you have additional use cases.
> I had planned to add some daemon in user space to monitor NIC through NC-SI, primarily to log AENs, check link status and retrieve NIC counters.
> We can collaborate on these if they align with your needs as well.
> 
> Also about Intel NIC, do you not plan to derive system address from BMC MAC? Is the BMC MAC independent of system address?
> 
> Thanks,
> -Ben
> 
Hi Ben,
Intel has in the past programmed BMC MACs with an offset from the system 
MAC address of the first shared interface. We have found this approach 
causes problems and adds complexity when system interfaces / OCP cards 
are added or removed or disabled in BIOS. Our approach in OpenBMC is to 
keep this simple - provide means for the BMC MAC addresses to be set in 
manufacturing and persist them.

We do also have some of the same use cases you mention.
Thanks,
Terry
