Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90DF0255B80
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 15:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbgH1NqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 09:46:07 -0400
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:34529 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729431AbgH1Nbw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 09:31:52 -0400
Received: from bretzel.dev.6wind.com (unknown [10.16.0.19])
        by proxy.6wind.com (Postfix) with ESMTPS id 6AFC544A9B4;
        Fri, 28 Aug 2020 15:31:07 +0200 (CEST)
Received: from dichtel by bretzel.dev.6wind.com with local (Exim 4.92)
        (envelope-from <dichtel@bretzel.dev.6wind.com>)
        id 1kBeTD-0005x5-BJ; Fri, 28 Aug 2020 15:31:07 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     davem@davemloft.net, kuba@kernel.org, pablo@netfilter.org,
        laforge@gnumonks.org, osmocom-net-gprs@lists.osmocom.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 0/2] gtp: minor enhancements
Date:   Fri, 28 Aug 2020 15:30:54 +0200
Message-Id: <20200828133056.22751-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch removes a useless rcu lock and the second relax alloc
constraints when a PDP context is added.

 drivers/net/gtp.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

Comments are welcomed,
Nicolas


