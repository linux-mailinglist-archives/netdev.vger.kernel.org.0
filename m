Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81607654C7E
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 07:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbiLWGak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 01:30:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiLWGaj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 01:30:39 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8FDA1705E
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 22:30:35 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id g14so4052825ljh.10
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 22:30:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UsteLFOe3RV7/92oM+l7nr3DWVyDJidDgLpy6nMLlvM=;
        b=jVTfbxwhV/QIcwFRStedxZuQnE74i2UWhT58tg3Twh5ECtr7JTMAcHcT0Z17sZYm2m
         c3p9f1ZzmH/M2GFsBpQHv4juWnjo6m86HX+C08wlY+Xx2arBk52LMuDQOOWfRfFEnB0B
         22pRikIcSaM8YtXVHdCWjnpi8egadCv1LFBdpTcUFsMIoFwaTbnIC1cJnv4rL1Uze1/m
         Avw4g30XmzDoddooze6l9Df7Qd8v6VKLldAggUUAZq7/1jyL+aPkjz0/C6gRx4M++NQu
         i20O2oRU/laTJjZmEJ7BL48x7Oig9H9LnVImSIHofSkkRxXAyAixmop0oMkWaTy5BZ6V
         NM7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UsteLFOe3RV7/92oM+l7nr3DWVyDJidDgLpy6nMLlvM=;
        b=TO2NWG4h4fZTNqGGOmEjwYs8ZugxJ+54dKHJF5oVdTMbaIKpnBAO1pLCY4Psczv0ez
         zbdsrAt66/bpzoiF9A/p5yGVY6eP7OnZnSztAW2/6IxjzOTYR9v7BDfbyqePqMKoMGVv
         o8Kjud9iHh4IJCthk13Hw48X0MaGZcq58m/OjvuWpopcwTzDlIyXokxfk6fYV7xIYoQX
         GYOMmp+ZQOjHOWLspD/uBTKL8R15iXtPDM3K4RavmkQu4AItb3dHEfUQqqeXGmRRwV4v
         pKVH94X3YZouqmLMJ8aL69iqt+3mulx1POXYfLlL29gWQRny0Um551YVwA/zU+b/SEzb
         EX8Q==
X-Gm-Message-State: AFqh2kolWIJpQxzXA2QbQhwcnaLWIkJ5Iv+bCitN11Eogz+BRhM2MmgW
        i+SOiAB403ybsRtxK4BvH9ydlw0l18OK3c0vNlOFzOnIveA=
X-Google-Smtp-Source: AMrXdXuz/4jtChDCaF9i+WRwjvDJCqZQ8lM3t/TJ3ap8j2ZajIFgiSMx0FtL2cFKoqaAnf7VYdDzqRxUSougWoXNy+E=
X-Received: by 2002:a05:651c:384:b0:279:ea3b:5a35 with SMTP id
 e4-20020a05651c038400b00279ea3b5a35mr357440ljp.419.1671777033797; Thu, 22 Dec
 2022 22:30:33 -0800 (PST)
MIME-Version: 1.0
References: <20221221225304.3477126-1-hauke@hauke-m.de>
In-Reply-To: <20221221225304.3477126-1-hauke@hauke-m.de>
From:   Heiko Thiery <heiko.thiery@gmail.com>
Date:   Fri, 23 Dec 2022 07:30:21 +0100
Message-ID: <CAEyMn7bK7rfXfg99RyMvyudGHd1JVP1v1r-7rzRsx4ABgP10Lg@mail.gmail.com>
Subject: Re: [PATCH iproute2] configure: Remove include <sys/stat.h>
To:     Hauke Mehrtens <hauke@hauke-m.de>
Cc:     netdev@vger.kernel.org
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

Hi Hauke,

Am Mi., 21. Dez. 2022 um 23:53 Uhr schrieb Hauke Mehrtens <hauke@hauke-m.de>:
>
> The check_name_to_handle_at() function in the configure script is
> including sys/stat.h. This include fails with glibc 2.36 like this:
> ````
> In file included from /linux-5.15.84/include/uapi/linux/stat.h:5,
>                  from /toolchain-x86_64_gcc-12.2.0_glibc/include/bits/statx.h:31,
>                  from /toolchain-x86_64_gcc-12.2.0_glibc/include/sys/stat.h:465,
>                  from config.YExfMc/name_to_handle_at_test.c:3:
> /linux-5.15.84/include/uapi/linux/types.h:10:2: warning: #warning "Attempt to use kernel headers from user space, see https://kernelnewbies.org/KernelHeaders" [-Wcpp]
>    10 | #warning "Attempt to use kernel headers from user space, see https://kernelnewbies.org/KernelHeaders"
>       |  ^~~~~~~
> In file included from /linux-5.15.84/include/uapi/linux/posix_types.h:5,
>                  from /linux-5.15.84/include/uapi/linux/types.h:14:
> /linux-5.15.84/include/uapi/linux/stddef.h:5:10: fatal error: linux/compiler_types.h: No such file or directory
>     5 | #include <linux/compiler_types.h>
>       |          ^~~~~~~~~~~~~~~~~~~~~~~~
> compilation terminated.
> ````
>
> Just removing the include works, the manpage of name_to_handle_at() says
> only fcntl.h is needed.
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Unfortunately I do not have an environment with uclibc-ng < 1.0.35 to
test it against this. But I just build the package in buildroot with a
newer version and it works with your changes.

Tested-by: Heiko Thiery <heiko.thiery@gmail.com>

thanks

> ---
>  configure | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/configure b/configure
> index c02753bb..18be5a03 100755
> --- a/configure
> +++ b/configure
> @@ -214,7 +214,6 @@ check_name_to_handle_at()
>      cat >$TMPDIR/name_to_handle_at_test.c <<EOF
>  #define _GNU_SOURCE
>  #include <sys/types.h>
> -#include <sys/stat.h>
>  #include <fcntl.h>
>  int main(int argc, char **argv)
>  {
> --
> 2.35.1
>
