Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8C91D7FE5
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 19:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728416AbgERRSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 13:18:04 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33149 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728139AbgERRSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 13:18:04 -0400
Received: by mail-pf1-f195.google.com with SMTP id n15so2013879pfd.0;
        Mon, 18 May 2020 10:18:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=o/LRAU6oORjP4bOuNDVY0R1e1/6YnNXq8W0dWZnejw4=;
        b=O9739FtMZiAgYKy63O8FH4dhttnJ8DUUgyBoqIvaImIHq3RWhEztDKOxq3Af5mgdB6
         eQX/4lQ8qqnKmNpqlqM0tzC96IdKmKM2QYVGAQpT5e6py0hygGPs4FUVxMLu1XVCHtxP
         iN/cao8tVjzgrPCzwMf+aFM2+T16dADmTA7YDN5y+68HjXRCTcfw7dPBFpXgH7QtrwjA
         pfR+BkZSN4AORY2KM/CkXgNFwKr1abfOXux1sQLs38wfGzH85eLNouR7rv1MgzNO1Mgo
         utL0MuYtM5q8ayih+ajWESYz6bsc9fN4OV59KS1ymhruehve+ZzzwndJ0syayJanwJnY
         lixg==
X-Gm-Message-State: AOAM530WCbaRhnom9lkFc0f6rKq8MDPzQPAMlzy+Sf4hKacvH8Y8gaZa
        3QuLv3DP8bAwQMmCt2qkXJY=
X-Google-Smtp-Source: ABdhPJyOKQx6snLdV6SH5a4e989iVV2McRYJsKuizKPK18IX2sbTdIBU1x9WLjpUX0KewZZXJA0nqQ==
X-Received: by 2002:a62:754f:: with SMTP id q76mr18380695pfc.14.1589822283147;
        Mon, 18 May 2020 10:18:03 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id q100sm132531pjc.11.2020.05.18.10.18.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 10:18:02 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 5D797404B0; Mon, 18 May 2020 17:18:01 +0000 (UTC)
Date:   Mon, 18 May 2020 17:18:01 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Ben Greear <greearb@candelatech.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>, jeyu@kernel.org,
        akpm@linux-foundation.org, arnd@arndb.de, rostedt@goodmis.org,
        mingo@redhat.com, aquini@redhat.com, cai@lca.pw, dyoung@redhat.com,
        bhe@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        gpiccoli@canonical.com, pmladek@suse.com, tiwai@suse.de,
        schlad@suse.de, andriy.shevchenko@linux.intel.com,
        keescook@chromium.org, daniel.vetter@ffwll.ch, will@kernel.org,
        mchehab+samsung@kernel.org, kvalo@codeaurora.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: Re: [PATCH v2 12/15] ath10k: use new module_firmware_crashed()
Message-ID: <20200518171801.GL11244@42.do-not-panic.com>
References: <20200515212846.1347-1-mcgrof@kernel.org>
 <20200515212846.1347-13-mcgrof@kernel.org>
 <2b74a35c726e451b2fab2b5d0d301e80d1f4cdc7.camel@sipsolutions.net>
 <20200518165154.GH11244@42.do-not-panic.com>
 <4ad0668d-2de9-11d7-c3a1-ad2aedd0c02d@candelatech.com>
 <20200518170934.GJ11244@42.do-not-panic.com>
 <abf22ef3-93cb-61a4-0af2-43feac6d7930@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abf22ef3-93cb-61a4-0af2-43feac6d7930@candelatech.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 18, 2020 at 10:15:45AM -0700, Ben Greear wrote:
> 
> 
> On 05/18/2020 10:09 AM, Luis Chamberlain wrote:
> > On Mon, May 18, 2020 at 09:58:53AM -0700, Ben Greear wrote:
> > > 
> > > 
> > > On 05/18/2020 09:51 AM, Luis Chamberlain wrote:
> > > > On Sat, May 16, 2020 at 03:24:01PM +0200, Johannes Berg wrote:
> > > > > On Fri, 2020-05-15 at 21:28 +0000, Luis Chamberlain wrote:> module_firmware_crashed
> > > > > 
> > > > > You didn't CC me or the wireless list on the rest of the patches, so I'm
> > > > > replying to a random one, but ...
> > > > > 
> > > > > What is the point here?
> > > > > 
> > > > > This should in no way affect the integrity of the system/kernel, for
> > > > > most devices anyway.
> > > > 
> > > > Keyword you used here is "most device". And in the worst case, *who*
> > > > knows what other odd things may happen afterwards.
> > > > 
> > > > > So what if ath10k's firmware crashes? If there's a driver bug it will
> > > > > not handle it right (and probably crash, WARN_ON, or something else),
> > > > > but if the driver is working right then that will not affect the kernel
> > > > > at all.
> > > > 
> > > > Sometimes the device can go into a state which requires driver removal
> > > > and addition to get things back up.
> > > 
> > > It would be lovely to be able to detect this case in the driver/system
> > > somehow!  I haven't seen any such cases recently,
> > 
> > I assure you that I have run into it. Once it does again I'll report
> > the crash, but the problem with some of this is that unless you scrape
> > the log you won't know. Eventually, a uevent would indeed tell inform
> > me.
> > 
> > > but in case there is
> > > some common case you see, maybe we can think of a way to detect it?
> > 
> > ath10k is just one case, this patch series addresses a simple way to
> > annotate this tree-wide.
> > 
> > > > > So maybe I can understand that maybe you want an easy way to discover -
> > > > > per device - that the firmware crashed, but that still doesn't warrant a
> > > > > complete kernel taint.
> > > > 
> > > > That is one reason, another is that a taint helps support cases *fast*
> > > > easily detect if the issue was a firmware crash, instead of scraping
> > > > logs for driver specific ways to say the firmware has crashed.
> > > 
> > > You can listen for udev events (I think that is the right term),
> > > and find crashes that way.  You get the actual crash info as well.
> > 
> > My follow up to this was to add uevent to add_taint() as well, this way
> > these could generically be processed by userspace.
> 
> I'm not opposed to the taint, though I have not thought much on it.
> 
> But, if you can already get the crash info from uevent, and it automatically
> comes without polling or scraping logs, then what benefit beyond that does
> the taint give you?

From a support perspective it is a *crystal* clear sign that the device
and / or device driver may be in a very bad state, in a generic way.

  Luis
