Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11449412A51
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 03:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbhIUBft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 21:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbhIUBfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 21:35:47 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 595ACC08ED73
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 11:25:01 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id u21so16493569qtw.8
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 11:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Q2KgoUsajj4wTgr9qfoWd6Zmonitax7OMB9+YAOC8a4=;
        b=F7Cn0wsoXgZ9GJ4ecH1+8+fBc/Ah1Sj/FTRx8HssGHuO3taYBUvT3f13PaSDMMiMX/
         Mw3PJE69ediSsWyMuzCCVsyDREqhdMZBzrEQhN76d4A3+uZyGAqsyFJPts7X68BUaIcy
         c0z4Is46vqs+6mDTIMyJ6mTTo168C5D0LAMSZXi6PpPpTeV0nVXkOrJiazuanZ7OhAPI
         /JE2lfxEfKpBxmNnFAkaeG48Re0TdEkIAtwmEZBzKLBA7SnStfl2TnIddob6o82UPSZP
         CzideVxotVokgTQa/4n/wxzPTxl1OGvcgPjuPq4FHxhclrre5EB/nDbu0y0wdLgrFjGd
         etDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Q2KgoUsajj4wTgr9qfoWd6Zmonitax7OMB9+YAOC8a4=;
        b=JV379B2jH94qbINJx+w89Xcd5bg8wClB2/x1F3KJmc395K9EkDSbkXpGqUvBpLaqMu
         1tqMWsz3ibDlQefelUDe7yxb4W+pdOYSYMzKNKcROdN/HPTlfLTJIqdvM9kzS/M5qnu2
         3tYchYJJSLcKr5INehwQtQBy4tWyi+DyTAHNK6LymiMiYU8eYNWz2JmvOSwG/KumBI68
         EsehiFB2vtfibstHuNRgRLxOH2EB1gqwjXdGc+jLx6KzOne5crafgeVIyOYzIRRenazq
         fUd9Wb5sZITZDZtr2G8uHjBEmA95Yw37X/t2AOJs6oMv1AkKHRFN24KdBcIi1UMWWD9c
         otKw==
X-Gm-Message-State: AOAM5308RxYSlcRyJvuJAVWBRyDD/jsgP8m6MWBPUIAhIR74K4acU4Uh
        IEvyy6DuZodsnbOsadRzKLRfpID0AQ==
X-Google-Smtp-Source: ABdhPJxaYdmrXe4EVKLJTPUh4l9DXqpUBqNvGgU5fWWAJjVgwmfnyM2JOS4Nw6u3VSWRvLadVy6KQQ==
X-Received: by 2002:ac8:71cd:: with SMTP id i13mr7333266qtp.159.1632162300504;
        Mon, 20 Sep 2021 11:25:00 -0700 (PDT)
Received: from ssuryadesk ([136.56.65.87])
        by smtp.gmail.com with ESMTPSA id v201sm7918203qkb.29.2021.09.20.11.24.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 11:25:00 -0700 (PDT)
Date:   Mon, 20 Sep 2021 14:24:53 -0400
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next] ipmr: ip6mr: APIs to support adding more
 than MAXVIFS/MAXMIFS
Message-ID: <20210920182453.GA5695@ssuryadesk>
References: <20210917224123.410009-1-ssuryaextr@gmail.com>
 <YUaNVvSGoQ1+vcoa@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUaNVvSGoQ1+vcoa@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 19, 2021 at 03:07:34AM +0200, Andrew Lunn wrote:
> On Fri, Sep 17, 2021 at 06:41:23PM -0400, Stephen Suryaputra wrote:
> > MAXVIFS and MAXMIFS are too small (32) for certain applications. But
> > they are defined in user header files  So, use a different definition
> > CONFIG_IP_MROUTE_EXT_MAXVIFS that is configurable and different ioctl
> > requests (MRT_xyz_EXT and MRT6_xyz_EXT) as well as a different structure
> > for adding MFC (mfcctl_ext).
> > 
> > CONFIG_IP_MROUTE_EXT_MAXVIFS is bounded by the IF_SETSIZE (256) in
> > mroute6.h.
> > 
> > This patch is extending the following RFC:
> > http://patchwork.ozlabs.org/project/netdev/patch/m1eiis8uc6.fsf@fess.ebiederm.org/
> 
> Quoting the above URL:
> 
> > My goal is an API that works with just a recompile of existing
> > applications, and an ABI that continues to work for old applications.
> 
> Does this really work? Does the distribution version of mrouted use
> the kernel UAPI headers of the running kernel? Can i upgrade to a
> newer kernel, with newer headers, and it automagically pulls in a new
> mrouted built using the new kernel headers? I think not. ethtool has
> its own copy of the kernel headers. mrouted uses
> /usr/include/linux/mroute.h which is provided by
> linux-libc-dev:amd64. That is not tied to the running kernel. What
> about quagga?

That particular goal by Eric isn't exactly my goal. I extended his
approach to be more inline with the latest feedback he got. My
application is written for an embedded router and for it
/usr/include/linux/mroute.h is coming from the
include/uapi/linux/mroute.h. So, the new structure mfcctl_ext can be
used by the application.
> 
> So in effect, you have to ask the running kernel, what value is it
> using for MAXVIFS? Which means it is much more than just a recompile.
> So i doubt think you can achieve this goal.
> 
> Given that, i really think you should spend the time to do a proper
> solution. Add a netlink based API, which does not have the 32 limit.
> Make the kernel implementation be based on a linked list. Have the
> ioctl interface simply return the first 32 entries and ignore anything
> above that.

This proposal doesn't change any existing ones such as MRT_ADD_MFC,
MRT_ADD_VIF, MRT6_ADD_MFC and MRT6_ADD_MIF as they are still using the
unchanged MAXVIFS. So, if the applications such as quagga still use the
existing mroute.h it should still be working with the 32 vifs
limitation.

To use more than 32 vifs, then MRT_ADD_MFC_EXT, etc can be used. But for
that the applications need to be modified and be using the updated
mroute.h and mroute6.h.

Regards,
Stephen.
