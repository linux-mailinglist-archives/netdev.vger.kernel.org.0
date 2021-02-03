Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB6BA30E29C
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 19:35:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232759AbhBCSfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 13:35:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232760AbhBCSfN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 13:35:13 -0500
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62650C06178A
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 10:34:04 -0800 (PST)
Received: by mail-ot1-x334.google.com with SMTP id v1so799607ott.10
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 10:34:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=b/h61WQmUl7DxkrOa+nJW5VWfeQ3jtDfBJrjGAKSiWg=;
        b=th7nHy8TMGvd77hm3VatWAIKwQwqkGfYpRxIpabbNdRxzotHf5qHiXX/1fD0efLp/b
         rvwX1ZlFPrFR3IMLR0siUmShoamKB7xNf0Udcssb+EVePnGR9uj+zoQLIQu1ZQSC/+0D
         jUp0DYbSf4sqTOGzhObh551zlqJbH/sJIAxlaw7bFs1uFkTrbW6s1PkEE6BFtKn8SRtT
         ISvaO/9m1pUx1V5+VYkuxY8upkPtw8vvuDNGjC8C/OaRoKnfNn5CZQeQoDi4kFs0kfr4
         jnCeXpED7dCMeFRQbO3RUamk2WW8Ch53SNPTmyl5cV6gly5wp7HWKf+9vb5XVmsqIT5Z
         IBug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=b/h61WQmUl7DxkrOa+nJW5VWfeQ3jtDfBJrjGAKSiWg=;
        b=jJSHF/wjLGb9AP2R0aMROBl9PXq2Ngkqi5/yUhGwk7/ddg9+NRUff5z64mae2B+1vs
         uj9DIY7JK1J/ZIbmOnnQgs70hrt5NejMHEEnImsZnP/qpg6dV52vCGsjFaf5H14cE04J
         YVO8dj3Xzn/+vhkU1MLtSnNnhPqzjYH0mmW7aEKaLRzlsDkQjtEVfCBKscLa+GKZOHf2
         GMUoP0diuvsg6FUApSRP6pKC5nI7l+R2SNQMlzPkbaR1czOfBNnb2osYgqiI90Bl5yDo
         aqzSw+/idsa00R+nyfoBWgpVERDyfraaqnu5zwDNCSh8tmPjTzUBaoFnDMjZr3+PfPUD
         RsAQ==
X-Gm-Message-State: AOAM531c2/BeCOT75os32KOxxIGUpx8rSBDVxqq5pHuEGdThisZBLACV
        MN0mz/vv9OQvKXXn7dPVHHahUA==
X-Google-Smtp-Source: ABdhPJzX5bEPWeTsKmXSVCVyB+BEQNGvGEz8pjvBUPD+m7MKvasqadpfTT/hujD0044pXJGP6otwiA==
X-Received: by 2002:a9d:d10:: with SMTP id 16mr3089686oti.101.1612377243532;
        Wed, 03 Feb 2021 10:34:03 -0800 (PST)
Received: from builder.lan (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id t2sm579489otj.47.2021.02.03.10.34.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 10:34:02 -0800 (PST)
Date:   Wed, 3 Feb 2021 12:34:00 -0600
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>, davem@davemloft.net,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jhugo@codeaurora.org, bbhatt@codeaurora.org,
        loic.poulain@linaro.org, netdev@vger.kernel.org
Subject: Re: [RESEND PATCH v18 0/3] userspace MHI client interface driver
Message-ID: <YBrsmO/ATztB+1K4@builder.lan>
References: <1609958656-15064-1-git-send-email-hemantk@codeaurora.org>
 <20210113152625.GB30246@work>
 <YBGDng3VhE1Yw6zt@kroah.com>
 <20210201105549.GB108653@thinkpad>
 <YBfi573Bdfxy0GBt@kroah.com>
 <20210201121322.GC108653@thinkpad>
 <20210202042208.GB840@work>
 <20210202201008.274209f9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <835B2E08-7B84-4A02-B82F-445467D69083@linaro.org>
 <20210203100508.1082f73e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210203100508.1082f73e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 03 Feb 12:05 CST 2021, Jakub Kicinski wrote:

> On Wed, 03 Feb 2021 09:45:06 +0530 Manivannan Sadhasivam wrote:
> > >> Jakub, Dave, Adding you both to get your reviews on this series. I've
> > >> provided an explanation above and in the previous iteration [1].  
> > >
> > >Let's be clear what the review would be for. Yet another QMI chardev 
> > >or the "UCI" direct generic user space to firmware pipe?  
> > 
> > The current patchset only supports QMI channel so I'd request you to
> > review the chardev node created for it. The QMI chardev node created
> > will be unique for the MHI bus and the number of nodes depends on the
> > MHI controllers in the system (typically 1 but not limited). 
> 
> If you want to add a MHI QMI driver, please write a QMI-only driver.

But said QMI driver would be identical to what is proposed here, given
that the libqmi [1] communicates in the raw messages of the given MHI
channel. Should I then propose another copy of the same driver for
transporting debug messages between [2] and the modem? And a third copy
to support firmware flashing using [3].

[1] https://www.freedesktop.org/wiki/Software/libqmi/
[2] https://github.com/andersson/diag
[3] https://github.com/andersson/qdl

> This generic "userspace client interface" driver is a no go. Nobody will
> have the time and attention to police what you throw in there later.

PCI devices implementing this must have a MHI controller driver, which
explicitly needs to specify which logical channels should be exposed to
userspace using the UCI driver. So in contrast to things like USBFS or
the tty layer - which is used to implement "network devices" today -
there is a natural point of policing this.

Regards,
Bjorn
