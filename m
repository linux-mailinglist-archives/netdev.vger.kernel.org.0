Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 098E42FD673
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 18:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391526AbhATRFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 12:05:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:58628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391597AbhATRFU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 12:05:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0B7E22CE3;
        Wed, 20 Jan 2021 17:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611162280;
        bh=m8pqVrcfEzJVeZz+TZSi4ol1fr8/WL/q2yYltK7jfhM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JxD99PyNA3wqyEIZKqMSQ6Y6Wk8R2ir01C7TjlGDEPvHTz0Je2UgWrpaY5SnwQnh8
         hBJb49QKOxKNDF0OuuUn0rdGAj22UqlXNmuZW5VaKMF0ONrD0mdbDOWJpYMNy851o4
         lEK2pwcc6pgpYp3s5GgipjyWCmg48z3AaPEzSxbkInx+kUrztuGTYWOYUW1IDqCYuC
         DQF98oVUvdvXOaCiHbTNAFI6Sc6b3u/OCHVxYOhK9zun+1OOPVAFHdfoo9TAaI/Dfc
         K6TlZ+gFS2tWKLgOJJhBuw6gS/Ay18bZGGn01izYvKR4aBDLJLXkGhJeiU8BHubuIx
         a0HLsgd3qD5gQ==
Date:   Wed, 20 Jan 2021 09:04:38 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hayes Wang <hayeswang@realtek.com>,
        Grant Grundler <grundler@chromium.org>
Cc:     Oliver Neukum <oliver@neukum.org>,
        "David S. Miller" <davem@davemloft.net>,
        nic_swsd <nic_swsd@realtek.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: usb: cdc_ncm: don't spew notifications
Message-ID: <20210120090438.0f5bba6e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <0a5e1dad04494f16869b44b8457f0980@realtek.com>
References: <20210120011208.3768105-1-grundler@chromium.org>
        <0a5e1dad04494f16869b44b8457f0980@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Jan 2021 03:38:32 +0000 Hayes Wang wrote:
> Grant Grundler <grundler@chromium.org>
> > Sent: Wednesday, January 20, 2021 9:12 AM
> > Subject: [PATCH net] net: usb: cdc_ncm: don't spew notifications
> > 
> > RTL8156 sends notifications about every 32ms.
> > Only display/log notifications when something changes.
> > 
> > This issue has been reported by others:
> > 	https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1832472
> > 	https://lkml.org/lkml/2020/8/27/1083
> > 
> > Chrome OS cannot support RTL8156 until this is fixed.
> > 
> > Signed-off-by: Grant Grundler <grundler@chromium.org>  
> 
> Reviewed-by: Hayes Wang <hayeswang@realtek.com>

Applied, thanks!

net should be merged back into net-next by the end of the day, so
if the other patches depend on this one to apply cleanly please keep 
an eye and post after that happens. If there is no conflict you can
just post them with [PATCH net-next] now.
