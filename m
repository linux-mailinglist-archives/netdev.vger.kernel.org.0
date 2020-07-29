Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF102231F44
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 15:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgG2NZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 09:25:51 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:46511 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726385AbgG2NZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 09:25:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596029149;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=MdMwVuEz2OJ2DA5rwEfhkKcwzYOEnV4z9K6qIEUqT7M=;
        b=EnBlE38ZNbhOmLBaCs31L4a3rrQFDUhMpPBfa5krfHEtnQM/ob8QkWZE3JkFWqjt9EkIn4
        G5ecAGEUhPp/XZcqddSuHnXmNID6A3ZAP+icytRK3RM+QltKMyES6twX+63vt+pW5KdMxY
        5xNl1uZ1kKGQXJp5UXW7KCjFUhUtZN0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-500-9058lTqYOX-64tVnSeT4LQ-1; Wed, 29 Jul 2020 09:25:45 -0400
X-MC-Unique: 9058lTqYOX-64tVnSeT4LQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0AC1C1902EA7;
        Wed, 29 Jul 2020 13:25:44 +0000 (UTC)
Received: from ebuild.redhat.com (ovpn-114-26.ams2.redhat.com [10.36.114.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C3E7769336;
        Wed, 29 Jul 2020 13:25:41 +0000 (UTC)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dev@openvswitch.org, kuba@kernel.org,
        pabeni@redhat.com, pshelar@ovn.org, fw@strlen.de,
        xiangxia.m.yue@gmail.com
Subject: [PATCH net-next v3 0/2] net: openvswitch: masks cache enhancements
Date:   Wed, 29 Jul 2020 15:25:35 +0200
Message-Id: <159602912600.937753.3123982828905970322.stgit@ebuild>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds two enhancements to the Open vSwitch masks cache.

Signed-off-by: Eelco Chaudron <echaudro@redhat.com>

Changes in v3 [patch 2/2 only]:
 - Use is_power_of_2() function
 - Use array_size() function
 - Fix remaining sparse errors

Changes in v2 [patch 2/2 only]:
 - Fix sparse warnings
 - Fix netlink policy items reported by Florian Westphal

Eelco Chaudron (2):
      net: openvswitch: add masks cache hit counter
      net: openvswitch: make masks cache size configurable


 include/uapi/linux/openvswitch.h |    3 +
 net/openvswitch/datapath.c       |   19 ++++++
 net/openvswitch/datapath.h       |    3 +
 net/openvswitch/flow_table.c     |  116 ++++++++++++++++++++++++++++++++------
 net/openvswitch/flow_table.h     |   13 ++++
 5 files changed, 132 insertions(+), 22 deletions(-)

