Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18F2C209784
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 02:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388868AbgFYANS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 20:13:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59652 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388522AbgFYANK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 20:13:10 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1joFVn-00274Y-Nt; Thu, 25 Jun 2020 02:13:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [ethtool v2 0/6] ethtool(1) cable test support
Date:   Thu, 25 Jun 2020 02:12:38 +0200
Message-Id: <20200625001244.503790-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the user space side of the ethtool cable test.

The TDR output is most useful when fed to some other tool which can
visualize the data. So add JSON support, by borrowing code from
iproute2.

v2:
man page fixes.

Andrew Lunn (6):
  Add cable test support
  Add cable test TDR support
  json_writer: Import the iproute2 helper code for JSON output
  Add --json command line argument parsing
  ethtool.8.in: Document the cable test commands
  ethtool.8.in: Add --json option

 Makefile.am          |   5 +-
 ethtool.8.in         |  53 ++++
 ethtool.c            |  46 +++-
 internal.h           |   4 +
 json_writer.c        | 389 +++++++++++++++++++++++++++
 json_writer.h        |  76 ++++++
 netlink/cable_test.c | 624 +++++++++++++++++++++++++++++++++++++++++++
 netlink/extapi.h     |   4 +
 netlink/monitor.c    |   8 +
 netlink/netlink.h    |   5 +-
 netlink/parser.c     |  41 +++
 netlink/parser.h     |   4 +
 12 files changed, 1245 insertions(+), 14 deletions(-)
 create mode 100644 json_writer.c
 create mode 100644 json_writer.h
 create mode 100644 netlink/cable_test.c

-- 
2.26.2

