Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3266CD9D7
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 15:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbjC2NBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 09:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbjC2NBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 09:01:46 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9EC9CA;
        Wed, 29 Mar 2023 06:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680094903; x=1711630903;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=M8LKsGXgrEqKUdUv7wna8yZG8GZaTqDF9eASbo6RR20=;
  b=CWdgPOH2bdOU5xUVqZ48Q0qGQ6waOR3tgi7rGSCjtKECn0CQ8Nf9LG9g
   WeWBhapWuaAEPdBG/fQSGkQ0RPYq3OxXIeswWrMAyI9r6agxecN+Rr7kX
   NumRDFgLtyd1YpMXkcbc9Y8Z6/5BNq8I5i+6MLD0K+S0YlCNaFe4wB8yJ
   M1QYtg1v8P+sb9AOnylEpt2dajgPEIULiCzu/uuS5am24EANbS4VKStaP
   6cN9iDxxuWkOQy5alNgRkwuf8voS71crP2nGQuJB+9+2hLGhFLK4h5DTG
   dlYGDXTa2Ejs6s6Z9KseerzjHuhDIJAFmHYVJd0HuKDtnmxJh71zMm0gk
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="368638253"
X-IronPort-AV: E=Sophos;i="5.98,300,1673942400"; 
   d="scan'208";a="368638253"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2023 06:01:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="1014010988"
X-IronPort-AV: E=Sophos;i="5.98,300,1673942400"; 
   d="scan'208";a="1014010988"
Received: from ostermam-mobl.amr.corp.intel.com (HELO intel.com) ([10.249.32.144])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2023 06:01:35 -0700
Date:   Wed, 29 Mar 2023 15:01:10 +0200
From:   Andi Shyti <andi.shyti@linux.intel.com>
To:     Andrzej Hajda <andrzej.hajda@intel.com>
Cc:     Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>, linux-kernel@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andi Shyti <andi.shyti@linux.intel.com>
Subject: Re: [PATCH v6 0/8] drm/i915: use ref_tracker library for tracking
 wakerefs
Message-ID: <ZCQ2lr6/ITBdBqce@ashyti-mobl2.lan>
References: <20230224-track_gt-v6-0-0dc8601fd02f@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224-track_gt-v6-0-0dc8601fd02f@intel.com>
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric, David (Miller),

Could you please check the ref_tracker portion of this series?

This patch has reached its 6th version, and we need your approval
to proceed.

Thank you,
Andi

