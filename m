Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B00A562728D
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 21:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235515AbiKMUee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 15:34:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235576AbiKMUeZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 15:34:25 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 335D813EBA;
        Sun, 13 Nov 2022 12:34:08 -0800 (PST)
Message-ID: <20221113202428.697888905@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1668371646;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=eJNcyge3ZPQEoc+qx3yEUXe0nyamCH265ttaV9WAT9s=;
        b=u17nhFcK73Hi/1m1E5b0SgS80ToQHGSjtnT20SMhzieIoRhK+gP5kwkqNAgzDeTlY0yNkv
        xsMHVHCvYrBFJV5jho8Tmzb0aR+yWgCnkYdymcdY1ByLO4W2LvqtIA0bYUJFWJELLaZrLa
        Ya4JPqOhJJ7KY//CmydGebpowZ054LXhxTE/xMkVVn6dW6i03HiJ/gQLRD5MfgN3vMcC7f
        Pnz4uh1yE9B6/ChZLODfcJG3bR30L65WO9zeSjEOGHWgXD8RQfCIgqe7FORJTMZ7cjo7jJ
        VNXhp9G/is7HueAq6+oewujb5FMQWg6CicB4OwU2yShw4jBL1SP840A6CoSTjA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1668371646;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=eJNcyge3ZPQEoc+qx3yEUXe0nyamCH265ttaV9WAT9s=;
        b=x4oxru4uVlHhsL/5+JhDPeHD8mDyrs2n85CDrzC2GwXCDGlduqdK6wmloqLgWXZnQ9Jbge
        CeikEzZn14iTyUAA==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Marc Zyngier <maz@kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, oss-drivers@corigine.com,
        netdev@vger.kernel.org
Subject: [patch 07/10] net: nfp: Remove linux/msi.h includes
References: <20221113201935.776707081@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Sun, 13 Nov 2022 21:34:05 +0100 (CET)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nothing in these files needs anything from linux/msi.h

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Simon Horman <simon.horman@corigine.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: oss-drivers@corigine.com
Cc: netdev@vger.kernel.org
---
 drivers/net/ethernet/netronome/nfp/nfp_main.h       |    1 -
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c |    1 -
 drivers/net/ethernet/netronome/nfp/nfp_net_main.c   |    1 -
 3 files changed, 3 deletions(-)

--- a/drivers/net/ethernet/netronome/nfp/nfp_main.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_main.h
@@ -12,7 +12,6 @@
 #include <linux/ethtool.h>
 #include <linux/list.h>
 #include <linux/types.h>
-#include <linux/msi.h>
 #include <linux/pci.h>
 #include <linux/workqueue.h>
 #include <net/devlink.h>
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -27,7 +27,6 @@
 #include <linux/page_ref.h>
 #include <linux/pci.h>
 #include <linux/pci_regs.h>
-#include <linux/msi.h>
 #include <linux/ethtool.h>
 #include <linux/log2.h>
 #include <linux/if_vlan.h>
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
@@ -16,7 +16,6 @@
 #include <linux/lockdep.h>
 #include <linux/pci.h>
 #include <linux/pci_regs.h>
-#include <linux/msi.h>
 #include <linux/random.h>
 #include <linux/rtnetlink.h>
 

