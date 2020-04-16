Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED02C1ACC5C
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 18:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895990AbgDPP65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 11:58:57 -0400
Received: from mout.kundenserver.de ([217.72.192.75]:41347 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2895850AbgDPP6w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 11:58:52 -0400
Received: from mail-qk1-f170.google.com ([209.85.222.170]) by
 mrelayeu.kundenserver.de (mreue108 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MNso2-1jaCjx2SnQ-00OGie; Thu, 16 Apr 2020 17:58:49 +0200
Received: by mail-qk1-f170.google.com with SMTP id o19so14496656qkk.5;
        Thu, 16 Apr 2020 08:58:49 -0700 (PDT)
X-Gm-Message-State: AGi0PuZ2KdLVAVbdkKvggkA12EKvnomfG7hGlLVN8SvY09KMHhQMhu5G
        Fk9PEpVHam3/+dhMMl3BELWq1nn2ymFMSscbLAI=
X-Google-Smtp-Source: APiQypKGrakVFJpHU6+2/9ubHFZSVsfORqHq+Dek4jgUuB+FQt0sMX/hFlCLPEJjO3Byfz+ywXPktI2/F+cmyK0/LA8=
X-Received: by 2002:a37:851:: with SMTP id 78mr32467282qki.352.1587052728173;
 Thu, 16 Apr 2020 08:58:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200414132900.GD5100@ziepe.ca> <CAK8P3a0aFQ7h4zRDW=QLogXWc88JkJJXEOK0_CpWwsRjq6+T+w@mail.gmail.com>
 <20200414152312.GF5100@ziepe.ca> <CAK8P3a1PjP9_b5NdmqTLeGN4y+3JXx_yyTE8YAf1u5rYHWPA9g@mail.gmail.com>
 <f6d83b08fc0bc171b5ba5b2a0bc138727d92e2c0.camel@mellanox.com>
 <CAK8P3a1-J=4EAxh7TtQxugxwXk239u8ffgxZNRdw_WWy8ExFoQ@mail.gmail.com>
 <834c7606743424c64951dd2193ca15e29799bf18.camel@mellanox.com>
 <CAK8P3a3Wx5_bUOKnN3_hG5nLOqv3WCUtMSq6vOkJzWZgsmAz+A@mail.gmail.com>
 <874ktj4tvn.fsf@intel.com> <CAK8P3a1S2x1jnx9Q5B22vX8gBHs0Ztu-znA9hqZ5xp5tRAykGg@mail.gmail.com>
 <20200416145235.GR5100@ziepe.ca>
In-Reply-To: <20200416145235.GR5100@ziepe.ca>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 16 Apr 2020 17:58:31 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3HwFYKfZftm2fWE=Lzi486rXpMBwjy1F4oohYU2+o7-g@mail.gmail.com>
Message-ID: <CAK8P3a3HwFYKfZftm2fWE=Lzi486rXpMBwjy1F4oohYU2+o7-g@mail.gmail.com>
Subject: Re: [RFC 0/6] Regressions for "imply" behavior change
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Jani Nikula <jani.nikula@linux.intel.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "narmstrong@baylibre.com" <narmstrong@baylibre.com>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "Laurent.pinchart@ideasonboard.com" 
        <Laurent.pinchart@ideasonboard.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nico@fluxnic.net" <nico@fluxnic.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "kieran.bingham+renesas@ideasonboard.com" 
        <kieran.bingham+renesas@ideasonboard.com>,
        "a.hajda@samsung.com" <a.hajda@samsung.com>,
        "jonas@kwiboo.se" <jonas@kwiboo.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "jernej.skrabec@siol.net" <jernej.skrabec@siol.net>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:NvuMKkUOlsrp2prjXUqiJgwl2fFGba1tjbVPgdJTXH3/mhN0MMO
 V1nblPlClntAmE57yT9m+FF7dqNXEKFVfWA1yfdb6htAepBEPga8nvSndR5RyyuJ0SOgU3a
 QfXMeh6PgxUfxNwK/RiPHCUwXPvl83ppSySAWgOh356/NJb2EEBRIuhmfA8++gpR3FWDhjf
 +ipZITRcVMeuNVkejH/PA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:nLLF9c2uOC4=:CO3B1+y57PnWI3KAQsNtp+
 XOVUMAJLv1uP+nnwoMyOUjWAMxhCA6kUHH7SUVTnLLwkWYun6Il50xBEv34zL2Pb8WHHTGI7T
 KfT2u4SNrBxbBee4PnMm40NQ9ECxnvLlIulMqwAvSgEk1DuxD5reTyl3t1lzxx9EISnrshAXm
 zglvRnqi7s3epUZv4BqyE7xXeQA08X27PykRNW3RRioJR6KiGmdmSZOal6A6x2dudQtzITvRJ
 TSsGr3s6vQJbaMOzjFeLsrA7TDOdOeSo1kodMSS1grC3HuUUcmrDHwPp8HFTk13vaSl2vOaKt
 9Fn6p8mFjguKEDBuECGUV2yHLUhUHRd59j/oVymQC6d5TWMgmIYQ6Hn+vdoVovyQcxzQ/aLGO
 4LsMntB1DvHXkkeN/vfkjbf4LnvXwe4CGneR0xG2PSa9m81qHrN1cMPYCBH6F2sLz+IJbYX/q
 nbtMESTGcTyvqvPye/VfuXNBj2UD83hkLtAE2n2o+My9LfSXib/AdERcqp1Xp9YzN/zqxEyF/
 NWRLC47HtdeXVdeCr631fjjqSZZK7wYG6kb/QO1p5FZKWhrvoTr/Ehtvpe/5UdUrWSZ7hUJ1x
 YTOC3D2zs3dNhYmNwlO5qNUv6Nia+657JxMI6xtbpxastY9GwIQYixo8NoEvjcnr218KwnY9Y
 fXk/dLaeKc862FyZie5AQfE4Bfp2WT9FV7cRG6hH0QjPK4mPGXto/QzH60dNsl43z+0OinG4H
 gAB32EphIxXK56OMN4KW/RI6RYOPkcDnjM/pTu+XibtSbRtDYFYJyOellq8Kx/mS8jT/8JyaW
 Av3FXArCl/gJb7EVEeywqp9NPDw1Z2n/lzxFR28MPRyqkMehXU=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 16, 2020 at 4:52 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> On Thu, Apr 16, 2020 at 02:38:50PM +0200, Arnd Bergmann wrote:
> > On Thu, Apr 16, 2020 at 12:17 PM Jani Nikula <jani.nikula@linux.intel.com> wrote:
> > > Of course, this is all just talk until someone(tm) posts a patch
> > > actually making the change. I've looked at the kconfig tool sources
> > > before; not going to make the same mistake again.
> >
> > Right. OTOH whoever implements it gets to pick the color of the
> > bikeshed. ;-)
>
> I hope someone takes it up, especially now that imply, which
> apparently used to do this, doesn't any more :)

The old 'imply' was something completely different, it was more of a
'try to select if you can so we can assume it's there, but give up
if it can only be a module and we need it to be built-in".

        Arnd
