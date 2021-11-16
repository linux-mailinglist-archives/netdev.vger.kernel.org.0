Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2662D453343
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 14:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231842AbhKPN4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 08:56:36 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35988 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229908AbhKPN4e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 08:56:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Nh8cmk8Fo0ciQF/jP1Q2J8McTirBtCHFTSJnjGjcRZs=; b=GdJ+O7q5EGokkRf1qskAURyOyp
        PyUsl1xesLQBhFnHs2xFvaw5EYOkHTTXqd7hC5iItNv0x4BHQRVcXoG1n1AWLmI2PNp21oBhG9omS
        2fvi3wuijYMLm/X0cvGymXVVrnfvHrretdw219jJyKsZkPJdwDX8ebdr0AA89Hmmh3YY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mmytx-00DeeU-FT; Tue, 16 Nov 2021 14:53:33 +0100
Date:   Tue, 16 Nov 2021 14:53:33 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     hnagalla@ti.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, geet.modi@ti.com,
        vikram.sharma@ti.com, grygorii.strashko@ti.com
Subject: Re: [PATCH net-next] net: phy: add support for TI DP83561-SP phy
Message-ID: <YZO33aidzEwo3YFC@lunn.ch>
References: <20211116102015.15495-1-hnagalla@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211116102015.15495-1-hnagalla@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 16, 2021 at 04:20:15AM -0600, hnagalla@ti.com wrote:
> From: Hari Nagalla <hnagalla@ti.com>
> 
> Add support for the TI DP83561-SP Gigabit ethernet phy device.
> 
> The dp83561-sp is a high reliability gigabit ethernet PHY designed for

Does anybody manufacture low reliability devices? Please avoid
meaningless Marketing.

Please add my Reviewed-by: Andrew Lunn <andrew@lunn.ch> to version 2.

    Andrew
