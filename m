Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9A802E3289
	for <lists+netdev@lfdr.de>; Sun, 27 Dec 2020 20:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbgL0TTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Dec 2020 14:19:11 -0500
Received: from saphodev.broadcom.com ([192.19.232.172]:39820 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726179AbgL0TTK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Dec 2020 14:19:10 -0500
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 284E6E9;
        Sun, 27 Dec 2020 11:18:19 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 284E6E9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1609096699;
        bh=tEnUQBQ/lN/E0vTP4BQgR02bEVWGuW8VhymGr9fpZRs=;
        h=From:To:Cc:Subject:Date:From;
        b=s8XA8GcDb+wOqnxBi06P2wObXhtQJwI9PI5yncVC/mHtZ8pCT9hKC68ZggTICVZVM
         s5ONfXLdWZnHw1/F4RFlbgyLewPu3bzwQzj6vlYCGGpiZ8sv7YP6sHSki3b0qSyXDI
         ZjjRk3rhaF4yi4WG3vZT/oQ6sguLbdjGlKZ5493E=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net 0/2] bnxt_en: Bug fixes.
Date:   Sun, 27 Dec 2020 14:18:16 -0500
Message-Id: <1609096698-15009-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch fixes recovery of fatal AER errors.  The second one
fixes a potential array out of bounds issue.

Please queue for -stable.  Thanks.

Michael Chan (1):
  bnxt_en: Check TQM rings for maximum supported value.

Vasundhara Volam (1):
  bnxt_en: Fix AER recovery.

 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 38 +++++++++++------------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  7 ++++-
 2 files changed, 25 insertions(+), 20 deletions(-)

-- 
2.18.1

