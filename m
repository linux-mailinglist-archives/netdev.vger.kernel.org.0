Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4D65D77AE
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 15:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732165AbfJONtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 09:49:19 -0400
Received: from foss.arm.com ([217.140.110.172]:39118 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732106AbfJONtT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 09:49:19 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1A323337;
        Tue, 15 Oct 2019 06:49:19 -0700 (PDT)
Received: from eglon.cambridge.arm.com (unknown [10.1.196.105])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 79C4F3F718;
        Tue, 15 Oct 2019 06:49:18 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
To:     netdev@vger.kernel.org
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        "Dave S . Miller" <davem@davemloft.net>
Subject: [RFC PATCH net 0/2] amd-xgbe: Sleeping while atomic during hibernate
Date:   Tue, 15 Oct 2019 14:49:09 +0100
Message-Id: <20191015134911.231121-1-james.morse@arm.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi guys,

While testing hibernate on Seattle, I ran over these two.

I'm not sure the second one is correct, so I'm hoping someone else will
know how to fix it!

Thanks,

James Morse (2):
  amd-xgbe: Avoid sleeping in flush_workqueue() while holding a spinlock
  amd-xgbe: Avoid sleeping in napi_disable() while holding a spinlock

 drivers/net/ethernet/amd/xgbe/xgbe-drv.c | 26 ++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

-- 
2.20.1

