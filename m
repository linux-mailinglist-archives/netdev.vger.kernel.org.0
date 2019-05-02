Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B540120A6
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 18:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbfEBQzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 12:55:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52471 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726193AbfEBQzg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 12:55:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=xMqzWPWYIN6jeOd3YVkBiCmwBqYgASR2+g0UEvKZ2P4=; b=QQ7tllZlxmWjEuXWSr4a2ioKAC
        vpAwCvBriqVDIYwJdYna1C6EGvz4pzbJpnFWZ3euQ9D/PMIOPMtu0y9iyoLmkpJHHO2aYo5ohas3b
        Ju/w4dGj0jXgCzVUXMI13hFoeHCoSasBeRLiLWU/0uepkuK1W5wxWqOmOti2+gfmWlaI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hMEza-0001Tk-BB; Thu, 02 May 2019 18:55:30 +0200
Date:   Thu, 2 May 2019 18:55:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        vivien.didelot@gmail.com, netdev <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 net-next 00/12] NXP SJA1105 DSA driver
Message-ID: <20190502165530.GJ19809@lunn.ch>
References: <20190429001706.7449-1-olteanv@gmail.com>
 <20190430.234425.732219702361005278.davem@davemloft.net>
 <CA+h21hrmXaAAepTrY-HfbrmZPVRf3Qg1-fA8EW4prwSkrGYogQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hrmXaAAepTrY-HfbrmZPVRf3Qg1-fA8EW4prwSkrGYogQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Wow I am sorry, Gmail apparently moved your reply to spam and I only
> got it when I posted my message just now.
> Do you know what causes these whitespace errors, so I can avoid them
> next time? I think I'm generating my patches rather normally, with
> $(git format-patch -12 --subject-prefix="PATCH v4 net-next"
> --cover-letter).

What happens when you run checkpatch on the patches? Does it report
white space problems.

Another possibility is your email system has mangled the patches.
First try applying the patches you generated from format-patch to a
clean tree. If you don't get any warnings, email the patches to
yourself, and then apply them.

     Andrew
