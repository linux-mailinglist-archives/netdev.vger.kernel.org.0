Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31882309F93
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 00:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbhAaXuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 18:50:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbhAaXt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 18:49:59 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0A6FC061573;
        Sun, 31 Jan 2021 15:49:18 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id b9so1939463ejy.12;
        Sun, 31 Jan 2021 15:49:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9u3VCjKt2Gr/6kZ0CP5Tw8UvLHGncCvwPN4iJBZKcMs=;
        b=lYDqHCRo+aURxVzwc0ShiB0TDCkw81kvah8NjpQA9dbUFCMT1Dd03epfx6q70+glXw
         2LGTb8uyczLF6ppYBD871890IcglCtlTzC0pBp1M1Lz6qi32juE0X5+Hs8IOvbpiXlso
         y9LPhycws8rhldlN0BimRCFi3A0m8v1zyOiS8w99gvDs7a+9QkAUXsCRUOIlj08yoON0
         PsKGcLhjUqffG6QPANrYzp5tVJPjXvFeMEGYT5NL6WNRuBs+zL2uZSN56PYIVX9jXJUe
         poiFa3DV2cKlQnmJgsd8wp3jQZCmG35uiRDDFgTmgVf4YUW5GrjLCCujxA4q8GH+Nsyd
         8RiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9u3VCjKt2Gr/6kZ0CP5Tw8UvLHGncCvwPN4iJBZKcMs=;
        b=hN4vepziVgLdotNyy19uTFiJRXVLN1clxx0PI3MOe1NisUR3D7fknhPtlFJqDM4alk
         LNHWAMOCdMv0P0Qw4AJwhqjPkckArI5hYv0OO+WsUDfwrgc8v6+aIzOkvIdKQG/YCDYF
         ojkOqi5AMYNjt5gMvOOCMH/Csy+w5dtzrFlea1QY1T0Zx1Bd0/kABtV/xZJ6EmZec3yM
         rdI/NObCFUqB1krEK9c0Vorx5gGRSsNNSef9C2y/n8eEq1fojq3NloPc7KztPgCCBYHF
         JuIM6+URBXRaRrkuHCaQrto4tv7ksrwt4tPFWhXW28oDPBfvH73dFKpxdDohUS0RJbrb
         8RrA==
X-Gm-Message-State: AOAM530clNzl56e2vc4CpkIcK3VAGTAw+1Zxl8P3nKGImzDjf9jBRPCR
        AujS3y8L3XeYOJr38XrPxMfx87ic7zzsOusM768=
X-Google-Smtp-Source: ABdhPJwZImVgHQQZzAZ2rZGzt+0YVdpvb6DQzxoVfp65auAlz+i9HwSCDEJs84CDYWvK0k9gbyI6q/lJ+5K62Jp12hc=
X-Received: by 2002:a17:906:3f8d:: with SMTP id b13mr14801915ejj.464.1612136957300;
 Sun, 31 Jan 2021 15:49:17 -0800 (PST)
