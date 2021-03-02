Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14C4E32A36E
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446356AbhCBI5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:57:02 -0500
Received: from mga03.intel.com ([134.134.136.65]:14921 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1381609AbhCBIGO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Mar 2021 03:06:14 -0500
IronPort-SDR: DKLZvsxwWIiBb/kHAMe1JaB0tFh7jv4UTzxqepl1R6dBlimw5kVXTht3Gk6fq0T2zyHstM7LMZ
 cuLDvrcwbLeA==
X-IronPort-AV: E=McAfee;i="6000,8403,9910"; a="186785815"
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="186785815"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 00:05:20 -0800
IronPort-SDR: sw2rsKQqdZjtGURCfIUjJ+SdN7iPxlLGUoaT0a/bgRr/3agl4H7BR1FC+Zn1s2SW81VeV1Jqe/
 sZiWgvwKQgfQ==
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="398278563"
Received: from ilick-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.249.41.237])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 00:05:17 -0800
Subject: Re: [PATCH bpf-next 2/2] libbpf, xsk: add libbpf_smp_store_release
 libbpf_smp_load_acquire
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        maximmi@nvidia.com, andrii@kernel.org, will@kernel.org
References: <20210301104318.263262-1-bjorn.topel@gmail.com>
 <20210301104318.263262-3-bjorn.topel@gmail.com> <87k0qqx3be.fsf@toke.dk>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <e052a22a-4b7b-fe38-06ad-2ad04c83dda7@intel.com>
Date:   Tue, 2 Mar 2021 09:05:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <87k0qqx3be.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-03-01 17:10, Toke Høiland-Jørgensen wrote:
> Björn Töpel <bjorn.topel@gmail.com> writes:
> 
>> From: Björn Töpel <bjorn.topel@intel.com>
>>
>> Now that the AF_XDP rings have load-acquire/store-release semantics,
>> move libbpf to that as well.
>>
>> The library-internal libbpf_smp_{load_acquire,store_release} are only
>> valid for 32-bit words on ARM64.
>>
>> Also, remove the barriers that are no longer in use.
> 
> So what happens if an updated libbpf is paired with an older kernel (or
> vice versa)?
>

"This is fine." ;-) This was briefly discussed in [1], outlined by the
previous commit!

...even on POWER.


Björn

[1] https://lore.kernel.org/bpf/20200316184423.GA14143@willie-the-truck/


> -Toke
> 
