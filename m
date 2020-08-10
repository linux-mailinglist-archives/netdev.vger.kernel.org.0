Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 898F7240AD2
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 17:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727800AbgHJPvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 11:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726484AbgHJPvu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 11:51:50 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 771B7C061756;
        Mon, 10 Aug 2020 08:51:50 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id p37so951229pgl.3;
        Mon, 10 Aug 2020 08:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=8ZzO6krlGJtRD/+LRXbveBA4o2Xgr8jl4siKcCp95Rs=;
        b=eRdnzb8EwOXUMu2u4KxZk9rEvwiwanXfLavWPE+hUtV0e/KDATsXJiC/CgxbDBCBnk
         GmLW2r+3SLEfweVobCL/0xQf7MYy/Knz51v60SsM46jG+Ry5AimEvpVrG7R/BvtDZwMc
         Q300hPeRXARxvgzPyA6xTlbSSfcwE0jwOJky/twVX6orerMVGY/ZQoVaICjiNHx4Y4Lu
         akUb25LnqrGz7PrQzAwAAfhd4q8N/MyPXiGoZE0ByqBILNQSVE1eT1fueOG1JDw3wcmf
         pJDdp1lq1gysfSfLqZ+6a2t1XyuhXBgdgjWRjI5qUQFK7vfebiXjM0qG6R1L0uyrXIwn
         WT0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=8ZzO6krlGJtRD/+LRXbveBA4o2Xgr8jl4siKcCp95Rs=;
        b=NhwEAuAllUcRtCtByoSe8D7ok+0AboRqGWSQ/WLaZs14QtF+r4YhLUCRxlCs8zZThl
         wQqRAp5YjGSqwVxCu9Avu64h8mvO4oY9H8uRtoaYGfalYe3U80g4fxkql+dBKCzDAers
         0QfW0Ummdx/dE9dQwTsG650dsHtmFxxsKS4ZqMzpGYgJlMVtWUtW6FFWSK+u1OexuYvr
         qF3OBMMAjOSY5aBNrRQUkZr+2xqV3Kj179qs3DjM2UzyMbA+439+gohu1uxWnIpcFwME
         mL8ExqfCnI9Zc2r7rXVpJLhNh0m+CirqK02hddCXTpr9bVXbyp2S7Xd2lAjjJV75h1Lo
         XK9Q==
X-Gm-Message-State: AOAM530cOoDyxFKQAZEOUEJ8ObYfN6th8hLFkp0FdqVP6VZzz1m+8XJe
        XXBL+pyWgb2QzFk/yRn2ims=
X-Google-Smtp-Source: ABdhPJyjYHbuOtgFfYrASU2QIplM/xpM3JwZFyaDKBzaqpr+xFYrNfS02R+Iopzhf7MofqdWcS28Ng==
X-Received: by 2002:a62:1803:: with SMTP id 3mr1763866pfy.198.1597074709927;
        Mon, 10 Aug 2020 08:51:49 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a15sm21753181pfo.185.2020.08.10.08.51.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 10 Aug 2020 08:51:49 -0700 (PDT)
Date:   Mon, 10 Aug 2020 08:51:47 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Edward Cree <ecree@solarflare.com>
Cc:     kernel test robot <lkp@intel.com>, kbuild-all@lists.01.org,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [linux-next:master 13398/13940]
 drivers/net/ethernet/sfc/ef100_nic.c:610: undefined reference to `__umoddi3'
Message-ID: <20200810155147.GA108014@roeck-us.net>
References: <202008060723.1gNgVvUi%lkp@intel.com>
 <487d9159-41f8-2757-2e93-01426a527fb5@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <487d9159-41f8-2757-2e93-01426a527fb5@solarflare.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 06, 2020 at 07:17:43PM +0100, Edward Cree wrote:
> On 06/08/2020 00:48, kernel test robot wrote:
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> > head:   d15fe4ec043588beee823781602ddb51d0bc84c8
> > commit: adcfc3482ffff813fa2c34e5902005853f79c2aa [13398/13940] sfc_ef100: read Design Parameters at probe time
> > config: microblaze-randconfig-r032-20200805 (attached as .config)
> > compiler: microblaze-linux-gcc (GCC) 9.3.0
> > reproduce (this is a W=1 build):
> >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> >         chmod +x ~/bin/make.cross
> >         git checkout adcfc3482ffff813fa2c34e5902005853f79c2aa
> >         # save the attached .config to linux build tree
> >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=microblaze 
> >
> > If you fix the issue, kindly add following tag as appropriate
> > Reported-by: kernel test robot <lkp@intel.com>
> >
> > All errors (new ones prefixed by >>):
> >
> >    microblaze-linux-ld: drivers/net/ethernet/sfc/ef100_nic.o: in function `ef100_process_design_param':
> >>> drivers/net/ethernet/sfc/ef100_nic.c:610: undefined reference to `__umoddi3'
> >    605			/* Our TXQ and RXQ sizes are always power-of-two and thus divisible by
> >    606			 * EFX_MIN_DMAQ_SIZE, so we just need to check that
> >    607			 * EFX_MIN_DMAQ_SIZE is divisible by GRANULARITY.
> >    608			 * This is very unlikely to fail.
> >    609			 */
> >  > 610			if (EFX_MIN_DMAQ_SIZE % reader->value) {
> So, this is (unsigned long) % (u64), whichI guess doesn't go quite
>  as smoothly 32-bit microcontrollers (though the thought of plugging
>  a 100-gig smartNIC into a microblaze boggles the mind a little ;).
> And none of the math64.h functions seem to have the shape we want —
>  div_u64_rem() wants to write the remainder through a pointer, and
>  do_div() wants to modify the dividend (which is a constant in this
>  case).  So whatever I do, it's gonna be ugly :(
> 
> Maybe I should add a
> 
> static inline u32 mod_u64(u64 dividend, u32 divisor)
> {
>         return do_div(dividend, divisor);
> }

Your proposed function is an exact replicate of do_div() and thus doesn't
make much sense. Also, in your case, divisor is a 64-bit value, which is
causing the problem to start with. You could try something like

	if (reader->value > EFX_MIN_DMAQ_SIZE || EFX_MIN_DMAQ_SIZE % (u32)reader->value)

If EFX_MIN_DMAQ_SIZE is indeed known to be a power of 2, you could also use
the knowledge that a 2^n value can only be divided by a smaller 2^n value,
meaning that reader->value must have exactly one bit set. This would also
avoid divide-by-0 issues if reader->value can be 0.

	if (reader->value > EFX_MIN_DMAQ_SIZE || hweight64(reader->value) != 1)

Guenter
