Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5D5331AD3D
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 17:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbhBMQsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 11:48:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbhBMQr4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 11:47:56 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D7C1C061574
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 08:47:16 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id g21so3430203edm.6
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 08:47:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hpzftsUk2/rMHUGTQ1xA+pUUko30FNDsdd0NDmeqjv0=;
        b=RprEYt5FY2DZ2gm7JJgWqw3TSdPHEW7SqRTxdyPwDHC7sglhy1VGf61gsCPHETQSdA
         uQ2pSXO9xC+4GvY7hZjxBlluvK3poKW/m41eTQByXLDrCknUaAF6X9y1XD3xdFsT9Km6
         2iMoqZEoaweORAG+OfAW3MUFwimAw4OOc2m3ZsZCXdIWNIHtth433+Mp2owrZn2tdc41
         Y7od9jOS6ZyZJwimoIZvmxLZ2kt8Z8yPpN9TDjKo28ncDC5e4G5e16913b4xpreRa/40
         zKbTzfwH/F7tt2ANqabCoExl486d0PY3KICREEx2o1QJngAkg4qEIyESfHMd+n9XG876
         JlJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hpzftsUk2/rMHUGTQ1xA+pUUko30FNDsdd0NDmeqjv0=;
        b=X7k764pB4wBPS9XZs/x8iJHLedNEL+VwcKjmnjLLCOYQsmhLJp8iydMOqRfoMzKTd0
         M8w2BSKXyKDwOIf9yvPGv3/qYscnQtMuIB3HLsbIv/cQ2Co4Fka2ppAf+O8y9t/9mtAo
         Hw86HY09lfw/JfSEH5R5bl8E8WN4sUxSE2WBqwpBw0B2BzwigRYQESqpYCDieGwXLC/D
         N7WQh1l+xJi8JvvwcJANZdjrR540rfWrIUNZFDTDNu6pVieEzsUlhNsU5Iq9jqf1RsoA
         kRWW0uxL39I5npVEBt6+vLt9DZIDTcCYiSydUsVFLC8MO7xfQD53WcZRCUIqym+xwXBc
         ewHA==
X-Gm-Message-State: AOAM533nouwNEW8wvFGbgGV9wXGS9z1nxOF+xU48NVFI3/KpBz+JPHeL
        1RQlN7LkcPg7SLm/MkDHCrt8rAE3fURH3BP1KZw=
X-Google-Smtp-Source: ABdhPJy8mjEiLKBO4OsGl4+wG9+UbZ1yTLExMWS2oF/vDVpUZsdOZfkQX2vzMo0pB5RvCgX6yrwznmDF/vLkCrRa2ic=
X-Received: by 2002:a50:c403:: with SMTP id v3mr8358260edf.217.1613234834578;
 Sat, 13 Feb 2021 08:47:14 -0800 (PST)
MIME-Version: 1.0
References: <20210207181324.11429-1-smalin@marvell.com> <20210212180639.GA511742@localhost>
In-Reply-To: <20210212180639.GA511742@localhost>
From:   Shai Malin <malin1024@gmail.com>
Date:   Sat, 13 Feb 2021 18:47:02 +0200
Message-ID: <CAKKgK4yof3MsvUFAB-yjSBKtf-UhrTGb7vghOUv=ttYG29v1OQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3 00/11] NVMeTCP Offload ULP and QEDN Device Driver
To:     Chris Leech <cleech@redhat.com>
Cc:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, sagi@grimberg.me,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>, nassa@marvell.com,
        Douglas.Farley@dell.com, Erik.Smith@dell.com, kuba@kernel.org,
        pkushwaha@marvell.com, davem@davemloft.net
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 12 Feb 2021 at 20:06, Chris Leech wrote:
>
> On Sun, Feb 07, 2021 at 08:13:13PM +0200, Shai Malin wrote:
> > Queue Initialization:
> > =====================
> > The nvme-tcp-offload ULP module shall register with the existing
> > nvmf_transport_ops (.name = "tcp_offload"), nvme_ctrl_ops and blk_mq_ops.
> > The nvme-tcp-offload vendor driver shall register to nvme-tcp-offload ULP
> > with the following ops:
> >  - claim_dev() - in order to resolve the route to the target according to
> >                  the net_dev.
> >  - create_queue() - in order to create offloaded nvme-tcp queue.
> >
> > The nvme-tcp-offload ULP module shall manage all the controller level
> > functionalities, call claim_dev and based on the return values shall call
> > the relevant module create_queue in order to create the admin queue and
> > the IO queues.
>
> Hi Shai,
>
> How well does this claim_dev approach work with multipathing?  Is it
> expected that providing HOST_TRADDR is sufficient control over which
> offload device will be used with multiple valid paths to the controller?
>
> - Chris
>

Hi Chris,

The nvme-tcp-offload multipath behaves the same as the non-offloaded
nvme-tcp. The HOST_TRADDR is sufficient to control which offload device
will be used with multiple valid paths.

- Shai
