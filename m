Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 424F547978
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 06:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726127AbfFQEnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 00:43:43 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:42361 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbfFQEnn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 00:43:43 -0400
Received: by mail-lf1-f68.google.com with SMTP id y13so5444974lfh.9
        for <netdev@vger.kernel.org>; Sun, 16 Jun 2019 21:43:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QZYnY2hIUSm+INHACfGV3NJI8hXeyeTw8tvqjhCF464=;
        b=MMXvlchVs2Zgrzft62CDXTNlgYLYUhsdEmF5yBBfIzjcxXwgu+TFNl4ZoIwXwi/Cp5
         GZyWocmV8KqP7vfrpu1KZsUdWgrLDSd0gdy43lJi+LlqepOvPg3LRwzIW8VKsHP3Zyex
         nUl+DAZfb/HRyNan1Ndv+uAdskNAK0QOUFJS1qq8hxxYXWax7O1+84TlV70C14ekBJq6
         2Ld/EPFBUYKfF5DBrHjTwoqqpQ8o2NWQU/A8PIF+9etcSJjrhDveAIUKfa2rAObbsj+p
         xspUXSK+ZWwcak0Pe7L+Kb0TaWtpxbwnsJoIEHGhu7U1B34r930XYyfs5qAAq3I80GEW
         ESfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QZYnY2hIUSm+INHACfGV3NJI8hXeyeTw8tvqjhCF464=;
        b=ONFTyujCmXqIPH6RCTor+ECw857LVwRx/a6Id7GcVYHxtB15Hb3ub0yXERZoxiYe38
         oEoSmHZ4jtgJT0wTh4uJsRAZ2sCeWbpAXeMRhjzs04MPzIa6XRwl1DO788Mfz7dtDGDm
         x3Too+u6tTQNMPqx8C8AFXAN18XUX3BASq/Q7D8vDJFl4BWRoGhVOcRXftBJ6i0Te9uq
         OaPYyG9oJqsL7AyBHKWSfKoqW5sK8gM2JpUpKjFjAfHXmKrD8kBzkIoeDZNsgd0CAVot
         KRk1sOhD1EWhvsZhEsV2l7UhCjOSP54z/AXaUNauiJHL9EkyKyBh3JaH4fURYytqYhdp
         QzuQ==
X-Gm-Message-State: APjAAAUjmG/3RKBJIIU+ZKgTJuJvH740JB35oOLwoAf19ekgbJr2cMPj
        gkxTIm8+nzo1bjhavyLKWQMW8cRsdhPgrQm1tBOcnA==
X-Google-Smtp-Source: APXvYqx5atfcvuI00s9Z4mXLRo48akZO/SgAq0T1wCjD9YxY4YsnaLJCxKSL3H3msuEwih+R7uGarFUy+Wtgrp1SkuE=
X-Received: by 2002:a19:5046:: with SMTP id z6mr6335117lfj.185.1560746621318;
 Sun, 16 Jun 2019 21:43:41 -0700 (PDT)
MIME-Version: 1.0
References: <1560745167-9866-1-git-send-email-yash.shah@sifive.com>
In-Reply-To: <1560745167-9866-1-git-send-email-yash.shah@sifive.com>
From:   Yash Shah <yash.shah@sifive.com>
Date:   Mon, 17 Jun 2019 10:13:05 +0530
Message-ID: <CAJ2_jOH2X6+CcNCruxX0aeCzPnjcGuv-X1Q4eESsY6PyW1LViA@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] Add macb support for SiFive FU540-C000
To:     David Miller <davem@davemloft.net>, devicetree@vger.kernel.org,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org
Cc:     Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        =?UTF-8?Q?Petr_=C5=A0tetiar?= <ynezz@true.cz>,
        Sachin Ghadi <sachin.ghadi@sifive.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 17, 2019 at 9:49 AM Yash Shah <yash.shah@sifive.com> wrote:
>
> On FU540, the management IP block is tightly coupled with the Cadence
> MACB IP block. It manages many of the boundary signals from the MACB IP
> This patchset controls the tx_clk input signal to the MACB IP. It
> switches between the local TX clock (125MHz) and PHY TX clocks. This
> is necessary to toggle between 1Gb and 100/10Mb speeds.
>
> Future patches may add support for monitoring or controlling other IP
> boundary signals.
>
> This patchset is mostly based on work done by
> Wesley Terpstra <wesley@sifive.com>
>
> This patchset is based on Linux v5.2-rc1 and tested on HiFive Unleashed
> board with additional board related patches needed for testing can be
> found at dev/yashs/ethernet branch of:

Correction in branch name: dev/yashs/ethernet_v2

> https://github.com/yashshah7/riscv-linux.git
>
> Change History:
> V2:
> - Change compatible string from "cdns,fu540-macb" to "sifive,fu540-macb"
> - Add "MACB_SIFIVE_FU540" in Kconfig to support SiFive FU540 in macb
>   driver. This is needed because on FU540, the macb driver depends on
>   SiFive GPIO driver.
> - Avoid writing the result of a comparison to a register.
> - Fix the issue of probe fail on reloading the module reported by:
>   Andreas Schwab <schwab@suse.de>
>
> Yash Shah (2):
>   macb: bindings doc: add sifive fu540-c000 binding
>   macb: Add support for SiFive FU540-C000
>
>  Documentation/devicetree/bindings/net/macb.txt |   3 +
>  drivers/net/ethernet/cadence/Kconfig           |   6 ++
>  drivers/net/ethernet/cadence/macb_main.c       | 129 +++++++++++++++++++++++++
>  3 files changed, 138 insertions(+)
>
> --
> 1.9.1
>
