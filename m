Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7930C2A1375
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 06:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbgJaFKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 01:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbgJaFKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 01:10:54 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA977C0613D5;
        Fri, 30 Oct 2020 22:10:53 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id r186so6841993pgr.0;
        Fri, 30 Oct 2020 22:10:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=30RKCcrZAh1OoyUEPuNwHLq06vemkuwPy1oxjZp5m+A=;
        b=g+sba7uL0nO0hTzzJdp4HVJVajpoT+8xqcJEtuYdSUEe5COCq4p7RFRDu6/R3e2DZu
         IDk+aB5A4stRSzPrh5EQvZtFiMvfxR0e8LhE/XRRXQtCiXbA/vxfbFVEE/PHqoPjwky6
         jZxZKYNYPvznbiMItBK+7GIuYZHZejO+MoRcy6RiBQsV/2VG7Xuh4gCandTQ7B1u+hEj
         08LnVJ7ZLn/kZFsWt5LFS6sGcVX2NHHGlT4U1I+m0XHOy4TsuA0c/5A+1t1oPdUYbzKn
         7h2wKe5ZfpjLo6uQYoc3nGQZ/sn1oshrb0/+6CPt66uLerbmTbVwHoJnAfaK//5OX13K
         TFAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=30RKCcrZAh1OoyUEPuNwHLq06vemkuwPy1oxjZp5m+A=;
        b=GwD7IbOJVxEHBbfFoB0aiBrnIWidRuyREp2jD/sLGiKCvqru+YD4r6l0nq5OOptJJ0
         wVFsTjeFOFQg7u5i1AdGWREi4ce+CdPVHa7QgovDoxN+8FUr9oLPAnoSFKpO1wJy4J/K
         Svjv4L25YDc5CUt8QjGhgnr1Pr85Jh4vz6AYbTqPdC9yTIJLqenh5BwDhA9p6OU2dolP
         CNliWZ+9vW92crG9m387bdsVHrykfAa9UB1EHKgrUCrRNwpY+a5Z/skb/N1QxCkkTLjp
         +MYudW3dBSlRAEdDI+7X7vCSWGHM41urRPasVtSjHslJdXlarxQagtqdprcIqcryn0F4
         zyxg==
X-Gm-Message-State: AOAM530b+APu7RfsqUV9O89Ab4zmkiPlosoIuFbctjG9zQ1IPnt76zDR
        XKkGOhZv7qlrpMKnFSiCJW/lbDpdsvNJHNVZcms=
X-Google-Smtp-Source: ABdhPJwd6kjKTb3oPc5yyNy1HAKjtKbzeiqtHzlToE7dWhzFojx1MfQNtp/l0ghVcWKuneF1YgCmfxZ/ehp7x62AwTw=
X-Received: by 2002:a62:3004:0:b029:156:47d1:4072 with SMTP id
 w4-20020a6230040000b029015647d14072mr12371482pfw.63.1604121053489; Fri, 30
 Oct 2020 22:10:53 -0700 (PDT)
MIME-Version: 1.0
References: <20201028070504.362164-1-xie.he.0141@gmail.com> <20201030200705.6e2039c2@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201030200705.6e2039c2@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Fri, 30 Oct 2020 22:10:42 -0700
Message-ID: <CAJht_EOk43LdKVU4qH1MB5pLKcSONazA9XsKJUMTG=79TJ-3Rg@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dlci: Deprecate the DLCI driver (aka the
 Frame Relay layer)
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Krzysztof Halasa <khc@pm.waw.pl>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 30, 2020 at 8:07 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> This code has only seen cleanup patches since the git era begun -
> do you think that it may still have users? Or is it completely unused?

I don't think it is still used. But I don't have solid evidence. So I
asked people in the warning messages to move to the newer HDLC Frame
Relay layer.

Some evidence indicating this is not in use might be:

1. In "Documentation/networking/framerelay.rst", in the last
paragraph, the link for the user space programs needed for
configuration has been broken.

2. The Frame Relay layer supports only one hardware driver in the
kernel. I looked up the hardware on the vendor's website, and it
seemed they had their own drivers for the hardware. I guess most users
would use the driver provided by the vendor instead.

The names of the hardware supported by our sdla.c driver appear in this page:
    http://ftp.sangoma.com/technote/INDEX
According to this file in the same directory, the driver provided by
the vendor is named WANPIPE and supports multi-protocol (unlike sdla.c
/ dlci.c but similar to hdlc_fr.c):
    http://ftp.sangoma.com/technote/tn0015.txt
According to the WANPIPE installation guide here, the vendor
explicitly requested users to disable dlci.c in the kernel, by
answering NO to CONFIG_DLCI:
    http://ftp.sangoma.com/linux/current_wanpipe/doc/WanpipeInstallation.pdf

3. According to drivers/net/wan/Kconfig, sdla.c (the only hardware
driver dlci.c supports) depends on CONFIG_ISA. According to Wikipedia,
ISA is an old 16-bit bus system. I think this makes users of this
hardware driver rare.

4. Frame Relay itself is an old technology. I'm not clear about its
overall usage but if it's still used its usage must be declining.

> The usual way of getting rid of old code is to move it to staging/
> for a few releases then delete it, like Arnd just did with wimax.

Oh. OK. But I see "include/linux/if_frad.h" is included in
"net/socket.c", and there's still some code in "net/socket.c" related
to it. If we move all these files to "staging/", we need to change the
"include" line in "net/socket.c" to point to the new location, and we
still need to keep a little code in "net/socket.c". So I think if we
move it to "staging/", we can't do this in a clean way.
