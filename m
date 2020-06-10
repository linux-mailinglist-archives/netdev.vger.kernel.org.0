Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 779351F5E64
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 00:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbgFJWgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 18:36:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:49970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726105AbgFJWgv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jun 2020 18:36:51 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16B752074B;
        Wed, 10 Jun 2020 22:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591828610;
        bh=uEUiTsScg6XCz1JnkzzyVWCxOtWhKe5qMj2VQUNvDnQ=;
        h=From:To:Cc:Subject:Date:From;
        b=kgJRKa41b6+B4j2Uo2zQezPzfvoevnHOg/eitsojskgFge8N+gB4IsI6zmxDz128y
         57xBIEQ06iN4rpB2ZbW58kiY549XsH8x6MvI9ink7r+qVjsqcBZybX9MLyAglKz9Jr
         O+0vYZDcTNkvflMavnLmxZ51Rfa1W9WufNIvg/eY=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     andrew@lunn.ch, mkubecek@suse.cz, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] docs: networking: fix extra spaces in ethtool-netlink
Date:   Wed, 10 Jun 2020 15:36:48 -0700
Message-Id: <20200610223648.406834-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sphinx appears to get upset at extra spaces at the end of a literal:

Documentation/networking/ethtool-netlink.rst:1032: WARNING: Inline literal start-string without end-string.
Documentation/networking/ethtool-netlink.rst:1034: WARNING: Inline literal start-string without end-string.
Documentation/networking/ethtool-netlink.rst:1036: WARNING: Inline literal start-string without end-string.
Documentation/networking/ethtool-netlink.rst:1089: WARNING: Inline literal start-string without end-string.
Documentation/networking/ethtool-netlink.rst:1091: WARNING: Inline literal start-string without end-string.
Documentation/networking/ethtool-netlink.rst:1093: WARNING: Inline literal start-string without end-string.

Fixes: f2bc8ad31a7f ("net: ethtool: Allow PHY cable test TDR data to configured")
Fixes: a331172b156b ("net: ethtool: Add attributes for cable test TDR data")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/ethtool-netlink.rst | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index d42661b91128..82470c36c27a 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -1028,11 +1028,11 @@ Start a cable test and report raw TDR data
  +--------------------------------------------+--------+-----------------------+
  | ``ETHTOOL_A_CABLE_TEST_TDR_CFG``           | nested | test configuration    |
  +-+------------------------------------------+--------+-----------------------+
- | | ``ETHTOOL_A_CABLE_STEP_FIRST_DISTANCE `` | u32    | first data distance   |
+ | | ``ETHTOOL_A_CABLE_STEP_FIRST_DISTANCE``  | u32    | first data distance   |
  +-+-+----------------------------------------+--------+-----------------------+
- | | ``ETHTOOL_A_CABLE_STEP_LAST_DISTANCE ``  | u32    | last data distance    |
+ | | ``ETHTOOL_A_CABLE_STEP_LAST_DISTANCE``   | u32    | last data distance    |
  +-+-+----------------------------------------+--------+-----------------------+
- | | ``ETHTOOL_A_CABLE_STEP_STEP_DISTANCE ``  | u32    | distance of each step |
+ | | ``ETHTOOL_A_CABLE_STEP_STEP_DISTANCE``   | u32    | distance of each step |
  +-+-+----------------------------------------+--------+-----------------------+
  | | ``ETHTOOL_A_CABLE_TEST_TDR_CFG_PAIR``    | u8     | pair to test          |
  +-+-+----------------------------------------+--------+-----------------------+
@@ -1085,11 +1085,11 @@ used to report the amplitude of the reflection for a given pair.
  +-+-+-----------------------------------------+--------+----------------------+
  | | ``ETHTOOL_A_CABLE_NEST_STEP``             | nested | TDR step info        |
  +-+-+-----------------------------------------+--------+----------------------+
- | | | ``ETHTOOL_A_CABLE_STEP_FIRST_DISTANCE ``| u32    | First data distance  |
+ | | | ``ETHTOOL_A_CABLE_STEP_FIRST_DISTANCE`` | u32    | First data distance  |
  +-+-+-----------------------------------------+--------+----------------------+
- | | | ``ETHTOOL_A_CABLE_STEP_LAST_DISTANCE `` | u32    | Last data distance   |
+ | | | ``ETHTOOL_A_CABLE_STEP_LAST_DISTANCE``  | u32    | Last data distance   |
  +-+-+-----------------------------------------+--------+----------------------+
- | | | ``ETHTOOL_A_CABLE_STEP_STEP_DISTANCE `` | u32    | distance of each step|
+ | | | ``ETHTOOL_A_CABLE_STEP_STEP_DISTANCE``  | u32    | distance of each step|
  +-+-+-----------------------------------------+--------+----------------------+
  | | ``ETHTOOL_A_CABLE_TDR_NEST_AMPLITUDE``    | nested | Reflection amplitude |
  +-+-+-----------------------------------------+--------+----------------------+
-- 
2.26.2

