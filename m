Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F965568957
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 15:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbiGFNZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 09:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbiGFNZL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 09:25:11 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C20241903B
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 06:25:10 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-31c89653790so88720537b3.13
        for <netdev@vger.kernel.org>; Wed, 06 Jul 2022 06:25:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BePqUTWYhdjlTvvB66t3UVfSpmustcH7nCWgRyDk3Mk=;
        b=s/KcpU4PIRE8VAP5ZQl7gL6cPhY0DdUPBwoMA5MIm4vKy9Ba5WX6LAfcqB++0/ySn8
         XjaKWGkOhZdSb7odaZScAqEH1bxMiGlWQOpQgoN8NCcjEAIvTvppr/NSMljXpx6eo6gz
         q3ZjV8f45pZ7IlV5cBDEJ/0CJD551xpYE9WEbVhaaus4wXwhumewBC7x3aWnC5trnB2N
         MzHSkge87w641+rrLcGr2KBUXycRomLuobPTdjqSoaHEQvBOE6DffDcl5Ney+CS/hRSO
         rUckr33GdI1esHxtwrt78SmvsUc+llONLeKWk1jL320QYM+tr0GTF02H1a0Xn020Rx65
         eniQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BePqUTWYhdjlTvvB66t3UVfSpmustcH7nCWgRyDk3Mk=;
        b=70x0tfKwwR6o2WSVAASjB/dDMXxSmd9kjzjC7g37BoxvGHmAEQ+eKnQsLue0mE6upA
         gLbLeEuYam1GqAwVz29y7NmGRO3MSoRqxwtVz/jVfIWAf9OnGQ4xAmvgssRyboSqdE7H
         TcL7nic0Gcngun8c1qofRGbOrYybupG5RR9PQF3nBMVw2WSc/B4hx4HoDG47JXBQ8W9u
         SA1Xi4szw7JpLrhQq+0RiJk2oTdRZiKeI+8btCq5FJBr7Hzap9u2XscdPW7fVmIvOXQW
         9qEljexCzimcHD9D8f6f8cy3bCoAWgxwJD5/6vjG3PCyByAxgkX42gElzSIjWzOggiIN
         c91Q==
X-Gm-Message-State: AJIora9j+zJ5kkXJGppmelH2VukwnnmoqpkBkzp9Zb4Fnv8fL6UIGTeE
        r3Y784Rv9xVR+CEslWn998bnJM2oELCIM/r1lpLF/JuUx7u2/Q==
X-Google-Smtp-Source: AGRyM1tvmgIomsx3pkl14E+/sr4mHoGZHBd37h04kvpzDZ4sEowTA+HM/y+plozdG15Y28rUTyNoMS1jgyUIcWevqJM=
X-Received: by 2002:a81:7996:0:b0:31c:96d1:746 with SMTP id
 u144-20020a817996000000b0031c96d10746mr19259492ywc.467.1657113909629; Wed, 06
 Jul 2022 06:25:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220706085320.17581-1-atenart@kernel.org>
In-Reply-To: <20220706085320.17581-1-atenart@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 6 Jul 2022 15:24:58 +0200
Message-ID: <CANn89iKjr=3CVtAiJN_SLUYj5pLta5E1HxR6pEwHcNqwY3BAKA@mail.gmail.com>
Subject: Re: [PATCH net-next] Documentation: add a description for net.core.high_order_alloc_disable
To:     Antoine Tenart <atenart@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 6, 2022 at 10:53 AM Antoine Tenart <atenart@kernel.org> wrote:
>
> A description is missing for the net.core.high_order_alloc_disable
> option in admin-guide/sysctl/net.rst ; add it. The above sysctl option
> was introduced by commit ce27ec60648d ("net: add high_order_alloc_disable
> sysctl/static key").
>
> Cc: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Antoine Tenart <atenart@kernel.org>
> ---
>  Documentation/admin-guide/sysctl/net.rst | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
> index fcd650bdbc7e..85ab83411359 100644
> --- a/Documentation/admin-guide/sysctl/net.rst
> +++ b/Documentation/admin-guide/sysctl/net.rst
> @@ -391,6 +391,16 @@ GRO has decided not to coalesce, it is placed on a per-NAPI list. This
>  list is then passed to the stack when the number of segments reaches the
>  gro_normal_batch limit.
>
> +high_order_alloc_disable
> +------------------------
> +
> +By default the allocator for page frags tries to use high order pages (order-3
> +on x86). While the default behavior gives good results in most cases, some users
> +might hit a contention in page allocations/freeing. This allows to opt-in for
> +order-0 allocation instead.
>

Note:

linux-5.14 allowed high-order pages to be stored on the per-cpu lists.

I ran again the benchmark cited in commit ce27ec60648d to confirm that
the slowdown we had before 5.14 for
high number of alloc/frees per second is no more.

    for thr in {1..30}
    do
     sysctl -wq net.core.high_order_alloc_disable=0
     T0=`./super_netperf $thr -H 127.0.0.1 -l 15`
     sysctl -wq net.core.high_order_alloc_disable=1
     T1=`./super_netperf $thr -H 127.0.0.1 -l 15`
     echo $thr:$T0:$T1
    done

1:62799:48115
2:121604:94588
3:183240:138376
4:241544:184639
5:302641:232985
6:358566:276494
7:418464:316401
8:470687:362562
9:528084:401193
10:586269:446422
11:642764:482556
12:696490:530701
13:748840:573388
14:808681:610787
15:856676:645813
16:912061:687695
17:966847:738943
18:1011960:771893
19:1056554:798815
20:1109519:844586
21:1159857:849445
22:1203224:888646
23:1226389:933538
24:1238174:964386
...


 +
> +Default: 0
> +
>  2. /proc/sys/net/unix - Parameters for Unix domain sockets
>  ----------------------------------------------------------
>
> --
> 2.36.1
>
