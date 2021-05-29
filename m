Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBA8E394CA3
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 17:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbhE2PPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 May 2021 11:15:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23294 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229693AbhE2PPn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 May 2021 11:15:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622301246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=6MGGzLTDe9gFpsIj0b73RWsIuNVF4M6OHm824oEKtZA=;
        b=hEhlG9g5Lsc4e3BAbITyufTh76Ax85Uw4s+iMfgnZgVateqJAZHZZj8H79En3PrCH80piz
        4/ywpqVMEG9TgaCB8NUnASoUfAxUbpn8UlroXHAF2b6V7dryz4HWvvwnyVgdj8iJZ2MMlT
        QfSd43TnleKpfc7PELVZuM2WC/5VRps=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-391-yc_9f2ezP8OwycRWAv71ug-1; Sat, 29 May 2021 11:14:03 -0400
X-MC-Unique: yc_9f2ezP8OwycRWAv71ug-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0C630501E0;
        Sat, 29 May 2021 15:14:02 +0000 (UTC)
Received: from ymir.virt.lab.eng.bos.redhat.com (virtlab420.virt.lab.eng.bos.redhat.com [10.19.152.148])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 68B68E151;
        Sat, 29 May 2021 15:14:00 +0000 (UTC)
From:   jmaloy@redhat.com
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     tipc-discussion@lists.sourceforge.net,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        tuong.t.lien@dektech.com.au, jmaloy@redhat.com, maloy@donjonn.com,
        xinl@redhat.com, ying.xue@windriver.com,
        parthasarathy.bhuvaragan@gmail.com
Subject: [net-next 0/3] tipc: some small cleanups
Date:   Sat, 29 May 2021 11:13:57 -0400
Message-Id: <20210529151400.781539-1-jmaloy@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jon Maloy <jmaloy@redhat.com>

We make some minor code cleanups and improvements.

Jon Maloy (3):
  tipc: eliminate redundant fields in struct tipc_sock
  tipc: refactor function tipc_sk_anc_data_recv()
  tipc: simplify handling of lookup scope during multicast message
    reception

 net/tipc/name_table.c |   6 +-
 net/tipc/name_table.h |   4 +-
 net/tipc/socket.c     | 156 +++++++++++++++++++-----------------------
 3 files changed, 77 insertions(+), 89 deletions(-)

-- 
2.31.1

