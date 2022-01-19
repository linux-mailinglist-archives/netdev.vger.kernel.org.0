Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C75ED4935FD
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 09:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351883AbiASIDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 03:03:01 -0500
Received: from mga14.intel.com ([192.55.52.115]:29408 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343971AbiASIC6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jan 2022 03:02:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642579378; x=1674115378;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version:content-transfer-encoding;
  bh=ttJ0yEmqdVCXnFR0RzsiyMUeg+GLGi5ZbTTPlF7sNtk=;
  b=mYrG9e1ovvkPWdIPpvPg8Wcb91xVxVYzvBRnOaBXEv/WatO+rbVHty+Q
   qz5hq6PY2pYP4z9wsS/r2rDIEuc9SwbuikVueEVdgKnQxT38agZFYmU6A
   j5os+aYPLDltT7j14kr9w3cqggXFvtLZ7+r4dzhJL7u82VAF58JXRijhz
   pGIDftbqzZFsR4i7bhLWpSib/7jIip1WAc0np29DmMpwKUQWkZnEOvvLn
   Pq9B/l7WIF3XrlvNKz+MY1lsDXsj5hMKfqiTYNJlakSzvn5yn7F7Wg4xZ
   zoSdgdu1dZM88htGut04hqWi3aoj+L0yywzBPcxbE7QGa3ButDb8QapP6
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10231"; a="245207743"
X-IronPort-AV: E=Sophos;i="5.88,299,1635231600"; 
   d="scan'208";a="245207743"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2022 00:02:47 -0800
X-IronPort-AV: E=Sophos;i="5.88,299,1635231600"; 
   d="scan'208";a="477282343"
Received: from elenadel-mobl.ger.corp.intel.com (HELO localhost) ([10.252.50.196])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2022 00:02:33 -0800
From:   Jani Nikula <jani.nikula@linux.intel.com>
To:     Lucas De Marchi <lucas.demarchi@intel.com>,
        linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        linux-security-module@vger.kernel.org,
        nouveau@lists.freedesktop.org, netdev@vger.kernel.org
Cc:     Alex Deucher <alexander.deucher@amd.com>,
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
        Petr Mladek <pmladek@suse.com>,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vishal Kulkarni <vishal@chelsio.com>
Subject: Re: [PATCH 0/3] lib/string_helpers: Add a few string helpers
In-Reply-To: <20220119072450.2890107-1-lucas.demarchi@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20220119072450.2890107-1-lucas.demarchi@intel.com>
Date:   Wed, 19 Jan 2022 10:02:31 +0200
Message-ID: <87sftk40h4.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Jan 2022, Lucas De Marchi <lucas.demarchi@intel.com> wrote:
> Add some helpers under lib/string_helpers.h so they can be used
> throughout the kernel. When I started doing this there were 2 other
> previous attempts I know of, not counting the iterations each of them
> had:
>
> 1) https://lore.kernel.org/all/20191023131308.9420-1-jani.nikula@intel.co=
m/
> 2) https://lore.kernel.org/all/20210215142137.64476-1-andriy.shevchenko@l=
inux.intel.com/#t
>
> Going through the comments I tried to find some common ground and
> justification for what is in here, addressing some of the concerns
> raised.
>
> a. This version should be a drop-in replacement for what is currently in
>    the tree, with no change in behavior or binary size. For binary
>    size what I checked wat that the linked objects in the end have the
>    same size (gcc 11). From comments in the previous attempts this seems
>    also the case for earlier compiler versions
>
> b. I didn't change the function name to choice_* as suggested by Andrew
>    Morton in 20191023155619.43e0013f0c8c673a5c508c1e@linux-foundation.org
>    because other people argumented in favor of shorter names for these
>    simple helpers - if they are long and people simply not use due to
>    that, we failed
>
> c. Use string_helper.h for these helpers - pulling string.h in the
>    compilations units was one of the concerns and I think re-using this
>    already existing header is better than creating a new string-choice.h
>
> d. This doesn't bring onoff() helper as there are some places in the
>    kernel with onoff as variable - another name is probably needed for
>    this function in order not to shadow the variable, or those variables
>    could be renamed.  Or if people wanting  <someprefix>
>    try to find a short one
>
> e. One alternative to all of this suggested by Christian K=C3=B6nig
>    (43456ba7-c372-84cc-4949-dcb817188e21@amd.com) would be to add a
>    printk format. But besides the comment, he also seemed to like
>    the common function. This brought the argument from others that the
>    simple yesno()/enabledisable() already used in the code is easier to
>    remember and use than e.g. %py[DOY]
>
> Last patch also has some additional conversion of open coded cases. I
> preferred starting with drm/ since this is "closer to home".
>
> I hope this is a good summary of the previous attempts and a way we can
> move forward.

