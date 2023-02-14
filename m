Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC428696A20
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 17:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjBNQpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 11:45:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232749AbjBNQo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 11:44:57 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B7F2A25B;
        Tue, 14 Feb 2023 08:44:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=DcXjeo41TfylPPxV971J1tbQSZ0SSP9nKlIQ9CVep7E=; b=z3CPbyr+vxel1ZDWrN7GI2XOKI
        r6XXJGCh5zCeyrJCHSeudLiysegEfILmqXVWjoIYhDiOPeKdYHcnP6HvJ3nqXQzyQcOtaXm+bUl0U
        iRvs8g0ryHAVQuJzf24fWVek1AGAEaIc75CahDv0zUPOY9eiwk3hjDv9bchNDqh0OdreQztwtL6Xo
        uS3CneIwVqg8UN5mlY5BVXTfeA6fuJzZYSWrJHuSjobqMOY80WQ+Adp++tKPIww8xiLP5Ozpuypum
        akF4p8CIEc+HhG6CjDYk91hU85FsPU+0L+OFVKLh9yojepimF2qnsCN11qlIUil3ipMlBB9HRc57w
        kqiR84rA==;
Received: from [2601:1c2:980:9ec0::df2f]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pRyPT-002slN-LA; Tue, 14 Feb 2023 16:44:03 +0000
Message-ID: <f8f3e8df-f707-28f3-ab0f-eec21686c940@infradead.org>
Date:   Tue, 14 Feb 2023 08:44:02 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] fixed typos on selftests/bpf
Content-Language: en-US
To:     Taichi Nishimura <awkrail01@gmail.com>, shuah@kernel.org,
        andrii@kernel.org, mykolal@fb.com, ast@kernel.org,
        daniel@iogearbox.net, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        sdf@google.com, haoluo@google.com, jolsa@kernel.org,
        davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
        nathan@kernel.org, ndesaulniers@google.com, trix@redhat.com,
        ytcoode@gmail.com, deso@posteo.net, joannelkoong@gmail.com
Cc:     linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, llvm@lists.linux.dev
References: <20230214152850.389392-1-awkrail01@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20230214152850.389392-1-awkrail01@gmail.com>
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

Hi--

On 2/14/23 07:28, Taichi Nishimura wrote:
> I run spell checker and found typos in selftest/bpf/ files.
> Fixed all of the detected typos.
> 
> This patch is an extra credit for kselftest task
> in the Linux kernel bug fixing spring unpaid 2023.
> 
> Best regards,
> Taichi Nishimura
> 
> Signed-off-by: Taichi Nishimura <awkrail01@gmail.com>
> ---
>  tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c    | 2 +-
>  tools/testing/selftests/bpf/prog_tests/trampoline_count.c     | 2 +-
>  tools/testing/selftests/bpf/progs/btf_dump_test_case_syntax.c | 2 +-
>  tools/testing/selftests/bpf/progs/dynptr_fail.c               | 2 +-
>  tools/testing/selftests/bpf/progs/strobemeta.h                | 2 +-
>  tools/testing/selftests/bpf/progs/test_cls_redirect.c         | 4 ++--
>  tools/testing/selftests/bpf/progs/test_subprogs.c             | 2 +-
>  tools/testing/selftests/bpf/progs/test_xdp_vlan.c             | 2 +-
>  tools/testing/selftests/bpf/test_cpp.cpp                      | 2 +-
>  tools/testing/selftests/bpf/veristat.c                        | 4 ++--
>  10 files changed, 12 insertions(+), 12 deletions(-)
> 

Issues here:

> @@ -610,7 +610,7 @@ static INLINING ret_t get_next_hop(buf_t *pkt, encap_headers_t *encap,
>   *
>   *    fill_tuple(&t, foo, sizeof(struct iphdr), 123, 321)
>   *
> - * clang will substitue a costant for sizeof, which allows the verifier
> + * clang will substitute a costant for sizeof, which allows the verifier

                              constant

>   * to track it's value. Based on this, it can figure out the constant

               its value.

>   * return value, and calling code works while still being "generic" to
>   * IPv4 and IPv6.

The other changes look good. Thanks.

After fixing the issues above:
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>


-- 
~Randy
