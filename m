Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADB31264E4E
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbgIJTJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:09:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:39586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726828AbgIJTJW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 15:09:22 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05734207DE;
        Thu, 10 Sep 2020 19:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599764962;
        bh=4A38izDaZLdExPsdduPa2mVWjPznfyxoCrEqcnukRnw=;
        h=From:To:Cc:Subject:Date:From;
        b=FMjeSXcGbVVg2cvtSlpXuuHgbz68ktyz09ZlZk7k2OMbttCmMyrJkPMy33W5kn3k3
         TSV+RG4g7E1blcD8jRgIgYwInWzd8IeilllTadOZvC7gV0BFC7mYmmO2u1VWtevno2
         cOcJk3RP0TxaYUooEvoF1n9HEd3viYzWdU8vfE5k=
From:   Jakub Kicinski <kuba@kernel.org>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH ethtool v2 0/2] support tunnel info dumping
Date:   Thu, 10 Sep 2020 12:09:13 -0700
Message-Id: <20200910190915.564904-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

This set adds support for ETHTOOL_MSG_TUNNEL_INFO_GET.

Jakub Kicinski (2):
  update UAPI header copies
  tunnels: implement new --show-tunnels command

 Makefile.am                  |   2 +-
 ethtool.8.in                 |   9 ++
 ethtool.c                    |   5 +
 netlink/extapi.h             |   2 +
 netlink/tunnels.c            | 236 +++++++++++++++++++++++++++++++++++
 uapi/linux/ethtool.h         |  17 +++
 uapi/linux/ethtool_netlink.h |  55 ++++++++
 uapi/linux/if_link.h         | 227 ++++++++++++++++++++++++++++++---
 uapi/linux/rtnetlink.h       |  46 +++----
 9 files changed, 558 insertions(+), 41 deletions(-)
 create mode 100644 netlink/tunnels.c

-- 
2.26.2

