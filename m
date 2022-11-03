Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B61B6185AD
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 18:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbiKCRD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 13:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232141AbiKCRDL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 13:03:11 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6F7F1D0C3;
        Thu,  3 Nov 2022 10:03:00 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id v27so4050881eda.1;
        Thu, 03 Nov 2022 10:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sMe/w1piolBGnVahRqgDlvg03nMiDV17ymksE4asAgo=;
        b=byOUMkMoSgwsPdgJfElh/+HW2anWgLMSKtMVUdskPaVMPCfFYA+NulTZxzxduj5LuJ
         A9DTSRintzRdCI0OSXQ8EouZ48eZ9RnW/fXrNuWN31LrHFn01josAvt8V9F3E1T3vDl0
         q7n1JjkOJuqYUE5jdtX2UouAmrwtPsL416fQu66aUTZV5IguYiAzF4HKXOeYRVfa5j4Q
         1k8h2fDV8zG7+qXriBJ3OlfsAtWwo8EXD+gXYbxrUafVYxdfGscxyiDKtsEDa1yQ0yag
         +U89X4QWgMRD0pMWz1sug6L5lHzKysTpOb7bkoISYA1P8MS1QX6NZjf3XNPJpv9kX8BY
         aaIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sMe/w1piolBGnVahRqgDlvg03nMiDV17ymksE4asAgo=;
        b=J6FTqvM76erDbgETjPCm/OHeT6HQxlxxVFLWtM6y0rf2CaAlG8+KDEy1wqDF9Kf+zk
         2tYuGemJOqot2XYNYbzMxHbemqr66S8086GOhHu7iJn7Fg+6i2a/HMG5e4JpShCk73QP
         vlzGK0zQlx/o6inhoV6F+j/FbmgSUGo8ryApN3dk+HogX+AqvHjtfhnCfyeN6VVRQtT+
         UgXEMKhGX3HxkVECd6qs+7wy2e9juf5TocthCt6KCo1wF/CYi+cF07d9kyBpPevdojAM
         h9vLuhVTKZOP15Lm4dTXva42Yq4I8TcaBtOI6JDsowqfer3t65ksjRsJtQnlPdCi9tn0
         2JpA==
X-Gm-Message-State: ACrzQf3GCNullmP8RglMqqstXTrehDI10Pfy3V2U963pUK+x5+2HMQR3
        pMRATSISSXCdWgrGhAMHeaqqpE+VYM9IRqtoTOY=
X-Google-Smtp-Source: AMsMyM7m60RCHrSwiShzF46g7SlxeqpGdr6nzQ8fYR6zzn6NuZzEosn31fOOq69vNhjz11pxmXSaxcZnUtU2V3pG2cY=
X-Received: by 2002:a50:ee0a:0:b0:463:4055:9db4 with SMTP id
 g10-20020a50ee0a000000b0046340559db4mr25325777eds.421.1667494979022; Thu, 03
 Nov 2022 10:02:59 -0700 (PDT)
MIME-Version: 1.0
References: <20221103091100.246115-1-yangjihong1@huawei.com>
In-Reply-To: <20221103091100.246115-1-yangjihong1@huawei.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 3 Nov 2022 10:02:47 -0700
Message-ID: <CAADnVQJTZdDCEVL0ZuieGvTYEPOEqvdScnr77Nnb+tbBuFwx3g@mail.gmail.com>
Subject: Re: [PATCH net v2] uapi: Add missing linux/stddef.h header file to in.h
To:     Yang Jihong <yangjihong1@huawei.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 3, 2022 at 2:16 AM Yang Jihong <yangjihong1@huawei.com> wrote:
>
> commit 5854a09b4957 ("net/ipv4: Use __DECLARE_FLEX_ARRAY() helper") does
> not include "linux/stddef.h" header file, and tools headers update
> linux/in.h copy, BPF prog fails to be compiled:
>
>     CLNG-BPF [test_maps] bpf_flow.bpf.o
>     CLNG-BPF [test_maps] cgroup_skb_sk_lookup_kern.bpf.o
>   In file included from progs/cgroup_skb_sk_lookup_kern.c:9:
>   /root/linux/tools/include/uapi/linux/in.h:199:3: error: type name requires a specifier or qualifier
>                   __DECLARE_FLEX_ARRAY(__be32, imsf_slist_flex);
>                   ^
>   /root/linux/tools/include/uapi/linux/in.h:199:32: error: type specifier missing, defaults to 'int' [-Werror,-Wimplicit-int]
>                   __DECLARE_FLEX_ARRAY(__be32, imsf_slist_flex);
>                                                ^
>   2 errors generated.
>
> To maintain consistency, add missing header file to kernel.
>
> Fixes: 5854a09b4957 ("net/ipv4: Use __DECLARE_FLEX_ARRAY() helper")
> Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
> ---
>
> Changes since v1:
>  - 'Fixes' tag separates by the commit message by a blank line
>  - Remove the empty line between 'Fixes' and SoB.
>  - Specify the target tree to "net" in title
>  - Wrap the commit message text to 75 chars per line (except build output)

Since it's bpf related please always use [PATCH bpf] in the subject.
Please monitor the tree and mailing lists as well.
In this case the proper fix is already in bpf tree.
https://lore.kernel.org/bpf/20221102182517.2675301-1-andrii@kernel.org/

Your fix alone is incomplete. See patch 2 in the fix above.
