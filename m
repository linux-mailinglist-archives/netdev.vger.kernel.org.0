Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 712545FA42E
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 21:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiJJT3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 15:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiJJT3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 15:29:19 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC244F68B
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 12:29:15 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id c24so11248879plo.3
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 12:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1rYd5wKmTtTEZzMnTT5DcQpclFJ5bKOFkPhGQYkmSBw=;
        b=RqTAm/DuxqwDzCmHthDOl9UX9v3KDK9uWW3dB7gJ26kgzCp6X0VUMtZERm5waSuAJp
         WRwYeIUdSWz+yOsPSDH6pMUkKbBp5ltb6DE46I20hh7n5sfZcr+/UWI/e6JIo+kQ7pAn
         XmqH/cj8c75Mn9wCipbjMGSHNGvGjHkcJp9XYSiUnt9nvkyBi9hXjxq6aV1bSDVNDMlY
         3IDCmibgKH3c062sEM4Lw1b/enoGGXVrOYjCOEhSRZKFkfN0FJYor5O5Dbn3dNriRI8V
         qsTahCejPuFksgdzmV+iCfhVJXFhiqetk/cvxFiNOTSSKl2vnSWYxB0NWJVPOrJszZov
         ePDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1rYd5wKmTtTEZzMnTT5DcQpclFJ5bKOFkPhGQYkmSBw=;
        b=245GUWk6Ez+IWUZmd17ev2DnwrYRdSQp8R1CaRx/3tTEJas0+5i5h+/28anKfdn8aM
         LKMS9Fqp67AwwMa4O3TKZGt1k+YkL1TNca0ZFZEl+8UCGnzEUQZagUjuO6vvwRLbSIjK
         9z3LV1cyvL5nf4d72ab23UIbEnYeKFIH6reasYBE1cGsYh1GdfBqyr9XtUU7He1PJQ1c
         NC14q5mwr8veFaMdY6icK/Ly2PRVYgn3zvHEwe4YfEfvnq7jJZp+/cWnbMbaeOJHm+eO
         YksV3moFznihnkzJRXVmoh2x0MsB4SikW+3aJAV2KZtBYOGSU5TI7mnIeXYVCTDbu0vt
         HlvA==
X-Gm-Message-State: ACrzQf0wiBBkmlSNcG3Y4P4dhis0tGonYS4K+kDFId2O9PjPY+nzbqhz
        2pKoKNyscR/6HLvuF0+6wIbBVg==
X-Google-Smtp-Source: AMsMyM7TXibQhFguBkFno2yp6rWxynGT/DZUk5/HtH4gACpcfFw+oDohMV2x5Th9cvxfTdfMTVSHjg==
X-Received: by 2002:a17:90b:1a8b:b0:20d:4c24:af5 with SMTP id ng11-20020a17090b1a8b00b0020d4c240af5mr5660039pjb.213.1665430155292;
        Mon, 10 Oct 2022 12:29:15 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id q4-20020a170902dac400b001728ac8af94sm7018956plx.248.2022.10.10.12.29.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 12:29:15 -0700 (PDT)
Date:   Mon, 10 Oct 2022 12:29:13 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     Jouke Witteveen <j.witteveen@gmail.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Documentation: update urls to Linux Foundation wiki
Message-ID: <20221010122913.6a91b117@hermes.local>
In-Reply-To: <87v8orpkda.fsf@meer.lwn.net>
References: <20221001112058.22387-1-j.witteveen@gmail.com>
        <87v8orpkda.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 10 Oct 2022 13:08:17 -0600
Jonathan Corbet <corbet@lwn.net> wrote:

> Jouke Witteveen <j.witteveen@gmail.com> writes:
> 
> > The redirects from the old urls stopped working recently.
> >
> > Signed-off-by: Jouke Witteveen <j.witteveen@gmail.com>  
> 
> I see the LF has done its annual web-site replacement; I have no idea
> why they are so enamored with breaking URLs...
> 
> Anyway, This is networking documentation, so it should go to the folks
> at netdev [CC'd] rather than me.
> 
> >  Documentation/networking/bridge.rst                           | 2 +-
> >  Documentation/networking/dccp.rst                             | 4 ++--
> >  .../networking/device_drivers/ethernet/intel/ice.rst          | 2 +-
> >  Documentation/networking/generic_netlink.rst                  | 2 +-
> >  MAINTAINERS                                                   | 2 +-
> >  net/ipv4/Kconfig                                              | 2 +-
> >  net/sched/Kconfig                                             | 2 +-
> >  7 files changed, 8 insertions(+), 8 deletions(-)
> >
> > diff --git a/Documentation/networking/bridge.rst b/Documentation/networking/bridge.rst
> > index 4aef9cddde2f..c859f3c1636e 100644
> > --- a/Documentation/networking/bridge.rst
> > +++ b/Documentation/networking/bridge.rst
> > @@ -8,7 +8,7 @@ In order to use the Ethernet bridging functionality, you'll need the
> >  userspace tools.
> >  
> >  Documentation for Linux bridging is on:
> > -   http://www.linuxfoundation.org/collaborate/workgroups/networking/bridge
> > +   https://wiki.linuxfoundation.org/networking/bridge  
> 
> So this page is full of encouraging stuff like:
> 
> > The code is updated as part of the 2.4 and 2.6 kernels available at
> > kernel.org.  
> 
> ...and tells us about an encouraging prototype implementation in 2.6.18.
> I'd apply the patch because working URLs are better than broken ones,
> but I also question the value of this material at all in 2022... there
> should be better documents to link to at this point?

This is ancient networking wiki.
I took old stuff put it on wiki back when I was working at LF
but never updated since then.
