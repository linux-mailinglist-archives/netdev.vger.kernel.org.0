Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 279BF3F9BB5
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 17:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245401AbhH0P2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 11:28:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:43474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245384AbhH0P2h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 11:28:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F653600AA;
        Fri, 27 Aug 2021 15:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630078068;
        bh=YXRdDDcJ+D1TbZfRQcr8Hi/1iYMg6Oy2sBDAOrOjHlI=;
        h=From:To:Cc:Subject:Date:From;
        b=kLs1tsERYLpj8nzB3QngPuhebYffLvthHVwkM2qRfRZy9NBQBM2APGfYree9oIxeK
         VEDCjfXSavqmL1HBstmuHu6eiLTzPH5CKkFGtsF0ON8idyCzY29sVBPVxERrYBXn5Q
         A+c/iXjhqRP+K2qYKwADAzk9CAKA0vsY+2SnZ89ZW5z/VTmkkLUaWDzjMoOQI7DLUE
         OgYKR7FVyYmWRJNui9RVqIJIyZcHkXCRR0K0B8yFjWzaWfzNNK685oKiyNVkXUJgEb
         gxtkQzOFZPuu71DcXR/1w8bTypZd3b8Y7F7tYM7soDFV5xiklSbPaY4vN7JOUeDga1
         1vpu1u3AAXRqg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, michael.chan@broadcom.com
Cc:     netdev@vger.kernel.org, edwin.peer@broadcom.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v4 0/2] bnxt: add rx discards stats for oom and netpool
Date:   Fri, 27 Aug 2021 08:27:43 -0700
Message-Id: <20210827152745.68812-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drivers should avoid silently dropping frames. This set adds two
stats for previously unaccounted events to bnxt - packets dropped
due to allocation failures and packets dropped during emergency
ring polling.

v4: drop patch 1, not needed after simplifications

Jakub Kicinski (2):
  bnxt: count packets discarded because of netpoll
  bnxt: count discards due to memory allocation errors

 drivers/net/ethernet/broadcom/bnxt/bnxt.c      | 18 +++++++++++++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h      |  2 ++
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |  4 ++++
 3 files changed, 23 insertions(+), 1 deletion(-)

-- 
2.31.1

