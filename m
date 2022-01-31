Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EACB4A4073
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 11:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234637AbiAaKrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 05:47:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbiAaKrj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 05:47:39 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DABE2C061714;
        Mon, 31 Jan 2022 02:47:38 -0800 (PST)
Date:   Mon, 31 Jan 2022 11:47:29 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643626051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IvT+96WC4xlc86N7eSlAFMmOlclUSR1CkGpGq2QgIX8=;
        b=KZMyEJRre/OttTzp9HkeBp+HSKli3uTN429Y3mRSBq/r1Mpxrd1Ltk29IKGetZ97dQ0I2j
        Ga6uTRd1q1TzAkUfqqU5SpZ5bMaBwFDStAYV/5QXO1WDzMGVq36JOqnfHHvv9RC6RXKK5I
        ZRmJKVhJrSR/OWPcmrLv2OLnTKwexMDSzxhF3mXSTUr8V9Wmd2vDYkAkZBCsyfPwBldb6U
        /kvmF5kGEZdEqh1YWN8yMzfYI5LYYlfHwgHYNPZ8YnVNB3QewJ00Yj7kgfgVEkfXalxS9t
        tQ6pwHXaeSPRG4AnB85Kx9l8O2eTGhhPLzBpx3nf8TIssmpitr7feb+kQkvnkw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643626051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IvT+96WC4xlc86N7eSlAFMmOlclUSR1CkGpGq2QgIX8=;
        b=cVrD8VA+0PMCB+FD65Xrt8Wz4qGuljy8hfkRLVd7SpOP0A49Uyb3uF79h/L8DsKn3i3/TB
        ONpvSGGPh4iijGBQ==
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
Subject: Re: [PATCH 1/7] genirq: Provide generic_handle_irq_safe().
Message-ID: <Yfe+QRJh8OIPSuD1@linutronix.de>
References: <20220127113303.3012207-1-bigeasy@linutronix.de>
 <20220127113303.3012207-2-bigeasy@linutronix.de>
 <YfLQYa5aKJKs7ZUe@shikoro>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YfLQYa5aKJKs7ZUe@shikoro>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-01-27 18:03:29 [+0100], Wolfram Sang wrote:
> Hi Sebastian,
Hi Wolfram,

> > +/**
> > + * generic_handle_irq_safe - Invoke the handler for a particular irq
> 
> This is the same desc as for generic_handle_irq(). I suggest to add
> something like "from any context" to have some distinction.

There is something later but let me reword that.

> > + * This function must be called either from an IRQ context with irq regs
> > + * initialized or with care from any context.
> 
> I think "with care" is not obvious enough. Can you describe it a little?

Yeah, will do.

> Thanks for this work,
> 
>    Wolfram

Sebastian
