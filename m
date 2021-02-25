Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53C7E325957
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 23:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234465AbhBYWPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 17:15:05 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:58208 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231591AbhBYWOw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 17:14:52 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lFOtW-008TR5-CR; Thu, 25 Feb 2021 23:14:02 +0100
Date:   Thu, 25 Feb 2021 23:14:02 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniel =?iso-8859-1?Q?Gonz=E1lez?= Cabanelas <dgcbueu@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, f.fainelli@gmail.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        noltari@gmail.com
Subject: Re: [PATCH v3] bcm63xx_enet: fix internal phy IRQ assignment
Message-ID: <YDghKktU6l9noanv@lunn.ch>
References: <2190629.1yaby32tsi@tool>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2190629.1yaby32tsi@tool>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 24, 2021 at 05:11:33PM +0100, Daniel González Cabanelas wrote:
> The current bcm63xx_enet driver doesn't asign the internal phy IRQ. As a
> result of this it works in polling mode.
> 
> Fix it using the phy_device structure to assign the platform IRQ.

Hi Daniel

We still don't have a root cause analysis. I really would like to
understand what is wrong here, since there should be no need to assign
phydev->irq. I want to be sure we don't have the same problem with
other drivers.

      Andrew
