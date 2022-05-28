Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 950CC536AB9
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 06:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355638AbiE1Ecm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 May 2022 00:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238534AbiE1Ecl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 May 2022 00:32:41 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCBB05D5D9;
        Fri, 27 May 2022 21:32:38 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id jx22so11888512ejb.12;
        Fri, 27 May 2022 21:32:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K5qfxYBTG9WQi+JmHupiyYmCa2ZO/Sp/SWpnNg7xgFg=;
        b=TBfD3xnunIhS2XmLVzvPpgX+ylxEweyl7z8zgWPrkVF69pvMB9/eSJkDKqh9BBnMzn
         DxSMSIRlyEWfQSqJzYGJ+4PidF+PFfVRs8PjCetH+KFQqKIyUcN5VFJb32LfUrkNCGjt
         xAsLSE9W9Tnk9GSNwYn7AB6HDTklA/laxHZG7OV57SvVFBc642y7Tjda9BeAJGcC1Jyo
         kf3KFdT+zdMIwYNqkHoWBeZceiKPnzLzL1NMeTtBnZwUceGN1ASq5M/qGK2z185prIM8
         3rh2/x93gFKQkLBtLApJxFr1zFw7T9MBL1U0coABCiBThTzzEPsCNQpCnS0yQGwtF3IY
         s4sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K5qfxYBTG9WQi+JmHupiyYmCa2ZO/Sp/SWpnNg7xgFg=;
        b=C18noDWvi+Arjy31dhLAyFVSi4KHLumUSRU1XRAI5bRKy7yTZeJ6kPpBb5TDsQlsuo
         NKWaUoq4c6NNMUMoT6lEhjjtamQZAN6iDpjSvd3sXk8zxU6EWkFZo8uNYQR/niZNNsrN
         jPtIPIaqnNOzf5ArkLm8KviWLVFtTC/65Y3xg5ZJDI4l2pfRONPOinDmTSpHQPYa37Zy
         2KIqzXeILogshPO2HHXMOufs08D2LWHuTcexzeiuE9Ag7HvRFajdOVPbXucQbS0xNwTM
         XA2o0yEAG+R14zbODLQTUWSLyHAXeUq52pUwEQVy4eG0p+YDpnlEe53aoWymzRqV8R/x
         y5Hw==
X-Gm-Message-State: AOAM533FM13ZCyyUrtPppZc/ESZA6ZEsYk4igIguuTx9qO3PcUGHRA6N
        6JizEe8zh7qzGUOvksAHCdRRTyqT4rQAW0fFfmQ=
X-Google-Smtp-Source: ABdhPJyc+e4+b4oc4I1w5A7pZswiReAC3+xRq+obk6xVXM2JA2WQpdxl/8he3EORjKO/k1h9+ZcgJqtGvdCaSxf51ek=
X-Received: by 2002:a17:906:6a07:b0:6fe:ec47:b64d with SMTP id
 qw7-20020a1709066a0700b006feec47b64dmr23985856ejc.765.1653712357408; Fri, 27
 May 2022 21:32:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220527071522.116422-1-imagedong@tencent.com>
 <20220527071522.116422-4-imagedong@tencent.com> <20220527181915.6e776577@kernel.org>
In-Reply-To: <20220527181915.6e776577@kernel.org>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Sat, 28 May 2022 12:32:26 +0800
Message-ID: <CADxym3ZM=eW3hNLsUuCYDfZe2F+=c_Q69YxVi9VQ_65GY2DbAQ@mail.gmail.com>
Subject: Re: [PATCH net-next 3/3] net: dropreason: reformat the comment fo skb
 drop reasons
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Menglong Dong <imagedong@tencent.com>,
        David Ahern <dsahern@kernel.org>,
        Talal Ahmad <talalahmad@google.com>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
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

On Sat, May 28, 2022 at 9:19 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 27 May 2022 15:15:22 +0800 menglong8.dong@gmail.com wrote:
> > From: Menglong Dong <imagedong@tencent.com>
> >
> > To make the code clear, reformat the comment in dropreason.h to k-doc
> > style.
> >
> > Now, the comment can pass the check of kernel-doc without warnning:
> >
> > $ ./scripts/kernel-doc -v -none include/linux/dropreason.h
> > include/linux/dropreason.h:7: info: Scanning doc for enum skb_drop_reason
> >
> > Signed-off-by: Menglong Dong <imagedong@tencent.com>
>
> I feel bad for suggesting this after you reformatted all the values
> but could we use inline notation here? With a huge enum like this
> there's a lot of scrolling between documentation and the value.
>
> /**
>  * enum skb_drop_reason - the reasons of skb drops
>  *
>  * The reason of skb drop, which is used in kfree_skb_reason().
>  * en...maybe they should be splited by group?
>  */
>  enum skb_drop_reason {
>         /**
>          * @SKB_NOT_DROPPED_YET: skb is not dropped yet (used for no-drop case)
>          */
>         SKB_NOT_DROPPED_YET = 0,
>         /** @SKB_DROP_REASON_NOT_SPECIFIED: drop reason is not specified */
>         SKB_DROP_REASON_NOT_SPECIFIED,
>         /** @SKB_DROP_REASON_NO_SOCKET: socket not found */
>         SKB_DROP_REASON_NO_SOCKET,
> ...

The inline comment is an option, which I thought of. But I found it
makes the code a little not tidy. Of course, inline comments are
easier to read. Anyway, I'll have a try and make them inline.

Thanks!
Menglong Dong
