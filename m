Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB9893A2315
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 06:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbhFJEJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 00:09:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55594 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229989AbhFJEJf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 00:09:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=nMwQ6ILBNlvRgr3018PELUeh/oBei/LXOAz5PDnWC4s=; b=HRSMKUutk0U0eKMXlzTlJy3fJW
        5//IgcTsM7xBlb0xPys7FZnLcRi9JsI/2vA/KDYWUyDfSRh8oq0UIATnos+aGhxaBsKF+Jt0J3zDR
        yvTViBrbT2PFo7w7F4Ll0wDEmhqStf6WcfQ/mfeeqTfQvCuSp7EAzCumy1kB/Z5Nz06Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lrByX-008bQx-5n; Thu, 10 Jun 2021 06:07:25 +0200
Date:   Thu, 10 Jun 2021 06:07:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     praneeth@ti.com
Cc:     Geet Modi <geet.modi@ti.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: phy: dp83867: perform soft reset and retain
 established link
Message-ID: <YMGP/aim6CD270Yo@lunn.ch>
References: <3494dcf6-14ca-be2b-dbf8-dda2e208b70b@ti.com>
 <20210610004342.4493-1-praneeth@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210610004342.4493-1-praneeth@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 09, 2021 at 07:43:42PM -0500, praneeth@ti.com wrote:
> From: Praneeth Bajjuri <praneeth@ti.com>
> 
> Current logic is performing hard reset and causing the programmed
> registers to be wiped out.
> 
> as per datasheet: https://www.ti.com/lit/ds/symlink/dp83867cr.pdf
> 8.6.26 Control Register (CTRL)
> 
> do SW_RESTART to perform a reset not including the registers,
> If performed when link is already present,
> it will drop the link and trigger re-auto negotiation.
> 
> Signed-off-by: Praneeth Bajjuri <praneeth@ti.com>
> Signed-off-by: Geet Modi <geet.modi@ti.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
