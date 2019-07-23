Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40A49713E7
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 10:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733210AbfGWIYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 04:24:11 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:34162 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733199AbfGWIYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 04:24:10 -0400
Received: by mail-lf1-f67.google.com with SMTP id b29so21468787lfq.1
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 01:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z4oiDNheB7tcp4OlfdwdNJixiwjQ7CN/OqrZSF2BQl4=;
        b=ia1JfK+7eINBofKtKO04fnLG2c/ORhlen9wzZsM3f9jtvacXw9wzVipd/IKpZyIvt1
         lHiZytrgcytx8wNSN/KWkpGTYd2Pc+5F6WztnIV747hg4bWIFwcLpBrgxDIQPi9bxm9k
         yaKEWcLo7Avc1KZD51rYRu3VdD8EC4p5AMW4LA4gJyumXz3WtvcQJO/qcDAmSCxTsQvb
         NJ00x/3dUoIP8iWdxEHFbjRzvM1VietYOAkDZd/S2iPkneOyqH6ZyCMENQyxWanGeVlv
         gmGyqfEwS9tNOy4P5+KQlY4JIBwPnHXOAayXHOoVjd0w5Ea5vTo5b5AamT0F0Q+RTEeK
         Kuhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z4oiDNheB7tcp4OlfdwdNJixiwjQ7CN/OqrZSF2BQl4=;
        b=BEY8QSvZD6AuhkWzT4AnHSdt7QkhQY1Jzne3cxI/uMrifp+03MiqrWCVD7h8XT88TO
         40uAP4+zrSi29Le50Necgk0Yz/kNV23O2quzwejwGj3lxqVFGfgxb4J8Xkza5WClucic
         uuGYJxZPA+1sqFQ5DWWSFS3DT1Qf0up1cFUfXnzRmEiwwfumUdBpQ56kxNjfED5kvBjp
         pSlzajP4NfZ3hoJ+6NCBVj1AcxiIeTJnTIfvdEu6oWO2xa58ItRAzMy0jCsLXa/r2F/L
         HD2DI04gExN7vZRQ9AsOKXIJMTxbsWTSuiHgEKZT36sLLBNimZjO8Raf5gXeBPhJMMhU
         tssg==
X-Gm-Message-State: APjAAAWKzX9RHXik3NRmeVeM5WE3xJAAfJsw3SAbLieBjGaWl6ZotVyx
        URlS3gFsTMJxZb/ars8gKgTqxVr39fP1F6LRqz0+dQ==
X-Google-Smtp-Source: APXvYqxRHlls9XsJdn6N1L6aNp6XRxRHchgvWi1x+4y2L86sh1FPQdZY43ccO4gdutnunaw+n+p1U04JRza21fs1hSg=
X-Received: by 2002:a19:6a01:: with SMTP id u1mr34253339lfu.141.1563870248944;
 Tue, 23 Jul 2019 01:24:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190722191304.164929-1-arnd@arndb.de>
In-Reply-To: <20190722191304.164929-1-arnd@arndb.de>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 23 Jul 2019 10:23:57 +0200
Message-ID: <CACRpkdZMRmF_CEhXJYyeNEThwHc-ihEReLgU2pvJWjWiBnNFWw@mail.gmail.com>
Subject: Re: [PATCH 1/3] [net-next] net: remove netx ethernet driver
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, linux-serial@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg KH <gregkh@linuxfoundation.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 22, 2019 at 9:13 PM Arnd Bergmann <arnd@arndb.de> wrote:

> The ARM netx platform got removed in 5.3, so this driver
> is now useless.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

I thought I sent a patch like this yesterday but it apparently
never left the mailserver as I can't find it in the archives.

Linus Walleij
