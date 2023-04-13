Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAB7E6E0FB4
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 16:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbjDMOMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 10:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbjDMOMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 10:12:15 -0400
X-Greylist: delayed 61 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 13 Apr 2023 07:12:13 PDT
Received: from h1.cmg1.smtp.forpsi.com (h1.cmg1.smtp.forpsi.com [81.2.195.162])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15DBF106
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 07:12:13 -0700 (PDT)
Received: from lenoch ([91.218.190.200])
        by cmgsmtp with ESMTPSA
        id mxfHpEhAtPm6CmxfIpKcR6; Thu, 13 Apr 2023 16:11:10 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=triops.cz; s=f2019;
        t=1681395070; bh=/xxAYZbH9E6YSxbjqKxa1nq30Q75rv6dW1p88SKzXDE=;
        h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
        b=cXmWmb+Y1dl4TDG2tFVlZ3TUstovGRGNCnSrane8URthWm6wanRkHK81pX8C7zgnJ
         r0a+skLXaJ7ADSV5ZKT+xrAyJ2uNGBQEVCeCWaVhY3ll/lxQIzWmfPLjizabm9DnZK
         lEY8tUbwRrZoC3IzsUp9BMC5/cZOYv1HCCh0zhBPZ1D4TURmMtKEqUUuBc5HSrXiz3
         I90T85vcVdTd2j4ZHhRlGzX7GvNjaESrYVol6BCvBwlFkaQZntQn5tyIYdvqErAoj3
         MMsrlBWQXsPct3PMLO+33+1I8Of/DqZqmz55hNJDaqmQtsbpU8ECIrIVCWX9k5p0qG
         C+UmGvJfSalHA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=triops.cz; s=f2019;
        t=1681395070; bh=/xxAYZbH9E6YSxbjqKxa1nq30Q75rv6dW1p88SKzXDE=;
        h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
        b=cXmWmb+Y1dl4TDG2tFVlZ3TUstovGRGNCnSrane8URthWm6wanRkHK81pX8C7zgnJ
         r0a+skLXaJ7ADSV5ZKT+xrAyJ2uNGBQEVCeCWaVhY3ll/lxQIzWmfPLjizabm9DnZK
         lEY8tUbwRrZoC3IzsUp9BMC5/cZOYv1HCCh0zhBPZ1D4TURmMtKEqUUuBc5HSrXiz3
         I90T85vcVdTd2j4ZHhRlGzX7GvNjaESrYVol6BCvBwlFkaQZntQn5tyIYdvqErAoj3
         MMsrlBWQXsPct3PMLO+33+1I8Of/DqZqmz55hNJDaqmQtsbpU8ECIrIVCWX9k5p0qG
         C+UmGvJfSalHA==
