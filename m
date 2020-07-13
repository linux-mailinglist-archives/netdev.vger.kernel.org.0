Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0480021CF67
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 08:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729445AbgGMGKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 02:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729021AbgGMGKr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 02:10:47 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39A86C061794
        for <netdev@vger.kernel.org>; Sun, 12 Jul 2020 23:10:47 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id k23so12190049iom.10
        for <netdev@vger.kernel.org>; Sun, 12 Jul 2020 23:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y44HJ/5Naind8aqlTewSONd87bABThK4TcBzrQm+pMI=;
        b=gyD37dhHZVdbKc+LhHZa2v9ZAqIwP4/CcEghnaVOaN3ltn6KsR35qp0yCwbRYQe/5y
         hMRj3NFPzSIJmuPb7Wye+QTPkzQfgspFUbTs2RXtKaKD1zkyN0JZriAZ6pzsRmBs88Iu
         nbnWhRIKdEHR5ODbfSQtC4wTrjmPxETWNoA4cB1+Yjl5PVn0gjj3K9GrtownJ5tvKCx1
         9ywumy6l4oMi24/FDO/5y0TxCeF+Wiy+HkgXM5uo3GBYvXR70zpkNbZODb73wKZyyNd7
         TZLIywy9jApqouVaKf7rGLiohigs8/WbTlWDQz+CWFJSLdErDfzhnr/dFuiqq3BsgDrU
         nkeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y44HJ/5Naind8aqlTewSONd87bABThK4TcBzrQm+pMI=;
        b=fIrRI7dHUnVosyL/ZIVQ/frL0amLxbQxd1gpwgmMI/+3ummA4cY6oaPKlMPGQvzdT7
         7p804i1CmEMjk1J3XpcpB9muX5xWI1x8ASXmVnlEwgZUlEbSuFJ9lo0s37aBE56NT0Gf
         6uSYrxahoBvijKD/bI+7/bcrA774rI50v6ChBYXRZHo0Dksg6nobxo3Bq/JXmIB/n0Ge
         bSRZjcjdJeUDItqhNT8rroNIzJ7vuHIaykrkax2qla///DZE9WRKeJKvkCcohGjVe8BB
         I1No1U2rbdhYpRO+93040D/vwQ+pSmuSKe7kvaosXIUewbxQgvJyvAG71FpPNb33gUx/
         x40Q==
X-Gm-Message-State: AOAM532195gULjG36oEiiY2r2KNSJPf1gYA2lOChtMM0BJs+IciQPXJU
        hpABGnDpwMnphQTgbRAgtQWH6PvFGvahwELmUog=
X-Google-Smtp-Source: ABdhPJxYW6nX4BebofNXygs9zFMR3bnOEWF/NXRB9Ub9+MaRoaV59HRnYhaUsj9CmJfFoChZ8/uTa6URBpGW+LMKnpw=
X-Received: by 2002:a02:5a08:: with SMTP id v8mr93524012jaa.142.1594620646420;
 Sun, 12 Jul 2020 23:10:46 -0700 (PDT)
MIME-Version: 1.0
References: <1594301221-3731-1-git-send-email-sundeep.lkml@gmail.com>
 <1594301221-3731-4-git-send-email-sundeep.lkml@gmail.com> <20200709160156.GC7904@hoboy>
In-Reply-To: <20200709160156.GC7904@hoboy>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Mon, 13 Jul 2020 11:40:34 +0530
Message-ID: <CALHRZuoVtuHLFjwW_bJsWxVFYN=PYxwsj+YabNH4p=v82u-MVA@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 3/3] octeontx2-pf: Add support for PTP clock
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        sgoutham@marvell.com, Subbaraya Sundeep <sbhatta@marvell.com>,
        Aleksey Makarov <amakarov@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Richard,

