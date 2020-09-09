Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69EEA263297
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 18:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731110AbgIIQqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 12:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730939AbgIIQHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 12:07:40 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D63F6C061366;
        Wed,  9 Sep 2020 07:09:20 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id a9so1399018pjg.1;
        Wed, 09 Sep 2020 07:09:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TJE+289hTtvntUk1HLKGYW6MtyXveHeXW/D3sjIxKq4=;
        b=MlRa/+NvY7M7jOTHavH3Q9lFy080yJFraBQL31+lHwWOT6k0/OBgero6SovD+zMNz9
         cT6t9IIh1i5RiFnrl61GU20SItXDEcQGpdekXUSQvQTr5mQe9LFrCV2XNmn1TEWk1sm+
         VOZi3Yd+iiwz1yZiPP0glVniCzUS9JbrmfLiz9qGXbCrKLouBM3VqofQxer4SWMNbzKL
         AscCw5p2Wc9xNMnoeLJ3AjBgI8wOvGDJS7OYmpZ/vg2EUYB0GXPcDJ37BwidJTm2fqH8
         4UM44a4Jjw6LUwRFUj+D7MPQ7FIVhQT+uCjCdWGeyabOGLF1SGBD8kyvB40x2/hL2vx0
         F1Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TJE+289hTtvntUk1HLKGYW6MtyXveHeXW/D3sjIxKq4=;
        b=tNXvd1jIvxoBtV2dxAxfyP/gRIoCUbyqjec9TP80hmetvdRiihfOtgU79+HQSVrxRg
         36GaTqTUyAgZ2uZLLvYwaEStUjUEro1DUd9WbpUGtyfTYS3+/Ylf6/8e8DZ2grLRKaaU
         n5i7/ghXV0qs3GwwjNjV8v7UX1h2qX8Pk5vG+zvzqFQOFKUEj9gs6qYFqmiGr0y4XeYw
         Z6HBZBgchz97LRPXvfDsmGO5h0/u304Z2ovskhMKOO3TuNPxAzcXB4v07dQjJv2/SADh
         lG42cYtfHtsPOSvVpzjL38nqtjZdX+ovba6znkEnS2HJBeeheBMag4cVtOEViL8KhJxm
         p5BA==
X-Gm-Message-State: AOAM530RRqW2eRovor1iHL57fQFNeeyGKHEqLrY5IwWClDUnlmVf0cvO
        GdB/GEpiNWGxMDDTYd+OLy3UGZM71N4Ff4RFHdQ=
X-Google-Smtp-Source: ABdhPJwiYdvRQa2vATilMGyvAGfRasPZniD+zOzkWLhLPHuVpgDISM2BAExE/4PtItREzaOstqA46Wd999dfE0PiR5U=
X-Received: by 2002:a17:90a:b387:: with SMTP id e7mr1018362pjr.228.1599660560292;
 Wed, 09 Sep 2020 07:09:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200904165222.18444-1-vadym.kochan@plvision.eu>
 <20200904165222.18444-2-vadym.kochan@plvision.eu> <CAHp75Vc_MN-tD+iQNbUcB6fbYizyfKJSJnm1W7uXCT6JAvPauA@mail.gmail.com>
 <20200908083514.GB3562@plvision.eu> <CAHp75VdyahsNyOK9_7mFGHFg_O47jVQWro-mhU0n=1K17Eeg8Q@mail.gmail.com>
 <20200909140043.GB20411@plvision.eu>
In-Reply-To: <20200909140043.GB20411@plvision.eu>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 9 Sep 2020 17:09:02 +0300
Message-ID: <CAHp75Ve+JOaN=_B+a_oUF+iMT=VMw2wMrqCS5r-EbACwEmWKfw@mail.gmail.com>
Subject: Re: [PATCH net-next v7 1/6] net: marvell: prestera: Add driver for
 Prestera family ASIC devices
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mickey Rachamim <mickeyr@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 9, 2020 at 5:00 PM Vadym Kochan <vadym.kochan@plvision.eu> wrote:
> On Tue, Sep 08, 2020 at 12:38:04PM +0300, Andy Shevchenko wrote:
> > On Tue, Sep 8, 2020 at 11:35 AM Vadym Kochan <vadym.kochan@plvision.eu> wrote:
> > > On Fri, Sep 04, 2020 at 10:12:07PM +0300, Andy Shevchenko wrote:
> > > > On Fri, Sep 4, 2020 at 7:52 PM Vadym Kochan <vadym.kochan@plvision.eu> wrote:

...

> > > > > +                       if (b == 0)
> > > > > +                               continue;
> > > > > +
> > > > > +                       prestera_sdma_rx_desc_set_next(sdma,
> > > > > +                                                      ring->bufs[b - 1].desc,
> > > > > +                                                      buf->desc_dma);
> > > > > +
> > > > > +                       if (b == PRESTERA_SDMA_RX_DESC_PER_Q - 1)
> > > > > +                               prestera_sdma_rx_desc_set_next(sdma, buf->desc,
> > > > > +                                                              head->desc_dma);
> > > >
> > > > I guess knowing what the allowed range of bnum the above can be optimized.
> > > >
> > > You mean to replace PRESTERA_SDMA_RX_DESC_PER_Q by bnum ?
> >
> > I don't know what you meant in above. It might be a bug, it might be
> > that bnum is redundant and this definition may be used everywhere...
> > But I believe there is room for improvement when I see pattern like
> >
> >   for (i < X) {
> >     ...
> >     if (i == 0) {
> >       ...
> >     } else if (i == X - 1) {
> >       ...
> >     }
> >   }
> >
> > Either it can be while-loop (or do-while) with better semantics for
> > the first and last item to handle or something else.
> > Example from another review [1] in case you wonder how changes can be
> > made. Just think about it.
> >
> > [1]: https://www.spinics.net/lists/linux-pci/msg60826.html (before)
> > https://www.spinics.net/lists/linux-pci/msg62043.html (after)
> >
>
> I came up with the following approach which works:
>
> -------------->8------------------------------------------------
> tail = &ring->bufs[bnum - 1];
> head = &ring->bufs[0];
> next = head;
> prev = next;
> ring->next_rx = 0;
>
> do {
>         err = prestera_sdma_buf_init(sdma, next);
>         if (err)
>                 return err;
>
>         err = prestera_sdma_rx_skb_alloc(sdma, next);
>         if (err)
>                 return err;
>
>         prestera_sdma_rx_desc_init(sdma, next->desc, next->buf_dma);
>
>         prestera_sdma_rx_desc_set_next(sdma, prev->desc, next->desc_dma);
>
>         prev = next;
>         next++;
> } while (prev != tail);
>
> /* make a circular list */
> prestera_sdma_rx_desc_set_next(sdma, tail->desc, head->desc_dma);
> --------------8<------------------------------------------------
>
> Now it looks more list-oriented cyclic logic.

And much better, thanks!

Note, you have two places in the code with something similar (I mean
loop handling), perhaps you may improve both.

-- 
With Best Regards,
Andy Shevchenko
