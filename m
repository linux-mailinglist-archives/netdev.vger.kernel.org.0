Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B44954BCFB
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 23:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354987AbiFNVty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 17:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245174AbiFNVty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 17:49:54 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C28551E52
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 14:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=jg/BD/UXuuiofSVd7ivGOGGWFN0ep/F5nImplqHXHiQ=; b=xMDKvIrI9wLw1/mnxJw39f8hd8
        YyOEGZbDtD2a86Q0t8S3u6KII3KvhwKHOVrK4D5HKSv0eyvrJ5q3RTHQe4bgiggdgoT2q0ZH/EBpQ
        M4a5rt2NwLbghuM+m5AzxBRERE38fZ2CAJTG6QJjGC6Cmjxp9scVf4qLjs2+H7KScwQ0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o1EPy-006vzb-Cv; Tue, 14 Jun 2022 23:49:46 +0200
Date:   Tue, 14 Jun 2022 23:49:46 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Robert Hancock <robert.hancock@calian.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next 10/15] net: dsa: mv88e6xxx: add infrastructure
 for phylink_pcs
Message-ID: <YqkCeifkwie/6CQK@lunn.ch>
References: <Yqc0lxn3ngWSuvdS@shell.armlinux.org.uk>
 <E1o0jgu-000JZ5-3S@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1o0jgu-000JZ5-3S@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 13, 2022 at 02:01:12PM +0100, Russell King (Oracle) wrote:
> Add infrastructure for phylink_pcs to the mv88e6xxx driver. This
> involves adding a mac_select_pcs() hook so we can pass the PCS to
> phylink at the appropriate time, and a PCS initialisation function.
> 
> As the various chip implementations are converted to use phylink_pcs,
> they are no longer reliant on the legacy phylink behaviour. We detect
> this by the use of this infrastructure, or the lack of any serdes.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
