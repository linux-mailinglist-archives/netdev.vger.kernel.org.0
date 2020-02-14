Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCAE15E3D1
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 17:32:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389537AbgBNQcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 11:32:25 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46302 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393515AbgBNQcX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 11:32:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=EVE2QyhWUcN4faOpoE+Hy0shAp6QLvkX+MzRUb+BF8o=; b=DGtJGdns92ALhj0LSBlHNMtF6I
        DhAVpF8S7uZJn68IIMdm5g7arm1DSs0SWj7Amd4JzBs7bUmEUo/exo8CrdC8PyDeRRLSst8j7eoCi
        9IETsM3kUrmjRbteV9lFAM1gS/qNFrporaX9mIi83Yd7vypiemAz2aZPpdmSK7V00J08=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j2dsr-0000Hl-9O; Fri, 14 Feb 2020 17:32:05 +0100
Date:   Fri, 14 Feb 2020 17:32:05 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     Paul Cercueil <paul@crapouillou.net>,
        "David S. Miller" <davem@davemloft.net>,
        Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>,
        Richard Fontana <rfontana@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, letux-kernel@openphoenux.org,
        kernel@pyra-handheld.com
Subject: Re: [PATCH v2] net: davicom: dm9000: allow to pass MAC address
 through mac_addr module parameter
Message-ID: <20200214163205.GL31084@lunn.ch>
References: <0d6b4d383bb29ed5d4710e9706e5ad6c7f92d9da.1581696454.git.hns@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d6b4d383bb29ed5d4710e9706e5ad6c7f92d9da.1581696454.git.hns@goldelico.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 14, 2020 at 05:07:35PM +0100, H. Nikolaus Schaller wrote:
> The MIPS Ingenic CI20 board is shipped with a quite old u-boot
> (ci20-v2013.10 see https://elinux.org/CI20_Dev_Zone). This passes
> the MAC address through dm9000.mac_addr=xx:xx:xx:xx:xx:xx
> kernel module parameter to give the board a fixed MAC address.

I think this will get ACKed.

There is a well defined way to pass the MAC address via DT. The driver
supports that already.

uboot for this board appears to be open:

https://github.com/MIPS/CI20_u-boot

and it is documented to how build it.

So there is no reason why it cannot be made to support the standard
mechanism.

	Andrew
