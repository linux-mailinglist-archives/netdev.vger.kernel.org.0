Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E16D01E8253
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 17:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbgE2PoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 11:44:08 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:44124 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726940AbgE2PoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 11:44:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590767047;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=3HjoOnY9UVIwd010eI0IkUhEkmqRTg2VmyQzN5dEOa0=;
        b=T1EkorMc39jKs6rVHXrZ2kRHm0U/endEUANK0bfavvduP4HdvWzr9jp6pgwTU4Mos6EZzt
        RWHI/wCUGH6rq3Lu8W7wJGfC1BTAKu3zJPGZQs4ZfeqGKL2wnCxxalvYVoon3yKnczWSBC
        hGKqig7UcTCN/JuThep0PAh6AAA8NLo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-26-kw6yvRYfNNaeVf6Wl0ys5A-1; Fri, 29 May 2020 11:44:05 -0400
X-MC-Unique: kw6yvRYfNNaeVf6Wl0ys5A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E1D978014D4;
        Fri, 29 May 2020 15:44:03 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-114-94.ams2.redhat.com [10.36.114.94])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 925BE7A8D4;
        Fri, 29 May 2020 15:44:02 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 0/3] mptcp: a bunch of fixes
Date:   Fri, 29 May 2020 17:43:28 +0200
Message-Id: <cover.1590766645.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series pulls together a few bugfixes for MPTCP bug observed while
doing stress-test with apache bench - forced to use MPTCP and multiple
subflows.

Paolo Abeni (3):
  mptcp: fix unblocking connect()
  mptcp: fix race between MP_JOIN and close
  mptcp: remove msk from the token container at destruction time.

 net/mptcp/protocol.c | 64 +++++++++++++++++++++++++++++++-------------
 1 file changed, 46 insertions(+), 18 deletions(-)

-- 
2.21.3

