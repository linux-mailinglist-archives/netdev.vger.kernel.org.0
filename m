Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E379D63A31
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 19:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbfGIRbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 13:31:40 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38610 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbfGIRbj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 13:31:39 -0400
Received: by mail-wm1-f67.google.com with SMTP id s15so4113654wmj.3
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 10:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qX+bZY3caijWFF7Mk1QvxZ83E/adHJPEa68JLLMzZNg=;
        b=mzt9WvaQIopawsrRtQJzqFQW2OB44KKkvcA1Myg2r5LIrkPnkK/rLLCXd+TEVX1+YJ
         OG5C0/67EIvF2mt5SVfrrPlVUc5JPxekc2G94KZ6jCfoooUHpPGrGNtD71nJpgTnpkPS
         ldT7E6N/THEbW+esPmp2AlHnqjaFSRYRkjfEDkoQXJdwlNi0k/+YxCgGQQRUCfMr04xQ
         qqBL4IrxUUS6ff749Gic2HKwlxWlMz5xHh2c1o9WzxoIt8nIJZsQcAyDNSHo6TI83i20
         YLa71umOwoFgcWua4IMlRtaiZtouzjSvsnoOqwLOGivOMAJnupZZXyW4rEwiv+hTDT1l
         0sRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qX+bZY3caijWFF7Mk1QvxZ83E/adHJPEa68JLLMzZNg=;
        b=M5jGJIIqhuZtA4fndDg7LBetHA2+HmjP/2V5wnWRKb2Zz61yWbjsDotidquhm0OoEC
         nuaGkQ9NeR5Kud25HyljaCsl4kQHS3sMtAckEUM+LvK3UXaB9wN+QsZ34zI+Tly2ENcV
         k2YdAUAnrk7NBtJrxQ+uFmxC4AqciMk/DrUC9Fm2461sRp4ukhYVyXHOnPdcn0S8I6dl
         2xEPWVaboAcQx59vrdazavjkg5gPYN+cQRKal010DzAReTTLCwjcqhoNNRSq8zmsmV5u
         Vl2gHkkTiTY55FFrSu/gnKtC0hm//dRdpPI/B6tMBEax1weOULTntbIzo6Hmbps7FVD8
         9RPQ==
X-Gm-Message-State: APjAAAXKLSLn2xuLf2IZlNIrJFhHlMRx1+yJUtGxq7J+KnuPmrGFBIoY
        LMEBsxqE1w3bJyHu/fpCDA6LUJ1f6+FAoPtLivaXng==
X-Google-Smtp-Source: APXvYqyyOH4A0DQFkMm5LZO/76q7oOGshT1MB7ATLp+pxl7+MCrAwI/FFzRgZSX1rJtZtjV0qCoFvhhi/KBbxmOt20w=
X-Received: by 2002:a1c:d107:: with SMTP id i7mr957025wmg.92.1562693497299;
 Tue, 09 Jul 2019 10:31:37 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1562667648.git.aclaudi@redhat.com> <5caaac096e5bbbf88ad3aedcc50ff2451f94105c.1562667648.git.aclaudi@redhat.com>
In-Reply-To: <5caaac096e5bbbf88ad3aedcc50ff2451f94105c.1562667648.git.aclaudi@redhat.com>
From:   =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>
Date:   Tue, 9 Jul 2019 10:31:20 -0700
Message-ID: <CAF2d9jiGnR-A-A-mEv-84Mu6xfwFNvWt5jp+iiBhMGNPMkaDZg@mail.gmail.com>
Subject: Re: [PATCH iproute2 1/2] Revert "ip6tunnel: fix 'ip -6 {show|change}
 dev <name>' cmds"
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
> This reverts commit ba126dcad20e6d0e472586541d78bdd1ac4f1123.
> It breaks tunnel creation when using 'dev' parameter:
>
> $ ip link add type dummy
> $ ip -6 tunnel add ip6tnl1 mode ip6ip6 remote 2001:db8:ffff:100::2 local 2001:db8:ffff:100::1 hoplimit 1 tclass 0x0 dev dummy0
> add tunnel "ip6tnl0" failed: File exists
>
> dev parameter must be used to specify the device to which
> the tunnel is binded, and not the tunnel itself.
>
> Reported-by: Jianwen Ji <jiji@redhat.com>
> Reviewed-by: Matteo Croce <mcroce@redhat.com>
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> ---
>  ip/ip6tunnel.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/ip/ip6tunnel.c b/ip/ip6tunnel.c
> index 56fd3466ed062..999408ed801b1 100644
> --- a/ip/ip6tunnel.c
> +++ b/ip/ip6tunnel.c
> @@ -298,8 +298,6 @@ static int parse_args(int argc, char **argv, int cmd, struct ip6_tnl_parm2 *p)
>                 p->link = ll_name_to_index(medium);
>                 if (!p->link)
>                         return nodev(medium);
> -               else
> -                       strlcpy(p->name, medium, sizeof(p->name));
NACK

I see that ba126dcad20e6d0e472586541d78bdd1ac4f1123 has broke
something but that doesn't mean revert of the original fix is correct
way of fixing it. The original fix is fixing the show and change
command. Shouldn't you try fixing the add command so that all (show,
change, and add) work correctly?

>         }
>         return 0;
>  }
> --
> 2.20.1
>