MIME-Version: 1.0
References: <1612025501-91712-1-git-send-email-gakula@marvell.com>
In-Reply-To: <1612025501-91712-1-git-send-email-gakula@marvell.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 31 Jan 2021 18:48:41 -0500
Message-ID: <CAF=yD-J=+opJmqGwCimGm1PnncDDcf1gzTFLuqHrFjZFxSbOeA@mail.gmail.com>
Subject: Re: [net-next 00/14] Add Marvell CN10K support
To:     Geetha sowjanya <gakula@marvell.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 30, 2021 at 12:04 PM Geetha sowjanya <gakula@marvell.com> wrote:
>
> The current admin function (AF) driver and the netdev driver supports
> OcteonTx2 silicon variants. The same OcteonTx2's Resource Virtualization Unit (RVU)
> is carried forward to the next-gen silicon ie OcteonTx3, with some changes
> and feature enhancements.
>
> This patch set adds support for OcteonTx3 (CN10K) silicon and gets the drivers
> to the same level as OcteonTx2. No new OcteonTx3 specific features are added.
> Changes cover below HW level differences
> - PCIe BAR address changes wrt shared mailbox memory region
> - Receive buffer freeing to HW
> - Transmit packet's descriptor submission to HW
> - Programmable HW interface identifiers (channels)
> - Increased MTU support
> - A Serdes MAC block (RPM) configuration
>
> Geetha sowjanya (6):
>   octeontx2-af: cn10k: Update NIX/NPA context structure
>   octeontx2-af: cn10k: Update NIX and NPA context in debugfs
>   octeontx2-pf: cn10k: Initialise NIX context
>   octeontx2-pf: cn10k: Map LMTST region
>   octeontx2-pf: cn10k: Use LMTST lines for NPA/NIX operations
>
> Hariprasad Kelam (5):
>   octeontx2-af: cn10k: Add RPM MAC support
>   octeontx2-af: cn10K: Add MTU configuration
>   octeontx2-pf: cn10k: Get max mtu supported from admin function
>   octeontx2-af: cn10k: Add RPM Rx/Tx stats support
>   octeontx2-af: cn10k: MAC internal loopback support
>
> Rakesh Babu (1):
>   octeontx2-af: cn10k: Add RPM LMAC pause frame support
>
> Subbaraya Sundeep (2):
>   octeontx2-af: cn10k: Add mbox support for CN10K platform
>   octeontx2-pf: cn10k: Add mbox support for CN10K
>   octeontx2-af: cn10k: Add support for programmable channels
>
>  drivers/net/ethernet/marvell/octeontx2/af/Makefile |   2 +-
>  drivers/net/ethernet/marvell/octeontx2/af/cgx.c    | 315 ++++++++---
>  drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |  15 +-
>  .../net/ethernet/marvell/octeontx2/af/cgx_fw_if.h  |   1 +
>  drivers/net/ethernet/marvell/octeontx2/af/common.h |   5 +
>  .../ethernet/marvell/octeontx2/af/lmac_common.h    | 129 +++++
>  drivers/net/ethernet/marvell/octeontx2/af/mbox.c   |  59 +-
>  drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  70 ++-
>  drivers/net/ethernet/marvell/octeontx2/af/rpm.c    | 272 ++++++++++
>  drivers/net/ethernet/marvell/octeontx2/af/rpm.h    |  57 ++
>  drivers/net/ethernet/marvell/octeontx2/af/rvu.c    | 157 +++++-
>  drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  70 +++
>  .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    | 135 ++++-
>  .../net/ethernet/marvell/octeontx2/af/rvu_cn10k.c  | 261 +++++++++
>  .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    | 339 +++++++++++-
>  .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    | 112 +++-
>  .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |   4 +-
>  .../net/ethernet/marvell/octeontx2/af/rvu_reg.h    |  24 +
>  .../net/ethernet/marvell/octeontx2/af/rvu_struct.h | 604 ++++++---------------
>  .../net/ethernet/marvell/octeontx2/nic/Makefile    |   2 +-
>  drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c | 182 +++++++
>  drivers/net/ethernet/marvell/octeontx2/nic/cn10k.h |  17 +
>  .../ethernet/marvell/octeontx2/nic/otx2_common.c   | 144 +++--
>  .../ethernet/marvell/octeontx2/nic/otx2_common.h   | 105 +++-
>  .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  67 ++-
>  .../net/ethernet/marvell/octeontx2/nic/otx2_reg.h  |   4 +
>  .../ethernet/marvell/octeontx2/nic/otx2_struct.h   |  10 +-
>  .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |  70 ++-
>  .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.h |   8 +-
>  .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |  52 +-
>  include/linux/soc/marvell/octeontx2/asm.h          |   8 +
>  31 files changed, 2573 insertions(+), 727 deletions(-)
>  create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
>  create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rpm.c
>  create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rpm.h
>  create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
>  create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
>  create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.h
>

FYI, patchwork shows a number of checkpatch and build warnings to fix up

https://patchwork.kernel.org/project/netdevbpf/list/?series=424847
