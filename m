Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 170B3EF899
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 10:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730755AbfKEJXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 04:23:44 -0500
Received: from mx2.suse.de ([195.135.220.15]:36178 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727093AbfKEJXo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Nov 2019 04:23:44 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D7D8EB2CE;
        Tue,  5 Nov 2019 09:23:40 +0000 (UTC)
Date:   Tue, 5 Nov 2019 10:23:37 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Stefan Wahren <wahrenst@gmx.net>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        Marc Zyngier <maz@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH] net: usb: lan78xx: Disable interrupts before calling
 generic_handle_irq()
Message-ID: <20191105092337.rkjeohkdkmiiswzy@beryllium.lan>
References: <20191025080413.22665-1-dwagner@suse.de>
 <20191104085703.diajpzpxo6dchuhs@beryllium.lan>
 <793b1cfa-dc45-c01c-ef0f-72db6df3ecd1@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <793b1cfa-dc45-c01c-ef0f-72db6df3ecd1@gmx.net>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> did you never saw a warning about under voltage from the Raspberry Pi
> hwmon driver?

Guess why I feel so stupid? I just ignored it... /me goes back to
shaming in the corner.
