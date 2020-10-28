Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64FE829DBC0
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:13:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390800AbgJ2AN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 20:13:29 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50750 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390791AbgJ2AN1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 20:13:27 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kXZUR-003toX-4V; Wed, 28 Oct 2020 01:38:59 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 0/2] Markup some printk like functions
Date:   Wed, 28 Oct 2020 01:38:47 +0100
Message-Id: <20201028003849.929490-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

W=1 warns of functions which look like printk but don't have
attributes so the compile can check that arguments matches the format
string.

Andrew Lunn (2):
  net: dccp: Add __printf() markup to fix -Wsuggest-attribute=format
  net: tipc: Add __printf() markup to fix -Wsuggest-attribute=format

 net/dccp/ccid.c           | 2 +-
 net/tipc/netlink_compat.c | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

-- 
2.28.0

