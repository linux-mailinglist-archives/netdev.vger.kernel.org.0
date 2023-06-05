Return-Path: <netdev+bounces-8199-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A80D72316B
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 22:29:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 00F3D1C20D20
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 20:29:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2C6A261E5;
	Mon,  5 Jun 2023 20:28:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A25261DA;
	Mon,  5 Jun 2023 20:28:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF939C433D2;
	Mon,  5 Jun 2023 20:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685996920;
	bh=SOB6TXii0X/LL9pHwHXkq3U/qAHYc7nqMK4r9mLoUpA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=rP+4FEn2nSktXAukfJXBONmnnEcXgF3CmeRdodVU2u8bbUIqn1C8gOIOiS7qXz5be
	 T9pV/DeYRdZoNwQvg6MwLEUZ/pAtvQh/VRwPD4KGMpBCX7aYQFrw//K1VOxBTwwtsc
	 WDIiHaS/QCOTGTTFwUPmWhMgxIcSolJqonzUUqMwl8ASaSMzT33ppu3hMwLH07d946
	 WWZo1UhwAVhWklnr6AYRVRdnn0PeBFpv4VX0lW1BN2i9syRxw4cWtsTpwxtkZctzAY
	 HL9HMtuEmWKl7eYTTo2QyUgMw/FTrYVppBOvnymdE9ryxvLq91G2QDduEH+EjRgfv4
	 QOhKrED9HyGoA==
Date: Mon, 5 Jun 2023 13:28:39 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: kernel test robot <lkp@intel.com>
Cc: Maxime Chevallier <maxime.chevallier@bootlin.com>,
 oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org, Simon Horman
 <simon.horman@corigine.com>
Subject: Re: [net-next:main 3/19]
 drivers/net/ethernet/altera/altera_tse_main.c:1419: undefined reference to
 `lynx_pcs_create_mdiodev'
Message-ID: <20230605132839.1b604580@kernel.org>
In-Reply-To: <202306060325.l3TVneV8-lkp@intel.com>
References: <202306060325.l3TVneV8-lkp@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 6 Jun 2023 03:17:47 +0800 kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git main
> head:   69da40ac3481993d6f599c98e84fcdbbf0bcd7e0
> commit: db48abbaa18e571106711b42affe68ca6f36ca5a [3/19] net: ethernet: altera-tse: Convert to mdio-regmap and use PCS Lynx
> config: nios2-defconfig (https://download.01.org/0day-ci/archive/20230606/202306060325.l3TVneV8-lkp@intel.com/config)
> compiler: nios2-linux-gcc (GCC) 12.3.0
> reproduce (this is a W=1 build):
>         mkdir -p ~/bin
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/commit/?id=db48abbaa18e571106711b42affe68ca6f36ca5a
>         git remote add net-next https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
>         git fetch --no-tags net-next main
>         git checkout db48abbaa18e571106711b42affe68ca6f36ca5a
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.3.0 ~/bin/make.cross W=1 O=build_dir ARCH=nios2 olddefconfig
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.3.0 ~/bin/make.cross W=1 O=build_dir ARCH=nios2 SHELL=/bin/bash
> 
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202306060325.l3TVneV8-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>    nios2-linux-ld: drivers/net/ethernet/altera/altera_tse_main.o: in function `altera_tse_probe':
> >> drivers/net/ethernet/altera/altera_tse_main.c:1419: undefined reference to `lynx_pcs_create_mdiodev'  
>    drivers/net/ethernet/altera/altera_tse_main.c:1419:(.text+0xd7c): relocation truncated to fit: R_NIOS2_CALL26 against `lynx_pcs_create_mdiodev'
> >> nios2-linux-ld: drivers/net/ethernet/altera/altera_tse_main.c:1451: undefined reference to `lynx_pcs_destroy'  
>    drivers/net/ethernet/altera/altera_tse_main.c:1451:(.text+0xdf8): relocation truncated to fit: R_NIOS2_CALL26 against `lynx_pcs_destroy'
>    nios2-linux-ld: drivers/net/ethernet/altera/altera_tse_main.o: in function `altera_tse_remove':
> >> drivers/net/ethernet/altera/altera_tse_main.c:1473: undefined reference to `lynx_pcs_destroy'  
>    drivers/net/ethernet/altera/altera_tse_main.c:1473:(.text+0x1564): relocation truncated to fit: R_NIOS2_CALL26 against `lynx_pcs_destroy'

Hum, if it doesn't build without the patch from Mark's tree, I think
we'll need to revert..

