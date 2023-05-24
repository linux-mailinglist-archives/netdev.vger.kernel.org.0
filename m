Return-Path: <netdev+bounces-5038-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BD0C70F7FC
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 15:48:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A0011C20D3C
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 13:48:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC2F4182C7;
	Wed, 24 May 2023 13:48:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACC671FDD
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 13:48:16 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B80FD9E;
	Wed, 24 May 2023 06:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=Lvfka6Ek+41nm7w9MV0i66TSEWM9HlLQmnBz2RnwAbk=; b=pXsAWHDC8asialXtF8xj2rSAeM
	eLDHhIfGcUT1FzTPKDVnmQoUPQbvLoAvsyqoq50dBCXQp7gRG7+1Lv+iPLurWWIaJk6h+lqJZ9eQ/
	8HalFOjHbXBz6CC5dlYOfmCNo6v1IIku6UUSykP1SjhFejocjrX+9+YfkSCGX6kPsG/k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q1oqQ-00DnXy-2A; Wed, 24 May 2023 15:48:02 +0200
Date: Wed, 24 May 2023 15:48:02 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Lukasz Majewski <lukma@denx.de>
Cc: Vladimir Oltean <olteanv@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Alexander Duyck <alexander.duyck@gmail.com>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 0/3] dsa: marvell: Add support for mv88e6071 and 6020
 switches
Message-ID: <c39f4127-e1fe-4d38-83eb-f372ca2ebcd3@lunn.ch>
References: <20230523142912.2086985-1-lukma@denx.de>
 <89fd3a8d-c262-46d8-98ad-c8dc04fe9d9c@lunn.ch>
 <20230524141743.1322c051@wsk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230524141743.1322c051@wsk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> > Vladimir indicates here that it is not known how to change the max MTU
> > for the MV88E6250. Where did you get the information from to implement
> > it?
> 
> Please refer to [1].
> 
> The mv88e6185_g1_set_max_frame_size() function can be reused (as
> registers' offsets and bits are the same for mv88e60{71|20}).

So you have the datasheet? You get the information to implement this
from the data sheet?

     Andrew

