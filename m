Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B99FA2A123E
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 01:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726015AbgJaA6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 20:58:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55890 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgJaA6s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 20:58:48 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kYfEE-004Rqf-Tm; Sat, 31 Oct 2020 01:58:46 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 0/2] davicom W=1 fixes
Date:   Sat, 31 Oct 2020 01:58:31 +0100
Message-Id: <20201031005833.1060316-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixup various W=1 warnings, and then add COMPILE_TEST support, which
explains why these where missed on the previous pass.

Andrew Lunn (2):
  drivers: net: davicom: Fixed unused but set variable with W=1
  drivers: net: davicom Add COMPILE_TEST support

 drivers/net/ethernet/davicom/Kconfig  | 2 +-
 drivers/net/ethernet/davicom/dm9000.c | 9 +++------
 2 files changed, 4 insertions(+), 7 deletions(-)

-- 
2.28.0

