Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 462C22A1B41
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 00:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbgJaXfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 19:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbgJaXfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 19:35:40 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6833DC0617A6;
        Sat, 31 Oct 2020 16:35:40 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id j18so8038814pfa.0;
        Sat, 31 Oct 2020 16:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+Q1P3Fsa2S6Rajkz4K2j14J+8baoBGyfgDlj09P9ZMI=;
        b=umtw0O3IQdpfPvgMpbP3Jb1QjtxxPlalCSacUhZa8auXwaJrVXIXAl7WnJ1qNkvW+o
         CeVr9ofEBwUyPgtgJjw+1OJc0mu3kkMbP3klBTiePL7cF/DOU3sWtiUnI6eAaEVrC9c7
         xw5UTCtxEZSSM9BH95H2NhQToL9/PV5Ee4T7bYOdyQjJdZgliEUDpgoGCbBzcelsR4u4
         /7ZuQgQF0hrsRKGqOFdYP0OdoHROMXMMbZVYSLKLUYrZsH0L12A2mA/58pqHRMTrOWci
         ehGA4FbF+lQ0LsQfsrStUTjVjSMk5X54/727Ht53gblIDxDu1VGgLVA8tkj0dqlNMojl
         v8jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+Q1P3Fsa2S6Rajkz4K2j14J+8baoBGyfgDlj09P9ZMI=;
        b=K7a4TcrlMDBaYRzc6P4CKw7DtiHU3ai1QPxOY6mN9Tp6mLZBlOIXqNqrhsiwV9JnPB
         wJfK/h6wecbZuVsFTDr6eklGaLjz0MV54ujneT9fRFCsMRZCQNOa0+sUvo/btVcgktvB
         2xxPMOHccQpbJ6dfBhc51p/R2afHMFJ//rXkueJiOfZlZ3m6nFWtZgE/u3QArAkRzIdw
         0c86SDMlXUA50+T0Wtm7oUriBt7jZLr26zPXCElQTycoHNSMBHyF8IToTx349ICg71jF
         8Vco23P1OPTynjSWYSyplkfUoFQShQQlPOyPOlygLMYSFwBoptxt3bJZB7/1EvDhaVbg
         y9wA==
X-Gm-Message-State: AOAM5330Ccvdcr2WR9rkfMtmWsGj8JJREJHUJT7nd6QTl91VE/Kjos0Q
        rdSmFiJp6OguviLnGfLcolH+boz5+BoRrf6qTpY=
X-Google-Smtp-Source: ABdhPJy4+C2TgT6q7M3fgWND9u3XqrYgi9/x7AcYU9x66u+5IBACqoMskaPdEM4I5+DNwpHKjVmrsKOwL/8VTyqvym8=
X-Received: by 2002:a63:a5e:: with SMTP id z30mr228933pgk.233.1604187339814;
 Sat, 31 Oct 2020 16:35:39 -0700 (PDT)
MIME-Version: 1.0
References: <20201028070504.362164-1-xie.he.0141@gmail.com>
 <20201030200705.6e2039c2@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAJht_EOk43LdKVU4qH1MB5pLKcSONazA9XsKJUMTG=79TJ-3Rg@mail.gmail.com>
 <20201031095146.5e6945a1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net> <CAK8P3a1kJT50s+BVF8-fmX6ctX2pmVtcg5rnS__EBQvseuqWNA@mail.gmail.com>
In-Reply-To: <CAK8P3a1kJT50s+BVF8-fmX6ctX2pmVtcg5rnS__EBQvseuqWNA@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Sat, 31 Oct 2020 16:35:29 -0700
Message-ID: <CAJht_EO0Wp=TVdLZ_8XK7ShXTUAmX-wb0UssTtn51DkPE266yQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dlci: Deprecate the DLCI driver (aka the
 Frame Relay layer)
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Krzysztof Halasa <khc@pm.waw.pl>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 31, 2020 at 2:41 PM Arnd Bergmann <arnd@kernel.org> wrote:
>
> I think it can just go in the bin directly. I actually submitted a couple of
> patches to clean up drivers/net/wan last year but didn't follow up
> with a new version after we decided that x.25 is still needed, see
> https://lore.kernel.org/netdev/20191209151256.2497534-1-arnd@arndb.de/
>
> I can resubmit if you like.

Should we also remove the two macro definitions in
"include/uapi/linux/sockios.h" (SIOCADDDLCI / SIOCDELDLCI), too? It
seems to be not included in your original patch.
