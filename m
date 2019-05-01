Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE9D1045E
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 05:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbfEADoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 23:44:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54702 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbfEADoa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 23:44:30 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 53963136E24DD;
        Tue, 30 Apr 2019 20:44:27 -0700 (PDT)
Date:   Tue, 30 Apr 2019 23:44:25 -0400 (EDT)
Message-Id: <20190430.234425.732219702361005278.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 net-next 00/12] NXP SJA1105 DSA driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190429001706.7449-1-olteanv@gmail.com>
References: <20190429001706.7449-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Apr 2019 20:44:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Mon, 29 Apr 2019 03:16:54 +0300

> This patchset adds a DSA driver for the SPI-controlled NXP SJA1105
> switch.

This patch series adds many whitespace errors, which are all reported
by GIT when I try to apply your changes:

Applying: lib: Add support for generic packing operations
.git/rebase-apply/patch:176: new blank line at EOF.
+
.git/rebase-apply/patch:480: new blank line at EOF.
+
warning: 2 lines add whitespace errors.
Applying: net: dsa: Introduce driver for NXP SJA1105 5-port L2 switch
.git/rebase-apply/patch:102: new blank line at EOF.
+
.git/rebase-apply/patch:117: new blank line at EOF.
+
.git/rebase-apply/patch:262: new blank line at EOF.
+
.git/rebase-apply/patch:867: new blank line at EOF.
+
.git/rebase-apply/patch:2905: new blank line at EOF.
+
warning: squelched 2 whitespace errors
warning: 7 lines add whitespace errors.
Applying: net: dsa: sja1105: Add support for FDB and MDB management
.git/rebase-apply/patch:81: new blank line at EOF.
+
warning: 1 line adds whitespace errors.
Applying: net: dsa: sja1105: Error out if RGMII delays are requested in DT
Applying: ether: Add dedicated Ethertype for pseudo-802.1Q DSA tagging
Applying: net: dsa: sja1105: Add support for VLAN operations
.git/rebase-apply/patch:359: new blank line at EOF.
+
warning: 1 line adds whitespace errors.
Applying: net: dsa: sja1105: Add support for ethtool port counters
.git/rebase-apply/patch:474: new blank line at EOF.
+
warning: 1 line adds whitespace errors.
Applying: net: dsa: sja1105: Add support for configuring address aging time
Applying: net: dsa: sja1105: Prevent PHY jabbering during switch reset
Applying: net: dsa: sja1105: Reject unsupported link modes for AN
Applying: Documentation: net: dsa: Add details about NXP SJA1105 driver
.git/rebase-apply/patch:200: new blank line at EOF.
+
warning: 1 line adds whitespace errors.
Applying: dt-bindings: net: dsa: Add documentation for NXP SJA1105 driver
.git/rebase-apply/patch:178: new blank line at EOF.
+
warning: 1 line adds whitespace errors.
