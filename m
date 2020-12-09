Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EAB32D409D
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 12:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730314AbgLILFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 06:05:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60720 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730183AbgLILFK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 06:05:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607511824;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=01gqQ38ASgF2fnFR3f0KAdi/jKYXH/hWOXAEUD2Amuc=;
        b=Fnz0vqRMLYb2730qUxNscGPM0Ec252JLzdc5rLQwgkAdQTViaGKA1NvvZCPiP38Qw4Q6cP
        im9qoPo/iasEf0UOnLCiLflsOfhPJSQCdAOfZFPuX+AdARpDWQln/O1vroOGIKSI0+EVn/
        Z1gyME+FXtrvboFrCqlXbZHwLYgorEY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-586-EDQDMThfP9GmqJwXU32a4A-1; Wed, 09 Dec 2020 06:03:42 -0500
X-MC-Unique: EDQDMThfP9GmqJwXU32a4A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A3FA5700B;
        Wed,  9 Dec 2020 11:03:41 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-112-45.ams2.redhat.com [10.36.112.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 05FE519C78;
        Wed,  9 Dec 2020 11:03:39 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org
Subject: [PATCH net-next 0/3] mptcp: a bunch of fixes
Date:   Wed,  9 Dec 2020 12:03:28 +0100
Message-Id: <cover.1607508810.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series includes a few fixes following-up the
recent code refactor for the MPTCP RX and TX paths.

Boundling them together, since the fixes are somewhat
related.

Paolo Abeni (3):
  mptcp: link MPC subflow into msk only after accept
  mptcp: plug subflow context memory leak
  mptcp: be careful on subflows shutdown

 net/mptcp/options.c  |  7 ++++++-
 net/mptcp/pm.c       |  8 +++++++-
 net/mptcp/protocol.c | 23 +++++++++++++++++++++--
 net/mptcp/protocol.h |  1 +
 net/mptcp/subflow.c  | 19 +++++++++++++------
 5 files changed, 48 insertions(+), 10 deletions(-)

-- 
2.26.2

