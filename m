Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE60724FFD6
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 16:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbgHXObv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 10:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbgHXObu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 10:31:50 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52CDBC061573
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 07:31:50 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id e11so7397568ils.10
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 07:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=iqPMeMXHCwwrrVeMUoxZUiCIdtQQu6/AqnQAcMvhfeo=;
        b=IMR/Y0qQjVFDyld2iBigqJAUWf4gm1de9KtAy+8s9OkbHEgz0c1+Y46x9JeExX8NNV
         syeP8Ps3qwmxE0FaH5shVLUrHu+32j7qwGt79X53Ssi0Hb6FFgoNAi9frYGCDjPeMBSg
         MScwZ9RiBddRy3DCBtbbZDnJ91fhtXX9qGWJ8hjWQcdxRvF9F+ZYle/2H7COQrWACl5r
         vqexgQmxqifDWo5jAsJf3hTEmddrQTuCDMMjJK6sEGz8FywvLzaLx/69tG9PfHt+eX6g
         GE4psISTyBQ7ARU/2BEN+PkRN070lzrTaysCIlE1ohO32U7MiNbCSJugQ/SxLMEK2Iuo
         KSvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iqPMeMXHCwwrrVeMUoxZUiCIdtQQu6/AqnQAcMvhfeo=;
        b=nK0P4OeJL7GqIsosdESmQiVa3CJdFqtZKQsmZzUz1Pl084Wog23NWlMyi/qc4crF9g
         ec5yptbljKWWx/1+RSOI3wadsdp6YOQJS0xgntSjqSo7cG6bfFU+ATzspmQ++5oEgOkF
         M0rJPhDW/H+Zsr4FgrrhUPhGdniSq+sZTXy4BuE/ynL5Cky71gdMHiQngzmRMOUeKtNc
         6UOtuDwUfAVdROLXJZ6NfU9T7arIi7VhvEYiUVMHuKuTTSaxKyJS3T0IP5OW8s/9KfiT
         15IVUHsDP/L+mD7ZjTVM2xQys5hepU/THFcFeEifsJ1GKXX153xKQJpSSEEx5kE2bVod
         RQ/A==
X-Gm-Message-State: AOAM532hhBmXyJLF3jDmItI/w3vs2hKNlr3aT2NNqE82WiAkZpMij1hz
        jbvdrSBt9k+DRIrhck9sztSSU3wIJybHGik6Pyg=
X-Google-Smtp-Source: ABdhPJwIxsijmOT9KX1yVX9hXkUj0p+R77bPMrpt/ByfC9KYDBE9pau2uzr1XYeetrmrZ2M3Lzu6tBv1Xo4BsMg+K8w=
X-Received: by 2002:a92:9117:: with SMTP id t23mr5482261ild.177.1598279509608;
 Mon, 24 Aug 2020 07:31:49 -0700 (PDT)
MIME-Version: 1.0
References: <1598255717-32316-1-git-send-email-sundeep.lkml@gmail.com>
 <20200824.061657.2168445189551301124.davem@davemloft.net> <20200824.061737.1288546229773264212.davem@davemloft.net>
In-Reply-To: <20200824.061737.1288546229773264212.davem@davemloft.net>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Mon, 24 Aug 2020 20:01:38 +0530
Message-ID: <CALHRZuqdDAELDfpj6DA02i0NkhqyYDcr+ZWushhg4nZpCazK0w@mail.gmail.com>
Subject: Re: [PATCH v7 net-next 0/3] Add PTP support for Octeontx2
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org, sgoutham@marvell.com,
        Subbaraya Sundeep <sbhatta@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Mon, Aug 24, 2020 at 6:47 PM David Miller <davem@davemloft.net> wrote:
>
> From: David Miller <davem@davemloft.net>
> Date: Mon, 24 Aug 2020 06:16:57 -0700 (PDT)
>
> > Series applied, thank you.
>
> Actually, this doesn't even compile:
>
Our Marvell GCC10 ARM64 compiler did not complain anything about this
even with W=3D1 and my bad I overlooked the missing header file inclusion.
The same happened during V1 where the power-pc compiler caught a
similar error and ours did not.
Sorry for the trouble, I will send the next spin.

Thanks,
Sundeep

> drivers/net/ethernet/marvell/octeontx2/af/ptp.c: In function =E2=80=98get=
_clock_rate=E2=80=99:
> drivers/net/ethernet/marvell/octeontx2/af/ptp.c:60:26: error: implicit de=
claration of function =E2=80=98FIELD_GET=E2=80=99; did you mean =E2=80=98FO=
LL_GET=E2=80=99? [-Werror=3Dimplicit-function-declaration]
>    60 |  ret =3D CLOCK_BASE_RATE * FIELD_GET(RST_MUL_BITS, cfg);
>       |                          ^~~~~~~~~
>       |                          FOLL_GET
