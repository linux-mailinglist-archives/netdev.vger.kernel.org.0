Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4CA3378B0
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 17:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234358AbhCKQD3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 11:03:29 -0500
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:60944 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234144AbhCKQDQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 11:03:16 -0500
X-Greylist: delayed 591 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Mar 2021 11:03:16 EST
Received: from localhost (unknown [10.16.0.21])
        by proxy.6wind.com (Postfix) with ESMTP id E5D6E90E4E9;
        Thu, 11 Mar 2021 16:53:20 +0100 (CET)
From:   Julien Massonneau <julien.massonneau@6wind.com>
To:     davem@davemloft.net, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, dlebrun@google.com
Cc:     Julien Massonneau <julien.massonneau@6wind.com>
Subject: [PATCH net-next 0/2] SRv6: SRH processing improvements
Date:   Thu, 11 Mar 2021 16:53:17 +0100
Message-Id: <20210311155319.2280-1-julien.massonneau@6wind.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for IPv4 decapsulation in ipv6_srh_rcv() and
ignore routing header with segments left equal to 0 for
seg6local actions that doesn't perfom decapsulation.

Julien Massonneau (2):
  seg6: add support for IPv4 decapsulation in ipv6_srh_rcv()
  seg6: ignore routing header with segments left equal to 0

 include/net/ipv6.h    |  1 +
 net/ipv6/exthdrs.c    |  5 +++--
 net/ipv6/seg6_local.c | 11 ++++-------
 3 files changed, 8 insertions(+), 9 deletions(-)


base-commit: 34bb975126419e86bc3b95e200dc41de6c6ca69c
-- 
2.29.2

