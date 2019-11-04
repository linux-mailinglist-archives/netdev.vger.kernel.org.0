Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B133EDAE3
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 09:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728001AbfKDI5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 03:57:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:55410 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726100AbfKDI5G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Nov 2019 03:57:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C41ACB277;
        Mon,  4 Nov 2019 08:57:04 +0000 (UTC)
Date:   Mon, 4 Nov 2019 09:57:03 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     netdev@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        Marc Zyngier <maz@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Stefan Wahren <wahrenst@gmx.net>,
        Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH] net: usb: lan78xx: Disable interrupts before calling
 generic_handle_irq()
Message-ID: <20191104085703.diajpzpxo6dchuhs@beryllium.lan>
References: <20191025080413.22665-1-dwagner@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191025080413.22665-1-dwagner@suse.de>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 25, 2019 at 10:04:13AM +0200, Daniel Wagner wrote:
> This patch just fixes the warning. There are still problems left (the
> unstable NFS report from me) but I suggest to look at this
> separately. The initial patch to revert all the irqdomain code might
> just hide the problem. At this point I don't know what's going on so I
> rather go baby steps. The revert is still possible if nothing else
> works.

I replaced my power supply with the official RPi one and the NFS
timeouts problems are gone. Also a long test session with different
network loads didn't show any problems. I feel so stupid...

Thanks,
Daniel

