Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 634C5173EA8
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 18:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbgB1Rgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 12:36:49 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:22021 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726418AbgB1Rgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 12:36:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582911408;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=qaN74ygMdYFmwFGtbvJOf0cJwraYUr28OtcaDTp39P0=;
        b=F/7cUTJ5gH7qZ2PI5eRTWSEPzsdmazHE8eI56zsGJhp4NuwNiU/yCoxP6T6DTNKfKJltyi
        9do3JfZGU7UlUMlvNv24IuxsxnILknb7vRmWE/XGKM0AXBtLd8fTQ25HFAzCOnP4UC8BAd
        3IFinN3BdFJxpbNRToPRiqzmEwmaUhc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-491-JCxx_rNqPliTOmP9l9K4uQ-1; Fri, 28 Feb 2020 12:36:45 -0500
X-MC-Unique: JCxx_rNqPliTOmP9l9K4uQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2EE7B1902EA1;
        Fri, 28 Feb 2020 17:36:44 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.36.118.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 161AC5C21A;
        Fri, 28 Feb 2020 17:36:41 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2 0/2] rdma man pages improvements
Date:   Fri, 28 Feb 2020 18:36:23 +0100
Message-Id: <cover.1582910855.git.aclaudi@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- Add missing descriptions for both resource subcomand and filters on
  the statistic subcommand.
- Add filter description on the rdma statistic help message
- Fix some whitespace issue on the rdma statistic man page

Andrea Claudi (2):
  man: rdma.8: Add missing resource subcommand description
  man: rdma-statistic: Add filter description

 man/man8/rdma-statistic.8 | 16 ++++++++++++----
 man/man8/rdma.8           |  6 +++++-
 rdma/stat.c               |  1 +
 3 files changed, 18 insertions(+), 5 deletions(-)

--=20
2.24.1

