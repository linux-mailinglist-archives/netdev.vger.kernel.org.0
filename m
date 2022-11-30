Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57BA763D5AA
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 13:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234619AbiK3Mel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 07:34:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbiK3Mek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 07:34:40 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8B137722A;
        Wed, 30 Nov 2022 04:34:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669811679; x=1701347679;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zxraUxBzA273AD95EACiGPBErHdD8ubf2JuNnbpgFp0=;
  b=QRKNMmACIMdSkNg7oZ5ReSSYFNCoBLwVdCQj5djzUklO5iNQmB38aIK8
   JGf9T4kBqlhmtqmp6YgusBxfNLNpXfo9/abiwT2WMj1u6N8VuGh4tMRmi
   tlOnJt1AX9G84J4jRgZpa9DHi3KVQQFW8avnFkAHklA6kmE0bmyPMYEu0
   N0pYJKrOAOoRE6uHF5fICVnhpggSzGGDLZTObfECkV81VChhVfvXbHgvJ
   hFZUX7n5beX+ZjMLBeoYlJwJcSVw3ewN1pv+81TnsPDw1J9GWtgFJNaGI
   cqyhH2k5liyXjH+iMMmhAE4AvGSyBSg74j8UhAMNV5WpocjM7YThqKc/i
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="342306078"
X-IronPort-AV: E=Sophos;i="5.96,206,1665471600"; 
   d="scan'208";a="342306078"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 04:34:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="818614671"
X-IronPort-AV: E=Sophos;i="5.96,206,1665471600"; 
   d="scan'208";a="818614671"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga005.jf.intel.com with ESMTP; 30 Nov 2022 04:34:36 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1p0MIM-002G8s-1R;
        Wed, 30 Nov 2022 14:34:34 +0200
Date:   Wed, 30 Nov 2022 14:34:34 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v2 1/2] Revert "net: thunderbolt: Use separate
 header data type for the Rx"
Message-ID: <Y4dN2moWIfJWWWkQ@smile.fi.intel.com>
References: <20221130122439.10822-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221130122439.10822-1-andriy.shevchenko@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 30, 2022 at 02:24:38PM +0200, Andy Shevchenko wrote:
> This reverts commit 9ad63a3dad65b984ba16f5841163457dec266be4.

Ah wrong SHA was taken, sorry for the noise.
v3 will be sent soon.

-- 
With Best Regards,
Andy Shevchenko


