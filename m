Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F4060531AE5
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbiEWTnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 15:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234307AbiEWTm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 15:42:29 -0400
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A682FFFC;
        Mon, 23 May 2022 12:39:52 -0700 (PDT)
Received: by mail-vs1-xe2a.google.com with SMTP id h5so8134989vsq.5;
        Mon, 23 May 2022 12:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rdaOtEJzlEI4rkC5/eExmfsw3plPJUfdC5HwNnDdrl8=;
        b=ls+NfBeWK6+RxG8ca3EQRNTT3yplKi3fChJbujgJK3CbJJDIoJPHk4Ev2xPWMfQ3UQ
         4/3OhdIsuwT2+wTRoCDZIVGul70Iv2hTQHHRBNW0qqWIQrvdJf0OeDCH/xOr2DmGz9I/
         ZG7oDy5uZpNdDM6p3D/WL/jWOfRF21NDIHlg3rzRJxZjHPkrdmZbMWT8FYMoGzGnkdsd
         hYQr3w1DJETirktof+iE4+F2Y82LwoRI+4bQ2v7TEnfnimu3lE0kVJRQbtDAEfx4vp/8
         PKZuuJV5Jvdsl0iiULvkfE6cB8RkoVrr3nlFVPiEjpiXwKrXrzeMvGTTULrXKheM4PXY
         eIJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rdaOtEJzlEI4rkC5/eExmfsw3plPJUfdC5HwNnDdrl8=;
        b=g1HbdD7jjK35ESo6RkbLQUVaZ+ZHOqqp6nOMPlWNjk7rZ/lciEXNHmkd2vgoyY6H92
         bQvMsmGmudN+fMUg/tzOXzPBx50Z1KJHGAZEqOJuGjWPXPwU4Pk38gGeWIxzHp7YOJva
         Ug8YMf3FDrtbaaRtk6936Uc1zMa3n1OilgPLersXU2bRqYlaVYTiAJrt25QWSnLXgqgh
         nUgSOGCdyGU3ejQTo8G0EnLXJJ2Lj/fphvHTHhJdV8F9QDuCtmNpXqHR31TriEy/3xin
         bb2LXXxP+fW1hKorYZNt1dJwX2pH2C6+g6dojc1VjBMyZewGAeduGvO/VWF2cedueTqA
         fBNg==
X-Gm-Message-State: AOAM531xFPzzj/tGuTPC/co5hljve2bQ3bZoT963T0FplTUmSVmTdmdm
        940B+pWgtpftNBYhCOrkKWaXcV27zpKgq8gIF13iA8i45N4=
X-Google-Smtp-Source: ABdhPJxiCGD1HM0L3J2KBiNOFPU+Aw2Qa2Kb9zDMgIIPHpmwII13aUMzattuzW3qu8Mz1+vUUf7DJTgQD/WZUF0qyOk=
X-Received: by 2002:a05:6102:4b6:b0:335:f244:2286 with SMTP id
 r22-20020a05610204b600b00335f2442286mr7503887vsa.54.1653334792037; Mon, 23
 May 2022 12:39:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220521000921.8337-1-ruijian63@gmail.com>
In-Reply-To: <20220521000921.8337-1-ruijian63@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 23 May 2022 12:39:41 -0700
Message-ID: <CAEf4BzZkfc4ivfewD4Bo8ngfcg-evOjYPwyyL1zcc3oH7rUDyQ@mail.gmail.com>
Subject: Re: [PATCH] samples: fix compile failure error
To:     Ruijian Li <ruijian63@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, 798073189@qq.com
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

On Fri, May 20, 2022 at 5:09 PM Ruijian Li <ruijian63@gmail.com> wrote:
>
> Because compile samples/bpf/test_lru_dist failure, I remove the
> declaration of the struct list_head.
>
> Signed-off-by: Ruijian Li <ruijian63@gmail.com>
> ---
>  samples/bpf/test_lru_dist.c | 4 ----
>  1 file changed, 4 deletions(-)
>
> diff --git a/samples/bpf/test_lru_dist.c b/samples/bpf/test_lru_dist.c
> index 75e877853596..dd7eb470653b 100644
> --- a/samples/bpf/test_lru_dist.c
> +++ b/samples/bpf/test_lru_dist.c
> @@ -33,10 +33,6 @@ static int nr_cpus;
>  static unsigned long long *dist_keys;
>  static unsigned int dist_key_counts;
>
> -struct list_head {
> -       struct list_head *next, *prev;
> -};
> -

this struct is used right there one line below, how removing it fixes
compilation issues? What was the error in the first place? Did you run
`make headers_install` before building samples/bpf? Please provide a
bit more information.

>  static inline void INIT_LIST_HEAD(struct list_head *list)
>  {
>         list->next = list;
> --
> 2.32.0
>
