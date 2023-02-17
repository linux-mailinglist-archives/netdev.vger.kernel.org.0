Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEA3869B1ED
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 18:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbjBQRkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 12:40:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbjBQRkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 12:40:11 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E21B714A7;
        Fri, 17 Feb 2023 09:40:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=o/Ixh04YsOuSmwGw24QhQlanGNMqW6xNp2H4bqYVuQ8=; b=IiLVD77gJcyS9iX+4f91zOE2cV
        TDjkesbORmR0IAH/3nuZyNqjbm34PmDF1y5u62JuOpVkNVFLXriXQBkvrmlfMY1IrcfLcD+gPffUk
        gNAacubEPaRrl+UGK04yOPRT8qUyiAuU6Hv5t8zKRWmAMtgHcwA7A6tEu1+sLN76oSMs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pT4iM-005JW3-9t; Fri, 17 Feb 2023 18:40:06 +0100
Date:   Fri, 17 Feb 2023 18:40:06 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        f.fainelli@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        Thangaraj Samynathan <Thangaraj.S@microchip.com>
Subject: Re: [PATCH v2 net-next 1/5] net: dsa: microchip: add rmon grouping
 for ethtool statistics
Message-ID: <Y++79sDREoyj+mWc@lunn.ch>
References: <20230217110211.433505-1-rakesh.sankaranarayanan@microchip.com>
 <20230217110211.433505-2-rakesh.sankaranarayanan@microchip.com>
 <20230217165346.2eaualia32kmliz6@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230217165346.2eaualia32kmliz6@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 06:53:46PM +0200, Vladimir Oltean wrote:
> On Fri, Feb 17, 2023 at 04:32:07PM +0530, Rakesh Sankaranarayanan wrote:
> >     Add support for ethtool standard device statistics grouping. Support rmon
> >     statistics grouping using rmon groups parameter in ethtool command. rmon
> >     provides packet size based range grouping. Common mib parameters are used
> >     across all KSZ series swtches for packet size statistics, except for
> >     KSZ8830. KSZ series have mib counters for packets with size:
> >     - less than 64 Bytes,
> >     - 65 to 127 Bytes,
> >     - 128 to 255 Bytes,
> >     - 256 to 511 Bytes,
> >     - 512 to 1023 Bytes,
> >     - 1024 to 1522 Bytes,
> >     - 1523 to 2000 Bytes and
> >     - More than 2001 Bytes
> >     KSZ8830 have mib counters upto 1024-1522 range only. Since no other change,
> >     common range used across all KSZ series, but used upto only upto 1024-1522
> >     for KSZ8830.
> 
> Why are all commit messages indented in this way? Please keep the
> default text indentation at 0 characters. I have never seen this style
> in "git log".

I can make a guess

git show HEAD

notice how the commit message is indented. So if you where to
cut/paste that, you get the extra indent. It is better to do:

git commit -C 8e757b50555f3ae ; git commit --am

to copy a commit message from 8e757b50555f3ae, and then edit it to
suite.

	Andrew
