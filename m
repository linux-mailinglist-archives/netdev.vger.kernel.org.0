Return-Path: <netdev+bounces-11816-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F377734829
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 22:30:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F30D6280FE2
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 20:30:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8420863BB;
	Sun, 18 Jun 2023 20:30:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C0DBE47
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 20:30:39 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2421F7
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 13:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=GPNi9M6Aw5h+M2i2kr6RRQO3RIsxi3bvaMFMrd0FWcg=; b=rZvzXdmt4j5aNIPUW47tpvx54q
	LSn/zZ/r53io5AYvAg4iUlOxi1INf6bSvF2IKjwhqN6gGDgAqkTUbN66ioKnBnY4yCQa9MWow3H9a
	h3WNN9ntOXokCSoKHoj/rov5sLWwSxeCQN+FzgMJup9hQUQzmAqCm0wXUYbD9rINp5NI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1qAz2i-00GraP-AX; Sun, 18 Jun 2023 22:30:36 +0200
Date: Sun, 18 Jun 2023 22:30:36 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: netdev <netdev@vger.kernel.org>, Heiner Kallweit <hkallweit1@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Oleksij Rempel <linux@rempel-privat.de>
Subject: Re: [PATCH v4 net-next 1/9] net: phy-c45: Fix
 genphy_c45_ethtool_set_eee description
Message-ID: <9f1787b6-a435-4e15-8123-16a8a725c85d@lunn.ch>
References: <20230618184119.4017149-1-andrew@lunn.ch>
 <20230618184119.4017149-2-andrew@lunn.ch>
 <ZI9YkpEsaCj+cDqP@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZI9YkpEsaCj+cDqP@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> >  /**
> > - * genphy_c45_ethtool_set_eee - get EEE supported and status
> > + * genphy_c45_ethtool_set_eee - set EEE supported and status
> >   * @phydev: target phy_device struct
> >   * @data: ethtool_eee data
> >   *
> > - * Description: it reportes the Supported/Advertisement/LP Advertisement
> > - * capabilities.
> > + * Description: it set the Supported/Advertisement/LP Advertisement
> 
>       Description: sets the ...
> 
> > + * capabilities. If eee_enabled is false, no links modes are
> > + * advertised, but the previously advertised link modes are
> 
> I'd suggest moving "advertised," to the preceding line to fill it
> more...
> 
> > + * retained. This allows EEE to be enabled/disabled in a none
> > + * destructive way.
> 
> which then would allow "non-destructive" here rather than the slightly
> more awkward (but correct) "non-
> destructive" formatting here.

Thanks for the comments. I actually ended up submitting this patch
twice, one standalone and then again as part of this patchset. I
should stop submitting patches today, i'm getting too many things
wrong :-)

I will fixup the standalone version.

  Andrew

