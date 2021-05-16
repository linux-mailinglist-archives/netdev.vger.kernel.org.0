Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91A40381C64
	for <lists+netdev@lfdr.de>; Sun, 16 May 2021 06:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232503AbhEPEZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 May 2021 00:25:24 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:34528 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbhEPEZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 May 2021 00:25:23 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id 52ACE27E19;
        Sun, 16 May 2021 00:23:59 -0400 (EDT)
Date:   Sun, 16 May 2021 14:24:07 +1000 (AEST)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Arnd Bergmann <arnd@kernel.org>
cc:     netdev@vger.kernel.org, linux-m68k@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sam Creasey <sammy@sammy.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        linux-kernel@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com
Subject: Re: [RFC 13/13] [net-next] 8390: xsurf100: avoid including
 lib8390.c
In-Reply-To: <20210515221320.1255291-14-arnd@kernel.org>
Message-ID: <d4e42d3-9920-8fe0-1a71-6c6de8585f4c@nippy.intranet>
References: <20210515221320.1255291-1-arnd@kernel.org> <20210515221320.1255291-14-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 16 May 2021, Arnd Bergmann wrote:

> From: Arnd Bergmann <arnd@arndb.de>
> 
> This driver always warns about unused functions because it includes
> an file that it doesn't actually need:
> 

I don't think you can omit #include "lib8390.c" here without changing 
driver behaviour, because of the macros in effect.

I think this change would need some actual testing unless you can show 
that the module binary does not change.
