Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10A973DF685
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 22:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbhHCUle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 16:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbhHCUlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 16:41:32 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 612CFC061757;
        Tue,  3 Aug 2021 13:41:20 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id x11so426180ejj.8;
        Tue, 03 Aug 2021 13:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=muiFGHEiWM25TrMqBdRhYVOUT+BYpoCINhQGE9kEJ74=;
        b=MNlRcuGihDn3+Z15IGGZ551Y9IzqTYJz2RsPB/18HciIbgAh7DS4vs5qgpQzNuSd2+
         ZpzYlPq46RynZktqAvy2nZr+szds0M2MjV0g0++EgJgbFGgO3o68oLUnamcJJjZCzNut
         Yhq71OtVAfqNPzQmyEiV4kcaMF3h5ziwHE/c26ts1OlDE2LaJ8ZAFZ8kZW8QLsUeosqp
         WmmwPWnUiY1CbLZASkGIch1ltlXeQ/Z4rPTg3EiaQnUZdcZMRoaPTmN9jCnZw1FuTHSS
         dAY6evOYP7jawMRXnFBSTVvJC2GGYJen+gZUsPlHFQSmBbohMAesGlkHOnceCuQBpCGs
         nXow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=muiFGHEiWM25TrMqBdRhYVOUT+BYpoCINhQGE9kEJ74=;
        b=R44REq9Q/3vNbapLJpsZTg0rfkZFC/FnXUbyK+EyEfjTdSYr/f7h14GnPFl9ef2aB9
         en2fP5xjUROBDnBhmoEBdBJffwY6uEuBXOd17R+T71kP8Pp5Et2fWdnXW04CElHjQ4Xg
         ywmpsB4Kb7x5VufFfDiw8LNQ9TPX7U35jF82PFa+jY5xdgA6fQ5tlpX/Y0LN/YAITpKO
         zFVZv4Mj/aVHPX1Lkdb6BUOqdBv5dtEVOSEUmUichzSM2r7m1wW22mHPwxq8r2khgO/s
         Jza1VJVKshMmXNznzKC44m/9MfeFTR+DzmwK4lVeJIpXnvN19KDLTVbLsLQ2YhxiVfeN
         aQOQ==
X-Gm-Message-State: AOAM531X8/XkUQ4ypkmOlfk9bEQoi218Ea+ry/3qOP+gfTD23Qwbkz4c
        RzbOipr7+mYGsuz08+24iejCzY6gdlZ1LFSX1rc=
X-Google-Smtp-Source: ABdhPJxC90iBtIQJh6nPIWU8pSAop+ICxI60kaovcWNRh3ZFPKMATs9wV8MtyZ5+vdEpGw66BuARlVTc44++ww1Ejkc=
X-Received: by 2002:a17:906:b0c5:: with SMTP id bk5mr22129214ejb.428.1628023278980;
 Tue, 03 Aug 2021 13:41:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210729201100.3994-1-linux.amoon@gmail.com>
In-Reply-To: <20210729201100.3994-1-linux.amoon@gmail.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Tue, 3 Aug 2021 22:41:08 +0200
Message-ID: <CAFBinCAPP7J-B53FCrY50oF9ttsOkkknG1NhBbL8BYZVPdkJSA@mail.gmail.com>
Subject: Re: [PATCHv1 0/3] Add Reset controller to Ethernet PHY
To:     Anand Moon <linux.amoon@gmail.com>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Emiliano Ingrassia <ingrassia@epigenesys.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Anand,

On Thu, Jul 29, 2021 at 10:11 PM Anand Moon <linux.amoon@gmail.com> wrote:
>
> It is being observed some time the Ethernet interface
> will not send / recive any packet after reboot.
>
> Earlier I had submitted Ethernet reset ID patch
> but it did not resolve it issue much, Adding new
> reset controller of the Ethernet PHY for Amlogic SoC
> could help resolve the issue.
nowhere in this series you are addressing the issue from [0]
Some more comments in the individual patch


Best regards,
Martin


[0] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/arch/arm64/boot/dts/amlogic?id=19f6fe976a61f9afc289b062b7ef67f99b72e7b9
