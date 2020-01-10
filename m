Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1689D1376F3
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 20:26:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728760AbgAJTZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 14:25:57 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:60540 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728332AbgAJTZ5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 14:25:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1dcxievtQE7QyiuKHF+oOaVSqb3GpcAof2zEYmMLuz0=; b=gnxqpEyH+aWpHc/jdhHTd2vk0a
        7063eGgAIdpSxtptTrfakb4/RvCMPK2Yi/oYkOL3RbIDqdwLegHI0EXJSIh/Z1hu73b0akF8eneap
        9vATJh1BfxKZ5HhN9w1ur4ChcuEmM/c1mYv7rGgDcGnH5ahJ2qguBj5vDBxUmgMedshE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ipzur-0003kl-5R; Fri, 10 Jan 2020 20:25:53 +0100
Date:   Fri, 10 Jan 2020 20:25:53 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] net: phy: DP83TC811: Fix typo in Kconfig
Message-ID: <20200110192553.GP19739@lunn.ch>
References: <20200110184702.14330-1-dmurphy@ti.com>
 <20200110184702.14330-2-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110184702.14330-2-dmurphy@ti.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 10, 2020 at 12:46:59PM -0600, Dan Murphy wrote:
> Fix typo in the Kconfig for the DP83TC811 as it indicates support for
> the DP83TC822 which is incorrect.
> 
> Fixes: 6d749428788b {"net: phy: DP83TC811: Introduce support for the DP83TC811 phy")
> Signed-off-by: Dan Murphy <dmurphy@ti.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
