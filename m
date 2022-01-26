Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 305FD49C75A
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 11:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239844AbiAZKXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 05:23:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiAZKXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 05:23:24 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D522C06161C;
        Wed, 26 Jan 2022 02:23:24 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id r10so37285493edt.1;
        Wed, 26 Jan 2022 02:23:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ii7o+rApOV9c1TS9mkx6aDYIwS5s1Dz6MCJYhhLsikE=;
        b=Ln8amVerCzYz68x4zhhZMfq3Pzh+9Uxd/aMxebrg76kqFnhS5Y1yQlqRX7BB8j7qfD
         nvKLtBp9Hj8dvf8Pezk6nVo62kXsDWJLhU6xzCclmoOwNgmxquPDs7YXmBxUJPVNoxyt
         cRgDI87fT6C5xCT4r3lORmqRw5CbUFi4CbRkUoLbAbVEDUFE2iCal5gdJ5KOKNCtE1qv
         gxnyrSXzSHn+q88EOMlxmOvElZxknK+WwUDFYJctt8D1L54oVVbkfipcnaJJo9X65zJd
         GfdCnIfQerYPKrPpRhM697M24JcQoWzb9/lMfD8P0a70ZwrDzPtb58tUzSLpfCUHhyBF
         eBSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ii7o+rApOV9c1TS9mkx6aDYIwS5s1Dz6MCJYhhLsikE=;
        b=vSoznErQR0v2sA9OIYavYKZxT/DAbmLTRFArB/Yy2GdlYNGCHVR+Mnk/1FVqug0IKg
         b+XAF+6tAiRh/LKIpKdV2pDJDeZYx4bxOaB/i4g91gZlJwReEH4nhIHwURYwFGXvafsk
         PNyltTtoN9ka9prLpIHyFt2RfNXyBplgoXZIfoFoxDt+wZejQfpas6nOLjZq/2Frvbz2
         imMcnnpfGtr/QNTX1Hjs4eUW3JJomb6isxIIAIxsp1yUfv0vHN8iIs9c+OBpnF1os387
         OMzHZHt4UqqfoEyT2atu4uRp7lzWD8k6W1w3p11wCqi7ubIP/PXwOuKdMh2xOGFbDUiW
         fr7A==
X-Gm-Message-State: AOAM5306vXDVzWqDYHsZ2sg0FjqB0GXFFZLTIhJs5GEDW22ih/7wUfub
        YFEMyx0lKnBEgKo+Gb/dpa3d3xZPXZ2Z3IIuDic=
X-Google-Smtp-Source: ABdhPJzNoLjMutkiG1rIcRLBMJYXNKAEcChNIpwB1oqibQS0oJJv8RdEKOE0ei2A5eNUb+1fDDzSSnET34BlxoFSA5s=
X-Received: by 2002:a05:6402:40cd:: with SMTP id z13mr1007577edb.158.1643192602670;
 Wed, 26 Jan 2022 02:23:22 -0800 (PST)
MIME-Version: 1.0
References: <20220126093951.1470898-1-lucas.demarchi@intel.com>
In-Reply-To: <20220126093951.1470898-1-lucas.demarchi@intel.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 26 Jan 2022 12:22:46 +0200
Message-ID: <CAHp75VcheiM7gNW+zP2Ve8qOj40158aOM0OkhUjyODd+V3sYjQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/11] lib/string_helpers: Add a few string helpers
To:     Lucas De Marchi <lucas.demarchi@intel.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        amd-gfx@lists.freedesktop.org,
        linux-security-module <linux-security-module@vger.kernel.org>,
        nouveau@lists.freedesktop.org, netdev <netdev@vger.kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        "David S. Miller" <davem@davemloft.net>,
        Emma Anholt <emma@anholt.net>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Harry Wentland <harry.wentland@amd.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        Leo Li <sunpeng.li@amd.com>, Petr Mladek <pmladek@suse.com>,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vishal Kulkarni <vishal@chelsio.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 11:39 AM Lucas De Marchi
