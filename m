Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 700C646D95
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 03:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbfFOBiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 21:38:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37320 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726167AbfFOBiZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 21:38:25 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 344C285539;
        Sat, 15 Jun 2019 01:38:25 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-112-18.ams2.redhat.com [10.36.112.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EA1835C257;
        Sat, 15 Jun 2019 01:38:21 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        David Ahern <dsahern@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
Subject: [PATCH net-next 0/2] selftests: pmtu: List/flush IPv4 cached routes, improve IPv6 test
Date:   Sat, 15 Jun 2019 03:38:16 +0200
Message-Id: <cover.1560562631.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Sat, 15 Jun 2019 01:38:25 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series introduce a new test, list_flush_ipv4_exception, and improves
the existing list_flush_ipv6_exception test by making it as demanding as
the IPv4 one.

Stefano Brivio (2):
  selftests: pmtu: Introduce list_flush_ipv4_exception test case
  selftests: pmtu: Make list_flush_ipv6_exception test more demanding

 tools/testing/selftests/net/pmtu.sh | 84 ++++++++++++++++++++++++++---
 1 file changed, 76 insertions(+), 8 deletions(-)

-- 
2.20.1

