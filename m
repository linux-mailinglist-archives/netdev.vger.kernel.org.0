Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87F4E1225BC
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 08:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbfLQHnK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 17 Dec 2019 02:43:10 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:54973 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbfLQHnK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 02:43:10 -0500
Received: from marcel-macbook.fritz.box (p4FF9F0D1.dip0.t-ipconnect.de [79.249.240.209])
        by mail.holtmann.org (Postfix) with ESMTPSA id D2372CED3F;
        Tue, 17 Dec 2019 08:52:19 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.40.2.2.4\))
Subject: Re: [PATCH v5 2/2] bluetooth: hci_bcm: enable IRQ capability from
 devicetree
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <7ho8wc87vy.fsf@baylibre.com>
Date:   Tue, 17 Dec 2019 08:43:07 +0100
Cc:     Guillaume La Roque <glaroque@baylibre.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, nsaenzjulienne@suse.de,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <18AAF11E-26CA-4753-8F16-C90DCBC15D38@holtmann.org>
References: <20191213150622.14162-1-glaroque@baylibre.com>
 <20191213150622.14162-3-glaroque@baylibre.com> <7ho8wc87vy.fsf@baylibre.com>
To:     Kevin Hilman <khilman@baylibre.com>
X-Mailer: Apple Mail (2.3608.40.2.2.4)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Guillaume,

>> Actually IRQ can be found from GPIO but all platforms don't support
>> gpiod_to_irq, it's the case on amlogic chip.
>> so to have possibility to use interrupt mode we need to add interrupts
>> property in devicetree and support it in driver.
> 
> I would reword this slightly (leaving out the amlogic specifics):
> 
> """
> Add support for getting IRQ directly from DT instead of relying on
> converting a GPIO to IRQ. This is needed for platforms with GPIO
> controllers that that do not support gpiod_to_irq().
> """
> 
> Other than that, this looks good to me and now it's clear that it only
> affects the DT path.
> 
> Reviewed-by: Kevin Hilman <khilman@baylibre.com>

I reverted the broken patch and now I am waiting for v6 with proper reviewed-by or acked-by tags.

Regards

Marcel

