Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 709E623E0F4
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 20:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728159AbgHFS2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 14:28:35 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:59276 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727995AbgHFSUB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 14:20:01 -0400
Received: from dispatch1-us1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 17AA9B684B;
        Thu,  6 Aug 2020 18:18:15 +0000 (UTC)
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.62])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 886C060070;
        Thu,  6 Aug 2020 18:17:54 +0000 (UTC)
Received: from us4-mdac16-4.ut7.mdlocal (unknown [10.7.65.72])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 840958009B;
        Thu,  6 Aug 2020 18:17:54 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.35])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 09249280074;
        Thu,  6 Aug 2020 18:17:54 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id B7DEF480079;
        Thu,  6 Aug 2020 18:17:53 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 6 Aug 2020
 19:17:47 +0100
Subject: Re: [linux-next:master 13398/13940]
 drivers/net/ethernet/sfc/ef100_nic.c:610: undefined reference to `__umoddi3'
To:     kernel test robot <lkp@intel.com>
CC:     <kbuild-all@lists.01.org>, netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <202008060723.1gNgVvUi%lkp@intel.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <487d9159-41f8-2757-2e93-01426a527fb5@solarflare.com>
Date:   Thu, 6 Aug 2020 19:17:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <202008060723.1gNgVvUi%lkp@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25586.005
X-TM-AS-Result: No-12.452600-8.000000-10
X-TMASE-MatchedRID: oHOSwQSJZWhq0U6EhO9EE4lSWYvdSPSY4cLBHAw1BRZske+tckkBoiGU
        b2JNxi1qvPtSCmwHhL0W+rN4H33dkbWPvW6oP7NyLIrMljt3aduPzv8sr7ayoxpX1zEL4nq3Hf4
        4ullC212/lkj6wDcDigSuWRuEnLXhV9nX7lX9OjRyMswwR1sr6zAuMzu3eJGjdroFpVy5w+mHhM
        8qmux3Sb9ULgvDfUo5vdBFVbH6wdjqRl2OKU4dKpzEHTUOuMX3eouvej40T4gd0WOKRkwsh1ymR
        v3NQjsEYnBhoG388QPQHiCKHhKOgW7vEKjEI8LySHCU59h5KrG0em6xcBVoDI4iwAQuovtYru70
        Q5pawzYAb9Rn+iNx0xQAmj5Up3IVn/nVWd4TWXeMrYi9PmoV29i5W7Rf+s6Qi8VrlddQxsZwASG
        rGM67O2HuJNcKeM9f6lUt9vnbi+9O8fMZwaqIgp4CIKY/Hg3AnCGS1WQEGtD8V77yhJRgo6u6xV
        HLhqfxIAcCikR3vq86XuPdvRHcl9hjjqZSWk1w1xY6ykLB0sx3lZ6s0ZOX6ajcaKKxOnis
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--12.452600-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25586.005
X-MDID: 1596737874-pEQT5DErUjQB
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/08/2020 00:48, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> head:   d15fe4ec043588beee823781602ddb51d0bc84c8
> commit: adcfc3482ffff813fa2c34e5902005853f79c2aa [13398/13940] sfc_ef100: read Design Parameters at probe time
> config: microblaze-randconfig-r032-20200805 (attached as .config)
> compiler: microblaze-linux-gcc (GCC) 9.3.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         git checkout adcfc3482ffff813fa2c34e5902005853f79c2aa
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=microblaze 
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>    microblaze-linux-ld: drivers/net/ethernet/sfc/ef100_nic.o: in function `ef100_process_design_param':
>>> drivers/net/ethernet/sfc/ef100_nic.c:610: undefined reference to `__umoddi3'
>    605			/* Our TXQ and RXQ sizes are always power-of-two and thus divisible by
>    606			 * EFX_MIN_DMAQ_SIZE, so we just need to check that
>    607			 * EFX_MIN_DMAQ_SIZE is divisible by GRANULARITY.
>    608			 * This is very unlikely to fail.
>    609			 */
>  > 610			if (EFX_MIN_DMAQ_SIZE % reader->value) {
So, this is (unsigned long) % (u64), whichI guess doesn't go quite
 as smoothly 32-bit microcontrollers (though the thought of plugging
 a 100-gig smartNIC into a microblaze boggles the mind a little ;).
And none of the math64.h functions seem to have the shape we want —
 div_u64_rem() wants to write the remainder through a pointer, and
 do_div() wants to modify the dividend (which is a constant in this
 case).  So whatever I do, it's gonna be ugly :(

Maybe I should add a

static inline u32 mod_u64(u64 dividend, u32 divisor)
{
        return do_div(dividend, divisor);
}

to include/linux/math64.h?  At least that way the ugly is centralised
 in the header file.
