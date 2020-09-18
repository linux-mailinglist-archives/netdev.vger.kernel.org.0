Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 388F626FF6C
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 16:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgIROBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 10:01:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43474 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726199AbgIROBb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 10:01:31 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kJGx2-00FF6N-UQ; Fri, 18 Sep 2020 16:01:24 +0200
Date:   Fri, 18 Sep 2020 16:01:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?utf-8?B?5YqJ5YGJ5qyK?= <willy.liu@realtek.com>
Cc:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Ryan Kao <ryankao@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: phy: realtek: Replace 2.5Gbps name from RTL8125 to
 RTL8226
Message-ID: <20200918140124.GD3631014@lunn.ch>
References: <1600306748-3176-1-git-send-email-willy.liu@realtek.com>
 <20200917134007.GN3526428@lunn.ch>
 <da7e5ceda2724cb5a1aa69d6304bcf95@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <da7e5ceda2724cb5a1aa69d6304bcf95@realtek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 18, 2020 at 09:02:43AM +0000, 劉偉權 wrote:
> Hi Andrew,
> Thanks for your information. Should I do any modifications to make this patch be applied?

Please do not to post. And wrap your text to about 75 characters.

Since i think you are new to posting to netdev, we tend to be generous
to start with, and allow minor process errors. But we do expect you to
learn from what we say, and watch other patches on netdev, so that
future patches do follow the processes. So please get [PATCH <tree>
v<version>] correct in your next patches, include a summary of what
has changed between versions, etc.

I guess David will accept this patch. If not, he will tell you why and
what you need to improve.

  Andrew
