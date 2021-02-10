Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC2BA3173C6
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 23:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233691AbhBJW5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 17:57:03 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:33660 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231897AbhBJW4y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 17:56:54 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l9yP3-005Pnt-NO; Wed, 10 Feb 2021 23:56:09 +0100
Date:   Wed, 10 Feb 2021 23:56:09 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jon Hunter <jonathanh@nvidia.com>
Subject: Re: phy_attach_direct()'s use of device_bind_driver()
Message-ID: <YCRkidArVGlesPfy@lunn.ch>
References: <CAGETcx9YpCUMmHjyydMtOJP9SKBbVsHNB-9SspD9u=txJ12Gug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx9YpCUMmHjyydMtOJP9SKBbVsHNB-9SspD9u=txJ12Gug@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 02:13:48PM -0800, Saravana Kannan wrote:
> Hi,
> 
> This email was triggered by this other email[1].

And it appears the Tegra194 Jetson Xavier uses the Marvell 88E1512
PHY. So ensure the Marvell driver is available, and it should get
probed in the usual way, the fallback driver will not be needed.

       Andrew
