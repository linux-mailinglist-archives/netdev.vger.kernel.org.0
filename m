Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93BE821B736
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 15:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgGJNwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 09:52:50 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:21097 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726965AbgGJNwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 09:52:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594389168;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=vnGUVVZOuUIta4LfOOmVhXZeqEjdnZNp3klN3v3klVE=;
        b=Ovmsh1F04wlDlftM4iFiNZDICJMFthJK4chOCDUxdvdj2w+xorZpJwR/kTvujvjzIFfr4v
        Ud6wwY5z4EHOfOfkRdQr5qEjSXvqiIR1cANIYaXViqUqe6fcFsKBvR8U7MhzwHCEOBVmb6
        iBewsbZJvjPlZxxSkjxPYCxhtTW60BQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-KE_H_R6hO6ezMZQeo2LOiw-1; Fri, 10 Jul 2020 09:52:47 -0400
X-MC-Unique: KE_H_R6hO6ezMZQeo2LOiw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D9674800FEB;
        Fri, 10 Jul 2020 13:52:45 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-113-230.ams2.redhat.com [10.36.113.230])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D196E6FEEA;
        Fri, 10 Jul 2020 13:52:44 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     mptcp@lists.01.org, David Ahern <dsahern@kernel.org>
Subject: [PATCH iproute2-next 0/2] ss: MPTCP diag interface support
Date:   Fri, 10 Jul 2020 15:52:33 +0200
Message-Id: <cover.1594388640.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series implements support for the MPTCP diag interface, as recently
introduced on net-next.

The first patch updates the relevant uAPI definition to current net-next,
while the 2nd one brings in the actual implementation

Paolo Abeni (2):
  include: update mptcp uAPI
  ss: mptcp: add msk diag interface support

 include/uapi/linux/inet_diag.h |   1 +
 include/uapi/linux/mptcp.h     |  17 +++++
 misc/ss.c                      | 115 ++++++++++++++++++++++++++++++---
 3 files changed, 123 insertions(+), 10 deletions(-)

-- 
2.26.2

