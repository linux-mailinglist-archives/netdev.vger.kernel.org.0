Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAA7B431776
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 13:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbhJRLg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 07:36:59 -0400
Received: from mail-ua1-f44.google.com ([209.85.222.44]:41852 "EHLO
        mail-ua1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231217AbhJRLg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 07:36:58 -0400
Received: by mail-ua1-f44.google.com with SMTP id r17so521964uaf.8;
        Mon, 18 Oct 2021 04:34:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6IaelJrOWMpa4QAL/Q/iLPggGYl6ZVnf+Z8JHUKXX5M=;
        b=hvb9Wwq43L8ElKt7vyoA2GstxJULwpV/W1OasgR0dyNLCq03qvMWhlh0fr/kHh8TWb
         GNwK/BfflyZnA23SNWM4Fr92gTYOlBRdchKtektPA8ZSmREgat/klSrEKL4UjLx9nFSU
         t5KunvVU6Uwl/PSXtc4IAjux0oMNcA1VAWJOXj/tqH8Tw3HzBXowY6HfJXtbh9ixAVgo
         v/ZlCdsOwANxOpa4EDrBa2kdlGcUU/p+0oJeWGV/eDqLZJFxH1i19KuDxYNUUiqEwS6O
         GiYH3f7CLIxI9Y+lf1EUxUTQXW6nDtbvHmSHVegfb2hK1ZaeujljAzdC35Ny2gwrNObq
         mx3Q==
X-Gm-Message-State: AOAM532msyroz2av7aliZ9jKDzR3zkYza9mpqstUG77941kN3PXeijts
        S/xpxE9uzaY9u4ZZgfGy6x6cNY6iHXlPwQ==
X-Google-Smtp-Source: ABdhPJxJRJAYWTZiZk+IKwDkT7LqcVPgxwi5YBSCprR9WkFVle0VS/VLhtNdct4VRTKWyJHaNI14VA==
X-Received: by 2002:a67:d111:: with SMTP id u17mr26704847vsi.37.1634556886652;
        Mon, 18 Oct 2021 04:34:46 -0700 (PDT)
Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com. [209.85.221.170])
        by smtp.gmail.com with ESMTPSA id 39sm9116159vki.56.2021.10.18.04.34.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 04:34:46 -0700 (PDT)
Received: by mail-vk1-f170.google.com with SMTP id j12so8384799vka.4;
        Mon, 18 Oct 2021 04:34:45 -0700 (PDT)
X-Received: by 2002:a05:6122:a20:: with SMTP id 32mr23628239vkn.15.1634556885722;
 Mon, 18 Oct 2021 04:34:45 -0700 (PDT)
MIME-Version: 1.0
References: <362d9ced19f3524ee8917df5681b3880c13cac85.1630416373.git.geert+renesas@glider.be>
 <20210831133238.75us5ipf25wzqkuq@pengutronix.de>
In-Reply-To: <20210831133238.75us5ipf25wzqkuq@pengutronix.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 18 Oct 2021 13:34:34 +0200
X-Gmail-Original-Message-ID: <CAMuHMdX63XMfHS+d9FM0oR_-hnFi4z_GsSwhCmkNKQ01093ttQ@mail.gmail.com>
Message-ID: <CAMuHMdX63XMfHS+d9FM0oR_-hnFi4z_GsSwhCmkNKQ01093ttQ@mail.gmail.com>
Subject: Re: [PATCH] can: rcar: Drop unneeded ARM dependency
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        linux-can@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

On Tue, Aug 31, 2021 at 3:32 PM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 31.08.2021 15:27:40, Geert Uytterhoeven wrote:
> > The dependency on ARM predates the dependency on ARCH_RENESAS.
> > The latter was introduced for Renesas arm64 SoCs first, and later
> > extended to cover Renesas ARM SoCs, too.
> >
> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
>
> Applied to linux-can-next/testing.

Thanks!

https://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git/log/?h=testing
still predates my patch. Am I looking at the wrong tree?

Thanks again!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
