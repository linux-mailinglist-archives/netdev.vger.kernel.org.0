Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBC0D3040B8
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 15:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390255AbhAZOob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 09:44:31 -0500
Received: from mx2.suse.de ([195.135.220.15]:47554 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731103AbhAZJm6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 04:42:58 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1611654131; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mkHiLfHnIISE4hTYhT0zvaW5h6MozWBuiHpb4OaeraQ=;
        b=PsUgLd2LQ/Rrp8BLXvX7CymNpx3bzG670Hk4xXHtoW7obtbUUBefTeCv+f+KmMgstZMcnA
        B0QLmc0909tdwBZyvZsjHJM4Z6CGs5T9QSi5Ci6e3g1U/kIdO968y1stDlFid+/RG+NKCD
        eBAsct3vGvXUBk5vh4+19aoIhD1ot1c=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B463BAF7E;
        Tue, 26 Jan 2021 09:42:11 +0000 (UTC)
Message-ID: <3da2bd93f8da246d9032f4b07dff53a1b3648ccd.camel@suse.com>
Subject: Re: [PATCHv2 1/3] usbnet: specify naming of
 usbnet_set/get_link_ksettings
From:   Oliver Neukum <oneukum@suse.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     hayeswang@realtek.com, grundler@chromium.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Roland Dreier <roland@kernel.org>
Date:   Tue, 26 Jan 2021 10:42:09 +0100
In-Reply-To: <YAomCIEWCsquQODX@lunn.ch>
References: <20210121125731.19425-1-oneukum@suse.com>
         <20210121125731.19425-2-oneukum@suse.com> <YAomCIEWCsquQODX@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Freitag, den 22.01.2021, 02:10 +0100 schrieb Andrew Lunn:
> On Thu, Jan 21, 2021 at 01:57:29PM +0100, Oliver Neukum wrote:
> > The old generic functions assume that the devices includes
> > an MDIO interface. This is true only for genuine ethernet.
> > Devices with a higher level of abstraction or based on different
> > technologies do not have it. So in preparation for
> > supporting that, we rename the old functions to something specific.
> > 
> > v2: adjusted to recent changes
> 
> Hi Oliver
> 
> It  looks like my comment:
> 
> https://www.spinics.net/lists/netdev/msg711869.html
> 
> was ignored. Do you not like the name mii?

Hi,

sorry for not replying earlier.

It was my understanding that on the hardware level of the
networking devices we are using MII, but to control MII we
use MDIO, don't we?
So it seems to me that hardware could use MII but not
MDIO, yet for this purpose we require MDIO. So could
you please explain your reasoning about networking stuff?

I do not want to create false impressions in users.

	Regards
		Oliver


