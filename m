Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBBFC17222E
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 16:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729708AbgB0PYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 10:24:03 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:37028 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728211AbgB0PYD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 10:24:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8od8Fg9UDsLXZZZf0SrhBLscz18q2goIHtPuNLjCpCE=; b=MKG6Is9kISZ9v6oy1X03Ax4HEL
        cTPvT4HqFl31Uthj3/PO8V5FMEB4H/0zWBCadTFcd4GMUhDFUaoX1+n+fqwofOh/0tEDok0KVSXgD
        9Lx1REMMJlIieQHTCLGtDE8jfLwJrMMcnEmEAkMfTjSnoItsR8H9IGpdlp5AgIp3HLpI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j7L11-0005kX-BF; Thu, 27 Feb 2020 16:23:55 +0100
Date:   Thu, 27 Feb 2020 16:23:55 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] dpaa2-eth: add support for mii ioctls
Message-ID: <20200227152355.GD19662@lunn.ch>
References: <E1j7Hq1-0004Fc-MX@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1j7Hq1-0004Fc-MX@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 27, 2020 at 12:00:21PM +0000, Russell King wrote:
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
