Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFF3530D35
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 12:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234049AbiEWK0X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 06:26:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234146AbiEWK0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 06:26:02 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB1065D4;
        Mon, 23 May 2022 03:26:01 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id c190-20020a1c35c7000000b0038e37907b5bso11045543wma.0;
        Mon, 23 May 2022 03:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7JM49rnw8/t927Go20KZOB423YW0VstYI3tZ2JyFgC8=;
        b=QlsMYRADCMyemx36a85rYfOct9dK2xIxX9+AhNQZ9qjyJGCfDpnm7J08ZksqiYct2J
         srzoTj/57tjgYEDh5ko9laPVFQSAXiARaaqDjayx4XBzNzuRq1j131b4+417LcY34h+o
         5W44bcpR9vZgGL0dvRRCrEzUbD28VZK0v5ITog+BQB7aPVAIqKY4GgVys3DuGhE/sVL0
         NwLqnc7MW+O96gBKtU4FvV1iThZyB+jIitSs9CgoZB0YwJqyCaywC1CqLXkbxkeD0qCr
         HmzAysMN3EumscMZUnL9vCMEzRAVxW8wUPAgiI1/fpMCm8BWKYa7ZS1yg5Po/1g33AhI
         gkVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7JM49rnw8/t927Go20KZOB423YW0VstYI3tZ2JyFgC8=;
        b=PS7y9hEnOhkhMEB/1sCd0G7YhEqiiT++JFfbWvIzzp5XMwSqigxLlT2nquc8eFvwyA
         nWmgEM4KcfKoGIdWUebru5c/QodPCwtdmWYxjAhYcjJmcdyKi2u3RCCvUr+optPpyPqE
         ZwnseznLtEcGiZR57DLj35Gj5zBpAdCmLn8Z3Yb3Y+q4e2CTfOJjQF6QoLIREAbBbOcd
         w+0pGbsxsXoXPv9wKB6CYeA7aEjev8RSkssNRP9q1kpq7uBzP8pQxo4+p3JlVZck4j3n
         /+KPxHLES3mdbPKn9o4Y3U23zhTqTpd8mNWLjSRuSDNnymQ08eiN5iZGQazGePaWfPFh
         3Nng==
X-Gm-Message-State: AOAM533eKKCAM4KpH+bTLYq4A11BGCWuT2Zim83qsbYE/mL0o1JCJBkh
        RAbgdUdOpeZRQUiwHkMEfpx2B7JLjEp6Ui7wAXv7csf0
X-Google-Smtp-Source: ABdhPJz2aMYSa9RsBY988WncG91lGx86vaSnJuMWDvXlp4tlDpAqJ/6FOP3c6WIC1PnBjCL8mLZ5SXizY9VqVav4lWw=
X-Received: by 2002:a7b:c5d0:0:b0:355:482a:6f44 with SMTP id
 n16-20020a7bc5d0000000b00355482a6f44mr19038682wmk.58.1653301559612; Mon, 23
 May 2022 03:25:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220523083254.32285-1-magnus.karlsson@gmail.com>
In-Reply-To: <20220523083254.32285-1-magnus.karlsson@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Mon, 23 May 2022 12:25:47 +0200
Message-ID: <CAJ+HfNghrcajNC=m_hJAtKSRX906NARB4f6LWeginirZhuyg+Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next] MAINTAINERS: add maintainer to AF_XDP
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Netdev <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        KP Singh <kpsingh@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 May 2022 at 10:33, Magnus Karlsson <magnus.karlsson@gmail.com> w=
rote:
>
> Maciej Fijalkowski has gracefully accepted to become the third
> maintainer for the AF_XDP code. Thank you Maciej!
>

Awesome, and thanks for helping out, Maciej!

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org>

> Signed-off-by: Magnus Karlsson <magnus.karlsson@gmail.com>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 359afc617b92..adc63e18e601 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -21507,6 +21507,7 @@ K:      (?:\b|_)xdp(?:\b|_)
>  XDP SOCKETS (AF_XDP)
>  M:     Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org>
>  M:     Magnus Karlsson <magnus.karlsson@intel.com>
> +M:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
>  R:     Jonathan Lemon <jonathan.lemon@gmail.com>
>  L:     netdev@vger.kernel.org
>  L:     bpf@vger.kernel.org
>
> base-commit: c272e259116973b4c2d5c5ae7b6a4181aeeb38c7
> --
> 2.34.1
>
