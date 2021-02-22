Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 853BC321F18
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 19:23:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232462AbhBVSWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 13:22:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20934 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232395AbhBVSV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 13:21:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614018002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=IozkVH+f2vxjKQlN7jJ+KfwqaN+CI9QECzuL6PGoC5o=;
        b=TUthblb/Sp9xqVcI+X2cDsZZGt8znHe457wOhqs94lGKhDi15XOxMMtHhtKLUvMDWYodRp
        NvtRpaipI/nxn/Wo2QEjAf9M9qOLBEKWUo/JFDvZ+MtiBWm+/VRNf0vh0WGmKxS/Mic10T
        RZ2lQ7iwRMdud6XlsAWpUQR8DdXzbsY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-w4E6WmKJOmu0r8ntHOIpJA-1; Mon, 22 Feb 2021 13:19:58 -0500
X-MC-Unique: w4E6WmKJOmu0r8ntHOIpJA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1B7F5195D568;
        Mon, 22 Feb 2021 18:19:57 +0000 (UTC)
Received: from localhost.localdomain (ovpn-115-141.ams2.redhat.com [10.36.115.141])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3C30510016F4;
        Mon, 22 Feb 2021 18:19:56 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2 v2 0/2] Some fixes to lib/fs.c
Date:   Mon, 22 Feb 2021 19:14:30 +0100
Message-Id: <cover.1614016514.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains a couple of fixes and improvements on lib/fs.c
- in functions get_cgroup2_id() and get_cgroup2_path(), fixes cleanup on
  single return point;
- in function make_path(), avoid to call mkdir() two times in a row.

v1->v2:
- on 1/2, no code changes, add fixes tag suggested by Phil Sutter and
  his Acked-by;
- on 2/2, simplify changes using conditional close() calls, as suggested
  by Phil Sutter.

Andrea Claudi (2):
  lib/fs: avoid double call to mkdir on make_path()
  lib/fs: Fix single return points for get_cgroup2_*

 lib/fs.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

-- 
2.29.2

