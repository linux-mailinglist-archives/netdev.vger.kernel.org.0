Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3AD0357E64
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 10:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbhDHIsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 04:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbhDHIsM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 04:48:12 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCCBDC061760
        for <netdev@vger.kernel.org>; Thu,  8 Apr 2021 01:48:01 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id p12so913592pgj.10
        for <netdev@vger.kernel.org>; Thu, 08 Apr 2021 01:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/PMASeFAUbBI5JwV4L0k1lOX7888tIM9XHNKvH1RoPM=;
        b=DGNyFvJNtCpXW5Bjt2K1X1fr0tN3IHOLkCmGwmhQl5vLaqgacthwvenRB6aGv/AAeQ
         dUwql030rW4wIcVziIulvYiKbW40KunNuP3H5KxX0okrqVpKvITCe7SXjDaDAkjOEnXy
         BEmVDDDTn5S+YlBPZIjx9agDX1FUYGV0AVbS3lejwSFGBq2vL5EpfmP34A9nrF8xsu/K
         Dr1bTO1Zf/YLL8ACA1Y5V3eptwi/X0gocInmLAEjijbe6WWBn8Qvm/q4bcEdfCfc7mMA
         KjmgyGfXyZco6XZUC26jFDkRRHBjNTxelYFZ1Oez0RWaQLP6kiMzr/LbemQ88jCbYRqG
         nAng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/PMASeFAUbBI5JwV4L0k1lOX7888tIM9XHNKvH1RoPM=;
        b=gCcFUxmD8rvfDSmc8G9zRFeUgLD1ktuHi/yqrgZ21sXXqDH/GjJvL9izv8IN40TH3+
         ezbRFozK+8XsXfLRHqYDULN1SEWMgjoSfNBuGGJqDHkTRRnjAgLKWiQBqsplMTWRl1Nd
         HO5+IVC8JMPiZnd6izFCf2BPZ+VHuXLKNnvQ3KVXCh2xcwLMWEIxYZTKh3BQ0E6tbMVA
         4b/U5bWVsHean/h87JUsM2+DLRIpKzx9XRgRt44q/2VA5FXIh8PyqWYsQfPh8aMxoOvW
         PD2alHXVEm7Ns1eVfbzwo0FYg40Mr3IeXzxfA9FApCrWluJMPS2gdZNCFDQu8dT3oePh
         eRxQ==
X-Gm-Message-State: AOAM532BjPceTixqpavQajinXVCJ6CTEYviOrnwOKKWggdcc3/vxikfw
        G2hLVREj3vNjeAeGa2Ud1wwdEtV+WKqUp+kfjye2LH8B9DzSeQ==
X-Google-Smtp-Source: ABdhPJxiutvnYlEKjdNdSYTwUE01MVBkq0+GFUlPeMifn5KRIHOroysMx2hSbJbYXz3P2FVZwY3uIsC8Pl5tKTZj1d4=
X-Received: by 2002:a63:f903:: with SMTP id h3mr6882846pgi.443.1617871681332;
 Thu, 08 Apr 2021 01:48:01 -0700 (PDT)
MIME-Version: 1.0
References: <1617616369-27305-1-git-send-email-loic.poulain@linaro.org> <ddc8cd0fd3212ccbba399b03a059bcf40abbc117.camel@redhat.com>
In-Reply-To: <ddc8cd0fd3212ccbba399b03a059bcf40abbc117.camel@redhat.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Thu, 8 Apr 2021 10:56:11 +0200
Message-ID: <CAMZdPi_6hCYpiyf4=x1FdA2KHnVg6LFWnfEhCd8PMQP_yFXqCw@mail.gmail.com>
Subject: Re: [PATCH net-next v9 1/2] net: Add a WWAN subsystem
To:     Dan Williams <dcbw@redhat.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Aleksander Morgado <aleksander@aleksander.es>,
        open list <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dan,

On Wed, 7 Apr 2021 at 16:32, Dan Williams <dcbw@redhat.com> wrote:
>
> On Mon, 2021-04-05 at 11:52 +0200, Loic Poulain wrote:
> > This change introduces initial support for a WWAN framework. Given
> > the
> > complexity and heterogeneity of existing WWAN hardwares and
> > interfaces,
> > there is no strict definition of what a WWAN device is and how it
> > should
> > be represented. It's often a collection of multiple devices that
> > perform
> > the global WWAN feature (netdev, tty, chardev, etc).
>
> Great to see the continued work on this.
>
> Were you intending to follow-up with functionality to group netdevs
> with the control ports?  From my quick look at v9 here it only deals
> with MHI control ports (diag, QMI, AT, etc) which is great, but not the
> full story.
>
> I think that was a big part of the discussion around Johannes' earlier
> series since it's often protocol-specific to tie a particular netdev
> with a given control port, but that's something that's really necessary
> for a good abstract userspace.
>
> Thoughts here? I'd love to see that functionality too.

Yes, though it's not in the scope for this initial series*, I plan to add that.

I was thinking about introducing a wwan_register_ndev or
wwan_attach_ndev. Most of the time, netdev does not have reference to
related existing (or future) control ports (they are different
drivers), so we may need something like a 'context_id' for both ndev
and control ports that can be used for linking them when necessary.
Then, this relation could be represented as e.g a sysfs link to ndev
device(s)... That's just a possible approach, I'll be happy to discuss
this further.

* Note: Userspace tools like ModemManager are able to link control
ports and netdev by looking at the sysfs hierarchy, it's fine for
simple connection management, but probably not enough for 'multi PDN'
support for which devices may have multiple netdev and ports
targetting different 'PDN contexts'...

Regards,
Loic
