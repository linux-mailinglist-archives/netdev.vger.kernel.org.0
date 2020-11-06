Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45B322A9BEB
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 19:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbgKFSWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 13:22:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbgKFSWD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 13:22:03 -0500
X-Greylist: delayed 301 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 06 Nov 2020 10:22:03 PST
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4ED7AC0613CF
        for <netdev@vger.kernel.org>; Fri,  6 Nov 2020 10:22:03 -0800 (PST)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 2C16F96EEA;
        Fri,  6 Nov 2020 18:17:01 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1604686621; bh=DYFXpORBTULzacEj2cQhsEnCmbQQcv24Sl3XrhYsESs=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20gnault@redhat.com,=0D=0A=09jchapman@katalix.com,=0D
         =0A=09Tom=20Parkin=20<tparkin@katalix.com>|Subject:=20[RFC=20PATCH
         =202/2]=20docs:=20update=20ppp_generic.rst=20to=20describe=20ioctl
         =20PPPIOCBRIDGECHAN|Date:=20Fri,=20=206=20Nov=202020=2018:16:47=20
         +0000|Message-Id:=20<20201106181647.16358-3-tparkin@katalix.com>|I
         n-Reply-To:=20<20201106181647.16358-1-tparkin@katalix.com>|Referen
         ces:=20<20201106181647.16358-1-tparkin@katalix.com>;
        b=uXy2FAyhSYxwvcg4TkjvaBxWKIWfW4UPsN4EW+PdC8ue/8L3u3oLLM0UuDhdznzWT
         7L/eOuyxNwceozhH11On89xq9iscj+wmZ9u1cTVS1x3UoI0oIV2FpbgzD9i/JeW5WK
         BeF/G1KHjoihFtTT+xJw4MOZ/skdCmcB//QkaFXkaSqXsSVj8uH8qGtCcjvaJsd7Eg
         WC1ia7kM0mZtqd05g8ACKR+5N/DKBIF8EUvB3dqFthfKMHLvO/bj4IJ0JD6aM9YLvc
         zcg1usu8x7kDs4EGry2twcOEH7A1aQfOkxqRpt5+ko0K1iJL+JIm6TCOb7COCCBrLg
         RwjSJ8RzgEvxA==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     gnault@redhat.com, jchapman@katalix.com,
        Tom Parkin <tparkin@katalix.com>
Subject: [RFC PATCH 2/2] docs: update ppp_generic.rst to describe ioctl PPPIOCBRIDGECHAN
Date:   Fri,  6 Nov 2020 18:16:47 +0000
Message-Id: <20201106181647.16358-3-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201106181647.16358-1-tparkin@katalix.com>
References: <20201106181647.16358-1-tparkin@katalix.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

---
 Documentation/networking/ppp_generic.rst | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/networking/ppp_generic.rst b/Documentation/networking/ppp_generic.rst
index e60504377900..aea950ce953f 100644
--- a/Documentation/networking/ppp_generic.rst
+++ b/Documentation/networking/ppp_generic.rst
@@ -314,6 +314,11 @@ channel are:
   it is connected to.  It will return an EINVAL error if the channel
   is not connected to an interface.
 
+* PPPIOCBRIDGECHAN bridges a channel with another.  When frames are
+  presented to a channel by a call to ppp_input, they are passed to the
+  bridged channel by appending them to the channel's transmit queue.
+  This allows frames from one channel to be switched into another.
+
 * All other ioctl commands are passed to the channel ioctl() function.
 
 The ioctl calls that are available on an instance that is attached to
-- 
2.17.1

