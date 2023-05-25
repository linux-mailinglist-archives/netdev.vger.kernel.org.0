Return-Path: <netdev+bounces-5306-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D90B0710AA5
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 13:15:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9E9981C20EC2
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 11:15:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7BE5FC00;
	Thu, 25 May 2023 11:15:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B035E574
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 11:15:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19BF6C433D2;
	Thu, 25 May 2023 11:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685013327;
	bh=16CfExnCW0v4mSVwy4bxcZIlomgq0okkzlQp2MZhQ9w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uZtmMFtKqX/kAst5YKvj5lVcaOben3KKmosrpLCqDWiWJHQb6umgDMbEbOf1vI2Cw
	 OGIblC5DfKopA1ciYfTcVBkZr1wj3uBP13UJkJsSmMK4PumIInnk5oAtj5qqmewXSN
	 7Iaut92MkM5WESQxgXuPHtbs7yiHCvweZlKSwjjWrJOahKuQF+ij+mP9NJwKoaM41h
	 6ZgxSDjvXgamYndW9DWZsrxwXjBUVTEIcq52NzeNX8vUmIEejP8NGaE3jemxMvUDa4
	 BuRnc5RmKEyvpcKe0JNH945RQSn4hxZLVmGMz+p8KySo5KLWHLvsbCvfNgntSccvOW
	 v5miO3mPgCLWQ==
Date: Thu, 25 May 2023 12:15:21 +0100
From: Lee Jones <lee@kernel.org>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Christian Marangi <ansuelsmth@gmail.com>, Pavel Machek <pavel@ucw.cz>,
	linux-leds@vger.kernel.org, David Miller <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	netdev <netdev@vger.kernel.org>
Subject: [GIT PULL] Immutable branch between LEDs and netdev due for the v6.5
 merge window
Message-ID: <20230525111521.GA411262@google.com>
References: <02004a73-2768-46f6-86ad-c6c631631abf@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <02004a73-2768-46f6-86ad-c6c631631abf@lunn.ch>

> Christian Marangi and I will be continuing the work of offloading LED
> blinking to Ethernet MAC and PHY LED controllers. The next set of
> patches is again cross subsystem, LEDs and netdev. It also requires
> some patches you have in for-leds-next:
> 
> a286befc24e8 leds: trigger: netdev: Use mutex instead of spinlocks
> 509412749002 leds: trigger: netdev: Convert device attr to macro
> 0fd93ac85826 leds: trigger: netdev: Rename add namespace to netdev trigger enum modes
> eb31ca4531a0 leds: trigger: netdev: Drop NETDEV_LED_MODE_LINKUP from mode
> 3fc498cf54b4 leds: trigger: netdev: Recheck NETDEV_LED_MODE_LINKUP on dev rename
> 
> I'm assuming the new series will get nerged via netdev, with your
> Acked-by. Could you create a stable branch with these patches which
> can be pulled into netdev?

-------------

The following changes since commit ac9a78681b921877518763ba0e89202254349d1b:

  Linux 6.4-rc1 (2023-05-07 13:34:35 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lee/leds.git ib-leds-netdev-v6.5

for you to fetch changes up to d1b9e1391ab2dc80e9db87fe8b2de015c651e4c9:

  leds: trigger: netdev: Use mutex instead of spinlocks (2023-05-25 12:07:38 +0100)

----------------------------------------------------------------
Immutable branch between LEDs and netdev due for the v6.5 merge window

----------------------------------------------------------------
Christian Marangi (5):
      leds: trigger: netdev: Recheck NETDEV_LED_MODE_LINKUP on dev rename
      leds: trigger: netdev: Drop NETDEV_LED_MODE_LINKUP from mode
      leds: trigger: netdev: Rename add namespace to netdev trigger enum modes
      leds: trigger: netdev: Convert device attr to macro
      leds: trigger: netdev: Use mutex instead of spinlocks

 drivers/leds/trigger/ledtrig-netdev.c | 151 +++++++++++++---------------------
 1 file changed, 59 insertions(+), 92 deletions(-)

-- 
Lee Jones [李琼斯]

