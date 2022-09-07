Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2455B0C22
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 20:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbiIGSGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 14:06:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbiIGSGA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 14:06:00 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D105645983;
        Wed,  7 Sep 2022 11:05:59 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id b17so8009198ilh.0;
        Wed, 07 Sep 2022 11:05:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=3VYDrggKK6dYf0vUh61nL8e3i08cyN39P7b9NXouJAk=;
        b=jCpaSnBdBcuxgMuPjbBYy/Svd6b+hQtSTsEm+pOpu2c71xVBOCGYBEUnLdUFa2PfTb
         nsOth5VxJSUYtViyvMGo10f27YePi7e0CVkrDrAaAbM+NTCDTl28f5vPUxHzn3k92+dV
         w0c0++hM5l3e111wUnhwlu5hOy09bmfhe398KURDiQ7D815nh4eN9Nfmibdg7twjD10C
         R1cXMiAd97dA2D/SlF6VPPfI8o4IIIMJ5mqtpmIwUJMan0Cu9TpeXwX/xwBpVBrb1INs
         DkluWmixchUKq6mUjUX7ezD0KHnIbneGTDjcrxLWmkj1LnX/xtbvX/17l7h5HbIwAtSa
         8Oog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=3VYDrggKK6dYf0vUh61nL8e3i08cyN39P7b9NXouJAk=;
        b=Mn9w4bjMdwf0zQga5HLVQ9czRjsYAnHdEe20VlQDu+Rd+S9ptenoeX/wldBxqsS6yx
         xl3ju4fc28bxP1r8rzrQ8XVvm2L9eCGoyYTNHRThAms/T/6ZRI55mJxoYlZGAxj/kG9P
         vkLa88/laPTCxNZDOiCzr+lHV+XnwbRpj0YOPU3NYx484+z2Hz+aoU9b5c5+SyrsQdTk
         oKvy3AXYR5ut6joL6HudJk1ZFffNUmtO1cmFmT6VE4jwnPZxz2KmGmDsxv4fQnH7lHiT
         quTG5j1a7Z7zdy+tRpv6j1Axt1E7WM9PyEbTEMqwKxGha75/Rq54OspVLB4IFkYRADnO
         JX0g==
X-Gm-Message-State: ACgBeo1+qLG2pd3GHGhPe5qC4nrzgLJHgIxAMSy630wSAO8VaAkEjUWR
        aRcXoO3knFvtbST5olMw5T7e6+YIaoTh980SP2I=
X-Google-Smtp-Source: AA6agR4akzWSTmL/ozTsDhdQC+Ydb5z3g0nHIkINzA2f1xTKnDFImCHNRXBxC09keviCWSR+xb6UyWxuFbttdGHK1xo=
X-Received: by 2002:a05:6e02:1d0b:b0:2eb:73fc:2235 with SMTP id
 i11-20020a056e021d0b00b002eb73fc2235mr2537412ila.164.1662573959209; Wed, 07
 Sep 2022 11:05:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220906151303.2780789-1-benjamin.tissoires@redhat.com> <20220906151303.2780789-6-benjamin.tissoires@redhat.com>
In-Reply-To: <20220906151303.2780789-6-benjamin.tissoires@redhat.com>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Wed, 7 Sep 2022 20:05:23 +0200
Message-ID: <CAP01T77FCFH-12a0f=NEf71X+=8WXiDTAf6i+oOYQ9aAruMTUg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v11 5/7] bpf/btf: bump BTF_KFUNC_SET_MAX_CNT
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 6 Sept 2022 at 17:13, Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> net/bpf/test_run.c is already presenting 20 kfuncs.
> net/netfilter/nf_conntrack_bpf.c is also presenting an extra 10 kfuncs.
>
> Given that all the kfuncs are regrouped into one unique set, having
> only 2 space left prevent us to add more selftests.
>
> Bump it to 64 for now.
>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>
> ---

I can imagine pinning this down as the reason the program was failing
to load must have been fun, since I ended up requiring this too in the
linked list series...

Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>

>
> no changes in v11
>
> new in v10
> ---
>  kernel/bpf/btf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index eca9ea78ee5f..8280c1a8dbce 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -208,7 +208,7 @@ enum btf_kfunc_hook {
>  };
>
>  enum {
> -       BTF_KFUNC_SET_MAX_CNT = 32,
> +       BTF_KFUNC_SET_MAX_CNT = 64,
>         BTF_DTOR_KFUNC_MAX_CNT = 256,
>  };
>
> --
> 2.36.1
>
