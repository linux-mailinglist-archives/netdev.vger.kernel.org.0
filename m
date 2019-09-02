Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9AEEA50D7
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 10:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730053AbfIBIGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 04:06:12 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:60600 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbfIBIGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 04:06:11 -0400
Received: from reginn.horms.nl (watermunt.horms.nl [80.127.179.77])
        by kirsty.vergenet.net (Postfix) with ESMTPA id BDA2F25B784;
        Mon,  2 Sep 2019 18:06:07 +1000 (AEST)
Received: by reginn.horms.nl (Postfix, from userid 7100)
        id 2BA879401E6; Mon,  2 Sep 2019 10:06:05 +0200 (CEST)
From:   Simon Horman <horms+renesas@verge.net.au>
To:     David Miller <davem@davemloft.net>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc:     Magnus Damm <magnus.damm@gmail.com>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Simon Horman <horms+renesas@verge.net.au>
Subject: [net-next 0/3] ravb: Remove use of undocumented registers
Date:   Mon,  2 Sep 2019 10:06:00 +0200
Message-Id: <20190902080603.5636-1-horms+renesas@verge.net.au>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

this short series cleans up the RAVB driver a little.

The first patch corrects the spelling of the FBP field of SFO register.
This register field is unused and should have no run-time effect.

The remaining two patches remove the use of undocumented registers
after some consultation with the internal Renesas BSP team.

All patches have been lightly tested on:
* E3 Ebisu
* H3 Salvator-XS (ES2.0)
* M3-W Salvator-XS
* M3-N Salvator-XS

Kazuya Mizuguchi (2):
  ravb: correct typo in FBP field of SFO register
  ravb: Remove undocumented processing

Simon Horman (1):
  ravb: TROCR register is only present on R-Car Gen3

 drivers/net/ethernet/renesas/ravb.h      |  9 ++-------
 drivers/net/ethernet/renesas/ravb_main.c | 21 ++++-----------------
 2 files changed, 6 insertions(+), 24 deletions(-)

-- 
2.11.0

