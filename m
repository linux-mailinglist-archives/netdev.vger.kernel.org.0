Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 415586974E3
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 04:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232735AbjBOD0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 22:26:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjBOD0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 22:26:01 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBE216192;
        Tue, 14 Feb 2023 19:25:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=25j3Cvtb3jyrlYLarvQrJDhy0gbj6s2LEEygL5odKS0=; b=RiwKIz4S5XpRyhYA3uSNdol4ed
        zlnyv4sG0dgDhSJSR4+aPGbR1wac3nx+20O/vaLfTiIi2np8Nk2eGq8TJf90fJt9mZ09+pcv+9Xu6
        VrYnTbperpk7xYWw6W80mgDkZm3VUGrUk/tA6qtraS3J9MnxD52KBxIToMlhtD4vgHRSLanKHxLlq
        y5zoaYzhkwEqc6WwyUyZcJm8xxgIIEAcXowoYkJhTJWGlVXPOvJOSrSe/fk4+gTAyptH7mOQHRVmY
        aF7nAjL9Qi6KmMY4gI0Inyk2ra+RIVUuiFN/oqsI58HbDRKC5yr+T9xSVZ5k6XscnqrAXs8dRwwBH
        vByOZhlQ==;
Received: from [2601:1c2:980:9ec0::df2f]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pS8QT-004Vwc-BZ; Wed, 15 Feb 2023 03:25:45 +0000
Message-ID: <ca611ede-3797-b7b1-6261-80c7e8adde3f@infradead.org>
Date:   Tue, 14 Feb 2023 19:25:44 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v2] fixed typos on selftests/bpf
Content-Language: en-US
To:     Taichi Nishimura <awkrail01@gmail.com>
Cc:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, deso@posteo.net, haoluo@google.com,
        hawk@kernel.org, joannelkoong@gmail.com, john.fastabend@gmail.com,
        jolsa@kernel.org, kpsingh@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        llvm@lists.linux.dev, martin.lau@linux.dev, mykolal@fb.com,
        nathan@kernel.org, ndesaulniers@google.com, netdev@vger.kernel.org,
        sdf@google.com, shuah@kernel.org, song@kernel.org, trix@redhat.com,
        yhs@fb.com, ytcoode@gmail.com
References: <f8f3e8df-f707-28f3-ab0f-eec21686c940@infradead.org>
 <20230215032122.417515-1-awkrail01@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20230215032122.417515-1-awkrail01@gmail.com>
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



On 2/14/23 19:21, Taichi Nishimura wrote:
> Hi Randy,
> 
> Thank you for your reviewing.
> I fixed costant and it's to constant and its, respectively.
> 
> Best regards,
> Taichi Nishimura
> 
> Signed-off-by: Taichi Nishimura <awkrail01@gmail.com>

Looks good. Thanks.

Acked-by: Randy Dunlap <rdunlap@infradead.org>


> ---
>  tools/testing/selftests/bpf/progs/test_cls_redirect.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/progs/test_cls_redirect.c b/tools/testing/selftests/bpf/progs/test_cls_redirect.c
> index a8ba39848bbf..66b304982245 100644
> --- a/tools/testing/selftests/bpf/progs/test_cls_redirect.c
> +++ b/tools/testing/selftests/bpf/progs/test_cls_redirect.c
> @@ -610,8 +610,8 @@ static INLINING ret_t get_next_hop(buf_t *pkt, encap_headers_t *encap,
>   *
>   *    fill_tuple(&t, foo, sizeof(struct iphdr), 123, 321)
>   *
> - * clang will substitute a costant for sizeof, which allows the verifier
> - * to track it's value. Based on this, it can figure out the constant
> + * clang will substitute a constant for sizeof, which allows the verifier
> + * to track its value. Based on this, it can figure out the constant
>   * return value, and calling code works while still being "generic" to
>   * IPv4 and IPv6.
>   */

-- 
~Randy
