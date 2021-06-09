Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 135E53A207D
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 01:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbhFIXJS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 9 Jun 2021 19:09:18 -0400
Received: from mga03.intel.com ([134.134.136.65]:6498 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229507AbhFIXJR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 19:09:17 -0400
IronPort-SDR: +5Ss1y8ywapfIPMQjj037Vx2pjrFEytqma0dftewjKuBrH4NKrPXA3wWk12Wuf0oO1Ykg3EaVL
 PokxLw+kskBg==
X-IronPort-AV: E=McAfee;i="6200,9189,10010"; a="205219239"
X-IronPort-AV: E=Sophos;i="5.83,261,1616482800"; 
   d="scan'208";a="205219239"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2021 16:07:21 -0700
IronPort-SDR: P/zAnFMRxkHYkPVyckGYtiL+CcCx3i/lhg0ZrOVLqO5MMEF3VSQAyGpnCX8KLBQEXSglRpHT8P
 rqX7GWtWdN1g==
X-IronPort-AV: E=Sophos;i="5.83,261,1616482800"; 
   d="scan'208";a="448476024"
Received: from kotikala-mobl1.amr.corp.intel.com (HELO vcostago-mobl2.amr.corp.intel.com) ([10.209.25.177])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2021 16:07:21 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     linux-pci@vger.kernel.org, richardcochran@gmail.com,
        hch@infradead.org, netdev@vger.kernel.org, bhelgaas@google.com,
        helgaas@kernel.org, intel-wired-lan@lists.osuosl.org
Subject: Re: [Intel-wired-lan] [PATCH next-queue v5 3/4] igc: Enable PCIe PTM
In-Reply-To: <d8740484-3879-1c13-65ce-82d3e71cb96c@molgen.mpg.de>
References: <20210605002356.3996853-1-vinicius.gomes@intel.com>
 <20210605002356.3996853-4-vinicius.gomes@intel.com>
 <70d32740-eb4b-f7bf-146e-8dc06199d6c9@molgen.mpg.de>
 <87sg1sw56h.fsf@vcostago-mobl2.amr.corp.intel.com>
 <939b8042-a313-47db-43d9-ea37e95b724b@molgen.mpg.de>
 <87r1havm15.fsf@vcostago-mobl2.amr.corp.intel.com>
 <d8740484-3879-1c13-65ce-82d3e71cb96c@molgen.mpg.de>
Date:   Wed, 09 Jun 2021 16:07:20 -0700
Message-ID: <87k0n2vdqv.fsf@vcostago-mobl2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paul,

>> 
>>> Regarding my comment, I did not mean returning an error but the log
>>> *level* of the message. So, `dmesg --level err` would show that message.
>>> But if there are PCI controllers not supporting that, it’s not an error,
>>> but a warning at most. So, I’d use:
>>>
>>> 	dev_warn(&pdev->dev, "PTM not supported by PCI bus/controller
>>> (pci_enable_ptm() failed)\n");
>> 
>> I will use you suggestion for the message, but I think that warn is a
>> bit too much, info or notice seem to be better.
>
> I do not know, if modern PCI(e)(?) controllers normally support PTM or 
> not. If recent controllers should support it, then a warning would be 
> warranted, otherwise a notice.
>

From the Intel side, it seems that it's been supported for a few years.
So, fair enough, let's go with a warn.


Cheers,
-- 
Vinicius
