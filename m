Return-Path: <netdev+bounces-8219-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BC6472322F
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 23:25:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8E79A1C20D3B
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 21:25:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27B6A271EB;
	Mon,  5 Jun 2023 21:25:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E011B24134
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 21:25:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3DDDC433D2;
	Mon,  5 Jun 2023 21:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686000349;
	bh=HGSdS6z7tmyg4+mMCMO/270kF+95QBP4GXhUx/ceSAo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=qFt303HxkIfBVNmdvi8/CEEWB9ktYt0Iep92A0wICQtVBw2XnT0Kpt4VxJut/k/pp
	 ujJIIxegRXD76Selw6kosL6szsK4WTLI6yBqd0g/Hw55wmTYEX6LXcFcpKhjZks9NX
	 RvdOStrMWvMdcaYEOuinCa37BBGUXXizdSdWGdLTleuq2c8a1rdz26yFB5Dyo3Aywj
	 z3ms8WZMmZBdseeLgjYgwvnMBD+gCdYuSH4SxDBarNjT1jMXBaUdW56+PdAq90HfJz
	 la+Idm/DJQD7c1ISRQuWEPUvXnGhjy/Wrprzn5/ynEA8GHQ22ZXUwWGDO2d9mvQvK4
	 VSsrhZ3FsJmqg==
Date: Mon, 5 Jun 2023 14:25:48 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: 'Wolfram Sang' <wsa@kernel.org>, "Russell King (Oracle)"
 <linux@armlinux.org.uk>, Jiawen Wu <jiawenwu@trustnetic.com>,
 netdev@vger.kernel.org, jarkko.nikula@linux.intel.com,
 mika.westerberg@linux.intel.com, jsd@semihalf.com, Jose.Abreu@synopsys.com,
 andrew@lunn.ch, hkallweit1@gmail.com, linux-i2c@vger.kernel.org,
 linux-gpio@vger.kernel.org, mengyuanlou@net-swift.com, 'Piotr Raczynski'
 <piotr.raczynski@intel.com>
Subject: Re: [PATCH net-next v11 2/9] i2c: designware: Add driver support
 for Wangxun 10Gb NIC
Message-ID: <20230605142548.28714a93@kernel.org>
In-Reply-To: <ZH3dG5CJ3+W6fGNM@smile.fi.intel.com>
References: <20230605025211.743823-1-jiawenwu@trustnetic.com>
	<20230605025211.743823-3-jiawenwu@trustnetic.com>
	<ZH2IaM86ei2gQkfA@shikoro>
	<00c901d9977e$af0dc910$0d295b30$@trustnetic.com>
	<ZH2UT55SRNwN15t7@shikoro>
	<00eb01d99785$8059beb0$810d3c10$@trustnetic.com>
	<ZH2zb7smT/HbFx9k@shikoro>
	<ZH22jS7KPPBEVS2a@shell.armlinux.org.uk>
	<ZH3bwBZvjyIoFaVv@shikoro>
	<ZH3dG5CJ3+W6fGNM@smile.fi.intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 5 Jun 2023 16:03:23 +0300 Andy Shevchenko wrote:
> I'm wondering if it would be easier just mark it in patchwork as applied
> elsewhere (don't remember exact variant, but meaning is the same).

It would not. PW doesn't support sparse series well and it's just
confusing to everyone. We don't do manual handpicking in netdev.
Reposting the remaining patches is the right thing to do.

