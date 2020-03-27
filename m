Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0E7C1956CA
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 13:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727509AbgC0MJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 08:09:49 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:33188 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727143AbgC0MJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 08:09:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=o9B1rFQ4v0sXVcXWC4TqFJTLVIwnn8Q7w9fjLLJ4hrU=; b=N+jdtrADNN07k3r5HhGtyqzem
        WiAXI5pzgpoSoL4dqV7wTU9wxnbcSQ0w3zFfjkYhyo9dy830AAiG0ytPf2aqYEIP1NDqZfKFuJaPE
        TS0kb2/4QRoxCt8zG6zeauCWkMFGjrDN5oO24n1AClWepQ3i3frj1dw0noSh6EQ49dg0b2LLS35QV
        qlzzTn0lgCavFZcDAGjDzn3PZv4chd/fbNLnldL5IaYcO7b/NXK5m4n7ROEQPhXOtknDhrXhCM4BE
        wMjG1oABE0T0ctzV5iIvZUWJ3exxm7XT8s41SxHrEOT1nypcPQrVmI1J8uoJcSPyFc+ZBikv3JYdk
        t3PO9yssQ==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:58606)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jHnnz-0000wD-CV; Fri, 27 Mar 2020 12:09:43 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jHnny-0004Cp-5K; Fri, 27 Mar 2020 12:09:42 +0000
Date:   Fri, 27 Mar 2020 12:09:42 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Florinel Iordache <florinel.iordache@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, kuba@kernel.org,
        corbet@lwn.net, shawnguo@kernel.org, leoyang.li@nxp.com,
        madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 9/9] arm64: dts: add serdes and mdio description
Message-ID: <20200327120942.GI25745@shell.armlinux.org.uk>
References: <1585230682-24417-1-git-send-email-florinel.iordache@nxp.com>
 <1585230682-24417-10-git-send-email-florinel.iordache@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1585230682-24417-10-git-send-email-florinel.iordache@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 03:51:22PM +0200, Florinel Iordache wrote:
