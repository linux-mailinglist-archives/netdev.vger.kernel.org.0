Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7485380D80
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 17:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234985AbhENPmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 11:42:51 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40526 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232426AbhENPmu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 11:42:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=JGPg2rGN1c6V/ZgAIaVM+slcrBMKD0rGiiBx+eLZO3E=; b=GVdjFcI8OK/Bo9hHneBzVr4s8W
        V+xQ9NkGYW0TWXNNZ0pqk4c9dbcSYJ6BI9eOBM3H9/zcF+u2Q007kZYjvogndKCw0jtgZ31r14M+A
        HnotK1H/rKZ+jnYF6mQm8ThH/wZ2J8fKi0bzJIaWgPqHQa/IDcD3Ojevhg5CA50WRfq8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lhZwT-004Cnj-AV; Fri, 14 May 2021 17:41:33 +0200
Date:   Fri, 14 May 2021 17:41:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Peter Geis <pgwipeout@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>
Subject: Re: [PATCH v3] net: phy: add driver for Motorcomm yt8511 phy
Message-ID: <YJ6aLTo3fJ6kRvzK@lunn.ch>
References: <20210514115826.3025223-1-pgwipeout@gmail.com>
 <YJ56G23e930pg4Iv@lunn.ch>
 <CAMdYzYrSB0G7jfG9fo85X0DxVG_r-qaWUyVAa5paAW0ugLvoxw@mail.gmail.com>
 <YJ6OqpRTo+rlfb51@lunn.ch>
 <CAMdYzYrdNqDZdkCj5Jf9+MmGtZgy263cYmwWkB3rZY02dPefYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMdYzYrdNqDZdkCj5Jf9+MmGtZgy263cYmwWkB3rZY02dPefYw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Good Catch!
> 
> Guess I'll have to set that too, anything else you'd recommend looking into?

I think for a first submission, you have the basics. I'm just pushing
RGMII delays because we have had backwards compatibility problems in
that area when added later. Experience suggests adding features in
other areas is much less of a problem. So as you suggested, you can
add cable test, downshift control, interrupts etc later.

    Andrew
