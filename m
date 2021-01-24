Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94B50301D0E
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 16:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbhAXPNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 10:13:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21011 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726487AbhAXPLC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 10:11:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611500972;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=AkBGm8p0fa4rt1PI1coAbw65Fn4m5HoJaXKXxd+BTEc=;
        b=b9fAFLXMSOkPd9Xjijt04qDItG38VWRCGZoz7rFR/j3YEOHaQJOUWIh6T3E1vb2oOjKWBt
        Fl6SJOfZ3RPaH8f5R8avTPkXahCbFqKQDRzlJz14TDQnK/4nNC2hLePsVTWYp10wyN3Vdb
        Vx1yZjZ+7PghLsSDq47GneHKFE18Y70=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-257-9A4vUXmMOlaEbiJEryQxtg-1; Sun, 24 Jan 2021 10:09:30 -0500
X-MC-Unique: 9A4vUXmMOlaEbiJEryQxtg-1
Received: by mail-qv1-f72.google.com with SMTP id z8so5465060qva.23
        for <netdev@vger.kernel.org>; Sun, 24 Jan 2021 07:09:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AkBGm8p0fa4rt1PI1coAbw65Fn4m5HoJaXKXxd+BTEc=;
        b=mU34Jek64MdK4qsi3F+8NUbbZAG3FemxGBsSl4ZsH2K0HeHlvYeRCue1TkGCuUFM6r
         bo8DRHw33ERJU5WD2/eEvUSQMr82fc69/sjmkSRW5f/T2BVN1w49hOcqTsYrdy7Z711l
         Nhu9RU7EjuPfvGUSKEFS02VwbwLRyXEwABi7RrhJ7A++2mWY4HPj8euYHtG8ninq0N3K
         H/8lCaMWlyCloPEAo/h6ON3XzjzVwddwDbxwlC3siCTKKkPz/KZXDjDvM7qA4+Kdm/1Q
         MrqXmdDAfnd9n3D10P7emL4k/RpJxt242ZIgIAOrMPsIZr8UWIZTH45JPHtB10p/kjXX
         oQpw==
X-Gm-Message-State: AOAM5300TLWubJ5J/IgKPr5zgvrtHwQndBZax3L6eqvsv4lyV9gb2K2f
        dUWIMrDCtBlGhz8I3kN1+5151quVC064Y76J7A32hrB+n7F2b/f9zuckc98ArWxjvqqzTTgwnrb
        cnp+O3B5p1ra/cUBx
X-Received: by 2002:ac8:1184:: with SMTP id d4mr83457qtj.103.1611500970478;
        Sun, 24 Jan 2021 07:09:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzYBBg29MiCtXTRNQOAOd6nYAfAuayesoZV2Aq69NRiMptaO6XUCaf/fW9Xmoeh1PweXRp35Q==
X-Received: by 2002:ac8:1184:: with SMTP id d4mr83442qtj.103.1611500970318;
        Sun, 24 Jan 2021 07:09:30 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id v12sm2556362qkg.63.2021.01.24.07.09.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jan 2021 07:09:29 -0800 (PST)
From:   trix@redhat.com
To:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        kuba@kernel.org, socketcan@hartkopp.net, colin.king@canonical.com
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: [PATCH] can: mcba_usb: remove h from printk format specifier
Date:   Sun, 24 Jan 2021 07:09:16 -0800
Message-Id: <20210124150916.1920434-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

This change fixes the checkpatch warning described in this commit
commit cbacb5ab0aa0 ("docs: printk-formats: Stop encouraging use of
  unnecessary %h[xudi] and %hh[xudi]")

Standard integer promotion is already done and %hx and %hhx is useless
so do not encourage the use of %hh[xudi] or %h[xudi].

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/can/usb/mcba_usb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/usb/mcba_usb.c b/drivers/net/can/usb/mcba_usb.c
index df54eb7d4b36..dc79c050f5f7 100644
--- a/drivers/net/can/usb/mcba_usb.c
+++ b/drivers/net/can/usb/mcba_usb.c
@@ -466,7 +466,7 @@ static void mcba_usb_process_ka_usb(struct mcba_priv *priv,
 				    struct mcba_usb_msg_ka_usb *msg)
 {
 	if (unlikely(priv->usb_ka_first_pass)) {
-		netdev_info(priv->netdev, "PIC USB version %hhu.%hhu\n",
+		netdev_info(priv->netdev, "PIC USB version %u.%u\n",
 			    msg->soft_ver_major, msg->soft_ver_minor);
 
 		priv->usb_ka_first_pass = false;
@@ -492,7 +492,7 @@ static void mcba_usb_process_ka_can(struct mcba_priv *priv,
 				    struct mcba_usb_msg_ka_can *msg)
 {
 	if (unlikely(priv->can_ka_first_pass)) {
-		netdev_info(priv->netdev, "PIC CAN version %hhu.%hhu\n",
+		netdev_info(priv->netdev, "PIC CAN version %u.%u\n",
 			    msg->soft_ver_major, msg->soft_ver_minor);
 
 		priv->can_ka_first_pass = false;
@@ -554,7 +554,7 @@ static void mcba_usb_process_rx(struct mcba_priv *priv,
 		break;
 
 	default:
-		netdev_warn(priv->netdev, "Unsupported msg (0x%hhX)",
+		netdev_warn(priv->netdev, "Unsupported msg (0x%X)",
 			    msg->cmd_id);
 		break;
 	}
-- 
2.27.0