> Add dt nodes with serdes, lanes, mdio generic description for supported
> platforms: ls1046, ls1088, ls2088, lx2160. This is a prerequisite to
> enable backplane on device tree for these platforms.
> 
> Signed-off-by: Florinel Iordache <florinel.iordache@nxp.com>
> ---
>  arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi     |  33 ++++-
>  arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi     |  97 ++++++++++++-
>  arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi     | 160 ++++++++++++++++++++-
>  arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi     | 128 ++++++++++++++++-
>  .../boot/dts/freescale/qoriq-fman3-0-10g-0.dtsi    |   5 +-
>  .../boot/dts/freescale/qoriq-fman3-0-10g-1.dtsi    |   5 +-
>  6 files changed, 418 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi
> index d4c1da3..c7d845f 100644
> --- a/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi
> +++ b/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi
> @@ -3,7 +3,7 @@
>   * Device Tree Include file for Freescale Layerscape-1046A family SoC.
>   *
>   * Copyright 2016 Freescale Semiconductor, Inc.
> - * Copyright 2018 NXP
> + * Copyright 2018, 2020 NXP
>   *
>   * Mingkai Hu <mingkai.hu@nxp.com>
>   */
> @@ -735,6 +735,37 @@
>  			status = "disabled";
>  		};
>  
> +		serdes1: serdes@1ea0000 {
> +			compatible = "serdes-10g";
> +			reg = <0x0 0x1ea0000 0 0x00002000>;
> +			reg-names = "serdes", "serdes-10g";
> +			big-endian;
> +
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			ranges = <0x0 0x00 0x1ea0000 0x00002000>;
> +			lane_a: lane@800 {
> +				compatible = "lane-10g";
> +				reg = <0x800 0x40>;
> +				reg-names = "lane", "serdes-lane";
> +			};
> +			lane_b: lane@840 {
> +				compatible = "lane-10g";
> +				reg = <0x840 0x40>;
> +				reg-names = "lane", "serdes-lane";
> +			};
> +			lane_c: lane@880 {
> +				compatible = "lane-10g";
> +				reg = <0x880 0x40>;
> +				reg-names = "lane", "serdes-lane";
> +			};
> +			lane_d: lane@8c0 {
> +				compatible = "lane-10g";
> +				reg = <0x8c0 0x40>;
> +				reg-names = "lane", "serdes-lane";
> +			};
> +		};
> +
>  		pcie_ep@3600000 {
>  			compatible = "fsl,ls1046a-pcie-ep", "fsl,ls-pcie-ep";
>  			reg = <0x00 0x03600000 0x0 0x00100000
> diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi
> index 5945662..474464e 100644
> --- a/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi
> +++ b/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi
> @@ -2,7 +2,7 @@
>  /*
>   * Device Tree Include file for NXP Layerscape-1088A family SoC.
>   *
> - * Copyright 2017 NXP
> + * Copyright 2017, 2020 NXP
>   *
>   * Harninder Rai <harninder.rai@nxp.com>
>   *
> @@ -325,6 +325,69 @@
>  			#interrupt-cells = <2>;
>  		};
>  
> +		/* WRIOP0: 0x8B8_0000, E-MDIO1: 0x1_6000 */
> +		emdio1: mdio@8B96000 {
> +			compatible = "fsl,fman-memac-mdio";
> +			reg = <0x0 0x8B96000 0x0 0x1000>;
> +			device_type = "mdio";
> +			little-endian;	/* force the driver in LE mode */
> +
> +			/* Not necessary on the QDS, but needed on the RDB */
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +		};
> +
> +		/* WRIOP0: 0x8B8_0000, E-MDIO2: 0x1_7000 */
> +		emdio2: mdio@8B97000 {
> +			compatible = "fsl,fman-memac-mdio";
> +			reg = <0x0 0x8B97000 0x0 0x1000>;
> +			device_type = "mdio";
> +			little-endian;	/* force the driver in LE mode */
> +
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +		};
> +
> +		pcs_mdio1: mdio@0x8c07000 {
> +			compatible = "fsl,fman-memac-mdio";
> +			reg = <0x0 0x8c07000 0x0 0x1000>;
> +			device_type = "mdio";
> +			little-endian;
> +
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +		};
> +
> +		pcs_mdio2: mdio@0x8c0b000 {
> +			compatible = "fsl,fman-memac-mdio";
> +			reg = <0x0 0x8c0b000 0x0 0x1000>;
> +			device_type = "mdio";
> +			little-endian;
> +
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +		};
> +
> +		pcs_mdio3: mdio@0x8c0f000 {
> +			compatible = "fsl,fman-memac-mdio";
> +			reg = <0x0 0x8c0f000 0x0 0x1000>;
> +			device_type = "mdio";
> +			little-endian;
> +
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +		};
> +
> +		pcs_mdio4: mdio@0x8c13000 {
> +			compatible = "fsl,fman-memac-mdio";
> +			reg = <0x0 0x8c13000 0x0 0x1000>;
> +			device_type = "mdio";
> +			little-endian;
> +
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +		};
> +
>  		ifc: ifc@2240000 {
>  			compatible = "fsl,ifc", "simple-bus";
>  			reg = <0x0 0x2240000 0x0 0x20000>;
> @@ -777,6 +840,38 @@
>  				};
>  			};
>  		};
> +
> +		serdes1: serdes@1ea0000 {
> +				compatible = "serdes-10g";
> +				reg = <0x0 0x1ea0000 0 0x00002000>;
> +				reg-names = "serdes", "serdes-10g";
> +				little-endian;
> +
> +				#address-cells = <1>;
> +				#size-cells = <1>;
> +				ranges = <0x0 0x00 0x1ea0000 0x00002000>;
> +				lane_a: lane@800 {
> +					compatible = "lane-10g";
> +					reg = <0x800 0x40>;
> +					reg-names = "lane", "serdes-lane";
> +				};
> +				lane_b: lane@840 {
> +					compatible = "lane-10g";
> +					reg = <0x840 0x40>;
> +					reg-names = "lane", "serdes-lane";
> +				};
> +				lane_c: lane@880 {
> +					compatible = "lane-10g";
> +					reg = <0x880 0x40>;
> +					reg-names = "lane", "serdes-lane";
> +				};
> +				lane_d: lane@8c0 {
> +					compatible = "lane-10g";
> +					reg = <0x8c0 0x40>;
> +					reg-names = "lane", "serdes-lane";
> +				};
> +		};
> +
>  	};
>  
>  	firmware {
> diff --git a/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi
> index f96d06d..e8f3026 100644
> --- a/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi
> +++ b/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi
> @@ -3,7 +3,7 @@
>   * Device Tree Include file for Freescale Layerscape-2080A family SoC.
>   *
>   * Copyright 2016 Freescale Semiconductor, Inc.
> - * Copyright 2017 NXP
> + * Copyright 2017, 2020 NXP
>   *
>   * Abhimanyu Saini <abhimanyu.saini@nxp.com>
>   *
> @@ -560,6 +560,113 @@
>  			#interrupt-cells = <2>;
>  		};
>  
> +		/* WRIOP0: 0x8B8_0000, E-MDIO1: 0x1_6000 */
> +		emdio1: mdio@8B96000 {
> +			compatible = "fsl,fman-memac-mdio";
> +			reg = <0x0 0x8B96000 0x0 0x1000>;
> +			device_type = "mdio";
> +			little-endian;	/* force the driver in LE mode */
> +
> +			/* Not necessary on the QDS, but needed on the RDB */
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +		};
> +
> +		/* WRIOP0: 0x8B8_0000, E-MDIO2: 0x1_7000 */
> +		emdio2: mdio@8B97000 {
> +			compatible = "fsl,fman-memac-mdio";
> +			reg = <0x0 0x8B97000 0x0 0x1000>;
> +			device_type = "mdio";
> +			little-endian;	/* force the driver in LE mode */
> +
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +		};
> +
> +		pcs_mdio1: mdio@0x8c07000 {
> +			compatible = "fsl,fman-memac-mdio";
> +			reg = <0x0 0x8c07000 0x0 0x1000>;
> +			device_type = "mdio";
> +			little-endian;
> +
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +		};
> +
> +		pcs_mdio2: mdio@0x8c0b000 {
> +			compatible = "fsl,fman-memac-mdio";
> +			reg = <0x0 0x8c0b000 0x0 0x1000>;
> +			device_type = "mdio";
> +			little-endian;
> +
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +		};
> +
> +		pcs_mdio3: mdio@0x8c0f000 {
> +			compatible = "fsl,fman-memac-mdio";
> +			reg = <0x0 0x8c0f000 0x0 0x1000>;
> +			device_type = "mdio";
> +			little-endian;
> +
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +		};
> +
> +		pcs_mdio4: mdio@0x8c13000 {
> +			compatible = "fsl,fman-memac-mdio";
> +			reg = <0x0 0x8c13000 0x0 0x1000>;
> +			device_type = "mdio";
> +			little-endian;
> +
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +		};
> +
> +		pcs_mdio5: mdio@0x8c17000 {
> +			status = "disabled";
> +			compatible = "fsl,fman-memac-mdio";
> +			reg = <0x0 0x8c17000 0x0 0x1000>;
> +			device_type = "mdio";
> +			little-endian;
> +
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +		};
> +
> +		pcs_mdio6: mdio@0x8c1b000 {
> +			status = "disabled";
> +			compatible = "fsl,fman-memac-mdio";
> +			reg = <0x0 0x8c1b000 0x0 0x1000>;
> +			device_type = "mdio";
> +			little-endian;
> +
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +		};
> +
> +		pcs_mdio7: mdio@0x8c1f000 {
> +			status = "disabled";
> +			compatible = "fsl,fman-memac-mdio";
> +			reg = <0x0 0x8c1f000 0x0 0x1000>;
> +			device_type = "mdio";
> +			little-endian;
> +
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +		};
> +
> +		pcs_mdio8: mdio@0x8c23000 {
> +			status = "disabled";
> +			compatible = "fsl,fman-memac-mdio";
> +			reg = <0x0 0x8c23000 0x0 0x1000>;
> +			device_type = "mdio";
> +			little-endian;
> +
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +		};
> +
>  		i2c0: i2c@2000000 {
>  			status = "disabled";
>  			compatible = "fsl,vf610-i2c";
> @@ -754,6 +861,57 @@
>  			snps,incr-burst-type-adjustment = <1>, <4>, <8>, <16>;
>  		};
>  
> +		serdes1: serdes@1ea0000 {
> +				compatible = "serdes-10g";
> +				reg = <0x0 0x1ea0000 0 0x00002000>;
> +				reg-names = "serdes", "serdes-10g";
> +				little-endian;
> +
> +				#address-cells = <1>;
> +				#size-cells = <1>;
> +				ranges = <0x0 0x00 0x1ea0000 0x00002000>;
> +				lane_a: lane@800 {
> +					compatible = "lane-10g";
> +					reg = <0x800 0x40>;
> +					reg-names = "lane", "serdes-lane";
> +				};
> +				lane_b: lane@840 {
> +					compatible = "lane-10g";
> +					reg = <0x840 0x40>;
> +					reg-names = "lane", "serdes-lane";
> +				};
> +				lane_c: lane@880 {
> +					compatible = "lane-10g";
> +					reg = <0x880 0x40>;
> +					reg-names = "lane", "serdes-lane";
> +				};
> +				lane_d: lane@8c0 {
> +					compatible = "lane-10g";
> +					reg = <0x8c0 0x40>;
> +					reg-names = "lane", "serdes-lane";
> +				};
> +				lane_e: lane@900 {
> +					compatible = "lane-10g";
> +					reg = <0x900 0x40>;
> +					reg-names = "lane", "serdes-lane";
> +				};
> +				lane_f: lane@940 {
> +					compatible = "lane-10g";
> +					reg = <0x940 0x40>;
> +					reg-names = "lane", "serdes-lane";
> +				};
> +				lane_g: lane@980 {
> +					compatible = "lane-10g";
> +					reg = <0x980 0x40>;
> +					reg-names = "lane", "serdes-lane";
> +				};
> +				lane_h: lane@9c0 {
> +					compatible = "lane-10g";
> +					reg = <0x9c0 0x40>;
> +					reg-names = "lane", "serdes-lane";
> +				};
> +		};
> +
>  		ccn@4000000 {
>  			compatible = "arm,ccn-504";
>  			reg = <0x0 0x04000000 0x0 0x01000000>;
> diff --git a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
> index e5ee559..2815908 100644
> --- a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
> +++ b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
> @@ -2,7 +2,7 @@
>  //
>  // Device Tree Include file for Layerscape-LX2160A family SoC.
>  //
> -// Copyright 2018 NXP
> +// Copyright 2018, 2020 NXP
>  
>  #include <dt-bindings/gpio/gpio.h>
>  #include <dt-bindings/interrupt-controller/arm-gic.h>
> @@ -947,9 +947,9 @@
>  			#address-cells = <1>;
>  			#size-cells = <0>;
>  			little-endian;
> -			status = "disabled";
>  		};
>  
> +		/* WRIOP0: 0x8b8_0000, E-MDIO2: 0x1_7000 */
>  		emdio2: mdio@8b97000 {
>  			compatible = "fsl,fman-memac-mdio";
>  			reg = <0x0 0x8b97000 0x0 0x1000>;
> @@ -957,7 +957,129 @@
>  			little-endian;
>  			#address-cells = <1>;
>  			#size-cells = <0>;
> -			status = "disabled";
> +		};
> +
> +		pcs_mdio1: mdio@0x8c07000 {
> +			compatible = "fsl,fman-memac-mdio";
> +			reg = <0x0 0x8c07000 0x0 0x1000>;
> +			device_type = "mdio";
> +			little-endian;
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +		};
> +
> +		pcs_mdio2: mdio@0x8c0b000 {
> +			compatible = "fsl,fman-memac-mdio";
> +			reg = <0x0 0x8c0b000 0x0 0x1000>;
> +			device_type = "mdio";
> +			little-endian;
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +		};
> +
> +		pcs_mdio3: mdio@0x8c0f000 {
> +			compatible = "fsl,fman-memac-mdio";
> +			reg = <0x0 0x8c0f000 0x0 0x1000>;
> +			device_type = "mdio";
> +			little-endian;
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +		};
> +
> +		pcs_mdio4: mdio@0x8c13000 {
> +			compatible = "fsl,fman-memac-mdio";
> +			reg = <0x0 0x8c13000 0x0 0x1000>;
> +			device_type = "mdio";
> +			little-endian;
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +		};
> +
> +		pcs_mdio5: mdio@0x8c17000 {
> +			compatible = "fsl,fman-memac-mdio";
> +			reg = <0x0 0x8c17000 0x0 0x1000>;
> +			device_type = "mdio";
> +			little-endian;
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +		};
> +
> +		pcs_mdio6: mdio@0x8c1b000 {
> +			compatible = "fsl,fman-memac-mdio";
> +			reg = <0x0 0x8c1b000 0x0 0x1000>;
> +			device_type = "mdio";
> +			little-endian;
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +		};
> +
> +		pcs_mdio7: mdio@0x8c1f000 {
> +			compatible = "fsl,fman-memac-mdio";
> +			reg = <0x0 0x8c1f000 0x0 0x1000>;
> +			device_type = "mdio";
> +			little-endian;
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +		};
> +
> +		pcs_mdio8: mdio@0x8c23000 {
> +			compatible = "fsl,fman-memac-mdio";
> +			reg = <0x0 0x8c23000 0x0 0x1000>;
> +			device_type = "mdio";
> +			little-endian;
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +		};

