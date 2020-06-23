Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D43DA205307
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 15:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732669AbgFWNEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 09:04:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:33061 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732542AbgFWNEi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 09:04:38 -0400
IronPort-SDR: MDRAvRWKMS6vlwDSiKdvSf0lpQak9+nm3VCj7hoUIbpy4Oy4JUfIzTf0O2NDzvjOx40O+7oN4k
 aE+7DLLXSlOQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="142306005"
X-IronPort-AV: E=Sophos;i="5.75,271,1589266800"; 
   d="scan'208";a="142306005"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2020 06:04:38 -0700
IronPort-SDR: V0+2YvvU3iYnI514XKlaIFVV/LmrfUZnepH7R6bSkbVPoKGzVI8dG50ZlULGG9WWtN7zqcvaH4
 JBCyQwuzuDCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,271,1589266800"; 
   d="scan'208";a="264783873"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga008.fm.intel.com with ESMTP; 23 Jun 2020 06:04:33 -0700
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1jnibK-00FMnm-Sx; Tue, 23 Jun 2020 16:04:34 +0300
Date:   Tue, 23 Jun 2020 16:04:34 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com, andriin@fb.com,
        arnaldo.melo@gmail.com, kafai@fb.com, songliubraving@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        linux@rasmusvillemoes.dk, joe@perches.com, pmladek@suse.com,
        rostedt@goodmis.org, sergey.senozhatsky@gmail.com, corbet@lwn.net,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 bpf-next 7/8] bpf: add support for %pT format
 specifier for bpf_trace_printk() helper
Message-ID: <20200623130434.GX2428291@smile.fi.intel.com>
References: <1592914031-31049-1-git-send-email-alan.maguire@oracle.com>
 <1592914031-31049-8-git-send-email-alan.maguire@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1592914031-31049-8-git-send-email-alan.maguire@oracle.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 01:07:10PM +0100, Alan Maguire wrote:
> Allow %pT[cNx0] format specifier for BTF-based display of data associated
> with pointer.  The unsafe data modifier 'u' - where the source data
> is traversed without copying it to a safe buffer via probe_kernel_read() -
> is not supported.

I think I already saw this data structure definition...

> +/*
> + * struct __btf_ptr is used for %pT (typed pointer) display; the
> + * additional type string/BTF id are used to render the pointer
> + * data as the appropriate type.
> + */
> +struct __btf_ptr {
> +	void *ptr;
> +	const char *type;
> +	__u32 id;
> +};

So, this is 2nd...


> +/*
> + * struct __btf_ptr is used for %pT (typed pointer) display; the
> + * additional type string/BTF id are used to render the pointer
> + * data as the appropriate type.
> + */
> +struct __btf_ptr {
> +	void *ptr;
> +	const char *type;
> +	__u32 id;
> +};

,..and this is 3rd copy. Why?

-- 
With Best Regards,
Andy Shevchenko