On Wed, Mar 29, 2023 at 09:24:12AM +0200, Andrzej Hajda wrote:
> Gently ping for network developers, could you look at ref_tracker patches,
> as the ref_tracker library was developed for network.
> 
> This is revived patchset improving ref_tracker library and converting
> i915 internal tracker to ref_tracker.
> The old thread ended without consensus about small kernel allocations,
> which are performed under spinlock.
> I have tried to solve the problem by splitting the calls, but it results
> in complicated API, so I went back to original solution.
> If there are better solutions I am glad to discuss them.
> Meanwhile I send original patchset with addressed remaining comments.
> 
> To: Jani Nikula <jani.nikula@linux.intel.com>
> To: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> To: Rodrigo Vivi <rodrigo.vivi@intel.com>
> To: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
> To: David Airlie <airlied@gmail.com>
> To: Daniel Vetter <daniel@ffwll.ch>
> Cc: linux-kernel@vger.kernel.org
> Cc: intel-gfx@lists.freedesktop.org
> Cc: dri-devel@lists.freedesktop.org
> Cc: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: netdev@vger.kernel.org
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Andi Shyti <andi.shyti@linux.intel.com>
> Cc: Das, Nirmoy <nirmoy.das@linux.intel.com>
> Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
> 
> ---
> Changes in v6:
> - rebased to solve minor conflict and allow CI testing
> - Link to v5: https://lore.kernel.org/r/20230224-track_gt-v5-0-77be86f2c872@intel.com
> 
> Changes in v5 (thx Andi for review):
> - use *_locked convention instead of __*,
> - improved commit messages,
> - re-worked i915 patches, squashed separation and conversion patches,
> - added tags,
> - Link to v4: https://lore.kernel.org/r/20230224-track_gt-v4-0-464e8ab4c9ab@intel.com
> 
> Changes in v4:
> - split "Separate wakeref tracking" to smaller parts
> - fixed typos,
> - Link to v1-v3: https://patchwork.freedesktop.org/series/100327/
> 
> ---
> Andrzej Hajda (7):
>       lib/ref_tracker: add unlocked leak print helper
>       lib/ref_tracker: improve printing stats
>       lib/ref_tracker: add printing to memory buffer
>       lib/ref_tracker: remove warnings in case of allocation failure
>       drm/i915: Correct type of wakeref variable
>       drm/i915: Replace custom intel runtime_pm tracker with ref_tracker library
>       drm/i915: track gt pm wakerefs
> 
> Chris Wilson (1):
>       drm/i915/gt: Hold a wakeref for the active VM
> 
>  drivers/gpu/drm/i915/Kconfig.debug                 |  19 ++
>  drivers/gpu/drm/i915/display/intel_display_power.c |   2 +-
>  drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c     |   7 +-
>  .../drm/i915/gem/selftests/i915_gem_coherency.c    |  10 +-
>  drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c |  14 +-
>  drivers/gpu/drm/i915/gt/intel_breadcrumbs.c        |  13 +-
>  drivers/gpu/drm/i915/gt/intel_breadcrumbs_types.h  |   3 +-
>  drivers/gpu/drm/i915/gt/intel_context.h            |  15 +-
>  drivers/gpu/drm/i915/gt/intel_context_types.h      |   2 +
>  drivers/gpu/drm/i915/gt/intel_engine_pm.c          |  10 +-
>  drivers/gpu/drm/i915/gt/intel_engine_types.h       |   2 +
>  .../gpu/drm/i915/gt/intel_execlists_submission.c   |   2 +-
>  drivers/gpu/drm/i915/gt/intel_gt_pm.c              |  12 +-
>  drivers/gpu/drm/i915/gt/intel_gt_pm.h              |  38 +++-
>  drivers/gpu/drm/i915/gt/intel_gt_pm_debugfs.c      |   4 +-
>  drivers/gpu/drm/i915/gt/selftest_engine_cs.c       |  20 +-
>  drivers/gpu/drm/i915/gt/selftest_gt_pm.c           |   5 +-
>  drivers/gpu/drm/i915/gt/selftest_reset.c           |  10 +-
>  drivers/gpu/drm/i915/gt/selftest_rps.c             |  17 +-
>  drivers/gpu/drm/i915/gt/selftest_slpc.c            |   5 +-
>  drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c  |  11 +-
>  drivers/gpu/drm/i915/i915_driver.c                 |   2 +-
>  drivers/gpu/drm/i915/i915_pmu.c                    |  16 +-
>  drivers/gpu/drm/i915/intel_runtime_pm.c            | 221 ++-------------------
>  drivers/gpu/drm/i915/intel_runtime_pm.h            |  11 +-
>  drivers/gpu/drm/i915/intel_wakeref.c               |   7 +-
>  drivers/gpu/drm/i915/intel_wakeref.h               |  99 ++++++++-
>  include/linux/ref_tracker.h                        |  31 ++-
>  lib/ref_tracker.c                                  | 179 ++++++++++++++---
>  29 files changed, 456 insertions(+), 331 deletions(-)
> ---
> base-commit: d4c9fe2c8c9b66c5e5954f6ded7bc934dd6afe3e
> change-id: 20230224-track_gt-1b3da8bdacd7
> 
> Best regards,
> -- 
> Andrzej Hajda <andrzej.hajda@intel.com>
