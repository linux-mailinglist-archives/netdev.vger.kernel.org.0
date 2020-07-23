Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9929F22AFC5
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 14:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728693AbgGWM6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 08:58:22 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:35257 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726521AbgGWM6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 08:58:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595509100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=iktTWo7QuxetST0O1Gxkmm6bjBc53WCTh3lBW8kfa/M=;
        b=FaA/a1Swy7kS/puM6dl7d+xFPiU8I0Yre6GJC2JpcfXlPzizPh3by1JiSm5P20vNvHsAT0
        3KDZqxFZmixpelRkkP6/gKfwBXgokLBcz+lWdhTar48xp2VrhXSAHxh0cTONPXjuSR4D/h
        5WBy9sdzn4CRrV0U7ZK/HnQ2W0OnHdw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-443-pX62ZBpEN0atSPVIp4q-WQ-1; Thu, 23 Jul 2020 08:58:18 -0400
X-MC-Unique: pX62ZBpEN0atSPVIp4q-WQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 53A271083E87;
        Thu, 23 Jul 2020 12:58:17 +0000 (UTC)
Received: from ebuild.redhat.com (ovpn-112-133.ams2.redhat.com [10.36.112.133])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D49ED61177;
        Thu, 23 Jul 2020 12:58:15 +0000 (UTC)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dev@openvswitch.org, kuba@kernel.org,
        pabeni@redhat.com, pshelar@ovn.org, fw@strlen.de
Subject: [PATCH net-next v2 0/2] net: openvswitch: masks cache enhancements
Date:   Thu, 23 Jul 2020 14:58:11 +0200
Message-Id: <159550903978.849915.17042128332582130595.stgit@ebuild>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds two enhancements to the Open vSwitch masks cache.

Signed-off-by: Eelco Chaudron <echaudro@redhat.com>

Changes in v2:
 - Fix sparse warnings
 - Fix netlink policy items reported by Florian Westphal

Eelco Chaudron (2):
      net: openvswitch: add masks cache hit counter
      net: openvswitch: make masks cache size configurable


 include/uapi/linux/openvswitch.h |    3 +
 net/openvswitch/datapath.c       |   19 ++++++-
 net/openvswitch/datapath.h       |    3 +
 net/openvswitch/flow_table.c     |  109 +++++++++++++++++++++++++++++++++-----
 net/openvswitch/flow_table.h     |   13 ++++-
 5 files changed, 128 insertions(+), 19 deletions(-)

