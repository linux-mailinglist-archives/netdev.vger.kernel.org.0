Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6082A3AF7
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 04:17:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727146AbgKCDRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 22:17:00 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59956 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725940AbgKCDRA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 22:17:00 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kZmoN-004vq4-Us; Tue, 03 Nov 2020 04:16:43 +0100
Date:   Tue, 3 Nov 2020 04:16:43 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Pavana Sharma <pavana.sharma@digi.com>, ashkan.boldaji@digi.com,
        davem@davemloft.net, gregkh@linuxfoundation.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, marek.behun@nic.cz,
        netdev@vger.kernel.org, vivien.didelot@gmail.com
Subject: Re: [PATCH v7 2/4] net: phy: Add 5GBASER interface mode
Message-ID: <20201103031643.GJ1109407@lunn.ch>
References: <20201102130905.GE1109407@lunn.ch>
 <20201103013446.1220-1-pavana.sharma@digi.com>
 <7aef297e-cbee-6f04-9d74-82cf97579880@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7aef297e-cbee-6f04-9d74-82cf97579880@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 02, 2020 at 06:12:32PM -0800, Florian Fainelli wrote:
> 
> 
> On 11/2/2020 5:34 PM, Pavana Sharma wrote:
> >> How many times have i asked for you to add kerneldoc for this new
> >> value? How many times have you not done so?
> > 
> > I have added kerneldoc comment for the new value added.
> > 
> >> NACK.
> > 
> >> If you don't understand a comment, please ask.
> > 
> > Ok, explain what do you expect by that comment.
> 
> What Andrew wants you to do is add a comment like this:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/include/linux/phy.h#n88

Hi Pavana

This should also help:

https://www.kernel.org/doc/html/latest/doc-guide/kernel-doc.html

And please compile the kernel with the W=1 flag. Make sure changes you
make don't add new warnings. You will see a warning from this new enum
valu you are adding because it is not correctly documented.

       Andrew
