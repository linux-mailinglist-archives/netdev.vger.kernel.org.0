Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A552DEF29
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 16:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728819AbfJUORb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 10:17:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55596 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727680AbfJUORa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Oct 2019 10:17:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Jgv/JiY9a5I5w4sH96aTClgjxrSZfSDUHF7+EXcVTKM=; b=tWPGkhZCTIq3v4COdlYxrCK7Ge
        1tq8PRpOElMfJhEVDHPKZqXZVAi7JnM1xrLdA8kl4H15uYXJzaSD+UqTFCq+oD/skmFU+E0oglD+z
        Io2xZ2KWlf8aYSA5kh4MBbavhtOj/6zh7B6IBuBr7pFSlS0748XEjH6AnbEvtvWZnnGk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iMYUx-0004pX-Fx; Mon, 21 Oct 2019 16:17:27 +0200
Date:   Mon, 21 Oct 2019 16:17:27 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 08/16] net: dsa: use ports list to setup
 multiple master devices
Message-ID: <20191021141727.GD17002@lunn.ch>
References: <20191020031941.3805884-1-vivien.didelot@gmail.com>
 <20191020031941.3805884-9-vivien.didelot@gmail.com>
 <55f1256b-c1b3-f222-9275-c0cc969a59ab@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55f1256b-c1b3-f222-9275-c0cc969a59ab@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 20, 2019 at 08:03:34PM -0700, Florian Fainelli wrote:
> 
> 
> On 10/19/2019 8:19 PM, Vivien Didelot wrote:
> > Now that we have a potential list of CPU ports, make use of it instead
> > of only configuring the master device of an unique CPU port.
> 
> Out of your series, this is the only one that has possible side effects
> to existing set-up in that if you had multiple CPU ports defined, today,
> we would stop at the first one, whereas now, we will set them all up. I
> believe this is right way to do it, but have not had time to fire up a
> test on a BCM7278 w/ bcm_sf2 and this patch series to confirm that, will
> do that first thing tomorrow morning.

Hi Florian

The next patch might also change things, finding the first CPU port.
Is the order of the link list the same as searching the port array?

   Andrew