Thanks for picking this up again. I agree with the approach here.

Acked-by: Jani Nikula <jani.nikula@intel.com>

>
> Andrew Morton, Petr Mladek, Andy Shevchenko: if this is accepted, my
> proposal is to take first 2 patches either through mm tree or maybe
> vsprintf. Last patch can be taken later through drm.
>
> thanks
> Lucas De Marchi
>
> Cc: Alex Deucher <alexander.deucher@amd.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
> Cc: Ben Skeggs <bskeggs@redhat.com>
> Cc: Christian K=C3=B6nig <christian.koenig@amd.com>
> Cc: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Daniel Vetter <daniel@ffwll.ch>
> Cc: David Airlie <airlied@linux.ie>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Emma Anholt <emma@anholt.net>
> Cc: Eryk Brol <eryk.brol@amd.com>
> Cc: Francis Laniel <laniel_francis@privacyrequired.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Harry Wentland <harry.wentland@amd.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Jani Nikula <jani.nikula@linux.intel.com>
> Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> Cc: Julia Lawall <julia.lawall@lip6.fr>
> Cc: Kentaro Takeda <takedakn@nttdata.co.jp>
> Cc: Leo Li <sunpeng.li@amd.com>
> Cc: Mikita Lipski <mikita.lipski@amd.com>
> Cc: Petr Mladek <pmladek@suse.com>
> Cc: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
> Cc: Raju Rangoju <rajur@chelsio.com>
> Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Vishal Kulkarni <vishal@chelsio.com>
>
> Lucas De Marchi (3):
>   lib/string_helpers: Consolidate yesno() implementation
>   lib/string_helpers: Add helpers for enable[d]/disable[d]
>   drm: Convert open yes/no strings to yesno()
>
>  drivers/gpu/drm/amd/amdgpu/atom.c              |  3 ++-
>  .../amd/display/amdgpu_dm/amdgpu_dm_debugfs.c  |  6 +-----
>  drivers/gpu/drm/drm_client_modeset.c           |  3 ++-
>  drivers/gpu/drm/drm_dp_helper.c                |  3 ++-
>  drivers/gpu/drm/drm_gem.c                      |  3 ++-
>  drivers/gpu/drm/i915/i915_utils.h              | 15 ---------------
>  drivers/gpu/drm/nouveau/nvkm/subdev/i2c/aux.c  |  4 +++-
>  drivers/gpu/drm/radeon/atom.c                  |  3 ++-
>  drivers/gpu/drm/v3d/v3d_debugfs.c              | 11 ++++++-----
>  drivers/gpu/drm/virtio/virtgpu_debugfs.c       |  3 ++-
>  .../net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c | 11 -----------
>  include/linux/string_helpers.h                 |  4 ++++
>  security/tomoyo/audit.c                        |  2 +-
>  security/tomoyo/common.c                       | 18 ++++--------------
>  security/tomoyo/common.h                       |  1 -
>  15 files changed, 31 insertions(+), 59 deletions(-)

--=20
Jani Nikula, Intel Open Source Graphics Center
