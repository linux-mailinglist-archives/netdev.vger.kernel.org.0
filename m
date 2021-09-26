Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA2F418948
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 16:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbhIZOGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 10:06:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60882 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231743AbhIZOGu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Sep 2021 10:06:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=hHw9ornvJo+NmAmHhiHeeLnJbnW45go7bH67xEYr7kM=; b=QgNq4QVEvmgXZ63hXdbKVvpuVJ
        GqBPAG8rZmkz1lEb5kav+tzypaoy7DkUAi3Kpuj87tBRkJh/z84cWkRjty7M+6R4t9LwKwq4Dh2r+
        Lch+5UH28S47s4WXTH/IPIcT2005YLc0/dZvILpmi5qY+m9vlG5Mqv31/sn1+mFDqmB4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mUUmF-008K0V-94; Sun, 26 Sep 2021 16:05:11 +0200
Date:   Sun, 26 Sep 2021 16:05:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:BROADCOM GENET ETHERNET DRIVER" 
        <bcm-kernel-feedback-list@broadcom.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 3/4] net: bcmgenet: pull mac_config from
 adjust_link
Message-ID: <YVB+F9oqJ0KIH91m@lunn.ch>
References: <20210926032114.1785872-1-f.fainelli@gmail.com>
 <20210926032114.1785872-4-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210926032114.1785872-4-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 25, 2021 at 08:21:13PM -0700, Florian Fainelli wrote:
> From: Doug Berger <opendmb@gmail.com>
> 
> This commit separates out the MAC configuration that occurs on a
> PHY state change into a function named bcmgenet_mac_config().
> 
> This allows the function to be called directly elsewhere.
> 
> Signed-off-by: Doug Berger <opendmb@gmail.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
