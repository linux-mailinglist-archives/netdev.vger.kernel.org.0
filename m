Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 555662F3710
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 18:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389771AbhALR1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 12:27:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56011 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732584AbhALR1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 12:27:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610472353;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ksKJOrya0E5SZAtlWnTQ7OOV8JRV7X4ExT/Qyl0s9FM=;
        b=C7VGTCgQkUeA1GEIfjRGaabhT+SOgzX4BoTNryMEiCYlN5wbh6ldLzYoEtKufhOBvO/LWS
        VHO+OG3OaE4JSj0oFLZ8TZrBfgELYZ6iVnLUiVk+O7WUaz4kv/f0mlyxSePYDUiTs+9h85
        4YpEX9q1V1l4SE3xh56Ux5zYOzjz8AM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-193-sRvhOezcM--COkyaTWuGvg-1; Tue, 12 Jan 2021 12:25:48 -0500
X-MC-Unique: sRvhOezcM--COkyaTWuGvg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7C3FECC622;
        Tue, 12 Jan 2021 17:25:47 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-115-120.ams2.redhat.com [10.36.115.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 430E716D38;
        Tue, 12 Jan 2021 17:25:45 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     mptcp@lists.01.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 0/2] mptcp: a couple of fixes
Date:   Tue, 12 Jan 2021 18:25:22 +0100
Message-Id: <cover.1610471474.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series includes two related fixes addressing potential divide by 0
bugs in the MPTCP datapath.

Paolo Abeni (2):
  mptcp: more strict state checking for acks
  mptcp: better msk-level shutdown.

 net/mptcp/protocol.c | 64 +++++++++++++-------------------------------
 1 file changed, 18 insertions(+), 46 deletions(-)

-- 
2.26.2

