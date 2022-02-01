Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61FD54A5970
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 10:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236161AbiBAJpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 04:45:40 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40726 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236025AbiBAJpg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 04:45:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D3DCB82D3D;
        Tue,  1 Feb 2022 09:45:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B061BC340EB;
        Tue,  1 Feb 2022 09:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643708733;
        bh=MdErCthUfXwIMsMrpwhF/rPVygWP2deZtH4s9Fv9QMc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C44sCAaJEvPyJHh+AcUv43SuqCvTXQZGEIwVN3ocROKifl7mguDUBDImrPQ7wQxFv
         B/aOg6wDv0t3KthsBqjzjScooiRKE9ubLupZJBnzmKvPcIRsGY8LinhOn43mFpF4IP
         KwQDW7ds5jViZCIF9W34wYdY3yCrThx9nmnZ6vgpit6jJDI/2A+dyX42lUWuRfnQiZ
         5KoxK/7LLx0LXJFg143vsjRmpiXNYOgl1gwgt02kk2O1y2YYRlyrngtzMoJGP7U/7X
         reWjsk6E2ODJeP6lkqFJkDE2UfjJeaU+IUEikY2sRutpWEFRXeW7dwqs8b9FxzaWTJ
         NbuaCm0qqSh9A==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1nEpiv-0000sL-1O; Tue, 01 Feb 2022 10:45:17 +0100
Date:   Tue, 1 Feb 2022 10:45:17 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     greybus-dev@lists.linaro.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alex Elder <elder@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        UNGLinuxDriver@microchip.com, Wolfram Sang <wsa@kernel.org>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH v2 7/7] staging: greybus: gpio: Use
 generic_handle_irq_safe().
Message-ID: <YfkBLesNdsxJMbxm@hovoldconsulting.com>
References: <20220131123404.175438-1-bigeasy@linutronix.de>
 <20220131123404.175438-8-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220131123404.175438-8-bigeasy@linutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 31, 2022 at 01:34:04PM +0100, Sebastian Andrzej Siewior wrote:
> Instead of manually disabling interrupts before invoking use
> generic_handle_irq_safe() which can be invoked with enabled and disabled
> interrupts.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Acked-by: Johan Hovold <johan@kernel.org>
