Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 276162FDA69
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 21:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389966AbhATOGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 09:06:24 -0500
Received: from mga17.intel.com ([192.55.52.151]:24322 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389668AbhATN0H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 08:26:07 -0500
IronPort-SDR: WimJPuLfOA9A9wPfQSoQxwiRlxK/ww+tZ2kvu7kgNSnBHuqXWby1XYeZ69QCGzkSFYRtFea0R9
 pVzMzSA7VJOA==
X-IronPort-AV: E=McAfee;i="6000,8403,9869"; a="158877893"
X-IronPort-AV: E=Sophos;i="5.79,361,1602572400"; 
   d="scan'208";a="158877893"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 05:25:25 -0800
IronPort-SDR: HPzL6eB+vkLX+mVGosC2OWzaKNhF1iuzyuiiihb3ormJH/Vllh/ZMj3dTLlJL6EDFpkpmea90P
 0Qtvn6ayMFMg==
X-IronPort-AV: E=Sophos;i="5.79,361,1602572400"; 
   d="scan'208";a="384834261"
Received: from myegin-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.249.42.133])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 05:25:19 -0800
Subject: Re: [PATCH bpf-next v2 5/8] libbpf, xsk: select AF_XDP BPF program
 based on kernel version
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org, jonathan.lemon@gmail.com, maximmi@nvidia.com,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        ciara.loftus@intel.com, weqaar.a.janjua@intel.com,
        Marek Majtyka <alardam@gmail.com>
References: <20210119155013.154808-1-bjorn.topel@gmail.com>
 <20210119155013.154808-6-bjorn.topel@gmail.com> <875z3repng.fsf@toke.dk>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <6c7da700-700d-c7f6-fe0a-c42e55e81c8a@intel.com>
Date:   Wed, 20 Jan 2021 14:25:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <875z3repng.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-01-20 13:52, Toke Høiland-Jørgensen wrote:
> Björn Töpel <bjorn.topel@gmail.com> writes:
> 
>> From: Björn Töpel <bjorn.topel@intel.com>
>>
>> Add detection for kernel version, and adapt the BPF program based on
>> kernel support. This way, users will get the best possible performance
>> from the BPF program.
> 
> Please do explicit feature detection instead of relying on the kernel
> version number; some distro kernels are known to have a creative notion
> of their own version, which is not really related to the features they
> actually support (I'm sure you know which one I'm referring to ;)).
>

Right. For a *new* helper, like bpf_redirect_xsk, we rely on rejection
from the verifier to detect support. What about "bpf_redirect_map() now
supports passing return value as flags"? Any ideas how to do that in a
robust, non-version number-based scheme?


Thanks,
Björn
