Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52C6011FB5A
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 22:06:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbfLOVGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 16:06:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:34486 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726146AbfLOVGB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Dec 2019 16:06:01 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 87417AD93;
        Sun, 15 Dec 2019 21:06:00 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 15122E0404; Sun, 15 Dec 2019 22:06:00 +0100 (CET)
Message-Id: <cover.1576443050.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Date:   Sun, 15 Dec 2019 21:50:50 +0100
Subject: [PATCH iproute2-next 0/2] display permanent hardware address
To:     David Ahern <dsahern@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since kernel commit f74877a5457d ("rtnetlink: provide permanent hardware
address in RTM_NEWLINK"), in net-next tree at the moment, kernel provides
the permanent hardware address of a network device (if set). Patch 2 adds
this information to the output of "ip link show" and "ip address show",
patch 1 updates UAPI header copies to get IFLA_PERM_ADDRESS constant.

Michal Kubecek (2):
  Update kernel headers
  ip link: show permanent hardware address

 include/uapi/linux/if_bonding.h | 10 ++++++++++
 include/uapi/linux/if_bridge.h  | 10 ++++++++++
 include/uapi/linux/if_link.h    |  1 +
 ip/ipaddress.c                  | 18 ++++++++++++++++++
 4 files changed, 39 insertions(+)

-- 
2.24.1

