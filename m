Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECDD386D80
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 01:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344299AbhEQXFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 19:05:42 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:38178 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233727AbhEQXFl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 19:05:41 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id 5611D21F27;
        Mon, 17 May 2021 19:04:19 -0400 (EDT)
Date:   Tue, 18 May 2021 09:04:17 +1000 (AEST)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Paul Gortmaker <paul.gortmaker@windriver.com>
cc:     Arnd Bergmann <arnd@kernel.org>, netdev@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sam Creasey <sammy@sammy.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        linux-kernel@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com
Subject: Re: [RFC 00/13] [net-next] drivers/net/Space.c cleanup
In-Reply-To: <20210517143805.GQ258772@windriver.com>
Message-ID: <dbbc513f-94cf-7bfe-9a14-46dc45b496a3@nippy.intranet>
References: <20210515221320.1255291-1-arnd@kernel.org> <20210517143805.GQ258772@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 May 2021, Paul Gortmaker wrote:

> Leaving the more popular cards was a concession to making progress vs. 
> having the whole cleanup blocked by individuals who haven't yet realized 
> that using ancient hardware is best done (only done?) with ancient 
> kernels.
> 

By extension, using ancient kernels is best done with ancient userland. 
And now the time has come to remove all the 'compat' nonsense.

Oh, wait, all of that old software seems to be riddled with bugs and 
vulnerabilities.

And who would have thought that all those developers writing new code for 
emulators and their users were holding up "progress"?

> Maybe things are better now; people are putting more consideration to
> the future of the kernel, rather than clinging to times long past?

If you've been doing engineering for a while you'll start to notice a 
pattern: old designs that work get reused. That's partly why the latest 
silicon contains ancient logic blocks.

When that changes, perhaps we can talk about "progress"...
