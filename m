Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D720B641E2E
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 18:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbiLDRNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 12:13:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiLDRNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 12:13:31 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29CBE13E09;
        Sun,  4 Dec 2022 09:13:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=KuXgiHWxXZUsTH5LC0nqqf6lWB05XEwKQdJWjN9l0aE=; b=01Zvyu0opAZprNMzXd28lPpPb6
        rml345uNedgB3CtR776nkGLvism+OpblBXVEIOwcwb0IDcTxH1NCOQxaQ8PWfF+zuzu+MhVcmbbZ2
        wPiXn3JmQIJbh+EkfuwCnqoaOmhlwsgD+VX+XYFqFk10lf+jcS4u0PptAHVMVU2eqXegLNPAohGdH
        7NbNVIVzasb8KSc/GxOjVTXcs4m2jpWr5v5Xju69jfZGsY7Wi9HP6oEF9/2HQYkIJco8L5sLm97t9
        8vMrfCBVA254tXWxiBJt6LcZ3ENEyGTLo6Aj0tU2GEgRQ9NiLBhxNshL4mY1Riw90RyBnVvYwnLS2
        3r9ZCmng==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35566)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p1sYN-0005wD-Vw; Sun, 04 Dec 2022 17:13:24 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p1sYM-0006Rl-RT; Sun, 04 Dec 2022 17:13:22 +0000
Date:   Sun, 4 Dec 2022 17:13:22 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH net-next 1/2] ethtool: update UAPI files
Message-ID: <Y4zVMj7rOkyA12uA@shell.armlinux.org.uk>
References: <cover.1670121214.git.piergiorgio.beruto@gmail.com>
 <0f7042bc6bcd59b37969d10a40e65d705940bee0.1670121214.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0f7042bc6bcd59b37969d10a40e65d705940bee0.1670121214.git.piergiorgio.beruto@gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 04, 2022 at 03:38:37AM +0100, Piergiorgio Beruto wrote:

NAK. No description of changes.

> Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
> ---
>  uapi/linux/ethtool.h         | 104 +++++++++++++++++++++++++++++------
>  uapi/linux/ethtool_netlink.h |  49 ++++++++++++++++-
>  uapi/linux/genetlink.h       |   6 +-
>  uapi/linux/if_link.h         |  23 +++++++-
>  uapi/linux/netlink.h         |  41 ++++++++++----
>  uapi/linux/rtnetlink.h       |   8 ++-
>  6 files changed, 192 insertions(+), 39 deletions(-)
> 
> diff --git a/uapi/linux/ethtool.h b/uapi/linux/ethtool.h
> index 944711cfa6f6..5f414deacf23 100644
> --- a/uapi/linux/ethtool.h
> +++ b/uapi/linux/ethtool.h
> @@ -11,14 +11,16 @@
>   * Portions Copyright (C) Sun Microsystems 2008
>   */
>  
> -#ifndef _LINUX_ETHTOOL_H
> -#define _LINUX_ETHTOOL_H
> +#ifndef _UAPI_LINUX_ETHTOOL_H
> +#define _UAPI_LINUX_ETHTOOL_H
>  
>  #include <linux/const.h>
>  #include <linux/types.h>
>  #include <linux/if_ether.h>
>  
> +#ifndef __KERNEL__
>  #include <limits.h> /* for INT_MAX */
> +#endif
>  
>  /* All structures exposed to userland should be defined such that they
>   * have the same layout for 32-bit and 64-bit userland.
> @@ -120,14 +122,14 @@ struct ethtool_cmd {
>  	__u32	reserved[2];
>  };
>  
> -static __inline__ void ethtool_cmd_speed_set(struct ethtool_cmd *ep,
> +static inline void ethtool_cmd_speed_set(struct ethtool_cmd *ep,
>  					 __u32 speed)

NAK. This looks like a gratuitous change. __inline__ is used in kernel
header files to make things inline irrespective of userspace, making
this change will cause warnings and regressions.

>  {
>  	ep->speed = (__u16)(speed & 0xFFFF);
>  	ep->speed_hi = (__u16)(speed >> 16);
>  }
>  
> -static __inline__ __u32 ethtool_cmd_speed(const struct ethtool_cmd *ep)
> +static inline __u32 ethtool_cmd_speed(const struct ethtool_cmd *ep)
>  {
>  	return (ep->speed_hi << 16) | ep->speed;
>  }
> @@ -157,8 +159,10 @@ static __inline__ __u32 ethtool_cmd_speed(const struct ethtool_cmd *ep)
>   *	in its bus driver structure (e.g. pci_driver::name).  Must
>   *	not be an empty string.
>   * @version: Driver version string; may be an empty string
> - * @fw_version: Firmware version string; may be an empty string
> - * @erom_version: Expansion ROM version string; may be an empty string
> + * @fw_version: Firmware version string; driver defined; may be an
> + *	empty string
> + * @erom_version: Expansion ROM version string; driver defined; may be
> + *	an empty string
>   * @bus_info: Device bus address.  This should match the dev_name()
>   *	string for the underlying bus device, if there is one.  May be
>   *	an empty string.
> @@ -177,10 +181,6 @@ static __inline__ __u32 ethtool_cmd_speed(const struct ethtool_cmd *ep)
>   *
>   * Users can use the %ETHTOOL_GSSET_INFO command to get the number of
>   * strings in any string set (from Linux 2.6.34).
> - *
> - * Drivers should set at most @driver, @version, @fw_version and
> - * @bus_info in their get_drvinfo() implementation.  The ethtool
> - * core fills in the other fields using other driver operations.

Why are you deleting this comment (a commit description would be
useful.)

>   */
>  struct ethtool_drvinfo {
>  	__u32	cmd;
> @@ -734,6 +734,51 @@ enum ethtool_module_power_mode {
>  	ETHTOOL_MODULE_POWER_MODE_HIGH,
>  };
>  
> +/**
> + * enum ethtool_podl_pse_admin_state - operational state of the PoDL PSE
> + *	functions. IEEE 802.3-2018 30.15.1.1.2 aPoDLPSEAdminState
> + * @ETHTOOL_PODL_PSE_ADMIN_STATE_UNKNOWN: state of PoDL PSE functions are
> + * 	unknown
> + * @ETHTOOL_PODL_PSE_ADMIN_STATE_DISABLED: PoDL PSE functions are disabled
> + * @ETHTOOL_PODL_PSE_ADMIN_STATE_ENABLED: PoDL PSE functions are enabled
> + */
> +enum ethtool_podl_pse_admin_state {
> +	ETHTOOL_PODL_PSE_ADMIN_STATE_UNKNOWN = 1,
> +	ETHTOOL_PODL_PSE_ADMIN_STATE_DISABLED,
> +	ETHTOOL_PODL_PSE_ADMIN_STATE_ENABLED,
> +};
> +
> +/**
> + * enum ethtool_podl_pse_pw_d_status - power detection status of the PoDL PSE.
> + *	IEEE 802.3-2018 30.15.1.1.3 aPoDLPSEPowerDetectionStatus:
> + * @ETHTOOL_PODL_PSE_PW_D_STATUS_UNKNOWN: PoDL PSE
> + * @ETHTOOL_PODL_PSE_PW_D_STATUS_DISABLED: "The enumeration “disabled” is
> + *	asserted true when the PoDL PSE state diagram variable mr_pse_enable is
> + *	false"
> + * @ETHTOOL_PODL_PSE_PW_D_STATUS_SEARCHING: "The enumeration “searching” is
> + *	asserted true when either of the PSE state diagram variables
> + *	pi_detecting or pi_classifying is true."
> + * @ETHTOOL_PODL_PSE_PW_D_STATUS_DELIVERING: "The enumeration “deliveringPower”
> + *	is asserted true when the PoDL PSE state diagram variable pi_powered is
> + *	true."
> + * @ETHTOOL_PODL_PSE_PW_D_STATUS_SLEEP: "The enumeration “sleep” is asserted
> + *	true when the PoDL PSE state diagram variable pi_sleeping is true."
> + * @ETHTOOL_PODL_PSE_PW_D_STATUS_IDLE: "The enumeration “idle” is asserted true
> + *	when the logical combination of the PoDL PSE state diagram variables
> + *	pi_prebiased*!pi_sleeping is true."
> + * @ETHTOOL_PODL_PSE_PW_D_STATUS_ERROR: "The enumeration “error” is asserted
> + *	true when the PoDL PSE state diagram variable overload_held is true."
> + */
> +enum ethtool_podl_pse_pw_d_status {
> +	ETHTOOL_PODL_PSE_PW_D_STATUS_UNKNOWN = 1,
> +	ETHTOOL_PODL_PSE_PW_D_STATUS_DISABLED,
> +	ETHTOOL_PODL_PSE_PW_D_STATUS_SEARCHING,
> +	ETHTOOL_PODL_PSE_PW_D_STATUS_DELIVERING,
> +	ETHTOOL_PODL_PSE_PW_D_STATUS_SLEEP,
> +	ETHTOOL_PODL_PSE_PW_D_STATUS_IDLE,
> +	ETHTOOL_PODL_PSE_PW_D_STATUS_ERROR,
> +};
> +
>  /**
>   * struct ethtool_gstrings - string set for data tagging
>   * @cmd: Command number = %ETHTOOL_GSTRINGS
> @@ -1057,12 +1102,12 @@ struct ethtool_rx_flow_spec {
>  #define ETHTOOL_RX_FLOW_SPEC_RING	0x00000000FFFFFFFFLL
>  #define ETHTOOL_RX_FLOW_SPEC_RING_VF	0x000000FF00000000LL
>  #define ETHTOOL_RX_FLOW_SPEC_RING_VF_OFF 32
> -static __inline__ __u64 ethtool_get_flow_spec_ring(__u64 ring_cookie)
> +static inline __u64 ethtool_get_flow_spec_ring(__u64 ring_cookie)
>  {
>  	return ETHTOOL_RX_FLOW_SPEC_RING & ring_cookie;
>  }
>  
> -static __inline__ __u64 ethtool_get_flow_spec_ring_vf(__u64 ring_cookie)
> +static inline __u64 ethtool_get_flow_spec_ring_vf(__u64 ring_cookie)
>  {
>  	return (ETHTOOL_RX_FLOW_SPEC_RING_VF & ring_cookie) >>
>  				ETHTOOL_RX_FLOW_SPEC_RING_VF_OFF;
> @@ -1690,6 +1735,16 @@ enum ethtool_link_mode_bit_indices {
>  	ETHTOOL_LINK_MODE_100baseFX_Half_BIT		 = 90,
>  	ETHTOOL_LINK_MODE_100baseFX_Full_BIT		 = 91,
>  	ETHTOOL_LINK_MODE_10baseT1L_Full_BIT		 = 92,
> +	ETHTOOL_LINK_MODE_800000baseCR8_Full_BIT	 = 93,
> +	ETHTOOL_LINK_MODE_800000baseKR8_Full_BIT	 = 94,
> +	ETHTOOL_LINK_MODE_800000baseDR8_Full_BIT	 = 95,
> +	ETHTOOL_LINK_MODE_800000baseDR8_2_Full_BIT	 = 96,
> +	ETHTOOL_LINK_MODE_800000baseSR8_Full_BIT	 = 97,
> +	ETHTOOL_LINK_MODE_800000baseVR8_Full_BIT	 = 98,
> +	ETHTOOL_LINK_MODE_10baseT1S_Full_BIT		 = 99,
> +	ETHTOOL_LINK_MODE_10baseT1S_Half_BIT		 = 100,
> +	ETHTOOL_LINK_MODE_10baseT1S_P2MP_Half_BIT	 = 101,
> +
>  	/* must be last entry */
>  	__ETHTOOL_LINK_MODE_MASK_NBITS
>  };
> @@ -1801,10 +1856,11 @@ enum ethtool_link_mode_bit_indices {
>  #define SPEED_100000		100000
>  #define SPEED_200000		200000
>  #define SPEED_400000		400000
> +#define SPEED_800000		800000
>  
>  #define SPEED_UNKNOWN		-1
>  
> -static __inline__ int ethtool_validate_speed(__u32 speed)
> +static inline int ethtool_validate_speed(__u32 speed)
>  {
>  	return speed <= INT_MAX || speed == (__u32)SPEED_UNKNOWN;
>  }
> @@ -1814,7 +1870,7 @@ static __inline__ int ethtool_validate_speed(__u32 speed)
>  #define DUPLEX_FULL		0x01
>  #define DUPLEX_UNKNOWN		0xff
>  
> -static __inline__ int ethtool_validate_duplex(__u8 duplex)
> +static inline int ethtool_validate_duplex(__u8 duplex)
>  {
>  	switch (duplex) {
>  	case DUPLEX_HALF:
> @@ -1838,6 +1894,20 @@ static __inline__ int ethtool_validate_duplex(__u8 duplex)
>  #define MASTER_SLAVE_STATE_SLAVE		3
>  #define MASTER_SLAVE_STATE_ERR			4
>  
> +/* These are used to throttle the rate of data on the phy interface when the
> + * native speed of the interface is higher than the link speed. These should
> + * not be used for phy interfaces which natively support multiple speeds (e.g.
> + * MII or SGMII).
> + */
> +/* No rate matching performed. */
> +#define RATE_MATCH_NONE		0
> +/* The phy sends pause frames to throttle the MAC. */
> +#define RATE_MATCH_PAUSE	1
> +/* The phy asserts CRS to prevent the MAC from transmitting. */
> +#define RATE_MATCH_CRS		2
> +/* The MAC is programmed with a sufficiently-large IPG. */
> +#define RATE_MATCH_OPEN_LOOP	3
> +

This looks like it comes from another patch set submitted by other
people. Is this a badly generated patch?

>  /* Which connector port. */
>  #define PORT_TP			0x00
>  #define PORT_AUI		0x01
> @@ -2031,8 +2101,8 @@ enum ethtool_reset_flags {
>   *	reported consistently by PHYLIB.  Read-only.
>   * @master_slave_cfg: Master/slave port mode.
>   * @master_slave_state: Master/slave port state.
> + * @rate_matching: Rate adaptation performed by the PHY
>   * @reserved: Reserved for future use; see the note on reserved space.
> - * @reserved1: Reserved for future use; see the note on reserved space.
>   * @link_mode_masks: Variable length bitmaps.
>   *
>   * If autonegotiation is disabled, the speed and @duplex represent the
> @@ -2083,7 +2153,7 @@ struct ethtool_link_settings {
>  	__u8	transceiver;
>  	__u8	master_slave_cfg;
>  	__u8	master_slave_state;
> -	__u8	reserved1[1];
> +	__u8	rate_matching;
>  	__u32	reserved[7];
>  	__u32	link_mode_masks[];
>  	/* layout of link_mode_masks fields:
> @@ -2092,4 +2162,4 @@ struct ethtool_link_settings {
>  	 * __u32 map_lp_advertising[link_mode_masks_nwords];
>  	 */
>  };
> -#endif /* _LINUX_ETHTOOL_H */
> +#endif /* _UAPI_LINUX_ETHTOOL_H */
> diff --git a/uapi/linux/ethtool_netlink.h b/uapi/linux/ethtool_netlink.h
> index 378ad7da74f4..81e3d7b42d0f 100644
> --- a/uapi/linux/ethtool_netlink.h
> +++ b/uapi/linux/ethtool_netlink.h
> @@ -6,8 +6,8 @@
>   * doucumentation of the interface.
>   */
>  
> -#ifndef _LINUX_ETHTOOL_NETLINK_H_
> -#define _LINUX_ETHTOOL_NETLINK_H_
> +#ifndef _UAPI_LINUX_ETHTOOL_NETLINK_H_
> +#define _UAPI_LINUX_ETHTOOL_NETLINK_H_
>  
>  #include <linux/ethtool.h>
>  
> @@ -49,6 +49,11 @@ enum {
>  	ETHTOOL_MSG_PHC_VCLOCKS_GET,
>  	ETHTOOL_MSG_MODULE_GET,
>  	ETHTOOL_MSG_MODULE_SET,
> +	ETHTOOL_MSG_PSE_GET,
> +	ETHTOOL_MSG_PSE_SET,
> +	ETHTOOL_MSG_PLCA_GET_CFG,
> +	ETHTOOL_MSG_PLCA_SET_CFG,
> +	ETHTOOL_MSG_PLCA_GET_STATUS,
>  
>  	/* add new constants above here */
>  	__ETHTOOL_MSG_USER_CNT,
> @@ -94,6 +99,10 @@ enum {
>  	ETHTOOL_MSG_PHC_VCLOCKS_GET_REPLY,
>  	ETHTOOL_MSG_MODULE_GET_REPLY,
>  	ETHTOOL_MSG_MODULE_NTF,
> +	ETHTOOL_MSG_PSE_GET_REPLY,
> +	ETHTOOL_MSG_PLCA_GET_CFG_REPLY,
> +	ETHTOOL_MSG_PLCA_GET_STATUS_REPLY,
> +	ETHTOOL_MSG_PLCA_NTF,
>  
>  	/* add new constants above here */
>  	__ETHTOOL_MSG_KERNEL_CNT,
> @@ -242,6 +251,7 @@ enum {
>  	ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG,	/* u8 */
>  	ETHTOOL_A_LINKMODES_MASTER_SLAVE_STATE,	/* u8 */
>  	ETHTOOL_A_LINKMODES_LANES,		/* u32 */
> +	ETHTOOL_A_LINKMODES_RATE_MATCHING,	/* u8 */
>  
>  	/* add new constants above here */
>  	__ETHTOOL_A_LINKMODES_CNT,
> @@ -258,6 +268,7 @@ enum {
>  	ETHTOOL_A_LINKSTATE_SQI_MAX,		/* u32 */
>  	ETHTOOL_A_LINKSTATE_EXT_STATE,		/* u8 */
>  	ETHTOOL_A_LINKSTATE_EXT_SUBSTATE,	/* u8 */
> +	ETHTOOL_A_LINKSTATE_EXT_DOWN_CNT,	/* u32 */
>  
>  	/* add new constants above here */
>  	__ETHTOOL_A_LINKSTATE_CNT,
> @@ -862,10 +873,42 @@ enum {
>  	ETHTOOL_A_MODULE_MAX = (__ETHTOOL_A_MODULE_CNT - 1)
>  };
>  
> +/* Power Sourcing Equipment */
> +enum {
> +	ETHTOOL_A_PSE_UNSPEC,
> +	ETHTOOL_A_PSE_HEADER,			/* nest - _A_HEADER_* */
> +	ETHTOOL_A_PODL_PSE_ADMIN_STATE,		/* u32 */
> +	ETHTOOL_A_PODL_PSE_ADMIN_CONTROL,	/* u32 */
> +	ETHTOOL_A_PODL_PSE_PW_D_STATUS,		/* u32 */
> +
> +	/* add new constants above here */
> +	__ETHTOOL_A_PSE_CNT,
> +	ETHTOOL_A_PSE_MAX = (__ETHTOOL_A_PSE_CNT - 1)
> +};
> +
> +/* PLCA */
> +
> +enum {
> +	ETHTOOL_A_PLCA_UNSPEC,
> +	ETHTOOL_A_PLCA_HEADER,				/* nest - _A_HEADER_* */
> +	ETHTOOL_A_PLCA_VERSION,				/* u16 */
> +	ETHTOOL_A_PLCA_ENABLED,				/* u8 */
> +	ETHTOOL_A_PLCA_STATUS,				/* u8 */
> +	ETHTOOL_A_PLCA_NODE_CNT,			/* u8 */
> +	ETHTOOL_A_PLCA_NODE_ID,				/* u8 */
> +	ETHTOOL_A_PLCA_TO_TMR,				/* u8 */
> +	ETHTOOL_A_PLCA_BURST_CNT,			/* u8 */
> +	ETHTOOL_A_PLCA_BURST_TMR,			/* u8 */

These types appear to disagree with the struct.

> +
> +	/* add new constants above here */
> +	__ETHTOOL_A_PLCA_CNT,
> +	ETHTOOL_A_PLCA_MAX = (__ETHTOOL_A_PLCA_CNT - 1)
> +};
> +
>  /* generic netlink info */
>  #define ETHTOOL_GENL_NAME "ethtool"
>  #define ETHTOOL_GENL_VERSION 1
>  
>  #define ETHTOOL_MCGRP_MONITOR_NAME "monitor"
>  
> -#endif /* _LINUX_ETHTOOL_NETLINK_H_ */
> +#endif /* _UAPI_LINUX_ETHTOOL_NETLINK_H_ */
> diff --git a/uapi/linux/genetlink.h b/uapi/linux/genetlink.h
> index e9b8117bdcf9..ddba3ca01e39 100644
> --- a/uapi/linux/genetlink.h
> +++ b/uapi/linux/genetlink.h
> @@ -1,6 +1,6 @@
>  /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> -#ifndef __LINUX_GENERIC_NETLINK_H
> -#define __LINUX_GENERIC_NETLINK_H
> +#ifndef _UAPI__LINUX_GENERIC_NETLINK_H
> +#define _UAPI__LINUX_GENERIC_NETLINK_H
>  
>  #include <linux/types.h>
>  #include <linux/netlink.h>
> @@ -100,4 +100,4 @@ enum {
>  
>  #define CTRL_ATTR_POLICY_MAX (__CTRL_ATTR_POLICY_DUMP_MAX - 1)
>  
> -#endif /* __LINUX_GENERIC_NETLINK_H */
> +#endif /* _UAPI__LINUX_GENERIC_NETLINK_H */
> diff --git a/uapi/linux/if_link.h b/uapi/linux/if_link.h
> index e0fbbfeeb3a1..1021a7e47a86 100644
> --- a/uapi/linux/if_link.h
> +++ b/uapi/linux/if_link.h
> @@ -1,6 +1,6 @@
>  /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> -#ifndef _LINUX_IF_LINK_H
> -#define _LINUX_IF_LINK_H
> +#ifndef _UAPI_LINUX_IF_LINK_H
> +#define _UAPI_LINUX_IF_LINK_H
>  
>  #include <linux/types.h>
>  #include <linux/netlink.h>
> @@ -370,6 +370,9 @@ enum {
>  	IFLA_GRO_MAX_SIZE,
>  	IFLA_TSO_MAX_SIZE,
>  	IFLA_TSO_MAX_SEGS,
> +	IFLA_ALLMULTI,		/* Allmulti count: > 0 means acts ALLMULTI */
> +
> +	IFLA_DEVLINK_PORT,
>  
>  	__IFLA_MAX
>  };
> @@ -387,8 +390,10 @@ enum {
>  };
>  
>  /* backwards compatibility for userspace */
> +#ifndef __KERNEL__
>  #define IFLA_RTA(r)  ((struct rtattr*)(((char*)(r)) + NLMSG_ALIGN(sizeof(struct ifinfomsg))))
>  #define IFLA_PAYLOAD(n) NLMSG_PAYLOAD(n,sizeof(struct ifinfomsg))
> +#endif
>  
>  enum {
>  	IFLA_INET_UNSPEC,
> @@ -558,6 +563,7 @@ enum {
>  	IFLA_BRPORT_MCAST_EHT_HOSTS_LIMIT,
>  	IFLA_BRPORT_MCAST_EHT_HOSTS_CNT,
>  	IFLA_BRPORT_LOCKED,
> +	IFLA_BRPORT_MAB,
>  	__IFLA_BRPORT_MAX
>  };
>  #define IFLA_BRPORT_MAX (__IFLA_BRPORT_MAX - 1)
> @@ -692,6 +698,7 @@ enum {
>  	IFLA_XFRM_UNSPEC,
>  	IFLA_XFRM_LINK,
>  	IFLA_XFRM_IF_ID,
> +	IFLA_XFRM_COLLECT_METADATA,
>  	__IFLA_XFRM_MAX
>  };
>  
> @@ -1372,4 +1379,14 @@ enum {
>  
>  #define IFLA_MCTP_MAX (__IFLA_MCTP_MAX - 1)
>  
> -#endif /* _LINUX_IF_LINK_H */
> +/* DSA section */
> +
> +enum {
> +	IFLA_DSA_UNSPEC,
> +	IFLA_DSA_MASTER,
> +	__IFLA_DSA_MAX,
> +};
> +
> +#define IFLA_DSA_MAX	(__IFLA_DSA_MAX - 1)
> +
> +#endif /* _UAPI_LINUX_IF_LINK_H */
> diff --git a/uapi/linux/netlink.h b/uapi/linux/netlink.h
> index 105b79f05744..e2ae82e3f9f7 100644
> --- a/uapi/linux/netlink.h
> +++ b/uapi/linux/netlink.h
> @@ -1,6 +1,6 @@
>  /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> -#ifndef __LINUX_NETLINK_H
> -#define __LINUX_NETLINK_H
> +#ifndef _UAPI__LINUX_NETLINK_H
> +#define _UAPI__LINUX_NETLINK_H
>  
>  #include <linux/const.h>
>  #include <linux/socket.h> /* for __kernel_sa_family_t */
> @@ -20,7 +20,7 @@
>  #define NETLINK_CONNECTOR	11
>  #define NETLINK_NETFILTER	12	/* netfilter subsystem */
>  #define NETLINK_IP6_FW		13
> -#define NETLINK_DNRTMSG		14	/* DECnet routing messages */
> +#define NETLINK_DNRTMSG		14	/* DECnet routing messages (obsolete) */

More random changes.

>  #define NETLINK_KOBJECT_UEVENT	15	/* Kernel messages to userspace */
>  #define NETLINK_GENERIC		16
>  /* leave room for NETLINK_DM (DM Events) */
> @@ -41,12 +41,20 @@ struct sockaddr_nl {
>         	__u32		nl_groups;	/* multicast groups mask */
>  };
>  
> +/**
> + * struct nlmsghdr - fixed format metadata header of Netlink messages
> + * @nlmsg_len:   Length of message including header
> + * @nlmsg_type:  Message content type
> + * @nlmsg_flags: Additional flags
> + * @nlmsg_seq:   Sequence number
> + * @nlmsg_pid:   Sending process port ID
> + */
>  struct nlmsghdr {
> -	__u32		nlmsg_len;	/* Length of message including header */
> -	__u16		nlmsg_type;	/* Message content */
> -	__u16		nlmsg_flags;	/* Additional flags */
> -	__u32		nlmsg_seq;	/* Sequence number */
> -	__u32		nlmsg_pid;	/* Sending process port ID */
> +	__u32		nlmsg_len;
> +	__u16		nlmsg_type;
> +	__u16		nlmsg_flags;
> +	__u32		nlmsg_seq;
> +	__u32		nlmsg_pid;

This should be a seperate patch.

I think I'm going to stop reviewing here - you need to do a better job
of grouping your changes into logical patches and writing a proper
commit description for each one.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
