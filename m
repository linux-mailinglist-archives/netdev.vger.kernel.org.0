Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC709A500
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 03:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733295AbfHWBjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 21:39:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53652 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732065AbfHWBjH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 21:39:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=osB56ftWPFmR8twY8VsDwe4xdZwaR7vvqfbPOIdALvM=; b=oJ1+f0cgMZSg486YZNmykAGLOr
        arXb41bvbmzTv8XkbSKz37CPKDJdUGjCio/x33mJqwFSYB/M/JGq3sP9/P04NLObrQQMEE2y5isY7
        7wLinWO+6PHFNTpPnpXFhWbMj6y7G8fZLB+7drUAYoPNFfsI0rTNQnUwXd3dyig3tLro=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i0yXi-00015B-2Z; Fri, 23 Aug 2019 03:39:06 +0200
Date:   Fri, 23 Aug 2019 03:39:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next 05/10] net: dsa: mv88e6xxx: create
 chip->info->ops->serdes_get_lane method
Message-ID: <20190823013906.GL13020@lunn.ch>
References: <20190821232724.1544-1-marek.behun@nic.cz>
 <20190821232724.1544-6-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190821232724.1544-6-marek.behun@nic.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 22, 2019 at 01:27:19AM +0200, Marek Behún wrote:
> Create a serdes_get_lane() method in the mv88e6xxx operations structure.
> Use it instead of calling the different implementations.
> 
> Signed-off-by: Marek Behún <marek.behun@nic.cz>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
