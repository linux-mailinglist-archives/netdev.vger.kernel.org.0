Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7040F4A423D
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 12:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359370AbiAaLLL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 06:11:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377588AbiAaLKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 06:10:13 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDDE0C06175B;
        Mon, 31 Jan 2022 03:10:05 -0800 (PST)
Date:   Mon, 31 Jan 2022 12:10:02 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643627404;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VU/JLz6tZsfDSK1NGHlZJZDBKesuKZckLqSjhO2EaU4=;
        b=MlRIySoABztrXXhRXSWmvo2UV3/cD+W5Hip49G7RuhEGWfXMve9+967C7hina7NbgL0gsA
        aUsyVHVYqGGLzEAbCDnSBVARPcsyU62kssRd0FSyDb89J9lITtt7CgXLZ0DSZlUdLN5T/w
        qHNlm/789QXdfRSQ37F2M6KewwXuqn/+0LdECa+8B6SFUBy6IZuEV8ZmutujHGlddT6mSy
        LNUV9GJiEmtcb0UHeocT/ZyR7a+euq531BP7TAhXOFfSViefgJbswq1Ben8f0CIQKhfO4J
        DX/KxI7Aj22VxGxM8DU0CabHTBLnbrQsayoEQ4Y/4pFVta2+UVm6Q+TlXVYbSw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643627404;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VU/JLz6tZsfDSK1NGHlZJZDBKesuKZckLqSjhO2EaU4=;
        b=EsmtkMsJP6d5SP/mA+91F7XriKaPzaz7coj7QQMGILO4ncBzqs3VZj2EY51lcXyjhTegar
        UlifgoPYSZH9lYAA==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Wolfram Sang <wsa@kernel.org>, greybus-dev@lists.linaro.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alex Elder <elder@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH 3/7] i2c: cht-wc: Use generic_handle_irq_safe().
Message-ID: <YffDiv+NNWYFXJkX@linutronix.de>
References: <20220127113303.3012207-1-bigeasy@linutronix.de>
 <20220127113303.3012207-4-bigeasy@linutronix.de>
 <YfLThZsBwAucs2vp@shikoro>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YfLThZsBwAucs2vp@shikoro>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-01-27 18:16:53 [+0100], Wolfram Sang wrote:
> On Thu, Jan 27, 2022 at 12:32:59PM +0100, Sebastian Andrzej Siewior wrote:
> > Instead of manually disabling interrupts before invoking use
> > generic_handle_irq() which can be invoked with enabled and disabled
> 
> generic_handle_irq_safe()

Yes, thank you.

Sebastian
