Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC62D364545
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 15:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240663AbhDSNvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 09:51:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52009 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238659AbhDSNvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 09:51:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618840232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=stBALs32bfMznnAl5gOjql0aVHpwEItRBW5ORN3dqA8=;
        b=R3+H1lwegDgTl7vv/9ubvSsUaOXqDSSTigix/n8WqSPG80VyjmFvQ3TA4H8S4AKIKGEZDI
        xaWCulbxudp9wLdxSFgpUBRldfioLcPF9oM/uvZ7zOUs2h445WwwLnCTAP7SPPJux2YHbx
        9jKgMlki3GCoH+t5qpnIAmnN4qqDHx8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-363-zi8DpJ-5NIGlkJnSIhklgA-1; Mon, 19 Apr 2021 09:50:28 -0400
X-MC-Unique: zi8DpJ-5NIGlkJnSIhklgA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B274F107ACC7;
        Mon, 19 Apr 2021 13:50:27 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-112-159.ams2.redhat.com [10.36.112.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E22B12BFEC;
        Mon, 19 Apr 2021 13:50:26 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2 0/2] lib: bpf_legacy: some misc fixes
Date:   Mon, 19 Apr 2021 15:49:55 +0200
Message-Id: <cover.1618839527.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set fixes two issues on bpf_legacy library code.
- 1/2 fixes a covscan warning about a possible missing close() treating
  0 as a valid file descriptor, as almost elsewhere in iproute2 code.
- 2/2 fixes a missing close() on a socket in some error paths in two
  functions.

Andrea Claudi (2):
  lib: bpf_legacy: treat 0 as a valid file descriptor
  lib: bpf_legacy: fix missing socket close when connect() fails

 lib/bpf_legacy.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

-- 
2.30.2

