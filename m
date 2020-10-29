Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1196229EC7F
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 14:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbgJ2NJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 09:09:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52112 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726227AbgJ2NJ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 09:09:27 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kY7gB-004A0E-5Z; Thu, 29 Oct 2020 14:09:23 +0100
Date:   Thu, 29 Oct 2020 14:09:23 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Cc:     linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        hkallweit1@gmail.com, gregkh@linuxfoundation.org
Subject: Re: [PATCH] drivers: net: phy: Fix spelling in comment defalut to
 default
Message-ID: <20201029130923.GN933237@lunn.ch>
References: <20201029095525.20200-1-unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201029095525.20200-1-unixbhaskar@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 03:25:25PM +0530, Bhaskar Chowdhury wrote:
> Fixed spelling in comment like below:
> 
> s/defalut/default/p
> 
> This is in linux-next.
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
