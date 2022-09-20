Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3954B5BEF6A
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 23:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbiITVwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 17:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbiITVwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 17:52:14 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BC4422BC4;
        Tue, 20 Sep 2022 14:52:13 -0700 (PDT)
Message-ID: <da5fdb0c-cf24-6356-206e-bdde00f0f8fa@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1663710731;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=klj5NmUbqfIc93G99y7Qpm3kf0ZTRJq/7uq19pl5XF4=;
        b=aBkEdUmLY/EfW1ilM0/bGn2JVVfZNzNQekyFwmo1Jti3fNmtpLv2VsAWs2L7ADrl/s0XX4
        aBDaax9depWMvY77qDJV67e1qi910tCZ6A4d3WVWB3HJAISZbhE1iD3P3mr5PJqPJ7rgup
        WWdQn0Y9fBcfmfVISuvC/l8RKYQdD/8=
Date:   Tue, 20 Sep 2022 14:52:05 -0700
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v3 3/3] bpf: Move nf_conn extern declarations to
 filter.h
Content-Language: en-US
To:     Daniel Xu <dxu@dxuuu.xyz>
Cc:     pablo@netfilter.org, fw@strlen.de, toke@kernel.org,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, memxor@gmail.com
References: <cover.1663683114.git.dxu@dxuuu.xyz>
 <2bd2e0283df36d8a4119605878edb1838d144174.1663683114.git.dxu@dxuuu.xyz>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <2bd2e0283df36d8a4119605878edb1838d144174.1663683114.git.dxu@dxuuu.xyz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/20/22 7:15 AM, Daniel Xu wrote:
> --- a/include/net/netfilter/nf_conntrack_bpf.h
> +++ b/include/net/netfilter/nf_conntrack_bpf.h
> @@ -12,12 +12,6 @@
>   extern int register_nf_conntrack_bpf(void);
>   extern void cleanup_nf_conntrack_bpf(void);
>   
> -extern struct mutex nf_conn_btf_access_lock;
> -extern int (*nfct_btf_struct_access)(struct bpf_verifier_log *log, const struct btf *btf,
> -				     const struct btf_type *t, int off, int size,
> -				     enum bpf_access_type atype, u32 *next_btf_id,
> -				     enum bpf_type_flag *flag);
> -

I removed the 'include mutex.h' from this header and applied.  Thanks.
