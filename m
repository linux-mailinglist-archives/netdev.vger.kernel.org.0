Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0C21CBE8E
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 09:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbgEIHwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 03:52:14 -0400
Received: from conssluserg-04.nifty.com ([210.131.2.83]:47504 "EHLO
        conssluserg-04.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbgEIHwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 03:52:14 -0400
Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41]) (authenticated)
        by conssluserg-04.nifty.com with ESMTP id 0497paTk010240;
        Sat, 9 May 2020 16:51:37 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-04.nifty.com 0497paTk010240
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1589010697;
        bh=2V92LfBMVAyVrFXs5lPr1OUX4aisTenE89ByV2XZ0Yc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=jBP+CKa7kC0qTwFsBAkCFOtPN8P85iXmEoaulhtBOdNH+4Xc0U972VfXpqeBjqMDD
         Gdue98JQ/Ig2GSRdvzedNUBOzjV4BXTNHgCwIpOeu9H3RVLyDZOAoUgl9ojhAWAM7M
         ekAHcRkF7RulH2FLGdyxNkw0XXwsrL0K+gDXXCcSqIlULlnx8ng9RKbbj145N43EIf
         SznUMP1Oayx9m7ZG3fZlPfMnHxzHJXYXe1i5cPj+gi6sx6wwQtS6vnNJEW1UcI35AL
         66Txe/cAyPCmwhIcq5/JLOfq/0+G+nG3FOA03pUKxihiGZ/rCjkHAZJONxWIYidIQg
         BD56OZTMeOH7A==
X-Nifty-SrcIP: [209.85.222.41]
Received: by mail-ua1-f41.google.com with SMTP id t8so1556683uap.3;
        Sat, 09 May 2020 00:51:37 -0700 (PDT)
X-Gm-Message-State: AGi0PuaGN8xDVdjNYJTXVN+FwQUbT08mmOO2TkxRlk6/d26BAo+BD1O2
        rSy3JBOZPjDYadpgrQDyIUCKBH2jgIfFttEa3gw=
X-Google-Smtp-Source: APiQypLaIMCTVq1ANNjDJgY4g5gg4MnTRnSdctLVBtJBnr92xLBSycZrX64S5ReBIc7Y6HjAjAU8Jqir0z6QzJOv7iE=
X-Received: by 2002:ab0:4ac9:: with SMTP id t9mr5406736uae.40.1589010695831;
 Sat, 09 May 2020 00:51:35 -0700 (PDT)
MIME-Version: 1.0
References: <131136.1588999639@turing-police>
In-Reply-To: <131136.1588999639@turing-police>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Sat, 9 May 2020 16:51:00 +0900
X-Gmail-Original-Message-ID: <CAK7LNAT2xMR9fq+bJCc=1wLuEM99fPNagDc=NkFoDKNi-YCpDg@mail.gmail.com>
Message-ID: <CAK7LNAT2xMR9fq+bJCc=1wLuEM99fPNagDc=NkFoDKNi-YCpDg@mail.gmail.com>
Subject: Re: [PATCH] bpfilter: document build requirements for bpfilter_umh
To:     =?UTF-8?Q?Valdis_Kl=C4=93tnieks?= <valdis.kletnieks@vt.edu>
Cc:     Sam Ravnborg <sam@ravnborg.org>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 9, 2020 at 1:47 PM Valdis Kl=C4=93tnieks <valdis.kletnieks@vt.e=
du> wrote:
>
> It's not intuitively obvious that bpfilter_umh is a statically linked bin=
ary.
> Mention the toolchain requirement in the Kconfig help, so people
> have an easier time figuring out what's needed.
>
> Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
>

Applied to linux-kbuild.
Thanks.


> diff --git a/net/bpfilter/Kconfig b/net/bpfilter/Kconfig
> index fed9290e3b41..0ec6c7958c20 100644
> --- a/net/bpfilter/Kconfig
> +++ b/net/bpfilter/Kconfig
> @@ -13,4 +13,8 @@ config BPFILTER_UMH
>         default m
>         help
>           This builds bpfilter kernel module with embedded user mode help=
er
> +
> +         Note: your toolchain must support building static binaries, sin=
ce
> +         rootfs isn't mounted at the time when __init functions are call=
ed
> +         and do_execv won't be able to find the elf interpreter.
>  endif
>


--=20
Best Regards
Masahiro Yamada
