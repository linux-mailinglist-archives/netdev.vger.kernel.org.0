Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60413DBE02
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 09:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409621AbfJRHGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 03:06:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:39504 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2409614AbfJRHGe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 03:06:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CA7E2B19C;
        Fri, 18 Oct 2019 07:06:32 +0000 (UTC)
Date:   Fri, 18 Oct 2019 09:06:23 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, wahrenst@gmx.net
Subject: Re: [PATCH net] net: usb: lan78xx: Connect PHY before registering MAC
Message-ID: <20191018070623.mavdkhuo327qbszw@beryllium.lan>
References: <20191017192926.24232-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017192926.24232-1-andrew@lunn.ch>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 17, 2019 at 09:29:26PM +0200, Andrew Lunn wrote:
> As soon as the netdev is registers, the kernel can start using the
> interface. If the driver connects the MAC to the PHY after the netdev
> is registered, there is a race condition where the interface can be
> opened without having the PHY connected.
> 
> Change the order to close this race condition.
> 
> Fixes: 92571a1aae40 ("lan78xx: Connect phy early")
> Reported-by: Daniel Wagner <dwagner@suse.de>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Tested-by: Daniel Wagner <dwagner@suse.de>

Thanks for the fix!
Daniel
