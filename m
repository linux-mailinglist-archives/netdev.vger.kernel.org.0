Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA8829DBC9
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:13:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390830AbgJ2ANp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 20:13:45 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50728 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390758AbgJ2ANK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 20:13:10 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kXZEq-003tgb-Tq; Wed, 28 Oct 2020 01:22:52 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 0/2] net trigraph fixes for W=1
Date:   Wed, 28 Oct 2020 01:22:33 +0100
Message-Id: <20201028002235.928999-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both the Marvell mvneta and rose driver accidentally make use of a
trigraph. When compiling with W=1 an warning is issues because we have
trigraphs disabled. So for mvneta, which is only a diagnostic print,
remove the trigraph. For rose, since this is a sysfs file, escape the
sequence to make it clear it is not supposed to be trigraph.

Andrew Lunn (2):
  net: marvell: mvneta: Fix trigraph warning with W=1
  net: rose: Escape trigraph to fix warning with W=1

 drivers/net/ethernet/marvell/mvneta.c | 2 +-
 net/rose/af_rose.c                    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
2.28.0

