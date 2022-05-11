Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE7BF523A31
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 18:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235830AbiEKQVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 12:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344654AbiEKQU5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 12:20:57 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93FDB165B8
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 09:20:56 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id v66so3314251oib.3
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 09:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tyx1KvrGBxm1g2acHLuIjqZ6K/8R5HMpHxYsaRYTcbo=;
        b=cQ65bcvHGy9eRHGH1aLGXhGLxsOWzhTw+vQ30OJeEeFUhhMOHaqZR6GSqUGQ9q+LTv
         7fLr/MWezqVkjK3B42lzPt0G6x6x3UDAFIuxO+ArAkjy/5bFw7QJE+FmspyE25UF+CGG
         9s2q8Emw5J7surPHz8M7bukc4jt6w7tpvxg5aSUywiqX2Ncev74bjBu0D1Ilnj6uoZUF
         pSvnj2StO2ZS9Ea2Px0IdEKYCTeFMNIXgpyg0KKqFJ90dHzzzqqQrpP0jCpta5uKOXih
         JCw9X8hxXbOSMoms1ddEcUmr+gKA9HXMX+ZQ850XcAQtCHutWnwMK2Xxv10ch7YsQmxU
         MuLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tyx1KvrGBxm1g2acHLuIjqZ6K/8R5HMpHxYsaRYTcbo=;
        b=mh9ExK/AuVqYLi4bJBhcvgzCvkc3l1QSqd9uPu2HG6MaofkwOfaApnoKTKzOwn1bpt
         wFkBC4EOaLHJbc7KMKVB86jQypqhhHQHKhX7uBr547MMDHQcGDWA3fj4wy/g5Bc2u4Hk
         ASDVQdAd25cI0dXrMhA9tngDWb93gEsBOEuPawvz2eH+M3YXBggKti6/apKANEhHBImb
         vzwOWjdaBCfyLSioCaUyVqzScYKE5vLpWw/zmnBf0U+xJkBsDiVFex2dQ/k8w/CS7YJU
         vzj3F4DEBlBTCIKeC5g5p400GZHbBvFgtV1d6uOG/qlUyufpwHjCOEzpwTT4eqqGaz90
         u8oQ==
X-Gm-Message-State: AOAM533iQWipZnpDt1qoHzPKURt8eLlOG7TRlWw0QHtGv44DvaE57XCY
        YjldL6Kg/R9+gAk/Y/UssO13ftv4rpOwWtvTLMw=
X-Google-Smtp-Source: ABdhPJzRo6pwWcMnE/R4lqFBLtAE3W92aX98p7mXb9C/3eMgOQuwCrkcYyA1144NXqmlRo8gLOcLlJ/Uqj9PSaNA7jg=
X-Received: by 2002:aca:5941:0:b0:2f7:5c90:ad61 with SMTP id
 n62-20020aca5941000000b002f75c90ad61mr2992820oib.190.1652286055948; Wed, 11
 May 2022 09:20:55 -0700 (PDT)
MIME-Version: 1.0
References: <e448120735d71f16ca3e1e845730f7fc29e71ea1.1651861213.git.lucien.xin@gmail.com>
 <20220509180712.22f4a3a7@kernel.org> <CADvbK_dKQSnmn3z41=88Zoa4xGf55G59Y_ocAtoaJh=Y4JGw+A@mail.gmail.com>
 <11f25fef-e551-f72c-223d-c3d072a3a94d@xilinx.com>
In-Reply-To: <11f25fef-e551-f72c-223d-c3d072a3a94d@xilinx.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 11 May 2022 12:20:16 -0400
Message-ID: <CADvbK_f1B-HjSu1w7VX2=8KPkw+ecLf1aOfgcmcp48MGQNQEig@mail.gmail.com>
Subject: Re: [PATCH net] Documentation: add description for net.core.gro_normal_batch
To:     Edward Cree <edward.cree@xilinx.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        network dev <netdev@vger.kernel.org>,
        davem <davem@davemloft.net>, Edward Cree <ecree@solarflare.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 10, 2022 at 1:42 PM Edward Cree <edward.cree@xilinx.com> wrote:
>
> On 10/05/2022 18:10, Xin Long wrote:
> > On Mon, May 9, 2022 at 9:07 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >> That makes it sounds like only packets which were not coalesced
> >> go on the list. IIUC everything goes on that list before traveling
> >> up the stack, no?
> > I think the difference is these ones held/merged go to gro_list first
> > and get merged there, then go to the list. I can change it to:
> >
> > "place it on a list where the coalesced packets also eventually go"
> >
> > looks good?
>
> Maybe it'd be clearer to say something like
> "when a packet exits GRO, either as a coalesced superframe or as an
>  original packet which GRO has decided not to coalesce, it is placed on
>  a per-NAPI list.  This list is then passed to the stack when..." etc.
> Ideally also mention the fact that a coalesced superframe counts as
>  napi_gro_cb.count towards the gro_normal_batch limit, not just 1.
Thanks, ed.

I'd say "...when the segments in this list count towards the
gro_normal_batch limit." only
(too many details involved may confuse users)

will post v2.
