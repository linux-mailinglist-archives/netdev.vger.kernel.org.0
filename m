Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD3CC63694
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 15:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfGINO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 09:14:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35098 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726133AbfGINO1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jul 2019 09:14:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=txVHV8ZhFmk7ni+FVA1Y9x+c/M4/1KzvJcMhD2uKzUE=; b=WZOhRA8PI4zTJhswH6iJ0ALNlk
        IXKpGZk5kl+Qjfm1JB0zDRsVIqoA1FMpR86XfBzI/+2VKqxVrNUXBMT46wma8+eBCDitoEq9kdme4
        xY8LFdgU2vZxXKhuEy6BzgCqqCVAllWEBcqsqubdsHeL7TLlxG6ZBF7c7rJhzsm27tiI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hkpwu-0000fG-P7; Tue, 09 Jul 2019 15:14:24 +0200
Date:   Tue, 9 Jul 2019 15:14:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     josua@solid-run.com
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2 3/4] net: mvmdio: print warning when orion-mdio has
 too many clocks
Message-ID: <20190709131424.GA1965@lunn.ch>
References: <20190706151900.14355-1-josua@solid-run.com>
 <20190709130101.5160-1-josua@solid-run.com>
 <20190709130101.5160-4-josua@solid-run.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190709130101.5160-4-josua@solid-run.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 09, 2019 at 03:01:00PM +0200, josua@solid-run.com wrote:
> From: Josua Mayer <josua@solid-run.com>
> 
> Print a warning when device tree specifies more than the maximum of four
> clocks supported by orion-mdio. Because reading from mdio can lock up
> the Armada 8k when a required clock is not initialized, it is important
> to notify the user when a specified clock is ignored.
> 
> Signed-off-by: Josua Mayer <josua@solid-run.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
