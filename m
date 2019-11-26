Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25D7D109D93
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 13:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728245AbfKZMKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 07:10:44 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:29349 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727598AbfKZMKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 07:10:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574770243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=XdvPAnEZou5W6Y0NzuwOjtFzcsiRjYpu1FP7zo1/ZgE=;
        b=CBAi6zDtD35g1k8hCmJJ7shzNPWMv2xkBmMDZL1eqDneDTDwRINV71pVNN7gScQ/ljD6yz
        YW1dWxgx7qB/FHA+qFMVvQ28vbfcbzc3P9odxB7twtL52B67vv2pNZm0xFAlPxu+WyYNDG
        ta7NgQiT2Q1hnONXpjjjekXXpr2gC5Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-390-rv6Hf_b5O8yl6XrOO_4glQ-1; Tue, 26 Nov 2019 07:10:42 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C9A980183C;
        Tue, 26 Nov 2019 12:10:41 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-116-191.ams2.redhat.com [10.36.116.191])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7E51A5D9CA;
        Tue, 26 Nov 2019 12:10:40 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Pravin B Shelar <pshelar@ovn.org>
Subject: [PATCH net 0/2] openvswitch: remove a couple of BUG_ON()
Date:   Tue, 26 Nov 2019 13:10:28 +0100
Message-Id: <cover.1574769406.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: rv6Hf_b5O8yl6XrOO_4glQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The openvswitch kernel datapath includes some BUG_ON() statements to check =
for
exceptional/unexpected failures. These patches drop a couple of them, where
we can do that without introducing other side effects.

Paolo Abeni (2):
  openvswitch: drop unneeded BUG_ON() in ovs_flow_cmd_build_info()
  openvswitch: remove another BUG_ON()

 net/openvswitch/datapath.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--=20
2.21.0

