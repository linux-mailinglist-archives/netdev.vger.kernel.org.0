Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C69D45D491
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 07:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346725AbhKYGOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 01:14:01 -0500
Received: from pi.codeconstruct.com.au ([203.29.241.158]:57894 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345878AbhKYGMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 01:12:00 -0500
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id 156962022C; Thu, 25 Nov 2021 14:08:49 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH net-next v2 0/3] mctp serial minor fixes
Date:   Thu, 25 Nov 2021 14:07:36 +0800
Message-Id: <20211125060739.3023442-1-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We had a few minor fixes queued for a v4 of the original series, so
they're sent here as separate changes.

Cheers,


Jeremy

---
v2:
 - fix ordering of cancel_work vs. unregister_netdev.

Jeremy Kerr (3):
  mctp: serial: cancel tx work on ldisc close
  mctp: serial: enforce fixed MTU
  mctp: serial: remove unnecessary ldisc data check

 drivers/net/mctp/mctp-serial.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

-- 
2.30.2

