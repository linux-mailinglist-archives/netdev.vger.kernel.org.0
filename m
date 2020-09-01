Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBA2259D91
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 19:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729461AbgIARr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 13:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728126AbgIARrZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 13:47:25 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65197C061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 10:47:24 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id o16so993553pjr.2
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 10:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IsThTySUC2LXoDe5C5uelfQGGzR8IIc/eah+C0Q213A=;
        b=XpsC/oBxOrx4l0QwY0wYpPyU12/z2BUrVW00eLZvg+PjRFJ0rr7HBN4K89mKq/ahLx
         HMSTKYYuq63/D9UyOHzdL8xYU4W7Ipz4ixkCQ3zxlJ+Eyz9+jaSQBYL1TY9/W9e6ODld
         3DRvt8IClVNVZGNx3CRVKDvo3ylRp7X3pem3Kn5udMhFpTAcrmYxkYjIz+xWfAZVSs3b
         NQvUXL7xj/KHzh7CmWScQ3//BiJKXoByLtcpna+7a4lx8M1MeyAJnpLQvLcgjoEIy16m
         jl9GQfR4//ETenO6byMmJhVyy9WBBHX6WIJ6H+eduzIMzYzyt7bU9mKW2G76f4OCSbCu
         q27g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IsThTySUC2LXoDe5C5uelfQGGzR8IIc/eah+C0Q213A=;
        b=XFqCZQxuTnELxd03CEVP+XBWlTGOxk51jLhjHOaD3GLfr97kIVO+SPqhRT+/GFsBRg
         A4m7TG/ISTTk4Rsj0gd5fEcXbFZ4Bf7Id4i8C5AQlpghbXwbkC5MaEydIg0N09LRM4Lg
         lOu4NfsnVA3VuEPM7q+aQOkv14UYFgH4uvt+bedI3L7gNtMSaKBGRfsBjrmT9ytHEq1A
         Gh4n6eO4ZgBqs2d1ITXfO9oe4ZtdfzZGKQ76yqBZhpxD6tWVxARq5CsUrm1aMKk+kben
         /Flr8wns9YW/e+PkIQuR2dnvapANqjcj7tk3fmC4FWL3ioJU0v+ZPJ7Q2hjhjgSkRZ+K
         Cq0g==
X-Gm-Message-State: AOAM532Ygr49hWBls06W7fGHgQM8b4hONOfwpS9JgRZpIHxTjpEkwiev
        LunvbcFqdIb4gFsC03ZYOingWVOZuHMuuOdDIG3gpQ==
X-Google-Smtp-Source: ABdhPJyy/gARQ06E1lQvzSFMajJ+LnC3PB8OuEJKEaCQMevyZx2d+23ztQstfofFoOhGr9dGnniONqsiWwobCSfcQRk=
X-Received: by 2002:a17:902:9a45:: with SMTP id x5mr2304256plv.208.1598982443692;
 Tue, 01 Sep 2020 10:47:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200901070834.1015754-1-natechancellor@gmail.com>
In-Reply-To: <20200901070834.1015754-1-natechancellor@gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 1 Sep 2020 10:47:12 -0700
Message-ID: <CAKwvOdnrg0-s64kPCv4+kyFrxmJPXmYm66QbjrROkTr6OVTUYA@mail.gmail.com>
Subject: Re: [PATCH] mwifiex: Remove unnecessary braces from HostCmd_SET_SEQ_NO_BSS_INFO
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Andy Lavr <andy.lavr@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 1, 2020 at 12:08 AM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> A new warning in clang points out when macro expansion might result in a
> GNU C statement expression. There is an instance of this in the mwifiex
> driver:
>
> drivers/net/wireless/marvell/mwifiex/cmdevt.c:217:34: warning: '}' and
> ')' tokens terminating statement expression appear in different macro
> expansion contexts [-Wcompound-token-split-by-macro]
>         host_cmd->seq_num = cpu_to_le16(HostCmd_SET_SEQ_NO_BSS_INFO
>                                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/wireless/marvell/mwifiex/fw.h:519:46: note: expanded from
> macro 'HostCmd_SET_SEQ_NO_BSS_INFO'
>         (((type) & 0x000f) << 12);                  }
>                                                     ^
>
> This does not appear to be a real issue. Removing the braces and
> replacing them with parentheses will fix the warning and not change the
> meaning of the code.
>
> Fixes: 5e6e3a92b9a4 ("wireless: mwifiex: initial commit for Marvell mwifiex driver")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1146
> Reported-by: Andy Lavr <andy.lavr@gmail.com>
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Wow, that's tricky. The unnecessary extra parens mix with the extra
curly braces to form a GNU C statement expression.  Thanks for the
patch.
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
>  drivers/net/wireless/marvell/mwifiex/cmdevt.c | 4 ++--
>  drivers/net/wireless/marvell/mwifiex/fw.h     | 8 ++++----
>  2 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
> index d068b9075c32..3a11342a6bde 100644
> --- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
> +++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
> @@ -322,9 +322,9 @@ static int mwifiex_dnld_sleep_confirm_cmd(struct mwifiex_adapter *adapter)
>
>         adapter->seq_num++;
>         sleep_cfm_buf->seq_num =
> -               cpu_to_le16((HostCmd_SET_SEQ_NO_BSS_INFO
> +               cpu_to_le16(HostCmd_SET_SEQ_NO_BSS_INFO
>                                         (adapter->seq_num, priv->bss_num,
> -                                        priv->bss_type)));
> +                                        priv->bss_type));
>
>         mwifiex_dbg(adapter, CMD,
>                     "cmd: DNLD_CMD: %#x, act %#x, len %d, seqno %#x\n",
> diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
> index 8047e307892e..1f02c5058aed 100644
> --- a/drivers/net/wireless/marvell/mwifiex/fw.h
> +++ b/drivers/net/wireless/marvell/mwifiex/fw.h
> @@ -513,10 +513,10 @@ enum mwifiex_channel_flags {
>
>  #define RF_ANTENNA_AUTO                 0xFFFF
>
> -#define HostCmd_SET_SEQ_NO_BSS_INFO(seq, num, type) {   \
> -       (((seq) & 0x00ff) |                             \
> -        (((num) & 0x000f) << 8)) |                     \
> -       (((type) & 0x000f) << 12);                  }
> +#define HostCmd_SET_SEQ_NO_BSS_INFO(seq, num, type) \
> +       ((((seq) & 0x00ff) |                        \
> +        (((num) & 0x000f) << 8)) |                 \
> +       (((type) & 0x000f) << 12))
>
>  #define HostCmd_GET_SEQ_NO(seq)       \
>         ((seq) & HostCmd_SEQ_NUM_MASK)
> --

-- 
Thanks,
~Nick Desaulniers
