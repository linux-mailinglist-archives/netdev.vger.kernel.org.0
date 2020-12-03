Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AFBB2CD76C
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 14:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437118AbgLCNeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 08:34:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:47780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436825AbgLCNbB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 08:31:01 -0500
From:   Sasha Levin <sashal@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pankaj Sharma <pankj.sharma@samsung.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 22/23] can: m_can: m_can_dev_setup(): add support for bosch mcan version 3.3.0
Date:   Thu,  3 Dec 2020 08:29:34 -0500
Message-Id: <20201203132935.931362-22-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201203132935.931362-1-sashal@kernel.org>
References: <20201203132935.931362-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pankaj Sharma <pankj.sharma@samsung.com>

[ Upstream commit 5c7d55bded77da6db7c5d249610e3a2eed730b3c ]

Add support for mcan bit timing and control mode according to bosch mcan IP
version 3.3.0. The mcan version read from the Core Release field of CREL
register would be 33. Accordingly the properties are to be set for mcan v3.3.0

Signed-off-by: Pankaj Sharma <pankj.sharma@samsung.com>
Link: https://lore.kernel.org/r/1606366302-5520-1-git-send-email-pankj.sharma@samsung.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/m_can.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index f9a2a9ecbac9e..c84114b44ee07 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1337,6 +1337,8 @@ static int m_can_dev_setup(struct m_can_classdev *m_can_dev)
 						&m_can_data_bittiming_const_31X;
 		break;
 	case 32:
+	case 33:
+		/* Support both MCAN version v3.2.x and v3.3.0 */
 		m_can_dev->can.bittiming_const = m_can_dev->bit_timing ?
 			m_can_dev->bit_timing : &m_can_bittiming_const_31X;
 
-- 
2.27.0

