Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7719952DE56
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 22:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244084AbiESUYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 16:24:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244682AbiESUYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 16:24:02 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6482EA2069
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 13:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652991841; x=1684527841;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=e+ozTb0qBYjNphx8gnpHDkAjiqUYMNDT+0wx+KIjHxc=;
  b=hsPZjaybvRrrnrdKnaXpnGA1HCqfHImrpYBhg9xHLSPxQhvktSofBeZj
   v8bYZUx7/DsTybDgz9PIj2HbSEKLfrUPQval7CuNciQ+AcN1/GJXXO3qg
   4af29btR7B9vRCrywUjkH0aEtjnS+UFHZe6tJWz0xTpZ2VNhpajcnOH2E
   DoD7M20Qv4jsjJhh2J0ObQZj+whHFCe7oYrDccjeVHBeMl+BKFzkd60f8
   XUyi3luqQQaDIZ4yIfOV8NUPOH9SlTiC/3H5X5Vlm0qQfhIX59lrgOdIk
   /jrpUkOIZ2jUAKEPnk931DIJ78Jrc5KnJfS1+lsAshbi9+r7Xk4Xl53p6
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10352"; a="297674028"
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="297674028"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 13:23:57 -0700
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="570408337"
Received: from camcconn-mobl1.amr.corp.intel.com ([10.255.229.130])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 13:23:56 -0700
Date:   Thu, 19 May 2022 13:23:56 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: net <> net-next conflicts
In-Reply-To: <20220519113122.6bb6809a@kernel.org>
Message-ID: <50a38140-f8dc-979a-99da-dc7b58c782ff@linux.intel.com>
References: <20220519113122.6bb6809a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 May 2022, Jakub Kicinski wrote:

> Hi!
>
> The conflicts in today's net -> net-next merge were pretty tedious.
>
> First off - please try to avoid creating them.
>
> If they are unavoidable - please include the expected resolution
> in the cover letter and mark the cover letter with [conflict]
> (i.e.  [PATCH tree 0/n][conflict]) so we can easily find them days
> later when doing the merge.
>

Sorry about the tedium - I will be sure to note and [tag] any unavoidable 
conflicts in future cover letters. Merge results look good, thank you.

--
Mat Martineau
Intel
