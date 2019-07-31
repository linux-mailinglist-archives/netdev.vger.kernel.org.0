Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5067BB25
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 10:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbfGaIGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 04:06:17 -0400
Received: from smtp13.smtpout.orange.fr ([80.12.242.135]:33172 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725970AbfGaIGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 04:06:17 -0400
Received: from localhost.localdomain ([176.167.166.146])
        by mwinf5d75 with ME
        id jL6E2000e39qjAg03L6F0r; Wed, 31 Jul 2019 10:06:16 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Wed, 31 Jul 2019 10:06:16 +0200
X-ME-IP: 176.167.166.146
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     jcliburn@gmail.com, davem@davemloft.net, chris.snook@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 0/2] net: ag71xx: 2 small patches for 'ag71xx_rings_init()'
Date:   Wed, 31 Jul 2019 10:06:20 +0200
Message-Id: <cover.1564560130.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christophe JAILLET (2):
  net: ag71xx: Slighly simplify code in 'ag71xx_rings_init()'
  net: ag71xx: Use GFP_KERNEL instead of GFP_ATOMIC in
    'ag71xx_rings_init()'

 drivers/net/ethernet/atheros/ag71xx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
2.20.1

