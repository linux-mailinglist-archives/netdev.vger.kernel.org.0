Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C26E4506DB
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 12:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729079AbfFXKCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 06:02:08 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:37816 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726505AbfFXKCH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 06:02:07 -0400
Received: by mail-qt1-f193.google.com with SMTP id y57so13826079qtk.4;
        Mon, 24 Jun 2019 03:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zl3SXiizM38obE/rpMeiB8IZyhI2MegvSmWGOea2jeo=;
        b=iczv9kcHOGuOmLpziLkb/zIx8cYz3WhhR+m3XbUjHT3QEBf9eOSPvAn2SkI693zmeK
         g9xv73tyGv/WVacOqZBqnUeAhjMNeUaJf/fhLDFHbvY1RiX5+wv/EsrmQuxL+6Ec42bC
         Mvu4CN7Pk+M2eipbeULn+GZuxFIlxFflyDn7hyMUcKPwJVxJrjbneegwmmATHysnnoHl
         GjGP9ruvB/r/87a7gb2l2BZkIAWAs6q+QR+Rl3gBDm9kB6vFRWcXXsUmy5XCmyPXp4pY
         UeHqQgN63I62BrkLVvrGb+AhGEl7zFY7w+l0TqyfY9WjrrAxF+J0Auf2W/l/kxoFHJFU
         ZCUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zl3SXiizM38obE/rpMeiB8IZyhI2MegvSmWGOea2jeo=;
        b=CR4SMBGXA01uINXdqJfyvLGPeaMDPdiL9vij+1T40W0zS0cu6UVz8DZhLhZhhNYhoC
         QZlHE9/5ZbAHy3tT4jsWoFW5zGE9j25M/S6J8idDWFgajPzgM3Aci1cKKj8ZgsRudR2T
         fpk5+xQCBMJTl/CW6NqbBhaKPSlce4VqcI1EFkH+TNZEKocE3AMmYybvO4P5a+r8kgqE
         cXLsB5erSF7RZxB4y9+q8134BwyOBB6vKTblZjz40ltutr3u5M2cl4s3LsMckbbtD0bg
         MNK/xzpvzU3OtsPDTO5H4OvAo0Vw/fSRQA7doVhB71tvUanuKspAK+eHyhKNCNZNHbcO
         JZrA==
X-Gm-Message-State: APjAAAUvw1ClVlxrqkOs4w6MK/rvym4UfDrHEwuN4X6phaooqZC9XD5t
        GFLJ1Ce69ghw9Wb1+veZerAE5T+pqkv9AORUrs0=
X-Google-Smtp-Source: APXvYqxTB0yRz/E0qFnmWGAZ/eaBm2zQCIB9H2MdjWC3taZsUHE0jSAlWlIQwY/HWkxbjKlGPG99bo4K1zACr2dVpEc=
X-Received: by 2002:ac8:219d:: with SMTP id 29mr24603135qty.37.1561370526096;
 Mon, 24 Jun 2019 03:02:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190621201310.12791-1-eric@regit.org>
In-Reply-To: <20190621201310.12791-1-eric@regit.org>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Mon, 24 Jun 2019 12:01:54 +0200
Message-ID: <CAJ+HfNhwq1xHFZJHf3iVPZHsb76ay5_XeVnyTeCjTABFQoSdAQ@mail.gmail.com>
Subject: Re: [PATCH] xsk: sample kernel code is now in libbpf
To:     Eric Leblond <eric@regit.org>
Cc:     Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Jun 2019 at 22:55, Eric Leblond <eric@regit.org> wrote:
>
> Fix documentation that mention xdpsock_kern.c which has been
> replaced by code embedded in libbpf.
>
> Signed-off-by: Eric Leblond <eric@regit.org>

Thanks Eric!

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

> ---
>  Documentation/networking/af_xdp.rst | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/networking/af_xdp.rst b/Documentation/networki=
ng/af_xdp.rst
> index e14d7d40fc75..83dddc20f5d6 100644
> --- a/Documentation/networking/af_xdp.rst
> +++ b/Documentation/networking/af_xdp.rst
> @@ -220,7 +220,21 @@ Usage
>  In order to use AF_XDP sockets there are two parts needed. The
>  user-space application and the XDP program. For a complete setup and
>  usage example, please refer to the sample application. The user-space
> -side is xdpsock_user.c and the XDP side xdpsock_kern.c.
> +side is xdpsock_user.c and the XDP side is part of libbpf.
> +
> +The XDP code sample included in tools/lib/bpf/xsk.c is the following::
> +
> +   SEC("xdp_sock") int xdp_sock_prog(struct xdp_md *ctx)
> +   {
> +       int index =3D ctx->rx_queue_index;
> +
> +       // A set entry here means that the correspnding queue_id
> +       // has an active AF_XDP socket bound to it.
> +       if (bpf_map_lookup_elem(&xsks_map, &index))
> +           return bpf_redirect_map(&xsks_map, index, 0);
> +
> +       return XDP_PASS;
> +   }
>
>  Naive ring dequeue and enqueue could look like this::
>
> --
> 2.20.1
>
