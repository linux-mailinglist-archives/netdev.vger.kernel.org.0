Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D831F2027FD
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 04:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729180AbgFUCbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 22:31:38 -0400
Received: from mail-40133.protonmail.ch ([185.70.40.133]:57274 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729075AbgFUCbi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 22:31:38 -0400
X-Greylist: delayed 520 seconds by postgrey-1.27 at vger.kernel.org; Sat, 20 Jun 2020 22:31:37 EDT
Date:   Sun, 21 Jun 2020 02:22:52 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1592706176;
        bh=A+f3FHAixuOpth56vJ/0YcOYxJzSe8XBooG6LYoJkIE=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=elVU/9cWmCxb3uo1DiiQCKsaPYDYt4/vq7tj0e9iXI0pDIkwAQw1pyTmEaAtZXuKq
         Ou/ASsUUnDkcS07uA34kanofCWjyuttzqzAE2G4vFQbhEWSDTOg3yzqA4Iqum1ZIwE
         MmfB5/sV16/GwS8coVNnyEfwMCK3tCeXcoyPLWkI=
To:     davem@davemloft.net
From:   Colton Lewis <colton.w.lewis@protonmail.com>
Cc:     netdev@vger.kernel.org,
        Colton Lewis <colton.w.lewis@protonmail.com>
Reply-To: Colton Lewis <colton.w.lewis@protonmail.com>
Subject: [PATCH 2/3] net: core: correct trivial kernel-doc inconsistencies
Message-ID: <20200621022209.11814-3-colton.w.lewis@protonmail.com>
In-Reply-To: <20200621022209.11814-1-colton.w.lewis@protonmail.com>
References: <20200621022209.11814-1-colton.w.lewis@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=7.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on mail.protonmail.ch
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Silence documentation build warnings by correcting kernel-doc comments.

./include/linux/netdevice.h:2138: warning: Function parameter or member 'na=
pi_defer_hard_irqs' not described in 'net_device'

Signed-off-by: Colton Lewis <colton.w.lewis@protonmail.com>
---
 include/linux/netdevice.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 6fc613ed8eae..515791a9b299 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1742,6 +1742,7 @@ enum netdev_priv_flags {
  *=09@real_num_rx_queues: =09Number of RX queues currently active in devic=
e
  *=09@xdp_prog:=09=09XDP sockets filter program pointer
  *=09@gro_flush_timeout:=09timeout for GRO layer in NAPI
+ *=09@napi_defer_hard_irqs:=09count of deferred hardware interrupt request=
s
  *
  *=09@rx_handler:=09=09handler for received packets
  *=09@rx_handler_data: =09XXX: need comments on this one
--=20
2.26.2


