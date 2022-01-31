Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 496184A4670
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 12:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359304AbiAaL4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 06:56:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379359AbiAaLxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 06:53:46 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FC3EC08ED78;
        Mon, 31 Jan 2022 03:16:12 -0800 (PST)
Date:   Mon, 31 Jan 2022 12:16:09 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643627771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ll9KYARRuBZxRo09tM644QKrs5m7bsyeSqNKNu1Ai5c=;
        b=QJK53clJumtX9s0dxa4QZmUp1wdIpcTFOVfNRju6Mii59Nhxumj5PbxnCD4YIG6qIWTVVG
        9L7zxyNwgikDsUUyIwuFK79UyAeB34C+zuMtZVMYKBmjkuR9krx0gpQDlQPK4+LdR/hKIO
        glESyBcvyQY/QjgcDDId0hHYsvzPtwUcRjmBx6KqGp8v/FiZfC/U1uDAy8SOrpX4zhIQlZ
        7cbm/5T0Ho6nnUB/CjuX0+tMSEIVp+RcWNWYTuPWnyoNOgoq9jUcEt0XYk+6vRxVBq2GUG
        lYIpoR7WuPpkoKOyFN212omM6hjlz6bith9xh+KRpvxYnyQJZncfYA0ZyoDiaA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643627771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ll9KYARRuBZxRo09tM644QKrs5m7bsyeSqNKNu1Ai5c=;
        b=3nJZTRll2KKofcUlVbQaYLwLfUrkueiuloW8jj5eVHwVhU6NIL3VsqQeF07eMJyqEHZJnY
        e4MwZh8L7xEN4GCQ==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>
Cc:     greybus-dev@lists.linaro.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alex Elder <elder@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        UNGLinuxDriver@microchip.com, Wolfram Sang <wsa@kernel.org>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH 4/7] mfd: hi6421-spmi-pmic: Use generic_handle_irq_safe().
Message-ID: <YffE+XxLpFKw+7HS@linutronix.de>
References: <20220127113303.3012207-1-bigeasy@linutronix.de>
 <20220127113303.3012207-5-bigeasy@linutronix.de>
 <44b42c37-67a4-1d20-e2ff-563d4f9bfae2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <44b42c37-67a4-1d20-e2ff-563d4f9bfae2@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-01-28 13:23:08 [+0300], Sergei Shtylyov wrote:
> On 1/27/22 2:33 PM, Sebastian Andrzej Siewior wrote:
> 
> > generic_handle_irq() is invoked from a regular interrupt service
> > routing. This handler will become a forced-threaded handler on
> 
>    s/routing/routine/?

Yes, thank you.

Sebastian