This is a subset of the entries I've posted in my PCS series...

> +
> +		serdes1: serdes@1ea0000 {
> +			compatible = "serdes-28g";
> +			reg = <0x0 0x1ea0000 0 0x00002000>;
> +			reg-names = "serdes", "serdes-28g";
> +			little-endian;
> +
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			ranges = <0x0 0x00 0x1ea0000 0x00002000>;
> +			lane_a: lane@800 {
> +				compatible = "lane-28g";
> +				reg = <0x800 0x100>;
> +				reg-names = "lane", "serdes-lane";
> +			};
> +			lane_b: lane@900 {
> +				compatible = "lane-28g";
> +				reg = <0x900 0x100>;
> +				reg-names = "lane", "serdes-lane";
> +			};
> +			lane_c: lane@a00 {
> +				compatible = "lane-28g";
> +				reg = <0xa00 0x100>;
> +				reg-names = "lane", "serdes-lane";
> +			};
> +			lane_d: lane@b00 {
> +				compatible = "lane-28g";
> +				reg = <0xb00 0x100>;
> +				reg-names = "lane", "serdes-lane";
> +			};
> +			lane_e: lane@c00 {
> +				compatible = "lane-28g";
> +				reg = <0xc00 0x100>;
> +				reg-names = "lane", "serdes-lane";
> +			};
> +			lane_f: lane@d00 {
> +				compatible = "lane-28g";
> +				reg = <0xd00 0x100>;
> +				reg-names = "lane", "serdes-lane";
> +			};
> +			lane_g: lane@e00 {
> +				compatible = "lane-28g";
> +				reg = <0xe00 0x100>;
> +				reg-names = "lane", "serdes-lane";
> +			};
> +			lane_h: lane@f00 {
> +				compatible = "lane-28g";
> +				reg = <0xf00 0x100>;
> +				reg-names = "lane", "serdes-lane";
> +			};
>  		};
>  
>  		fsl_mc: fsl-mc@80c000000 {
> diff --git a/arch/arm64/boot/dts/freescale/qoriq-fman3-0-10g-0.dtsi b/arch/arm64/boot/dts/freescale/qoriq-fman3-0-10g-0.dtsi
> index dbd2fc3..d6191f1 100644
> --- a/arch/arm64/boot/dts/freescale/qoriq-fman3-0-10g-0.dtsi
> +++ b/arch/arm64/boot/dts/freescale/qoriq-fman3-0-10g-0.dtsi
> @@ -3,6 +3,7 @@
>   * QorIQ FMan v3 10g port #0 device tree
>   *
>   * Copyright 2012-2015 Freescale Semiconductor Inc.
> + * Copyright 2020 NXP
>   *
>   */
>  
> @@ -21,7 +22,7 @@ fman@1a00000 {
>  		fsl,fman-10g-port;
>  	};
>  
> -	ethernet@f0000 {
> +	mac9: ethernet@f0000 {
>  		cell-index = <0x8>;
>  		compatible = "fsl,fman-memac";
>  		reg = <0xf0000 0x1000>;
> @@ -29,7 +30,7 @@ fman@1a00000 {
>  		pcsphy-handle = <&pcsphy6>;
>  	};
>  
> -	mdio@f1000 {
> +	mdio9: mdio@f1000 {
>  		#address-cells = <1>;
>  		#size-cells = <0>;
>  		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
> diff --git a/arch/arm64/boot/dts/freescale/qoriq-fman3-0-10g-1.dtsi b/arch/arm64/boot/dts/freescale/qoriq-fman3-0-10g-1.dtsi
> index 6fc5d25..1f6f28f 100644
> --- a/arch/arm64/boot/dts/freescale/qoriq-fman3-0-10g-1.dtsi
> +++ b/arch/arm64/boot/dts/freescale/qoriq-fman3-0-10g-1.dtsi
> @@ -3,6 +3,7 @@
>   * QorIQ FMan v3 10g port #1 device tree
>   *
>   * Copyright 2012-2015 Freescale Semiconductor Inc.
> + * Copyright 2020 NXP
>   *
>   */
>  
> @@ -21,7 +22,7 @@ fman@1a00000 {
>  		fsl,fman-10g-port;
>  	};
>  
> -	ethernet@f2000 {
> +	mac10: ethernet@f2000 {
>  		cell-index = <0x9>;
>  		compatible = "fsl,fman-memac";
>  		reg = <0xf2000 0x1000>;
> @@ -29,7 +30,7 @@ fman@1a00000 {
>  		pcsphy-handle = <&pcsphy7>;
>  	};
>  
> -	mdio@f3000 {
> +	mdio10: mdio@f3000 {
>  		#address-cells = <1>;
>  		#size-cells = <0>;
>  		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
> -- 
> 1.9.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
