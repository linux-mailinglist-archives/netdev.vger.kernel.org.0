Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4C772C8DFD
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 20:23:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388316AbgK3TW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 14:22:27 -0500
Received: from mga12.intel.com ([192.55.52.136]:16174 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388274AbgK3TWV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 14:22:21 -0500
IronPort-SDR: N/Fam/x5S2WvYVb9pEAko1Vl8kvywxNSh5/GEMcqFcooHV6gZTy7+N30hW0jx7QMxHoq5BHy/m
 0ebj7Ki4AaRQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9821"; a="151951395"
X-IronPort-AV: E=Sophos;i="5.78,382,1599548400"; 
   d="scan'208";a="151951395"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2020 11:21:23 -0800
IronPort-SDR: 4wd7e6qmkf/ueH0GkZlQ8xIUfXFMKGCy3G0uZodVvF0KrURl8FkefSTmU4qyuIdClrBNGiX5BO
 K8ScJtJqbF9Q==
X-IronPort-AV: E=Sophos;i="5.78,382,1599548400"; 
   d="scan'208";a="549230575"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.209.29.232]) ([10.209.29.232])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2020 11:21:22 -0800
Subject: Re: [PATCH 0/5] Fix compiler warnings from GCC-10
To:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
References: <20201130002135.6537-1-stephen@networkplumber.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <737cca50-762d-8e90-9f4c-abecca597af6@intel.com>
Date:   Mon, 30 Nov 2020 11:21:20 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201130002135.6537-1-stephen@networkplumber.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/29/2020 4:21 PM, Stephen Hemminger wrote:
> Update to GCC-10 and it starts warning about some new things.
> 
> Stephen Hemminger (5):
>   devlink: fix uninitialized warning
>   bridge: fix string length warning
>   tc: fix compiler warnings in ip6 pedit
>   misc: fix compiler warning in ifstat and nstat
>   f_u32: fix compiler gcc-10 compiler warning
> 
>  devlink/devlink.c  | 2 +-
>  ip/iplink_bridge.c | 2 +-
>  misc/ifstat.c      | 2 +-
>  misc/nstat.c       | 3 +--
>  tc/f_u32.c         | 2 +-
>  tc/p_ip6.c         | 2 +-
>  6 files changed, 6 insertions(+), 7 deletions(-)
> 

Nice to see these cleanups. I noticed a few of these recently while
working on devlink.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
