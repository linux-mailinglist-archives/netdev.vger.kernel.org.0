Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9E53F5131
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 21:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231788AbhHWTXp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 15:23:45 -0400
Received: from mail-ej1-f48.google.com ([209.85.218.48]:33578 "EHLO
        mail-ej1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbhHWTXo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 15:23:44 -0400
Received: by mail-ej1-f48.google.com with SMTP id x11so39309460ejv.0;
        Mon, 23 Aug 2021 12:23:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LAkUj8eGXa16q3RpMBF+nglw7ejQzo6su3CYaWTKq58=;
        b=ZSNW2G2r0RR4l6HEKebjsOjqdfGmMgmyTSpqiFBURu8QSDXMXlSKp77HAs20kyFdZu
         yqfEqapSxbBmK0aEVMGabAdVW3Ietem5o64rYV4VcrF1PJNS3pWJU8P/OqHeQHlszeLg
         VKc8txe/JvMrwFeOeC9GV28k+2smaYmuHYf5D+nld0Op5HKnZrIx8Y4CRlc8HAuR8Kbb
         TVtP8wq8eFDEitw2dH3A4fu4KBTnu1LecMH9gZ9/JVwa6AQrxaCslplJtiLTPPRHRxJt
         2Gzyts2C6gC/5xB5fzQYGZwITzxRcJO5C9FupVNTUSu7Hre5nPnEs439W6bpoIpxj1rh
         vAPg==
X-Gm-Message-State: AOAM532K6RlJqeEfoDaY6G8lh1OpUAOgKZDp99zY3kBeRG/VPJ6mjZA/
        SoKm9kjO70ytJGuYylaVOlAhPmTCrBisQg==
X-Google-Smtp-Source: ABdhPJyzSArzCICLbcX4VB7Y0hnhLD5F0eF5GFBjkoXdGcXkcQcW1A+u9XnXplC/Jq8Qpv2AqQNC2g==
X-Received: by 2002:a17:906:9bdc:: with SMTP id de28mr36750594ejc.154.1629746580113;
        Mon, 23 Aug 2021 12:23:00 -0700 (PDT)
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com. [209.85.128.50])
        by smtp.gmail.com with ESMTPSA id o26sm2889828eje.24.2021.08.23.12.22.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Aug 2021 12:22:59 -0700 (PDT)
Received: by mail-wm1-f50.google.com with SMTP id u1so11257821wmm.0;
        Mon, 23 Aug 2021 12:22:59 -0700 (PDT)
X-Received: by 2002:a7b:c318:: with SMTP id k24mr157053wmj.144.1629746579518;
 Mon, 23 Aug 2021 12:22:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210816000542.18711-1-rdunlap@infradead.org>
In-Reply-To: <20210816000542.18711-1-rdunlap@infradead.org>
From:   Marc Dionne <marc.dionne@auristor.com>
Date:   Mon, 23 Aug 2021 16:22:48 -0300
X-Gmail-Original-Message-ID: <CAB9dFdvoo_JtbqW6s4+DKMraWxMX-Qivdt+nm7_w2Q-dq3WTaQ@mail.gmail.com>
Message-ID: <CAB9dFdvoo_JtbqW6s4+DKMraWxMX-Qivdt+nm7_w2Q-dq3WTaQ@mail.gmail.com>
Subject: Re: [PATCH] net: RxRPC: make dependent Kconfig symbols be shown indented
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        linux-afs@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 15, 2021 at 9:06 PM Randy Dunlap <rdunlap@infradead.org> wrote:
>
> Make all dependent RxRPC kconfig entries be dependent on AF_RXRPC
> so that they are presented (indented) after AF_RXRPC instead
> of being presented at the same level on indentation.
>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Marc Dionne <marc.dionne@auristor.com>
> Cc: linux-afs@lists.infradead.org
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org
> ---
>  net/rxrpc/Kconfig |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> --- linux-next-20210813.orig/net/rxrpc/Kconfig
> +++ linux-next-20210813/net/rxrpc/Kconfig
> @@ -21,6 +21,8 @@ config AF_RXRPC
>
>           See Documentation/networking/rxrpc.rst.
>
> +if AF_RXRPC
> +
>  config AF_RXRPC_IPV6
>         bool "IPv6 support for RxRPC"
>         depends on (IPV6 = m && AF_RXRPC = m) || (IPV6 = y && AF_RXRPC)
> @@ -30,7 +32,6 @@ config AF_RXRPC_IPV6
>
>  config AF_RXRPC_INJECT_LOSS
>         bool "Inject packet loss into RxRPC packet stream"
> -       depends on AF_RXRPC
>         help
>           Say Y here to inject packet loss by discarding some received and some
>           transmitted packets.
> @@ -38,7 +39,6 @@ config AF_RXRPC_INJECT_LOSS
>
>  config AF_RXRPC_DEBUG
>         bool "RxRPC dynamic debugging"
> -       depends on AF_RXRPC
>         help
>           Say Y here to make runtime controllable debugging messages appear.
>
> @@ -47,7 +47,6 @@ config AF_RXRPC_DEBUG
>
>  config RXKAD
>         bool "RxRPC Kerberos security"
> -       depends on AF_RXRPC
>         select CRYPTO
>         select CRYPTO_MANAGER
>         select CRYPTO_SKCIPHER
> @@ -58,3 +57,5 @@ config RXKAD
>           through the use of the key retention service.
>
>           See Documentation/networking/rxrpc.rst.
> +
> +endif
>
> _______________________________________________
> linux-afs mailing list
> http://lists.infradead.org/mailman/listinfo/linux-afs


Reviewed-by: Marc Dionne <marc.dionne@auristor.com>

Marc
