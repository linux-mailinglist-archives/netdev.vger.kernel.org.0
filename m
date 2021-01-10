Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E69342F0749
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 13:44:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbhAJMnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 07:43:52 -0500
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:26078 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726590AbhAJMnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 07:43:51 -0500
Received: from localhost.localdomain ([153.202.107.157])
        by mwinf5d13 with ME
        id F0hm240043PnFJp030i2yL; Sun, 10 Jan 2021 13:42:07 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Sun, 10 Jan 2021 13:42:07 +0100
X-ME-IP: 153.202.107.157
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        Jeroen Hofstee <jhofstee@victronenergy.com>
Cc:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 0/1] Add software TX timestamps to the CAN devices
Date:   Sun, 10 Jan 2021 21:41:30 +0900
Message-Id: <20210110124132.109326-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the ongoing work to add BQL to Socket CAN, I figured out that it
would be nice to have an easy way to mesure the latency.

And one easy way to do so it to check the round trip time of the
packet by doing the difference between the software rx timestamp and
the software tx timestamp.

rx timestamps are already available. This patch gives the missing
piece: add a tx software timestamp feature to the CAN devices.

Of course, the tx software timestamp might also be used for other
purposes such as performance measurements of the different queuing
disciplines (e.g. by checking the difference between the kernel tx
software timestamp and the userland tx software timestamp).

v2 reflects the comments that Jeroen made in
https://lkml.org/lkml/2021/1/10/54

Vincent Mailhol (1):
  can: dev: add software tx timestamps

 drivers/net/can/dev.c | 2 ++
 1 file changed, 2 insertions(+)

-- 
2.26.2

