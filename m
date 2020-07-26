Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 080BB22DB98
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 05:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgGZDzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 23:55:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbgGZDzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 23:55:15 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D41C0619D2;
        Sat, 25 Jul 2020 20:55:15 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id r12so10372520ilh.4;
        Sat, 25 Jul 2020 20:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f4ct+tMXIuuwOJq/PtkUJ0Tx4NfXOW0LK1hJfV6ApAs=;
        b=VZkbwqP5gxbMgSyvwFy6lcN6Ptj262fahi0hY5oBAs/fyMEAFIyLKi6g2kkdquHwyQ
         8QT4S8ZmJBb2dCFKFdQq78vawYrdKSxGdeZSjBoPqIISXJBSjrCgOs+PE3TWDmcGl1LP
         G40OdmJJCQdZkvwZ9WZ5EtnYIOo+ut6yLtiYn9n2WgT4aRsQu0KBx4+bkAjQT5+ttJtV
         Nt2Ue5woxbDlEWbxkQcrcAqncRgcGd9EF8q+66p2eegvj4/lR2qrmx5XFrwq2gjAhXzz
         pscSfUtpM5hyXIeRzVmwJM9gIGjzmKN3lIZwdHY9qtX2EOE3Q3wlpnBNVcW0sxSLAi5Q
         bK3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f4ct+tMXIuuwOJq/PtkUJ0Tx4NfXOW0LK1hJfV6ApAs=;
        b=aPrHae67J2Hmgco37GDQoHb6VugZ2IGdKRO3BaiGPyY+lgNamwvptaxJF7gYtjLaM/
         5OkDne0YQWZNKqPC6b4vDnH/4Bg5rcV5RjXjKjoa0IYZJ9tNxNWU+dbc3XoPHXtp2umV
         Fz4XSyP7ktzXgXJZH/wrVk08lKJEFkJ3TuA/0guJhX7P8aWkzVLSoUOjp06F3d29mIx6
         caeD9rUZnVzNKeuc5HT1cjeA/hdpdFERGocKQbDfGm4uDRQyg2/X4Z8MqsHIc9XxDJAG
         jkXekFFv6qt2+RAg+py9F/Lb3GbMYKWGKEmT5jKOUPOz7Nf9JnB3eMa2iJLvagiRDTzS
         K5hQ==
X-Gm-Message-State: AOAM5320D4YnXpGt50qlTjSLU7H3FYXgbgPelRhOduo4i58VVtqK32Gt
        iK0+N/IfpWQqsy44TUWY/PfMxaibho/GCmZiGUo=
X-Google-Smtp-Source: ABdhPJyLDUR8T4sn0OFASwP3saGG0kFACx0iavj345naF7n52+Gq+PgKc486ClDeIAc0agVrz9A6+UKYhubAT7K38/w=
X-Received: by 2002:a05:6e02:8a8:: with SMTP id a8mr18108013ilt.52.1595735714837;
 Sat, 25 Jul 2020 20:55:14 -0700 (PDT)
MIME-Version: 1.0
References: <1595596084-29809-1-git-send-email-schalla@marvell.com>
In-Reply-To: <1595596084-29809-1-git-send-email-schalla@marvell.com>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Sun, 26 Jul 2020 09:25:03 +0530
Message-ID: <CALHRZuonCvFSf8ANJvTdVfRVdTEH4Mzv-x0xdOfF7AGgH+vKyQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] Add Support for Marvell OcteonTX2 Cryptographic
To:     Srujana Challa <schalla@marvell.com>
Cc:     herbert@gondor.apana.org.au, David Miller <davem@davemloft.net>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        schandran@marvell.com, pathreya@marvell.com, sgoutham@marvell.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Srujana,

On Fri, Jul 24, 2020 at 6:39 PM Srujana Challa <schalla@marvell.com> wrote:
>
> The following series adds support for Marvell Cryptographic Acceleration
> Unit(CPT) on OcteonTX2 CN96XX SoC.
> This series is tested with CRYPTO_EXTRA_TESTS enabled and
> CRYPTO_DISABLE_TESTS disabled.
>
> Srujana Challa (4):
>   octeontx2-af: add support to manage the CPT unit
>   drivers: crypto: add support for OCTEONTX2 CPT engine
>   drivers: crypto: add the Virtual Function driver for OcteonTX2 CPT
>   crypto: marvell: enable OcteonTX2 cpt options for build
>
>  drivers/crypto/marvell/Kconfig                     |   17 +
>  drivers/crypto/marvell/Makefile                    |    1 +
>  drivers/crypto/marvell/octeontx2/Makefile          |   14 +
>  drivers/crypto/marvell/octeontx2/otx2_cpt_common.h |   53 +
>  .../crypto/marvell/octeontx2/otx2_cpt_hw_types.h   |  572 ++++++
>  .../marvell/octeontx2/otx2_cpt_mbox_common.c       |  286 +++
>  .../marvell/octeontx2/otx2_cpt_mbox_common.h       |  100 +
>  drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h |  202 ++
>  drivers/crypto/marvell/octeontx2/otx2_cptlf.h      |  370 ++++
>  drivers/crypto/marvell/octeontx2/otx2_cptlf_main.c |  964 +++++++++
>  drivers/crypto/marvell/octeontx2/otx2_cptpf.h      |   79 +
>  drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c |  599 ++++++
>  drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c |  694 +++++++
>  .../crypto/marvell/octeontx2/otx2_cptpf_ucode.c    | 2173 ++++++++++++++++++++
>  .../crypto/marvell/octeontx2/otx2_cptpf_ucode.h    |  180 ++
>  drivers/crypto/marvell/octeontx2/otx2_cptvf.h      |   29 +
>  drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c | 1708 +++++++++++++++
>  drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.h |  172 ++
>  drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c |  229 +++
>  drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c |  189 ++
>  .../crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c   |  543 +++++
>  drivers/net/ethernet/marvell/octeontx2/af/Makefile |    2 +-
>  drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |   85 +
>  drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |    2 +-
>  drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |    7 +
>  .../net/ethernet/marvell/octeontx2/af/rvu_cpt.c    |  343 +++
>  .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |  342 +++
>  .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |   76 +
>  .../net/ethernet/marvell/octeontx2/af/rvu_reg.h    |   65 +-
>  29 files changed, 10088 insertions(+), 8 deletions(-)
>  create mode 100644 drivers/crypto/marvell/octeontx2/Makefile
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cpt_hw_types.h
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.c
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.h
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptlf.h
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptlf_main.c
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf.h
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf.h
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.h
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c
>  create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c

Please include everyone in
./scripts/get_maintainer.pl drivers/net/ethernet/marvell/octeontx2/
or atleast
./scripts/get_maintainer.pl drivers/net/ethernet/marvell/octeontx2/af/

Thanks,
Sundeep
>
> --
> 1.9.1
>
