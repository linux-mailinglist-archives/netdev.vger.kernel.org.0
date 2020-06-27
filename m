Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C88E420C4EC
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 01:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgF0X6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 19:58:14 -0400
Received: from mail-40133.protonmail.ch ([185.70.40.133]:34676 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbgF0X6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 19:58:14 -0400
Date:   Sat, 27 Jun 2020 23:58:09 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1593302291;
        bh=AZ63dorgq5Ez9IEahQeIrgu63FWAwPP2mgWYWJJbvmY=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=H/xFwflrlENQBflTcwfaoD8kenVZrb/3rh8TtfOIkoLWqXPOJmDnbtxF7JMJ8Tq7w
         K/yJ67vo4nzO6A/d6xj1qrBSQBAipS8HxOpn0TF8uW77RgeWryPm9VgasdMZytwMEi
         /VlClH9qkLoU6jkfaw2ktza2zlZI/daj/a6zKlxk=
To:     linux@armlinux.org.uk
From:   Colton Lewis <colton.w.lewis@protonmail.com>
Cc:     netdev@vger.kernel.org,
        Colton Lewis <colton.w.lewis@protonmail.com>
Reply-To: Colton Lewis <colton.w.lewis@protonmail.com>
Subject: [PATCH v3] net: phylink: correct trivial kernel-doc inconsistencies
Message-ID: <20200627235803.101718-1-colton.w.lewis@protonmail.com>
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

Silence documentation build warnings by correcting kernel-doc
comments. In the case of pcs_{config,an_restart,link_up}, change the
declaration to a normal function since these only there for
documentation anyway.

./include/linux/phylink.h:74: warning: Function parameter or member 'poll_f=
ixed_state' not described in 'phylink_config'
./include/linux/phylink.h:74: warning: Function parameter or member 'get_fi=
xed_state' not described in 'phylink_config'
./include/linux/phylink.h:336: warning: Function parameter or member 'pcs_c=
onfig' not described in 'int'
./include/linux/phylink.h:336: warning: Excess function parameter 'config' =
description in 'int'
./include/linux/phylink.h:336: warning: Excess function parameter 'mode' de=
scription in 'int'
./include/linux/phylink.h:336: warning: Excess function parameter 'interfac=
e' description in 'int'
./include/linux/phylink.h:336: warning: Excess function parameter 'advertis=
ing' description in 'int'
./include/linux/phylink.h:345: warning: Function parameter or member 'pcs_a=
n_restart' not described in 'void'
./include/linux/phylink.h:345: warning: Excess function parameter 'config' =
description in 'void'
./include/linux/phylink.h:361: warning: Function parameter or member 'pcs_l=
ink_up' not described in 'void'
./include/linux/phylink.h:361: warning: Excess function parameter 'config' =
description in 'void'
./include/linux/phylink.h:361: warning: Excess function parameter 'mode' de=
scription in 'void'
./include/linux/phylink.h:361: warning: Excess function parameter 'interfac=
e' description in 'void'
./include/linux/phylink.h:361: warning: Excess function parameter 'speed' d=
escription in 'void'
./include/linux/phylink.h:361: warning: Excess function parameter 'duplex' =
description in 'void'

Signed-off-by: Colton Lewis <colton.w.lewis@protonmail.com>
---
 include/linux/phylink.h | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index cc5b452a184e..24c52d9f63d6 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -62,6 +62,8 @@ enum phylink_op_type {
  * @dev: a pointer to a struct device associated with the MAC
  * @type: operation type of PHYLINK instance
  * @pcs_poll: MAC PCS cannot provide link change interrupt
+ * @poll_fixed_state: poll link state with @get_fixed_state
+ * @get_fixed_state: read link state into struct phylink_link_state
  */
 struct phylink_config {
 =09struct device *dev;
@@ -331,7 +333,7 @@ void pcs_get_state(struct phylink_config *config,
  *
  * For most 10GBASE-R, there is no advertisement.
  */
-int (*pcs_config)(struct phylink_config *config, unsigned int mode,
+int pcs_config(struct phylink_config *config, unsigned int mode,
 =09=09  phy_interface_t interface, const unsigned long *advertising);
=20
 /**
@@ -341,7 +343,7 @@ int (*pcs_config)(struct phylink_config *config, unsign=
ed int mode,
  * When PCS ops are present, this overrides mac_an_restart() in &struct
  * phylink_mac_ops.
  */
-void (*pcs_an_restart)(struct phylink_config *config);
+void pcs_an_restart(struct phylink_config *config);
=20
 /**
  * pcs_link_up() - program the PCS for the resolved link configuration
@@ -356,7 +358,7 @@ void (*pcs_an_restart)(struct phylink_config *config);
  * mode without in-band AN needs to be manually configured for the link
  * and duplex setting. Otherwise, this should be a no-op.
  */
-void (*pcs_link_up)(struct phylink_config *config, unsigned int mode,
+void pcs_link_up(struct phylink_config *config, unsigned int mode,
 =09=09    phy_interface_t interface, int speed, int duplex);
 #endif
=20
--=20
2.26.2


