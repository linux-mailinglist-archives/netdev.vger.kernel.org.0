Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B40F13767C
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 20:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728617AbgAJTAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 14:00:12 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48408 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728496AbgAJTAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 14:00:12 -0500
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
        (envelope-from <linville@tuxdriver.com>)
        id 1ipzVy-0001Bp-Qr
        for netdev@vger.kernel.org; Fri, 10 Jan 2020 14:00:10 -0500
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by localhost.localdomain (8.15.2/8.14.6) with ESMTP id 00AIjJVR011860
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 13:45:19 -0500
Received: (from linville@localhost)
        by localhost.localdomain (8.15.2/8.15.2/Submit) id 00AIjJiF011859
        for netdev@vger.kernel.org; Fri, 10 Jan 2020 13:45:19 -0500
Date:   Fri, 10 Jan 2020 13:45:19 -0500
From:   "John W. Linville" <linville@tuxdriver.com>
To:     netdev@vger.kernel.org
Subject: ethtool 5.4 released
Message-ID: <20200110184519.GA27895@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ethtool version 5.4 has been released.

Home page: https://www.kernel.org/pub/software/network/ethtool/
Download link:
https://www.kernel.org/pub/software/network/ethtool/ethtool-5.4.tar.xz

Release notes:

	* Feature: ethtool: implement support for Energy Detect Power Down
 	* Fix: fix arithmetic on pointer to void is a GNU extension warning
 	* Fix: fix unused parameter warnings in do_version() and show_usage()
 	* Fix: fix unused parameter warning in find_option()
 	* Fix: fix unused parameter warning in dump_eeprom()
 	* Fix: fix unused parameter warning in altera_tse_dump_regs()
 	* Fix: fix unused parameter warning in sfc_dump_regs()
 	* Fix: fix unused parameter warning in print_simple_table()
 	* Fix: fix unused parameter warning in natsemi_dump_regs()
 	* Fix: fix unused parameter warning in netsemi_dump_eeprom()
 	* Fix: fix unused parameter warning in ixgbe_dump_regs()
 	* Fix: fix unused parameter warning in realtek_dump_regs()
 	* Fix: fix unused parameter warning in lan78xx_dump_regs()
 	* Fix: fix unused parameter warning in {skge, sky2}_dump_regs()
 	* Fix: fix unused parameter warning in dsa_dump_regs()
 	* Fix: fix unused parameter warning in vmxnet3_dump_regs()
 	* Fix: fix unused parameter warning in st_{mac100, gmac}_dump_regs()
 	* Fix: fix unused parameter warning in ixgbevf_dump_regs()
 	* Fix: fix unused parameter warning in fec_8xx_dump_regs()
 	* Fix: fix unused parameter warning in tg3_dump_{eeprom, regs}()
 	* Fix: fix unused parameter warning in vioc_dump_regs()
 	* Fix: fix unused parameter warning in e100_dump_regs()
 	* Fix: fix unused parameter warning in de2104[01]_dump_regs()
 	* Fix: fix unused parameter warning in igb_dump_regs()
 	* Fix: fix unused parameter warning in e1000_dump_regs()
 	* Fix: fix unused parameter warning in smsc911x_dump_regs()
 	* Fix: fix unused parameter warning in at76c50x_usb_dump_regs()
 	* Fix: fix unused parameter warning in fec_dump_regs()
 	* Fix: fix unused parameter warning in amd8111e_dump_regs()
 	* Fix: fix unused parameter warning in et131x_dump_regs()
 	* Fix: fix unused parameter warning in ibm_emac_dump_regs()
 	* Fix: fix unused parameter warning in ixgb_dump_regs()
 	* Fix: fix unused parameter warning in fjes_dump_regs()
 	* Fix: fix unused parameter warning in e1000_get_mac_type()
 	* Fix: ethtool: correctly interpret bitrate of 255
 	* Fix: ethtool: mark 10G Base-ER as SFF-8472 revision 10.4 onwards
 	* Fix: ethtool: add 0x16 and 0x1c extended compliance codes

John

P.S. If you are interested in maintaining ethtool, please let me know.
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

