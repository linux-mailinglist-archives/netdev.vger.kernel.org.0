Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A13221F9144
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 10:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728861AbgFOIVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 04:21:13 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:41121 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728369AbgFOIVM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 04:21:12 -0400
Received: by mail-ot1-f68.google.com with SMTP id k15so12449290otp.8;
        Mon, 15 Jun 2020 01:21:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=En0nCYVvJiHGZ5f4vKBhmUYFYKuL6510yItMIIk4SZU=;
        b=LHsD9C+9751qC2/8gSKkh2/NRpzshKJQBmo2FZpI+1Z+bpweQdhjduSGFGdnWMiib9
         /BrRcI7zdcqz0bcgLQxH45x6R2Bf0oU5NyfWqZmrWZJXwteoCL+V/z6cPWa2r2quZlTC
         XdqCxkgyvnC8u5De1aSntITuBrPGHOCjiKGnW/hXIBTLrJBvTMht34c3nUEZeIX55bmQ
         Dy2x3Bkzdz3vnLEotP8Gwi7EB3P/i4183H728YckhaRo5uZ1j+KpoLoGQ+DusNrZ+QgD
         FCOdvkXjTulnpSl03QvwZ+qfgk1vKiwpqyj+T8/2RTjFWu38JQRWx4vXWWT4psy74ubk
         d88A==
X-Gm-Message-State: AOAM531V2QBzn66qmoczCJaK7Tm/U61RbmJjdVhP2E37eFAbt9p12BmW
        YgC9u0kySMmXUpmgUygzjjkgU95BBlzOGF55Cnc3Pg==
X-Google-Smtp-Source: ABdhPJy40zkzsPYW8++hzgqNwCVPGu4sKPknAWssY/tW+sl8cETPqOssgErLrK4lJtfvHS4LaP2fxrs+oOIl3FHgS6s=
X-Received: by 2002:a9d:62c2:: with SMTP id z2mr19950177otk.145.1592209272006;
 Mon, 15 Jun 2020 01:21:12 -0700 (PDT)
MIME-Version: 1.0
References: <b95930e8-0e6b-f37d-da51-afd682a4f1f6@cogentembedded.com>
In-Reply-To: <b95930e8-0e6b-f37d-da51-afd682a4f1f6@cogentembedded.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 15 Jun 2020 10:21:00 +0200
Message-ID: <CAMuHMdXxj4TTTFMtJNpwXpLNcZZ0=3rqLr8pMnPOCM9K=Bsk5w@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: switch to my private email for Renesas
 Ethernet drivers
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sergei,

On Sat, Jun 13, 2020 at 10:59 PM Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com> wrote:
> Subject: MAINTAINERS: switch to my private email for Renesas Ethernet drivers
>
> I no longer work for Cogent Embedded (but my old email still works :-)),
> and still would like to continue looking after the Renesas Ethernet drivers
> and bindings.  Let's switch to my private email.
>
> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

Thanks a lot!

Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
