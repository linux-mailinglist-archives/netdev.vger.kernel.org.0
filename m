Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D97B3707E8
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 18:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbhEAQiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 May 2021 12:38:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44020 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230195AbhEAQiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 May 2021 12:38:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619887036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ZKqdQLltpNRJGM8g0iQdttOIYOgqYy1g8hmE2QEJNrU=;
        b=EscPeyD4dekm/aE5JzY/Qm10zL1+HFGZaaTfjPKd4mFKRzBG0XsA0dXnZGQYysuvwQoaZr
        uov91q0sfjdmg2ie4RysrKLJeTqoXxR1z5NLYhl45PNVRWpwG/PQhHjuGEZs3t5ItVOT+y
        vLIlI3Z5mDIULmoaSPisO26IDybTUU4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-574-xcum02LoNjSk0V3HsrQT-A-1; Sat, 01 May 2021 12:37:14 -0400
X-MC-Unique: xcum02LoNjSk0V3HsrQT-A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D871F802938;
        Sat,  1 May 2021 16:37:13 +0000 (UTC)
Received: from localhost.localdomain (ovpn-112-28.ams2.redhat.com [10.36.112.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EF91250AC6;
        Sat,  1 May 2021 16:37:12 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2 0/2] tipc: input validation
Date:   Sat,  1 May 2021 18:32:28 +0200
Message-Id: <cover.1619886329.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes two buffer overflow on tipc due to missing input leght
validation on key and algname params.

Andrea Claudi (2):
  tipc: bail out if algname is abnormally long
  tipc: bail out if key is abnormally long

 tipc/misc.c | 3 +++
 tipc/node.c | 9 +++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

-- 
2.30.2

