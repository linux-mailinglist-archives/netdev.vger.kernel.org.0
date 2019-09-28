Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 787CEC101F
	for <lists+netdev@lfdr.de>; Sat, 28 Sep 2019 09:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbfI1H5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Sep 2019 03:57:46 -0400
Received: from proxima.lasnet.de ([78.47.171.185]:52537 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726373AbfI1H5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Sep 2019 03:57:46 -0400
Received: from localhost.localdomain (p200300E9D742D296A393C26E681B47E6.dip0.t-ipconnect.de [IPv6:2003:e9:d742:d296:a393:c26e:681b:47e6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@sostec.de)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 2CF2BC1B7C;
        Sat, 28 Sep 2019 09:57:44 +0200 (CEST)
From:   Stefan Schmidt <stefan@datenfreihafen.org>
To:     davem@davemloft.net
Cc:     linux-wpan@vger.kernel.org, alex.aring@gmail.com,
        netdev@vger.kernel.org
Subject: pull-request: ieee802154 for net 2019-09-28
Date:   Sat, 28 Sep 2019 09:57:37 +0200
Message-Id: <20190928075737.28132-1-stefan@datenfreihafen.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Dave.

An update from ieee802154 for your *net* tree.

Three driver fixes. Navid Emamdoost fixed a memory leak on an error
path in the ca8210 driver, Johan Hovold fixed a use-after-free found
by syzbot in the atusb driver and Christophe JAILLET makes sure
__skb_put_data is used instead of memcpy in the mcr20a driver

I switched from branches to tags here to be pulled from. So far not
annotated and not signed. Once I fixed my scripts it should contain
this messages as annotations. If you want it signed as well just tell
me. If there are any problems let me know.

regards
Stefan Schmidt

The following changes since commit f53a7ad189594a112167efaf17ea8d0242b5ac00:

  r8152: Set memory to all 0xFFs on failed reg reads (2019-08-25 19:52:59 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan.git tags/ieee802154-for-davem-2019-09-28

for you to fetch changes up to 6402939ec86eaf226c8b8ae00ed983936b164908:

  ieee802154: ca8210: prevent memory leak (2019-09-27 21:57:42 +0200)

----------------------------------------------------------------
Christophe JAILLET (1):
      ieee802154: mcr20a: simplify a bit 'mcr20a_handle_rx_read_buf_complete()'

Johan Hovold (1):
      ieee802154: atusb: fix use-after-free at disconnect

Navid Emamdoost (1):
      ieee802154: ca8210: prevent memory leak

 drivers/net/ieee802154/atusb.c  | 3 ++-
 drivers/net/ieee802154/ca8210.c | 2 +-
 drivers/net/ieee802154/mcr20a.c | 2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)
