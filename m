Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C723117735E
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 11:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727899AbgCCKCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 05:02:35 -0500
Received: from mga04.intel.com ([192.55.52.120]:53097 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726694AbgCCKCe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 05:02:34 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Mar 2020 02:02:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,510,1574150400"; 
   d="scan'208";a="412691972"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga005.jf.intel.com with ESMTP; 03 Mar 2020 02:02:27 -0800
Received: from andy by smile with local (Exim 4.93)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1j94Ng-006W6Q-A9; Tue, 03 Mar 2020 12:02:28 +0200
Date:   Tue, 3 Mar 2020 12:02:28 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Luke Nelson <lukenels@cs.washington.edu>
Cc:     bpf@vger.kernel.org, Luke Nelson <luke.r.nels@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>,
        Xi Wang <xi.wang@gmail.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: Re: [PATCH bpf-next v4 4/4] MAINTAINERS: Add entry for RV32G BPF JIT
Message-ID: <20200303100228.GJ1224808@smile.fi.intel.com>
References: <20200303005035.13814-1-luke.r.nels@gmail.com>
 <20200303005035.13814-5-luke.r.nels@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200303005035.13814-5-luke.r.nels@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 02, 2020 at 04:50:35PM -0800, Luke Nelson wrote:

Commit message?

> Cc: Björn Töpel <bjorn.topel@gmail.com>
> Signed-off-by: Xi Wang <xi.wang@gmail.com>
> Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>

> @@ -3213,11 +3213,20 @@ L:	bpf@vger.kernel.org
>  S:	Maintained
>  F:	arch/powerpc/net/
>  
> -BPF JIT for RISC-V (RV64G)
> +BPF JIT for 32-bit RISC-V (RV32G)
> +M:	Luke Nelson <luke.r.nels@gmail.com>
> +M:	Xi Wang <xi.wang@gmail.com>
> +L:	bpf@vger.kernel.org
> +S:	Maintained
> +F:	arch/riscv/net/
> +X:	arch/riscv/net/bpf_jit_comp.c
> +
> +BPF JIT for 64-bit RISC-V (RV64G)
>  M:	Björn Töpel <bjorn.topel@gmail.com>
> -L:	netdev@vger.kernel.org
> +L:	bpf@vger.kernel.org
>  S:	Maintained
>  F:	arch/riscv/net/
> +X:	arch/riscv/net/bpf_jit_comp32.c

Obviously this breaks an order. Please, fix.
Hint: run parse-maintainers.pl after the change.

>  BPF JIT for S390
>  M:	Ilya Leoshkevich <iii@linux.ibm.com>

-- 
With Best Regards,
Andy Shevchenko


