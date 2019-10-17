Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03876DB392
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 19:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394330AbfJQRlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 13:41:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:40684 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729302AbfJQRlj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Oct 2019 13:41:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8A3BBB175;
        Thu, 17 Oct 2019 17:41:37 +0000 (UTC)
Date:   Thu, 17 Oct 2019 19:41:33 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Stefan Wahren <wahrenst@gmx.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Woojung Huh <woojung.huh@microchip.com>,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com,
        bcm-kernel-feedback-list@broadcom.com,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: lan78xx and phy_state_machine
Message-ID: <20191017174133.e4uhsp77zod5vbef@beryllium.lan>
References: <20191014140604.iddhmg5ckqhzlbkw@beryllium.lan>
 <20191015005327.GJ19861@lunn.ch>
 <20191015171653.ejgfegw3hkef3mbo@beryllium.lan>
 <20191016142501.2c76q7kkfmfcnqns@beryllium.lan>
 <20191016155107.GH17013@lunn.ch>
 <20191017065230.krcrrlmedzi6tj3r@beryllium.lan>
 <6f445327-a2bc-fa75-a70a-c117f2205ecd@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f445327-a2bc-fa75-a70a-c117f2205ecd@gmx.net>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stefan,

On Thu, Oct 17, 2019 at 07:05:32PM +0200, Stefan Wahren wrote:
> Am 17.10.19 um 08:52 schrieb Daniel Wagner:
> > On Wed, Oct 16, 2019 at 05:51:07PM +0200, Andrew Lunn wrote:
> >> Please could you give this a go. It is totally untested, not even
> >> compile tested...
> > Sure. The system boots but ther is one splat:
> >
> this is a known issues since 4.20 [1], [2]. So not related to the crash.

Oh, I see.

> Unfortunately, you didn't wrote which kernel version works for you
> (except of this splat). Only 5.3 or 5.4-rc3 too?

With v5.2.20 I was able to boot the system. But after this discussion
I would say that was just luck. The race seems to exist for longer and
only with my 'special' config I am able to reproduce it.

> [1] - https://marc.info/?l=linux-netdev&m=154604180927252&w=2
> [2] - https://patchwork.kernel.org/patch/10888797/

Indeed, the irq domain code looks suspicious and Marc pointed out that
is dead wrong. Could we just go with [2] and fix this up?

Thanks,
Daniel
