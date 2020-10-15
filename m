Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5B6328F82C
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 20:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388489AbgJOSKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 14:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732646AbgJOSKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 14:10:17 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0513C061755;
        Thu, 15 Oct 2020 11:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:References:Cc:To:From:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=pQvZdltOltA0dyBKgaso5o0xbvv6X+nw3aKhIVJIkFk=; b=NlcAC/03sf67CYz3rzJqY4SdC5
        4pzFX9Tcde5Z/WanzweKaWtxqEZq/xfVhpdtoZbq7UMHNVdDUXl1oOuso0A9bMoeAWLG6YBHZwEOk
        upyzbRvv0eYJz9NFyPcmx6cQe0WuhDaos5MZVQGzQ51EmMa7elnXZcG5Yg4cm6jusCHkmlHO266OW
        5Alk3rhJppD4nG9O/OCRfZVxQmkqTlBgPYll1xh+8Crs2ysEAktmlaQn4m8A7jSOZ5AOwg8b/t2kl
        wV8d3VsW92mSpfTQkrXN9FWa10Bhn8uF80DzE3JyMljgOEYeYtFsdZnLz4racXqk1XhMdqPGI3OyA
        xmW+0Ikg==;
Received: from [2601:1c0:6280:3f0::507c]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kT7hc-0003u7-4u; Thu, 15 Oct 2020 18:10:12 +0000
Subject: Re: linux-next: Tree for Sep 25 [kernel/bpf/preload/bpf_preload.ko]
From:   Randy Dunlap <rdunlap@infradead.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
References: <20200925205540.37d86b03@canb.auug.org.au>
 <7c80effa-310e-141f-3b6f-0c964838d5c7@infradead.org>
Message-ID: <906b72d0-6ced-c014-3810-624299c21278@infradead.org>
Date:   Thu, 15 Oct 2020 11:10:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <7c80effa-310e-141f-3b6f-0c964838d5c7@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/25/20 9:15 AM, Randy Dunlap wrote:
> On 9/25/20 3:55 AM, Stephen Rothwell wrote:
>> Hi all,
>>
>> Changes since 20200924:
>>
> 
> 
> on x86_64:
> 
> ERROR: modpost: "bpf_preload_ops" [kernel/bpf/preload/bpf_preload.ko] undefined!
> 
> Full randconfig file is attached.
> 

This build error still happens when (on today's linux-next 20201015)

CONFIG_BPF=y
# CONFIG_BPF_SYSCALL is not set
CONFIG_ARCH_WANT_DEFAULT_BPF_JIT=y
CONFIG_USERMODE_DRIVER=y
CONFIG_BPF_PRELOAD=y
CONFIG_BPF_PRELOAD_UMD=m


-- 
~Randy
Reported-by: Randy Dunlap <rdunlap@infradead.org>
