Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5C9336C70
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 07:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231415AbhCKGrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 01:47:15 -0500
Received: from mga05.intel.com ([192.55.52.43]:26562 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231377AbhCKGrL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 01:47:11 -0500
IronPort-SDR: oy+Sk+h6RUJ/q8AxBzJhfbqf1jYmOeAKfIl2SWqgD0QU+0pJ7tU2DtWXo0Zbc6Phndws6cfO56
 Z6ldUv61XlXg==
X-IronPort-AV: E=McAfee;i="6000,8403,9919"; a="273661589"
X-IronPort-AV: E=Sophos;i="5.81,239,1610438400"; 
   d="scan'208";a="273661589"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2021 22:47:10 -0800
IronPort-SDR: Ew6b4c2T3wX0D8nspkr4pjPdHmqyGUChpLcfAGIsLF/xeWAVkRfzmcjlicGFhiVjXX39p2ZVw9
 4N2T/cmFYvgw==
X-IronPort-AV: E=Sophos;i="5.81,239,1610438400"; 
   d="scan'208";a="410503797"
Received: from eefimov-mobl.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.48.42])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2021 22:47:07 -0800
Subject: Re: linux-next: build failure after merge of the bpf-next tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
References: <20210311114723.352e12f8@canb.auug.org.au>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <bad04c3d-c80e-16c1-0f5a-4d4556555a81@intel.com>
Date:   Thu, 11 Mar 2021 07:47:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210311114723.352e12f8@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-03-11 01:47, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the bpf-next tree, today's linux-next build (perf) failed
> like this:
> 
> make[3]: *** No rule to make target 'libbpf_util.h', needed by '/home/sfr/next/perf/staticobjs/xsk.o'.  Stop.
>

Hi Stephen,

It's an incremental build issue, as pointed out here [1], that is
resolved by cleaning the build.


Cheers,
Björn

[1] 
https://lore.kernel.org/bpf/CAEf4BzYPDF87At4=_gsndxof84OiqyJxgAHL7_jvpuntovUQ8w@mail.gmail.com/


> Caused by commit
> 
>    7e8bbe24cb8b ("libbpf: xsk: Move barriers from libbpf_util.h to xsk.h")
> 
> I have used the bpf tree from next-20210310 for today.
> 
