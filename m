Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78E13126F04
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 21:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbfLSUje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 15:39:34 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:33922 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726906AbfLSUje (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 15:39:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ZiPJlc5R66OrSg0ZomFfy6GmZZH59Hsf7n1Lcs1QDCE=; b=N69gkkmWpRSIgVu3w+Uiggl6XP
        OYMaLE0BkLhHWyThYdBDSThuBC7JNYmLCvsxgbgeSEwWih1gZdtpNFSsqil3MibvY4LQ6IMUqlKTp
        RWIOtf+3m+bX9iVhpyaFfjASfRdx9wVpL9vNFwdmm9A7vw2/TOvVfAq109TqJIKyakEI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ii2a3-0005bI-D9; Thu, 19 Dec 2019 21:39:31 +0100
Date:   Thu, 19 Dec 2019 21:39:31 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc:     f.fainelli@gmail.com, netdev@vger.kernel.org, davem@davemloft.net,
        kernel@pengutronix.de
Subject: Re: [PATCH] mdio-bitbang: add support for lowlevel mdio read/write
Message-ID: <20191219203931.GN17475@lunn.ch>
References: <20191107154201.GF7344@lunn.ch>
 <20191218162919.5293-1-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218162919.5293-1-m.grzeschik@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 18, 2019 at 05:29:19PM +0100, Michael Grzeschik wrote:
> Some phys support special opcode handling when communicating via mdio.
> This patch introduces mdio_ll_read/write which makes it possible to set
> the opcode. It implements these functions in the gpio-bitbang driver,
> which is capable of setting the opcode on read and write.
> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>

Hi Michael

It is normal to post the user of a new API at the same time as a new
API. I'm having trouble working out how this is supposed to be used.

     Andrew
