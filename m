Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 362024F6D99
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 23:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236879AbiDFV7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 17:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236848AbiDFV7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 17:59:52 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D858D10BD3E;
        Wed,  6 Apr 2022 14:57:54 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id t25so6419292lfg.7;
        Wed, 06 Apr 2022 14:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j2r4QuZB4sbYUsyiEP8pfS0Kaell7hun/eeN2g/FSFs=;
        b=YfUwanS1rouVwLojzGoXwW2KQ3Da1gAPgKJ7B3n24ZTOSlhkRWJaTsdVQxGfgR9p4P
         h+Go4XQ1mg2DooUEZ7L3lA0xIxS8nc7d8c1Vtbgel151weRZ2ZvyP/LYvrpDEXx2lI8e
         zx9ibzqZCDXMTPIw/9Trw3F40Qr/XIgkai9zddT6blQ4yLNM4ShhKFbP8KrsoR2wu3uS
         A6V570ieK8baGRFc8VtPrjIzMp0jAXpYYpdrnmQsYQLTpQ1Uy3+4Kn2IZTV6++EIo3oW
         o7L58S9YPjOGkdlMG7k03hG0AeiYjdvl0OUFeVLjl41XudFGquTlClOLEuBIn9swaGBk
         dOww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j2r4QuZB4sbYUsyiEP8pfS0Kaell7hun/eeN2g/FSFs=;
        b=XSLPDvQEeYvv3TnKdIZRtRojyTgiitQSRybOvfT5kNbbHY6P8e7OVAOLdu+bfUva8F
         Cdo6A/hHRWb/R5hGxNbbPJvhQsNwpoQWwGCOXnfpx34+1iTEA6/5D4gQRYpkjIKO1Nry
         T2y66a+tEVVAGtQs/+OgKRwgkYTt7TILVA0o7UeDB9QwRGNQbFe97GC0OnwvMkWkXFiO
         IQwIPQX9q6uYL6UsCk5eUwEgZbh0kqWZBYyKLw8xhKUBaEsv98vJSaUiKO4LvWSzeXHa
         5e7+tmw74IYKJjFpP8SUNhAoImvMIQxxkn5KRciA66s6geGnB6bBoSGc29/uxCkCFuoS
         jevQ==
X-Gm-Message-State: AOAM531TGOBVesVBhCohA88GriXrjJmk2K8bj02Or+1b+fNSKPgmNhge
        T0DqwP6p4ABP4rslCMdjPDLn9Y7idY5K8I9uKG6PazWb
X-Google-Smtp-Source: ABdhPJwHqsKNQVRJL/gCpRboPZ6BEVvKyOjJY02etsNUyKhQMjjQ85RXOZ9ie0+O0lAElN+g8EG4nCtB10zuk2afpDA=
X-Received: by 2002:a05:6512:3189:b0:44a:fbff:24d9 with SMTP id
 i9-20020a056512318900b0044afbff24d9mr7495461lfe.463.1649282273059; Wed, 06
 Apr 2022 14:57:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220406153441.1667375-1-miquel.raynal@bootlin.com> <20220406153441.1667375-7-miquel.raynal@bootlin.com>
In-Reply-To: <20220406153441.1667375-7-miquel.raynal@bootlin.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Wed, 6 Apr 2022 17:57:41 -0400
Message-ID: <CAB_54W4DMkBxYYorSZXp52D=xCEATFDbuz+0YvxNc6doO8uJ2A@mail.gmail.com>
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
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Apr 6, 2022 at 11:34 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> In theory there are two distinct error path:
> - The bus error when forwarding a packet to the transceiver fails.
> - The transmitter error, after the transmission has been offloaded.
>
> Right now in this driver only the former situation is properly handled,
> so rename the different helpers to reflect this situation before
> improving the support of the other path.
>

I have no idea what I should think about this patch.

On the driver layer there only exists "bus errors" okay, whatever
error because spi_async() returns an error and we try to recover from
it. Also async_error() will be called when there is a timeout because
the transceiver took too long for some state change... In this case
most often this async_error() is called if spi_async() returns an
error but as I said it's not always the case (e.g. timeout)... it is
some kind of hardware issue (indicated by 802.15.4 SYSTEM_ERROR for
upper layer) and probably if it occurs we can't recover anyway from it
(maybe rfkill support can do it, which does a whole transceiver reset
routine, but this is always user triggered so far I know).

However if you want that patch in that's it's fine for me, but for me
this if somebody looks closely into the code it's obvious that in most
cases it's called when spi_async() returns an error (which is not
always the case see timeout).

- Alex
