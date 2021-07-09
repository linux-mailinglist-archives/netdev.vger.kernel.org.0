Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6C13C2225
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 12:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbhGIKYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 06:24:40 -0400
Received: from mail.zx2c4.com ([104.131.123.232]:53672 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232010AbhGIKYk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 06:24:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1625826113;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7dR0/VUJHKDLRMz9yU5Zdn5RWQOxI+Wc0vq05RWjQvE=;
        b=SvQ1Je064yhDKpHtC+rohJT39TVuxD85wqjML8PO3gxEcEu4/YVvk3iaUzENwcWcM5wqDH
        thvwKk3BjAVh7F3FOpUHcQhDhnWXtVUhiWZl/AB9a/0FYWH9OU9sN96yOgwmH9E5N6HbE3
        GTlcQVkPe26jsPPQ4IgmztdiwLeX+Qk=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 9f8613a4 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 9 Jul 2021 10:21:53 +0000 (UTC)
Received: by mail-yb1-f182.google.com with SMTP id i4so13900066ybe.2;
        Fri, 09 Jul 2021 03:21:53 -0700 (PDT)
X-Gm-Message-State: AOAM530r+Kr7cH0AcFJCCo1ELnziOet3mR32TnCgFpMWwWlssorqRFGU
        rSp34naIb2vZUICKFFSYJZuEy4hw4D463fHCJwM=
X-Google-Smtp-Source: ABdhPJw3hLruA2qeePGLKBjcD2sa6DYSkDPQlzvvzUhZwIUmRBHDfkI+Q8Yxy6ibaOCC6j/KSgkkwr+titsIhBFR4BE=
X-Received: by 2002:a25:b684:: with SMTP id s4mr45457481ybj.178.1625826110246;
 Fri, 09 Jul 2021 03:21:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210709021747.32737-1-rdunlap@infradead.org> <20210709021747.32737-7-rdunlap@infradead.org>
In-Reply-To: <20210709021747.32737-7-rdunlap@infradead.org>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 9 Jul 2021 12:21:39 +0200
X-Gmail-Original-Message-ID: <CAHmME9rUJndFC-6KAxGL3w6Ka4WgyP_m5DS+1_vuHdQowonSOg@mail.gmail.com>
Message-ID: <CAHmME9rUJndFC-6KAxGL3w6Ka4WgyP_m5DS+1_vuHdQowonSOg@mail.gmail.com>
Subject: Re: [PATCH 6/6] net: wireguard: rename 'mod_init' & 'mod_exit'
 functions to be module-specific
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andres Salomon <dilinger@queued.net>,
        linux-geode@lists.infradead.org, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Christian Gromm <christian.gromm@microchip.com>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin Schiller <ms@dev.tdt.de>, linux-x25@vger.kernel.org,
        WireGuard mailing list <wireguard@lists.zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Randy,

The commit subject line should be:

wireguard: main: rename 'mod_init' & 'mod_exit' functions to be module-specific

And:

On Fri, Jul 9, 2021 at 4:17 AM Randy Dunlap <rdunlap@infradead.org> wrote:
> -static int __init mod_init(void)
> +static int __init wireguard_init(void)

wg_mod_init

> -static void __exit mod_exit(void)
> +static void __exit wireguard_exit(void)

wg_mod_exit

Thanks,
Jason
