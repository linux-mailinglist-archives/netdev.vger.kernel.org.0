Return-Path: <netdev+bounces-11668-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 40808733E03
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 06:36:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 240131C2105C
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 04:36:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECD5C622;
	Sat, 17 Jun 2023 04:36:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE5177F5
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 04:36:17 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73BDD1FF7;
	Fri, 16 Jun 2023 21:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=wUkV62sn8j1lEhJKWcMl0xb3qjf2WlXQi9oTNeYqRrc=; b=4umd6UzaGBKkL6/CSU2iTGaRwF
	IUFovXwULMrVCDKZqwJE0gUy8wGxdFK+iyY9SyPUZL1UzU4QbbB9Jv7NfzXtvqHJN4R195HdPnqah
	o4xsWfOR5dD5VaqnGsGAT5yr8R+VHaFtQeQLAi1o1sfYJZQqf93ZGLbBhR8M39BWX15rSlAdwrBfM
	NljzugUhuTGSRDID5MizyBSuSq9jVkwmrD4Sxzs5nUaRe4ugWEpTCnKkvAWzt3bBZEtzXvdUBva4R
	JTxl4e9YK0E/yjwvUAm/Q6T1Gr1Ob03SByoSJjMN3QAxCLxsBd3e1s927QurYHw2XiXDNUsKzt2Rn
	MIsg2RWg==;
Received: from [2601:1c2:980:9ec0::2764]
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1qANfC-002hUJ-0e;
	Sat, 17 Jun 2023 04:35:50 +0000
Message-ID: <e837c61f-f015-7ccd-003c-7f59acfe54be@infradead.org>
Date: Fri, 16 Jun 2023 21:35:48 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH] net: phy: mediatek: fix compile-test dependencies
Content-Language: en-US
To: Arnd Bergmann <arnd@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
 Heiner Kallweit <hkallweit1@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Russell King <linux@armlinux.org.uk>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 =?UTF-8?Q?Ram=c3=b3n_Nordin_Rodriguez?=
 <ramon.nordin.rodriguez@ferroamp.se>,
 Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>,
 Frank Sae <Frank.Sae@motor-comm.com>, Michael Walle <michael@walle.cc>,
 Daniel Golle <daniel@makrotopia.org>,
 Piergiorgio Beruto <piergiorgio.beruto@gmail.com>,
 Vladimir Oltean <vladimir.oltean@nxp.com>,
 Jonathan Lemon <jonathan.lemon@gmail.com>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org
References: <20230616093009.3511692-1-arnd@kernel.org>
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20230616093009.3511692-1-arnd@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 6/16/23 02:29, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The new phy driver attempts to select a driver from another subsystem,
> but that fails when the NVMEM subsystem is disabled:
> 
> WARNING: unmet direct dependencies detected for NVMEM_MTK_EFUSE
>   Depends on [n]: NVMEM [=n] && (ARCH_MEDIATEK [=n] || COMPILE_TEST [=y]) && HAS_IOMEM [=y]
>   Selected by [y]:
>   - MEDIATEK_GE_SOC_PHY [=y] && NETDEVICES [=y] && PHYLIB [=y] && (ARM64 && ARCH_MEDIATEK [=n] || COMPILE_TEST [=y])
> 
> I could not see an actual compile time dependency, so presumably this
> is only needed for for working correctly but not technically a dependency
> on that particular nvmem driver implementation, so it would likely
> be safe to remove the select for compile testing.
> 
> To keep the spirit of the original 'select', just replace this with a
> 'depends on' that ensures that the driver will work but does not get in
> the way of build testing.
> 
> Fixes: 98c485eaf509b ("net: phy: add driver for MediaTek SoC built-in GE PHYs")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org> # build-tested

Thanks.

> ---
>  drivers/net/phy/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> index a40269c175974..78e6981650d94 100644
> --- a/drivers/net/phy/Kconfig
> +++ b/drivers/net/phy/Kconfig
> @@ -239,7 +239,7 @@ config MEDIATEK_GE_PHY
>  config MEDIATEK_GE_SOC_PHY
>  	tristate "MediaTek SoC Ethernet PHYs"
>  	depends on (ARM64 && ARCH_MEDIATEK) || COMPILE_TEST
> -	select NVMEM_MTK_EFUSE
> +	depends on NVMEM_MTK_EFUSE
>  	help
>  	  Supports MediaTek SoC built-in Gigabit Ethernet PHYs.
>  

-- 
~Randy

