Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF73E1D4F4C
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 15:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726228AbgEONcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 09:32:51 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:39195 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbgEONcu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 09:32:50 -0400
Received: from mail-qv1-f54.google.com ([209.85.219.54]) by
 mrelayeu.kundenserver.de (mreue009 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1N8GIa-1j4jqL03iy-0148bL; Fri, 15 May 2020 15:32:49 +0200
Received: by mail-qv1-f54.google.com with SMTP id p4so1036078qvr.10;
        Fri, 15 May 2020 06:32:48 -0700 (PDT)
X-Gm-Message-State: AOAM533LC1JhRL8lBvEYosRM/J8mL0QJapJt9PSOWop9bWdP0bC6/eRk
        yd+VsM6iU/j2hJQvBX0zTgy6w+UKWY+IFV6U63I=
X-Google-Smtp-Source: ABdhPJxRaY7zY8QTvNzuxerWSaqGbHKOK4FIyf/5qJLFxDuhmkrh8pWdFCVTHGQsHaBEpA8LvsOh8UJboFLS9sON+fo=
X-Received: by 2002:a0c:eb11:: with SMTP id j17mr3448680qvp.197.1589549567720;
 Fri, 15 May 2020 06:32:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200514075942.10136-1-brgl@bgdev.pl> <20200514075942.10136-11-brgl@bgdev.pl>
In-Reply-To: <20200514075942.10136-11-brgl@bgdev.pl>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 15 May 2020 15:32:31 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0XgJtZNKePZUUpzADO25-JZKyDiVHFS_yuHRXTjvjDwg@mail.gmail.com>
Message-ID: <CAK8P3a0XgJtZNKePZUUpzADO25-JZKyDiVHFS_yuHRXTjvjDwg@mail.gmail.com>
Subject: Re: [PATCH v3 10/15] net: ethernet: mtk-eth-mac: new driver
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     Jonathan Corbet <corbet@lwn.net>, Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Fabien Parent <fparent@baylibre.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        DTML <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC..." 
        <linux-mediatek@lists.infradead.org>,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:/5ofnXw9mU5dIgLefv/eRsDvP8+vTrIU+kLDXUGITnkQuWac4Lv
 lCUzHqRE2GvIKbgKOqokob5YjwHyKX97w0rAAWhXtQOfANy41OWqbOBppqecviSzLFkmNz+
 2baHX4ARSd0lXB90Re+J/7eya76FB9t4m55bGplGQ+RfBZSx9IL4TuVFvxJp5ov/6iHHmpn
 4slNhioblUkWT2Ewt3K6Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:PSBO+4J/98g=:gGROTXY0ptE/pYUSwwvuox
 LQJix53g2u4f43J6wPGIlXEN9Sfdb91HjNyChil2D95CJzrRnaWlVruZOo55mgKhe92Ohy/yg
 87OxKYoBj1Mb2P4J3L/V3fwqP/gav9cVeaxsCo20ZFaZKoDvkYvfSlIPYU3uurK/xeEFAMAbt
 qTjRN9SdEVq/n4qttKKMYTG9tw1Shau5JApHNfoB7BxtG3qf9SbAGxOsqaARuc47qUYax1dZ6
 1578a9XMcwHoKjC8rsWVu3m9WcdNS0qVH9VIH+rzArN+G81B1CaboTmEgNF2cPqd9xRvMp/Oz
 7EA5phTtB26zA7YNb5q6Zv55A0kKSfzPK571gneJm4rDtsS8/J3JbjXme+g8hKNmUH4xQN2yS
 iDZLbWuwlWzjeKIeMxXkK8QMGCaN0sHeY0/LtUgY8BVQ+unPpjmLQC3ry/CyVIKmEZkrWEkGR
 Xce+CMpI83rqIg857MjSgpzciN7wok2nNy0BPk8DJZb9HOjlpUxE0szWAxIn5VjzOsVZhTSLi
 3m/Z6AUId97YB+eqRUNSHlLaam1G55PHrKKd80C8B0vLof15lLICwSnOQi33wDKI8vO4/WT/t
 BGRcMNIu1vThyBFAC2NRdPVihx7d37eDljyoIJRK4o1OpPhV/daih5x8HZQkE4ftEFRFBNcwe
 vtAgLAJdJcS/SsDR+JCwKabWvHHbCJItJfZT0uRLp71Imow6FV5+a3LR7CMEKbFSVfv3U8p7F
 rhiCgx08UIIgJbUEGAZm4+lL+yaVY+NZPwhReHOUocFaLcjNfELZBJkcAbWJ+Qiicg08kgcv/
 xV8uJmISTCGfylAtb0x0tUGlBv+WL8b/dblBJFamBW0aVbHB00=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 10:00 AM Bartosz Golaszewski <brgl@bgdev.pl> wrote:
> +static int mtk_mac_ring_pop_tail(struct mtk_mac_ring *ring,
> +                                struct mtk_mac_ring_desc_data *desc_data)

I took another look at this function because of your comment on the locking
the descriptor updates, which seemed suspicious as the device side does not
actually use the locks to access them

> +{
> +       struct mtk_mac_ring_desc *desc = &ring->descs[ring->tail];
> +       unsigned int status;
> +
> +       /* Let the device release the descriptor. */
> +       dma_rmb();
> +       status = desc->status;
> +       if (!(status & MTK_MAC_DESC_BIT_COWN))
> +               return -1;

The dma_rmb() seems odd here, as I don't see which prior read
is being protected by this.

> +       desc_data->len = status & MTK_MAC_DESC_MSK_LEN;
> +       desc_data->flags = status & ~MTK_MAC_DESC_MSK_LEN;
> +       desc_data->dma_addr = ring->dma_addrs[ring->tail];
> +       desc_data->skb = ring->skbs[ring->tail];
> +
> +       desc->data_ptr = 0;
> +       desc->status = MTK_MAC_DESC_BIT_COWN;
> +       if (status & MTK_MAC_DESC_BIT_EOR)
> +               desc->status |= MTK_MAC_DESC_BIT_EOR;
> +
> +       /* Flush writes to descriptor memory. */
> +       dma_wmb();

The comment and the barrier here seem odd as well. I would have expected
a barrier after the update to the data pointer, and only a single store
but no read of the status flag instead of the read-modify-write,
something like

      desc->data_ptr = 0;
      dma_wmb(); /* make pointer update visible before status update */
      desc->status = MTK_MAC_DESC_BIT_COWN | (status & MTK_MAC_DESC_BIT_EOR);

> +       ring->tail = (ring->tail + 1) % MTK_MAC_RING_NUM_DESCS;
> +       ring->count--;

I would get rid of the 'count' here, as it duplicates the information
that is already known from the difference between head and tail, and you
can't update it atomically without holding a lock around the access to
the ring. The way I'd do this is to have the head and tail pointers
in separate cache lines, and then use READ_ONCE/WRITE_ONCE
and smp barriers to access them, with each one updated on one
thread but read by the other.

     Arnd
