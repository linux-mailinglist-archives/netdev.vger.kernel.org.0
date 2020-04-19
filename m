Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EADC31AFE8B
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 00:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbgDSWMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 18:12:25 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49136 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725848AbgDSWMZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 18:12:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Wv93w1GBmx10pGoTzPJXf3zqeg3gjP7XumG5wNRQ1eE=; b=keuwFi8FHFYImsx8tkyFuM1D3/
        typn78YXMTEofFV6JZig7ZEoeBkDKf4QvpQn+X6uED5uh8YWymNCd6JqSBmsrvfr/h3xqrbhr47pQ
        ni/82boYNw5itqTqhO8vd/3fSPhqS1WlO+r4vgbdITFVqYKJP3xcDiiI/dP+WBDT+uw8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jQIAZ-003hzq-JR; Mon, 20 Apr 2020 00:12:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v2 0/3] RFC 2863 Testing Oper status
Date:   Mon, 20 Apr 2020 00:11:49 +0200
Message-Id: <20200419221152.884053-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.26.0.rc2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset add support for RFC 2863 Oper status testing.  An
interface is placed into this state when a self test is performed
using ethtool.

v2:
Fix date/kernel version in Documentation
Add reviewed-by tags

Andrew Lunn (3):
  net: Add IF_OPER_TESTING
  net: Add testing sysfs attribute
  net: ethtool: self_test: Mark interface in testing operative status

 Documentation/ABI/testing/sysfs-class-net | 13 +++++++
 include/linux/netdevice.h                 | 41 +++++++++++++++++++++++
 include/uapi/linux/if.h                   |  1 +
 net/core/dev.c                            |  5 +++
 net/core/link_watch.c                     | 12 +++++--
 net/core/net-sysfs.c                      | 15 ++++++++-
 net/core/rtnetlink.c                      |  9 ++++-
 net/ethtool/ioctl.c                       |  2 ++
 8 files changed, 94 insertions(+), 4 deletions(-)

-- 
2.26.1

