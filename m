Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D65E649CCC6
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 15:53:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242385AbiAZOxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 09:53:07 -0500
Received: from mga05.intel.com ([192.55.52.43]:27414 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235644AbiAZOxF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 09:53:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643208785; x=1674744785;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=7n8kP29+3QJkGEyq+fGxF09Qxaj32zhHfyUa9OrAKE0=;
  b=hRsjMEwxxl2F8Q07KpwvY/59y5XI86DOtvEj26l8s+djMq0CU+MeFxhG
   VcOxmXV5DVFME2tUG8ZsnJEam5w9KqtNgcTB/nOOJGBczPQntVA32wAcT
   GUrtwzJ726DWwzrrPn3eb5CXdMkeap4iip1hDp7SbqkSm+HRjJwSzvtam
   Rvnmf6E11mO0NQh/qc/grUnMNGpqFaoRNejuyOy4I85irumjTYEdLsIiB
   T7b9ZkwzRO415PjB+5E8aJXWskmg1/LIDXmNpRHVgz3hDoy/4y5fhaMXt
   +hk2vtzkdMQPhzdrMidxpMGynCn0mC5cu1Z8bD1bHB78khy+KoYSdoEHw
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10238"; a="332918084"
X-IronPort-AV: E=Sophos;i="5.88,318,1635231600"; 
   d="scan'208";a="332918084"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 06:53:04 -0800
X-IronPort-AV: E=Sophos;i="5.88,318,1635231600"; 
   d="scan'208";a="520821374"
Received: from nbasu-mobl.ger.corp.intel.com (HELO localhost) ([10.252.16.197])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 06:52:53 -0800
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
        "David S. Miller" <davem@davemloft.net>,
        Emma Anholt <emma@anholt.net>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Harry Wentland <harry.wentland@amd.com>,
        Jakub Kicinski <kuba@kernel.org>,
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
Subject: Re: [PATCH v2 02/11] drm/i915: Fix trailing semicolon
In-Reply-To: <20220126093951.1470898-3-lucas.demarchi@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20220126093951.1470898-1-lucas.demarchi@intel.com>
 <20220126093951.1470898-3-lucas.demarchi@intel.com>
Date:   Wed, 26 Jan 2022 16:52:50 +0200
Message-ID: <874k5qzgzh.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Jan 2022, Lucas De Marchi <lucas.demarchi@intel.com> wrote:
> Remove the trailing semicolon, as correctly warned by checkpatch:
>
> 	-:1189: WARNING:TRAILING_SEMICOLON: macros should not use a trailing semicolon
> 	#1189: FILE: drivers/gpu/drm/i915/intel_device_info.c:119:
> 	+#define PRINT_FLAG(name) drm_printf(p, "%s: %s\n", #name, yesno(info->display.name));
>
> Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>

Reviewed-by: Jani Nikula <jani.nikula@intel.com>

> ---
>  drivers/gpu/drm/i915/intel_device_info.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/i915/intel_device_info.c b/drivers/gpu/drm/i915/intel_device_info.c
> index 93b251b25aba..94da5aa37391 100644
> --- a/drivers/gpu/drm/i915/intel_device_info.c
> +++ b/drivers/gpu/drm/i915/intel_device_info.c
> @@ -114,7 +114,7 @@ void intel_device_info_print_static(const struct intel_device_info *info,
>  	DEV_INFO_FOR_EACH_FLAG(PRINT_FLAG);
>  #undef PRINT_FLAG
>  
> -#define PRINT_FLAG(name) drm_printf(p, "%s: %s\n", #name, yesno(info->display.name));
> +#define PRINT_FLAG(name) drm_printf(p, "%s: %s\n", #name, yesno(info->display.name))
>  	DEV_INFO_DISPLAY_FOR_EACH_FLAG(PRINT_FLAG);
>  #undef PRINT_FLAG
>  }

-- 
Jani Nikula, Intel Open Source Graphics Center