<lucas.demarchi@intel.com> wrote:
>
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
> Now there is also the v1 of this same patch series:
> https://lore.kernel.org/all/20220119072450.2890107-1-lucas.demarchi@intel=
.com/
>
> Going through the comments I tried to find some common ground and
> justification for what is in here, addressing some of the concerns
> raised.
>
> a. This version should be a drop-in replacement for what is currently in
>    the tree, with no change in behavior or binary size. For binary
>    size what I checked was that the linked objects in the end have the
>    same size (gcc 11). From comments in the previous attempts this seems
>    also the case for earlier compiler versions
>
> b. I didn't change the function name to choice_* as suggested by Andrew
>    Morton in 20191023155619.43e0013f0c8c673a5c508c1e@linux-foundation.org
>    because other people argumented in favor of shorter names for these
>    simple helpers - if they are long and people simply not use due to
>    that, we failed. However as pointed out in v1 of this patchseries,
>    onoff(), yesno(), enabledisable(), enableddisabled() have some
>    issues: the last 2 are hard to read and for the first 2 it would not
>    be hard to have the symbol to clash with variable names.
>    From comments in v1, most people were in favor (or at least not
>    opposed) to using str_on_off(), str_yes_no(), str_enable_disable()
>    and str_enabled_disabled().
>
> c. Use string_helper.h for these helpers - pulling string.h in the
>    compilations units was one of the concerns and I think re-using this
>    already existing header is better than creating a new string-choice.h
>
> d. One alternative to all of this suggested by Christian K=C3=B6nig
>    (43456ba7-c372-84cc-4949-dcb817188e21@amd.com) would be to add a
>    printk format. But besides the comment, he also seemed to like
>    the common function. This brought the argument from others that the
>    simple yesno()/enabledisable() already used in the code (or new
>    renamed version) is easier to remember and use than e.g. %py[DOY]

I do not see any impediments to this series to be pulled.
Thanks for the work you've done!

