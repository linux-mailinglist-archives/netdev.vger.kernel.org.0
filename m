Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC0DF8691E
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 20:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390268AbfHHSyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 14:54:24 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:44196 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390260AbfHHSyY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 14:54:24 -0400
Received: by mail-qt1-f194.google.com with SMTP id 44so62229814qtg.11;
        Thu, 08 Aug 2019 11:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ePbQLgmew1flkn1x6c05tWaSE/mhwZOcWAVFKg9qmww=;
        b=u36AN4gd0RPtfKMPqbdfTmgOOqlgGK83pLl7pOIriFBbEF+gXdR5GUNmWqK4k4nIr4
         VYfuNLVUE1MqEzk1APsfudag3GHz67C7kjqcP2QZW4GJNpXXgnULiacX620KjJvMNBVs
         J3ZoaAdSeBzOX3vN2Uc+0P0GtjJ86Fn1yCrugPorMPVqjgMvlrTJs/WiO9kFMH9t8T1H
         oiJ3c7YfZviPPIU+DXtOvSKesEInJae0SpXRpsmHkSLPj7WDwelC2P7hnZAJx/QcabPP
         VG8NKa1sbkpNg6jAoZB/pjqTXssHAb9zbyaFMW4BpXCtcQP39jrBDo2TfyS/t6q9Em2S
         bWDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ePbQLgmew1flkn1x6c05tWaSE/mhwZOcWAVFKg9qmww=;
        b=Foq1JjB9rZ5FfUnZxr2Y/AJsFTEajmSBoZpZZtZteCkkWTc7GfdqxELyAKJP8CGjnH
         2D2LHub4F9DUHJq9Logt2Ao+NsGRmsiRWfwoWC4aHcSSlt0jM7+9vPSmtA22Fas3Q3h7
         3bW/6A30N4X095jBwao6ilkszvgZiZHOsX9A8QmRVsfyCqqvAkZMPAJ0eNzdighP8T7A
         YGf95vkeih92hRn3Ir3LQPpwUOYqQ24c7FXRya72iz1dIQyd5/HxuUrLBAsx9mAOdR5o
         LChlIxF77J8cfQ7Jx4TLgHxJud/lHtzbJ0dcIu7ZyjWuNIV3LMSdwzELp2/PF8i1dgbU
         BRNQ==
X-Gm-Message-State: APjAAAUU39GMbGc+ZLe8g5gPLtBI+CL/i+XSYDQqIAOsXUq45akAgtBE
        0Td1nh2XYbzKKO1BvYdVetHbGZs081zTE27YgFpa0Gv/YGw0SA==
X-Google-Smtp-Source: APXvYqyNavIzM6XtGEHHaSyhsEsgyo1N/M9sigv9bW9ZxDyDb9tUqKSe1cjB4iSoYDbcoyyEzy5xtO5rEpUIz2KZvdo=
X-Received: by 2002:ad4:56a2:: with SMTP id bd2mr4199859qvb.162.1565290463360;
 Thu, 08 Aug 2019 11:54:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190807001923.19483-1-jakub.kicinski@netronome.com> <20190807001923.19483-3-jakub.kicinski@netronome.com>
In-Reply-To: <20190807001923.19483-3-jakub.kicinski@netronome.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 8 Aug 2019 11:54:12 -0700
Message-ID: <CAEf4BzaCGu8CYc-bztAH4Aqb812jbpr2JRD0T_Wa-9UbS_sAGg@mail.gmail.com>
Subject: Re: [PATCH bpf 2/2] tools: bpftool: add error message on pin failure
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        oss-drivers@netronome.com, Andy Lutomirski <luto@kernel.org>,
        Quentin Monnet <quentin.monnet@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 6, 2019 at 5:21 PM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> No error message is currently printed if the pin syscall
> itself fails. It got lost in the loadall refactoring.
>
> Fixes: 77380998d91d ("bpftool: add loadall command")
> Reported-by: Andy Lutomirski <luto@kernel.org>
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

> CC: luto@kernel.org, sdf@google.com
>
>  tools/bpf/bpftool/common.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
> index c52a6ffb8949..6a71324be628 100644
> --- a/tools/bpf/bpftool/common.c
> +++ b/tools/bpf/bpftool/common.c
> @@ -204,7 +204,11 @@ int do_pin_fd(int fd, const char *name)
>         if (err)
>                 return err;
>
> -       return bpf_obj_pin(fd, name);
> +       err = bpf_obj_pin(fd, name);
> +       if (err)
> +               p_err("can't pin the object (%s): %s", name, strerror(errno));
> +
> +       return err;
>  }
>
>  int do_pin_any(int argc, char **argv, int (*get_fd_by_id)(__u32))
> --
> 2.21.0
>
