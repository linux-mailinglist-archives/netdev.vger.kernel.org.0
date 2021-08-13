Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA673EBC9F
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 21:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233684AbhHMTjf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 15:39:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbhHMTjd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 15:39:33 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87127C061756;
        Fri, 13 Aug 2021 12:39:06 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id n12so12693466plf.4;
        Fri, 13 Aug 2021 12:39:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ptSHrsRcw6X4czsXxLVYZ9xIoB25F8JfnlEqAAuo6Tk=;
        b=kV/XUpbnSxLqxCVo4oM+MhneT3az9eTRMXPbtO1yIg5qwRYw/MDFp4duud/7ie0via
         +9uZNhcAmmCv84auI/2l+fCIp5brHu65S7I5xItMKNhk9zPMMc2FLNmazYBkncdtZL77
         pbUTqAD//b3CHjmxKwtaLoM2HkbyMjnDg5gOvSKy0d3oBCJB5iD0HXHheziiMAvCJnyT
         lhI6mIYQ6zYHEo0rsndx4/Xkr/m2xn7l/E3H/h80cClB46NaoepYYcd4LU9QmNzSV0LQ
         Pnuqb3OQh+l/o5Az9pQqVX9BnZ6pNBlmYFLnvAYSyvYfkniBgmfbf6t7w41UlJMCuWI/
         R/DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ptSHrsRcw6X4czsXxLVYZ9xIoB25F8JfnlEqAAuo6Tk=;
        b=TYmhEraC7/PsOF+JiiZGK0GE+XuTAWdCxW3I1GWELo6Rm3kK29QLB5ZX/1EhEBSKdH
         5EkOpEdX7Gtvn7AkemsQEjnMq7IdP2rM7aJBqT++76rkTPO+V16FRBkasId32gYNTDAr
         de5tEf1tdfQ55ZztNS//s3RV4EEeIgotgTo+Yjk97o4wgIqKsraL8x6WJu2N02cMrR7C
         bAfq7i5hrDjLINbm+ltItFPZ2lGIpYY5jZG55DlUabdk7wnEQWng8+7/wbzeICkwgBhN
         jKtUMIdlDT1b7rgYfDKAguHUnEwC0V0tfPwThris7ZUAV2xmjuN+vxcKjY1eEtVmlr8D
         x0NA==
X-Gm-Message-State: AOAM5317whyrMRp6FbI11IYoK2O7JTwt2y3xp22qbAnlZACHokfPow64
        awY7SkPL+ZVL8s9Q0IXzlG677VMfAB8DfrgoNM0=
X-Google-Smtp-Source: ABdhPJx7zPLlB/XEZBtUGfWhOZB3PZJBTXFbowM7nDaCDhl4o3AGmj7U7DRQG6/Pz47QB9OH1C1iYFbkWgS2y/r4SPA=
X-Received: by 2002:a17:902:e786:b029:12d:2a7:365f with SMTP id
 cp6-20020a170902e786b029012d02a7365fmr3318156plb.21.1628883546071; Fri, 13
 Aug 2021 12:39:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210813122932.46152-4-andriy.shevchenko@linux.intel.com>
 <202108132237.jJSESPou-lkp@intel.com> <YRaMEfTvOCsi40Je@smile.fi.intel.com>
 <YRaSIp4ViWvMrCoP@smile.fi.intel.com> <20210813112312.62f4ac42@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAHp75VeszO9iN7D3zG0-Z-V3CVC=mMdqq1ybHpUyD2HPRFH2Aw@mail.gmail.com>
In-Reply-To: <CAHp75VeszO9iN7D3zG0-Z-V3CVC=mMdqq1ybHpUyD2HPRFH2Aw@mail.gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 13 Aug 2021 22:38:29 +0300
Message-ID: <CAHp75VfZ1Sxxt5P4Bw5K0Sgh0Vw=dGjX5uhYDVxACdO5713xUw@mail.gmail.com>
Subject: Re: [PATCH v1 net-next 4/7] ptp_pch: Switch to use
 module_pci_driver() macro
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        kernel test robot <lkp@intel.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kbuild-all@lists.01.org, Richard Cochran <richardcochran@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 13, 2021 at 10:26 PM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> On Fri, Aug 13, 2021 at 9:23 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Fri, 13 Aug 2021 18:39:14 +0300 Andy Shevchenko wrote:
> > > On Fri, Aug 13, 2021 at 06:13:21PM +0300, Andy Shevchenko wrote:

...

> > > Kconfig misses PCI dependency. I will send a separate patch, there is nothing
> > > to do here.
> >
> > That patch has to be before this one, tho.
>
> Yes, I have sent it as a fix to the net, this series is to the
> net-next.

For the sake of reference:
https://lore.kernel.org/netdev/20210813173328.16512-1-andriy.shevchenko@linux.intel.com/T/#u

And by the way, dependency (although implicit) was there, see above
commit message.

-- 
With Best Regards,
Andy Shevchenko
