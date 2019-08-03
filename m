Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00D7B80494
	for <lists+netdev@lfdr.de>; Sat,  3 Aug 2019 08:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbfHCGFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Aug 2019 02:05:33 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52865 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726621AbfHCGFd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Aug 2019 02:05:33 -0400
Received: by mail-wm1-f66.google.com with SMTP id s3so69877489wms.2;
        Fri, 02 Aug 2019 23:05:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rNjsuP0ZjDp9jnRQNucz2c5yrrLQk2HCJuqAw6zZVeM=;
        b=LVh4eCRnc+8XPVEiLWCyMApcVszjz2OaYV8RYm0L7XWc3HjY9IwIwOyJEVNiDLIVtM
         MIl9CYrEs3SxyB3KwyjiPhYG2BfGpQKw4BvOODGx2egaLIAawt8MKY/WKTtyo2m0M7U0
         iq3aFs8wi/HbWP6rfo4Vqsq2V+y4bGiW++1SbHvXLb0P/7GAQoMCMIVjXMOi0c6HZKR0
         TdVGbN1fu6rDGl7J3REDkP5glgHsQIg2J/5Q2EMGeZKu/TPKOn5kT1dhZdv/Y/Z2mzgn
         gv1jhd504dTix0h/CwyzkgZmmoKebRS1vMJfNUv3rfkYs44Yry2s3o4KT9jU96OBdLIv
         PDaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rNjsuP0ZjDp9jnRQNucz2c5yrrLQk2HCJuqAw6zZVeM=;
        b=Exw8X/T8HFnvD9nM17zlXZv4ksN2vVsOtPAaHtgz+Ka1B/bBrPS5S5GkgOzbsUYvFM
         Gab8W+nTMBly1RVjI4TuUk3cSTmxhiTp/jgzb95rHjxReRVX+TyZCU8te1LeJ2fRTcpG
         +kTGLhs10gf2B/7ZKuRFoaME58Vox/yUoQfEwrwowY/9GCkhDNSBG6bnQOK7MHjC0ofW
         EaCuFIUPoFOgz0rgN6Mh7SU2CtSUA8kgRJocbBRKVQRckAynTuxDK8l2bmD66tM2wLKs
         /Yx7HuLnNTipVhdO8VhqimnrmTK1929jb0zSvpgRryZK8sVTcq2jDm5k9VRAAer7dUN/
         mXRQ==
X-Gm-Message-State: APjAAAUfJL3nULbmRkVe47qh5YUEUkX4F7Se4MxDv9QwxBPIixAiikeX
        U6BVC0n+ekTcmIUY51VXWZ4=
X-Google-Smtp-Source: APXvYqz36zGRvW+EA5Q16NvmRTURlwWo6t5ErfVh/qGFKq4wC1cYjfYdUWL01hQeI+UTjypAPLkC/A==
X-Received: by 2002:a1c:d10c:: with SMTP id i12mr7689994wmg.152.1564812330438;
        Fri, 02 Aug 2019 23:05:30 -0700 (PDT)
Received: from archlinux-threadripper ([2a01:4f8:222:2f1b::2])
        by smtp.gmail.com with ESMTPSA id r123sm73514728wme.7.2019.08.02.23.05.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 23:05:29 -0700 (PDT)
Date:   Fri, 2 Aug 2019 23:05:28 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     David Miller <davem@davemloft.net>, andrew@lunn.ch,
        broonie@kernel.org, devel@driverdev.osuosl.org,
        f.fainelli@gmail.com, gregkh@linuxfoundation.org,
        hkallweit1@gmail.com, kernel-build-reports@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        netdev@vger.kernel.org, lkp@intel.com, rdunlap@infradead.org
Subject: Re: [PATCH] net: mdio-octeon: Fix build error and Kconfig warning
Message-ID: <20190803060528.GA89737@archlinux-threadripper>
References: <20190731.094150.851749535529247096.davem@davemloft.net>
 <20190731185023.20954-1-natechancellor@gmail.com>
 <20190802.181132.1425585873361511856.davem@davemloft.net>
 <20190803013031.GA76252@archlinux-threadripper>
 <20190803013952.GF5597@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190803013952.GF5597@bombadil.infradead.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 02, 2019 at 06:39:52PM -0700, Matthew Wilcox wrote:
> On Fri, Aug 02, 2019 at 06:30:31PM -0700, Nathan Chancellor wrote:
> > On Fri, Aug 02, 2019 at 06:11:32PM -0700, David Miller wrote:
> > > The proper way to fix this is to include either
> > > 
> > > 	linux/io-64-nonatomic-hi-lo.h
> > > 
> > > or
> > > 
> > > 	linux/io-64-nonatomic-lo-hi.h
> > > 
> > > whichever is appropriate.
> > 
> > Hmmmm, is that not what I did?
> > 
> > Although I did not know about io-64-nonatomic-hi-lo.h. What is the
> > difference and which one is needed here?
> 
> Whether you write the high or low 32 bits first.  For this, it doesn't
> matter, since the compiled driver will never be run on real hardware.

That's what I figured. I have only seen lo-hi used personally, which is
what I went with here. Thanks for the confirmation!

> 
> > There is apparently another failure when OF_MDIO is not set, I guess I
> > can try to look into that as well and respin into a series if
> > necessary.
> 
> Thanks for taking care of that!
