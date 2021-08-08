Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 959963E3CB1
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 22:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232387AbhHHUXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 16:23:19 -0400
Received: from mail.zx2c4.com ([104.131.123.232]:40638 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229977AbhHHUXS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Aug 2021 16:23:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1628454176;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hwMXHfWfY1HwtKLFV1C9p+LNgMMZXcsO9o0YDBO5lpY=;
        b=A0sw1zzmJnofdfzUawTVUJ/IciosRPm+uLSnUwvRtxnt3LLTFNSDU3h+vGfe5Ndi/FowLf
        LjS9JXZosImxK0b2413SmCNhwokBiJNYwudSG+/oplPjozb+FLIT20ujRPfGod4q0ap87N
        uNReM6HlnDnqYV9jeL/fJoBYqMuXSu4=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 413f59e3 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Sun, 8 Aug 2021 20:22:56 +0000 (UTC)
Received: by mail-yb1-f176.google.com with SMTP id j77so25667860ybj.3;
        Sun, 08 Aug 2021 13:22:54 -0700 (PDT)
X-Gm-Message-State: AOAM5332yhvrWNGM+YGDIcl4dBrbdrK0sSnxkoM53+owtMaNYws/zSI4
        Yr5NWkzFijiJX8WDw/qU6Ifj/Fhgv6GW0P0qA9Q=
X-Google-Smtp-Source: ABdhPJwAQlzVFpIsrq+ZqLHe2FFAW/bpSKn/srqbL9Rcr2xkwEBPFudnUGdpUeYlE2UfYEgtmwNjOzQmNPZpBk7bZwo=
X-Received: by 2002:a25:8445:: with SMTP id r5mr28369650ybm.20.1628454173366;
 Sun, 08 Aug 2021 13:22:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210711223148.5250-1-rdunlap@infradead.org> <20210711223148.5250-7-rdunlap@infradead.org>
In-Reply-To: <20210711223148.5250-7-rdunlap@infradead.org>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Sun, 8 Aug 2021 22:22:42 +0200
X-Gmail-Original-Message-ID: <CAHmME9pqLEmNKu1gZDsvTbukzqv8O2kCp6ndQROTu9RzcPnrVA@mail.gmail.com>
Message-ID: <CAHmME9pqLEmNKu1gZDsvTbukzqv8O2kCp6ndQROTu9RzcPnrVA@mail.gmail.com>
Subject: Re: [PATCH 6/6 v2] wireguard: main: rename 'mod_init' & 'mod_exit'
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

Thanks, I've applied this to the wireguard stable tree, and it'll be
sent off to netdev during the next push there.

Regards,
Jason
