Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2222B454C
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 14:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729943AbgKPNzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 08:55:45 -0500
Received: from mxout70.expurgate.net ([194.37.255.70]:35679 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728717AbgKPNzo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 08:55:44 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1keeyp-0000EN-3c; Mon, 16 Nov 2020 14:55:39 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1keeyo-0000Dw-0h; Mon, 16 Nov 2020 14:55:38 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id 364FD240049;
        Mon, 16 Nov 2020 14:55:37 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id A99F1240047;
        Mon, 16 Nov 2020 14:55:36 +0100 (CET)
Received: from mschiller01.dev.tdt.de (unknown [10.2.3.20])
        by mail.dev.tdt.de (Postfix) with ESMTPSA id 76133200AE;
        Mon, 16 Nov 2020 14:55:36 +0100 (CET)
From:   Martin Schiller <ms@dev.tdt.de>
To:     andrew.hendry@gmail.com, davem@davemloft.net, kuba@kernel.org,
        xie.he.0141@gmail.com
Cc:     linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Martin Schiller <ms@dev.tdt.de>
Subject: [PATCH net-next v2 0/6] netdev event handling + neighbour config
Date:   Mon, 16 Nov 2020 14:55:16 +0100
Message-ID: <20201116135522.21791-1-ms@dev.tdt.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
Content-Transfer-Encoding: quoted-printable
X-purgate-type: clean
X-purgate-ID: 151534::1605534938-00000FB8-DD25A441/0/0
X-purgate: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin Schiller (6):
  net/x25: handle additional netdev events
  net/x25: make neighbour params configurable
  net/x25: replace x25_kill_by_device with x25_kill_by_neigh
  net/x25: support NETDEV_CHANGE notifier
  net/lapb: support netdev events
  net/lapb: fix t1 timer handling

 include/net/x25.h        |  10 +-
 include/uapi/linux/x25.h |  56 ++++++-----
 net/lapb/lapb_iface.c    |  83 ++++++++++++++++
 net/lapb/lapb_timer.c    |  11 ++-
 net/x25/af_x25.c         | 206 +++++++++++++++++++++++++++++++--------
 net/x25/x25_facilities.c |   6 +-
 net/x25/x25_link.c       | 142 +++++++++++++++++++++++----
 net/x25/x25_subr.c       |  22 ++++-
 8 files changed, 445 insertions(+), 91 deletions(-)

--=20
2.20.1

