Return-Path: <netdev+bounces-6089-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 262EA714C9A
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 17:00:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B36C01C208F2
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 15:00:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E741F8C09;
	Mon, 29 May 2023 15:00:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9BED6FCF
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 15:00:21 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D1F5AD;
	Mon, 29 May 2023 08:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=5j7SFtDQH8X7DSfej9/fAOkmgEKXu6OTxSbujrl3kdk=; b=t0baHsaWpZWl967uOTI/ZY11Je
	l4dVgDg9fL0BQyf4o/bZUTF3VCQCHo8kMsDQwsk+Wfl7md4kAsQC5r7odS79nXI0nJbLVXjCcu24C
	Vd5XeodM60KmcaPtfK69x8zpyiu4zP/52CMyY0Efndw4Zsl+3tIyD24QIIll5MGIOJjw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q3eM0-00EEjm-HD; Mon, 29 May 2023 17:00:12 +0200
Date: Mon, 29 May 2023 17:00:12 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Jerry Ray <jerry.ray@microchip.com>,
	"David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v1 1/1] dsa: lan9303: Remove stray
 gpiod_unexport() call
Message-ID: <3eb4f7cf-6401-40ba-b2c0-9a1f26308f98@lunn.ch>
References: <20230528142531.38602-1-andriy.shevchenko@linux.intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230528142531.38602-1-andriy.shevchenko@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, May 28, 2023 at 05:25:31PM +0300, Andy Shevchenko wrote:
> There is no gpiod_export() and gpiod_unexport() looks pretty much stray.
> The gpiod_export() and gpiod_unexport() shouldn't be used in the code,
> GPIO sysfs is deprecated. That said, simply drop the stray call.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

