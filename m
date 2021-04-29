Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDCF736E7E8
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 11:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237494AbhD2JZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 05:25:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:33476 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235125AbhD2JZ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Apr 2021 05:25:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1619688280; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sFsswHYzmnsCtIuWtaEE2puDhfR/SZTmIoW2PDCisco=;
        b=YHGyFKkt5FLMqBLrnT2gKXkMJrFdXxGIaYTsZwHTkZl/aJrBSyIWADryXxu0HwVHPiX68g
        rmN+DZf1OlhdUd4aI/utae5zRHaqzTu9b+gp/ClXNvy1rzfYl9xTXY70yup6WHBLQUELlu
        NxxbuOjqbhatlpjTgDyq0oNC5djBdXE=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id EB95FAFDC;
        Thu, 29 Apr 2021 09:24:39 +0000 (UTC)
Date:   Thu, 29 Apr 2021 11:24:39 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Jia He <justin.he@arm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Jonathan Corbet <corbet@lwn.net>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-s390@vger.kernel.org
Subject: Re: [PATCH 2/4] lib/vsprintf.c: Make %p{D,d} mean as much components
 as possible
Message-ID: <YIp7VxzE5MspQ0UX@alley>
References: <20210428135929.27011-1-justin.he@arm.com>
 <20210428135929.27011-2-justin.he@arm.com>
 <YIpyZmi1Reh7iXeI@alley>
 <CAHp75Vfa3ATc+-Luka9vJTwoCLAPVm38cciYyBYnWxzNQ1DPrg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75Vfa3ATc+-Luka9vJTwoCLAPVm38cciYyBYnWxzNQ1DPrg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 2021-04-29 11:52:49, Andy Shevchenko wrote:
> On Thu, Apr 29, 2021 at 11:47 AM Petr Mladek <pmladek@suse.com> wrote:
> >
> > On Wed 2021-04-28 21:59:27, Jia He wrote:
> > > From: Linus Torvalds <torvalds@linux-foundation.org>
> > >
> > > We have '%pD'(no digit following) for printing a filename. It may not be
> > > perfect (by default it only prints one component.
> > >
> > > %pD4 should be more than good enough, but we should make plain "%pD" mean
> > > "as much of the path that is reasonable" rather than "as few components as
> > > possible" (ie 1).
> >
> > Could you please provide link to the discussion where this idea was
> > came from?
> 
> https://lore.kernel.org/lkml/20210427025805.GD3122264@magnolia/

Thanks for the link. I see that it was not clear whether the patch
was good for %pd behavior.

Linus actually suggests to keep %pd behavior as it was before, see
https://lore.kernel.org/lkml/CAHk-=wimsMqGdzik187YWLb-ru+iktb4MYbMQG1rnZ81dXYFVg@mail.gmail.com/

Well, I think that this is up to the file system developers to decide.
I am not sure if the path would do more harm than good,
or vice versa, for dentry names.

Best Regards,
Petr
