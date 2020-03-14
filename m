Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBA521858CE
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 03:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbgCOCYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 22:24:11 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:36282 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727727AbgCOCYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Mar 2020 22:24:11 -0400
Received: by mail-lj1-f193.google.com with SMTP id g12so14804704ljj.3
        for <netdev@vger.kernel.org>; Sat, 14 Mar 2020 19:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aAbKSNMDcMUO6uRsWJmHOq81eoTwUmocXTcEsEGnoos=;
        b=M4ItZ5bpEoNeEFWFbfFjtL2wrraQYFzpy+uMEpR0gpuGHAtraQGKkZDzQ/aN0c9afe
         RKbDs2E6F8rIfoKOGEWOc3UzCS9eP2j8NTP06QF/1bxIZydHqJ+fS+V4lmUBtetGjGZD
         z58ucA/VJZ3TINoKPSJUz8eKkDbV3wVSoGo6NCAVTDEYMVXKwVytz1cGVMZsucGc8hxY
         a/FcSPywvoUab9MMZb+PnpeXfTNPUveRShWxIjQzT/3RjAxLBHGSSERnIjUu3uy2Pypg
         fU24glmqOzGi3bZ5E/CPbcAzdk3rXiI97YZmafB5+4R87v+7DIBw7anAnXoDnzlNi6d5
         8B1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aAbKSNMDcMUO6uRsWJmHOq81eoTwUmocXTcEsEGnoos=;
        b=L0E1rKYgxmXBQhbdGWo9wtRjI6AFwV89USD1ACTxBEeaESaOKDIMzF9WoJt5IvMzpP
         9rlmp1sU3i7Teue8SJWSnTsZcwDNgieuW7pIkxcJRm69XqHv23Y9mJjlq5v3+ezvtupX
         xL5b5MSCcrl0gGHQAhvUz+voVTk/GrmLdVJpODvDOdXLwojQ4FmlG81B/ABdL/iQK0tv
         7OC6S4duL7bKrR7Ukj/G1h/4u0BGd6PCrpfveavr5RK6mopRmfV86zYlgq0jtIyJP1ld
         6ljTLoiRJt6y870NBZD2+rh/j5PUqyBZebI634e4HBHZ/67LP/6vg4dZIv6jxpNxKY6t
         X+gA==
X-Gm-Message-State: ANhLgQ0ynY+3MKMXKIa/yniuzdZdAVUaNkuOWK67ZobpZhgCA89c+nPk
        re8exKw37GFIUT3aNB/h1zkvxSACRpZGkwSnAwmLp58a
X-Google-Smtp-Source: ADFU+vvKAGCQ+T6KsGaZPG9Hk6BOTmtaKFiJDYWLglzbIqZJLnHHIUpGWo3xNdpm8OEuyR3sMaUtnKH4CelxGs/Gudg=
X-Received: by 2002:adf:90e1:: with SMTP id i88mr25280531wri.95.1584200585214;
 Sat, 14 Mar 2020 08:43:05 -0700 (PDT)
MIME-Version: 1.0
References: <1584092566-4793-1-git-send-email-sunil.kovvuri@gmail.com>
 <1584092566-4793-3-git-send-email-sunil.kovvuri@gmail.com> <20200313181648.GD67638@unreal>
In-Reply-To: <20200313181648.GD67638@unreal>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Sat, 14 Mar 2020 21:12:53 +0530
Message-ID: <CA+sq2CfJggqOJKb3jXnzg5YhBt4enoCFxnbUu83J4mdxUL0eBw@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 2/7] octeontx2-pf: Handle VF function level reset
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Geetha sowjanya <gakula@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 13, 2020 at 11:46 PM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Fri, Mar 13, 2020 at 03:12:41PM +0530, sunil.kovvuri@gmail.com wrote:
> > From: Geetha sowjanya <gakula@marvell.com>
> >
> > When FLR is initiated for a VF (PCI function level reset),
> > the parent PF gets a interrupt. PF then sends a message to
> > admin function (AF), which then cleanups all resources attached
> > to that VF.
> >
> > Also handled IRQs triggered when master enable bit is cleared
> > or set for VFs. This handler just clears the transaction pending
> > ie TRPEND bit.
> >
> > Signed-off-by: Geetha sowjanya <gakula@marvell.com>
> > Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> > ---
> >  .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   7 +
> >  .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   | 234 ++++++++++++++++++++-
> >  2 files changed, 240 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> > index 74439e1..c0a9693 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> > +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> > @@ -191,6 +191,11 @@ struct otx2_hw {
> >       u64                     cgx_tx_stats[CGX_TX_STATS_COUNT];
> >  };
> >
> > +struct flr_work {
> > +     struct work_struct work;
> > +     struct otx2_nic *pf;
> > +};
> > +
> >  struct refill_work {
> >       struct delayed_work pool_refill_work;
> >       struct otx2_nic *pf;
> > @@ -226,6 +231,8 @@ struct otx2_nic {
> >
> >       u64                     reset_count;
> >       struct work_struct      reset_task;
> > +     struct workqueue_struct *flr_wq;
> > +     struct flr_work         *flr_wrk;
> >       struct refill_work      *refill_wrk;
> >
> >       /* Ethtool stuff */
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> > index 967ef7b..bf6e2529 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> > +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> > @@ -61,6 +61,224 @@ static int otx2_change_mtu(struct net_device *netdev, int new_mtu)
> >       return err;
> >  }
> >
> > +static void otx2_disable_flr_me_intr(struct otx2_nic *pf)
> > +{
> > +     int irq, vfs = pf->total_vfs;
> > +
> > +     /* Disable VFs ME interrupts */
> > +     otx2_write64(pf, RVU_PF_VFME_INT_ENA_W1CX(0), INTR_MASK(vfs));
> > +     irq = pci_irq_vector(pf->pdev, RVU_PF_INT_VEC_VFME0);
> > +     free_irq(irq, pf);
> > +
> > +     /* Disable VFs FLR interrupts */
> > +     otx2_write64(pf, RVU_PF_VFFLR_INT_ENA_W1CX(0), INTR_MASK(vfs));
> > +     irq = pci_irq_vector(pf->pdev, RVU_PF_INT_VEC_VFFLR0);
> > +     free_irq(irq, pf);
> > +
> > +     if (vfs <= 64)
> > +             return;
> > +
> > +     otx2_write64(pf, RVU_PF_VFME_INT_ENA_W1CX(1), INTR_MASK(vfs - 64));
> > +     irq = pci_irq_vector(pf->pdev, RVU_PF_INT_VEC_VFME1);
> > +     free_irq(irq, pf);
> > +
> > +     otx2_write64(pf, RVU_PF_VFFLR_INT_ENA_W1CX(1), INTR_MASK(vfs - 64));
> > +     irq = pci_irq_vector(pf->pdev, RVU_PF_INT_VEC_VFFLR1);
> > +     free_irq(irq, pf);
> > +}
> > +
> > +static void otx2_flr_wq_destroy(struct otx2_nic *pf)
> > +{
> > +     if (!pf->flr_wq)
> > +             return;
> > +     flush_workqueue(pf->flr_wq);
> > +     destroy_workqueue(pf->flr_wq);
>
> destroy_workqueue() calls to drain_workqueue() which calls to
> flush_workqueue() in proper order and not like it is written here.
>

Thanks, will fix this in v3.

Sunil.