Date:   Thu, 13 Apr 2023 16:11:07 +0200
From:   Ladislav Michl <oss-lists@triops.cz>
To:     linux-staging@lists.linux.dev
Cc:     netdev@vger.kernel.org, linux-mips@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH 0/3] staging: octeon: Convert to use phylink
Message-ID: <ZDgNexVTEfyGo77d@lenoch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfL8Nmxz6tRftiRMLG59T7itoGSQnmDDLU8K/vA/DTd7k6nblm+j8rzfHeSbnDrv1J8eW6FqPzW/4yNXdY6gCPGcKpzAhQ5L5TPBwdRZQBWgTxluc1rJx
 UrtQ72tjptssgKuspgdSTac9lWSQsfg3sZDnY6HQ8G4uqXg2LkGX37Y8zDbc4v5DTWmtKzC/3j4zesQhoyq9zX/RMRoPvydDT83AE5OjU4GUZN0koaW3qSAJ
 6FC7JAIzwVAuYZf46InIbWCwll7yZoHOz/HX5fLi5fBjQCnGpeDcJlG+iH258b6J
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The purpose of this patches is to provide support for SFP cage to
Octeon ethernet driver. This is tested with following DT snippet:

	smi0: mdio@1180000001800 {
		compatible = "cavium,octeon-3860-mdio";
		#address-cells = <1>;
		#size-cells = <0>;
		reg = <0x11800 0x00001800 0x0 0x40>;

		/* QSGMII PHY */
		phy0: ethernet-phy@0 {
			compatible = "marvell,88e154", "ethernet-phy-ieee802.3-c22";
			reg = <0>;
			interrupt-parent = <&gpio>;
			interrupts = <6 IRQ_TYPE_LEVEL_LOW>;
			marvell,reg-init =
			  <0xff 24 0 0x2800>, <0xff 23 0 0x2001>, /* errata 3.1.1 - PHY Initialization #1 */
			  <0 29 0 3>, <0 30 0 2>, <0 29 0 0>,	  /* errata 3.1.2 - PHY Initialization #2 */
			  <4 26 0 0x2>, 			  /* prekrizeni RX a TX QSGMII sbernice */
			  <4 0 0x1000 0x1000>, 			  /* Q_ANEG workaround: P4R0B12 = 1 */
			  <3 16 0 0x1117>;			  /* nastavení LED: G=link+act, Y=1Gbit */
		};
		phy1: ethernet-phy@1 {
			compatible = "marvell,88e154", "ethernet-phy-ieee802.3-c22";
			reg = <1>;
			interrupt-parent = <&gpio>;
			interrupts = <6 IRQ_TYPE_LEVEL_LOW>;
			marvell,reg-init =
			  <4 0 0x1000 0x1000>,			  /* Q_ANEG workaround: P4R0B12 = 1 */
			  <3 16 0 0x1117>;			  /* nastavení LED: G=link+act, Y=1Gbit */
		};
		phy2: ethernet-phy@2 {
			compatible = "marvell,88e154", "ethernet-phy-ieee802.3-c22";
			reg = <2>;
			interrupt-parent = <&gpio>;
			interrupts = <6 IRQ_TYPE_LEVEL_LOW>;
			marvell,reg-init =
			  <4 0 0x1000 0x1000>,			  /* Q_ANEG workaround: P4R0B12 = 1 */
			  <3 16 0 0x1117>;			  /* nastavení LED: G=link+act, Y=1Gbit */
		};
		phy3: ethernet-phy@3 {
			compatible = "marvell,88e154", "ethernet-phy-ieee802.3-c22";
			reg = <3>;
			interrupt-parent = <&gpio>;
			interrupts = <6 IRQ_TYPE_LEVEL_LOW>;
			marvell,reg-init =
			  <4 0 0x1000 0x1000>,			  /* Q_ANEG workaround: P4R0B12 = 1 */
			  <3 16 0 0x1117>;			  /* nastavení LED: G=link+act, Y=1Gbit */
		};
	};

	pip: pip@11800a0000000 {
		compatible = "cavium,octeon-3860-pip";
		#address-cells = <1>;
		#size-cells = <0>;
		reg = <0x11800 0xa0000000 0x0 0x2000>;

		/* Interface 0 goes to SFP */
		interface@0 {
			compatible = "cavium,octeon-3860-pip-interface";
			#address-cells = <1>;
			#size-cells = <0>;
			reg = <0>; /* interface */

			ethernet@0 {
				compatible = "cavium,octeon-3860-pip-port";
				reg = <0>; /* Port */
				local-mac-address = [ 00 00 00 00 00 00 ];
				managed = "in-band-status";
				phy-connection-type = "1000base-x";
				sfp = <&sfp>;
			};
		};
		/* Interface 1 goes to eth1-eth4 and is QSGMII */
		interface@1 {
			compatible = "cavium,octeon-3860-pip-interface";
			#address-cells = <1>;
			#size-cells = <0>;
			reg = <1>; /* interface */

			ethernet@0 {
				compatible = "cavium,octeon-3860-pip-port";
				reg = <0>; /* Port */
				local-mac-address = [ 00 00 00 00 00 00 ];
				phy-handle = <&phy0>;
			};
			ethernet@1 {
				compatible = "cavium,octeon-3860-pip-port";
				reg = <1>; /* Port */
				local-mac-address = [ 00 00 00 00 00 00 ];
				phy-handle = <&phy1>;
			};
			ethernet@2 {
				compatible = "cavium,octeon-3860-pip-port";
				reg = <2>; /* Port */
				local-mac-address = [ 00 00 00 00 00 00 ];
				phy-handle = <&phy2>;
			};
			ethernet@3 {
				compatible = "cavium,octeon-3860-pip-port";
				reg = <3>; /* Port */
				local-mac-address = [ 00 00 00 00 00 00 ];
				phy-handle = <&phy3>;
			};
		};
	};

