Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEF892C50DC
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 10:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389121AbgKZJBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 04:01:52 -0500
Received: from mga17.intel.com ([192.55.52.151]:54767 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389113AbgKZJBw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Nov 2020 04:01:52 -0500
IronPort-SDR: MKOQ9KHPtpkrGGxs00kL5YF6pwpdnLFjYNC70q58Mr+R4kvwjauEqoLO0mbbIOA5aJXetjFybZ
 CUBCVQeh0bCg==
X-IronPort-AV: E=McAfee;i="6000,8403,9816"; a="152092657"
X-IronPort-AV: E=Sophos;i="5.78,371,1599548400"; 
   d="scan'208";a="152092657"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2020 01:01:52 -0800
IronPort-SDR: nYkBRYDqIxwypCIERqVk4pm6PF1s7RxyyN2qOGILkoSIxeI4lMwp3BKxfWODlLGSo7isrPgz0S
 3zf3wbpbZfig==
X-IronPort-AV: E=Sophos;i="5.78,371,1599548400"; 
   d="scan'208";a="547641737"
Received: from vyevtyus-mobl1.ccr.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.249.42.21])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2020 01:01:34 -0800
Subject: Re: [PATCH bpf-next v3 1/5] selftests/bpf: xsk selftests framework
To:     Yonghong Song <yhs@fb.com>,
        Weqaar Janjua <weqaar.janjua@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org,
        magnus.karlsson@gmail.com
Cc:     Weqaar Janjua <weqaar.a.janjua@intel.com>, shuah@kernel.org,
        skhan@linuxfoundation.org, linux-kselftest@vger.kernel.org,
        anders.roxell@linaro.org, jonathan.lemon@gmail.com
References: <20201125183749.13797-1-weqaar.a.janjua@intel.com>
 <20201125183749.13797-2-weqaar.a.janjua@intel.com>
 <d8eedbad-7a8e-fd80-5fec-fc53b86e6038@fb.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <1bcfb208-dfbd-7b49-e505-8ec17697239d@intel.com>
Date:   Thu, 26 Nov 2020 10:01:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <d8eedbad-7a8e-fd80-5fec-fc53b86e6038@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-26 07:44, Yonghong Song wrote:
> 
[...]
> 
> What other configures I am missing?
> 
> BTW, I cherry-picked the following pick from bpf tree in this experiment.
>    commit e7f4a5919bf66e530e08ff352d9b78ed89574e6b (HEAD -> xsk)
>    Author: Björn Töpel <bjorn.topel@intel.com>
>    Date:   Mon Nov 23 18:56:00 2020 +0100
> 
>        net, xsk: Avoid taking multiple skbuff references
>

Hmm, I'm getting an oops, unless I cherry-pick:

36ccdf85829a ("net, xsk: Avoid taking multiple skbuff references")

*AND*

537cf4e3cc2f ("xsk: Fix umem cleanup bug at socket destruct")

from bpf/master.


Björn
