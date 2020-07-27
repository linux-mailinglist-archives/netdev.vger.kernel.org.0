Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D73D422E3EC
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 04:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbgG0CNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 22:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbgG0CNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 22:13:33 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E25C0619D2
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 19:13:33 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id q7so15491495ljm.1
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 19:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t9hp4ouKl5bjdjbXbUofGpLmTYSqAoFdaVn5UPF2Uco=;
        b=iNATHHGj4RfnnVFSu/7x7VcqIvhM/66h3AWRCpKropWMyYZo1nPlRHsQtrP/Mgd6ob
         KguFvDzENbIy3kiCLkTawXBS6gRRTxaEK0K4qNdgZoX/6stTgECXraVCMgYI4sVMszEE
         +/e8WN7zlyQdAdCCLQMIgnaitp3pbVPvOo/x9trmxlARumIdmzi3pT1PR5FVukpEiVqo
         dt7ibqGuam4dbt5OOhyLnK5sEw+6QLjmMQuMC56Rc7xoUCJEEo9oQ5mHjR67kMuoVZxt
         Un8s8XRpYS6z69o92e8mmh8LwiDCLrxY4PnCdB3bARmkAvrGldUZbwc3TX2sG+z68Nn+
         nWXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t9hp4ouKl5bjdjbXbUofGpLmTYSqAoFdaVn5UPF2Uco=;
        b=m2U59fsxAqS6gKpNUrAu/fB7AHeFBiX/ESQsyVuRgsMt0huovre+xkEeAlpVjJSLpR
         7nqfvI/roS1b38ldpepPtFt0eG4pnkPvuPLIhisAz3fnOpt1waD3F0OsIa71CBzDoovn
         Il7Co5EtzOgqvUg7SVkT2v0je4dbe/aGhp6CxxHqha3KcAKa0OxK/Qe3jTLPwI7DQQkY
         oq6O+7GnkOuVspKTF2ZZHt751PxQDAwtm7g1DF03bxzgBp3I+lV1HvQyKQtBkHWRtNdk
         wpXn6GYK4Fo7YZSjNaQC79GI+OuIGEHDCl6U1ztgPakdG//damFJDL1xf3SUzyFt8fKZ
         S6Lg==
X-Gm-Message-State: AOAM5307Ll23r98AdHGNbuCiqRXARqpliD+Hu7kUaD98Qiu3jAg2wjtP
        0n+o3fCiwJIQOY5uun2GT7Y5lu2TXg339lI95P+bjdEb
X-Google-Smtp-Source: ABdhPJxFW43u+irf2SogZdnLwl2RUTL4uRuRdmMGeRA347rvZFdRnuzrilOxdYgQjO+NQFxNE8+Hs2QW6x1h0571Hv4=
X-Received: by 2002:a05:651c:88:: with SMTP id 8mr8464475ljq.136.1595816011583;
 Sun, 26 Jul 2020 19:13:31 -0700 (PDT)
MIME-Version: 1.0
References: <1587996484-3504-1-git-send-email-fugang.duan@nxp.com>
 <20200727012354.GT28704@pendragon.ideasonboard.com> <20200727020631.GW28704@pendragon.ideasonboard.com>
