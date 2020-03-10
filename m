Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31CC317FB5F
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 14:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730056AbgCJNNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 09:13:20 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55102 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731334AbgCJNNR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 09:13:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=VPcwSmSGzn5ajfB2BRITEeWuZm0bV4e+TfKsv8eLyB0=; b=w1tNh0x9O4rYta4n9sCh9xj2Ov
        Kuidd48UylMpYIvqV2rcroRuEYIPDU1ulXN7BAEnl5nQOy7AMCf7PR0B38hCOFqr4pDE9cVxcZYG5
        Ld2KRDLgnksVZGWRGsRviBFDz4SpGP04IgOiCFbX/30W3fuv/o9+2dS6llzv8Qjw1m+U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jBeh5-0001jF-9D; Tue, 10 Mar 2020 14:13:11 +0100
Date:   Tue, 10 Mar 2020 14:13:11 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] net: phy: move the mscc driver to its own
 directory
Message-ID: <20200310131311.GD5932@lunn.ch>
References: <20200310090720.521745-1-antoine.tenart@bootlin.com>
 <20200310090720.521745-2-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200310090720.521745-2-antoine.tenart@bootlin.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 10, 2020 at 10:07:18AM +0100, Antoine Tenart wrote:
> The MSCC PHY driver is growing, with lots of space consuming features
> (firmware support, full initialization, MACsec...). It's becoming hard
> to read and navigate in its source code. This patch moves the MSCC
> driver to its own directory, without modifying anything, as a
> preparation for splitting up its features into dedicated files.
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
