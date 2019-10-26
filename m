Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB8AE5982
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 11:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbfJZJxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 05:53:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34488 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726010AbfJZJxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Oct 2019 05:53:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572083633;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Qqh2ifUwe7D7I/W3ry+Fzk9aC84N/FSXJKw5ngJ+cOs=;
        b=XDAfrIBBEE0iylIdNk2obsqMJxjbIpFykpJ2SYAPZ+DIIncEEs/fn5uel4ZHfyZDTxLHOs
        lBke/uJucMGOlshJqjMqp8S7gv9AupszVyGzNe/BYljmiUNbxLVTAk86o3EGkpLYEzjEnD
        ZCjhpifaSKWzkwRiqDbRiiLKD9b0BNU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-mKLLwImhPbC_nmAiFXQdUg-1; Sat, 26 Oct 2019 05:53:49 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BBE10800D41;
        Sat, 26 Oct 2019 09:53:48 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-116-60.ams2.redhat.com [10.36.116.60])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9154C5C1B5;
        Sat, 26 Oct 2019 09:53:47 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>,
        Beniamino Galvani <bgalvani@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH v2 0/2] ipv4: fix route update on metric change.
Date:   Sat, 26 Oct 2019 11:53:38 +0200
Message-Id: <cover.1572083332.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: mKLLwImhPbC_nmAiFXQdUg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This fixes connected route update on some edge cases for ip addr metric
change.
It additionally includes self tests for the covered scenarios. The new test=
s
fail on unpatched kernels and pass on the patched one.

v1 -> v2:
 - add selftests

Paolo Abeni (2):
  ipv4: fix route update on metric change.
  selftests: fib_tests: add more tests for metric update

 net/ipv4/fib_frontend.c                  |  2 +-
 tools/testing/selftests/net/fib_tests.sh | 21 +++++++++++++++++++++
 2 files changed, 22 insertions(+), 1 deletion(-)

--=20
2.21.0