> Changes in v2:
>
>   - Use str_ prefix and separate other words with underscore: it's a
>     little bit longer, but should improve readability
>
>   - Patches we re-split due to the rename: first patch adds all the new
>     functions, then additional patches try to do one conversion at a
>     time. While doing so, there were some fixes for issues already
>     present along the way
>
>   - Style suggestions from v1 were adopted
>
> In v1 it was suggested to apply this in drm-misc. I will leave this to
> maintainers to decide: maybe it would be simpler to merge the first
> patches on drm-intel-next, wait for the back merge and merge the rest
> through drm-misc - my fear is a big conflict with other work going in
> drm-intel-next since the bulk of the rename is there.
>
> I tried to figure out acks and reviews from v1 and apply them to how the
> patches are now split.
>
> thanks
> Lucas De Marchi
>
> Lucas De Marchi (11):
>   lib/string_helpers: Consolidate string helpers implementation
>   drm/i915: Fix trailing semicolon
>   drm/i915: Use str_yes_no()
>   drm/i915: Use str_enable_disable()
>   drm/i915: Use str_enabled_disabled()
>   drm/i915: Use str_on_off()
>   drm/amd/display: Use str_yes_no()
>   drm/gem: Sort includes alphabetically
>   drm: Convert open-coded yes/no strings to yesno()
>   tomoyo: Use str_yes_no()
>   cxgb4: Use str_yes_no()
>
>  drivers/gpu/drm/amd/amdgpu/atom.c             |   4 +-
>  .../amd/display/amdgpu_dm/amdgpu_dm_debugfs.c |  14 +-
>  drivers/gpu/drm/dp/drm_dp.c                   |   3 +-
>  drivers/gpu/drm/drm_client_modeset.c          |   3 +-
>  drivers/gpu/drm/drm_gem.c                     |  23 +-
>  drivers/gpu/drm/i915/display/g4x_dp.c         |   6 +-
>  .../gpu/drm/i915/display/intel_backlight.c    |   3 +-
>  drivers/gpu/drm/i915/display/intel_ddi.c      |   4 +-
>  drivers/gpu/drm/i915/display/intel_display.c  |  46 ++--
>  .../drm/i915/display/intel_display_debugfs.c  |  74 +++---
>  .../drm/i915/display/intel_display_power.c    |   4 +-
>  .../drm/i915/display/intel_display_trace.h    |   9 +-
>  drivers/gpu/drm/i915/display/intel_dp.c       |  20 +-
>  drivers/gpu/drm/i915/display/intel_dpll.c     |   3 +-
>  drivers/gpu/drm/i915/display/intel_dpll_mgr.c |   7 +-
>  drivers/gpu/drm/i915/display/intel_dsi_vbt.c  |   7 +-
>  drivers/gpu/drm/i915/display/intel_fbc.c      |   4 +-
>  drivers/gpu/drm/i915/display/intel_fdi.c      |   8 +-
>  drivers/gpu/drm/i915/display/intel_hdmi.c     |   3 +-
>  drivers/gpu/drm/i915/display/intel_sprite.c   |   6 +-
>  drivers/gpu/drm/i915/display/vlv_dsi_pll.c    |   3 +-
>  .../gpu/drm/i915/gem/selftests/huge_pages.c   |   9 +-
>  .../drm/i915/gem/selftests/i915_gem_context.c |   7 +-
>  drivers/gpu/drm/i915/gt/intel_breadcrumbs.c   |   3 +-
>  drivers/gpu/drm/i915/gt/intel_engine_cs.c     |  11 +-
>  .../drm/i915/gt/intel_execlists_submission.c  |   7 +-
>  drivers/gpu/drm/i915/gt/intel_gt_pm.c         |   3 +-
>  drivers/gpu/drm/i915/gt/intel_gt_pm_debugfs.c |  52 ++--
>  drivers/gpu/drm/i915/gt/intel_rc6.c           |   5 +-
>  drivers/gpu/drm/i915/gt/intel_reset.c         |   3 +-
>  drivers/gpu/drm/i915/gt/intel_rps.c           |  13 +-
>  drivers/gpu/drm/i915/gt/intel_sseu.c          |   9 +-
>  drivers/gpu/drm/i915/gt/intel_sseu_debugfs.c  |  10 +-
>  drivers/gpu/drm/i915/gt/selftest_timeline.c   |   3 +-
>  drivers/gpu/drm/i915/gt/uc/intel_guc_ct.c     |   5 +-
>  drivers/gpu/drm/i915/gt/uc/intel_guc_log.c    |   5 +-
>  drivers/gpu/drm/i915/gt/uc/intel_guc_rc.c     |   6 +-
>  drivers/gpu/drm/i915/gt/uc/intel_guc_slpc.c   |   4 +-
>  drivers/gpu/drm/i915/gt/uc/intel_uc.c         |  14 +-
>  drivers/gpu/drm/i915/gt/uc/intel_uc_debugfs.c |  20 +-
>  drivers/gpu/drm/i915/i915_debugfs.c           |  17 +-
>  drivers/gpu/drm/i915/i915_driver.c            |   4 +-
>  drivers/gpu/drm/i915/i915_gpu_error.c         |   9 +-
>  drivers/gpu/drm/i915/i915_params.c            |   5 +-
>  drivers/gpu/drm/i915/i915_utils.h             |  21 +-
>  drivers/gpu/drm/i915/intel_device_info.c      |   8 +-
>  drivers/gpu/drm/i915/intel_dram.c             |  10 +-
>  drivers/gpu/drm/i915/intel_pm.c               |  14 +-
>  drivers/gpu/drm/i915/pxp/intel_pxp_debugfs.c  |   4 +-
>  drivers/gpu/drm/i915/selftests/i915_active.c  |   3 +-
>  drivers/gpu/drm/i915/vlv_suspend.c            |   3 +-
>  drivers/gpu/drm/nouveau/nvkm/subdev/i2c/aux.c |   5 +-
>  drivers/gpu/drm/radeon/atom.c                 |   3 +-
>  drivers/gpu/drm/v3d/v3d_debugfs.c             |  11 +-
>  drivers/gpu/drm/virtio/virtgpu_debugfs.c      |   4 +-
>  .../ethernet/chelsio/cxgb4/cxgb4_debugfs.c    | 249 ++++++++++--------
>  include/linux/string_helpers.h                |  20 ++
>  security/tomoyo/audit.c                       |   2 +-
>  security/tomoyo/common.c                      |  19 +-
>  security/tomoyo/common.h                      |   1 -
>  60 files changed, 482 insertions(+), 373 deletions(-)
>
> --
> 2.34.1
>


--=20
With Best Regards,
Andy Shevchenko
