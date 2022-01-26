Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECDDB49CA75
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 14:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237635AbiAZNMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 08:12:55 -0500
Received: from mail-vk1-f175.google.com ([209.85.221.175]:47003 "EHLO
        mail-vk1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234991AbiAZNMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 08:12:54 -0500
Received: by mail-vk1-f175.google.com with SMTP id z15so11323716vkp.13;
        Wed, 26 Jan 2022 05:12:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BhJUXbO8q0bPKjK33ClDLLcFdaoVbDDuXbB3IPKRL8Y=;
        b=noVYv68WuAgU8HUxBJolC73hWZZDUXNtV2y+YZGvzior9TBG4kqyjSqE426GJs1qyG
         vKhuuhpIfsDuaiw9NJP7suGlUvAb8Zfb4uRWildQ2q3pHT7CQany5mftB3tIxgLzn1bY
         XK9c4fnj+Js0vRboku4JuPxUnIQZWGiWQ3TL4q+t9FzpY77uK/hFbt5k9R69B98VIAnj
         cZSywpK+GHUF1XiQHhj/YaLgqnmQCh3ETS6rVv9M8PVZrEt/u0MhzvatXe41FxeOj0Sk
         Hi+/3ZF9u1Wn6SKfBWpxa+5JXMeJleSdI9xtfi78BetUlobZyhF4pxhJ47acgoxhUtOC
         HpaQ==
X-Gm-Message-State: AOAM532aYhLf9HTr5qa/B+A46YUTumrzvI+NaY+PLnxoySKhr6vm2u7a
        Yt0KPV0xZhoBDUinBYXADD9C4l2MLOmVEA1P
X-Google-Smtp-Source: ABdhPJxyEmvWNKfxyfW9IWX7lh60fcVY7PAuHSfqMiXFOClNmZSlib2ABmjaYlPhQt2umf9NE+P9qg==
X-Received: by 2002:a1f:a3ca:: with SMTP id m193mr8572626vke.3.1643202773937;
        Wed, 26 Jan 2022 05:12:53 -0800 (PST)
Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com. [209.85.221.172])
        by smtp.gmail.com with ESMTPSA id k20sm258738vsg.14.2022.01.26.05.12.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jan 2022 05:12:52 -0800 (PST)
Received: by mail-vk1-f172.google.com with SMTP id m131so14563196vkm.7;
        Wed, 26 Jan 2022 05:12:52 -0800 (PST)
X-Received: by 2002:a67:a401:: with SMTP id n1mr5404419vse.38.1643202772297;
 Wed, 26 Jan 2022 05:12:52 -0800 (PST)
MIME-Version: 1.0
References: <20220111162231.10390-1-uli+renesas@fpond.eu> <20220111162231.10390-5-uli+renesas@fpond.eu>
In-Reply-To: <20220111162231.10390-5-uli+renesas@fpond.eu>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 26 Jan 2022 14:12:41 +0100
X-Gmail-Original-Message-ID: <CAMuHMdWwsbPGojoyjPkfBa=-cpb_tXJgys=yeHr6KBdDT0MWSA@mail.gmail.com>
Message-ID: <CAMuHMdWwsbPGojoyjPkfBa=-cpb_tXJgys=yeHr6KBdDT0MWSA@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] arm64: dts: renesas: r8a779a0-falcon: enable CANFD
 0 and 1
To:     Ulrich Hecht <uli+renesas@fpond.eu>
Cc:     Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, linux-can@vger.kernel.org,
        "Lad, Prabhakar" <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Wolfram Sang <wsa@kernel.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        socketcan@hartkopp.net,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Uli,

On Tue, Jan 11, 2022 at 5:22 PM Ulrich Hecht <uli+renesas@fpond.eu> wrote:
> Enables confirmed-working CAN interfaces 0 and 1 on the Falcon board.
>
> Signed-off-by: Ulrich Hecht <uli+renesas@fpond.eu>

Thanks for your patch!

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Perhaps you want to describe can_clk (40 MHz) and its pinctrl, too?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
