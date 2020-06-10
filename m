Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6F601F5C7B
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 22:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730491AbgFJUMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 16:12:25 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33160 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726362AbgFJUMZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jun 2020 16:12:25 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jj75E-0005UV-0w; Wed, 10 Jun 2020 22:12:24 +0200
Date:   Wed, 10 Jun 2020 22:12:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Helmut Grohne <helmut.grohne@intenta.de>
Cc:     netdev@vger.kernel.org
Subject: Re: correct use of PHY_INTERFACE_MODE_RGMII{,_TXID,_RXID,_ID}
Message-ID: <20200610201224.GC19869@lunn.ch>
References: <20200610081236.GA31659@laureti-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200610081236.GA31659@laureti-dev>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 10, 2020 at 10:12:37AM +0200, Helmut Grohne wrote:
> Hi,
> 
> I've been trying to write a dt for a board and got quite confused about
> the RGMII delays. That's why I looked into it and got even more confused
> by what I found. Different drivers handle this quite differently. Let me
> summarize.

Hi Helmut

In general, in DT, put what you want the PHY to do. If the PCB does
not add the delay, use rgmii-id. If the PCB does add the delay, then
use rgmii.

It is quite confusing, we have had bugs, and some drivers just do odd
things. In general, the MAC should not add delays. The PHY should add
delays, based on what is passed via DT. This assumes the PHY actually
implements the delays, which most PHYs do.

What exact hardware are you using?

     Andrew
