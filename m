Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D67171098FE
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 06:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727423AbfKZF4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 00:56:13 -0500
Received: from mga05.intel.com ([192.55.52.43]:7609 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727207AbfKZF4N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Nov 2019 00:56:13 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Nov 2019 21:56:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,244,1571727600"; 
   d="scan'208";a="409868879"
Received: from shao2-debian.sh.intel.com (HELO [10.239.13.6]) ([10.239.13.6])
  by fmsmga006.fm.intel.com with ESMTP; 25 Nov 2019 21:56:10 -0800
Subject: Re: [kbuild-all] Re: [PATCH bpf-next] bpf: add
 bpf_jit_blinding_enabled for !CONFIG_BPF_JIT
To:     Daniel Borkmann <daniel@iogearbox.net>,
        kbuild test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, ast@kernel.org, jakub@cloudflare.com,
        andrii.nakryiko@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        fengguang.wu@intel.com
References: <40baf8f3507cac4851a310578edfb98ce73b5605.1574541375.git.daniel@iogearbox.net>
 <201911250641.xKeDIKoX%lkp@intel.com>
 <4447a335-6311-3470-7546-dff06672a200@iogearbox.net>
From:   Rong Chen <rong.a.chen@intel.com>
Message-ID: <9247bdf6-ced1-aed7-c6b6-8f554bd796fc@intel.com>
Date:   Tue, 26 Nov 2019 13:55:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <4447a335-6311-3470-7546-dff06672a200@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

Sorry for the inconvenience, It's our fault. the patch("bpf: Add 
bpf_jit_blinding_enabled for !CONFIG_BPF_JIT") has been applied into 
bpf-next/master,
but kbuild bot catched the patch("bpf: add bpf_jit_blinding_enabled for 
!CONFIG_BPF_JIT") and applied it again.

$ git log --oneline 
linux-review/Daniel-Borkmann/bpf-add-bpf_jit_blinding_enabled-for-CONFIG_BPF_JIT/20191125-042008 
-n5
139a0e0d24031 bpf: add bpf_jit_blinding_enabled for !CONFIG_BPF_JIT
b633b4ea8a963 bpf: Simplify __bpf_arch_text_poke poke type handling
11d450039666e bpf: Introduce BPF_TRACE_x helper for the tracing tests
691ed80326693 bpf: Add bpf_jit_blinding_enabled for !CONFIG_BPF_JIT
eb41045096419 Merge branch 'optimize-bpf_tail_call'

Best Regards,
Rong Chen

On 11/25/19 3:27 PM, Daniel Borkmann wrote:
> [ +Philip, +Fengguang ]
>
> On 11/24/19 11:54 PM, kbuild test robot wrote:
>> Hi Daniel,
>>
>> I love your patch! Yet something to improve:
>>
>> [auto build test ERROR on bpf-next/master]
>> [cannot apply to v5.4-rc8 next-20191122]
>> [if your patch is applied to the wrong git tree, please drop us a 
>> note to help
>> improve the system. BTW, we also suggest to use '--base' option to 
>> specify the
>> base tree in git format-patch, please see 
>> https://stackoverflow.com/a/37406982]
>>
>> url: 
>> https://github.com/0day-ci/linux/commits/Daniel-Borkmann/bpf-add-bpf_jit_blinding_enabled-for-CONFIG_BPF_JIT/20191125-042008
>> base: 
>> https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
>> config: i386-tinyconfig (attached as .config)
>> compiler: gcc-7 (Debian 7.4.0-14) 7.4.0
>> reproduce:
>>          # save the attached .config to linux build tree
>>          make ARCH=i386
>>
>> If you fix the issue, kindly add following tag
>> Reported-by: kbuild test robot <lkp@intel.com>
>>
>> All errors (new ones prefixed by >>):
>>
>>     In file included from include/net/sock.h:59:0,
>>                      from include/linux/tcp.h:19,
>>                      from include/linux/ipv6.h:87,
>>                      from include/net/ipv6.h:12,
>>                      from include/linux/sunrpc/clnt.h:28,
>>                      from include/linux/nfs_fs.h:32,
>>                      from init/do_mounts.c:23:
>>>> include/linux/filter.h:1061:20: error: redefinition of 
>>>> 'bpf_jit_blinding_enabled'
>>      static inline bool bpf_jit_blinding_enabled(struct bpf_prog *prog)
>>                         ^~~~~~~~~~~~~~~~~~~~~~~~
>>     include/linux/filter.h:1056:20: note: previous definition of 
>> 'bpf_jit_blinding_enabled' was here
>>      static inline bool bpf_jit_blinding_enabled(struct bpf_prog *prog)
>>                         ^~~~~~~~~~~~~~~~~~~~~~~~
>
> Hmm, can't reproduce with above .config for `make ARCH=i386`. The 
> .config doesn't have
> CONFIG_BPF_JIT, and given there's only exactly *one* definition of 
> bpf_jit_blinding_enabled()
> for CONFIG_BPF_JIT and *one* for !CONFIG_BPF_JIT this build bot 
> warning feels invalid to me
> (unless I'm completely blind and missing something obvious, but the 
> succeeded kernel build
> seems to agree with me).
>
> Thanks,
> Daniel
>
>> vim +/bpf_jit_blinding_enabled +1061 include/linux/filter.h
>>
>>    1060
>>> 1061    static inline bool bpf_jit_blinding_enabled(struct bpf_prog 
>>> *prog)
>>    1062    {
>>    1063        return false;
>>    1064    }
>>    1065
>>
>> ---
>> 0-DAY kernel test infrastructure                 Open Source 
>> Technology Center
>> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel 
>> Corporation
>>
> _______________________________________________
> kbuild-all mailing list -- kbuild-all@lists.01.org
> To unsubscribe send an email to kbuild-all-leave@lists.01.org