However testing revealed some glitches:
1. driver previously returned -EPROBE_DEFER when no phy was attached.
Phylink stack does not seem to do so, which end up with:

Marvell PHY driver as a module:
octeon_ethernet 11800a0000000.pip eth0: configuring for inband/1000base-x link mode
octeon_ethernet 11800a0000000.pip eth1: PHY [8001180000001800:00] driver [Generic PHY] (irq=POLL)
octeon_ethernet 11800a0000000.pip eth1: configuring for phy/sgmii link mode
octeon_ethernet 11800a0000000.pip eth2: PHY [8001180000001800:01] driver [Generic PHY] (irq=POLL)
octeon_ethernet 11800a0000000.pip eth2: configuring for phy/sgmii link mode
octeon_ethernet 11800a0000000.pip eth0: switched to inband/sgmii link mode
octeon_ethernet 11800a0000000.pip eth0: PHY [i2c:sfp:16] driver [Marvell 88E1111] (irq=POLL)
octeon_ethernet 11800a0000000.pip eth3: PHY [8001180000001800:02] driver [Marvell 88E1340S] (irq=25)
octeon_ethernet 11800a0000000.pip eth3: configuring for phy/sgmii link mode
octeon_ethernet 11800a0000000.pip eth4: PHY [8001180000001800:03] driver [Marvell 88E1340S] (irq=25)
octeon_ethernet 11800a0000000.pip eth4: configuring for phy/sgmii link mode
octeon_ethernet 11800a0000000.pip eth1: Link is Up - 100Mbps/Full - flow control off

Marvell PHY driver built-in:
octeon_ethernet 11800a0000000.pip eth0: configuring for inband/1000base-x link mode
octeon_ethernet 11800a0000000.pip eth1: PHY [8001180000001800:00] driver [Marvell 88E1340S] (irq=25)
octeon_ethernet 11800a0000000.pip eth1: configuring for phy/sgmii link mode
Error: Driver 'Marvell 88E1101' is already registered, aborting...
libphy: Marvell 88E1101: Error -16 in registering driver
Error: Driver 'Marvell 88E1101' is already registered, aborting...
libphy: Marvell 88E1101: Error -16 in registering driver
octeon_ethernet 11800a0000000.pip eth0: switched to inband/sgmii link mode
octeon_ethernet 11800a0000000.pip eth0: PHY [i2c:sfp:16] driver [Marvell 88E1111] (irq=POLL)
octeon_ethernet 11800a0000000.pip eth2: PHY [8001180000001800:01] driver [Marvell 88E1340S] (irq=25)
octeon_ethernet 11800a0000000.pip eth2: configuring for phy/sgmii link mode
octeon_ethernet 11800a0000000.pip eth3: PHY [8001180000001800:02] driver [Marvell 88E1340S] (irq=25)
octeon_ethernet 11800a0000000.pip eth3: configuring for phy/sgmii link mode
octeon_ethernet 11800a0000000.pip eth4: PHY [8001180000001800:03] driver [Marvell 88E1340S] (irq=25)
octeon_ethernet 11800a0000000.pip eth4: configuring for phy/sgmii link mode
octeon_ethernet 11800a0000000.pip eth1: Link is Up - 100Mbps/Full - flow control off

How it is supposed to deal with that?

2. It is not possible to call phylink_create from ndo_init callcack as
it evetually calls sfp_bus_add_upstream which calls rtnl_lock().
As this lock is already taken, it just deadlocks. Is this an unsupported
scenario?

Comments welcome and appreciated,
	ladis
