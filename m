Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62429116A8C
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 11:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbfLIKHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 05:07:35 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:46477 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726801AbfLIKHc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 05:07:32 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 5f4a0ed7;
        Mon, 9 Dec 2019 09:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=MzJW81Y2l9liUBJB6xdygpI6H4o=; b=D4yQpP
        ToqTcWOuLNSvqv42XXZtLwM+wq3bvnpgw1X35Cy+9SS81MrB+T7tfkr7dbH1zupx
        BhaVPA2zv1haRFCrxM2kkPYWczlodGtEPhAyB8sUyxbPKKQIwPgM6Q1KNlG5AHHB
        Ako9WX2xHOGqBvNl5AgGI4nAdKPk4+Lmcx8ZFeycBBU0dNGtbTp/HIkoK/mKg3zu
        r/fhV7E3LgzbAl/5gUOhu7VvrlycyLO+z1wOGm/ATOVrnLsH7b3N1N9itxrWqQ4z
        wVXks3r7VL31hC+IEOoFnku7LYXbWPKHL0iGCcHRd8OPVIxYv5zjgu9he0XCimnO
        aYC977hzI39h3+WA==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id c73e30a7 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Mon, 9 Dec 2019 09:12:06 +0000 (UTC)
Received: by mail-oi1-f175.google.com with SMTP id l136so5835068oig.1;
        Mon, 09 Dec 2019 02:07:29 -0800 (PST)
X-Gm-Message-State: APjAAAUHBkT009BfylPoZuddSE5vWCKwH+kZuUBbbcBzoPVjfv24wJNy
        dxM+hFe5eL7LS2pIXTJTlXD74PdcqKWRFKC+YYk=
X-Google-Smtp-Source: APXvYqzrtpXcTBYUHQPnLatbUuyLsHiq7IJk7Mrmbl3KgZotcTSAlcByvlElSfsmxye6pDFpFYSdAb3f/wV2X2FykNI=
X-Received: by 2002:aca:cf58:: with SMTP id f85mr23924143oig.6.1575886048379;
 Mon, 09 Dec 2019 02:07:28 -0800 (PST)
MIME-Version: 1.0
References: <20191208232734.225161-1-Jason@zx2c4.com> <20191208.175209.1415607162791536317.davem@davemloft.net>
In-Reply-To: <20191208.175209.1415607162791536317.davem@davemloft.net>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 9 Dec 2019 11:07:16 +0100
X-Gmail-Original-Message-ID: <CAHmME9pXLEhe1gJm84EzXCRONMH-VfBh6UsKQ_DLq1NyOSS+_Q@mail.gmail.com>
Message-ID: <CAHmME9pXLEhe1gJm84EzXCRONMH-VfBh6UsKQ_DLq1NyOSS+_Q@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net: WireGuard secure network tunnel
To:     David Miller <davem@davemloft.net>
Cc:     Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 9, 2019 at 2:52 AM David Miller <davem@davemloft.net> wrote:
>
> From: "Jason A. Donenfeld" <Jason@zx2c4.com>
> Date: Mon,  9 Dec 2019 00:27:34 +0100
>
> > WireGuard is a layer 3 secure networking tunnel made specifically for
> > the kernel, that aims to be much simpler and easier to audit than IPsec.
> > Extensive documentation and description of the protocol and
> > considerations, along with formal proofs of the cryptography, are
> > available at:
> >
> >   * https://www.wireguard.com/
> >   * https://www.wireguard.com/papers/wireguard.pdf
>  ...
>
> Applied, thanks Jason.

Thank you, Dave!
