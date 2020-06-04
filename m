Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 092151EEA79
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 20:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728649AbgFDSpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 14:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728124AbgFDSpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 14:45:18 -0400
Received: from smtp.tuxdriver.com (tunnel92311-pt.tunnel.tserv13.ash1.ipv6.he.net [IPv6:2001:470:7:9c9::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CCC56C08C5C0
        for <netdev@vger.kernel.org>; Thu,  4 Jun 2020 11:45:18 -0700 (PDT)
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
        (envelope-from <linville@tuxdriver.com>)
        id 1jgurX-0000Z1-2u; Thu, 04 Jun 2020 14:45:11 -0400
Received: from linville-x1.hq.tuxdriver.com (localhost.localdomain [127.0.0.1])
        by linville-x1.hq.tuxdriver.com (8.15.2/8.14.6) with ESMTP id 054IZd8L1475749;
        Thu, 4 Jun 2020 14:35:39 -0400
Received: (from linville@localhost)
        by linville-x1.hq.tuxdriver.com (8.15.2/8.15.2/Submit) id 054IZdA11475748;
        Thu, 4 Jun 2020 14:35:39 -0400
Date:   Thu, 4 Jun 2020 14:35:39 -0400
From:   "John W. Linville" <linville@tuxdriver.com>
To:     netdev@vger.kernel.org
Cc:     Michal Kubecek <mkubecek@suse.cz>, davem@davemloft.net
Subject: ethtool 5.7 released
Message-ID: <20200604183539.GC1408312@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ethtool version 5.7 has been released.

Home page: https://www.kernel.org/pub/software/network/ethtool/
Download link:
https://www.kernel.org/pub/software/network/ethtool/ethtool-5.7.tar.xz

Release notes:

	* Feature: ethtool: Add support for Low Latency Reed Solomon
	* Fix: ethtool.c: Report transceiver correctly
	* Feature: features: accept long legacy flag names when setting features
	* Feature: refactor interface between ioctl and netlink code
	* Feature: netlink: use genetlink ops information to decide about fallback
	* Feature: netlink: show netlink error even without extack
	* Feature: ethtool: add support for newer SFF-8024 compliance codes
	* Feature: Rewrite printf() due to -Werror=format-security

This should be my last release as maintainer of ethtool. Michal
Kubecek has graciously agreed to take-on that responsibility, and I
have every confidence that he will do a great job in that capacity
for our community.

Thanks, Michal!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.



