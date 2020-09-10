Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78CC526506F
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbgIJURv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726848AbgIJUQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 16:16:52 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9197EC061573;
        Thu, 10 Sep 2020 13:16:51 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id a3so7186429oib.4;
        Thu, 10 Sep 2020 13:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JA2F+pX+cf8Yb+/rxjLSfe19FqfGzsimaxJ7Sn8glHk=;
        b=Puleq9oJw3llEgroMR266Jcniocupl0HQrXmsWxnW43UUTp5VffHF6Fz3mzZCOB8sf
         4PD1j9SsnSSrUJTQOnT3YRnIDpf0hQ81peTImL4JlsWqP9V2rVJNXk3vErWf0Plw6i9C
         bzfOyBiZoNFJgavCV5MUpf5fkVSlL2o9x52L2J92Vx5NBQaDWKOaBsTYwAZ2OnfTrKFW
         qMtOTDRAvoLPX9yg5NlhMMnBCaE6OiqlcyX6KzWWa01XBO1obR8dG0AY3zHAXHMbJZ/q
         8ncZEgxV5M0ZLfKTYQlmFPCmOt9Gpj3qHl/ZKZ5M5HNoF2kyzNC6DnEMoFGPm/fmuonV
         DETg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JA2F+pX+cf8Yb+/rxjLSfe19FqfGzsimaxJ7Sn8glHk=;
        b=MMuOUe01mN6j7A7ve5QPmbJLLfV3pb8BUIkrwljKUXJZTiAXP//7ET/DIwKGMkRCHi
         PnhKoh5kEtX4wTVR+u29Krdf7KSu2hIfAligYy/0xDLef0PkylOu4/uHRkqPFWl9oato
         uPCDnathC4Y9auZIXOsn3JrbSrYFe4cMcbJ2pjxNBQcntpRSn94ndBOFPSgqI/T8jKyI
         cRnGEeJfXIkq09odflKsg+R50eNECnZ+mSkp9Aqh7GAIfly4bXttB+sz3iPF8cIWNR51
         syNmNKc18tPHXMRFAm8BFDZ9bEr2uyjAMp5o7bAQbyNSu8Xb/CzmHlpBZPkiP20tnmSC
         LxJA==
X-Gm-Message-State: AOAM532A5SfCRwW9ads3iUx2ttWWdE4U/2FuMbvupXYkoKvzHOA+xm5C
        lROdiu8z2lTj/jUu8f++jrNJmx8flF2XnAW/a9U=
X-Google-Smtp-Source: ABdhPJxWPUn3qHrn3wcNUUEGLzQJFnAwRfSU7Gej9E24ZTzAkIjqi+ULWfU3OSIlQq1KqwQDmyWu9XqXBk3E5939uQU=
X-Received: by 2002:aca:c758:: with SMTP id x85mr1173120oif.102.1599769010957;
 Thu, 10 Sep 2020 13:16:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200910161126.30948-1-oded.gabbay@gmail.com> <20200910130112.1f6bd9e9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200910130112.1f6bd9e9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Oded Gabbay <oded.gabbay@gmail.com>
Date:   Thu, 10 Sep 2020 23:16:22 +0300
Message-ID: <CAFCwf13SbXqjyu6JHKSTf-EqUxcBZUe4iAfggLhKXOi6DhXYcg@mail.gmail.com>
Subject: Re: [PATCH 00/15] Adding GAUDI NIC code to habanalabs driver
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 11:01 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 10 Sep 2020 19:11:11 +0300 Oded Gabbay wrote:
> >  create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_nic.c
> >  create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_nic.h
> >  create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_nic_dcbnl.c
> >  create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_nic_debugfs.c
> >  create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_nic_ethtool.c
> >  create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_phy.c
> >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qm0_masks.h
> >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qm0_regs.h
> >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qm1_regs.h
> >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qpc0_masks.h
> >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qpc0_regs.h
> >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qpc1_regs.h
> >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_rxb_regs.h
> >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_rxe0_masks.h
> >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_rxe0_regs.h
> >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_rxe1_regs.h
> >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_stat_regs.h
> >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_tmr_regs.h
> >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txe0_masks.h
> >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txe0_regs.h
> >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txe1_regs.h
> >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txs0_masks.h
> >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txs0_regs.h
> >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txs1_regs.h
> >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic1_qm0_regs.h
> >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic1_qm1_regs.h
> >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic2_qm0_regs.h
> >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic2_qm1_regs.h
> >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic3_qm0_regs.h
> >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic3_qm1_regs.h
> >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic4_qm0_regs.h
> >  create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic4_qm1_regs.h
> >  create mode 100644 drivers/misc/habanalabs/include/hw_ip/nic/nic_general.h
>
> The relevant code needs to live under drivers/net/(ethernet/).
> For one thing our automation won't trigger for drivers in random
> (/misc) part of the tree.

Can you please elaborate on how to do this with a single driver that
is already in misc ?
As I mentioned in the cover letter, we are not developing a
stand-alone NIC. We have a deep-learning accelerator with a NIC
interface.
Therefore, we don't have a separate PCI physical function for the NIC
and I can't have a second driver registering to it.

We did this design based on existing examples in the kernel
(registering to netdev), such as (just a few examples):
1. sgi-xp driver in drivers/misc/sgi-xp (see file xpnet.c)
2. bnx2fc in drivers/scsi/bnx2fc

Thanks,
Oded
