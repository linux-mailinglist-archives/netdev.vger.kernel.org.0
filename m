Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B93602141A4
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 00:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbgGCWlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 18:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726427AbgGCWle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 18:41:34 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB9FC061794;
        Fri,  3 Jul 2020 15:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=vn4H9ZRRvy1xw40/odYzWeme/b0wkapBn1J0rQxksLc=; b=fec9n2eKp6svVtuNJ8PB6rVDmw
        qaDfdStR7cvYkT35epYE4NhVRAEy7pzSeSrkjXnOPfFlpHkeWBJnq8JMs22GQKT6Dah69VtA3AXSs
        x0tmm6B1Msqz/u2NAaHIn4AqHsvNFAUZcbVTHdTLDpU6JXDh8KV8r1YgN/epOP1H6/8+5zQ4r+Xg8
        EcJ4E0klmlfJNjQ3G7wj1BbSbSVuGnpTAGwnO8GjvgcBHOrtYXd4BLXLYdGmEmLQWdUw808afg0LC
        6VVk5CEAk2yb4nY4YRNzD2jrkXOMgTsPp1MEYqNB964lLrj6p/t0wmEzrrC/Via5PIgROrH+zrUdu
        wVUGek/Q==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jrUN9-0000A4-Ur; Fri, 03 Jul 2020 22:41:32 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>, linux-hams@vger.kernel.org,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Howells <dhowells@redhat.com>,
        linux-afs@lists.infradead.org
Subject: [PATCH 3/7] Documentation: networking: can_ucan_protocol: drop doubled words
Date:   Fri,  3 Jul 2020 15:41:11 -0700
Message-Id: <20200703224115.29769-4-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200703224115.29769-1-rdunlap@infradead.org>
References: <20200703224115.29769-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop the doubled words "the" and "of".

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Cc: Wolfgang Grandegger <wg@grandegger.com>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: linux-can@vger.kernel.org
---
 Documentation/networking/can_ucan_protocol.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20200701.orig/Documentation/networking/can_ucan_protocol.rst
+++ linux-next-20200701/Documentation/networking/can_ucan_protocol.rst
@@ -144,7 +144,7 @@ UCAN_COMMAND_SET_BITTIMING
 
 *Host2Dev; mandatory*
 
-Setup bittiming by sending the the structure
+Setup bittiming by sending the structure
 ``ucan_ctl_payload_t.cmd_set_bittiming`` (see ``struct bittiming`` for
 details)
 
@@ -232,7 +232,7 @@ UCAN_IN_TX_COMPLETE
   zero
 
 The CAN device has sent a message to the CAN bus. It answers with a
-list of of tuples <echo-ids, flags>.
+list of tuples <echo-ids, flags>.
 
 The echo-id identifies the frame from (echos the id from a previous
 UCAN_OUT_TX message). The flag indicates the result of the
