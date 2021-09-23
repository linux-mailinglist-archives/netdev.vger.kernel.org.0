Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA4C416159
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 16:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241797AbhIWOqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 10:46:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56854 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241662AbhIWOqb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 10:46:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=jgw3MMJ0lzxDwTLbKoxnzju2sR5xuO3tCpwWUyzdaVM=; b=5KZbXBLUQK5qVswEJ9j+i2ivay
        bWkLe4WSrL+UrGKXIl37f361qEetSrmD9i0NfuGxywkAzcgFrxtI30ZA4xr2gvkhknVp1IHDGjgEb
        JIOmUNc246POrMUPYpQy3OgsvVeFwG0c2fYbl1FkqUcbVM69qSIvn9G3tSS9guO3rIMM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mTPy5-007wKT-7K; Thu, 23 Sep 2021 16:44:57 +0200
Date:   Thu, 23 Sep 2021 16:44:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Asmaa Mnebhi <asmaa@nvidia.com>
Cc:     "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "bgolaszewski@baylibre.com" <bgolaszewski@baylibre.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        David Thompson <davthompson@nvidia.com>
Subject: Re: [PATCH v2 1/2] gpio: mlxbf2: Introduce IRQ support
Message-ID: <YUyS6fqD1TJU+sPt@lunn.ch>
References: <20210920212227.19358-1-asmaa@nvidia.com>
 <20210920212227.19358-2-asmaa@nvidia.com>
 <YUpdjh8dtjz29TWU@lunn.ch>
 <CH2PR12MB38951F1A008AE68A6FE7ED96D7A29@CH2PR12MB3895.namprd12.prod.outlook.com>
 <YUtEZvkI7ZPzfffo@lunn.ch>
 <CH2PR12MB3895D489497D7F45B4A45A34D7A39@CH2PR12MB3895.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CH2PR12MB3895D489497D7F45B4A45A34D7A39@CH2PR12MB3895.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> No we don't. I double checked with the HW team and they confirmed that
> YU_GPIO_CAUSE_FALL_EN and YU_GPIO_CAUSE_RISE_EN are used in
> Both level and edge interrupts cases.

How? They are different things.

I suggest you test this. Make sure a level interrupt real does fire on
level. One simple test is use a resistor to force the interrupt pin
low. Your machine should then die in an interrupt storm, until the
kernel declares the interrupt broken and disables it.

       Andrew
