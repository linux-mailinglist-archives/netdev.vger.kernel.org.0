Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB1CE28D79A
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 02:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730562AbgJNAmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 20:42:00 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:55050 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727837AbgJNAmA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 20:42:00 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602636118;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PzR5IL2R4gmikKwFDAs0pPeoY0Y9a98SsklSREDDfb4=;
        b=Oq+TQlP2jTdRZ8atVcna0hBG3Mif8apL8lo8ABwFCcvoSyQHLCO5++KkZZyISI8mV7Sups
        JDQ1xXKsJo0ZQogGfutGBbRTv0JztilESpPGkxYxSXX7PYGXjh6wVS86wvFPIAOGPkLbWs
        KImNmdm3Cb4zDpsI1/bDdFmGPljGPYtAFca2r195ErzJii3yNGB0vzXB1K3zTgwFSO8gyt
        HdnITc1g5P5Echdwf26iQJCDwK4cEooqmveyLSnHjqcQhqb2zWw2698h2NUSX4p5kcOFW4
        sEEhRRVep0y4CfvclwgRGIghK7DNPYKlsUTgrYE/muKZNjZk1IAWcpuYoHIgbQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602636118;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PzR5IL2R4gmikKwFDAs0pPeoY0Y9a98SsklSREDDfb4=;
        b=ghNT47llkkGQ5teUGbdFVTcJGuV2/Bt3/JhiSH78wK39Ec0EzeZfTyPKVBOUAMKwo+cX1U
        sS39ScobvaZmY4Cg==
To:     Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@armlinux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/3] timekeeping: remove arch_gettimeoffset
In-Reply-To: <20201008154601.1901004-4-arnd@arndb.de>
References: <20201008154601.1901004-1-arnd@arndb.de> <20201008154601.1901004-4-arnd@arndb.de>
Date:   Wed, 14 Oct 2020 02:41:58 +0200
Message-ID: <87wnztbpux.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 08 2020 at 17:46, Arnd Bergmann wrote:
> With Arm EBSA110 gone, nothing uses it any more, so the corresponding
> code and the Kconfig option can be removed.

Yay! It only took 11+ years to get rid of that.

Feel free to route it through your tree.

Acked-by: Thomas Gleixner <tglx@linutronix.de>
