Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 840A23D66E4
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 20:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231958AbhGZSDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 14:03:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:53144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230032AbhGZSDu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 14:03:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C709460F59;
        Mon, 26 Jul 2021 18:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627325059;
        bh=HboBVhjDpRLHQmXcnm5oCAcUI5VwjPBPwHAZnRlAcac=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NbWPMzLRKIn9zlbL5g3TB+sDUOU/LVAF3b2MlBBKQfSCiFSLjol2veiR3dXIqAquq
         tb5vkC2Wl4drEcy8NOmLQ9rliVEfcz9iH/3sgO8Dw848Ifx7jS8IV6WZjPVe2UgP5X
         C1glmgtWuQ09K1IL622k9gpQOXe3BsmM5g6nMiBPwY6vgIB+fY1eI+EN3wTkCuZZIS
         p/PdO+0d0EPHFFnxZ1pZtwjZdh24+oIJABjwUK9MTZV9Olx+gYCglo0AEfw51EFY4X
         Euc4nj+OHJL5g+S1zIB1za/m22v8Csm5YkAnxe6+Qamm1yo4OPr/IRnZyZvsfNzmd0
         nmFzx1oZdh9+A==
Date:   Mon, 26 Jul 2021 20:44:13 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Jacek Anaszewski <jacek.anaszewski@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Pavel Machek <pavel@ucw.cz>,
        Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org, Kurt Kanzenbach <kurt@linutronix.de>,
        netdev@vger.kernel.org, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com, vinicius.gomes@intel.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
Message-ID: <20210726204413.652202f7@thinkpad>
In-Reply-To: <4d8db4ce-0413-1f41-544d-fe665d3e104c@gmail.com>
References: <20210716212427.821834-1-anthony.l.nguyen@intel.com>
        <20210716212427.821834-6-anthony.l.nguyen@intel.com>
        <f705bcd6-c55c-0b07-612f-38348d85bbee@gmail.com>
        <YPTKB0HGEtsydf9/@lunn.ch>
        <88d23db8-d2d2-5816-6ba1-3bd80738c398@gmail.com>
        <YPbu8xOFDRZWMTBe@lunn.ch>
        <3b7ad100-643e-c173-0d43-52e65d41c8c3@gmail.com>
        <20210721204543.08e79fac@thinkpad>
        <YPh6b+dTZqQNX+Zk@lunn.ch>
        <20210721220716.539f780e@thinkpad>
        <4d8db4ce-0413-1f41-544d-fe665d3e104c@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Jul 2021 19:42:04 +0200
Jacek Anaszewski <jacek.anaszewski@gmail.com> wrote:

> I believe you must have misinterpreted some my of my statements.
> The whole effort behind LED naming unification was getting rid of
> hardware device names in favour of Linux provided device names.

Hi Jacek,

sorry about that. I don't know how this could have happened :D

Marek
