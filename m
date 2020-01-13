Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF81F13911F
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 13:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgAMMbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 07:31:43 -0500
Received: from mga06.intel.com ([134.134.136.31]:2101 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725832AbgAMMbm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 07:31:42 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jan 2020 04:31:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,428,1571727600"; 
   d="scan'208";a="273017199"
Received: from arydygie-mobl.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.51.144])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Jan 2020 04:31:39 -0800
Subject: Re: [PATCH 5/5] bpf: Allow to resolve bpf trampoline in unwind
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@redhat.com>
References: <20191229143740.29143-1-jolsa@kernel.org>
 <20191229143740.29143-6-jolsa@kernel.org>
 <20200106234639.fo2ctgkb5vumayyl@ast-mbp> <20200107130546.GI290055@krava>
 <76a10338-391a-ffca-9af8-f407265d146a@intel.com>
 <20200113094310.GE35080@krava>
 <a2e2b84e-71dd-e32c-bcf4-09298e9f4ce7@intel.com>
Message-ID: <9da1c8f9-7ca5-e10b-8931-6871fdbffb23@intel.com>
Date:   Mon, 13 Jan 2020 13:31:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <a2e2b84e-71dd-e32c-bcf4-09298e9f4ce7@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-01-13 13:21, Björn Töpel wrote:
> 
> On 2020-01-13 10:43, Jiri Olsa wrote:
>> hi,
>> attached patch seems to work for me (trampoline usecase), but I don't 
>> know
>> how to test it for dispatcher.. also I need to check if we need to 
>> decrease
>> BPF_TRAMP_MAX or BPF_DISPATCHER_MAX, it might take more time;-)
>>
> 
> Thanks for working on it! I'll take the patch for a spin.
> 
> To test the dispatcher, just run XDP!
> 
> With your change, the BPF_DISPATCHER_MAX is still valid. 48 entries =>
> 1890B which is < (BPF_IMAGE_SIZE / 2).
>

...and FWIW, it would be nice with bpf_dispatcher_<...> entries in 
kallsyms as well. If that code could be shared with the trampoline code 
as well (bpf_trampoline_<btf_id>), that'd be great!
