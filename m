Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 548E01DD269
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 17:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728145AbgEUPzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 11:55:16 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43182 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726808AbgEUPzQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 11:55:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=lejDy2yblcAN7FKv0Cx9T90QbZTcebIiYio3X8WfYUA=; b=G4I8KL9PkE/HlMqVPelpUnpE6d
        VykW1M27tvOS1HSHJDhII7PPi8TwJLanBxP3eXDDQ3bS8Ov5UtIEeCTSwl3vwrJsbRQoz0NIga7ds
        UXBAU3HRmGNCN2zFSMplFqn6bHF1iS4q93MxftDmwXaZyxgWxenzO/dJwyBO6JMSdntg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jbnXN-002v2D-In; Thu, 21 May 2020 17:55:13 +0200
Date:   Thu, 21 May 2020 17:55:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Daniel =?iso-8859-1?Q?Gonz=E1lez?= Cabanelas <dgcbueu@gmail.com>,
        netdev@vger.kernel.org, davem@davemloft.net,
        thomas.petazzoni@bootlin.com
Subject: Re: [PATCH] net: mvneta: only do WoL speed down if the PHY is valid
Message-ID: <20200521155513.GE677363@lunn.ch>
References: <3268996.Ej3Lftc7GC@tool>
 <20200521151916.GC677363@lunn.ch>
 <20200521152656.GU1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200521152656.GU1551@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I hope the patch adding pp->dev->phydev hasn't been merged as it's
> almost certainly wrong.

Hi Russell

It was merged :-(

And it Oops when used with a switch.

    Andrew
