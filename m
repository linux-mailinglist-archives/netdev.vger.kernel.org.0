Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0488F5A5839
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 01:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbiH2XyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 19:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiH2XyY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 19:54:24 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65D8D247;
        Mon, 29 Aug 2022 16:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=BsB52UPkydFC8riflUpJ1euNmd4L7oOJVadavpq9VRI=; b=fqHXR03SSArbuxJXHVUXqLVxXg
        cqOrOk/GOjbFPsqTNVunCgdmfrsaHkJxN6AZ7U7AeoB8JuxlqxaYSc7M2nIXmeZRkHlWMrwKKo/PD
        avfJzhGqm3ad0BYdlVguIejKLgjnB2kB74ZwYmHWieLrLCty8aOsV5wk5mGsbE8bCP7wE78bl7QQt
        YEFvs2BSb8rQ5oVItkR+a1DYakziQraLBdPUhGzG7acQLKyrUiVkN5oGD9VFLxY/08ceNXahLj2bP
        gX5Qy1h5qTftOg4/MZwvI/qjww2x/BcYFQFH3i+CkuJIJqFSjCQV5811wEP8cEAO5jtTp8szCkZ8Z
        HmNdYaTQ==;
Received: from [2601:1c0:6280:3f0::a6b3] (helo=casper.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oSoaD-003WK3-3d; Mon, 29 Aug 2022 23:54:21 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-doc@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH] Documentation: networking: correct possessive "its"
Date:   Mon, 29 Aug 2022 16:54:14 -0700
Message-Id: <20220829235414.17110-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change occurrences of "it's" that are possessive to "its"
so that they don't read as "it is".

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org
Cc: Jiri Pirko <jiri@nvidia.com>
---
 Documentation/networking/devlink/netdevsim.rst |    2 +-
 Documentation/networking/driver.rst            |    2 +-
 Documentation/networking/ipvlan.rst            |    2 +-
 Documentation/networking/l2tp.rst              |    2 +-
 Documentation/networking/switchdev.rst         |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

--- a/Documentation/networking/devlink/netdevsim.rst
+++ b/Documentation/networking/devlink/netdevsim.rst
@@ -67,7 +67,7 @@ The ``netdevsim`` driver supports rate o
 - setting tx_share and tx_max rate values for any rate object type;
 - setting parent node for any rate object type.
 
-Rate nodes and it's parameters are exposed in ``netdevsim`` debugfs in RO mode.
+Rate nodes and their parameters are exposed in ``netdevsim`` debugfs in RO mode.
 For example created rate node with name ``some_group``:
 
 .. code:: shell
--- a/Documentation/networking/driver.rst
+++ b/Documentation/networking/driver.rst
@@ -8,7 +8,7 @@ Transmit path guidelines:
 
 1) The ndo_start_xmit method must not return NETDEV_TX_BUSY under
    any normal circumstances.  It is considered a hard error unless
-   there is no way your device can tell ahead of time when it's
+   there is no way your device can tell ahead of time when its
    transmit function will become busy.
 
    Instead it must maintain the queue properly.  For example,
--- a/Documentation/networking/ipvlan.rst
+++ b/Documentation/networking/ipvlan.rst
@@ -11,7 +11,7 @@ Initial Release:
 ================
 This is conceptually very similar to the macvlan driver with one major
 exception of using L3 for mux-ing /demux-ing among slaves. This property makes
-the master device share the L2 with it's slave devices. I have developed this
+the master device share the L2 with its slave devices. I have developed this
 driver in conjunction with network namespaces and not sure if there is use case
 outside of it.
 
--- a/Documentation/networking/l2tp.rst
+++ b/Documentation/networking/l2tp.rst
@@ -530,7 +530,7 @@ its tunnel close actions. For L2TPIP soc
 handler initiates the same tunnel close actions. All sessions are
 first closed. Each session drops its tunnel ref. When the tunnel ref
 reaches zero, the tunnel puts its socket ref. When the socket is
-eventually destroyed, it's sk_destruct finally frees the L2TP tunnel
+eventually destroyed, its sk_destruct finally frees the L2TP tunnel
 context.
 
 Sessions
--- a/Documentation/networking/switchdev.rst
+++ b/Documentation/networking/switchdev.rst
@@ -159,7 +159,7 @@ tools such as iproute2.
 
 The switchdev driver can know a particular port's position in the topology by
 monitoring NETDEV_CHANGEUPPER notifications.  For example, a port moved into a
-bond will see it's upper master change.  If that bond is moved into a bridge,
+bond will see its upper master change.  If that bond is moved into a bridge,
 the bond's upper master will change.  And so on.  The driver will track such
 movements to know what position a port is in in the overall topology by
 registering for netdevice events and acting on NETDEV_CHANGEUPPER.
