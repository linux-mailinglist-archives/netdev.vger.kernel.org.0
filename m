Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DCE430045F
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 14:41:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727486AbhAVNjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 08:39:19 -0500
Received: from mga14.intel.com ([192.55.52.115]:25569 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727988AbhAVNis (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 08:38:48 -0500
IronPort-SDR: u3p0pslQMFFE76dp+wXQxrKtb3F0Fsd+1+jiy8GGxf/aGyVTapCGCgEZEaDJjrzDsS+wXO5om+
 pebR7VzSQxyQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9871"; a="178667667"
X-IronPort-AV: E=Sophos;i="5.79,366,1602572400"; 
   d="scan'208";a="178667667"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 05:38:08 -0800
IronPort-SDR: jlFI4hq8v2VrZRdCUaZMMFL9j6hV9x+sWehbFcHgzCBSz7JZ4T8HQ8UhH0bjA0nKtKBfGAOAsj
 FnXVlHVSzBew==
X-IronPort-AV: E=Sophos;i="5.79,366,1602572400"; 
   d="scan'208";a="385758087"
Received: from mdoronin-mobl.ccr.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.44.52])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 05:38:02 -0800
Subject: Re: [PATCH bpf-next 0/3] AF_XDP clean up/perf improvements
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org, jonathan.lemon@gmail.com, maximmi@nvidia.com,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        ciara.loftus@intel.com, weqaar.a.janjua@intel.com,
        andrii@kernel.org
References: <20210122105351.11751-1-bjorn.topel@gmail.com>
 <877do56reh.fsf@toke.dk>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <82c445fd-5be8-c9e8-eda1-68ed6f355966@intel.com>
Date:   Fri, 22 Jan 2021 14:37:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <877do56reh.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-01-22 14:19, Toke Høiland-Jørgensen wrote:
> Björn Töpel <bjorn.topel@gmail.com> writes:
> 
>> This series has some clean up/performance improvements for XDP
>> sockets.
>>
>> The first two patches are cleanups for the AF_XDP core, and the
>> restructure actually give a little performance boost.
>>
>> The last patch adds support for selecting AF_XDP BPF program, based on
>> what the running kernel supports.
>>
>> The patches were earlier part of the bigger "bpf_redirect_xsk()"
>> series [1]. I pulled out the non-controversial parts into this series.
> 
> What about the first patch from that series, refactoring the existing
> bpf_redirect_map() handling? I think that would be eligible for sending
> on its own as well :)
>

Yeah, I'm planning on doing that, but I figured I'd wait for Hangbin's
work to go first.


Björn


> -Toke
> 
