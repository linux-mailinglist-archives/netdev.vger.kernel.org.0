Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2D9F494A80
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 10:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241014AbiATJMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 04:12:51 -0500
Received: from mga11.intel.com ([192.55.52.93]:41324 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237469AbiATJMu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jan 2022 04:12:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642669970; x=1674205970;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=O6+9vsSDVilrh7UjW1BQCXvdPjMTCzf/nC38lgkfjeM=;
  b=AHA02wk5ouwuy6W2HYrPYzS3lrrL/+qHOg0CYICTR4e+NnGDFVlrPQJY
   gUj38EYBjNh8qH1E352SLmi7aiETla3w5jUoSe+DLdc6dwhtORh48OxAB
   wwXh0qh8dDeN8ZpYxipzfTpLjwedgt6UZTGuVuF0tPJWiTOD8Hb6lBqYz
   TUbCocR9flrnZDvAlhu8UmnmUBvlBMKQk8+wBnGcT+5/+LbCwKTmYYJFo
   5Zdbc2SDIn7jtDAU5Mcfjj2Ul9fOOFojNnFmVlLIhBT6wLzbLvZBezAhi
   o0Krv3L9xYhq5xaiCt5g4CTKMsIURyXAl01a6ZaGbJ/PxuOdz23nu1+ji
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10232"; a="242871050"
X-IronPort-AV: E=Sophos;i="5.88,302,1635231600"; 
   d="scan'208";a="242871050"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2022 01:12:43 -0800
X-IronPort-AV: E=Sophos;i="5.88,302,1635231600"; 
   d="scan'208";a="532691996"
Received: from davidfsc-mobl3.ger.corp.intel.com (HELO localhost) ([10.252.52.140])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2022 01:12:32 -0800
From:   Jani Nikula <jani.nikula@linux.intel.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Lucas De Marchi <lucas.demarchi@intel.com>,
        linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
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
In-Reply-To: <YekfbKMjOP9ecc5v@alley>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20220119072450.2890107-1-lucas.demarchi@intel.com>
 <YegPiR7LU8aVisMf@alley> <87tudzbykz.fsf@intel.com>
 <YekfbKMjOP9ecc5v@alley>
Date:   Thu, 20 Jan 2022 11:12:27 +0200
Message-ID: <8735libwjo.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Jan 2022, Petr Mladek <pmladek@suse.com> wrote:
> On Wed 2022-01-19 16:16:12, Jani Nikula wrote:
>> On Wed, 19 Jan 2022, Petr Mladek <pmladek@suse.com> wrote:
>> > On Tue 2022-01-18 23:24:47, Lucas De Marchi wrote:
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
>
> It is also possible to support both notations at the beginning.
> And convert the existing users in the 2nd step.
>
>> What I do mind is grinding this series to a halt once again. I sent a
>> handful of versions of this three years ago, with inconclusive
>> bikeshedding back and forth, eventually threw my hands up in disgust,
>> and walked away.
>
> Yeah, and I am sorry for bikeshedding. Honestly, I do not know what is
> better. This is why I do not want to block this series when others
> like this.
>
> My main motivation is to point out that:
>
>     enabledisable(enable)
>
> might be, for some people, more eye bleeding than
>
>     enable ? "enable" : "disable"
>
>
> The problem is not that visible with yesno() and onoff(). But as you said,
> onoff() confliscts with variable names. And enabledisable() sucks.
> As a result, there is a non-trivial risk of two mass changes:

My point is, in the past three years we could have churned through more
than two mass renames just fine, if needed, *if* we had just managed to
merge something for a start!

BR,
Jani.

>
> now:
>
> - contition ? "yes" : "no"
> + yesno(condition)
>
> a few moths later:
>
> - yesno(condition)
> + str_yes_no(condition)
>
>
> Best Regards,
> Petr

-- 
Jani Nikula, Intel Open Source Graphics Center
