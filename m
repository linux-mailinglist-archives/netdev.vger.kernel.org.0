Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA4E5241893
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 10:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728372AbgHKIzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 04:55:49 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:47184 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728301AbgHKIzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 04:55:49 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.61])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 6C5B060056;
        Tue, 11 Aug 2020 08:55:48 +0000 (UTC)
Received: from us4-mdac16-75.ut7.mdlocal (unknown [10.7.64.194])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 6B9478009E;
        Tue, 11 Aug 2020 08:55:48 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.35])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id E904680051;
        Tue, 11 Aug 2020 08:55:47 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 8C00748005F;
        Tue, 11 Aug 2020 08:55:47 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 11 Aug
 2020 09:55:42 +0100
Subject: Re: [linux-next:master 13398/13940]
 drivers/net/ethernet/sfc/ef100_nic.c:610: undefined reference to `__umoddi3'
To:     Guenter Roeck <linux@roeck-us.net>
CC:     kernel test robot <lkp@intel.com>, <kbuild-all@lists.01.org>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <202008060723.1gNgVvUi%lkp@intel.com>
 <487d9159-41f8-2757-2e93-01426a527fb5@solarflare.com>
 <20200810155147.GA108014@roeck-us.net>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <d27bd95d-8b6a-d42a-80ee-f0589913796b@solarflare.com>
Date:   Tue, 11 Aug 2020 09:55:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200810155147.GA108014@roeck-us.net>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25596.005
X-TM-AS-Result: No-8.422900-8.000000-10
X-TMASE-MatchedRID: u7Yf2n7Ca/1q0U6EhO9EE/ZvT2zYoYOwC/ExpXrHizyRoQLwUmtov9Ik
        lxunVj5brKyWKUs6vMoBU9vJN4D7b0gidi3dgHgvdhnFihmbnwWWGk93C/VnSkn8NbadvwORTQF
        fM0Uvf4zaag0AZVfuYpnx1D8CeR1z8oXBIPaSRDxZMZ6MZ0H1Uu5qSW5mBa7xg8vHe9ji82J0ra
        Ix19+P5PVigNEWT95fx189SE5Q3BC1Hdke1yr594pHR9xEGhE1kRkcrpA9poBGMe+tDjQ3FiXi8
        Z7hCx0o2NBcWhOm2bWVQwS3RbdfmPY+eQk8cjCvfid4LSHtIANB9uUinegF0Zsoi2XrUn/JmTDw
        p0zM3zoqtq5d3cxkNUxwdPL5DqMW+dVxjfWbRN4853G90KC26uLrut+Wy90y/jwtLNwIC1/AvpL
        E+mvX8g==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--8.422900-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25596.005
X-MDID: 1597136148-P_vCEkmWSHm9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/08/2020 16:51, Guenter Roeck wrote:
> On Thu, Aug 06, 2020 at 07:17:43PM +0100, Edward Cree wrote:
>> Maybe I should add a
>>
>> static inline u32 mod_u64(u64 dividend, u32 divisor)
>> {
>>         return do_div(dividend, divisor);
>> }
> Your proposed function is an exact replicate of do_div()
No, because do_div() is a macro that modifies 'dividend', whereas by
 wrapping it in an inline function mod_u64() implicitly creates a
 local variable.  Thus do_div() cannot be used on a constant, whereas
 mod_u64() can.
> You could try something like
>
> 	if (reader->value > EFX_MIN_DMAQ_SIZE || EFX_MIN_DMAQ_SIZE % (u32)reader->value)
I considered that.  It's ugly, so while it will work I think it's
 worthlooking to see if there's a better way.
> If EFX_MIN_DMAQ_SIZE is indeed known to be a power of 2, you could also use
> the knowledge that a 2^n value can only be divided by a smaller 2^n value,
> meaning that reader->value must have exactly one bit set. This would also
> avoid divide-by-0 issues if reader->value can be 0.
>
> 	if (reader->value > EFX_MIN_DMAQ_SIZE || hweight64(reader->value) != 1)
This is also ugly and I don't like relying on the power-of-twoness —
 it just feels fragile.

But you're right to point out that there's a div/0 issue, and if I'm
 going to have to check for that, then ugliness is unavoidable.  So
 I think the least painful option available is probably

    if (!reader->value || reader->value > EFX_MIN_DMAQ_SIZE ||
        EFX_MIN_DMAQ_SIZE % (u32)reader->value)

 which only assumes EFX_MIN_DMAQ_SIZE <= U32_MAX, an assumption I'm
 comfortable with baking in.
I'll put together a formal patch with that.

Thanks for the help.

-ed
