Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52D3418AAAC
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 03:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgCSCa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 22:30:57 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:42981 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726666AbgCSCa5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 22:30:57 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id f3cbff15
        for <netdev@vger.kernel.org>;
        Thu, 19 Mar 2020 02:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=g6A32MSUUWuv2ZxSHa6ARWw2KGE=; b=Inu/l2
        K/tk2oeCrwm4c3Lj0YTBJ5bVO9a1UHZF1f8rNrfvtOYRJbUepUDX5p5FEoi8RQeC
        evdbjzdDZjqk5siGrMu9ePqCAo5+KyUI4lQ3f7Q1OiCcD8Houwf257z+Q1IC0mGB
        ycFc1Chb3czlcyVr6bP4kUxee0Afvuisw2wfQeY6kvDGphb8uYN5NPD5bC7GNegC
        M2ZAQGn9qDjmC2QD9iChlxcRInWwSHHHS/vivbma+qsGNjwZ/k/z/AbTMKKAtU68
        0lMY0Wfriuem7d9fWLEUaSWtRC9HVfl7Gc4e4KkaA4CJ9sZoXRx/H3I6Q21O77Ps
        kc5Todgt5Jb8tTzg==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id ef3c44bb (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Thu, 19 Mar 2020 02:24:31 +0000 (UTC)
Received: by mail-io1-f42.google.com with SMTP id q9so707393iod.4
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 19:30:56 -0700 (PDT)
X-Gm-Message-State: ANhLgQ23jrSb646aZYQSHVK2gjFUGwuFOujXhIBX2nTMcs2ZxjdpbWLC
        DbxwYF7LGGnUp0JtXCbFOEvf+x/dveyE52Sjy9U=
X-Google-Smtp-Source: ADFU+vsXaIu85W0+0SGmdA7XIRB2YRaT2X8TB6eYqsZXaXWhwyNOClya6DeqgLn5UcjVzK49rZS56E4MXGNk9YcO1i4=
X-Received: by 2002:a05:6638:308:: with SMTP id w8mr1075831jap.108.1584585055902;
 Wed, 18 Mar 2020 19:30:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200319003047.113501-1-Jason@zx2c4.com> <20200318.185454.2276380590236986388.davem@davemloft.net>
In-Reply-To: <20200318.185454.2276380590236986388.davem@davemloft.net>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 18 Mar 2020 20:30:44 -0600
X-Gmail-Original-Message-ID: <CAHmME9pf5dhGHdg851a4Ru48k+exVbBNd9H3N6xFjPbnbruA8g@mail.gmail.com>
Message-ID: <CAHmME9pf5dhGHdg851a4Ru48k+exVbBNd9H3N6xFjPbnbruA8g@mail.gmail.com>
Subject: Re: [PATCH net 0/5] wireguard fixes for 5.6-rc7
To:     David Miller <davem@davemloft.net>
Cc:     Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 18, 2020 at 7:55 PM David Miller <davem@davemloft.net> wrote:
> Series applied, please start providing appropriate Fixes: tags in the
> future.

No problem, will do.

Jason
