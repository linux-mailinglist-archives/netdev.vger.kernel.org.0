Return-Path: <netdev+bounces-11070-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A29027316D3
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 13:37:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8C5DF1C20E7D
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 11:37:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E8A0125C1;
	Thu, 15 Jun 2023 11:37:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2571134AA
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 11:37:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B1DBC433C9;
	Thu, 15 Jun 2023 11:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686829040;
	bh=wFknVUKg9Zep7d8KD5madwbt58kjiSFqs26HYAb1rbk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s8wZ7QwQnAwBaJb/shpXNC8ztWfk7NIxmFM56AXHYktUqDHJdmxhysd0ZA6Wt3CDs
	 6KUhUniUBuODAE6OKAoMyDcOD9iAF2Kui7EC/JOGlsQpw3u5YUZWprfz1O/t2vIW31
	 7R0yRjpm0hfZFE21TJYs4by/L1wilgzZpHTeLskM=
Date: Thu, 15 Jun 2023 13:37:17 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Matti Vaittinen <mazziesaccount@gmail.com>,
	Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Daniel Scally <djrscally@gmail.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Wolfram Sang <wsa@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
	Michael Hennerich <Michael.Hennerich@analog.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Andreas Klinger <ak@it-klinger.de>, Marcin Wojtas <mw@semihalf.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Jonathan =?iso-8859-1?Q?Neusch=E4fer?= <j.neuschaefer@gmx.net>,
	Linus Walleij <linus.walleij@linaro.org>,
	Paul Cercueil <paul@crapouillou.net>,
	Akhil R <akhilrajeev@nvidia.com>, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
	linux-iio@vger.kernel.org, netdev@vger.kernel.org,
	openbmc@lists.ozlabs.org, linux-gpio@vger.kernel.org,
	linux-mips@vger.kernel.org
Subject: Re: [PATCH v7 0/9] fix fwnode_irq_get[_byname()] returnvalue
Message-ID: <2023061553-urging-collision-32f8@gregkh>
References: <cover.1685340157.git.mazziesaccount@gmail.com>
 <20230530233438.572db3fb@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530233438.572db3fb@kernel.org>

On Tue, May 30, 2023 at 11:34:38PM -0700, Jakub Kicinski wrote:
> On Mon, 29 May 2023 09:22:15 +0300 Matti Vaittinen wrote:
> > The fwnode_irq_get() and the fwnode_irq_get_byname() may have returned
> > zero if mapping the IRQ fails. This contradicts the
> > fwnode_irq_get_byname() documentation. Furthermore, returning zero or
> > errno on error is unepected and can easily lead to problems
> > like.
> 
> What's the merging plan? Could patch 1 go to a stable branch 
> and then driver trees can pull it in and apply their respective 
> patches locally?

I'll take patch 1 now, and then after 6.5-rc1, Matti, can you send the
cleanup patches to the respective subsystems?

thanks,

greg k-h

