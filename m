Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1618148CCC
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 18:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731640AbgAXRQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 12:16:12 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51471 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730514AbgAXRQM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 12:16:12 -0500
Received: by mail-wm1-f68.google.com with SMTP id t23so206136wmi.1
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 09:16:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Cc+I8p21gl50jv91grim2qawyAZowE+y2F+nXQZtzX4=;
        b=PMeRe+rt7HLUrwOFJqsoVbkIxnprzZMuJeqWm90VYTXMa7hwHtf1YnljW6bC4lvc9y
         WuvbnLm+QoWmvBddc1tNYLZYB0GqnOCoUHM7p2Xy7ZQviu1ZUES4s2+xO6teLwB3/ALJ
         RpzvUbNhvO2ys7y7xaYBSr41aaRrHGYFDcg5U6jy4yrzSNF7lFqZvuk9BsPFeBqSvNc6
         KIwBi2Np7pAzRkRRokN3prUwxJo9l1OtF3QMw8dEt+kbxQfQ8NzGA/9Lti+5fY72e1r/
         b9mONxhoGyXKXTo6UN+0MKFwLS8Ng4JbTsM/obQPSZ+eM2ASqgvpz8XJIkzUINWiOyHM
         Ayjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Cc+I8p21gl50jv91grim2qawyAZowE+y2F+nXQZtzX4=;
        b=R/U7rtAxaz96bRwWZfYq3/D/mJMpoHCAr07WuKrE95wzigSp+3dWjyjxmpjsG6KxqA
         vnaeyeNW6yG5rjltNQrWnoz8Ih0MZ95BAVZq5S6aZ0hNTQxGmC3PeVxK3Hd4NCxoPU1x
         TstvF9thq15c74aiwhLLvPNuGME+3UHr9Lv8EjkBRwfkFEydvylOgzRlf9HEcoapM+d7
         aypK/3LeoJfOgC9e8ptduJEW6SEMBANtLbd+ZczkAV5HzgVHJ4dwu1nVBBp4czzfMkpf
         qS0wM2r1U1YNWyqpbwkhea5xjI6ZGiwgZ/sLI7GeMwa+yk1AI3VjCsiWW6021Cxrb0eo
         WP1g==
X-Gm-Message-State: APjAAAUBensvix9cvLUrhlBttEXqS9M0kjSjkF7Q9F8dBrkBPOTofudB
        034saxXci7VXVZEEyx7C1g0H3hwhFIjXz0BPx1Y=
X-Google-Smtp-Source: APXvYqxfJ04mX5PNdf++ZxEeNDvjbdRtbiDDAtqSB7Q5mMwwTo+u2d+TVkxA3YIuJ8bj7XlcR535lHXzFgNid56ekPg=
X-Received: by 2002:a7b:cc97:: with SMTP id p23mr190857wma.89.1579886169317;
 Fri, 24 Jan 2020 09:16:09 -0800 (PST)
MIME-Version: 1.0
References: <1579612911-24497-1-git-send-email-sunil.kovvuri@gmail.com>
 <1579612911-24497-3-git-send-email-sunil.kovvuri@gmail.com> <20200124083315.GC32191@ranger.igk.intel.com>
In-Reply-To: <20200124083315.GC32191@ranger.igk.intel.com>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Fri, 24 Jan 2020 22:45:58 +0530
Message-ID: <CA+sq2CeT-FrV8Yd=fjZ-rOE87qB7k2HSutzF0L2d2jL1YjnPyA@mail.gmail.com>
Subject: Re: [PATCH v4 02/17] octeontx2-pf: Mailbox communication with AF
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kubakici@wp.pl>,
        Michal Kubecek <mkubecek@suse.cz>,
        Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Christina Jacob <cjacob@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Aleksey Makarov <amakarov@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 24, 2020 at 9:11 PM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> On Tue, Jan 21, 2020 at 06:51:36PM +0530, sunil.kovvuri@gmail.com wrote:
