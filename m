Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3C3142B35
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 17:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440139AbfFLPp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 11:45:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49106 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440124AbfFLPpZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 11:45:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version
        :Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=UhP/gNJdISNSP1ByA7xkg/UKMmP3ldw/AWsFKV74xZs=; b=bfe5gmhtkk/3YUKHRbfrO6xead
        g2qMHsmKl0dCcE3o95mVxeUA7AOUa//mXB3SkpaN+lz1FSSyCVr3RHs3a65Lb23EOPY9UcjgDC6+0
        IHVf1MCtEKkrnj4xaundWYZOQPYfIQ9SxGxbIhgm3Ywl/38H49sCvrO9nLILqZgubPbY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hb5Qp-0005ur-Uh; Wed, 12 Jun 2019 17:44:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH RFC 0/3] RFC 2863 Testing Oper status
Date:   Wed, 12 Jun 2019 17:44:35 +0200
Message-Id: <20190612154438.22703-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset add support for RFC 2863 Oper status testing.  An
interface is placed into this state when a self test is performed
using ethtool.

Andrew Lunn (3):
  net: Add IF_OPER_TESTING
  net: Add testing sysfs attribute
  net: ethtool: self_test: Mark interface in testing operative status

 Documentation/ABI/testing/sysfs-class-net | 13 +++++++
 include/linux/netdevice.h                 | 41 +++++++++++++++++++++++
 include/uapi/linux/if.h                   |  1 +
 net/core/dev.c                            |  5 +++
 net/core/ethtool.c                        |  2 ++
 net/core/link_watch.c                     | 12 +++++--
 net/core/net-sysfs.c                      | 15 ++++++++-
 net/core/rtnetlink.c                      |  9 ++++-
 8 files changed, 94 insertions(+), 4 deletions(-)

-- 
2.20.1

