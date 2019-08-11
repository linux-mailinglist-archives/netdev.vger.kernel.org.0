Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 995028928B
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 18:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725847AbfHKQVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 12:21:37 -0400
Received: from mail.nic.cz ([217.31.204.67]:50782 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbfHKQVh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Aug 2019 12:21:37 -0400
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id C36E914093E;
        Sun, 11 Aug 2019 18:21:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1565540495; bh=XjxcCoyM0l71Gmn2NY3/Q1Ou3Hi58e79S5FJPc9db9k=;
        h=Date:From:To;
        b=Jk3cABF2zunWFWda6It8GsKycLs4Rl4R3zBLkyDGfz8ARutHMtz8A6ufOsYUmGeO/
         7/FxjD7cA7SkCOySv8gVyotdOSMq47hl65In6u+q1z+qLZmqhTzC2dk5HxV/LSlGQg
         GFK31ZQebrdKCCmoU3ZvMsz4Q0BZfMvAGXmlUbCc=
Date:   Sun, 11 Aug 2019 18:21:35 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v2 1/1] net: dsa: fix fixed-link port
 registration
Message-ID: <20190811182135.24e6c320@nic.cz>
In-Reply-To: <CA+h21hoOZQ79rj0SLZGLnkSjrKD3aLNos0GcnRjre-Ls=Tq=4w@mail.gmail.com>
References: <20190811031857.2899-1-marek.behun@nic.cz>
        <20190811033910.GL30120@lunn.ch>
        <91cd70df-c856-4c7e-7ebb-c01519fb13d2@gmail.com>
        <20190811160404.06450685@nic.cz>
        <CA+h21hoOZQ79rj0SLZGLnkSjrKD3aLNos0GcnRjre-Ls=Tq=4w@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.3 at mail.nic.cz
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 11 Aug 2019 18:16:11 +0300
Vladimir Oltean <olteanv@gmail.com> wrote:

> The DSA fixed-link port functionality *has* been converted to phylink.
> See:
> - https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/commit/?id=0e27921816ad9
> - https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/commit/?id=7fb5a711545d7d25fe9726a9ad277474dd83bd06
>

/o\ my bad. I did not realize that I was working on 5.2 :(. Sorry.
