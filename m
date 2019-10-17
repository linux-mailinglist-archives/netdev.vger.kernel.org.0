Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92DC7DAE06
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 15:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394419AbfJQNP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 09:15:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50556 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394313AbfJQNP1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Oct 2019 09:15:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=NqVeHSqOt7B49IXQ7DBm0nJvqrZVETdR2j3Q+0D5yBk=; b=BNND/TCB2BZpVmQujW/03vUDTN
        7iY+e61kwaHLaAoBoDESVzmbENCJ/t60CuvndaGdVxM/aPZ/01g7m2ON9E/KlnwPowwzpI157VscX
        J5ANU/jbivWqVhtShE18WtdGuvxLC4H6cjreA9z9T/4VVUCLYT6CnI6g2sK72Zzh6xvw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iL5cb-0004RE-8r; Thu, 17 Oct 2019 15:15:17 +0200
Date:   Thu, 17 Oct 2019 15:15:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniel Wagner <dwagner@suse.de>
Cc:     bcm-kernel-feedback-list@broadcom.com,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org
Subject: Re: lan78xx and phy_state_machine
Message-ID: <20191017131517.GJ4780@lunn.ch>
References: <20191014140604.iddhmg5ckqhzlbkw@beryllium.lan>
 <20191015005327.GJ19861@lunn.ch>
 <20191015171653.ejgfegw3hkef3mbo@beryllium.lan>
 <20191016142501.2c76q7kkfmfcnqns@beryllium.lan>
 <20191016155107.GH17013@lunn.ch>
 <20191017065230.krcrrlmedzi6tj3r@beryllium.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017065230.krcrrlmedzi6tj3r@beryllium.lan>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 17, 2019 at 08:52:30AM +0200, Daniel Wagner wrote:
> On Wed, Oct 16, 2019 at 05:51:07PM +0200, Andrew Lunn wrote:
> > Hi Daniel
> > 
> > Please could you give this a go. It is totally untested, not even
> > compile tested...
> 
> Sure. The system boots but ther is one splat:

Cool. So we are going in the right direction.

This splat looks complete different. But it might still be a race
condition with netdev_register. We should look at what the power
management code is doing.

	   Andrew
