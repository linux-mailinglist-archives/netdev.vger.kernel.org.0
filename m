Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76FD22EFECE
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 10:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726868AbhAIJkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 04:40:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726848AbhAIJkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jan 2021 04:40:15 -0500
Received: from ficht.host.rs.currently.online (ficht.host.rs.currently.online [IPv6:2a01:4f8:120:614b::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE1A5C061786;
        Sat,  9 Jan 2021 01:39:34 -0800 (PST)
Received: from carbon.srv.schuermann.io (carbon.srv.schuermann.io [178.63.44.188])
        by ficht.host.rs.currently.online (Postfix) with ESMTPS id 9D1521EA5C;
        Sat,  9 Jan 2021 09:39:30 +0000 (UTC)
From:   Leon Schuermann <leon@is.currently.online>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     oliver@neukum.org, davem@davemloft.net, hayeswang@realtek.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] r8152: Add Lenovo Powered USB-C Travel Hub
In-Reply-To: <20210108182030.77839d11@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210108202727.11728-1-leon@is.currently.online>
 <20210108202727.11728-2-leon@is.currently.online>
 <20210108182030.77839d11@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Sat, 09 Jan 2021 10:39:27 +0100
Message-ID: <87bldye9f4.fsf@is.currently.online>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:
> On Fri,  8 Jan 2021 21:27:27 +0100 Leon Schuermann wrote:
>> This USB-C Hub (17ef:721e) based on the Realtek RTL8153B chip used to
>> work with the cdc_ether driver.
>
> When you say "used to work" do you mean there was a regression where
> the older kernels would work fine and newer don't? Or just "it works
> most of the time"?

Sorry, I should've clarified that. "Used to work" is supposed to say
"the device used the generic cdc_ether driver", as in

[  +0.000004] usb 4-1.1: Product: Lenovo Powered Hub
[  +0.000003] usb 4-1.1: Manufacturer: Lenovo
[  +0.000002] usb 4-1.1: SerialNumber: xxxxxxxxx
[  +0.024803] cdc_ether 4-1.1:2.0 eth0: register 'cdc_ether' at
              usb-0000:2f:00.0-1.1, CDC Ethernet Device,
              xx:xx:xx:xx:xx:xx

I guess it did technically work correctly, except for the reported issue
when the host system suspends, which is fixed by using the dedicated
Realtek driver. As far as I know this hasn't been fixed before, so it's
not a regression.

Should I update the commit message accordingly? Thanks!

Leon
