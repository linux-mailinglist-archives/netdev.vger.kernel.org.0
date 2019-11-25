Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C785108642
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 02:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbfKYBTw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 20:19:52 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:46237 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727072AbfKYBTw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 20:19:52 -0500
Received: by mail-lf1-f66.google.com with SMTP id a17so9587929lfi.13;
        Sun, 24 Nov 2019 17:19:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1BRJcfc8MhDWuAE2x1zzn5pGwEuyWHPYC+TlBnSdWu8=;
        b=Pl9hZ1re8B3/Wdruv0SzZo9mYS1hFes/DGGN3B0ifaamOEG2f9/38mUgEUmkCSvxIe
         zF1t7Z2rHyILc/plvUwfQJE/wxBt8fdmAayQcu0X3bBYtPynwLumCnzTQg5thefPNs+H
         DOCeLIuvk9rKKs74h9IINFihhOtjPTiUeJtF5j0M5cNace75T+x7WEfPT92Q/SoV+aWL
         Il9yeMJ2PKzNOFkaoEOtE/XGPROq6yhgpjZRJrB1IaoHx8+FJBzndrEEEGpTpGeiNMGC
         vE7OncBKBgykWCith+n2COIbGCLt1Zq1yQHYFPJmysh8HCQcmW35gGk15jpJatAKvIUy
         vGxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1BRJcfc8MhDWuAE2x1zzn5pGwEuyWHPYC+TlBnSdWu8=;
        b=KHteQgnsxwXw6rKqvWJ+frDNYfmAVf6QyR/YzswRprCZfZemTak1iXlh8GnWmsZPG6
         xz1jmp6Qq5s9K/hNMWBH/vfm0rHtUTFx8KReYBoICinWjEemZt8f2+x/unvyILg0ACUM
         NGJg6hLpBQh/xrqhr34AxTZH/073m8jnh72EWNMzNz9aKFmucH6eS9AWIDNWduqNhHzk
         gy+F/JS9zoVPqWvTqdYGltXUKkAH6T1Dg189GXidmVli2vuMmSAzz/uBStWm81ITjf6y
         7Y6nLfsSST6vp99c8jZBHaBAgkkILuVHX0AsgVF5giMQVaEhCdgfD0YwfqbLaqWi2Aae
         WbqA==
X-Gm-Message-State: APjAAAWSWU/CqWEz2utWezoq2xs25sv2Ea8mKX+6zKuVMif0SbdLQe3c
        sOvJQjpYcrjQPKP1FrD3QtGapbsmQaEosnetcuKe0A==
X-Google-Smtp-Source: APXvYqxTxbIQbmPevyKUlXwPvj7kdUzCdNJBzuliq2Hjqoo+D62dAN/9MlCALq8199nyoHkDmkHUBcd/EZhCAR2dVRs=
X-Received: by 2002:a19:c384:: with SMTP id t126mr18842484lff.100.1574644789373;
 Sun, 24 Nov 2019 17:19:49 -0800 (PST)
MIME-Version: 1.0
References: <20191125105843.2bdea309@canb.auug.org.au>
In-Reply-To: <20191125105843.2bdea309@canb.auug.org.au>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 24 Nov 2019 17:19:38 -0800
Message-ID: <CAADnVQJz=d-vqA4d+g-Mf=J+GVt4SDYxU_eo9E_+bN1WaroyJg@mail.gmail.com>
Subject: Re: linux-next: manual merge of the bpf-next tree with the net-next tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 24, 2019 at 3:58 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> Today's linux-next merge of the bpf-next tree got a conflict in:
>
>   kernel/bpf/syscall.c
>
> between commit:
>
>   84bb46cd6228 ("Revert "bpf: Emit audit messages upon successful prog load and unload"")
>
> from the net-next tree and commit:
>
>   8793e6b23b1e ("bpf: Move bpf_free_used_maps into sleepable section")
>
> from the bpf-next tree.

argh. I wonder whether individual reverts would have
helped git to avoid such conflict.
Anyhow I've rebased bpf-next on top of net-next to avoid this mess.
There was only one Fixes tag that I adjusted manually.
