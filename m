Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9DF2DBFC7
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 12:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725958AbgLPLuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 06:50:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40671 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725871AbgLPLuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 06:50:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608119339;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=wfVWb3CVMonBfeGlFj/7mPfE6wqEjL5Et9Uh8BCMheU=;
        b=EBSeaLT2aHZ2yHnutvvfOLgFactEIADCyoA6i4V3ZfDRup+9wYav9YODqWvwRRTSCdglZS
        xfOaDUS2z/GZdEWUBuT3uLlyI62VZieJ6+S6HTcUVbkiKHoThEzvf+4nZCH+3p655JgWGW
        9XdV/CXJCPdLXFuG4ZPGWleWQrlQ0UI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-592-LfSpfqJ6PxKJV-rnqIw85A-1; Wed, 16 Dec 2020 06:48:55 -0500
X-MC-Unique: LfSpfqJ6PxKJV-rnqIw85A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D1F418735CC;
        Wed, 16 Dec 2020 11:48:48 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-112-143.ams2.redhat.com [10.36.112.143])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4FA0D77C07;
        Wed, 16 Dec 2020 11:48:46 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org
Subject: [PATCH net 0/4] mptcp: a bunch of assorted fixes
Date:   Wed, 16 Dec 2020 12:48:31 +0100
Message-Id: <cover.1608114076.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series pulls a few fixes for the MPTCP datapath.
Most issues addressed here has been recently introduced
with the recent reworks, with the notable exception of
the first patch, which addresses an issue present since
the early days

Paolo Abeni (4):
  mptcp: fix security context on server socket
  mptcp: properly annotate nested lock
  mptcp: push pending frames when subflow has free space
  mptcp: fix pending data accounting

 net/mptcp/options.c                               | 13 ++++++++-----
 net/mptcp/protocol.c                              | 11 ++++++-----
 net/mptcp/protocol.h                              |  2 +-
 tools/testing/selftests/net/mptcp/simult_flows.sh |  6 +++---
 4 files changed, 18 insertions(+), 14 deletions(-)

-- 
2.26.2

