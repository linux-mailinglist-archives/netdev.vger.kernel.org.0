Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C99A845A348
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 13:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236505AbhKWMyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 07:54:16 -0500
Received: from pi.codeconstruct.com.au ([203.29.241.158]:55700 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235080AbhKWMyP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 07:54:15 -0500
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id B07B42022C; Tue, 23 Nov 2021 20:51:06 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     Jiri Slaby <jirislaby@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/3] mctp serial minor fixes
Date:   Tue, 23 Nov 2021 20:50:39 +0800
Message-Id: <20211123125042.2564114-1-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We had a few minor fixes queued for a v4 of the original series, so
they're sent here as separate changes.

Cheers,


Jeremy

Jeremy Kerr (3):
  mctp: serial: cancel tx work on ldisc close
  mctp: serial: enforce fixed MTU
  mctp: serial: remove unnecessary ldisc data check

 drivers/net/mctp/mctp-serial.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

-- 
2.33.0

