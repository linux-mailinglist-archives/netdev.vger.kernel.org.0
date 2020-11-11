Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3FE2AF7CA
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 19:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgKKSPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 13:15:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbgKKSPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 13:15:34 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA4F8C0613D1;
        Wed, 11 Nov 2020 10:15:33 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id i186so2752010ybc.11;
        Wed, 11 Nov 2020 10:15:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r5V5gOPUpECRjofMGc2gIkhBp+lIfzZwhOaSjiXXcyY=;
        b=UuZfH3Go2Fub4dfxG+k4rc9t2CBRgsiZhQZjuaVBzz4YYVVpvkGl01o762wh3AYPkh
         VmBge2n/foCtB90+s44rgFz2txea7hPYPfSUo+qXtU6FjgLULfw4SdvZUZY8FMRrTznf
         6/m12Z19ladiAt942a4GmjIjd+Xqh6ohKjXLa0q4ERES2NRre1qmjAmje/RfeDIyJelX
         u/d7n4ZDndRHGtl9NlCLguQPlv2cwOXzu1vi6qR2vX6l060+zToyLiZxE7PtV2omEK+G
         +FDSBieFrk60cqWb5rjIS1kuGBBfktsHrZBZStVlYc0DcZgrlrvh/had/+SSymAcuMMV
         23sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r5V5gOPUpECRjofMGc2gIkhBp+lIfzZwhOaSjiXXcyY=;
        b=ryoy5D/LDjw89rfJdm2qK5YjFF3/7MmHvNWqQswufR8gIHqtYINzDURR9E+pW0antN
         priC9S4tobVwT6HF0Q35EdIsmbSX6tb/DPg5qkBCKIz/Qoqk2LIvBaRzJgPAB6QV1HMM
         wEpAsoqFSQPvIIxETAH5yKlQ9F7Hp3MJPWAiVh6QBGPrxclALqtcl5uhXn8Uml5LCP+x
         JHGJO6C7i/DzwEQslfBq/041iWCYlzTZDrzHC/ONtTmigwzrBiohIBqu2rNh0FoChsgH
         tsAM8i279/dH5bi9LGy7g2IfUUcZT8E2lpta4CJEaBL0shJPoFJmFFLrcJFYs0K96auu
         p2pA==
X-Gm-Message-State: AOAM533rzkJ7Byw3NKV8xT7Sm4G8jxXH2xLYASldgNFAGR4xvP91ThnE
        hZKmwoUZkolr0VRYFGtfNaMx/DqspRMk+LQxs24=
X-Google-Smtp-Source: ABdhPJw9OJD0GlL2oVuYFpbRTeF6cZU6okS1QTgfhmnQ8y9z1QQMcaQ26ycxOlIk/15eF9i0OX/EneDbP9WmpMRajMU=
X-Received: by 2002:a25:585:: with SMTP id 127mr24244345ybf.425.1605118532756;
 Wed, 11 Nov 2020 10:15:32 -0800 (PST)
MIME-Version: 1.0
References: <20201111120121.48dd970d@canb.auug.org.au> <288207f247a2e1c6c7940f87e337d3b881c7de17.camel@redhat.com>
In-Reply-To: <288207f247a2e1c6c7940f87e337d3b881c7de17.camel@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 11 Nov 2020 10:15:21 -0800
Message-ID: <CAEf4BzZacfQWqS38AZfnP03Ai=OxYhZrX2CeHp-d1hwSw5FaNA@mail.gmail.com>
Subject: Re: linux-next: build warning after merge of the bpf-next tree
To:     Qian Cai <cai@redhat.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 11, 2020 at 6:03 AM Qian Cai <cai@redhat.com> wrote:
>
> On Wed, 2020-11-11 at 12:01 +1100, Stephen Rothwell wrote:
> > Hi all,
> >
> > After merging the bpf-next tree, today's linux-next build (powerpc
> > ppc64_defconfig) produced this warning:
> >
> > kernel/bpf/btf.c:4481:20: warning: 'btf_parse_module' defined but not used [-
> > Wunused-function]
> >  4481 | static struct btf *btf_parse_module(const char *module_name, const
> > void *data, unsigned int data_size)
> >       |                    ^~~~~~~~~~~~~~~~
> >
> > Introduced by commit
> >
> >   36e68442d1af ("bpf: Load and verify kernel module BTFs")
> >
>
> It loos like btf_parse_module() is only used when
> CONFIG_DEBUG_INFO_BTF_MODULES=y, so this should fix it.

Fixed already in [0].

  [0] https://patchwork.kernel.org/project/netdevbpf/patch/20201111040645.903494-1-andrii@kernel.org/

>
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 0f1fd2669d69..e877eeebc616 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -4478,6 +4478,7 @@ struct btf *btf_parse_vmlinux(void)
>         return ERR_PTR(err);
>  }
>
> +#ifdef CONFIG_DEBUG_INFO_BTF_MODULES
>  static struct btf *btf_parse_module(const char *module_name, const void *data, unsigned int data_size)
>  {
>         struct btf_verifier_env *env = NULL;
> @@ -4546,6 +4547,7 @@ static struct btf *btf_parse_module(const char *module_name, const void *data, u
>         }
>         return ERR_PTR(err);
>  }
> +#endif /* CONFIG_DEBUG_INFO_BTF_MODULES */
>
>  struct btf *bpf_prog_get_target_btf(const struct bpf_prog *prog)
>  {
>