In-Reply-To: <20200727020631.GW28704@pendragon.ideasonboard.com>
From:   Chris Healy <cphealy@gmail.com>
Date:   Sun, 26 Jul 2020 19:13:20 -0700
Message-ID: <CAFXsbZrc4kLQPDRXo7zLXV-p6=eLQfiZo6o4o_dK6iDCyJP+AA@mail.gmail.com>
Subject: Re: [RESENT PATCH net--stat 1/1] net: ethernet: fec: Revert "net:
 ethernet: fec: Replace interrupt driven MDIO with polled IO"
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Martin Fuzzey <martin.fuzzey@flowbird.group>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 26, 2020 at 7:06 PM Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>
> On Mon, Jul 27, 2020 at 04:24:02AM +0300, Laurent Pinchart wrote:
> > On Mon, Apr 27, 2020 at 10:08:04PM +0800, Fugang Duan wrote:
> > > This reverts commit 29ae6bd1b0d8a57d7c00ab12cbb949fc41986eef.
> > >
> > > The commit breaks ethernet function on i.MX6SX, i.MX7D, i.MX8MM,
> > > i.MX8MQ, and i.MX8QXP platforms. Boot yocto system by NFS mounting
> > > rootfs will be failed with the commit.
> >
> > I'm afraid this commit breaks networking on i.MX7D for me :-( My board
> > is configured to boot over NFS root with IP autoconfiguration through
> > DHCP. The DHCP request goes out, the reply it sent back by the server,
> > but never noticed by the fec driver.
> >
> > v5.7 works fine. As 29ae6bd1b0d8a57d7c00ab12cbb949fc41986eef was merged
> > during the v5.8 merge window, I suspect something else cropped in
> > between 29ae6bd1b0d8a57d7c00ab12cbb949fc41986eef and this patch that
> > needs to be reverted too. We're close to v5.8 and it would be annoying
> > to see this regression ending up in the released kernel. I can test
> > patches, but I'm not familiar enough with the driver (or the networking
> > subsystem) to fix the issue myself.
>
> If it can be of any help, I've confirmed that, to get the network back
> to usable state from v5.8-rc6, I have to revert all patches up to this
> one. This is the top of my branch, on top of v5.8-rc6:
>
> 5bbe80c9efea Revert "net: ethernet: fec: Revert "net: ethernet: fec: Replace interrupt driven MDIO with polled IO""
> 5462896a08c1 Revert "net: ethernet: fec: Replace interrupt driven MDIO with polled IO"
> 824a82e2bdfa Revert "net: ethernet: fec: move GPR register offset and bit into DT"
> bfe330591cab Revert "net: fec: disable correct clk in the err path of fec_enet_clk_enable"
> 109958cad578 Revert "net: ethernet: fec: prevent tx starvation under high rx load"

I just fired up net-next on my i.MX7d based design (not NFS root
though).  I can bring up the network interface with a gigabit
connection but ALL RX traffic is failing with CRC errors.  Now, my
design is using a Micrel KSZ9031 which might be part of the problem
for me as there were some recent KSZ9031 changes made so take what I'm
seeing with a grain of salt.

Laurent, couple questions:

1) Are you able to boot without NFS root and communicate correctly or
is this issue just when doing an NFS root?
2) If you are able to boot up without NFS root, can you check the
ethtool statistics and see the same RX CRC errors I'm seeing?


