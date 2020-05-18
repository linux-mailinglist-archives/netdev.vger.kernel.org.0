Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66A441D892F
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 22:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbgERUbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 16:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbgERUbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 16:31:03 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 407B0C061A0C;
        Mon, 18 May 2020 13:31:03 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jamOZ-00FkWP-9n; Mon, 18 May 2020 22:29:55 +0200
Message-ID: <8d7a3bed242ac9d3ec55a4c97e008081230f1f6d.camel@sipsolutions.net>
Subject: Re: [PATCH v2 12/15] ath10k: use new module_firmware_crashed()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        Steve deRosier <derosier@gmail.com>,
        Ben Greear <greearb@candelatech.com>, jeyu@kernel.org,
        akpm@linux-foundation.org, arnd@arndb.de, rostedt@goodmis.org,
        mingo@redhat.com, aquini@redhat.com, cai@lca.pw, dyoung@redhat.com,
        bhe@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        gpiccoli@canonical.com, pmladek@suse.com,
        Takashi Iwai <tiwai@suse.de>, schlad@suse.de,
        andriy.shevchenko@linux.intel.com, keescook@chromium.org,
        daniel.vetter@ffwll.ch, will@kernel.org,
        mchehab+samsung@kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath10k@lists.infradead.org
Date:   Mon, 18 May 2020 22:29:53 +0200
In-Reply-To: <20200518132828.553159d9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200515212846.1347-1-mcgrof@kernel.org>
         <20200515212846.1347-13-mcgrof@kernel.org>
         <2b74a35c726e451b2fab2b5d0d301e80d1f4cdc7.camel@sipsolutions.net>
         <20200518165154.GH11244@42.do-not-panic.com>
         <4ad0668d-2de9-11d7-c3a1-ad2aedd0c02d@candelatech.com>
         <20200518170934.GJ11244@42.do-not-panic.com>
         <abf22ef3-93cb-61a4-0af2-43feac6d7930@candelatech.com>
         <20200518171801.GL11244@42.do-not-panic.com>
         <CALLGbR+ht2V3m5f-aUbdwEMOvbsX8ebmzdWgX4jyWTbpHrXZ0Q@mail.gmail.com>
         <20200518190930.GO11244@42.do-not-panic.com>
         <e3d978c8fa6a4075f12e843548d41e2c8ab537d1.camel@sipsolutions.net>
         <20200518132828.553159d9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-05-18 at 13:28 -0700, Jakub Kicinski wrote:
> On Mon, 18 May 2020 21:25:09 +0200 Johannes Berg wrote:
> > It's pretty clear, but even then, first of all I doubt this is the case
> > for many of the places that you've sprinkled the annotation on, and
> > secondly it actually hides useful information.
> > 
> > Regardless of the support issue, I think this hiding of information is
> > also problematic.
> > 
> > I really think we'd all be better off if you just made a sysfs file (I
> > mistyped debugfs in some other email, sorry, apparently you didn't see
> > the correction in time) that listed which device(s) crashed and how many
> > times. That would actually be useful. Because honestly, if a random
> > device crashed for some random reason, that's pretty much a non-event.
> > If it keeps happening, then we might even want to know about it.
> 
> Johannes - have you seen devlink health? I think we should just use
> that interface, since it supports all the things you're requesting,
> rather than duplicate it in sysfs.

I haven't, and I'm glad to hear that's there, sounds good!

I suspect that Luis wants something more generic though, that isn't just
applicable to netdevices, unless devlink grew some kind of non-netdev
stuff while I wasn't looking? :)

johannes

