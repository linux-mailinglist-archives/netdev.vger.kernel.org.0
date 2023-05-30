Return-Path: <netdev+bounces-6495-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B27F716A98
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 19:16:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 318211C20BFB
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 17:15:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9978200AF;
	Tue, 30 May 2023 17:15:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9B51F179
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 17:15:59 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8976198;
	Tue, 30 May 2023 10:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=Y5litxN3gyJeHFGeMaTtqwxYqx5JbPyncdwNmEDY4KU=; b=CVH0HFffWk++s38eFUMzA37F0l
	g+OxRHSnHnbU9j4gFyOXNz4qsFYiG11+iHanP7bE06Whdeat8de8YKn0uv7JUBQToXFuIv+S5MphF
	VKWp3j7nNqHc1EHPo9cNH0PLqfxXcRZUtOLYXs4MSbc4Q10xDmgRbyOXfW9aQcUDbfMM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q42wp-00EMSD-Of; Tue, 30 May 2023 19:15:51 +0200
Date: Tue, 30 May 2023 19:15:51 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Lukasz Majewski <lukma@denx.de>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>,
	Vivien Didelot <vivien.didelot@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC] net: dsa: slave: Advertise correct EEE capabilities at
 slave PHY setup
Message-ID: <b9950909-0fa3-46f9-a250-c4eef6ca1786@lunn.ch>
References: <20230530122621.2142192-1-lukma@denx.de>
 <ZHXzTBOtlPKqNfLw@shell.armlinux.org.uk>
 <20230530160743.2c93a388@wsk>
 <e7696621-38a9-41a1-afdf-0864e115d796@lunn.ch>
 <20230530164025.7a6d6bbd@wsk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530164025.7a6d6bbd@wsk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> > But as a result, don't expect EEE to actually work with any LTS
> > kernel.
> 
> Then, I think that it would be best to use the above "hack" until your
> patch set is not reviewed and merged. After that, when customer will
> mover forward with LTS kernel, I can test the EEE on the proper HW.

Just to be clear, Since EEE never really worked, i doubt these
patchset will fulfil the stable rules. They are not minimal fixes, but
pretty much a re-write.  So you will need to wait for the LTS released
December 2023. Or you do your own backport.

	 Andrew

