Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F09E4D2E0D
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 12:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231555AbiCILdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 06:33:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbiCILdY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 06:33:24 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66DBE527D7
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 03:32:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646825545; x=1678361545;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pZh6tggFD0k+hx+94LfOfVeWHwnnjq6x1VyVrjGwjL4=;
  b=d3JnTHlWtLCh92uUC3AfXYoC5dlm6H4UjhkaFKfkg+OmF0rN9NKDAYNz
   v5bWREFbM8jDM8j35e0DbUwsEHI5pozdQa910xI4AfQfomSUrEJykP/N5
   n0DOr4RtyJbReqJEI439DhZLR8y62O87T7ZGrjuBFPf4ZrZGknq+lGElq
   U1LVeVcfeMSYObRqLWXmPzu+wfAi+J45AA3CbpTH6edAhTGllzeD8RA04
   I57l9CgV7JFAcH80O3pmmPaJqcZon5xWznCFyq1Tr0xoIPOd1TyFWyW6/
   v93sWymo62RQnGpw1tW/ivoaKdpmhjioWf36QhcbgGTak+wjj5M0LrFZb
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10280"; a="318180824"
X-IronPort-AV: E=Sophos;i="5.90,167,1643702400"; 
   d="scan'208";a="318180824"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 03:32:25 -0800
X-IronPort-AV: E=Sophos;i="5.90,167,1643702400"; 
   d="scan'208";a="554082214"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 03:32:21 -0800
Date:   Wed, 9 Mar 2022 03:33:44 -0500
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     Marcin Szycik <marcin.szycik@linux.intel.com>
Cc:     netdev@vger.kernel.org, wojciech.drewek@intel.com,
        davem@davemloft.net, kuba@kernel.org, pablo@netfilter.org,
        laforge@gnumonks.org, jiri@resnulli.us,
        osmocom-net-gprs@lists.osmocom.org,
        intel-wired-lan@lists.osuosl.org, xiyou.wangcong@gmail.com,
        jhs@mojatatu.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com
Subject: Re: [PATCH net-next v10 7/7] ice: Support GTP-U and GTP-C offload in
 switchdev
Message-ID: <YihmaGhvS0PlndgM@localhost.localdomain>
References: <20220304164048.476900-1-marcin.szycik@linux.intel.com>
 <20220304164048.476900-8-marcin.szycik@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220304164048.476900-8-marcin.szycik@linux.intel.com>
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

ice part looks fine, thanks!

Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

Regards, Michal
