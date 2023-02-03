Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82A1868A70C
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 00:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232802AbjBCXuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 18:50:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232375AbjBCXup (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 18:50:45 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC03B627AA;
        Fri,  3 Feb 2023 15:50:43 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id mf7so19647222ejc.6;
        Fri, 03 Feb 2023 15:50:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gOrsPhcpzWEq2PcdjbKFApKHFuTiUGlYuSEdAr9vzSA=;
        b=ZAfyu43MSVYff52t9LKybrPfV7bkeFgC5Uchf2kG3yIJkgCx+9x/Lk6gQIrzFjMUn/
         5Y3tJjt1BHFS3iWBLIE6M6ZgXBtdfpcmLmjky1rY5r8iVfzNvCtgWWJrLji7VJhext6T
         uZpRLenaOJCY8sjoared70nx0YMbrGdP3foZHSID+cvYrpdqtzzOdA5m0YVrXJaC1fDh
         oj4O/iaSsIwd864u/lRfSuQ9ioYNiF9GxvWFPclI3aGWVZ24j3iDBgDPQKbvOlqLQVpn
         g+cDONZC/z+BpceeIcKi1+NWkl8RyrzGImrYPDrO9/gqBro1c5jSM1QimZ9erbogTc3y
         MXYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gOrsPhcpzWEq2PcdjbKFApKHFuTiUGlYuSEdAr9vzSA=;
        b=nbF6RnCthfrl2g2M/4yCl94WWipRLEjLLHkPlRD2Asp5ieBLJks9MuYE78AmGvNzAX
         gpNGj7rH9sBitFf4Azr3qkRVkHYapbMG6PWFrIbgQlESmIww2ykau0jzAMsY7w52qD95
         +aYUmV1MtFilnv71xkPvv8m7HdlYifZ/AvEd6LiVY2wyrTsPtwjzi2GFD2ok3c4NFWEk
         3KkVB+rbc5fNM1dZu8OuK6LDw2C79ov+9MI/uj3X3guN01jSFDsLOGkiZdie9bJkTqIL
         vRsffN2bgfQEX8RYqPHb79fd1B+eVRE/1lmhd6mop2rwxC8TshCD0NeEvqvS/fu2qlGg
         5kjA==
X-Gm-Message-State: AO0yUKVGYIagvwlbiNw15RgnNsrHv/A4PcFdHsHu043YZ0fWnb5Nu8/K
        KVsgtYshvEb4Kucc2Cgu4F+P8pImNtfung5vYZY=
X-Google-Smtp-Source: AK7set9O5rc94Ldp5+Ji252ZVIitA8/2FF89pBrJW7KTM+Kv1zAEAhmxsVOgd7abkYlWUImBH4y8FzoWqM+ITlZFKO8=
X-Received: by 2002:a17:906:6d13:b0:878:786e:8c39 with SMTP id
 m19-20020a1709066d1300b00878786e8c39mr3707005ejr.105.1675468242181; Fri, 03
 Feb 2023 15:50:42 -0800 (PST)
MIME-Version: 1.0
References: <cover.1675245257.git.lorenzo@kernel.org> <7c1af8e7e6ef0614cf32fa9e6bdaa2d8d605f859.1675245258.git.lorenzo@kernel.org>
 <CAADnVQLTBSTCr4O2kGWSz3ihOZxpXHz-8TuwbwXe6=7-XhiDkA@mail.gmail.com> <Y91GLP4LCqsGE8kX@localhost.localdomain>
In-Reply-To: <Y91GLP4LCqsGE8kX@localhost.localdomain>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 3 Feb 2023 15:50:30 -0800
Message-ID: <CAADnVQKnTzfDuZL0BD9sONeR2jEnQr=mD8kwWHqdaz9dv8VQRA@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 8/8] selftests/bpf: introduce XDP compliance
 test tool
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Marek Majtyka <alardam@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>, anthony.l.nguyen@intel.com,
        Andy Gospodarek <gospo@broadcom.com>, vladimir.oltean@nxp.com,
        Felix Fietkau <nbd@nbd.name>, john@phrozen.org,
        Leon Romanovsky <leon@kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        Ariel Elior <aelior@marvell.com>,
        christophe.jaillet@wanadoo.fr, ecree.xilinx@gmail.com,
        "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Stanislav Fomichev <sdf@google.com>,
        gerhard@engleder-embedded.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 3, 2023 at 9:35 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> > On Wed, Feb 1, 2023 at 2:25 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> > >
> > > Introduce xdp_features tool in order to test XDP features supported by
> > > the NIC and match them against advertised ones.
> > > In order to test supported/advertised XDP features, xdp_features must
> > > run on the Device Under Test (DUT) and on a Tester device.
> > > xdp_features opens a control TCP channel between DUT and Tester devices
> > > to send control commands from Tester to the DUT and a UDP data channel
> > > where the Tester sends UDP 'echo' packets and the DUT is expected to
> > > reply back with the same packet. DUT installs multiple XDP programs on the
> > > NIC to test XDP capabilities and reports back to the Tester some XDP stats.
> >
> >
> > 'DUT installs...'? what? The device installs XDP programs ?
>
> Hi Alexei,
>
> DUT stands for Device Under Test, I was thinking it is quite a common term.
> Sorry for that.

It was clear from the commit log.
My point was not questioning whether abbreviation is common or not.
It's this:
"device under test installs...". device installs? No. device doesn't
install anything. It's xdp_features tool attaches a prog to the
device.

and more:
"device under test socket"... what does it even mean?

> >
> > > +
> > > +       ctrl_sockfd = accept(*sockfd, (struct sockaddr *)&ctrl_addr, &addrlen);
> > > +       if (ctrl_sockfd < 0) {
> > > +               fprintf(stderr, "Failed to accept connection on DUT socket\n");
> >
> > Applied, but overuse of the word 'DUT' is incorrect and confusing.
> >
> > 'DUT socket' ? what is that?
> > 'Invalid DUT address' ? what address?
> > The UX in general is not user friendly.
> >
> > ./xdp_features
> > Invalid ifindex
> >
> > This is not a helpful message.
> >
> > ./xdp_features eth0
> > Starting DUT on device 3
> > Failed to accept connection on DUT socket
> >
> > 'Starting DUT' ? What did it start?
>
> I will post a follow-up patch to clarify them.
>
> Regards,
> Lorenzo
