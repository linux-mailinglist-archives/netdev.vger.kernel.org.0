Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98D9D2F5973
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:42:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbhANDjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 22:39:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:57472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726198AbhANDjo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 22:39:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A793E23719;
        Thu, 14 Jan 2021 03:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610595543;
        bh=uZR4mGwmgbLda6MnfOZFuaM1lXpb5wXv+VHdTxpquRw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OzOWegX7KoHfUpfLjt5zRUuTHoHxSscpaPpz6fVZpJvZNN2e0JaqpHvQIyB3D1ILy
         A8RHCn5wQaEW0Ykb7MTKyRFkU8BDUrWzyFothqW8pzTn4LbojM+dr3gE1Ajjm1JqtF
         ycPTlxqtvQgI21CTTj5XRuAkU7zRJHR8HP2tZZZdZCOvynNZxidviXTgHmXw5w9Ctn
         V0O6d4Ak+drP856WxuHhvd7N2Qp5aEdViyssUcmdBa7JOD5XKu9x/2CkoEE5QXPiyJ
         gSKdBX9khfqLo2d1ecNEZ3DPzWItdXscKmjrwS+MiCMdw17VYChKzBc8g1Rwjc6elR
         /8aLVNW9rb92A==
Date:   Wed, 13 Jan 2021 19:39:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Gwendal Grignou <gwendal@chromium.org>,
        linux-iio <linux-iio@vger.kernel.org>
Subject: Re: [PATCH v1 1/1] time64.h: Consolidated PSEC_PER_SEC definition
Message-ID: <20210113193900.69b69a7c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210112153709.1074-1-andriy.shevchenko@linux.intel.com>
References: <20210112153709.1074-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Jan 2021 17:37:09 +0200 Andy Shevchenko wrote:
> We have currently three users of the PSEC_PER_SEC each of them defining it
> individually. Instead, move it to time64.h to be available for everyone.
> 
> There is a new user coming with the same constant in use. It will also
> make its life easier.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Which tree will you send the new user to? I'm not sure who you're
expecting to take this patch :S
