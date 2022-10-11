Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF2DD5FB404
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 16:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbiJKOAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 10:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiJKOAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 10:00:33 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A57213CDE
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 07:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665496831; x=1697032831;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KxoF4d8lwg/MhTgck2/YV7EBllbmaXYF66xRc2oIOnE=;
  b=nRsORKDOHLReYgpwe/L1DfWDJpDnankM2OObZCwGA5kXHeefp8v9eOf2
   a2bIDl4ZaIE71xpAIlzd4QBvvdgpNwL0igajILrnAtyT5svuDoe320RTY
   SqX9S+VO/Ov12nBTso0dpjS0JvAkPWwigecNCa4sUF3nJsRvg5VxSaCwR
   T5fpCF58B+/WGtoyuS/p53S6+O3qImmPBmYOgL3XOCLmBHwoFLkWNnlCr
   b1ibymXSlpW0SDHg1+Dx01UUT2H6EzwPsZJzeXQu6MZ86zuP9J6+Pba7m
   x/lyFXwd77kvHohtsm5UnCjsElNniqZw3EbU5lAnyyCZOki/0jhzyXMj+
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10497"; a="330990332"
X-IronPort-AV: E=Sophos;i="5.95,176,1661842800"; 
   d="scan'208";a="330990332"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2022 07:00:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10497"; a="577444122"
X-IronPort-AV: E=Sophos;i="5.95,176,1661842800"; 
   d="scan'208";a="577444122"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga003.jf.intel.com with ESMTP; 11 Oct 2022 07:00:28 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 29BE0QUw015038;
        Tue, 11 Oct 2022 15:00:27 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Michal Wilczynski <michal.wilczynski@intel.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        kernel test robot <lkp@intel.com>, netdev@vger.kernel.org,
        kbuild-all@lists.01.org, jacob.e.keller@intel.com,
        jesse.brandeburg@intel.com, przemyslaw.kitszel@intel.com,
        anthony.l.nguyen@intel.com, kuba@kernel.org,
        ecree.xilinx@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net-next v5 1/4] devlink: Extend devlink-rate api with export functions and new params
Date:   Tue, 11 Oct 2022 15:56:51 +0200
Message-Id: <20221011135650.364856-1-olek@zu.ehren.unserer.toten>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <202210111928.lU75pRc2-lkp@intel.com>
References: <20221011090113.445485-2-michal.wilczynski@intel.com> <202210111928.lU75pRc2-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: kernel test robot <lkp@intel.com>
Date: Tue, 11 Oct 2022 19:32:48 +0800

> Hi Michal,
> 
> Thank you for the patch! Perhaps something to improve:
> 
> [auto build test WARNING on net-next/master]

[...]

> All warnings (new ones prefixed by >>):
> 
>    net/core/devlink.c: In function 'devl_rate_node_create':
> >> net/core/devlink.c:10314:9: warning: 'strncpy' specified bound 30 equals destination size [-Wstringop-truncation]
>    10314 |         strncpy(rate_node->name, node_name, DEVLINK_RATE_NAME_MAX_LEN);
>          |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

BTW, it's highly recommended to use strscpy().

> 
> 
> vim +/strncpy +10314 net/core/devlink.c

[...]

> -- 
> 0-DAY CI Kernel Test Service
> https://01.org/lkp

Thanks,
Olek
