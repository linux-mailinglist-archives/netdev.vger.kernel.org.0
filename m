Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D925C418940
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 16:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231807AbhIZOC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 10:02:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60870 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231743AbhIZOCZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Sep 2021 10:02:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Df9oMSo2AoYxD1GT9zztyaQTu2D2FFW/ddKBADmqco4=; b=29avS6PsoNeqnz4+4oy6e17Y7d
        DpHH8AgGgknN/E54VmqUj6ccFlzVUDF7Z6ndABAD0dgqbDwVVkhS7IrnsXi+7fobOMJSTlVLcj/IZ
        5M95kUipLGvejiRr0kqUjj1QIvSxXYDBiKCNGhPQtt3rc4MN+zdk0kl9s30UYIR45WBg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mUUhx-008Jyo-Qm; Sun, 26 Sep 2021 16:00:45 +0200
Date:   Sun, 26 Sep 2021 16:00:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:BROADCOM GENET ETHERNET DRIVER" 
        <bcm-kernel-feedback-list@broadcom.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 2/4] net: bcmgenet: remove old link state values
Message-ID: <YVB9DQoKqTseD4X+@lunn.ch>
References: <20210926032114.1785872-1-f.fainelli@gmail.com>
 <20210926032114.1785872-3-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210926032114.1785872-3-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 25, 2021 at 08:21:12PM -0700, Florian Fainelli wrote:
> From: Doug Berger <opendmb@gmail.com>
> 
> The PHY state machine has been fixed to only call the adjust_link
> callback when the link state has changed. Therefore the old link
> state variables are no longer needed to detect a change in link
> state.
> 
> This commit effectively reverts
> commit 5ad6e6c50899 ("net: bcmgenet: improve bcmgenet_mii_setup()")
> 
> Signed-off-by: Doug Berger <opendmb@gmail.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
