Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA5322CD9F8
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 16:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbgLCPQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 10:16:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbgLCPQD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 10:16:03 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C140CC061A4E;
        Thu,  3 Dec 2020 07:15:17 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id o1so2226600wrx.7;
        Thu, 03 Dec 2020 07:15:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fFaCriGSYx/jNXnz0XbvUiNq6DB0Sw/tCXGOND8c0og=;
        b=SST5AJWfppZNIQZ1c71S4pRZRCgOpDQjBFI7O004IV1EmRNpg7MNTNTChLeSluy6b8
         fr8gFfYFH1zQA+FY3C2DufLFhZWzCtsl+5fnNjqBd17+afqCq19pyYzSFO41g5c0Tvzh
         679xIVJ88m/lyucAI/F6Pbmc5zqI3vTbP/ci1l459V1GnhILstgOizY3A4qySqeRJk9O
         DiRlr89YzB49dNS9hbUqt5w3iUnJBsZRI4sFMBdm/iltObUWqy70gcmjjSnrBk1BiFa0
         yTzGGehtkmFCOSm3Rwk06NYVuOo6oLdgpgAblJ3xOsMIKF9BKya7x9Ykhqv7OV/V0F3U
         H29Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fFaCriGSYx/jNXnz0XbvUiNq6DB0Sw/tCXGOND8c0og=;
        b=uJiJ7la5WWGDB/7VRitZ4FFEpoFlWifh2foelckr4sLqDpTQVuJ9fbceMoRiN5U1e/
         ZEfuU3hjsKX19mwNHu3bjuH1y/PO4BakTX0fBWWXVaXTJzU9AiB46eVUcOg/pKHITb0T
         Ry2LJfTNad0xyQhc3EtsQHHfjPB0odJ8ovEs4stD+KnM6YpgnzwfCSF6Yj/wDUGuPrJF
         ez44W9TvWsnvEa/86wJNtiM6NnUiuTiad/a6W9vzRfmNVtBCVcM+fQZ+sgXGS5FVtTKr
         wi5RjpLzS8klXLK6YdmXN0j64VQAemHlPZV4nBfngpAJItOVmj45t/snA2Tqh34pso5R
         BiSQ==
X-Gm-Message-State: AOAM530Dtad5NKZQ9VdzK9YTQ1DI9zDTXYlqeDr7NuCerPPQReVYdAC5
        wOFERiu+/nEbv7XHTZsUIVs1w1eedIrjoyQcnO0=
X-Google-Smtp-Source: ABdhPJxFa6CoW2qkpeaUpLguTFOPv/6+OfkPZg79klK1iRQ7vQVjZnha+cFTtwHNmnpoGelHzHOcchdhsRgIiCveiJo=
X-Received: by 2002:adf:ed04:: with SMTP id a4mr4273079wro.172.1607008515458;
 Thu, 03 Dec 2020 07:15:15 -0800 (PST)
MIME-Version: 1.0
References: <20201203114452.1060017-1-colin.king@canonical.com>
In-Reply-To: <20201203114452.1060017-1-colin.king@canonical.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Thu, 3 Dec 2020 16:15:02 +0100
Message-ID: <CAJ+HfNiFcyqGYCNigs22k4=g_GQ_hJiZ=eE7f+hguOyN2ScdsA@mail.gmail.com>
Subject: Re: [PATCH][next] samples/bpf: Fix spelling mistake "recieving" -> "receiving"
To:     Colin King <colin.king@canonical.com>
Cc:     Mariusz Dudek <mariuszx.dudek@intel.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Dec 2020 at 12:46, Colin King <colin.king@canonical.com> wrote:
>
> From: Colin Ian King <colin.king@canonical.com>
>
> There is a spelling mistake in an error message. Fix it.
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

> ---
>  samples/bpf/xdpsock_user.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
> index 0fee7f3aef3c..9553c7c47fc4 100644
> --- a/samples/bpf/xdpsock_user.c
> +++ b/samples/bpf/xdpsock_user.c
> @@ -1570,7 +1570,7 @@ recv_xsks_map_fd(int *xsks_map_fd)
>
>         err =3D recv_xsks_map_fd_from_ctrl_node(sock, xsks_map_fd);
>         if (err) {
> -               fprintf(stderr, "Error %d recieving fd\n", err);
> +               fprintf(stderr, "Error %d receiving fd\n", err);
>                 return err;
>         }
>         return 0;
> --
> 2.29.2
>
