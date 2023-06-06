Return-Path: <netdev+bounces-8280-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CF73723834
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 08:52:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E51A71C209FA
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 06:52:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1DA353B6;
	Tue,  6 Jun 2023 06:52:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A95651
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 06:52:40 +0000 (UTC)
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::221])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B170E48
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 23:52:37 -0700 (PDT)
X-GND-Sasl: maxime.chevallier@bootlin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1686034355;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hq9g+FkBx2qOhWU/2IbG4goANxP2IfC/I4yEBnJijYs=;
	b=BVolinF+niz64ECVgkOq3AMcPQVtZuP5ivMTYdBQ4fkhKgFUDK3XT8OmDTXXHuTxyx4i8u
	yyGcymoS4YnnjZKcZN1VMPj/ittCRszQ8QJpiJNL5/CLAECgtIJga9TtB4dkWzxmI9YtYI
	HEYBDyA/1BWUg26laikioCFoc/dg8nxuwUC//uJlw+ZxZI6EuGSZN/KevBq8uFS+rG7KkY
	v04xq+VegtmuFj9Y8+1OGnSR283hLMz0Bzbkm+UrJgjtomxuvsg0dXVEsSGEQihA/TuINY
	cvEi1NYb/M2wbFoPWEkVFmZPZrkOT6sXLejtEzFlp5X5gkhItJh2N5r8RuzWMQ==
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
Received: by mail.gandi.net (Postfix) with ESMTPSA id DB62624000B;
	Tue,  6 Jun 2023 06:52:34 +0000 (UTC)
Date: Tue, 6 Jun 2023 08:52:33 +0200
From: Maxime Chevallier <maxime.chevallier@bootlin.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev,
 netdev@vger.kernel.org, Simon Horman <simon.horman@corigine.com>
Subject: Re: [net-next:main 3/19]
 drivers/net/ethernet/altera/altera_tse_main.c:1419: undefined reference to
 `lynx_pcs_create_mdiodev'
Message-ID: <20230606085233.41db238a@pc-7.home>
In-Reply-To: <20230605132839.1b604580@kernel.org>
References: <202306060325.l3TVneV8-lkp@intel.com>
	<20230605132839.1b604580@kernel.org>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello Jakub,

On Mon, 5 Jun 2023 13:28:39 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> On Tue, 6 Jun 2023 03:17:47 +0800 kernel test robot wrote:
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git main
> > head:   69da40ac3481993d6f599c98e84fcdbbf0bcd7e0
> > commit: db48abbaa18e571106711b42affe68ca6f36ca5a [3/19] net: ethernet: altera-tse: Convert to mdio-regmap and use PCS Lynx
> > config: nios2-defconfig (https://download.01.org/0day-ci/archive/20230606/202306060325.l3TVneV8-lkp@intel.com/config)
> > compiler: nios2-linux-gcc (GCC) 12.3.0
> > reproduce (this is a W=1 build):
> >         mkdir -p ~/bin
> >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> >         chmod +x ~/bin/make.cross
> >         # https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/commit/?id=db48abbaa18e571106711b42affe68ca6f36ca5a
> >         git remote add net-next https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
> >         git fetch --no-tags net-next main
> >         git checkout db48abbaa18e571106711b42affe68ca6f36ca5a
> >         # save the config file
> >         mkdir build_dir && cp config build_dir/.config
> >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.3.0 ~/bin/make.cross W=1 O=build_dir ARCH=nios2 olddefconfig
> >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.3.0 ~/bin/make.cross W=1 O=build_dir ARCH=nios2 SHELL=/bin/bash
> > 
> > If you fix the issue, kindly add following tag where applicable
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202306060325.l3TVneV8-lkp@intel.com/
> > 
> > All errors (new ones prefixed by >>):
> > 
> >    nios2-linux-ld: drivers/net/ethernet/altera/altera_tse_main.o: in function `altera_tse_probe':  
> > >> drivers/net/ethernet/altera/altera_tse_main.c:1419: undefined reference to `lynx_pcs_create_mdiodev'    
> >    drivers/net/ethernet/altera/altera_tse_main.c:1419:(.text+0xd7c): relocation truncated to fit: R_NIOS2_CALL26 against `lynx_pcs_create_mdiodev'  
> > >> nios2-linux-ld: drivers/net/ethernet/altera/altera_tse_main.c:1451: undefined reference to `lynx_pcs_destroy'    
> >    drivers/net/ethernet/altera/altera_tse_main.c:1451:(.text+0xdf8): relocation truncated to fit: R_NIOS2_CALL26 against `lynx_pcs_destroy'
> >    nios2-linux-ld: drivers/net/ethernet/altera/altera_tse_main.o: in function `altera_tse_remove':  
> > >> drivers/net/ethernet/altera/altera_tse_main.c:1473: undefined reference to `lynx_pcs_destroy'    
> >    drivers/net/ethernet/altera/altera_tse_main.c:1473:(.text+0x1564): relocation truncated to fit: R_NIOS2_CALL26 against `lynx_pcs_destroy'  
> 
> Hum, if it doesn't build without the patch from Mark's tree, I think
> we'll need to revert..

Hmpf that's an unrelated error on my side... I've sent a followup
fix a few minutes ago. Sorry about that.

Maxime

