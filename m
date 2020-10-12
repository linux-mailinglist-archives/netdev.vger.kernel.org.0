Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6B828B271
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 12:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387632AbgJLKnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 06:43:00 -0400
Received: from hosting.gsystem.sk ([212.5.213.30]:37818 "EHLO
        hosting.gsystem.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387463AbgJLKnA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 06:43:00 -0400
Received: from [192.168.1.3] (ns.gsystem.sk [62.176.172.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hosting.gsystem.sk (Postfix) with ESMTPSA id 8B83D7A0192;
        Mon, 12 Oct 2020 12:42:58 +0200 (CEST)
From:   Ondrej Zary <linux@zary.sk>
To:     Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 1/2] cx82310_eth: re-enable ethernet mode after router reboot
Date:   Mon, 12 Oct 2020 12:42:55 +0200
User-Agent: KMail/1.9.10
Cc:     Oliver Neukum <oneukum@suse.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201010140048.12067-1-linux@zary.sk> <20201011155539.315bf5aa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201011155539.315bf5aa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <202010121242.55826.linux@zary.sk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday 12 October 2020, Jakub Kicinski wrote:
> On Sat, 10 Oct 2020 16:00:46 +0200 Ondrej Zary wrote:
> > When the router is rebooted without a power cycle, the USB device
> > remains connected but its configuration is reset. This results in
> > a non-working ethernet connection with messages like this in syslog:
> > 	usb 2-2: RX packet too long: 65535 B
> >
> > Re-enable ethernet mode when receiving a packet with invalid size of
> > 0xffff.
>
> Patch looks good, but could you explain what's a reboot without a power
> cycle in this case? The modem gets reset but USB subsystem doesn't know
> it and doesn't go though a unbind() + bind() cycle?

The router can be rebooted through the web interface. The reboot does not 
disconnect the USB device - it remains connected as if nothing happened. Only 
wrong data starts to come in.

-- 
Ondrej Zary
