Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7A8224D62
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 19:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728031AbgGRRpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 13:45:43 -0400
Received: from mga18.intel.com ([134.134.136.126]:29858 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726155AbgGRRpm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Jul 2020 13:45:42 -0400
IronPort-SDR: EvCxX/2f0JobXzYd/ymQOQyUxuizWD350jlcZP2CPNB0cTLd4JSuwvi008iPpSf72cjYBt/KKq
 B8O6C+TLcnPA==
X-IronPort-AV: E=McAfee;i="6000,8403,9686"; a="137231597"
X-IronPort-AV: E=Sophos;i="5.75,367,1589266800"; 
   d="scan'208";a="137231597"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2020 10:45:41 -0700
IronPort-SDR: QsdMbicwCHfFRCkrUt4f9DS83ayU3f3t25gmia3Jofp2x8bHZCElI/qPTHC0xWLGNbccpT68u3
 M6/56Uz1WAgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,367,1589266800"; 
   d="scan'208";a="269775731"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga007.fm.intel.com with ESMTP; 18 Jul 2020 10:45:37 -0700
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1jwqu1-002ZJm-LY; Sat, 18 Jul 2020 20:45:37 +0300
Date:   Sat, 18 Jul 2020 20:45:37 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     "Daniel W. S. Almeida" <dwlsalmeida@gmail.com>
Cc:     corbet@lwn.net, pmladek@suse.com, rostedt@goodmis.org,
        sergey.senozhatsky@gmail.com, linux@rasmusvillemoes.dk,
        ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] docs: core-api/printk-formats.rst: use literal block
 syntax
Message-ID: <20200718174537.GI3703480@smile.fi.intel.com>
References: <20200718165107.625847-1-dwlsalmeida@gmail.com>
 <20200718165107.625847-8-dwlsalmeida@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200718165107.625847-8-dwlsalmeida@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 18, 2020 at 01:51:02PM -0300, Daniel W. S. Almeida wrote:
> From: Daniel W. S. Almeida <dwlsalmeida@gmail.com>
> 
> Fix the following warning:
> 
> WARNING: Definition list ends without a blank line;
> unexpected unindent.
> 
> By switching to the literal block syntax.

Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

> 
> Signed-off-by: Daniel W. S. Almeida <dwlsalmeida@gmail.com>
> ---
>  Documentation/core-api/printk-formats.rst | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/core-api/printk-formats.rst b/Documentation/core-api/printk-formats.rst
> index 1beac4719e437..6d26c5c6ac485 100644
> --- a/Documentation/core-api/printk-formats.rst
> +++ b/Documentation/core-api/printk-formats.rst
> @@ -494,9 +494,11 @@ Time and date
>  	%pt[RT]t		HH:MM:SS
>  	%pt[RT][dt][r]
>  
> -For printing date and time as represented by
> +For printing date and time as represented by::
> +
>  	R  struct rtc_time structure
>  	T  time64_t type
> +
>  in human readable format.
>  
>  By default year will be incremented by 1900 and month by 1.
> -- 
> 2.27.0
> 

-- 
With Best Regards,
Andy Shevchenko


