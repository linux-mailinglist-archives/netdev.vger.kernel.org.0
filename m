Return-Path: <netdev+bounces-11972-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA2807358AE
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 15:34:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7E0C02810F2
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 13:34:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A79A11196;
	Mon, 19 Jun 2023 13:34:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF108BE5
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 13:34:15 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 461ABCF;
	Mon, 19 Jun 2023 06:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=nTWSNiuEhtESNEvZembfyPM0U3olFWyb3kIrhPDUAi8=; b=J2jcfPBY5x/ZtkWeEDS8qw3hNl
	RLSoedlit2R+tdB7rKPyuOXatuiiw7eNPx5DTRttN/tgTZmUoZrM0J9p7I989BT6YZaPMtSboPpaN
	CYILs/twAlH2OVKl7cIfBO+v77YYxll44gZS7qBahgdghX8i+42ZWQJvHdASxkZBgtz0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1qBF1A-00Gueb-5D; Mon, 19 Jun 2023 15:34:04 +0200
Date: Mon, 19 Jun 2023 15:34:04 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Lee Jones <lee@kernel.org>
Cc: Christian Marangi <ansuelsmth@gmail.com>, Pavel Machek <pavel@ucw.cz>,
	"David S. Miller" <davem@davemloft.net>,
	Yang Li <yang.lee@linux.alibaba.com>, linux-leds@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [net-next PATCH v4 0/3] leds: trigger: netdev: add additional
 modes
Message-ID: <dd82d1bd-a225-4452-a9a6-fb447bdb070e@lunn.ch>
References: <20230617115355.22868-1-ansuelsmth@gmail.com>
 <20230619104030.GB1472962@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230619104030.GB1472962@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> Seeing as we're on -rc7 already, any reason why we shouldn't hold off
> and simply apply these against LEDs once v6.5 is released?

Each subsystem has its own policies. netdev tends to accept patches
right up until the merge window opens, sometimes even a couple of days
into the merge window for low risk changes. Maybe this is because
netdev is fast moving, two weeks of not merging results in a big
backlog of patches, making it a bumpy restart once merging is started
again. And is some of those late patches breaks something, there is
still 7 weeks to fix it.

Since this is cross subsystems i would expect both subsystems
Maintainers to agree to a merge or not. If you want to be more
conservative than netdev, wait until after the next merge window,
please say so.

If you do decided to wait, you are going to need to create another
stable branch to pull into netdev. I know it is not a huge overhead,
but it is still work, coordination etc.

       Andrew

