Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B56F6485759
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 18:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242351AbiAERgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 12:36:24 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53346 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242348AbiAERgU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 12:36:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=PX/MKKMa6KMx/x6d3OQVuipaLC1b+o2fk5fUFUNgIA0=; b=Sqzr687ZDCFo7GUOWT4AuWwHUm
        /hNXeEOfcQUsdQo9XZtMDy1RH6dqXgQwwCMy52LlqPaykEYF5TPQWAYXuI64bTwXiBuyt9ahsk2om
        cpVRuQ9TEfxoMGdMHaoxb+9Z0iNgG0vk2gwbIJtX1i9cG4l5/3oGp0r0DOwEtay43v80=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n5ACt-000a50-8W; Wed, 05 Jan 2022 18:36:15 +0100
Date:   Wed, 5 Jan 2022 18:36:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Aaron Ma <aaron.ma@canonical.com>
Cc:     Oliver Neukum <oneukum@suse.com>, kuba@kernel.org,
        henning.schild@siemens.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, hayeswang@realtek.com, tiwai@suse.de
Subject: Re: [PATCH] Revert "net: usb: r8152: Add MAC passthrough support for
 more Lenovo Docks"
Message-ID: <YdXXD3us3RnCuw4y@lunn.ch>
References: <20220105155102.8557-1-aaron.ma@canonical.com>
 <394d86b6-bb22-9b44-fa1e-8fdc6366d55e@suse.com>
 <fa192218-4fc8-678f-8b40-95b85e36097e@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa192218-4fc8-678f-8b40-95b85e36097e@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 06, 2022 at 12:05:28AM +0800, Aaron Ma wrote:
> 
> On 1/6/22 00:01, Oliver Neukum wrote:
> > 
> > On 05.01.22 16:51, Aaron Ma wrote:
> > > This reverts commit f77b83b5bbab53d2be339184838b19ed2c62c0a5.
> > > 
> > > This change breaks multiple usb to ethernet dongles attached on Lenovo
> > > USB hub.
> > 
> > Hi,
> > 
> > now we should maybe discuss a sensible way to identify device
> > that should use passthrough. Are your reasons to not have a list
> > of devices maintainability or is it impossible?
> > 
> 
> The USB to ethernet ID is 0bda:8153. It's is original Realtek 8153 ID.
> It's impossible.
> 
> And ocp data are 0.
> No way to identify it's from dock.

Can you at least identify the dock?

Can you have a udev rule which matches on 0bda:8153, it then walks up
the tree and checks if it is part of the dock? And it is on the
expected port of the hub within the dock, and not a USB stick plugged
into the dock on some other port of the hub?

     Andrew
