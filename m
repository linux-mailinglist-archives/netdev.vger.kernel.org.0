Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 691D8337AC9
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 18:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbhCKR0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 12:26:22 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:52308 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229819AbhCKR0I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 12:26:08 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lKP4S-00AOE1-Mw; Thu, 11 Mar 2021 18:26:00 +0100
Date:   Thu, 11 Mar 2021 18:26:00 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jonathan =?iso-8859-1?Q?Neusch=E4fer?= <j.neuschaefer@gmx.net>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] docs: networking: phy: Improve placement of parenthesis
Message-ID: <YEpSqO7/3eCJjx3b@lunn.ch>
References: <20210311172234.1812323-1-j.neuschaefer@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210311172234.1812323-1-j.neuschaefer@gmx.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 06:22:34PM +0100, Jonathan Neuschäfer wrote:
> "either" is outside the parentheses, so the matching "or" should be too.
> 
> Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
