Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 829D72F19FE
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 16:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732355AbhAKPrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 10:47:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:59592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731838AbhAKPrD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 10:47:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69B0A20897;
        Mon, 11 Jan 2021 15:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610379983;
        bh=Vb4EWJGhtPIfUX19jNXMSL+D+Wx8b6XEpNClUK+58ko=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=omf8WyqzAdFiNBENs6FDTp9dRwmDGFd7toldLz8gPhXncb+6VzD6JuWiCmSB63EbX
         2hGoxcFQ+P+dgxd43gmBFKm7BzyzYP3WPdiydrAughKwpyHeAwEqRxrLgdbuYv9CF4
         JAQMCjUr2lv6eCzoXhq8KVh3VwnIdY9FT2H7Ym1c1PwPPQPN3Z5Z9fX6B5NS7atdu8
         X/8JB8BJTVrsa0o7A7X5RJNbLMvEeLfaomqDHW4x8j/GUuERevKI6LqK4jof5fz5jx
         GpP8UWC6McyCY+kkqzIGMUuL2umI5S7EpSjyyfpDbmQVKSQkWHZ1y7WVfseDhiQJMr
         aif/UEIZZHTog==
Date:   Mon, 11 Jan 2021 16:46:16 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Frank Wunderlich <frank-w@public-files.de>,
        =?UTF-8?B?UmVuw6k=?= van Dorst <opensource@vdorst.com>
Subject: Re: [PATCH net-next 0/2] dsa: add MT7530 GPIO support
Message-ID: <20210111164616.1947d779@kernel.org>
In-Reply-To: <20210111054428.3273-1-dqfext@gmail.com>
References: <20210111054428.3273-1-dqfext@gmail.com>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Qingfang,

what modes does the LED support? Does it support blinking on rx/tx?
What about link status?
I'd like to know because I am still working on patches which add
ethernet PHY/switch LEDs, with transparent offloading of netdev trigger.

Marek

On Mon, 11 Jan 2021 13:44:26 +0800
DENG Qingfang <dqfext@gmail.com> wrote:

> MT7530's LED controller can be used as GPIO controller. Add support for
> it.
> 
> DENG Qingfang (2):
>   dt-bindings: net: dsa: add MT7530 GPIO controller binding
>   drivers: net: dsa: mt7530: MT7530 optional GPIO support
> 
>  .../devicetree/bindings/net/dsa/mt7530.txt    |  6 ++
>  drivers/net/dsa/mt7530.c                      | 96 +++++++++++++++++++
>  drivers/net/dsa/mt7530.h                      | 20 ++++
>  3 files changed, 122 insertions(+)
> 

