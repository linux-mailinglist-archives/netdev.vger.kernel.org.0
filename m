Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85170DECBD
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 14:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728740AbfJUMtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 08:49:06 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55440 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727725AbfJUMtG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Oct 2019 08:49:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=uDWj1BGLJpqiTjvVPaLp3YpcS8YSDcQwU3Vq1WTdWec=; b=L7A1moRjU205jA6hbMLRm+3Te3
        KxVLLgDMhzx1pO1WnrG2zN+jE2XtgGLF/pOiew9i4KLdpjiF5kud2CpCplObCpNqxR3dKYqFSZAA0
        WW6CFjV1H9TwRmWVQmqPb8qs6FJSMRwANZfXKV8J7wFSQfKyCKUfszkrYBThG0p0S79c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iMX7O-0004Os-OB; Mon, 21 Oct 2019 14:49:02 +0200
Date:   Mon, 21 Oct 2019 14:49:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 05/16] net: dsa: use ports list to setup switches
Message-ID: <20191021124902.GF16084@lunn.ch>
References: <20191020031941.3805884-1-vivien.didelot@gmail.com>
 <20191020031941.3805884-6-vivien.didelot@gmail.com>
 <21738767-7e98-6c4c-ba1c-bea29142d481@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21738767-7e98-6c4c-ba1c-bea29142d481@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 20, 2019 at 07:42:15PM -0700, Florian Fainelli wrote:
> 
> 
> On 10/19/2019 8:19 PM, Vivien Didelot wrote:
> > Use the new ports list instead of iterating over switches and their
> > ports when setting up the switches and their ports.
> > 
> > At the same time, provide setup states and messages for ports and
> > switches as it is done for the trees.
> 
> Humm, that becomes quite noisy, would it make sense to have those
> messages only for non-user ports that are not already visible because
> they do not have a net_device?

I agree, it looks noise. Maybe change them to _dbg()?
 
> If you have multiple switches in a fabric, it might be convenient to use
> dev_info(dp->ds->dev, ...) to print your message so you can clearly
> identify which port belongs to which switch, which becomes even more
> important as it is all flattened thanks to lists now. What do you think?

I do think it needs to identify both the dst and the ds.

  Andrew
