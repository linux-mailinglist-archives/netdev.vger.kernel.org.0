Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2777C14A7BE
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 17:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729652AbgA0QET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 11:04:19 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56192 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729146AbgA0QET (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 11:04:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=IEhBXQolKdYdTh55pxpxJxonj6D/So7Ri+xcTzqeqVk=; b=GZ2lCk7u39OPIsQic6y7S9kHuz
        IQ3ZDuxN7wuHApEqWCr7hoqQwNqHFDoysHfsg/IlXa7GjrcLqKpPND5/2mo+bijyl6f6TkF3yDT4N
        B9KXqOm0ujo/xeNxsCGDadHvIPmok/mAwoQZFa3lh0jJp6tE6yGPcO44jNmNRBue26Kg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1iw6s1-00076Q-VG; Mon, 27 Jan 2020 17:04:13 +0100
Date:   Mon, 27 Jan 2020 17:04:13 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     madalin.bucur@oss.nxp.com, "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>, ykaukab@suse.de
Subject: Re: [PATCH v2 2/2] dpaa_eth: support all modes with rate adapting
 PHYs
Message-ID: <20200127160413.GI13647@lunn.ch>
References: <1580137671-22081-1-git-send-email-madalin.bucur@oss.nxp.com>
 <1580137671-22081-3-git-send-email-madalin.bucur@oss.nxp.com>
 <CA+h21hqzR72v9=dWGk1zBptNHNst+kajh6SHHSUMp02fAq5m5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hqzR72v9=dWGk1zBptNHNst+kajh6SHHSUMp02fAq5m5g@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Is this sufficient?
> I suppose this works because you have flow control enabled by default?
> What would happen if the user would disable flow control with ethtool?

It will still work. Network protocols expect packets to be dropped,
there are bottlenecks on the network, and those bottlenecks change
dynamically. TCP will still be able to determine how much traffic it
can send without too much packet loss, independent of if the
bottleneck is here between the MAC and the PHY, or later when it hits
an RFC 1149 link.

    Andrew

