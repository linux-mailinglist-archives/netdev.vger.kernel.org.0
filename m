Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5322DE9A6
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 20:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733166AbgLRTP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 14:15:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51008 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727889AbgLRTP6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 14:15:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608318872;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=uV2i2Mj7h3i2oT/BVy2+5TUCaZ0dyQPv7Y9cwu2xvwk=;
        b=bEYRuMPbAjgb57V1I53YpzcuZIWEqId23EICmknao9YIH6IQJi28z/nEqg8FHNYEkZ40Cc
        KFAsALBqYdp35kjPHHqftDbx0VCoTRUJDiGfmCaSib1TeKSJR2hEm5UFI6i44MbLV7EiII
        bTNSGDrkoUcYCa09rvwv4SW3UZ+b688=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-zAJIMG_6Of-8Vj1WF9FNmQ-1; Fri, 18 Dec 2020 14:14:31 -0500
X-MC-Unique: zAJIMG_6Of-8Vj1WF9FNmQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED3EC1842141;
        Fri, 18 Dec 2020 19:14:29 +0000 (UTC)
Received: from localhost.localdomain (ovpn-114-0.ams2.redhat.com [10.36.114.0])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1953B19CB6;
        Fri, 18 Dec 2020 19:14:28 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2 0/2] Some fixes to lib/fs.c
Date:   Fri, 18 Dec 2020 20:09:21 +0100
Message-Id: <cover.1608315719.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains a couple of fixes and improvements on lib/fs.c
- in functions get_cgroup2_id() and get_cgroup2_path(), fixes cleanup on
  single return point;
- in function make_path(), avoid to call mkdir() two times in a row.

Andrea Claudi (2):
  lib/fs: avoid double call to mkdir on make_path()
  lib/fs: Fix single return points for get_cgroup2_*

 lib/fs.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

-- 
2.29.2

