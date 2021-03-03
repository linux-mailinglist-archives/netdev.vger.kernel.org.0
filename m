Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E82A832C483
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:54:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392480AbhCDAOt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:14:49 -0500
Received: from mga07.intel.com ([134.134.136.100]:49518 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242236AbhCCQh4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 11:37:56 -0500
IronPort-SDR: J8FgcHyvjvtxPww5pF9q7gxoqOCeQfck1jZzMAM+tkyCjgMqtCesItnJSophdahD12CTPsLxp4
 D/oS4UUJ8nwQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9912"; a="251280352"
X-IronPort-AV: E=Sophos;i="5.81,220,1610438400"; 
   d="scan'208";a="251280352"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2021 08:34:56 -0800
IronPort-SDR: uNvKzQnepISAasxm7yd0UXWSdvQO8RluwH7gOw+wuDjl8SC7Mv4N+elhtAlp4OiW1CqPl/Ui/h
 3WXSxDWi7ahg==
X-IronPort-AV: E=Sophos;i="5.81,220,1610438400"; 
   d="scan'208";a="407308833"
Received: from jdibley-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.61.121])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2021 08:34:52 -0800
Subject: Re: [PATCH bpf-next 2/2] libbpf, xsk: add libbpf_smp_store_release
 libbpf_smp_load_acquire
To:     Will Deacon <will@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        maximmi@nvidia.com, andrii@kernel.org
References: <20210301104318.263262-1-bjorn.topel@gmail.com>
 <20210301104318.263262-3-bjorn.topel@gmail.com> <87k0qqx3be.fsf@toke.dk>
 <e052a22a-4b7b-fe38-06ad-2ad04c83dda7@intel.com>
 <12f8969b-6780-f35f-62cd-ed67b1d8181a@iogearbox.net>
 <20210303153932.GB19247@willie-the-truck>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <95d0038f-13a7-1b4f-5aa8-7d6b8a8504db@intel.com>
Date:   Wed, 3 Mar 2021 17:34:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210303153932.GB19247@willie-the-truck>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-03-03 16:39, Will Deacon wrote:
> On Tue, Mar 02, 2021 at 10:13:21AM +0100, Daniel Borkmann wrote:

[...]

>>
>> Would also be great to get Will's ACK on that when you have a v2. :)
> 
> Please stick me on CC for that and I'll take a look as I've forgotten pretty
> much everything about this since last time :)
>

:-) I'll do that!

Thanks!


> Will
> 
