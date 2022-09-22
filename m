Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 308C25E5F93
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 12:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbiIVKOx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 06:14:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiIVKOt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 06:14:49 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 777521E71D;
        Thu, 22 Sep 2022 03:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663841686; x=1695377686;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=x32tm762eYRcO0hneA/oJ5/kFu+e00pw3Fm2BAzUBI0=;
  b=g2dnpIAQZdYov0kK0IvE8CSMolkc+0TzWSDzom++nmu2EyS9srnxPpQC
   2GCCOIwqiicY7dzqf82fLxafPHxfbw9n0Pp4arWK2AxC0FBxtHuCCHyMR
   W1j6fRp3UnxSeHbe0fJmsPB3bSbOOnOFsWzqBkQzlGtKME8YDqndBxxfB
   8Zx1vu5D4XpKy/uayiMjuGp/c4KaCnME289vip+7IcXWZbmV9zClsgkc0
   YQhhQkYEfIJrTxb5PKsN3CyC5/nVQd+GTcG3oKyDBTNmpD6IH1ymK4Or6
   UYX/mcZjLtQXd7x/AILJWmoktq/OXq53OBwYgAGAhBRcyLK3cqgLjGG4b
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10477"; a="300243189"
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="300243189"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 03:14:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="597375856"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga006.jf.intel.com with ESMTP; 22 Sep 2022 03:14:41 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1obJE7-005xPE-1j;
        Thu, 22 Sep 2022 13:14:39 +0300
Date:   Thu, 22 Sep 2022 13:14:39 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vadim Fedorenko <vadfed@fb.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH v1 1/1] ptp_ocp: use device_find_any_child() instead of
 custom approach
Message-ID: <Yyw1j7f7p8PIdVq1@smile.fi.intel.com>
References: <20220921141005.2443-1-andriy.shevchenko@linux.intel.com>
 <b7536b94-b37c-9e8a-363f-cbca652f1cbd@novek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b7536b94-b37c-9e8a-363f-cbca652f1cbd@novek.ru>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 21, 2022 at 09:52:15PM +0100, Vadim Fedorenko wrote:
> On 21.09.2022 15:10, Andy Shevchenko wrote:
> > We have already a helper to get the first child device, use it and
> > drop custom approach.
> 
> LGTM. This patch should go to net-next, I believe.

Yes, I forgot to add the 'net-next' to the Subject line.

> Acked-by: Vadim Fedorenko <vadfed@fb.com>

Thanks!

-- 
With Best Regards,
Andy Shevchenko


