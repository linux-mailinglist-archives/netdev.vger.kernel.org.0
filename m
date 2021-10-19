Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDA90433BF0
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 18:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233784AbhJSQVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 12:21:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47048 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232137AbhJSQVN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 12:21:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=fJRLB42XQcsYfYfsYVcIV7s8kQ6rgyTZ6Dj+jrkJZ9E=; b=NSKzDMTQO6yn+mn0JvlksHP1Rb
        Uc7zxbee4w0ttz09MF/1w7QhkBswOqsj5SR4b7AKN6UqbT/tV9SB40+gYMQ76NCV4G5B8WyiHTIrA
        Q9eHhyZXBex9ypKAYVv5Y4GFs2vrUgoNIftPdIvMLHrWJZNMevnlNDJqPSPGbXWjdfrg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mcrpF-00B5wm-Dh; Tue, 19 Oct 2021 18:18:53 +0200
Date:   Tue, 19 Oct 2021 18:18:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Volodymyr Mytnyk [C]" <vmytnyk@marvell.com>
Cc:     "kuba@kernel.org" <kuba@kernel.org>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        "Vadym Kochan [C]" <vkochan@marvell.com>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        "Taras Chornyi [C]" <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2] net: marvell: prestera: add firmware v4.0
 support
Message-ID: <YW7v7VjQF6ZZOb/L@lunn.ch>
References: <1634623424-15011-1-git-send-email-volodymyr.mytnyk@plvision.eu>
 <YW6+r9u2a9k6wKF+@lunn.ch>
 <SJ0PR18MB40099BBA546BFBE941B969DCB2BD9@SJ0PR18MB4009.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ0PR18MB40099BBA546BFBE941B969DCB2BD9@SJ0PR18MB4009.namprd18.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> - Major changes have been made to new v4.0 FW ABI to add support of new features,
>   introduce the stability of the FW ABI and ensure better forward compatibility
>   for the future vesrions.

So this point needs bring out in the commit message. You need to
explain why you think you will never need another ABI break. How your
new design allows extensible, what you have fixed in your old design
which has causes two ABI breaks.

Given this is the second time you have broken the ABI, i need
convincing.

> - All current platforms using this driver have dedicated OOB mgmt port, thus the
>   user still be able to do upgrade of the FW. So, no "Bricks in broom closets" :).

So your cabling guidelines suggest a dedicated Ethernet cable from the
broom closet to the NOC for the OOB port? I suspect most users ignore
this, and do management over the network. They only use the OOB port
when they have bricked the device because they installed a kernel
upgrade over the network, without upgrading the firmware.

	Andrew
