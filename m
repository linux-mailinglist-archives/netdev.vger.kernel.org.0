Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E71E56BC23
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 17:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238767AbiGHOtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 10:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238766AbiGHOt3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 10:49:29 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D14421276E;
        Fri,  8 Jul 2022 07:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657291738; x=1688827738;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=A2lLFi5u8UsxZhn0WXa3lBiGFwloEe9xAauBS7sD2kM=;
  b=EXwCZvvlIFiuVi6tYqmwv511lrd2lmdXnjfim1z22W+bpmpoRgegAJkj
   9v7OQOHoqxIiU4Hny6tZXaoYl0ppIy6P0V/cE7bdIPxxmKagnFxmR+7s5
   FvvXxTT26kPcSvElzWGTnIOGfoAynz5PzqlBY0WrafKb4OGjzU7kJFmk1
   ORjm8dbZQHo/eFhXenJAfcbn8QYmaJtcOiLIuENldiGHUbCykCJss+2Ma
   3WRoUXY6Nj7APLxvfPagj6SOnjIQJH39DLdjGQvdYfkte2Rs4QoIxPNFw
   /KENn+gmgij7sEJaS9eJkrP8eZZxuvm14N+nw8Z2H6tmm9CMBBA8w2PAt
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10401"; a="370608681"
X-IronPort-AV: E=Sophos;i="5.92,255,1650956400"; 
   d="scan'208";a="370608681"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2022 07:48:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,255,1650956400"; 
   d="scan'208";a="683680886"
Received: from lkp-server01.sh.intel.com (HELO 68b931ab7ac1) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 08 Jul 2022 07:48:54 -0700
Received: from kbuild by 68b931ab7ac1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o9pHq-000Nbs-4I;
        Fri, 08 Jul 2022 14:48:54 +0000
Date:   Fri, 8 Jul 2022 22:48:29 +0800
From:   kernel test robot <lkp@intel.com>
To:     Vikas Gupta <vikas.gupta@broadcom.com>, jiri@nvidia.com,
        kuba@kernel.org
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        dsahern@kernel.org, stephen@networkplumber.org,
        edumazet@google.com, pabeni@redhat.com, ast@kernel.org,
        leon@kernel.org, linux-doc@vger.kernel.org, corbet@lwn.net,
        michael.chan@broadcom.com, andrew.gospodarek@broadcom.com,
        Vikas Gupta <vikas.gupta@broadcom.com>
Subject: Re: [PATCH net-next v2 1/3] devlink: introduce framework for
 selftests
Message-ID: <202207082224.8QYTEsje-lkp@intel.com>
References: <20220707182950.29348-2-vikas.gupta@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220707182950.29348-2-vikas.gupta@broadcom.com>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vikas,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Vikas-Gupta/devlink-introduce-framework-for-selftests/20220708-033020
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git cf21b355ccb39b0de0b6a7362532bb5584c84a80
reproduce: make htmldocs

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> Documentation/networking/devlink/devlink-selftests.rst: WARNING: document isn't included in any toctree

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
