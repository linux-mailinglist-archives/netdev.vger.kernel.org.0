Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7EA522203
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 19:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347024AbiEJROk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 13:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347787AbiEJROi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 13:14:38 -0400
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 308E91573A
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 10:10:41 -0700 (PDT)
Received: by mail-oo1-xc2a.google.com with SMTP id y22-20020a4acb96000000b0035eb01f5b65so3389002ooq.5
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 10:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MgM/pzUrZZptcnHK3AG1aAMcmTV2YO4Z5eL1tpBBNVY=;
        b=AqAQEL3GEwp1V4iYnS1+OSldYB7h0bHMrSR4l4qsy2/C8Z2ixGrrfKj0C1U7n1lNtb
         YlMKOPXHx7zSO9/xJB37CoraSRLBllEpYvYQmNhmX0HfrZlcKpDztkoxGpP2boH0UzAG
         k3ION27TKRIxgTEdM20Iz24sHcvm0kngLd31Q5f9VkyRxBIfmKKL1mZNa3OIO/Vi0Amc
         hZrd0xLws0ILKV+qMjYp/Yo8rffi/vMWKfuTnF3tfbgEDrT8dj6OlB3gSElcjpYVf3Hp
         d40fh4IglgPC9Kj5X+KF09W6t9uQ2i4+awPu4qHmj8zgzv7lQ9h6JNW29ky6zyb3Sxcy
         t7NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MgM/pzUrZZptcnHK3AG1aAMcmTV2YO4Z5eL1tpBBNVY=;
        b=JVRsFFkZn7Vsw2e+PkGBb0Mot9e+xWcvMJvKQ1FcHUwpkiQMUzbw3xX1I7wBdh4IrD
         4ml4H8+2b7O9nbJjxZcr4SMMMdXH6d4NzCvKkTJBzyS2+UH2zTkdpdU7meWxta5KZP1Y
         f2hGanQRCaOfSd+8Ny29wX+ttOUGzYD9jeKEdNiNFBC9my2gWrquAhZGb7YLynos5u0F
         qsZYuBTUTDuWP3XtBk/oi93H/NZh50IoT2gjdQeorMPHJ+KJ/j745fx3fJt0XdlFhJkX
         r83ukLuyEEmu7WRctU8O2tC80/9KNGocAfIhN4tOsVgeTmt1pMbBi9p1uaYufIhL3cns
         my0g==
X-Gm-Message-State: AOAM533g1vmL/NqgsFHX4qubUCIQCR30h28UM/lpR6jUuriMUvXdeia0
        64aCiyyTytDCzST+wPD6H6C4QlLvqyKw6ie9Yhk=
X-Google-Smtp-Source: ABdhPJyTv6UwWp5O5Ei74tMCYj6+578jlmqd0CF1weePrAERks5G9E+c6+KHAklJRDT1pm+EbOC/ktNG9YGEWpSKWrk=
X-Received: by 2002:a9d:5550:0:b0:605:f2b4:e6d2 with SMTP id
 h16-20020a9d5550000000b00605f2b4e6d2mr8231795oti.46.1652202640547; Tue, 10
 May 2022 10:10:40 -0700 (PDT)
MIME-Version: 1.0
References: <e448120735d71f16ca3e1e845730f7fc29e71ea1.1651861213.git.lucien.xin@gmail.com>
 <20220509180712.22f4a3a7@kernel.org>
In-Reply-To: <20220509180712.22f4a3a7@kernel.org>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 10 May 2022 13:10:04 -0400
Message-ID: <CADvbK_dKQSnmn3z41=88Zoa4xGf55G59Y_ocAtoaJh=Y4JGw+A@mail.gmail.com>
Subject: Re: [PATCH net] Documentation: add description for net.core.gro_normal_batch
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     network dev <netdev@vger.kernel.org>, davem <davem@davemloft.net>,
        Edward Cree <ecree@solarflare.com>
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

On Mon, May 9, 2022 at 9:07 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri,  6 May 2022 14:20:13 -0400 Xin Long wrote:
> > Describe it in admin-guide/sysctl/net.rst like other Network core options.
> > Users need to know gro_normal_batch for performance tuning.
> >
> > Fixes: 323ebb61e32b ("net: use listified RX for handling GRO_NORMAL skbs")
> > Reported-by: Prijesh <prpatel@redhat.com>
>
> Does Prijesh have a last name? :)
'Prijesh <prpatel@redhat.com>' is what I got from his emails.
But yes, he has. 'Prijesh Patel'.

>
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  Documentation/admin-guide/sysctl/net.rst | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >
> > diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
> > index f86b5e1623c6..d8a8506f31ad 100644
> > --- a/Documentation/admin-guide/sysctl/net.rst
> > +++ b/Documentation/admin-guide/sysctl/net.rst
> > @@ -374,6 +374,16 @@ option is set to SOCK_TXREHASH_DEFAULT (i. e. not overridden by setsockopt).
> >  If set to 1 (default), hash rethink is performed on listening socket.
> >  If set to 0, hash rethink is not performed.
> >
> > +gro_normal_batch
> > +----------------
> > +
> > +Maximum number of GRO_NORMAL skbs to batch up for list-RX. When GRO decides
> > +not to coalesce a packet, instead of passing it to the stack immediately,
> > +place it on a list.
>
> That makes it sounds like only packets which were not coalesced
> go on the list. IIUC everything goes on that list before traveling
> up the stack, no?
I think the difference is these ones held/merged go to gro_list first
and get merged there, then go to the list. I can change it to:

"place it on a list where the coalesced packets also eventually go"

looks good?

>
> > +Pass this list to the stack at flush time or whenever
>
> This sentences is in second person, and the previous one was in third
> person.
how about "the list will be passed to stack at flush time..." ?

>
> > +the number of skbs in this list exceeds gro_normal_batch.
>
> s/skbs/segments/
right.

Thanks.

>
> > +Default : 8
> > +
> >  2. /proc/sys/net/unix - Parameters for Unix domain sockets
> >  ----------------------------------------------------------
> >
>
