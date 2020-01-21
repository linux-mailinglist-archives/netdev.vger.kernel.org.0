Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7791914471E
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 23:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729190AbgAUWUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 17:20:30 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:49058 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728609AbgAUWUa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 17:20:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=RpHJMpKu4v0CvkzuinHlziL2Buu48WNRyCcw287vfxA=; b=W1EI/6xYIiVa7MyWoZgDC7Z0vB
        g9BplIhQoX6bKqVznCAySybUauv/Dp/yFOS4YO10T6Gv9o5xsx7kw8jA9LpCgFd/I43XHs0iCZ8vn
        TZsNKYQS1mwenBebEmxVRQvpkw13B9SjueKT2IZDY96D+WmvDbGvKa4Uoixarad0LlZs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1iu1sk-0006HU-Ew; Tue, 21 Jan 2020 23:20:22 +0100
Date:   Tue, 21 Jan 2020 23:20:22 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        Byungho An <bh74.an@samsung.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: convert additional drivers to use
 phy_do_ioctl
Message-ID: <20200121222022.GK1466@lunn.ch>
References: <cc7396fa-81c6-6a13-0e94-9ac2ca2cab08@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc7396fa-81c6-6a13-0e94-9ac2ca2cab08@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 21, 2020 at 10:05:14PM +0100, Heiner Kallweit wrote:
> The first batch of driver conversions missed a few cases where we can
> use phy_do_ioctl too.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
