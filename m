Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B10145D4A6
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 18:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbfGBQsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 12:48:52 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48870 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726434AbfGBQsv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 12:48:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=XDWDOgkzwFtLFV2jAxwX/frru0a2XwH+5qoyeEIgspU=; b=o5jtPp7hEp5ekult12NDMnzom2
        fmGIpqpGYhogut6VzomfL8G3CcE/2xVOsgDUa+4VF/Z1a1xacq7xkN7Z8b88j2bm5X4VkJ3U0p/5i
        BYl3bMqFYl1hJ1z7ucj3D/zxomyNSR9jWRya53WYwrU48KptqV3/U54QacRGe5Tmy3uk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hiLxU-0007SR-Ba; Tue, 02 Jul 2019 18:48:44 +0200
Date:   Tue, 2 Jul 2019 18:48:44 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Parav Pandit <parav@mellanox.com>
Cc:     Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mkalderon@marvell.com" <mkalderon@marvell.com>,
        "aelior@marvell.com" <aelior@marvell.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>
Subject: Re: [PATCH net-next 1/1] devlink: Add APIs to publish/unpublish the
 port parameters.
Message-ID: <20190702164844.GA28471@lunn.ch>
References: <20190702152056.31728-1-skalluru@marvell.com>
 <20190702161133.GP30468@lunn.ch>
 <AM0PR05MB4866D7B26F48AF0BED9055EED1F80@AM0PR05MB4866.eurprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR05MB4866D7B26F48AF0BED9055EED1F80@AM0PR05MB4866.eurprd05.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> A vendor driver calling these APIs is needed at minimum.

Not a vendor driver, but a mainline driver.

But yes, a new API should not be added without at least one user.

    Andrew
