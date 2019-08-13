Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 482818B76A
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 13:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727420AbfHMLqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 07:46:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56466 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726810AbfHMLqD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 07:46:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Ul9hI6QimlOvjEhozLFgbc5R2VjdFU/OBfMdgHG5UDg=; b=CGijbDHEFEPFM35d9bfhlI27rW
        1+75Yf3zkNmbo6C9exJsJ/wvNAkdWzVcE+NQr5k58w6tZmJhgNOaTdeg9j1JFGBMtYyb1G6kDCLdM
        w+flQZbCQ2jcvOejH9UgQjxUy2zXLYl+ui0f6NpVeZJQZCLvCkX83xvlH/3gVAT5gypA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hxVFS-0000Yz-Vl; Tue, 13 Aug 2019 13:45:55 +0200
Date:   Tue, 13 Aug 2019 13:45:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Denis Efremov <efremov@linux.com>
Cc:     linux-kernel@vger.kernel.org, joe@perches.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: PHY LIBRARY: Remove sysfs-bus-mdio record
Message-ID: <20190813114554.GU14290@lunn.ch>
References: <7cd8d12f59bcacd18a78f599b46dac555f7f16c0.camel@perches.com>
 <20190813061439.17529-1-efremov@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813061439.17529-1-efremov@linux.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 13, 2019 at 09:14:39AM +0300, Denis Efremov wrote:
> Update MAINTAINERS to reflect that sysfs-bus-mdio documentation
> was removed.
> 
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Cc: netdev@vger.kernel.org
> Fixes: a6cd0d2d493a ("Documentation: net-sysfs: Remove duplicate PHY device documentation")
> Signed-off-by: Denis Efremov <efremov@linux.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
