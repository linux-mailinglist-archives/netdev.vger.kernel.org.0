Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5666F50E03A
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 14:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241847AbiDYM2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 08:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241890AbiDYM0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 08:26:52 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A85563BD8;
        Mon, 25 Apr 2022 05:22:38 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id x17so25836079lfa.10;
        Mon, 25 Apr 2022 05:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q+5T1iKAozssuLKi38LNlFH4ednefJJfAeRf0+hMLKM=;
        b=ZJC7SNXPrwQof0ANRY0Yj3olqdWPMt1ZrYJB2v3Y6B9lUxDC3sqNr/iLmmEYiAHXaz
         3TmuukiHSNLldCoD5pseMU8pP7gdk/2GcDVHr2QXpweKl1AEIH/pA+Tj4ZgcWRoaoTVQ
         JsKPklcHCwYtmlEpViGfXYuSZmu4bCT01ym0S1X+pjkL6aLwr/8GflSQ4OfMO7VBvjs3
         KtlcWy+q1W/TZlks8SFqbx6btQ3prH+QF0cTZR0jQLlNcLTap7vwOJI+UMmEm50mkwRz
         qlZI2DbYzT1fX/L7HG0SmO7ZWR+eNn5SaEgT2MN8hNnH5NHsJ+5v4ngUSTNyM6HMMkN5
         hX1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q+5T1iKAozssuLKi38LNlFH4ednefJJfAeRf0+hMLKM=;
        b=pgtahnOZ6UaqGiGO9E2gAkF9FpcDpjvv7w3cokCRciNCHCAHwql55TDPMOTJn8V/KJ
         5Mg8SyQ5++X1Eea72R30lkwxK/efjzdkj9egI8sqEVbQeBQhInkUqmLah1SRD9nil9xN
         e6S6o9wH5423h8wDoHfQj/bWdR92iQIzsO6vL9hPLTIRgZkVIUadIL8b8oW4VVVWBUT9
         uOeQqRq23vTy3PDKvWHy5VhmLeBOBsLMkhNBc6e//4gfNAZap1lmLOG1YSM6JuKZGawC
         XU6kO5kyNgx0vyHfHfCl0WnzYJZzS6O19IyBeBz/SzzQe41FOXATfLFJLazA/O173V28
         BjKg==
X-Gm-Message-State: AOAM533BCzPpWSquXFw+ddHaoqoNypPW3HkeGTMMiiQrijT5cqjlcVac
        jniZogV/K33Q0ylaTffgV8l1Nz0cFf0VzPt94f8=
X-Google-Smtp-Source: ABdhPJzjTx+/zhDCeVqqrGiL2ewisWzMtVBl+2Ll4NIfsnrLfZxsTjFstOPD99qVGSpcCO+E5tLWuoPaAPqcaasxPkY=
X-Received: by 2002:ac2:4207:0:b0:442:bf8b:eee with SMTP id
 y7-20020ac24207000000b00442bf8b0eeemr12805575lfh.536.1650889356420; Mon, 25
 Apr 2022 05:22:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220406153441.1667375-1-miquel.raynal@bootlin.com>
 <20220406153441.1667375-7-miquel.raynal@bootlin.com> <CAB_54W4DMkBxYYorSZXp52D=xCEATFDbuz+0YvxNc6doO8uJ2A@mail.gmail.com>
 <20220407100513.4b8378b6@xps13>
In-Reply-To: <20220407100513.4b8378b6@xps13>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Mon, 25 Apr 2022 08:22:25 -0400
Message-ID: <CAB_54W440CbmB4c6FqZ_8PR-iZASK2dq-jAujnVxiiXOMGvDXg@mail.gmail.com>
Subject: Re: [PATCH v5 06/11] net: ieee802154: at86rf230: Rename the
 asynchronous error helper
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
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

Hi,

On Thu, Apr 7, 2022 at 4:05 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> alex.aring@gmail.com wrote on Wed, 6 Apr 2022 17:57:41 -0400:
>
> > Hi,
> >
> > On Wed, Apr 6, 2022 at 11:34 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > >
> > > In theory there are two distinct error path:
> > > - The bus error when forwarding a packet to the transceiver fails.
> > > - The transmitter error, after the transmission has been offloaded.
> > >
> > > Right now in this driver only the former situation is properly handled,
> > > so rename the different helpers to reflect this situation before
> > > improving the support of the other path.
> > >
> >
> > I have no idea what I should think about this patch.
> >
> > On the driver layer there only exists "bus errors" okay, whatever
> > error because spi_async() returns an error and we try to recover from
> > it. Also async_error() will be called when there is a timeout because
> > the transceiver took too long for some state change... In this case
> > most often this async_error() is called if spi_async() returns an
> > error but as I said it's not always the case (e.g. timeout)... it is
> > some kind of hardware issue (indicated by 802.15.4 SYSTEM_ERROR for
> > upper layer) and probably if it occurs we can't recover anyway from it
> > (maybe rfkill support can do it, which does a whole transceiver reset
> > routine, but this is always user triggered so far I know).
> >
> > However if you want that patch in that's it's fine for me, but for me
> > this if somebody looks closely into the code it's obvious that in most
> > cases it's called when spi_async() returns an error (which is not
> > always the case see timeout).
>
> I thought it would clarify the situation but I overlooked the timeout
> situation. Actually I did wrote it before understanding what was wrong
> with the patch coming next (I assume my new approach is fine?), and
> the two changes are fully independent, so I'll drop this patch too.
>

new patch is perfect, I like hw_error().

- Alex
