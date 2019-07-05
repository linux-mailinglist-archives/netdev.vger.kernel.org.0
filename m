Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5262F60DBF
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 00:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726016AbfGEWX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 18:23:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38894 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbfGEWX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 18:23:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=GaF0igJTtDSWaw4oHqNfMc4C4pBtKNjoYsTBMA2zuAc=; b=NL++JgxX7cbuv0Cgtm4zs6QgV3
        6NjiFNaVJuT+FNDxroI84BmdfJybRai6t45qi3YCTsfqeEThPPjHNNvHltsQtx7s8W7zy+hlbu8HH
        2l7wR7n8VOcVrCAAQTjdYCjW3fBDwoJZgBSOyJikIpVe72FenKt/BbPloey5izo//czpSV5bNwc8u
        Z+EwZQ4q+9rnrT4Uxt9tQ1rdaQawQmuj73Fg+Mqu+Ulghec1mvm1nCfXavaMv8zitkEY6aaRzJICd
        2bTo0KsKoaMieALcVzsaf9DZX21yxLnNMZrTu/Xi/Y/0zAg0KMa118I+zOy7inexALYHYsLyR5keB
        1cWb52Ow==;
Received: from static-50-53-52-16.bvtn.or.frontiernet.net ([50.53.52.16] helo=midway.dunlab)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hjWcT-0005Ud-CT; Fri, 05 Jul 2019 22:23:53 +0000
Subject: Re: linux-next: Tree for Jun 28 (kernel/bpf/cgroup.c)
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Daniel Mack <zonque@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
References: <20190628203840.1f74e739@canb.auug.org.au>
 <74534ab8-a397-ac4f-dd02-9b3618d7c4cd@infradead.org>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <a92ec13a-352c-b3cc-8467-a3b6d02aff6d@infradead.org>
Date:   Fri, 5 Jul 2019 15:23:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <74534ab8-a397-ac4f-dd02-9b3618d7c4cd@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/28/19 1:52 PM, Randy Dunlap wrote:
> On 6/28/19 3:38 AM, Stephen Rothwell wrote:
>> Hi all,
>>
>> Changes since 20190627:
>>
> 
> on i386:
> 
> ld: kernel/bpf/cgroup.o: in function `cg_sockopt_func_proto':
> cgroup.c:(.text+0x2906): undefined reference to `bpf_sk_storage_delete_proto'
> ld: cgroup.c:(.text+0x2939): undefined reference to `bpf_sk_storage_get_proto'
> ld: kernel/bpf/cgroup.o: in function `__cgroup_bpf_run_filter_setsockopt':
> cgroup.c:(.text+0x85e4): undefined reference to `lock_sock_nested'
> ld: cgroup.c:(.text+0x8af2): undefined reference to `release_sock'
> ld: kernel/bpf/cgroup.o: in function `__cgroup_bpf_run_filter_getsockopt':
> cgroup.c:(.text+0x8fd6): undefined reference to `lock_sock_nested'
> ld: cgroup.c:(.text+0x94e4): undefined reference to `release_sock'
> 
> 
> Full randconfig file is attached.
> 

These build errors still happen in linux-next of 20190705...

-- 
~Randy
