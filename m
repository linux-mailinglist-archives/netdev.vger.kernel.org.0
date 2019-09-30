Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7A3EC24CC
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 18:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732188AbfI3QCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 12:02:24 -0400
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:57966 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730809AbfI3QCY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 12:02:24 -0400
Received: from bretzel.dev.6wind.com (unknown [10.16.0.19])
        by proxy.6wind.com (Postfix) with ESMTP id 4443B324B61;
        Mon, 30 Sep 2019 18:02:22 +0200 (CEST)
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 0/2] Ease nsid allocation
Date:   Mon, 30 Sep 2019 18:02:12 +0200
Message-Id: <20190930160214.4512-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


The goal of the series is to ease nsid allocation from userland.
The first patch is a preparation work and the second enables to receive the
new nsid in the answer to RTM_NEWNSID.

 net/core/net_namespace.c | 118 ++++++++++++++++++++++++++++-------------------
 1 file changed, 71 insertions(+), 47 deletions(-)

Comments are welcomed,
Nicolas

