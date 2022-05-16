Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 377D4528DB4
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 21:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345284AbiEPTGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 15:06:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345325AbiEPTGK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 15:06:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F31920BD8;
        Mon, 16 May 2022 12:06:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBB50614CB;
        Mon, 16 May 2022 19:06:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83024C385AA;
        Mon, 16 May 2022 19:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652727967;
        bh=2Resw6p+2SXUmxtcyRn6SOdYMRyAbxOVblDDKJZfhuk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BSfKI3ipMdkFD4rYZrdaySQegpDAWsCAylzId9ynBGOuOqecfeWt14fH5AoEc7BHS
         V8gAZ8FUYAWZ7+5K/4PIDrD6pGIIdrV0O2Jn6D6ulUbwttrVFEhG/G9b0Md4pdqADY
         53Xfp2wtiTvaziCmhPIFbYVTjPjsMkMemaBd4jPHGp7NQtU+tEhOGlW+KsaU0+Uy//
         GqydFI+z4tPURPZqkSW3aoa95B2I32CoYGYQEgbbShn5S4SKud+VDFCFP1PSKk/hrU
         wBLkQLJ+Vw6ANisqhMcgiJZpjptSCT72a9hpW4OU0IhEEp1d+2ZA0FAxOElhbv5Pqe
         BtFm85iRWxmGA==
Date:   Mon, 16 May 2022 12:06:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     kernel test robot <lkp@intel.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-sh@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-mm@kvack.org,
        linux-mips@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-hwmon@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kunit-dev@googlegroups.com, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, bpf@vger.kernel.org,
        amd-gfx@lists.freedesktop.org
Subject: Re: [linux-next:master] BUILD REGRESSION
 1e1b28b936aed946122b4e0991e7144fdbbfd77e
Message-ID: <20220516120605.7a6bb562@kernel.org>
In-Reply-To: <6280f965.kTCPpIEVY9TwoNre%lkp@intel.com>
References: <6280f965.kTCPpIEVY9TwoNre%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 15 May 2022 21:00:21 +0800 kernel test robot wrote:
> tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> branch HEAD: 1e1b28b936aed946122b4e0991e7144fdbbfd77e  Add linux-next specific files for 20220513
> 
> Error/Warning reports:
> 
> https://lore.kernel.org/linux-mm/202204181931.klAC6fWo-lkp@intel.com
> https://lore.kernel.org/linux-mm/202204291924.vTGZmerI-lkp@intel.com
> https://lore.kernel.org/linux-mm/202205031017.4TwMan3l-lkp@intel.com
> https://lore.kernel.org/linux-mm/202205041248.WgCwPcEV-lkp@intel.com
> https://lore.kernel.org/linux-mm/202205122113.uLKzd3SZ-lkp@intel.com
> https://lore.kernel.org/linux-mm/202205150051.3RzuooAG-lkp@intel.com
> https://lore.kernel.org/linux-mm/202205150117.sd6HzBVm-lkp@intel.com
> https://lore.kernel.org/lkml/202205100617.5UUm3Uet-lkp@intel.com
> https://lore.kernel.org/llvm/202204210555.DNvfHvIb-lkp@intel.com
> https://lore.kernel.org/llvm/202205060132.uhqyUx1l-lkp@intel.com
> https://lore.kernel.org/llvm/202205120010.zWBednzM-lkp@intel.com
> https://lore.kernel.org/llvm/202205141122.qihFGUem-lkp@intel.com
> 
> Error/Warning: (recently discovered and may have been fixed)
> 
> <command-line>: fatal error: ./include/generated/utsrelease.h: No such file or directory
> arch/arm/mach-versatile/versatile.c:56:14: warning: no previous prototype for function 'mmc_status' [-Wmissing-prototypes]
> arch/x86/kvm/pmu.h:20:32: warning: 'vmx_icl_pebs_cpu' defined but not used [-Wunused-const-variable=]
> drivers/gpu/drm/amd/amdgpu/../display/dc/core/dc_link_dp.c:5102:7: warning: variable 'allow_lttpr_non_transparent_mode' set but not used [-Wunused-but-set-variable]
> drivers/gpu/drm/amd/amdgpu/../display/dc/core/dc_link_dp.c:5147:6: warning: no previous prototype for function 'dp_parse_lttpr_mode' [-Wmissing-prototypes]
> drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c:1364:5: warning: no previous prototype for 'amdgpu_discovery_get_mall_info' [-Wmissing-prototypes]
> drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c:1983:6: warning: no previous prototype for function 'gfx_v11_0_rlc_stop' [-Wmissing-prototypes]
> drivers/gpu/drm/amd/amdgpu/soc21.c:171:6: warning: no previous prototype for 'soc21_grbm_select' [-Wmissing-prototypes]
> drivers/gpu/drm/solomon/ssd130x-spi.c:154:35: warning: 'ssd130x_spi_table' defined but not used [-Wunused-const-variable=]
> drivers/hwmon/nct6775-platform.c:199:9: sparse:    unsigned char
> drivers/hwmon/nct6775-platform.c:199:9: sparse:    void
> drivers/video/fbdev/omap/hwa742.c:492:5: warning: no previous prototype for 'hwa742_update_window_async' [-Wmissing-prototypes]
> fs/buffer.c:2254:5: warning: stack frame size (2144) exceeds limit (1024) in 'block_read_full_folio' [-Wframe-larger-than]
> fs/ntfs/aops.c:378:12: warning: stack frame size (2224) exceeds limit (1024) in 'ntfs_read_folio' [-Wframe-larger-than]
> kernel/trace/fgraph.c:37:12: warning: no previous prototype for 'ftrace_enable_ftrace_graph_caller' [-Wmissing-prototypes]
> kernel/trace/fgraph.c:46:12: warning: no previous prototype for 'ftrace_disable_ftrace_graph_caller' [-Wmissing-prototypes]

Is this report CCed everywhere or there's a reason why netdev@ is CCed?
I'm trying to figure out we need to care and it's not obvious..
