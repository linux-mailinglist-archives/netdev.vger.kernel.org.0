Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1C74AAACD
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 19:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380850AbiBESO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 13:14:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234705AbiBESO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 13:14:58 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC79C061348
        for <netdev@vger.kernel.org>; Sat,  5 Feb 2022 10:14:57 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id f8so7866462pgf.8
        for <netdev@vger.kernel.org>; Sat, 05 Feb 2022 10:14:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8l31Iyn30e4SiFLeL27V1Ki33NeNJ3SlJhCiSBXV7Xg=;
        b=qtq1JdecF1qfYNhCV/9jMRDzDrbM1Lyu7QZGX7LnWVAVyONwpW0HcbBoDenBGvo7L4
         eWhT0g7F1fegb16mlG07b5cptdnWAlfgXEMRFHB4QEz3F5HsBg9YdVcyoSzEM627plUD
         kAejOP7PWyFPS/hV027VDpToEY5hLbz39R5/Z6stBBzpAvcoS8g3LwJu0u6k3cscauqE
         3x2rzCEwJAI2GvAZvfftJI52I/ge9ilh7UVL0hXhXD8B/egfAeoKAAp3kt2bwT8btYDO
         OcuYVP4LBM70+SKuMwdwY26IY9PtUBH3P16txfK/mc50Hp/USJPaOhnCofgGl73Wrr3M
         DXYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8l31Iyn30e4SiFLeL27V1Ki33NeNJ3SlJhCiSBXV7Xg=;
        b=JLUfSYaMlohJsw9qCBwUWtY/KiEzoWJMXIyQHG7GX0gYKUD9BWCj7CzFwbNosw3D7n
         J2hN6NjzZQLf3I93UOjQRiQ3LCjhCp6g/7p0EE54NI+vRkCA//FijNObgwMDXYCLMIvR
         +LmCooSeXXE9KpdfVw8uOfUHMUmxkBmXaknwYZD5lIRXySMpyKRVL/7Dd8zMBGsDufQA
         ddIl5uC1PABqr2AFikXaYpYOWBZ0oBG2DsdvFW+XhilW8ISePnlZRak1+JCSYjKZnO0t
         gTVbn+/HqjvOSZpJk0M4V+KjnDYx/sGHwEbULydQF4captaXOnZtvI94sqBqmAlFZA9N
         xyhw==
X-Gm-Message-State: AOAM530mTCpg90zYW4Hp4nmoFyEmxAAV9ANlAvZJE+4wSOz31uHyeoTS
        CwzBXUw3WdJyCv4bEcYD1xBkD7GdKL61DTx36Qg=
X-Google-Smtp-Source: ABdhPJzyvHGwMDmLVt5hF/BflvCdwq9YUgg++rqAnSpXeKAGf9ODlrCNSFKvVK5nSsfmoDFNOxkSJj4zP/MOJGMc53I=
X-Received: by 2002:a63:6c01:: with SMTP id h1mr3742243pgc.118.1644084897063;
 Sat, 05 Feb 2022 10:14:57 -0800 (PST)
MIME-Version: 1.0
References: <20220204155927.2393749-1-kuba@kernel.org> <CACRpkdbfbKNzbSt_TiFq4Ji6zq1tLetW3f9=GjsFJypbihMU-g@mail.gmail.com>
In-Reply-To: <CACRpkdbfbKNzbSt_TiFq4Ji6zq1tLetW3f9=GjsFJypbihMU-g@mail.gmail.com>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Sat, 5 Feb 2022 15:14:46 -0300
Message-ID: <CAJq09z42p98YUcdKoJm78XHHPG=DFDpoaL+jgFn9NbmiFF=XMA@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: realtek: don't default Kconfigs to y
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
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

Em sex., 4 de fev. de 2022 20:55, Linus Walleij
<linus.walleij@linaro.org> escreveu:
>
> On Fri, Feb 4, 2022 at 4:59 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> > We generally default the vendor to y and the drivers itself
> > to n. NET_DSA_REALTEK, however, selects a whole bunch of things,
> > so it's not a pure "vendor selection" knob. Let's default it all
> > to n.

Whatever fits better In the kernel default settings policy. The
devices where that driver will be used normally work with custom built
kernels. The default values have little importance.

Acked-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
