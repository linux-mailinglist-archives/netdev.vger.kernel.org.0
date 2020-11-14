Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2578D2B2C9D
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 11:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbgKNKKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 05:10:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:38414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726495AbgKNKKH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 05:10:07 -0500
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FDC122252
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 10:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605348606;
        bh=mmBAQMv+Xl0Tz2Qi2wx/HBpfiieSydKH4Z2N2ZOrCc8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=xgPkVY5Z5aJ0k8fkJ106D8BPSfDwx5Co5bKsVDmjDRYhxjtvW9CjiyB+W6OYHdkSo
         CxgyOHB1M4nhaeZq60sE0oFqo+epL5kxnsmcjF8JsyFRiAYnbfwTvt8ne+h8s3uZmo
         T90u4eszseUBreB3k2KWlnSQpPbTz9TPEtN0alJQ=
Received: by mail-ot1-f50.google.com with SMTP id h16so7145680otq.9
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 02:10:06 -0800 (PST)
X-Gm-Message-State: AOAM531/JCJw1K1D3W6FbbuqS4hkUfRWDJvQxUlg82bpCTrgAYBWhEEw
        MbQkSVc/r65jCCgROX3lOzlnZWCyYQyulG7zp8U=
X-Google-Smtp-Source: ABdhPJyJA+Ax27ZHfsWC/evCiNOdXxEwDiIKBAgnnh7vQhbkKT7yRxALW3GRHAtJqW+HgYtO7mhPyzR9GDaBLMYKwxM=
X-Received: by 2002:a9d:62c1:: with SMTP id z1mr4365539otk.108.1605348605365;
 Sat, 14 Nov 2020 02:10:05 -0800 (PST)
MIME-Version: 1.0
References: <20201029143934.GO878328@lunn.ch> <20201029144644.GA70799@apalos.home>
 <2697795.ZkNf1YqPoC@kista> <CAK8P3a2hBpQAsRekNyauUF1MgdO8CON=77MNSd0E-U1TWNT-gA@mail.gmail.com>
 <20201113144401.GM1456319@lunn.ch> <CAK8P3a2iwwneb+FPuUQRm1JD8Pk54HCPnux4935Ok43WDPRaYQ@mail.gmail.com>
 <20201113165625.GN1456319@lunn.ch> <CAK8P3a3ABKRYg_wyjz_zUPd+gE1=f3PsVs5Ac-y1jpa0+Kt1fA@mail.gmail.com>
 <20201113224301.GU1480543@lunn.ch> <CAMj1kXGnfsX1pH8m1eO-B1nAqL=vMeuw6fpYdeA1RqMpSrg66Q@mail.gmail.com>
 <20201114004002.GV1480543@lunn.ch>
In-Reply-To: <20201114004002.GV1480543@lunn.ch>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sat, 14 Nov 2020 11:09:53 +0100
X-Gmail-Original-Message-ID: <CAMj1kXF8m=YWrVyQmjTuFJ=4wyRCEu=qeAKs4EP7B-hmqSJDwA@mail.gmail.com>
Message-ID: <CAMj1kXF8m=YWrVyQmjTuFJ=4wyRCEu=qeAKs4EP7B-hmqSJDwA@mail.gmail.com>
Subject: Re: Re: realtek PHY commit bbc4d71d63549 causes regression
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        =?UTF-8?Q?Jernej_=C5=A0krabec?= <jernej.skrabec@gmail.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Sumit Garg <sumit.garg@linaro.org>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steve McIntyre <steve@einval.com>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>, Willy Liu <willy.liu@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Masahisa Kojima <masahisa.kojima@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 14 Nov 2020 at 01:40, Andrew Lunn <andrew@lunn.ch> wrote:
>
> > One question that still has not been answered is how many actual
> > platforms were fixed by backporting Realtek's follow up fix to
> > -stable. My suspicion is none. That by itself should be enough
> > justification to revert the backport of that change.
>
> I think i've already said that would be a good idea. It makes the
> problem less critical. But the problem is still there, we are just
> kicking the can down the road. I've not seen much activity actually
> fixing the broken DT. So i suspect when we catch up with the can, we
> will mostly still be in the same place. Actually, maybe worse, because
> broken DTs have been copy/pasted for new boards?
>

I don't see how that matters. If the new board ships with a stable
kernel, things should simply work as they did before. If the new board
ships with a new kernel, things won't work in the first place, so it
is unlikely to cause a regression in the field.
