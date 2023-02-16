Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5A5E699AB3
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 17:58:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbjBPQ6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 11:58:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbjBPQ6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 11:58:48 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FA0727988;
        Thu, 16 Feb 2023 08:58:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=6wGbs1zzxMmzwpDLodKGDpXuC2kipHsbgo+ADLhwwGo=; b=Z6h9iUM2J47GO6FmgkAmCiGsGq
        2u9RKvp3C3TIaZrNDy/tHURkA8sX1+AGykuLZA4yWEfNSce77Yd0GkZDAeIVxxss0iPwwUBumW9kM
        +fmuhC9fP834MkPeHkYz4Gvq+/O5E3k8IVB9uMUbQqyLfMkxOSPACkJjEWarj6OsbUM1QO/goACIA
        LqObuWQzeebm5N0q/vQ+KAgfbvNj4Nkw7Oy5vybjLZZKcsPbcrSTSd8UhOLhl2I/CjsAMYwtFgDAa
        DdCTAR3m3OKKvB9FOaYNp7VBvarBpE2tT2A9cTEkDRjQojVSOoQd4n8n24EP/ZjE1I5hyxEZBfXoH
        VBeya9Mw==;
Received: from [2601:1c2:980:9ec0::df2f]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pShaa-00BHG7-ER; Thu, 16 Feb 2023 16:58:32 +0000
Message-ID: <328ad5a9-552b-ebd9-0ea2-6313a7347cad@infradead.org>
Date:   Thu, 16 Feb 2023 08:58:29 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH bpf-next] Fix typos in selftest/bpf files
Content-Language: en-US
To:     Taichi Nishimura <awkrail01@gmail.com>, andrii@kernel.org,
        mykolal@fb.com, ast@kernel.org, daniel@iogearbox.net,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, shuah@kernel.org,
        davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
        nathan@kernel.org, ndesaulniers@google.com, trix@redhat.com,
        iii@linux.ibm.com, ytcoode@gmail.com, deso@posteo.net,
        memxor@gmail.com, joannelkoong@gmail.com
Cc:     bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        llvm@lists.linux.dev
References: <20230216085537.519062-1-awkrail01@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20230216085537.519062-1-awkrail01@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/16/23 00:55, Taichi Nishimura wrote:
> Run spell checker on files in selftest/bpf and fixed typos.
> 
> Signed-off-by: Taichi Nishimura <awkrail01@gmail.com>

Reviewed-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
>  tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c  | 2 +-
>  tools/testing/selftests/bpf/prog_tests/trampoline_count.c   | 2 +-
>  .../testing/selftests/bpf/progs/btf_dump_test_case_syntax.c | 2 +-
>  tools/testing/selftests/bpf/progs/dynptr_fail.c             | 2 +-
>  tools/testing/selftests/bpf/progs/strobemeta.h              | 2 +-
>  tools/testing/selftests/bpf/progs/test_cls_redirect.c       | 6 +++---
>  tools/testing/selftests/bpf/progs/test_subprogs.c           | 2 +-
>  tools/testing/selftests/bpf/progs/test_xdp_vlan.c           | 2 +-
>  tools/testing/selftests/bpf/test_cpp.cpp                    | 2 +-
>  tools/testing/selftests/bpf/veristat.c                      | 4 ++--
>  10 files changed, 13 insertions(+), 13 deletions(-)
> 


-- 
~Randy
