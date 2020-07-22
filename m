Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0BD229372
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 10:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729894AbgGVI1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 04:27:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21564 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727034AbgGVI1m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 04:27:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595406462;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=gS0tPURnrLQ2v5Y9j1eOh/sTPrJ8Ydj14z8vM+B3N0Y=;
        b=HTAxBqWtx86uEeLAhe+dcYMluNqv4jbt2Hwx1S7U1U+5woBIP/q+FRGBuVD//WRL8qjH2P
        9EQGD07xGhZGM0Iy25pIvFDI2C15vT40wubHEcJjUU3aQeJ1oRwtbjZF9pISTGLJn9qM75
        1KMBPRBBrH1yO68TRICsrZaDmLyzFx0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-74sW_5vRMX-5O-TQVjlmGA-1; Wed, 22 Jul 2020 04:27:39 -0400
X-MC-Unique: 74sW_5vRMX-5O-TQVjlmGA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 443CB91271;
        Wed, 22 Jul 2020 08:27:38 +0000 (UTC)
Received: from ebuild.redhat.com (ovpn-112-133.ams2.redhat.com [10.36.112.133])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C5E6E72693;
        Wed, 22 Jul 2020 08:27:36 +0000 (UTC)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dev@openvswitch.org, kuba@kernel.org,
        pabeni@redhat.com, pshelar@ovn.org
Subject: [PATCH net-next 0/2] net: openvswitch: masks cache enhancements
Date:   Wed, 22 Jul 2020 10:27:34 +0200
Message-Id: <159540642765.619787.5484526399990292188.stgit@ebuild>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds two enhancements to the Open vSwitch masks cache.

Signed-off-by: Eelco Chaudron <echaudro@redhat.com>

Eelco Chaudron (2):
      net: openvswitch: add masks cache hit counter
      net: openvswitch: make masks cache size configurable


 include/uapi/linux/openvswitch.h |    3 +
 net/openvswitch/datapath.c       |   16 +++++-
 net/openvswitch/datapath.h       |    3 +
 net/openvswitch/flow_table.c     |  105 +++++++++++++++++++++++++++++++++-----
 net/openvswitch/flow_table.h     |   13 ++++-
 5 files changed, 122 insertions(+), 18 deletions(-)

