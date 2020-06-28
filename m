Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56B3420CAC5
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 23:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgF1Vjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 17:39:42 -0400
Received: from mail-40136.protonmail.ch ([185.70.40.136]:25434 "EHLO
        mail-40136.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726188AbgF1Vjm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 17:39:42 -0400
Date:   Sun, 28 Jun 2020 21:39:38 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1593380380;
        bh=A+f3FHAixuOpth56vJ/0YcOYxJzSe8XBooG6LYoJkIE=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=sWRCbXZ9LMVBYDaYjfVuKmcI7c4jOgo14cbEcxsPXWrGtMsYklHXsZ5e4+iECz81f
         wXlIlkeRrEGldq/tPMptpx29RGGuU3FXjmgtsi8Pvq8A2duSWjOvm6taJEbhwum5CX
         oA6FlnwzUk8nBgjR3Yr4jhHHFricTBi/FybFcUSE=
To:     linux@armlinux.org.uk
From:   Colton Lewis <colton.w.lewis@protonmail.com>
Cc:     netdev@vger.kernel.org,
        Colton Lewis <colton.w.lewis@protonmail.com>
Reply-To: Colton Lewis <colton.w.lewis@protonmail.com>
Subject: [PATCH v4 2/2] net: core: correct trivial kernel-doc inconsistencies
Message-ID: <20200628213912.116330-2-colton.w.lewis@protonmail.com>
In-Reply-To: <3034206.AJdgDx1Vlc@laptop.coltonlewis.name>
References: <20200621154248.GB338481@lunn.ch> <20200621155345.GV1551@shell.armlinux.org.uk> <3315816.iIbC2pHGDl@laptop.coltonlewis.name> <20200621234431.GZ1551@shell.armlinux.org.uk> <3034206.AJdgDx1Vlc@laptop.coltonlewis.name>
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