>
> > > Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
> > >
> > > diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
> > > index a6cdd5b..e74dd1f 100644
> > > --- a/drivers/net/ethernet/freescale/fec.h
> > > +++ b/drivers/net/ethernet/freescale/fec.h
> > > @@ -376,7 +376,8 @@ struct bufdesc_ex {
> > >  #define FEC_ENET_TS_AVAIL       ((uint)0x00010000)
> > >  #define FEC_ENET_TS_TIMER       ((uint)0x00008000)
> > >
> > > -#define FEC_DEFAULT_IMASK (FEC_ENET_TXF | FEC_ENET_RXF)
> > > +#define FEC_DEFAULT_IMASK (FEC_ENET_TXF | FEC_ENET_RXF | FEC_ENET_MII)
> > > +#define FEC_NAPI_IMASK     FEC_ENET_MII
> > >  #define FEC_RX_DISABLED_IMASK (FEC_DEFAULT_IMASK & (~FEC_ENET_RXF))
> > >
> > >  /* ENET interrupt coalescing macro define */
> > > @@ -542,6 +543,7 @@ struct fec_enet_private {
> > >     int     link;
> > >     int     full_duplex;
> > >     int     speed;
> > > +   struct  completion mdio_done;
> > >     int     irq[FEC_IRQ_NUM];
> > >     bool    bufdesc_ex;
> > >     int     pause_flag;
> > > diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> > > index 1ae075a..c7b84bb 100644
> > > --- a/drivers/net/ethernet/freescale/fec_main.c
> > > +++ b/drivers/net/ethernet/freescale/fec_main.c
> > > @@ -976,8 +976,8 @@ fec_restart(struct net_device *ndev)
> > >     writel((__force u32)cpu_to_be32(temp_mac[1]),
> > >            fep->hwp + FEC_ADDR_HIGH);
> > >
> > > -   /* Clear any outstanding interrupt, except MDIO. */
> > > -   writel((0xffffffff & ~FEC_ENET_MII), fep->hwp + FEC_IEVENT);
> > > +   /* Clear any outstanding interrupt. */
> > > +   writel(0xffffffff, fep->hwp + FEC_IEVENT);
> > >
> > >     fec_enet_bd_init(ndev);
> > >
> > > @@ -1123,7 +1123,7 @@ fec_restart(struct net_device *ndev)
> > >     if (fep->link)
> > >             writel(FEC_DEFAULT_IMASK, fep->hwp + FEC_IMASK);
> > >     else
> > > -           writel(0, fep->hwp + FEC_IMASK);
> > > +           writel(FEC_ENET_MII, fep->hwp + FEC_IMASK);
> > >
> > >     /* Init the interrupt coalescing */
> > >     fec_enet_itr_coal_init(ndev);
> > > @@ -1652,10 +1652,6 @@ fec_enet_interrupt(int irq, void *dev_id)
> > >     irqreturn_t ret = IRQ_NONE;
> > >
> > >     int_events = readl(fep->hwp + FEC_IEVENT);
> > > -
> > > -   /* Don't clear MDIO events, we poll for those */
> > > -   int_events &= ~FEC_ENET_MII;
> > > -
> > >     writel(int_events, fep->hwp + FEC_IEVENT);
> > >     fec_enet_collect_events(fep, int_events);
> > >
> > > @@ -1663,12 +1659,16 @@ fec_enet_interrupt(int irq, void *dev_id)
> > >             ret = IRQ_HANDLED;
> > >
> > >             if (napi_schedule_prep(&fep->napi)) {
> > > -                   /* Disable interrupts */
> > > -                   writel(0, fep->hwp + FEC_IMASK);
> > > +                   /* Disable the NAPI interrupts */
> > > +                   writel(FEC_NAPI_IMASK, fep->hwp + FEC_IMASK);
> > >                     __napi_schedule(&fep->napi);
> > >             }
> > >     }
> > >
> > > +   if (int_events & FEC_ENET_MII) {
> > > +           ret = IRQ_HANDLED;
> > > +           complete(&fep->mdio_done);
> > > +   }
> > >     return ret;
> > >  }
> > >
> > > @@ -1818,24 +1818,11 @@ static void fec_enet_adjust_link(struct net_device *ndev)
> > >             phy_print_status(phy_dev);
> > >  }
> > >
> > > -static int fec_enet_mdio_wait(struct fec_enet_private *fep)
> > > -{
> > > -   uint ievent;
> > > -   int ret;
> > > -
> > > -   ret = readl_poll_timeout_atomic(fep->hwp + FEC_IEVENT, ievent,
> > > -                                   ievent & FEC_ENET_MII, 2, 30000);
> > > -
> > > -   if (!ret)
> > > -           writel(FEC_ENET_MII, fep->hwp + FEC_IEVENT);
> > > -
> > > -   return ret;
> > > -}
> > > -
> > >  static int fec_enet_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
> > >  {
> > >     struct fec_enet_private *fep = bus->priv;
> > >     struct device *dev = &fep->pdev->dev;
> > > +   unsigned long time_left;
> > >     int ret = 0, frame_start, frame_addr, frame_op;
> > >     bool is_c45 = !!(regnum & MII_ADDR_C45);
> > >
> > > @@ -1843,6 +1830,8 @@ static int fec_enet_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
> > >     if (ret < 0)
> > >             return ret;
> > >
> > > +   reinit_completion(&fep->mdio_done);
> > > +
> > >     if (is_c45) {
> > >             frame_start = FEC_MMFR_ST_C45;
> > >
> > > @@ -1854,9 +1843,11 @@ static int fec_enet_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
> > >                    fep->hwp + FEC_MII_DATA);
> > >
> > >             /* wait for end of transfer */
> > > -           ret = fec_enet_mdio_wait(fep);
> > > -           if (ret) {
> > > +           time_left = wait_for_completion_timeout(&fep->mdio_done,
> > > +                           usecs_to_jiffies(FEC_MII_TIMEOUT));
> > > +           if (time_left == 0) {
> > >                     netdev_err(fep->netdev, "MDIO address write timeout\n");
> > > +                   ret = -ETIMEDOUT;
> > >                     goto out;
> > >             }
> > >
> > > @@ -1875,9 +1866,11 @@ static int fec_enet_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
> > >             FEC_MMFR_TA, fep->hwp + FEC_MII_DATA);
> > >
> > >     /* wait for end of transfer */
> > > -   ret = fec_enet_mdio_wait(fep);
> > > -   if (ret) {
> > > +   time_left = wait_for_completion_timeout(&fep->mdio_done,
> > > +                   usecs_to_jiffies(FEC_MII_TIMEOUT));
> > > +   if (time_left == 0) {
> > >             netdev_err(fep->netdev, "MDIO read timeout\n");
> > > +           ret = -ETIMEDOUT;
> > >             goto out;
> > >     }
> > >
> > > @@ -1895,6 +1888,7 @@ static int fec_enet_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
> > >  {
> > >     struct fec_enet_private *fep = bus->priv;
> > >     struct device *dev = &fep->pdev->dev;
> > > +   unsigned long time_left;
> > >     int ret, frame_start, frame_addr;
> > >     bool is_c45 = !!(regnum & MII_ADDR_C45);
> > >
> > > @@ -1904,6 +1898,8 @@ static int fec_enet_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
> > >     else
> > >             ret = 0;
> > >
> > > +   reinit_completion(&fep->mdio_done);
> > > +
> > >     if (is_c45) {
> > >             frame_start = FEC_MMFR_ST_C45;
> > >
> > > @@ -1915,9 +1911,11 @@ static int fec_enet_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
> > >                    fep->hwp + FEC_MII_DATA);
> > >
> > >             /* wait for end of transfer */
> > > -           ret = fec_enet_mdio_wait(fep);
> > > -           if (ret) {
> > > +           time_left = wait_for_completion_timeout(&fep->mdio_done,
> > > +                   usecs_to_jiffies(FEC_MII_TIMEOUT));
> > > +           if (time_left == 0) {
> > >                     netdev_err(fep->netdev, "MDIO address write timeout\n");
> > > +                   ret = -ETIMEDOUT;
> > >                     goto out;
> > >             }
> > >     } else {
> > > @@ -1933,9 +1931,12 @@ static int fec_enet_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
> > >             fep->hwp + FEC_MII_DATA);
> > >
> > >     /* wait for end of transfer */
> > > -   ret = fec_enet_mdio_wait(fep);
> > > -   if (ret)
> > > +   time_left = wait_for_completion_timeout(&fep->mdio_done,
> > > +                   usecs_to_jiffies(FEC_MII_TIMEOUT));
> > > +   if (time_left == 0) {
> > >             netdev_err(fep->netdev, "MDIO write timeout\n");
> > > +           ret  = -ETIMEDOUT;
> > > +   }
> > >
> > >  out:
> > >     pm_runtime_mark_last_busy(dev);
> > > @@ -2144,9 +2145,6 @@ static int fec_enet_mii_init(struct platform_device *pdev)
> > >
> > >     writel(fep->phy_speed, fep->hwp + FEC_MII_SPEED);
> > >
> > > -   /* Clear any pending transaction complete indication */
> > > -   writel(FEC_ENET_MII, fep->hwp + FEC_IEVENT);
> > > -
> > >     fep->mii_bus = mdiobus_alloc();
> > >     if (fep->mii_bus == NULL) {
> > >             err = -ENOMEM;
> > > @@ -3688,6 +3686,7 @@ fec_probe(struct platform_device *pdev)
> > >             fep->irq[i] = irq;
> > >     }
> > >
> > > +   init_completion(&fep->mdio_done);
> > >     ret = fec_enet_mii_init(pdev);
> > >     if (ret)
> > >             goto failed_mii_init;
>
> --
> Regards,
>
> Laurent Pinchart
