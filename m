Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4A562141A7
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 00:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbgGCWl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 18:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726427AbgGCWl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 18:41:28 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EBDCC08C5DD;
        Fri,  3 Jul 2020 15:41:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=xpaMHC1vD6dAuT3tv6oAvD/0zO3jL2xtR09updKR6To=; b=PQLd5Om79sruyolWkHmqhI7TL1
        D1PiUM3oe0ut/1blqmvdx1SKCHGvM5uqFb3o4NRrCWuoOxF9P0mYFiodGAU2dLflKvJMLR1Bn+AhY
        1nzU2PbTj0wH8BBJ+HG5lmrX09hQk4O1qVlIXh1bx1MX8wQtEn8vPVocdCNiFFcJfI69tLboUCuVj
        hEQNpbk4FO9P1JQdvsopsQ8VX/eUfndnS/ckGrwGPa8PEixWMHOyIkD82MuXdzvezFMAVWfdoyuP9
        rD8LTjCVZY7p0L4nwqW3+FqYcpHrW/j0vME0Cph4diQWz2m9gZbZYpAvSH+3FlRSlu2Cewj/6fwzf
        a4GrF+dQ==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jrUMy-0000A4-Bx; Fri, 03 Jul 2020 22:41:21 +0000
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
Subject: [PATCH 0/7] Documentation: networking: eliminate doubled words
Date:   Fri,  3 Jul 2020 15:41:08 -0700
Message-Id: <20200703224115.29769-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop all duplicated words in Documentation/networking/ files.

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-hams@vger.kernel.org
Cc: Wolfgang Grandegger <wg@grandegger.com>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: linux-can@vger.kernel.org
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Vivien Didelot <vivien.didelot@gmail.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: linux-afs@lists.infradead.org


 Documentation/networking/arcnet.rst            |    2 +-
 Documentation/networking/ax25.rst              |    2 +-
 Documentation/networking/can_ucan_protocol.rst |    4 ++--
 Documentation/networking/dsa/dsa.rst           |    2 +-
 Documentation/networking/ip-sysctl.rst         |    2 +-
 Documentation/networking/ipvs-sysctl.rst       |    2 +-
 Documentation/networking/rxrpc.rst             |    2 +-
 7 files changed, 8 insertions(+), 8 deletions(-)
