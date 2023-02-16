Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23F58698EB9
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 09:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbjBPIbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 03:31:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbjBPIbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 03:31:03 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BDC63CE3F;
        Thu, 16 Feb 2023 00:30:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=mYuxXbKrCpODagUarDc7PxmUEvuI0X547SLX/QpTaVQ=; b=AGTzlp4NRGGIDPNAkeLXM+4iLa
        x2w5/D9ESlYC9CEC1O3RuVTCIVD7rxxuV1hTf6gIGMWBs8G4SdQSNUVjLX68+sPjc72yec82VX0HR
        M3D6HdQzQgZj60jTf4HJTZg2pWY7v35TL1jCM+Vb9ZINIBBGUUag5uVrWJFG850UgLTNkQ5pNyv1Z
        DcibvagxBU1/Vd7ksKLbFVrtEer0fJn/Dtz6ANP74WfVyyD2Iput8OHfxWalzd3D0KTgxgZlFkmP0
        474fHdTptHfNy7ltaxGzh9a0/rTmmRQYoUwuw4GmwL+0NNBOSENljLLZbCLNb3j7vYZQWNS0JVGkv
        Vn1enLcw==;
Received: from [2601:1c2:980:9ec0::df2f]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pSZf1-0091r7-6M; Thu, 16 Feb 2023 08:30:35 +0000
Message-ID: <4753a724-2fd4-3672-c7ce-0164fe759eea@infradead.org>
Date:   Thu, 16 Feb 2023 00:30:33 -0800
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
References: <20230216080423.513746-1-awkrail01@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20230216080423.513746-1-awkrail01@gmail.com>
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



On 2/16/23 00:04, Taichi Nishimura wrote:
> This patch is a re-submitting patch.
> I cloned bpf-next repo, run spell checker, and fixed typos.
> Included v1 and v2 patches to this one.
> 
> Could you review it again? 
> Let me know if I have any mistakes.
> 
> Best regards,
> Taichi Nishimura
> 
> Signed-off-by: Taichi Nishimura <awkrail01@gmail.com>

Hi,
The corrections all look good.
Of course, you need to fix what Greg mentioned, then you can resubmit
the patch with this added:

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
