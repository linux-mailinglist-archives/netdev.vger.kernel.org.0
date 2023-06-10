Return-Path: <netdev+bounces-9838-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 765EE72AD9F
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 19:11:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3DB612814E3
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 17:10:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3853E19E55;
	Sat, 10 Jun 2023 17:10:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A31D2904
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 17:10:54 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C5062D7E;
	Sat, 10 Jun 2023 10:10:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=6/ljHa1TetfsMxIoQmiJpKoOzClakUJOlS+VDPzR2rY=; b=srVZBakSpNNQn5PW8fikii/viR
	cQvMUcdwiz8e0BBzSGPdHWzwnSkyfYlT3qGFSkBexJYzGzmnlqWH8ENxcfWyXEE9rWgI5CDxaOs23
	4LY28r9gJENQWA+qUzzLrOrbs+mnkUXwc425rrZ4YGK5DcT0ZnEkwjWiABrxjt8jCK8Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q826t-00FRzd-RI; Sat, 10 Jun 2023 19:10:43 +0200
Date: Sat, 10 Jun 2023 19:10:43 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Jianhui Zhao <zhaojh329@gmail.com>
Cc: hkallweit1@gmail.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: mdio: fix duplicate registrations for phy with c45
 in __of_mdiobus_register()
Message-ID: <b4d6eb7c-513a-4767-aedc-8d1b6ffd831f@lunn.ch>
References: <20230610161308.3158-1-zhaojh329@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230610161308.3158-1-zhaojh329@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, Jun 11, 2023 at 12:13:08AM +0800, Jianhui Zhao wrote:
> Maybe mdiobus_scan_bus_c45() is called in __mdiobus_register().
> Thus it should skip already registered PHYs later.

Please could you expand on your commit message. I don't see what is
going wrong here. What does your device tree look like? Do you have a
PHY which responds to both C22 and C45?

Thanks
	Andrew

