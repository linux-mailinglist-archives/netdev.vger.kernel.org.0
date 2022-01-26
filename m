Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D976049CA6F
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 14:11:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236852AbiAZNLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 08:11:22 -0500
Received: from mail-vk1-f182.google.com ([209.85.221.182]:43841 "EHLO
        mail-vk1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234995AbiAZNLV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 08:11:21 -0500
Received: by mail-vk1-f182.google.com with SMTP id w206so14582814vkd.10;
        Wed, 26 Jan 2022 05:11:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bFbkuijaiH0+MDZA4Nt3F0F0GOCS29abOfcWN2LnmLk=;
        b=vCHiMZt2GrX5lP0b7SdEor9Uc+4TaILxDeyU5RO4YGMMfIboXKvEwVy42LAAmSNwgh
         GKMHhr2XL77cDLLhP4nehGaY1lzubF5lTUyoZpSXcp8u1Bgx2h2/blC/+JnG+6ywGe/x
         GtzonZNWc7rb1XTLPsdR0laotPEWr5yhklC+NEUgRWcOIhzyAv74mrcBwOty2BWmudTq
         5Z088DrLV31uYH46J+NCXoYRpP1sf8dKBoUvxwm1eq5KPDHc1o5gr2+KW6GUANSJ0WDj
         +2v63hu8khxkv1NJt4QRMQyC6loBzScKOfSGknOo8TnQOI+hQLIxN3Ng3bzazQM8fO6l
         1Cxw==
X-Gm-Message-State: AOAM53215CNTn5LJubsWkfvDt7XF6S6Id9sVME9EacBTrztDIfWdZXjR
        W1fDA6Ofs2FFry9GgbV+xBUm9/n5qXRO8pIN
X-Google-Smtp-Source: ABdhPJw5Mk5lYt+TZxvBcMTycifX3o3UUk0lve1vmTcBehPPAAWwN5Vw3MYi0VLAaRvDfim0BP5i0w==
X-Received: by 2002:a67:c885:: with SMTP id v5mr662538vsk.39.1643202680766;
        Wed, 26 Jan 2022 05:11:20 -0800 (PST)
Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com. [209.85.221.181])
        by smtp.gmail.com with ESMTPSA id u12sm4325550vku.9.2022.01.26.05.11.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jan 2022 05:11:19 -0800 (PST)
Received: by mail-vk1-f181.google.com with SMTP id w206so14582569vkd.10;
        Wed, 26 Jan 2022 05:11:18 -0800 (PST)
X-Received: by 2002:ab0:13f1:: with SMTP id n46mr6555392uae.14.1643202678231;
 Wed, 26 Jan 2022 05:11:18 -0800 (PST)
MIME-Version: 1.0
References: <20220111162231.10390-1-uli+renesas@fpond.eu> <20220111162231.10390-4-uli+renesas@fpond.eu>
In-Reply-To: <20220111162231.10390-4-uli+renesas@fpond.eu>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 26 Jan 2022 14:11:06 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUAvWTG2kqRkU2Ee=dVQa8K8b4ixu63V-ADESAo676__g@mail.gmail.com>
Message-ID: <CAMuHMdUAvWTG2kqRkU2Ee=dVQa8K8b4ixu63V-ADESAo676__g@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] arm64: dts: renesas: r8a779a0: Add CANFD device node
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

On Tue, Jan 11, 2022 at 5:22 PM Ulrich Hecht <uli+renesas@fpond.eu> wrote:
> This patch adds a CANFD device node for r8a779a0.
>
> Based on patch by Kazuya Mizuguchi.
>
> Signed-off-by: Ulrich Hecht <uli+renesas@fpond.eu>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
