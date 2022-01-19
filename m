Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE7F49421E
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 21:53:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234399AbiASUxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 15:53:47 -0500
Received: from mga09.intel.com ([134.134.136.24]:55117 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229683AbiASUxq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jan 2022 15:53:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642625626; x=1674161626;
  h=date:from:to:subject:message-id:references:mime-version:
   in-reply-to;
  bh=cH3bHFZpGH0RESw8RskOlsgeHxPQYCpLCLkrUAgJ7oE=;
  b=N5V9BrYPZPe3+kNXJlVabWxsBtq7kBqY2EhPMRwpa8ZvXa3m07nkcgr/
   Q+lHFLsNHXStpIWuiUtZGItH2cEt2JEjDp7IQJTpE1i6EEtbODPef+3FU
   OV/JI1IKdZzmKbu3U+fFKqWZAM9JILGZwX0/w1JRjA7j/1bceMy3tF8eF
   EN9/KiqLGG0M5+BKMQoOgiNZCU8eJ6023VC7oUVfoRqWPrmTbq8eH1TPS
   Op2CrI2jwEiWYjtMNpUz2MJjz0S8HFb3rlTkR0sVfjMqtPe3dQTpWMtyV
   bbemB1boFVF2qw/ZhBHqoiVlLgZ0CaXQ4zhReCc21iP3I119Ia2wPqalu
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10231"; a="244984193"
X-IronPort-AV: E=Sophos;i="5.88,300,1635231600"; 
   d="scan'208";a="244984193"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2022 12:53:45 -0800
X-IronPort-AV: E=Sophos;i="5.88,300,1635231600"; 
   d="scan'208";a="765081592"
Received: from atefehad-mobl1.amr.corp.intel.com (HELO ldmartin-desk2) ([10.212.238.132])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2022 12:53:44 -0800
Date:   Wed, 19 Jan 2022 12:53:43 -0800
From:   Lucas De Marchi <lucas.demarchi@intel.com>
To:     Jani Nikula <jani.nikula@linux.intel.com>,
        Petr Mladek <pmladek@suse.com>, linux-kernel@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        amd-gfx@lists.freedesktop.org,
        linux-security-module@vger.kernel.org,
        nouveau@lists.freedesktop.org, netdev@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Emma Anholt <emma@anholt.net>, Eryk Brol <eryk.brol@amd.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Harry Wentland <harry.wentland@amd.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        Leo Li <sunpeng.li@amd.com>,
        Mikita Lipski <mikita.lipski@amd.com>,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vishal Kulkarni <vishal@chelsio.com>
Subject: Re: [Intel-gfx] [PATCH 0/3] lib/string_helpers: Add a few string
 helpers
Message-ID: <20220119205343.kd5cwfzpg4mlsekk@ldmartin-desk2>
X-Patchwork-Hint: comment
References: <20220119072450.2890107-1-lucas.demarchi@intel.com>
 <YegPiR7LU8aVisMf@alley>
 <87tudzbykz.fsf@intel.com>
 <Yeg5BpV8tknSPdSQ@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Yeg5BpV8tknSPdSQ@phenom.ffwll.local>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 19, 2022 at 05:15:02PM +0100, Daniel Vetter wrote:
>On Wed, Jan 19, 2022 at 04:16:12PM +0200, Jani Nikula wrote:
>> On Wed, 19 Jan 2022, Petr Mladek <pmladek@suse.com> wrote:
>> > On Tue 2022-01-18 23:24:47, Lucas De Marchi wrote:
>> >> Add some helpers under lib/string_helpers.h so they can be used
>> >> throughout the kernel. When I started doing this there were 2 other
>> >> previous attempts I know of, not counting the iterations each of them
>> >> had:
>> >>
>> >> 1) https://lore.kernel.org/all/20191023131308.9420-1-jani.nikula@intel.com/
>> >> 2) https://lore.kernel.org/all/20210215142137.64476-1-andriy.shevchenko@linux.intel.com/#t
>> >>
>> >> Going through the comments I tried to find some common ground and
>> >> justification for what is in here, addressing some of the concerns
>> >> raised.
>> >>
>> >> d. This doesn't bring onoff() helper as there are some places in the
>> >>    kernel with onoff as variable - another name is probably needed for
>> >>    this function in order not to shadow the variable, or those variables
>> >>    could be renamed.  Or if people wanting  <someprefix>
>> >>    try to find a short one
>> >
>> > I would call it str_on_off().
>> >
>> > And I would actually suggest to use the same style also for
>> > the other helpers.
>> >
>> > The "str_" prefix would make it clear that it is something with
>> > string. There are other <prefix>_on_off() that affect some
>> > functionality, e.g. mute_led_on_off(), e1000_vlan_filter_on_off().
>> >
>> > The dash '_' would significantly help to parse the name. yesno() and
>> > onoff() are nicely short and kind of acceptable. But "enabledisable()"
>> > is a puzzle.
>> >
>> > IMHO, str_yes_no(), str_on_off(), str_enable_disable() are a good
>> > compromise.
>> >
>> > The main motivation should be code readability. You write the
>> > code once. But many people will read it many times. Open coding
>> > is sometimes better than misleading macro names.
>> >
>> > That said, I do not want to block this patchset. If others like
>> > it... ;-)
>>
>> I don't mind the names either way. Adding the prefix and dashes is
>> helpful in that it's possible to add the functions first and convert
>> users at leisure, though with a bunch of churn, while using names that
>> collide with existing ones requires the changes to happen in one go.
>>
>> What I do mind is grinding this series to a halt once again. I sent a
>> handful of versions of this three years ago, with inconclusive
>> bikeshedding back and forth, eventually threw my hands up in disgust,
>> and walked away.
>
>Yeah we can sed this anytime later we want to, but we need to get the foot
>in the door. There's also a pile more of these all over.
>
>Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>
>on the series, maybe it helps? And yes let's merge this through drm-misc.

Ok, it seems we are reaching some agreement here then:

- Change it to use str_ prefix
- Wait -rc1 to avoid conflict
- Merge through drm-misc

I will re-send the series again soon.

Lucas De Marchi