On Thu, Jul 9, 2020 at 9:32 PM Richard Cochran <richardcochran@gmail.com> wrote:
>
> On Thu, Jul 09, 2020 at 06:57:01PM +0530, sundeep.lkml@gmail.com wrote:
>
> > @@ -1736,6 +1751,143 @@ static void otx2_reset_task(struct work_struct *work)
> >       netif_trans_update(pf->netdev);
> >  }
> >
> > +static int otx2_config_hw_rx_tstamp(struct otx2_nic *pfvf, bool enable)
> > +{
> > +     struct msg_req *req;
> > +     int err;
> > +
> > +     if (pfvf->flags & OTX2_FLAG_RX_TSTAMP_ENABLED && enable)
> > +             return 0;
>
> It appears that nothing protects pfvf->flags from concurrent access.
> Please double check and correct if needed.
>
Please correct me if am wrong ndo_open, ndo_close and ndo_ioctl are
protected by rtnl lock so it is okay here. But there is a reset task
in the driver
which accesses this flag too hence lock is required b/w those. I will fix this.

> > +     mutex_lock(&pfvf->mbox.lock);
> > +     if (enable)
> > +             req = otx2_mbox_alloc_msg_cgx_ptp_rx_enable(&pfvf->mbox);
> > +     else
> > +             req = otx2_mbox_alloc_msg_cgx_ptp_rx_disable(&pfvf->mbox);
> > +     if (!req) {
> > +             mutex_unlock(&pfvf->mbox.lock);
> > +             return -ENOMEM;
> > +     }
> > +
> > +     err = otx2_sync_mbox_msg(&pfvf->mbox);
> > +     if (err) {
> > +             mutex_unlock(&pfvf->mbox.lock);
> > +             return err;
> > +     }
> > +
> > +     mutex_unlock(&pfvf->mbox.lock);
> > +     if (enable)
> > +             pfvf->flags |= OTX2_FLAG_RX_TSTAMP_ENABLED;
> > +     else
> > +             pfvf->flags &= ~OTX2_FLAG_RX_TSTAMP_ENABLED;
> > +     return 0;
> > +}
> > +
> > +static int otx2_config_hw_tx_tstamp(struct otx2_nic *pfvf, bool enable)
> > +{
> > +     struct msg_req *req;
> > +     int err;
> > +
> > +     if (pfvf->flags & OTX2_FLAG_TX_TSTAMP_ENABLED && enable)
> > +             return 0;
>
> Again, please check concurrency here.
>
> > +
> > +     mutex_lock(&pfvf->mbox.lock);
> > +     if (enable)
> > +             req = otx2_mbox_alloc_msg_nix_lf_ptp_tx_enable(&pfvf->mbox);
> > +     else
> > +             req = otx2_mbox_alloc_msg_nix_lf_ptp_tx_disable(&pfvf->mbox);
> > +     if (!req) {
> > +             mutex_unlock(&pfvf->mbox.lock);
> > +             return -ENOMEM;
> > +     }
> > +
> > +     err = otx2_sync_mbox_msg(&pfvf->mbox);
> > +     if (err) {
> > +             mutex_unlock(&pfvf->mbox.lock);
> > +             return err;
> > +     }
> > +
> > +     mutex_unlock(&pfvf->mbox.lock);
> > +     if (enable)
> > +             pfvf->flags |= OTX2_FLAG_TX_TSTAMP_ENABLED;
> > +     else
> > +             pfvf->flags &= ~OTX2_FLAG_TX_TSTAMP_ENABLED;
> > +     return 0;
> > +}
> > +
> > +static int otx2_config_hwtstamp(struct net_device *netdev, struct ifreq *ifr)
> > +{
> > +     struct otx2_nic *pfvf = netdev_priv(netdev);
> > +     struct hwtstamp_config config;
> > +
> > +     if (!pfvf->ptp)
> > +             return -ENODEV;
> > +
> > +     if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
> > +             return -EFAULT;
> > +
> > +     /* reserved for future extensions */
> > +     if (config.flags)
> > +             return -EINVAL;
> > +
> > +     switch (config.tx_type) {
> > +     case HWTSTAMP_TX_OFF:
> > +             otx2_config_hw_tx_tstamp(pfvf, false);
> > +             break;
> > +     case HWTSTAMP_TX_ON:
> > +             otx2_config_hw_tx_tstamp(pfvf, true);
> > +             break;
> > +     default:
> > +             return -ERANGE;
> > +     }
> > +
> > +     switch (config.rx_filter) {
> > +     case HWTSTAMP_FILTER_NONE:
> > +             otx2_config_hw_rx_tstamp(pfvf, false);
> > +             break;
> > +     case HWTSTAMP_FILTER_ALL:
> > +     case HWTSTAMP_FILTER_SOME:
> > +     case HWTSTAMP_FILTER_PTP_V1_L4_EVENT:
> > +     case HWTSTAMP_FILTER_PTP_V1_L4_SYNC:
> > +     case HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ:
> > +     case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
> > +     case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
> > +     case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
> > +     case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
> > +     case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
> > +     case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
> > +     case HWTSTAMP_FILTER_PTP_V2_EVENT:
> > +     case HWTSTAMP_FILTER_PTP_V2_SYNC:
> > +     case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
> > +             otx2_config_hw_rx_tstamp(pfvf, true);
> > +             config.rx_filter = HWTSTAMP_FILTER_ALL;
> > +             break;
> > +     default:
> > +             return -ERANGE;
> > +     }
> > +
> > +     memcpy(&pfvf->tstamp, &config, sizeof(config));
> > +
> > +     return copy_to_user(ifr->ifr_data, &config,
> > +                         sizeof(config)) ? -EFAULT : 0;
> > +}
> > +
> > +static int otx2_ioctl(struct net_device *netdev, struct ifreq *req, int cmd)
> > +{
> > +     struct otx2_nic *pfvf = netdev_priv(netdev);
> > +     struct hwtstamp_config *cfg = &pfvf->tstamp;
> > +
>
> Need to test phy_has_hwtstamp() here and pass ioctl to PHY if true.
>
For this platform PHY is taken care of by firmware hence it is not
possible.

> > +     switch (cmd) {
> > +     case SIOCSHWTSTAMP:
> > +             return otx2_config_hwtstamp(netdev, req);
> > +     case SIOCGHWTSTAMP:
> > +             return copy_to_user(req->ifr_data, cfg,
> > +                                 sizeof(*cfg)) ? -EFAULT : 0;
> > +     default:
> > +             return -EOPNOTSUPP;
> > +     }
> > +}
> > +
> >  static const struct net_device_ops otx2_netdev_ops = {
> >       .ndo_open               = otx2_open,
> >       .ndo_stop               = otx2_stop,
>
>
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c
> > new file mode 100644
> > index 0000000..28058bd
> > --- /dev/null
> > +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c
> > @@ -0,0 +1,208 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/* Marvell OcteonTx2 PTP support for ethernet driver */
> > +
> > +#include "otx2_common.h"
> > +#include "otx2_ptp.h"
> > +
> > +static int otx2_ptp_adjfine(struct ptp_clock_info *ptp_info, long scaled_ppm)
> > +{
> > +     struct otx2_ptp *ptp = container_of(ptp_info, struct otx2_ptp,
> > +                                         ptp_info);
> > +     struct ptp_req *req;
> > +     int err;
> > +
> > +     if (!ptp->nic)
> > +             return -ENODEV;
> > +
> > +     req = otx2_mbox_alloc_msg_ptp_op(&ptp->nic->mbox);
> > +     if (!req)
> > +             return -ENOMEM;
> > +
> > +     req->op = PTP_OP_ADJFINE;
> > +     req->scaled_ppm = scaled_ppm;
> > +
> > +     err = otx2_sync_mbox_msg(&ptp->nic->mbox);
> > +     if (err)
> > +             return err;
> > +
> > +     return 0;
> > +}
> > +
> > +static u64 ptp_cc_read(const struct cyclecounter *cc)
> > +{
> > +     struct otx2_ptp *ptp = container_of(cc, struct otx2_ptp, cycle_counter);
> > +     struct ptp_req *req;
> > +     struct ptp_rsp *rsp;
> > +     int err;
> > +
> > +     if (!ptp->nic)
> > +             return 0;
> > +
> > +     req = otx2_mbox_alloc_msg_ptp_op(&ptp->nic->mbox);
> > +     if (!req)
> > +             return 0;
> > +
> > +     req->op = PTP_OP_GET_CLOCK;
> > +
> > +     err = otx2_sync_mbox_msg(&ptp->nic->mbox);
> > +     if (err)
> > +             return 0;
> > +
> > +     rsp = (struct ptp_rsp *)otx2_mbox_get_rsp(&ptp->nic->mbox.mbox, 0,
> > +                                               &req->hdr);
> > +     if (IS_ERR(rsp))
> > +             return 0;
> > +
> > +     return rsp->clk;
> > +}
> > +
> > +static int otx2_ptp_adjtime(struct ptp_clock_info *ptp_info, s64 delta)
> > +{
> > +     struct otx2_ptp *ptp = container_of(ptp_info, struct otx2_ptp,
> > +                                         ptp_info);
> > +     struct otx2_nic *pfvf = ptp->nic;
> > +
> > +     mutex_lock(&pfvf->mbox.lock);
> > +     timecounter_adjtime(&ptp->time_counter, delta);
> > +     mutex_unlock(&pfvf->mbox.lock);
> > +
> > +     return 0;
> > +}
> > +
> > +static int otx2_ptp_gettime(struct ptp_clock_info *ptp_info,
> > +                         struct timespec64 *ts)
> > +{
> > +     struct otx2_ptp *ptp = container_of(ptp_info, struct otx2_ptp,
> > +                                         ptp_info);
> > +     struct otx2_nic *pfvf = ptp->nic;
> > +     u64 nsec;
> > +
> > +     mutex_lock(&pfvf->mbox.lock);
> > +     nsec = timecounter_read(&ptp->time_counter);
> > +     mutex_unlock(&pfvf->mbox.lock);
> > +
> > +     *ts = ns_to_timespec64(nsec);
> > +
> > +     return 0;
> > +}
> > +
> > +static int otx2_ptp_settime(struct ptp_clock_info *ptp_info,
> > +                         const struct timespec64 *ts)
> > +{
> > +     struct otx2_ptp *ptp = container_of(ptp_info, struct otx2_ptp,
> > +                                         ptp_info);
> > +     struct otx2_nic *pfvf = ptp->nic;
> > +     u64 nsec;
> > +
> > +     nsec = timespec64_to_ns(ts);
> > +
> > +     mutex_lock(&pfvf->mbox.lock);
> > +     timecounter_init(&ptp->time_counter, &ptp->cycle_counter, nsec);
> > +     mutex_unlock(&pfvf->mbox.lock);
> > +
> > +     return 0;
> > +}
> > +
> > +static int otx2_ptp_enable(struct ptp_clock_info *ptp_info,
> > +                        struct ptp_clock_request *rq, int on)
> > +{
> > +     return -EOPNOTSUPP;
> > +}
> > +
> > +int otx2_ptp_init(struct otx2_nic *pfvf)
> > +{
> > +     struct otx2_ptp *ptp_ptr;
> > +     struct cyclecounter *cc;
> > +     struct ptp_req *req;
> > +     int err;
> > +
> > +     mutex_lock(&pfvf->mbox.lock);
> > +     /* check if PTP block is available */
> > +     req = otx2_mbox_alloc_msg_ptp_op(&pfvf->mbox);
> > +     if (!req) {
> > +             mutex_unlock(&pfvf->mbox.lock);
> > +             return -ENOMEM;
> > +     }
> > +
> > +     req->op = PTP_OP_GET_CLOCK;
> > +
> > +     err = otx2_sync_mbox_msg(&pfvf->mbox);
> > +     if (err) {
> > +             mutex_unlock(&pfvf->mbox.lock);
> > +             return err;
> > +     }
> > +     mutex_unlock(&pfvf->mbox.lock);
> > +
> > +     ptp_ptr = kzalloc(sizeof(*ptp_ptr), GFP_KERNEL);
> > +     if (!ptp_ptr) {
> > +             err = -ENOMEM;
> > +             goto error;
> > +     }
> > +
> > +     ptp_ptr->nic = pfvf;
> > +
> > +     cc = &ptp_ptr->cycle_counter;
> > +     cc->read = ptp_cc_read;
> > +     cc->mask = CYCLECOUNTER_MASK(64);
> > +     cc->mult = 1;
> > +     cc->shift = 0;
> > +
> > +     timecounter_init(&ptp_ptr->time_counter, &ptp_ptr->cycle_counter,
> > +                      ktime_to_ns(ktime_get_real()));
> > +
> > +     ptp_ptr->ptp_info = (struct ptp_clock_info) {
> > +             .owner          = THIS_MODULE,
> > +             .name           = "OcteonTX2 PTP",
> > +             .max_adj        = 1000000000ull,
> > +             .n_ext_ts       = 0,
> > +             .n_pins         = 0,
> > +             .pps            = 0,
> > +             .adjfine        = otx2_ptp_adjfine,
> > +             .adjtime        = otx2_ptp_adjtime,
> > +             .gettime64      = otx2_ptp_gettime,
> > +             .settime64      = otx2_ptp_settime,
> > +             .enable         = otx2_ptp_enable,
> > +     };
> > +
> > +     ptp_ptr->ptp_clock = ptp_clock_register(&ptp_ptr->ptp_info, pfvf->dev);
> > +     if (IS_ERR(ptp_ptr->ptp_clock)) {
> > +             err = PTR_ERR(ptp_ptr->ptp_clock);
> > +             kfree(ptp_ptr);
> > +             goto error;
> > +     }
>
> You need to handle NULL here.
>
>  * ptp_clock_register() - register a PTP hardware clock driver
>  *
>  * @info:   Structure describing the new clock.
>  * @parent: Pointer to the parent device of the new clock.
>  *
>  * Returns a valid pointer on success or PTR_ERR on failure.  If PHC
>  * support is missing at the configuration level, this function
>  * returns NULL, and drivers are expected to gracefully handle that
>  * case separately.
>
Okay. Will fix it.
> > +
> > +     pfvf->ptp = ptp_ptr;
> > +
> > +error:
> > +     return err;
> > +}
> > +
> > +void otx2_ptp_destroy(struct otx2_nic *pfvf)
> > +{
> > +     struct otx2_ptp *ptp = pfvf->ptp;
> > +
> > +     if (!ptp)
> > +             return;
> > +
> > +     ptp_clock_unregister(ptp->ptp_clock);
> > +     kfree(ptp);
> > +     pfvf->ptp = NULL;
> > +}
> > +
> > +int otx2_ptp_clock_index(struct otx2_nic *pfvf)
> > +{
> > +     if (!pfvf->ptp)
> > +             return -ENODEV;
> > +
> > +     return ptp_clock_index(pfvf->ptp->ptp_clock);
> > +}
> > +
> > +int otx2_ptp_tstamp2time(struct otx2_nic *pfvf, u64 tstamp, u64 *tsns)
> > +{
> > +     if (!pfvf->ptp)
> > +             return -ENODEV;
> > +
> > +     *tsns = timecounter_cyc2time(&pfvf->ptp->time_counter, tstamp);
> > +
> > +     return 0;
> > +}
>
>
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
> > index 3a5b34a..1f90426 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
> > +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
> > @@ -16,6 +16,7 @@
> >  #include "otx2_common.h"
> >  #include "otx2_struct.h"
> >  #include "otx2_txrx.h"
> > +#include "otx2_ptp.h"
> >
> >  #define CQE_ADDR(CQ, idx) ((CQ)->cqe_base + ((CQ)->cqe_size * (idx)))
> >
> > @@ -81,8 +82,11 @@ static void otx2_snd_pkt_handler(struct otx2_nic *pfvf,
> >                                int budget, int *tx_pkts, int *tx_bytes)
> >  {
> >       struct nix_send_comp_s *snd_comp = &cqe->comp;
> > +     struct skb_shared_hwtstamps ts;
> >       struct sk_buff *skb = NULL;
> > +     u64 timestamp, tsns;
> >       struct sg_list *sg;
> > +     int err;
> >
> >       if (unlikely(snd_comp->status) && netif_msg_tx_err(pfvf))
> >               net_err_ratelimited("%s: TX%d: Error in send CQ status:%x\n",
> > @@ -94,6 +98,18 @@ static void otx2_snd_pkt_handler(struct otx2_nic *pfvf,
> >       if (unlikely(!skb))
> >               return;
> >
> > +     if (skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS) {
>
> SKBTX_IN_PROGRESS may be set by the PHY, so you need to test whether
> time stamping is enabled in your MAC driver as well.
>
In our case PHY will not set it and the pfvf/MAC driver sets it.

Thanks for review,
Sundeep

> > +             timestamp = ((u64 *)sq->timestamps->base)[snd_comp->sqe_id];
> > +             if (timestamp != 1) {
> > +                     err = otx2_ptp_tstamp2time(pfvf, timestamp, &tsns);
> > +                     if (!err) {
> > +                             memset(&ts, 0, sizeof(ts));
> > +                             ts.hwtstamp = ns_to_ktime(tsns);
> > +                             skb_tstamp_tx(skb, &ts);
> > +                     }
> > +             }
> > +     }
> > +
> >       *tx_bytes += skb->len;
> >       (*tx_pkts)++;
> >       otx2_dma_unmap_skb_frags(pfvf, sg);
>
> Thanks,
> Richard
