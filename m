Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9090D145C66
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 20:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725989AbgAVT1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 14:27:36 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46056 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbgAVT1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 14:27:36 -0500
Received: by mail-wr1-f68.google.com with SMTP id j42so290039wrj.12
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 11:27:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=etP17nW7gU7n0ssXRPmMssp1lyKkq4c2aTZ+rhf6aBE=;
        b=DGbHvrJD+FBNfxbUkbjUutvr1Omfo1mJQtbQqTPi8OibX2RW5LONAB0LTea0QoPQky
         oM1MN1D2rqA6+j6aLzgGEeh00ZaaHeRqwBq6fBSVT5Dy1TTcBVXWt+7yH+UlkLx9ABxW
         qUWmNDYRS9kgE5YeSP7CIqhA2XCcOy54oAvrJfJQlCPAzF3f9dI+DX464OUOa4R8gg30
         Ts/nGRXTUvw4SVZOXDly/kqEj3EwXvFwnzUBXkIuEkWd0j/PzEDXX9ZZ6CWU4HHmqWZr
         ipP8B5WsEgJx/2piQktLQ16ySxiZ7BO9dnfCCqn2ab3tig31/qXe55Oo57mYZ+WgnAXp
         AIdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=etP17nW7gU7n0ssXRPmMssp1lyKkq4c2aTZ+rhf6aBE=;
        b=BdozhYsGL4oJCtJaTw7Q7YT/kIwhQrM+44Ji9MLLn0OId4KZMitcxW4KB6OqZKdxRN
         P1jFo12GYSHGC6eR3tOPvuEYpiBqkxbLfSI4Wt7e1nW8Q7gzDA8h9TnpEYnl9M4TKxM4
         GkfVFw+BWL3PuCdR2Y+adUSTXnva9tjjwkrE8RPttdntamVchbmd7emv6pX90e8WqSCK
         TpSXDy7bLxnLFY34NDUQKlrpULHBLhaNVuX33TilQRBLFzIFEAmA6qPCyuplNbUc0/6Z
         CdWLOGFklXRXwcEaLd0H0SJTssbIikpE93+eZUMaah9ryThPYJ9F4HfZN1LYdwrepwjt
         gZ7Q==
X-Gm-Message-State: APjAAAXoYeXwUP173WSzHFyC1NpYsojMFuRbcAb4ur9Uojb99ssx+OQT
        v7Ub9t6XhGVO33M+V6HF8Nl05ut1lUDjiBBQN+M=
X-Google-Smtp-Source: APXvYqxzL3e/9BcJ08u/srPjMHr8k65pXopI9p/OQ/XFmduHu0mEvn4TMtGmjOciEkQKpspYttm3q3UbBg0ND0fJG2Q=
X-Received: by 2002:adf:ebc1:: with SMTP id v1mr13321406wrn.351.1579721254260;
 Wed, 22 Jan 2020 11:27:34 -0800 (PST)
MIME-Version: 1.0
References: <1579612911-24497-1-git-send-email-sunil.kovvuri@gmail.com>
 <1579612911-24497-3-git-send-email-sunil.kovvuri@gmail.com> <20200121080029.42b6ea7d@cakuba>
In-Reply-To: <20200121080029.42b6ea7d@cakuba>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Thu, 23 Jan 2020 00:57:22 +0530
Message-ID: <CA+sq2Ce7nFbPu33Cu5YwgfEdfjOSWQwA1nijjtF7KKBYSph1TQ@mail.gmail.com>
Subject: Re: [PATCH v4 02/17] octeontx2-pf: Mailbox communication with AF
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
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

On Tue, Jan 21, 2020 at 9:30 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 21 Jan 2020 18:51:36 +0530, sunil.kovvuri@gmail.com wrote:
> > From: Sunil Goutham <sgoutham@marvell.com>
> >
> > In the resource virtualization unit (RVU) each of the PF and AF
> > (admin function) share a 64KB of reserved memory region for
> > communication. This patch initializes PF <=> AF mailbox IRQs,
> > registers handlers for processing these communication messages.
> > Also adds support to process these messages in both directions
> > ie responses to PF initiated DOWN (PF => AF) messages and AF
> > initiated UP messages (AF => PF).
> >
> > Mbox communication APIs and message formats are defined in AF driver
> > (drivers/net/ethernet/marvell/octeontx2/af), mbox.h from AF driver is
> > included here to avoid duplication.
> >
> > Signed-off-by: Geetha sowjanya <gakula@marvell.com>
> > Signed-off-by: Christina Jacob <cjacob@marvell.com>
> > Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> > Signed-off-by: Aleksey Makarov <amakarov@marvell.com>
> > Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
>
> >
> >  struct otx2_hw {
> > +
> > +     /* MSI-X*/
>                 ^
>
> The white space here is fairly loose
>

Will fix the white space issues.

> > +static inline void otx2_sync_mbox_bbuf(struct otx2_mbox *mbox, int devid)
> > +{
> > +     u16 msgs_offset = ALIGN(sizeof(struct mbox_hdr), MBOX_MSG_ALIGN);
> > +     void *hw_mbase = mbox->hwbase + (devid * MBOX_SIZE);
> > +     struct otx2_mbox_dev *mdev = &mbox->dev[devid];
> > +     struct mbox_hdr *hdr;
> > +     u64 msg_size;
> > +
> > +     if (mdev->mbase == hw_mbase)
> > +             return;
> > +
> > +     hdr = hw_mbase + mbox->rx_start;
> > +     msg_size = hdr->msg_size;
> > +
> > +     if (msg_size > mbox->rx_size - msgs_offset)
> > +             msg_size = mbox->rx_size - msgs_offset;
> > +
> > +     /* Copy mbox messages from mbox memory to bounce buffer */
> > +     memcpy(mdev->mbase + mbox->rx_start,
> > +            hw_mbase + mbox->rx_start, msg_size + msgs_offset);
>
> I'm slightly concerned about the use of non-iomem helpers like memset
> and memcpy on what I understand to be IOMEM, and the lack of memory
> barriers. But then again, I don't know much about iomem_wc(), is this
> code definitely correct from memory ordering perspective?
> (The memory barrier in otx2_mbox_msg_send() should probably be just
> wmb(), syncing with HW is unrelated with SMP.)

The mailbox region is a normal memory which is exposed to two devices
via PCI BARs.
And the writeq() call (to trigger IRQ) inside otx2_mbox_msg_send() has a wmb().

Thanks,
Sunil.