> > From: Sunil Goutham <sgoutham@marvell.com>
> >
> > +
> > +static void otx2_queue_work(struct mbox *mw, struct workqueue_struct *mbox_wq,
> > +                         int first, int mdevs, u64 intr, int type)
> > +{
> > +     struct otx2_mbox_dev *mdev;
> > +     struct otx2_mbox *mbox;
> > +     struct mbox_hdr *hdr;
> > +     int i;
> > +
> > +     for (i = first; i < mdevs; i++) {
> > +             /* start from 0 */
> > +             if (!(intr & BIT_ULL(i - first)))
> > +                     continue;
> > +
> > +             mbox = &mw->mbox;
> > +             mdev = &mbox->dev[i];
> > +             if (type == TYPE_PFAF)
> > +                     otx2_sync_mbox_bbuf(mbox, i);
> > +             hdr = mdev->mbase + mbox->rx_start;
> > +             /* The hdr->num_msgs is set to zero immediately in the interrupt
> > +              * handler to  ensure that it holds a correct value next time
> > +              * when the interrupt handler is called.
> > +              * pf->mbox.num_msgs holds the data for use in pfaf_mbox_handler
> > +              * pf>mbox.up_num_msgs holds the data for use in
> > +              * pfaf_mbox_up_handler.
> > +              */
> > +             if (hdr->num_msgs) {
> > +                     mw[i].num_msgs = hdr->num_msgs;
> > +                     hdr->num_msgs = 0;
> > +                     if (type == TYPE_PFAF)
> > +                             memset(mbox->hwbase + mbox->rx_start, 0,
> > +                                    ALIGN(sizeof(struct mbox_hdr),
> > +                                          sizeof(u64)));
> > +
> > +                     queue_work(mbox_wq, &mw[i].mbox_wrk);
> > +             }
> > +
> > +             mbox = &mw->mbox_up;
>
> You could have a two separate stack variables for these two mboxes instead
> of flipping the single variable on each loop iteration.
>
> > +             mdev = &mbox->dev[i];
> > +             if (type == TYPE_PFAF)
> > +                     otx2_sync_mbox_bbuf(mbox, i);
> > +             hdr = mdev->mbase + mbox->rx_start;
> > +             if (hdr->num_msgs) {
> > +                     mw[i].up_num_msgs = hdr->num_msgs;
> > +                     hdr->num_msgs = 0;
> > +                     if (type == TYPE_PFAF)
> > +                             memset(mbox->hwbase + mbox->rx_start, 0,
> > +                                    ALIGN(sizeof(struct mbox_hdr),
> > +                                          sizeof(u64)));
> > +
> > +                     queue_work(mbox_wq, &mw[i].mbox_up_wrk);
> > +             }
>
> Does it make sense to pull out the logic above onto separate function?
>

Thanks for the feedback.
I will relook into the logic and see if this can be cleanedup and
submit along with next patchset.

> > +     }
> > +}
> > +
> > +static void otx2_pfaf_mbox_destroy(struct otx2_nic *pf)
> > +{
> > +     struct mbox *mbox = &pf->mbox;
> > +
> > +     if (pf->mbox_wq) {
> > +             flush_workqueue(pf->mbox_wq);
> > +             destroy_workqueue(pf->mbox_wq);
> > +             pf->mbox_wq = NULL;
> > +     }
> > +
> > +     if (mbox->mbox.hwbase)
> > +             iounmap((void __iomem *)mbox->mbox.hwbase);
> > +
> > +     otx2_mbox_destroy(&mbox->mbox);
> > +     otx2_mbox_destroy(&mbox->mbox_up);
> > +}
> > +
> > +static int otx2_pfaf_mbox_init(struct otx2_nic *pf)
> > +{
> > +     struct mbox *mbox = &pf->mbox;
> > +     void __iomem *hwbase;
> > +     int err;
> > +
> > +     mbox->pfvf = pf;
> > +     pf->mbox_wq = alloc_workqueue("otx2_pfaf_mailbox",
> > +                                   WQ_UNBOUND | WQ_HIGHPRI |
> > +                                   WQ_MEM_RECLAIM, 1);
> > +     if (!pf->mbox_wq)
> > +             return -ENOMEM;
> > +
> > +     /* Mailbox is a reserved memory (in RAM) region shared between
> > +      * admin function (i.e AF) and this PF, shouldn't be mapped as
> > +      * device memory to allow unaligned accesses.
> > +      */
> > +     hwbase = ioremap_wc(pci_resource_start(pf->pdev, PCI_MBOX_BAR_NUM),
> > +                         pci_resource_len(pf->pdev, PCI_MBOX_BAR_NUM));
> > +     if (!hwbase) {
> > +             dev_err(pf->dev, "Unable to map PFAF mailbox region\n");
> > +             err = -ENOMEM;
> > +             goto exit;
> > +     }
> > +
> > +     err = otx2_mbox_init(&mbox->mbox, hwbase, pf->pdev, pf->reg_base,
> > +                          MBOX_DIR_PFAF, 1);
> > +     if (err)
> > +             goto exit;
> > +
> > +     err = otx2_mbox_init(&mbox->mbox_up, hwbase, pf->pdev, pf->reg_base,
> > +                          MBOX_DIR_PFAF_UP, 1);
>
> There is a chance that the first otx2_mbox_init succeeded and second one
> failed. In that case you will be leaking the mbox->dev that otx2_mbox_init
> is internally allocating as the caller of otx2_pfaf_mbox_init in case of
> error has a 'goto err_free_irq_vectors', so otx2_mbox_destroy won't be
> called for the mbox->mbox. Furthermore the iounmap() would be skipped as
> well.
>
> I'm not sure whether PCI subsystem will call the remove() callback in case
> when probe() failed?
>

Thanks for catching this, will fix and resubmit.

Sunil.
