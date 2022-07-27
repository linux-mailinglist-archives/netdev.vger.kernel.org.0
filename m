Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA7C05827F7
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 15:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233039AbiG0NrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 09:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233080AbiG0NrW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 09:47:22 -0400
X-Greylist: delayed 4199 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 27 Jul 2022 06:47:20 PDT
Received: from 10.mo582.mail-out.ovh.net (10.mo582.mail-out.ovh.net [87.98.157.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BD9B1FCF4
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 06:47:20 -0700 (PDT)
Received: from player692.ha.ovh.net (unknown [10.108.16.43])
        by mo582.mail-out.ovh.net (Postfix) with ESMTP id 6F2F4211F3
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 12:32:16 +0000 (UTC)
Received: from RCM-web1.webmail.mail.ovh.net (ip-194-187-74-233.konfederacka.maverick.com.pl [194.187.74.233])
        (Authenticated sender: rafal@milecki.pl)
        by player692.ha.ovh.net (Postfix) with ESMTPSA id 08DA82CE188E7;
        Wed, 27 Jul 2022 12:31:45 +0000 (UTC)
MIME-Version: 1.0
Date:   Wed, 27 Jul 2022 14:31:45 +0200
From:   =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
To:     William Zhang <william.zhang@broadcom.com>
Cc:     Linux ARM List <linux-arm-kernel@lists.infradead.org>,
        joel.peshkin@broadcom.com, f.fainelli@gmail.com,
        Broadcom Kernel List <bcm-kernel-feedback-list@broadcom.com>,
        dan.beygelman@broadcom.com, anand.gore@broadcom.com,
        kursad.oney@broadcom.com, krzysztof.kozlowski@linaro.org,
        Guenter Roeck <linux@roeck-us.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-gpio@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH v2 6/9] arm64: bcmbca: Make BCM4908 drivers depend on
 ARCH_BCMBCA
In-Reply-To: <20220725055402.6013-7-william.zhang@broadcom.com>
References: <20220725055402.6013-1-william.zhang@broadcom.com>
 <20220725055402.6013-7-william.zhang@broadcom.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <63797827553783061a0ad5e897ed6538@milecki.pl>
X-Sender: rafal@milecki.pl
X-Originating-IP: 194.187.74.233
X-Webmail-UserID: rafal@milecki.pl
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 3481282513174571860
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvfedrvdduvddgheefucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepggffhffvvefujghffgfkgihitgfgsehtjehjtddtredvnecuhfhrohhmpeftrghfrghlpgfoihhlvggtkhhiuceorhgrfhgrlhesmhhilhgvtghkihdrphhlqeenucggtffrrghtthgvrhhnpeetgfekfeduveehuedvgeefhffhieevhfejteeggfefieevffdtueeukedugeelieenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppedtrddtrddtrddtpdduleegrddukeejrdejgedrvdeffeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphhouhhtpdhhvghlohepphhlrgihvghrieelvddrhhgrrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpehrrghfrghlsehmihhlvggtkhhirdhplhdpnhgspghrtghpthhtohepuddprhgtphhtthhopehnvghtuggvvhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpoffvtefjohhsthepmhhoheekvd
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-07-25 07:53, William Zhang wrote:
> With Broadcom Broadband arch ARCH_BCMBCA supported in the kernel, this
> patch series migrate the ARCH_BCM4908 symbol to ARCH_BCMBCA. Hence
> replace ARCH_BCM4908 with ARCH_BCMBCA in subsystem Kconfig files.
> 
> Signed-off-by: William Zhang <william.zhang@broadcom.com>
> Acked-by: Guenter Roeck <linux@roeck-us.net> (for watchdog)
> Acked-by: Bjorn Helgaas <bhelgaas@google.com> (for drivers/pci)

I still think it may be a bad idea for all below drivers. Please see my
previous e-mail:
Re: [RESEND PATCH 6/9] arm64: bcmbca: Make BCM4908 drivers depend on 
ARCH_BCMBCA
https://lore.kernel.org/linux-arm-kernel/eee8c85652e6dac69420a876d03f67c4@milecki.pl/

I think we should:
1. Keep ARCH_BCM4908 for 4908 specific drivers (e.g. mtd, pinctrl, net)
2. Use ARCH_BCMBCA for more generic drivers (e.g. I2C, PCI,serial, WD)


> Changes in v2:
> - Add Acked-by tags
> - Update commit message with more details
> 
>  drivers/i2c/busses/Kconfig            | 4 ++--
>  drivers/mtd/parsers/Kconfig           | 6 +++---
>  drivers/net/ethernet/broadcom/Kconfig | 4 ++--
>  drivers/pci/controller/Kconfig        | 2 +-
>  drivers/phy/broadcom/Kconfig          | 4 ++--
>  drivers/pinctrl/bcm/Kconfig           | 4 ++--
>  drivers/reset/Kconfig                 | 2 +-
>  drivers/soc/bcm/bcm63xx/Kconfig       | 4 ++--
>  drivers/tty/serial/Kconfig            | 4 ++--
>  drivers/watchdog/Kconfig              | 2 +-
>  10 files changed, 18 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
> index 45a4e9f1b639..fd9a4dd01997 100644
> --- a/drivers/i2c/busses/Kconfig
> +++ b/drivers/i2c/busses/Kconfig
> @@ -487,8 +487,8 @@ config I2C_BCM_KONA
> 
>  config I2C_BRCMSTB
>  	tristate "BRCM Settop/DSL I2C controller"
> -	depends on ARCH_BCM2835 || ARCH_BCM4908 || ARCH_BCMBCA || \
> -		   ARCH_BRCMSTB || BMIPS_GENERIC || COMPILE_TEST
> +	depends on ARCH_BCM2835 || ARCH_BCMBCA || ARCH_BRCMSTB || \
> +		   BMIPS_GENERIC || COMPILE_TEST
>  	default y
>  	help
>  	  If you say yes to this option, support will be included for the
> diff --git a/drivers/mtd/parsers/Kconfig b/drivers/mtd/parsers/Kconfig
> index b43df73927a0..d6db655a1d24 100644
> --- a/drivers/mtd/parsers/Kconfig
> +++ b/drivers/mtd/parsers/Kconfig
> @@ -69,8 +69,8 @@ config MTD_OF_PARTS
> 
>  config MTD_OF_PARTS_BCM4908
>  	bool "BCM4908 partitioning support"
> -	depends on MTD_OF_PARTS && (ARCH_BCM4908 || COMPILE_TEST)
> -	default ARCH_BCM4908
> +	depends on MTD_OF_PARTS && (ARCH_BCMBCA || COMPILE_TEST)
> +	default ARCH_BCMBCA
>  	help
>  	  This provides partitions parser for BCM4908 family devices
>  	  that can have multiple "firmware" partitions. It takes care of
> @@ -78,7 +78,7 @@ config MTD_OF_PARTS_BCM4908
> 
>  config MTD_OF_PARTS_LINKSYS_NS
>  	bool "Linksys Northstar partitioning support"
> -	depends on MTD_OF_PARTS && (ARCH_BCM_5301X || ARCH_BCM4908 || 
> COMPILE_TEST)
> +	depends on MTD_OF_PARTS && (ARCH_BCM_5301X || ARCH_BCMBCA || 
> COMPILE_TEST)
>  	default ARCH_BCM_5301X
>  	help
>  	  This provides partitions parser for Linksys devices based on 
> Broadcom
> diff --git a/drivers/net/ethernet/broadcom/Kconfig
> b/drivers/net/ethernet/broadcom/Kconfig
> index 56e0fb07aec7..f4e1ca68d831 100644
> --- a/drivers/net/ethernet/broadcom/Kconfig
> +++ b/drivers/net/ethernet/broadcom/Kconfig
> @@ -53,8 +53,8 @@ config B44_PCI
> 
>  config BCM4908_ENET
>  	tristate "Broadcom BCM4908 internal mac support"
> -	depends on ARCH_BCM4908 || COMPILE_TEST
> -	default y if ARCH_BCM4908
> +	depends on ARCH_BCMBCA || COMPILE_TEST
> +	default y if ARCH_BCMBCA
>  	help
>  	  This driver supports Ethernet controller integrated into Broadcom
>  	  BCM4908 family SoCs.
> diff --git a/drivers/pci/controller/Kconfig 
> b/drivers/pci/controller/Kconfig
> index d1c5fcf00a8a..bfd9bac37e24 100644
> --- a/drivers/pci/controller/Kconfig
> +++ b/drivers/pci/controller/Kconfig
> @@ -274,7 +274,7 @@ config VMD
> 
>  config PCIE_BRCMSTB
>  	tristate "Broadcom Brcmstb PCIe host controller"
> -	depends on ARCH_BRCMSTB || ARCH_BCM2835 || ARCH_BCM4908 || \
> +	depends on ARCH_BRCMSTB || ARCH_BCM2835 || ARCH_BCMBCA || \
>  		   BMIPS_GENERIC || COMPILE_TEST
>  	depends on OF
>  	depends on PCI_MSI_IRQ_DOMAIN
> diff --git a/drivers/phy/broadcom/Kconfig 
> b/drivers/phy/broadcom/Kconfig
> index 93a6a8ee4716..1d89a2fd9b79 100644
> --- a/drivers/phy/broadcom/Kconfig
> +++ b/drivers/phy/broadcom/Kconfig
> @@ -93,11 +93,11 @@ config PHY_BRCM_SATA
> 
>  config PHY_BRCM_USB
>  	tristate "Broadcom STB USB PHY driver"
> -	depends on ARCH_BCM4908 || ARCH_BRCMSTB || COMPILE_TEST
> +	depends on ARCH_BCMBCA || ARCH_BRCMSTB || COMPILE_TEST
>  	depends on OF
>  	select GENERIC_PHY
>  	select SOC_BRCMSTB if ARCH_BRCMSTB
> -	default ARCH_BCM4908 || ARCH_BRCMSTB
> +	default ARCH_BCMBCA || ARCH_BRCMSTB
>  	help
>  	  Enable this to support the Broadcom STB USB PHY.
>  	  This driver is required by the USB XHCI, EHCI and OHCI
> diff --git a/drivers/pinctrl/bcm/Kconfig b/drivers/pinctrl/bcm/Kconfig
> index 8f4d89806fcb..35b51ce4298e 100644
> --- a/drivers/pinctrl/bcm/Kconfig
> +++ b/drivers/pinctrl/bcm/Kconfig
> @@ -31,13 +31,13 @@ config PINCTRL_BCM2835
> 
>  config PINCTRL_BCM4908
>  	tristate "Broadcom BCM4908 pinmux driver"
> -	depends on OF && (ARCH_BCM4908 || COMPILE_TEST)
> +	depends on OF && (ARCH_BCMBCA || COMPILE_TEST)
>  	select PINMUX
>  	select PINCONF
>  	select GENERIC_PINCONF
>  	select GENERIC_PINCTRL_GROUPS
>  	select GENERIC_PINMUX_FUNCTIONS
> -	default ARCH_BCM4908
> +	default ARCH_BCMBCA
>  	help
>  	  Driver for BCM4908 family SoCs with integrated pin controller.
> 
> diff --git a/drivers/reset/Kconfig b/drivers/reset/Kconfig
> index f9a7cee01659..7ae71535fe2a 100644
> --- a/drivers/reset/Kconfig
> +++ b/drivers/reset/Kconfig
> @@ -201,7 +201,7 @@ config RESET_SCMI
> 
>  config RESET_SIMPLE
>  	bool "Simple Reset Controller Driver" if COMPILE_TEST || EXPERT
> -	default ARCH_ASPEED || ARCH_BCM4908 || ARCH_BITMAIN || ARCH_REALTEK
> || ARCH_STM32 || (ARCH_INTEL_SOCFPGA && ARM64) || ARCH_SUNXI || ARC
> +	default ARCH_ASPEED || ARCH_BCMBCA || ARCH_BITMAIN || ARCH_REALTEK
> || ARCH_STM32 || (ARCH_INTEL_SOCFPGA && ARM64) || ARCH_SUNXI || ARC
>  	help
>  	  This enables a simple reset controller driver for reset lines that
>  	  that can be asserted and deasserted by toggling bits in a 
> contiguous,
> diff --git a/drivers/soc/bcm/bcm63xx/Kconfig 
> b/drivers/soc/bcm/bcm63xx/Kconfig
> index 9e501c8ac5ce..355c34482076 100644
> --- a/drivers/soc/bcm/bcm63xx/Kconfig
> +++ b/drivers/soc/bcm/bcm63xx/Kconfig
> @@ -13,8 +13,8 @@ endif # SOC_BCM63XX
> 
>  config BCM_PMB
>  	bool "Broadcom PMB (Power Management Bus) driver"
> -	depends on ARCH_BCM4908 || (COMPILE_TEST && OF)
> -	default ARCH_BCM4908
> +	depends on ARCH_BCMBCA || (COMPILE_TEST && OF)
> +	default ARCH_BCMBCA
>  	select PM_GENERIC_DOMAINS if PM
>  	help
>  	  This enables support for the Broadcom's PMB (Power Management Bus) 
> that
> diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
> index e3279544b03c..f32bb01c3feb 100644
> --- a/drivers/tty/serial/Kconfig
> +++ b/drivers/tty/serial/Kconfig
> @@ -1100,8 +1100,8 @@ config SERIAL_TIMBERDALE
>  config SERIAL_BCM63XX
>  	tristate "Broadcom BCM63xx/BCM33xx UART support"
>  	select SERIAL_CORE
> -	depends on ARCH_BCM4908 || ARCH_BCMBCA || BCM63XX || BMIPS_GENERIC
> || COMPILE_TEST
> -	default ARCH_BCM4908 || ARCH_BCMBCA || BCM63XX || BMIPS_GENERIC
> +	depends on ARCH_BCMBCA || BCM63XX || BMIPS_GENERIC || COMPILE_TEST
> +	default ARCH_BCMBCA || BCM63XX || BMIPS_GENERIC
>  	help
>  	  This enables the driver for the onchip UART core found on
>  	  the following chipsets:
> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> index 32fd37698932..1f85ec8a4b3b 100644
> --- a/drivers/watchdog/Kconfig
> +++ b/drivers/watchdog/Kconfig
> @@ -1798,7 +1798,7 @@ config BCM7038_WDT
>  	tristate "BCM63xx/BCM7038 Watchdog"
>  	select WATCHDOG_CORE
>  	depends on HAS_IOMEM
> -	depends on ARCH_BCM4908 || ARCH_BRCMSTB || BMIPS_GENERIC || BCM63XX
> || COMPILE_TEST
> +	depends on ARCH_BCMBCA || ARCH_BRCMSTB || BMIPS_GENERIC || BCM63XX
> || COMPILE_TEST
>  	help
>  	  Watchdog driver for the built-in hardware in Broadcom 7038 and
>  	  later SoCs used in set-top boxes.  BCM7038 was made public
