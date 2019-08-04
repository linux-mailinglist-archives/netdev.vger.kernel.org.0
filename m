Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14D1080B5B
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 17:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbfHDPKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 11:10:16 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59810 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726181AbfHDPKQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Aug 2019 11:10:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=p+WMY+8cLnh8hVqX51cvRSYqb4ylw/3I5FiwQRWM5pY=; b=woUVjGc2uW2gYheYd9bezIjaqt
        iIFQa+nhzH5eQKVa5xI5ruqNiGZlxfeHI1lDKnhwneSrtfpAiKR6Ebubls+UOG3+ax7J30dqktUtK
        qvjQjl8MsJskzdYApK1nktzYMv7s7V9+oJqcxui12fpW5jfwjJH9FJkWHf2I31jssxWU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1huI9F-00026R-79; Sun, 04 Aug 2019 17:10:13 +0200
Date:   Sun, 4 Aug 2019 17:10:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hubert Feurstein <h.feurstein@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: drop adjust_link to enabled
 phylink
Message-ID: <20190804151013.GD6800@lunn.ch>
References: <20190731154239.19270-1-h.feurstein@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190731154239.19270-1-h.feurstein@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 31, 2019 at 05:42:39PM +0200, Hubert Feurstein wrote:
> We have to drop the adjust_link callback in order to finally migrate to
> phylink.
> 
> Otherwise we get the following warning during startup:
>   "mv88e6xxx 2188000.ethernet-1:10: Using legacy PHYLIB callbacks. Please
>    migrate to PHYLINK!"

Hi Hubert

Do we need the same patch for the b53 driver?

   Andrew
