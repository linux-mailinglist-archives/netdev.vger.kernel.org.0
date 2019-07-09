Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB1F63DC6
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 00:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbfGIWPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 18:15:11 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39536 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbfGIWPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 18:15:11 -0400
Received: by mail-wm1-f66.google.com with SMTP id z23so313883wma.4
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 15:15:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G/BmSFY3cUxUVhH1T9s+uztWfxfh/GPBVLWzeAmRrHU=;
        b=vyBiOzQ8miJgJtjF7oNLu2uG4a9yQgDTKRKWT8BnOsY+DK82IMQBVTpLKgT2zVUqh9
         j9madMQnGD1eDJqQPgcORP6d5ec/ey27af1TABdoSJTUY0dsKeHLukPqFrqgkafSRVRY
         TMoCcOuUcspl4kwl1Rvs0RQifPeVSzXVCUUx0ZAEuGIFgORYMedlR3B+9dW+s0l4HHlF
         uTqGhl/ghn4nK8FlRt0klXHO6yMVb9iJfvfCELUJAO2Ot3+IRCU2O8qZZS3If33DL+Yk
         OiqJkGlpB/7YF83GK/hVDzZ3viFEQYJtOFhl4dE+eQIev4ze9FvX6pGlSfKFtYCjLqdE
         hXnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G/BmSFY3cUxUVhH1T9s+uztWfxfh/GPBVLWzeAmRrHU=;
        b=aV4Lc3DtwU6707iTnc0H3yyQye305Xkd1VH5XuMYSX7FFUh7XYcS9rro4DbnOWJJUB
         20ki7fIi0nYhmpSsslQhwNfLSNrTcwZcp37gzfxe6SnKxP/a7gHwIMc9vCmxLi0/PX2m
         IOkcNnnKFRGenhVGrY7wXVIopLb5S0c1kc3j0PXQ0N6OyqNklSQZkA9sKhoLqvUYz/tH
         N9ApGglCmVBeP90tvfMDRAZ92lZQum/uiGvJPCTamb7Q/HPwRbTK9b27yDETCISpvmtE
         mGHU9YCnIAtrs2AA/C1RtkCp9MHwYAwVVn549JJsGZ+IUokt1D5IETDdgG2vP+27xtmw
         Gjhw==
X-Gm-Message-State: APjAAAWXkeINGa3OJnlTV9SbNWItOqqbcUPmT6Kc+X22x+10DBx2jDUa
        s1N7Y+b4Uv3BrsG8XiPxAWTuNlIfDyjlqEKeayfuB9m+UtpYww==
X-Google-Smtp-Source: APXvYqzCTHGocGFV2uBJLbQfqEvuahCu1uE81sAnCbHXGxO8pm9bC+88ZYe46fxq38hilzB8dZcyPT+rUNDsntxzL/g=
X-Received: by 2002:a1c:cfc7:: with SMTP id f190mr1477528wmg.85.1562710508319;
 Tue, 09 Jul 2019 15:15:08 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1562667648.git.aclaudi@redhat.com> <dfb76d0e40b0158cf6a87ae9558b256915d73f6f.1562667648.git.aclaudi@redhat.com>
In-Reply-To: <dfb76d0e40b0158cf6a87ae9558b256915d73f6f.1562667648.git.aclaudi@redhat.com>
From:   =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>
Date:   Tue, 9 Jul 2019 15:14:51 -0700
Message-ID: <CAF2d9jhiUk0Jpz54EbA+3Fyf-cMniRHZrpktu57yZ+tX+QsuEQ@mail.gmail.com>
Subject: Re: [PATCH iproute2 2/2] ip tunnel: warn when changing IPv6 tunnel
 without tunnel name
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     linux-netdev <netdev@vger.kernel.org>, stephen@networkplumber.org,
        dsahern@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 9, 2019 at 6:16 AM Andrea Claudi <aclaudi@redhat.com> wrote:
>
> Tunnel change fails if a tunnel name is not specified while using
> 'ip -6 tunnel change'. However, no warning message is printed and
> no error code is returned.
>
> $ ip -6 tunnel add ip6tnl1 mode ip6gre local fd::1 remote fd::2 tos inherit ttl 127 encaplimit none dev dummy0
> $ ip -6 tunnel change dev dummy0 local 2001:1234::1 remote 2001:1234::2
> $ ip -6 tunnel show ip6tnl1
> ip6tnl1: gre/ipv6 remote fd::2 local fd::1 dev dummy0 encaplimit none hoplimit 127 tclass inherit flowlabel 0x00000 (flowinfo 0x00000000)
>
> This commit checks if tunnel interface name is equal to an empty
> string: in this case, it prints a warning message to the user.
> It intentionally avoids to return an error to not break existing
> script setup.
>
> This is the output after this commit:
> $ ip -6 tunnel add ip6tnl1 mode ip6gre local fd::1 remote fd::2 tos inherit ttl 127 encaplimit none dev dummy0
> $ ip -6 tunnel change dev dummy0 local 2001:1234::1 remote 2001:1234::2
> Tunnel interface name not specified
> $ ip -6 tunnel show ip6tnl1
> ip6tnl1: gre/ipv6 remote fd::2 local fd::1 dev dummy0 encaplimit none hoplimit 127 tclass inherit flowlabel 0x00000 (flowinfo 0x00000000)
>
> Reviewed-by: Matteo Croce <mcroce@redhat.com>
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>

I tried your patch and the commands that I posted in my (previous) patch.

Here is the output after reverting my patch and applying your patch

<show command>
------------------------
vm0:/tmp# ./ip -6 tunnel add ip6tnl1 mode ip6gre local fd::1 remote
fd::2 tos inherit ttl 127 encaplimit none
vm0:/tmp# ./ip -6 tunnel show dev ip6tnl1
vm0:/tmp# echo $?
0

here the output is NULL and return code is 0. This is wrong and I
would expect to see the tunnel info (as displayed in 'ip -6 tunnel
show ip6tnl1')

<change command>
lpaa10:/tmp# ip -6 tunnel change dev ip6tnl1 local 2001:1234::1 remote
2001:1234::2 encaplimit none ttl 127 tos inherit allow-localremote
lpaa10:/tmp# echo $?
0
lpaa10:/tmp# ip -6 tunnel show dev ip6tnl1
lpaa10:/tmp# ip -6 tunnel show ip6tnl1
ip6tnl1: gre/ipv6 remote fd::2 local fd::1 encaplimit none hoplimit
127 tclass inherit flowlabel 0x00000 (flowinfo 0x00000000)

the change command appeared to be successful but change wasn't applied
(expecting the allow-localremote to be present on the tunnel).
---
>  ip/ip6tunnel.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/ip/ip6tunnel.c b/ip/ip6tunnel.c
> index 999408ed801b1..e3da11eb4518e 100644
> --- a/ip/ip6tunnel.c
> +++ b/ip/ip6tunnel.c
> @@ -386,6 +386,9 @@ static int do_add(int cmd, int argc, char **argv)
>         if (parse_args(argc, argv, cmd, &p) < 0)
>                 return -1;
>
> +       if (!*p.name)
> +               fprintf(stderr, "Tunnel interface name not specified\n");
> +
>         if (p.proto == IPPROTO_GRE)
>                 basedev = "ip6gre0";
>         else if (p.i_flags & VTI_ISVTI)
> --
> 2.20.1
>
