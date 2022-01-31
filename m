Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 660264A4799
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 13:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377808AbiAaMyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 07:54:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359418AbiAaMym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 07:54:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9693DC061714;
        Mon, 31 Jan 2022 04:54:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 36C996118E;
        Mon, 31 Jan 2022 12:54:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3E7BC340E8;
        Mon, 31 Jan 2022 12:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643633680;
        bh=TpJ4GEaPX4PexsdhB7cwBnQoTsa0mM3UYOZrz61hFCQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Lip3gxDRdljxy/WnzSa0TQWZh+hycP2AAk7TUnTaNs4BhttJmfWwxNiHfgg2Lv3F/
         V/b1FyCeTx/MdOJjyN+pRX9mZi5Qm8ppCu3axLZywdUyvzZreLSoKdPqV+06qvMVSJ
         7qd4t0Ad8/jncvDN4ziIGmOOl+uyk0hjo08KmguA=
Date:   Mon, 31 Jan 2022 13:54:37 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     greybus-dev@lists.linaro.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alex Elder <elder@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Hans de Goede <hdegoede@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        UNGLinuxDriver@microchip.com, Wolfram Sang <wsa@kernel.org>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH v2 7/7] staging: greybus: gpio: Use
 generic_handle_irq_safe().
Message-ID: <YffcDdhRLvyoW3eB@kroah.com>
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

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
