Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17E42493BD0
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 15:16:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355089AbiASOQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 09:16:42 -0500
Received: from mga12.intel.com ([192.55.52.136]:25226 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354883AbiASOQl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jan 2022 09:16:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642601801; x=1674137801;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version:content-transfer-encoding;
  bh=d7hVq3oxHgek+LZjbNjbhxHHdzW6IMVr8vZX6/zGsrc=;
  b=PAuZNY+l3cVvbaSTkVVnimj8WozeX9hjBqQoNkX5SaYtnxi6wLByBDMo
   udgUsc4ojTh0yG/TCNpYNYOZYxhPbW7/Z9rCv0HzRYpK8QGf7IemCVl+Q
   ysbpUN5G8iihC5ZSovQbxsUbdM69smXLXkiF8RdlPXQpVzEdgncnkGCRB
   udVJ4B0QSr0hnIg48SPwWuiETDlgCauUVf67Zm44CUpN1LewFjBNaDwNl
   ElFzZoK12qBOdo8aJWDtBNzqYw0WY9S1PBxlBGOw6Gwy+mOJKCUio4Lo0
   imqDCAO/MyN2hEj6arkHM6V7YBZWf97KlelrXX4L735g8bLOSziFraiVq
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10231"; a="225051231"
X-IronPort-AV: E=Sophos;i="5.88,299,1635231600"; 
   d="scan'208";a="225051231"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2022 06:16:39 -0800
X-IronPort-AV: E=Sophos;i="5.88,299,1635231600"; 
   d="scan'208";a="477387201"
Received: from elenadel-mobl.ger.corp.intel.com (HELO localhost) ([10.252.50.196])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2022 06:16:15 -0800
From:   Jani Nikula <jani.nikula@linux.intel.com>
To:     Petr Mladek <pmladek@suse.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>
Cc:     linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        linux-security-module@vger.kernel.org,
        nouveau@lists.freedesktop.org, netdev@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Christian =?utf-8?Q?K=C3=B6nig?= <christian.koenig@amd.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel@ffwll.ch>,
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
Subject: Re: [PATCH 0/3] lib/string_helpers: Add a few string helpers
In-Reply-To: <YegPiR7LU8aVisMf@alley>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20220119072450.2890107-1-lucas.demarchi@intel.com>
 <YegPiR7LU8aVisMf@alley>
Date:   Wed, 19 Jan 2022 16:16:12 +0200
Message-ID: <87tudzbykz.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Jan 2022, Petr Mladek <pmladek@suse.com> wrote:
> On Tue 2022-01-18 23:24:47, Lucas De Marchi wrote:
>> Add some helpers under lib/string_helpers.h so they can be used
>> throughout the kernel. When I started doing this there were 2 other
>> previous attempts I know of, not counting the iterations each of them
>> had:
>>=20
>> 1) https://lore.kernel.org/all/20191023131308.9420-1-jani.nikula@intel.c=
om/
>> 2) https://lore.kernel.org/all/20210215142137.64476-1-andriy.shevchenko@=
linux.intel.com/#t
>>=20
>> Going through the comments I tried to find some common ground and
>> justification for what is in here, addressing some of the concerns
>> raised.
>>=20
>> d. This doesn't bring onoff() helper as there are some places in the
>>    kernel with onoff as variable - another name is probably needed for
>>    this function in order not to shadow the variable, or those variables
>>    could be renamed.  Or if people wanting  <someprefix>
>>    try to find a short one
>
> I would call it str_on_off().
>
> And I would actually suggest to use the same style also for
> the other helpers.
>
> The "str_" prefix would make it clear that it is something with
> string. There are other <prefix>_on_off() that affect some
> functionality, e.g. mute_led_on_off(), e1000_vlan_filter_on_off().
>
> The dash '_' would significantly help to parse the name. yesno() and
> onoff() are nicely short and kind of acceptable. But "enabledisable()"
> is a puzzle.
>
> IMHO, str_yes_no(), str_on_off(), str_enable_disable() are a good
> compromise.
>
> The main motivation should be code readability. You write the
> code once. But many people will read it many times. Open coding
> is sometimes better than misleading macro names.
>
> That said, I do not want to block this patchset. If others like
> it... ;-)

I don't mind the names either way. Adding the prefix and dashes is
helpful in that it's possible to add the functions first and convert
users at leisure, though with a bunch of churn, while using names that
collide with existing ones requires the changes to happen in one go.

What I do mind is grinding this series to a halt once again. I sent a
handful of versions of this three years ago, with inconclusive
bikeshedding back and forth, eventually threw my hands up in disgust,
and walked away.

>
>
>> e. One alternative to all of this suggested by Christian K=C3=B6nig
>>    (43456ba7-c372-84cc-4949-dcb817188e21@amd.com) would be to add a
>>    printk format. But besides the comment, he also seemed to like
>>    the common function. This brought the argument from others that the
>>    simple yesno()/enabledisable() already used in the code is easier to
>>    remember and use than e.g. %py[DOY]
>
> Thanks for not going this way :-)
>
>> Last patch also has some additional conversion of open coded cases. I
>> preferred starting with drm/ since this is "closer to home".
>>=20
>> I hope this is a good summary of the previous attempts and a way we can
>> move forward.
>>=20
>> Andrew Morton, Petr Mladek, Andy Shevchenko: if this is accepted, my
>> proposal is to take first 2 patches either through mm tree or maybe
>> vsprintf. Last patch can be taken later through drm.
>
> I agree with Andy that it should go via drm tree. It would make it
> easier to handle potential conflicts.
>
> Just in case, you decide to go with str_yes_no() or something similar.
> Mass changes are typically done at the end on the merge window.
> The best solution is when it can be done by a script.
>
> Best Regards,
> Petr

--=20
Jani Nikula, Intel Open Source Graphics Center
