Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 942E9293D41
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 15:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407206AbgJTNXp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 09:23:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:41036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406476AbgJTNXp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 09:23:45 -0400
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16B7F20BED
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 13:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603200225;
        bh=UsZJ0B25Cc9dD239hUGdtus7OX00Zt4EJkjU9ohMAL4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=piq95wxt1sqJzBv8cpehijNaXeDsBl5A4ICY74oWyyMR9S89vcbsxIxCKU49EmX7y
         5Aaz0NiOooW4qdKSjsTy+EYz9KxHmGM3Fo53Dm1/GL8JEu2zz+e315O8knNQlBN1Iq
         Sn/UBZqxB1qw8vUlzYv84y40B9fRRbXjRiZIZ5Mc=
Received: by mail-oi1-f174.google.com with SMTP id n3so2126379oie.1
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 06:23:45 -0700 (PDT)
X-Gm-Message-State: AOAM531CIR9QFg5X66+A4dx/KIxziCUH00gwF6Iu5b8G88EJ68POv9Rm
        Mxt7iQr02sVXrFiBIS2RUe3OZWfVAUiN0zOXjug=
X-Google-Smtp-Source: ABdhPJzDNSixTiOK8zHQXA6Ohq8dyrUVKpJU8UNUb1UKhANbmP0jmN8dTFPktQis7hXZBWLvPPh8yln9fH5qKbcngnQ=
X-Received: by 2002:aca:4085:: with SMTP id n127mr1810709oia.33.1603200222302;
 Tue, 20 Oct 2020 06:23:42 -0700 (PDT)
MIME-Version: 1.0
References: <20201018163625.2392-1-ardb@kernel.org> <20201018175218.GG456889@lunn.ch>
 <20201018203225.GA1790657@apalos.home> <CAMj1kXEtLx_5_Hyuk=nU6PhnYZm3F33uWGiRHH2Yb3X2ENxRSw@mail.gmail.com>
 <20201020084759.GA1837463@apalos.home> <20201020124937.GW456889@lunn.ch>
In-Reply-To: <20201020124937.GW456889@lunn.ch>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 20 Oct 2020 15:23:31 +0200
X-Gmail-Original-Message-ID: <CAMj1kXEEBe4Se1jy07B=5gnfGxty=cPM_5fJ2+5A-dZ6BX3uHw@mail.gmail.com>
Message-ID: <CAMj1kXEEBe4Se1jy07B=5gnfGxty=cPM_5fJ2+5A-dZ6BX3uHw@mail.gmail.com>
Subject: Re: [PATCH net] netsec: ignore 'phy-mode' device property on ACPI systems
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>, Jassi Brar <jaswinder.singh@linaro.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Willy Liu <willy.liu@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahisa Kojima <masahisa.kojima@linaro.org>,
        Serge Semin <fancer.lancer@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Oct 2020 at 14:49, Andrew Lunn <andrew@lunn.ch> wrote:
>
> > I hope Andrew is fine with the current changes
>
> Yes, i'm O.K. with it.

Thanks

> Making phy-mode optional would just make the
> driver more uniform with others.
>


Making phy-mode optional is fine with me, but I think it would belong
in a separate patch in any case. But I'd still prefer having the
possibility to spot bogus phy-mode values rather than ignoring them.
