Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9EF64195F4
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 16:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234720AbhI0OJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 10:09:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33792 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234645AbhI0OJq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 10:09:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=IckG1sRzJnW/Mx/vKohnDrPDQtYCCkvkQ4ZGzZAHtkc=; b=P2UElf26lwjvNVBZKnhDCN+NU6
        nu8C7CXIA6aQ8Pg+wPzDJnZ8ZpG4Zn7vt+ekLSI1WmIHOKKF7DxZbFUFJWPogl/1dbuDJbai2v5iL
        Yvb5c1k80++7eOVUSMEJMbNTiSXb7/tUys28eWUvJ+xL5cSitKtw8O6QZAUEXrhLYMWQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mUrIX-008RkP-4J; Mon, 27 Sep 2021 16:08:01 +0200
Date:   Mon, 27 Sep 2021 16:08:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Asmaa Mnebhi <asmaa@nvidia.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        David Thompson <davthompson@nvidia.com>
Subject: Re: [PATCH v3 1/2] gpio: mlxbf2: Introduce IRQ support
Message-ID: <YVHQQcv2M6soJR6u@lunn.ch>
References: <20210923202216.16091-1-asmaa@nvidia.com>
 <20210923202216.16091-2-asmaa@nvidia.com>
 <YU26lIUayYXU/x9l@lunn.ch>
 <CACRpkdbUJF6VUPk9kCMPBvjeL3frJAbHq+h0-z7P-a1pSU+fiw@mail.gmail.com>
 <CH2PR12MB38951F2326196AB5B573A73DD7A79@CH2PR12MB3895.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CH2PR12MB38951F2326196AB5B573A73DD7A79@CH2PR12MB3895.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The BlueField GPIO HW only support Edge interrupts.

O.K. So please remove all level support from this driver, and return
-EINVAL if requested to do level.

This also means, you cannot use interrupts with the Ethernet PHY. The
PHY is using level interrupts.

    Andrew
