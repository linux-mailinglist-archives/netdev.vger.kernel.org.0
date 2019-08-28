Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8C3DA07D6
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 18:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbfH1QuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 12:50:01 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38192 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726566AbfH1QuA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 12:50:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5xLaBMYTVCRP4903ZFN0Ub764RsGp9lEvSZMwk9wOZI=; b=qsD2I9liWWYjwaJyrW0cjLnJg8
        ALa3+wVIMX9oZ8l4cXDONseyVkUquUKV5bXYsgcqyfK6ZQHh4nP8psVbImVfSLlepYT7otI8eIbXQ
        cJIuu0VvNgaG3sn7zJZV59qridOZGRY5Ifhgl715ERxE4YlBWMTqR+OSU/AJYH/SH2Z4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i318v-0004Ku-L7; Wed, 28 Aug 2019 18:49:57 +0200
Date:   Wed, 28 Aug 2019 18:49:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>,
        f.fainelli@gmail.com
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: get serdes lane after lock
Message-ID: <20190828164957.GC13074@lunn.ch>
References: <20190828162611.10064-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190828162611.10064-1-vivien.didelot@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 28, 2019 at 12:26:11PM -0400, Vivien Didelot wrote:
> This is a follow-up patch for commit 17deaf5cb37a ("net: dsa:
> mv88e6xxx: create serdes_get_lane chip operation").
> 
> The .serdes_get_lane implementations access the CMODE of a port,
> even though it is cached at the moment, it is safer to call them
> after the mutex is locked, not before.
> 
> At the same time, check for an eventual error and return IRQ_DONE,
> instead of blindly ignoring it.
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
