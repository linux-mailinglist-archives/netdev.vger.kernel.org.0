Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE4641CF97E
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 17:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbgELPnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 11:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726889AbgELPnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 11:43:31 -0400
X-Greylist: delayed 1695 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 12 May 2020 08:43:30 PDT
Received: from smtp.tuxdriver.com (tunnel92311-pt.tunnel.tserv13.ash1.ipv6.he.net [IPv6:2001:470:7:9c9::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F290DC061A0C
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 08:43:30 -0700 (PDT)
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
        (envelope-from <linville@tuxdriver.com>)
        id 1jYWci-0000MI-Jz
        for netdev@vger.kernel.org; Tue, 12 May 2020 11:15:12 -0400
Received: from linville-x1.hq.tuxdriver.com (localhost.localdomain [127.0.0.1])
        by linville-x1.hq.tuxdriver.com (8.15.2/8.14.6) with ESMTP id 04CFApZT623920
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 11:10:51 -0400
Received: (from linville@localhost)
        by linville-x1.hq.tuxdriver.com (8.15.2/8.15.2/Submit) id 04CFApTT623919
        for netdev@vger.kernel.org; Tue, 12 May 2020 11:10:51 -0400
Date:   Tue, 12 May 2020 11:10:51 -0400
From:   "John W. Linville" <linville@tuxdriver.com>
To:     netdev@vger.kernel.org
Subject: ethtool 5.6 released
Message-ID: <20200512151051.GC615364@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ethtool version 5.6 has been released.

Home page: https://www.kernel.org/pub/software/network/ethtool/
Download link:
https://www.kernel.org/pub/software/network/ethtool/ethtool-5.6.tar.xz

Release notes:

	* Feature: add --debug option to control debugging messages
	* Feature: use named initializers in command line option list
	* Feature: netlink: add netlink related UAPI header files
	* Feature: netlink: introduce the netlink interface
	* Feature: netlink: message buffer and composition helpers
	* Feature: netlink: netlink socket wrapper and helpers
	* Feature: netlink: initialize ethtool netlink socket
	* Feature: netlink: add support for string sets
	* Feature: netlink: add notification monitor
	* Feature: netlink: add bitset helpers
	* Feature: netlink: partial netlink handler for gset (no option)
	* Feature: netlink: support getting wake-on-lan and debugging settings
	* Feature: netlink: add basic command line parsing helpers
	* Feature: netlink: add bitset command line parser handlers
	* Feature: netlink: add netlink handler for sset (-s)
	* Feature: netlink: support tests with netlink enabled
	* Feature: netlink: add handler for permaddr (-P)
	* Feature: netlink: support for pretty printing netlink messages
	* Feature: netlink: message format description for ethtool netlink
	* Feature: netlink: message format descriptions for genetlink control
	* Feature: netlink: message format descriptions for rtnetlink
	* Feature: netlink: use pretty printing for ethtool netlink messages

John

P.S. If you are interested in maintaining ethtool, please let me know!
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.


