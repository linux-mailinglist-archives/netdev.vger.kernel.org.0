Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA48621D9E
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 20:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727160AbfEQSpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 14:45:11 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37624 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfEQSpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 14:45:11 -0400
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
        (envelope-from <linville@tuxdriver.com>)
        id 1hRhqv-0004OF-V3
        for netdev@vger.kernel.org; Fri, 17 May 2019 14:45:10 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by localhost.localdomain (8.15.2/8.14.6) with ESMTP id x4HIb9Mg031750
        for <netdev@vger.kernel.org>; Fri, 17 May 2019 14:37:09 -0400
Received: (from linville@localhost)
        by localhost.localdomain (8.15.2/8.15.2/Submit) id x4HIb1aO031749
        for netdev@vger.kernel.org; Fri, 17 May 2019 14:37:01 -0400
Date:   Fri, 17 May 2019 14:37:01 -0400
From:   "John W. Linville" <linville@tuxdriver.com>
To:     netdev@vger.kernel.org
Subject: ethtool 5.1 released
Message-ID: <20190517183700.GA30699@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ethtool version 5.1 has been released.

Home page: https://www.kernel.org/pub/software/network/ethtool/
Download link:
https://www.kernel.org/pub/software/network/ethtool/ethtool-5.1.tar.xz

Release notes:

        * Feature: Add support for 200Gbps (50Gbps per lane) link mode
        * Feature: simplify handling of PHY tunable downshift
        * Feature: add support for PHY tunable Fast Link Down
        * Feature: add PHY Fast Link Down tunable to man page
        * Feature: Add a 'start N' option when specifying the Rx flow hash indirection table.
        * Feature: Add bash-completion script
        * Feature: add 10000baseR_FEC link mode name
        * Fix: qsfp: fix special value comparison
        * Feature: move option parsing related code into function
        * Feature: move cmdline_coalesce out of do_scoalesce
        * Feature: introduce new ioctl for per-queue settings
        * Feature: support per-queue sub command --show-coalesce
        * Feature: support per-queue sub command --coalesce
        * Fix: fix up dump_coalesce output to match actual option names
        * Feature: fec: add pretty dump

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

