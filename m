Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0D3225BDE
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 11:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728125AbgGTJk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 05:40:28 -0400
Received: from proxima.lasnet.de ([78.47.171.185]:45772 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727932AbgGTJk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 05:40:28 -0400
Received: from localhost.localdomain.datenfreihafen.local (p200300e9d7371614ec13d59c95910a08.dip0.t-ipconnect.de [IPv6:2003:e9:d737:1614:ec13:d59c:9591:a08])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@sostec.de)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 6061FC0476;
        Mon, 20 Jul 2020 11:40:26 +0200 (CEST)
From:   Stefan Schmidt <stefan@datenfreihafen.org>
To:     davem@davemloft.net
Cc:     linux-wpan@vger.kernel.org, alex.aring@gmail.com,
        netdev@vger.kernel.org
Subject: pull-request: ieee802154 for net 2020-07-20
Date:   Mon, 20 Jul 2020 11:40:09 +0200
Message-Id: <20200720094009.1807496-1-stefan@datenfreihafen.org>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hello Dave.

An update from ieee802154 for your *net* tree.

A potential memory leak fix for adf7242 from Liu Jian,
and one more HTTPS link change from Alexander A. Klimov.

regards
Stefan Schmidt

The following changes since commit 473309fb8372365ad211f425bca760af800e10a7:

  net: dp83640: fix SIOCSHWTSTAMP to update the struct with actual configuration (2020-07-16 13:27:40 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan.git tags/ieee802154-for-davem-2020-07-20

for you to fetch changes up to 19dc36548be2027cb5a491511bc152493c1244bb:

  net: ieee802154: adf7242: Replace HTTP links with HTTPS ones (2020-07-20 08:51:38 +0200)

----------------------------------------------------------------
Alexander A. Klimov (1):
      net: ieee802154: adf7242: Replace HTTP links with HTTPS ones

Liu Jian (1):
      ieee802154: fix one possible memleak in adf7242_probe

 drivers/net/ieee802154/adf7242.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)
