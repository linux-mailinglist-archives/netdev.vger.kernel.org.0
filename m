Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D359D23A769
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 15:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgHCNYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 09:24:37 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:46606 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726509AbgHCNYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 09:24:36 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from roid@mellanox.com)
        with SMTP; 3 Aug 2020 16:24:34 +0300
Received: from mtr-vdi-191.wap.labs.mlnx. (mtr-vdi-191.wap.labs.mlnx [10.209.100.28])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 073DOYhR012053;
        Mon, 3 Aug 2020 16:24:34 +0300
From:   Roi Dayan <roid@mellanox.com>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@mellanox.com>
Subject: [PATCH ethtool] ethtool.spec: Add bash completion script
Date:   Mon,  3 Aug 2020 16:23:38 +0300
Message-Id: <20200803132338.221961-1-roid@mellanox.com>
X-Mailer: git-send-email 2.8.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After the additon of the bash completion script, packaging
using the default spec file fails for installed but not packaged
error. so package it.

Fixes: 9b802643d7bd ("ethtool: Add bash-completion script")
Signed-off-by: Roi Dayan <roid@mellanox.com>
---
 ethtool.spec.in | 1 +
 1 file changed, 1 insertion(+)

diff --git a/ethtool.spec.in b/ethtool.spec.in
index 9c01b07abf2b..75f9be6aafa6 100644
--- a/ethtool.spec.in
+++ b/ethtool.spec.in
@@ -34,6 +34,7 @@ make install DESTDIR=${RPM_BUILD_ROOT}
 %defattr(-,root,root)
 %{_sbindir}/ethtool
 %{_mandir}/man8/ethtool.8*
+%{_datadir}/bash-completion/completions/ethtool
 %doc AUTHORS COPYING NEWS README
 
 
-- 
2.8.4

