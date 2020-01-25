Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F716149633
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 16:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbgAYPUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 10:20:31 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:54056 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725710AbgAYPUb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jan 2020 10:20:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=X8UUPTOUNfFXETSXGA8mkvkgEObCurF5t9bY3s9/WBw=; b=CvGoJahVgWmRUJ6lVkXuQ1M419
        Q/XFzshlEk7MPbOCKU20WMXVtIIDV0QUzNt5sL/uGSCuRSjz+XfKMwWrmYDSPMCPKwzhQJWZUAzkq
        5ZiKCStAZ3mi7aNle7UBR6BcdetgqEEMQOrrF2viYG9DfzS202kGxeEcyR/ihrfTlBTM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ivNEV-0006u6-W4; Sat, 25 Jan 2020 16:20:24 +0100
Date:   Sat, 25 Jan 2020 16:20:23 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org, jiri@resnulli.us,
        ivecera@redhat.com, davem@davemloft.net, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, anirudh.venkataramanan@intel.com,
        olteanv@gmail.com, jeffrey.t.kirsher@intel.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [RFC net-next v3 03/10] net: bridge: mrp: Add MRP interface used
 by netlink
Message-ID: <20200125152023.GA18311@lunn.ch>
References: <20200124161828.12206-1-horatiu.vultur@microchip.com>
 <20200124161828.12206-4-horatiu.vultur@microchip.com>
 <20200124174315.GC13647@lunn.ch>
 <20200125113726.ousbmm4n3ab4xnqt@soft-dev3.microsemi.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200125113726.ousbmm4n3ab4xnqt@soft-dev3.microsemi.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 25, 2020 at 12:37:26PM +0100, Horatiu Vultur wrote:
> The 01/24/2020 18:43, Andrew Lunn wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> > 
> > > br_mrp_flush - will flush the FDB.
> > 
> > How does this differ from a normal bridge flush? I assume there is a
> > way for user space to flush the bridge FDB.
> 
> Hi,
> 
> If I seen corectly the normal bridge flush will clear the entire FDB for
> all the ports of the bridge. In this case it is require to clear FDB
> entries only for the ring ports.

Maybe it would be better to extend the current bridge netlink call to
be able to pass an optional interface to be flushed?  I'm not sure it
is a good idea to have two APIs doing very similar things.

   Andrew
