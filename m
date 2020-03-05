Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB1217A947
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 16:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbgCEPxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 10:53:34 -0500
Received: from mga05.intel.com ([192.55.52.43]:11793 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725977AbgCEPxe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 10:53:34 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Mar 2020 07:53:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,518,1574150400"; 
   d="scan'208";a="234452025"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga008.jf.intel.com with ESMTP; 05 Mar 2020 07:53:27 -0800
Received: from andy by smile with local (Exim 4.93)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1j9soS-00792v-DX; Thu, 05 Mar 2020 17:53:28 +0200
Date:   Thu, 5 Mar 2020 17:53:28 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>,
        Luke Nelson <lukenels@cs.washington.edu>,
        bpf <bpf@vger.kernel.org>, Luke Nelson <luke.r.nels@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Xi Wang <xi.wang@gmail.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, linux-riscv@lists.infradead.org
Subject: Re: [PATCH bpf-next v5 0/4] eBPF JIT for RV32G
Message-ID: <20200305155328.GO1224808@smile.fi.intel.com>
References: <20200305050207.4159-1-luke.r.nels@gmail.com>
 <CAJ+HfNjrUxVqpBgC-WLHbZX7_7Gd-Lk7ghrmASTmaNySuXVUfg@mail.gmail.com>
 <4633123d-dc61-ab79-d2ee-e0cef66e4cea@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4633123d-dc61-ab79-d2ee-e0cef66e4cea@iogearbox.net>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 05, 2020 at 04:19:27PM +0100, Daniel Borkmann wrote:
> On 3/5/20 6:40 AM, Björn Töpel wrote:
> > On Thu, 5 Mar 2020 at 06:02, Luke Nelson <lukenels@cs.washington.edu> wrote:
> > > 
> > > This series adds an eBPF JIT for 32-bit RISC-V (RV32G) to the kernel,
> > > adapted from the RV64 JIT and the 32-bit ARM JIT.
> > > 
> > 
> > Nice work! Thanks for hanging in there!
> > 
> > For the series,
> > Acked-by: Björn Töpel <bjorn.topel@gmail.com>
> > Reviewed-by: Björn Töpel <bjorn.topel@gmail.com>
> 
> Applied, thanks everyone!

> P.s.: I fixed the MAINTAINERS entry in the last one to have both netdev and bpf
> to be consistent with all the other JIT entries there.

Does parse-maintainer.pl happy about your changes?

-- 
With Best Regards,
Andy Shevchenko


